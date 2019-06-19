const dotenv = require("dotenv").config();
const express = require("express");
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

// const roomQuery = require('./controllers/query/room')

app.get('/fac', facility.getAllFacility)
app.get('/fac/class/:id', facility.getFacilityCategory)
app.get('/fac/:id', facility.getFacilityCategoryEquipment)
app.post('/user/history', user.getReservationHistory)
app.post('/check/available', facStatus.checkAvailability)
app.post('/check/unavailable', facStatus.checkUnavailability)
app.post('/reserve', reservation.reserve)
app.get('/reservations', reservation.getAllReservations)
// app.get('/type/room', roomQuery.getRoomTypeList)
// app.get('/type/seat', roomQuery.getSeatTypeList)

app.use("*", function (request, response) {
  response.status(404).send('404, Not found');
});

server.listen(PORT, URL, () => {
  console.log(
    `✔ Listening on PORT: ${server.address().port} > ${process.env.NODE_ENV} > ${server.address().address}`
  );
});