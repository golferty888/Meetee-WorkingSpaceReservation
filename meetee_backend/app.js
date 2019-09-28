const dotenv = require("dotenv").config();
const express = require("express");
const pg = require('pg')
var http = require("http");
const bodyParser = require("body-parser");
const cors = require("cors");
const knex = require('knex')(
  require('./config/knexfile')[process.env.NODE_ENV]
)
module.exports.knex = knex;
const PORT = process.env.PORT || 9000;
const URL = process.env.URL;

const app = express();
const server = http.createServer(app);

app.use(bodyParser.urlencoded({
  extended: false
}));
app.use(bodyParser.json());
app.use(cors({
  origin: true
}));

const facility = require('./controllers/query/facility')
const facStatus = require('./controllers/query/facilityStatus')
const user = require('./controllers/query/user')
const reservation = require('./controllers/query/reservation')

app.get('/fac', facility.getAllFacility)
app.get('/fac/class/:id', facility.getFacilityFromClass)
app.get('/fac/category/all', facility.getAllFacilityCategory)
app.post('/user/history', user.getReservationHistory)
app.post('/facility/cate/status', facStatus.checkStatusEachFacilityCategory)
app.post('/facility/class/status', facStatus.checkStatusEachFacilityClass)
app.post('/facility/all/status', facStatus.checkStatusAllFacilities)
app.post('/reserve', reservation.reserve)
app.get('/reservations', reservation.getAllReservations)

app.get("/", (request, response) => {
  response.send("Meetee welcome!");
});

app.use("*", function (request, response) {
  response.status(404).send('404, Not found');
});

const pgConnectionString = require('./config/knexfile')[process.env.NODE_ENV].pg_connection
// const pgConnectionString = "postgres://meetee_admin:meetee_admin@meeteedb.cnkpi2hqmiv1.ap-southeast-1.rds.amazonaws.com:5432/meetee"
console.log(pgConnectionString)
const pgClient1 = new pg.Client(pgConnectionString);
const pgClient2 = new pg.Client(pgConnectionString);

pgClient1.connect();
pgClient2.connect();

const query1 = pgClient1.query("LISTEN events")
const query2 = pgClient2.query("LISTEN events")



const io = require('socket.io')(server);

const WebSocket = require('ws')
// const wss = new WebSocket.Server({
//   port: 9001
// })
const wss = new WebSocket.Server({
  server: server,
  port: 9001
})


io.on("connection", (socket) => {
  console.log("userId: " + socket.id + " connected.")
  socket.emit("test_connection", "Socket.io: socket is connected.")

  socket.on("disconnect", socket => {
    console.log("!userId: " + socket.id + " disconnected.")
  })
})

// wss.on('connection', ws => {
//   ws.on('message', message => {
//     console.log(`Receive message => ${message}`)
//   })
//   ws.send('Websocket: websocket is connected.');
// })

wss.on('open', function open() {
  console.log('connected');
  wss.send(Date.now());
});

pgClient1.on("notification", async (data) => {
  const payload = data.payload
  console.log("data.payload1: , " + data.payload)
  io.sockets.emit("reservation_trigger", "reservation_table is updated.")
})

wss.on('connection', ws => {
  ws.send('Websocket: websocket is connected.');
  ws.on('message', message => {
    console.log(`Receive message => ${message}`)
  })
  pgClient2.on("notification", async (data) => {
    console.log("PG Notification in Websocket!!!!")
    const payload = data.payload
    ws.send("Websocket: reservation_table is updated.");
  })
})

server.listen(PORT, URL, () => {
  console.log(
    `✔ Listening on PORT: ${server.address().port} > ${process.env.NODE_ENV} > ${server.address().address}`
  );
});

server.on('upgrade', function (req, socket) {
  if (req.headers['upgrade'] !== 'websocket') {
    socket.end('HTTP/1.1 400 Bad Request');
    return;
  }
  const acceptKey = req.headers['sec-websocket-key']
  console.log("acceptKey: " + acceptKey)
  // Read the websocket key provided by the client: const acceptKey = req.headers['sec-websocket-key']; 
  // Generate the response value to use in the response: const hash = generateAcceptValue(acceptKey); 
  // Write the HTTP response into an array of response lines: const responseHeaders = [ 'HTTP/1.1 101 Web Socket Protocol Handshake', 'Upgrade: WebSocket', 'Connection: Upgrade', `Sec-WebSocket-Accept: ${hash}` ]; // Write the response back to the client socket, being sure to append two // additional newlines so that the browser recognises the end of the response // header and doesn't continue to wait for more header data: socket.write(responseHeaders.join('\r\n') + '\r\n\r\n');
});


// pgClient.on("notification", (data) => {
//   const payload = data.payload
//   console.log("data.payload2: , " + data.payload)
//   wss.on('connection', ws => {
//     ws.send("reservation_table is updated.")
//   })
// })



// pgClient.on('error', function (err, client) {
//   console.log('pg::error', {
//     err: err,
//     client: client
//   });
// });