const dotenv = require("dotenv").config();
const express = require("express");
var http = require("http");
const bodyParser = require("body-parser");
const cors = require("cors");
if (process.env.NODE_ENV == "production") {
  var knex = require("./config/database-pg-rds");
} else if (process.env.NODE_ENV == "development") {
  var knex = require("./config/database-pg-local");
}
const PORT = process.env.PORT || 9000;
module.exports.knex = knex;
const URL = process.env.URL;

const app = express();
const server = http.createServer(app);

const reservationQuery = require('./controllers/query/reservation');
const availabilityQuery = require('./controllers/query/availability');
const unAvailabilityQuery = require('./controllers/query/unavailability');
const densityQuery = require('./controllers/query/density');
const roomQuery = require('./controllers/query/room');
const userQuery = require('./controllers/query/user')

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

app.get('/reservations', reservationQuery.getAllReservations)

app.post('/check/available', availabilityQuery.checkAvailability)

app.post('/check/unavailable', unAvailabilityQuery.checkUnAvailability)

app.post('/reserve', reservationQuery.reserve)

app.post('/check/density', densityQuery.checkDensityOfRoomtype)

app.get('/type/room', roomQuery.getRoomTypeList)

app.get('/type/seat', roomQuery.getSeatTypeList)

app.get('/rooms', roomQuery.getRoomList)

app.get('/seats', roomQuery.getSeatList)

app.post('/user/history', userQuery.getReservationHistoryList)

app.use("*", function (request, response) {
  response.status(404).send('404, Not found');
});

// server.listen(PORT);
server.listen(PORT, URL, () => {
  console.log(
    `Listening on PORT: ${server.address().port} > ${process.env.NODE_ENV} > ${server.address().address}`
  );
}
);

