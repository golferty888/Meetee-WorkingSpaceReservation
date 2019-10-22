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

const facility = require("./controllers/query/facility");
const equipment = require("./controllers/query/equipment");
const facStatus = require("./controllers/query/facilityStatus");
const user = require("./controllers/query/user");
const reservation = require("./controllers/query/reservation");
const test = require("./controllers/query/test");
const iot = require("./controllers/query/iot");

const login = require("./controllers/middleware/login");
const signup = require("./controllers/middleware/signup");
const reserve = require("./controllers/middleware/reserve");
const iotActivate = require("./controllers/middleware/iotActivate");
app.post("/signup", signup.middleware, user.signup);
app.post("/login", login.middleware, user.login);
app.post(
  "/activate",
  requireJWTAuth,
  iotActivate.middleware,
  iot.activateIotEquipment
);

// Rest API
// Getting Room/Seat Information
app.get("/fac", facility.getAllFacility);
app.get("/fac/type/:id", facility.getFacilityCategoriesFromType);
app.get("/fac/cate/:id", equipment.getFacilityCategoryDetail);
// Checking Room/Seat Status
app.post(
  "/facility/cate/status/av",
  facStatus.checkStatusAvaialableEachFacilityCategory
);
app.post("/facility/cate/status", facStatus.checkStatusEachFacilityCategory);
// app.post("/facility/type/status", facStatus.checkStatusEachFacilityType);
// app.post("/facility/all/status", facStatus.checkStatusAllFacilities);
// Do Reserve Room/Seat
app.post("/reserve", reserve.middleWare, reservation.reserve);
// app.post("/reserve", reserve.middleWare, test.reserve);
// Reservation Information
app.post("/user/history", user.getReservationHistoryList);
app.get("/reservations", reservation.getAllReservations);
// Test PG
app.post("/test", facStatus.getAvaialableFacWithAmount);
// app.post("/testreserve", reservation.testReserve);

app.get("/", requireJWTAuth, (request, response) => {
  response.send("MeeteeAPI welcome!");
});

app.use("*", function(request, response) {
  response.status(404).send("404, Not found");
});

app.use((err, req, res, next) => {
  handlerError(err, res);
});

// Postgres Client Connections
console.log(pgConnectionString);
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
    ws.send("Websocket: reservation_table is updated.");
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
