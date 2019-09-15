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

app.get("/", (request, response) => {
  response.send("Meetee welcome!");
});

const facility = require('./controllers/query/facility')
const facStatus = require('./controllers/query/facilityStatus')
const user = require('./controllers/query/user')
const reservation = require('./controllers/query/reservation')

app.get('/fac', facility.getAllFacility)
// app.get('/fac/class/:id', facility.getFacilityCategory)
app.get('/fac/class/:id', facility.getFacilityFromClass)
app.get('/fac/category', facility.getAllFacilityCategory)
// app.get('/fac/:id', equipment.getFacilityCategoryEquipment)
app.post('/user/history', user.getReservationHistory)
app.post('/check/available', facStatus.checkAvailability)
app.post('/check/unavailable', facStatus.checkUnavailability)
app.post('/check/unavailable/all', facStatus.checkUnavailabilityAllCategory)
app.post('/reserve', reservation.reserve)
app.get('/reservations', reservation.getAllReservations)

app.get('/test', async (request, response) => {
  const data = await pgClient.query('SELECT * FROM meeteenew.reservation')
  response.send({
    table: data.rows
  })
})

app.use("*", function (request, response) {
  response.status(404).send('404, Not found');
});

const connectionString = process.env.POSTGRES_CONNECTION_URL
const pgClient = new pg.Client(connectionString);

pgClient.connect();

const query = pgClient.query("LISTEN events")

server.listen(PORT, URL, () => {
  console.log(
    `✔ Listening on PORT: ${server.address().port} > ${process.env.NODE_ENV} > ${server.address().address}`
  );
});

const io = require('socket.io')(server);

io.on("connection", (socket) => {
  console.log("userId: " + socket.id + " connected.")

  socket.on("disconnect", socket => {
    console.log("!userId: " + socket.id + " disconnected.")
  })
})

pgClient.on("notification", async (data) => {
  const payload = data.payload
  console.log("data.payload: , " + data.payload)
  io.emit("reservation_trigger", payload)
})

pgClient.on('error', function (err, client) {
  console.log('pg::error', {
    err: err,
    client: client
  });
});