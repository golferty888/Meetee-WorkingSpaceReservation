const dotenv = require("dotenv").config();
const express = require("express");
const pg = require("pg");
var http = require("http");
const bodyParser = require("body-parser");
const cors = require("cors");
const { Pool } = require("pg");
const pgConnectionString = process.env.POSTGRES_CONNECTION_URL;
const pool = new Pool({
  connectionString: pgConnectionString
});
const { handlerError, ErrorHandler } = require("./helpers/error");
const ExtractJwt = require("passport-jwt").ExtractJwt;
const JwtStrategy = require("passport-jwt").Strategy;
const jwtOptions = {
  jwtFromRequest: ExtractJwt.fromHeader("authorization"),
  secretOrKey: process.env.SECRET
};
const jwtAuth = new JwtStrategy(jwtOptions, async (payload, done) => {
  const statement = `select * from meeteenew.users where username = $1`;
  const value = [payload.sub];
  console.log(payload.sub);
  const userData = await pool.query(statement, value);
  if (userData.rowCount == 1) {
    done(null, true);
  } else {
    done(null, false);
  }
});
const passport = require("passport");
passport.use(jwtAuth);
const requireJWTAuth = passport.authenticate("jwt", { session: false });

const PORT = process.env.PORT || 9000;
const URL = process.env.URL;

const app = express();
const server = http.createServer(app);

app.use(
  bodyParser.urlencoded({
    extended: false
  })
);
app.use(bodyParser.json());
app.use(
  cors({
    origin: true
  })
);

const facDetail = require("./controllers/query/facilityDetail");
const equipment = require("./controllers/query/equipment");
const facStatus = require("./controllers/query/facilityStatus");
const user = require("./controllers/query/user");
const reservation = require("./controllers/query/reservation");
const iotQuery = require("./controllers/query/iot");
const iot = require("./controllers/iot/iotActivate");
const del = require("./controllers/query/deleteForTest");

const login = require("./controllers/middleware/login");
const signup = require("./controllers/middleware/signup");
const reserve = require("./controllers/middleware/reserve");
const iotActivate = require("./controllers/middleware/iotActivate");
const consl = require("./controllers/middleware/console");
app.post("/signup", consl.req, signup.middleware, user.signup);
app.post("/login", consl.req, login.middleware, user.login);
app.post(
  "/activate",
  consl.req,
  requireJWTAuth,
  iotActivate.middleware,
  iot.activateIotEquipment
);

// Rest API
// Getting Room/Seat Information
app.get("/fac", consl.req, facDetail.getAllFacility);
app.get("/fac/type/:id", consl.req, facDetail.getFacilityCategoriesFromType);
app.get("/fac/cate/:id", consl.req, equipment.getFacilityCategoryDetail);
// Checking Room/Seat Status
app.post("/facility/type/status/av", consl.req, facStatus.checkStatusAvaialableAllCategories);
app.post(
  "/facility/cate/status/av",
  consl.req,
  facStatus.checkStatusAvaialableEachFacilityCategory
);
app.post(
  "/facility/cate/status",
  consl.req,
  facStatus.checkStatusEachFacilityCategory
);
app.post(
  "/facility/pending/lock",
  consl.req,
  facStatus.lockAndUnlockPendingFacilityInSpecificPeriod
);
app.post(
  "/facility/pending/unlock",
  consl.req,
  facStatus.lockAndUnlockPendingFacilityInSpecificPeriod
);
// Do Reserve Room/Seat
app.post("/reserve", consl.req, reserve.middleWare, reservation.reserve);
// Reservation Information
app.post("/user/history", consl.req, user.getReservationHistoryList);
app.post(
  "/user/history/upcoming",
  consl.req,
  user.getUpcomingAndIntimeReservation
);
app.get("/reservations", consl.req, reservation.getAllReservations);
// User Information for Admin
app.get("/users", consl.req, user.getAllUsers);
app.get("/userx", consl.req, user.getAllUsers);
// Test PG
app.post("/activate/initial", consl.req, iotQuery.getStartTimeForActivation);
// app.post("/testreserve", reservation.testReserve);
app.delete("/delete", consl.req, del.userAndReservation);

app.get("/", consl.req, requireJWTAuth, (request, response) => {
  response.send("MeeteeAPI welcome!");
});

app.use("*", (request, response) => {
  response.status(404).send("404, Not found");
});

app.use((err, req, res, next) => {
  handlerError(err, res);
});

// Postgres Client Connections
const pgClient1 = new pg.Client(pgConnectionString);
const pgClient2 = new pg.Client(pgConnectionString);
pgClient1.connect();
pgClient2.connect();

const query1 = pgClient1.query("LISTEN events");
const query2 = pgClient2.query("LISTEN events");

// Socket.io and WebSocket Connections
const io = require("socket.io")(server);
const WebSocket = require("ws");

const wss = new WebSocket.Server({
  server: server,
  port: 9001
});

io.on("connection", socket => {
  console.log("userId: " + socket.id + " connected.");
  socket.emit("test_connection", "Socket.io: socket is connected.");

  socket.on("disconnect", socket => {
    console.log("!userId: " + socket.id + " disconnected.");
  });
});

wss.on("open", function open() {
  console.log("connected");
  wss.send(Date.now());
});

pgClient1.on("notification", async data => {
  const payload = data.payload;
  console.log("data.payload1: , " + data.payload);
  io.sockets.emit("reservation_trigger", "reservation_table is updated.");
});

wss.on("connection", ws => {
  ws.send("Websocket: websocket is connected.");
  ws.on("message", message => {
    console.log(`Receive message => ${message}`);
  });
  pgClient2.on("notification", async data => {
    console.log("PG Notification in Websocket!!!!");
    const payload = data.payload;
    ws.send("Websocket: reservation_table/pending_facility_table is updated.");
  });
});

server.listen(PORT, URL, () => {
  console.log(
    `✔ Listening on PORT: ${server.address().port} > ${
      process.env.NODE_ENV
    } > ${server.address().address}`
  );
});

server.on("upgrade", function(req, socket) {
  if (req.headers["upgrade"] !== "websocket") {
    socket.end("HTTP/1.1 400 Bad Request");
    return;
  }
  const acceptKey = req.headers["sec-websocket-key"];
  console.log("acceptKey: " + acceptKey);
  // Read the websocket key provided by the client: const acceptKey = req.headers['sec-websocket-key'];
  // Generate the response value to use in the response: const hash = generateAcceptValue(acceptKey);
  // Write the HTTP response into an array of response lines: const responseHeaders = [ 'HTTP/1.1 101 Web Socket Protocol Handshake', 'Upgrade: WebSocket', 'Connection: Upgrade', `Sec-WebSocket-Accept: ${hash}` ]; // Write the response back to the client socket, being sure to append two // additional newlines so that the browser recognises the end of the response // header and doesn't continue to wait for more header data: socket.write(responseHeaders.join('\r\n') + '\r\n\r\n');
});
