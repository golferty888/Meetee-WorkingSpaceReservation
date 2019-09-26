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
console.log(pgConnectionString)
const pgClient = new pg.Client(pgConnectionString);

pgClient.connect();

const query = pgClient.query("LISTEN events")

server.listen(PORT, URL, () => {
  console.log(
    `✔ Listening on PORT: ${server.address().port} > ${process.env.NODE_ENV} > ${server.address().address}`
  );
});

const WebSocket = require('ws')

const wss = new WebSocket.Server({
  port: 9001
})

wss.on('connection', ws => {
  ws.on('message', message => {
    console.log(`Receive message => ${message}`)
  })
  ws.send('Congratulation Gulf, You\'re in the Websocket now!.');

  pgClient.on("notification", async (data) => {
    const payload = data.payload
    ws.send('(Websocket) db_payload: ' + payload)
  })

})

pgClient.on('error', function (err, client) {
  console.log('pg::error', {
    err: err,
    client: client
  });
});

// const io = require('socket.io')(server);

// io.on("connection", (socket) => {
//   console.log("userId: " + socket.id + " connected.")

//   socket.on("disconnect", socket => {
//     console.log("!userId: " + socket.id + " disconnected.")
//   })
// })

// pgClient.on("notification", async (data) => {
//   const payload = data.payload
//   console.log("data.payload: , " + data.payload)
//   ws.on('reserv', (ws, payload) => {
//     ws.send('payload: ' + payload)
//   })
//   // io.emit("reservation_trigger", payload)
// })