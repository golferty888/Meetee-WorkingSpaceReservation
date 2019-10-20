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
const iot = require("./controllers/query/iot");
// Rest API
// Getting Room/Seat Information
app.get("/fac", facility.getAllFacility);
app.get("/fac/type/:id", facility.getFacilityCategoriesFromType);
app.get("/fac/type/:id/detail", equipment.getFacilityCategoryDetail);
// Checking Room/Seat Status
app.post("/facility/cate/status", facStatus.checkStatusEachFacilityCategory);
app.post(
  "/facility/cate/status/av",
  facStatus.checkStatusAvaialableEachFacilityCategory
);
app.post("/facility/class/status", facStatus.checkStatusEachFacilityClass);
app.post("/facility/all/status", facStatus.checkStatusAllFacilities);
// Do Reserve Room/Seat
// app.post("/reserve", reservation.reserve);
app.post("/reserve", reservation.reserve);
// Reservation Information
app.post("/user/history", user.getReservationHistoryList);
app.get("/reservations", reservation.getAllReservations);
// Test PG
app.post("/test", facStatus.getAvaialableFacWithAmount);

const iotActivateMiddleWare = (request, response, next) => {
  const userName = request.body.username;
  // const reservId = request.body.reservId;
  const queryText = `select reservId, array_agg(json_build_object('facCode', code, 'floor', floor)) as facList 
    from meeteenew.view_user_history
    where username = $1 and ((NOW() ::timestamp, NOW() ::timestamp) overlaps (start_time, end_time))
    group by reservId`;
  const queryValues = [userName];
  pool.query(queryText, queryValues, (error, results) => {
    if (error) {
      response.status(500).send("Database Error");
    } else if (results.rowCount == 0) {
      response.status(400).send("Bad Request");
    } else {
      const facCodeList = [];
      results.rows.forEach(element => {
        element.faclist.forEach(facItem => {
          facCodeList.push(facItem.facCode);
        });
      });
      request.facCodeList = facCodeList;
      next();
    }
  });
  //รับ request {Header: jwt-token} {username: string, reservId: int}
  //เช็คเวลาที่จองไป query to get date and time-period เพื่อเทียบกับ now() ว่า overlaps กันหรือไม่
  //true=>next() false=>400 Bad Request
};
app.post("/activate", iotActivateMiddleWare, iot.activateIotEquipment);

app.get("/", (request, response) => {
  response.send("MeeteeAPI welcome!");
});

app.use("*", function(request, response) {
  response.status(404).send("404, Not found");
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
