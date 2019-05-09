const dotenv = require("dotenv").config();
const express = require("express");
var http = require("http");
const bodyParser = require("body-parser");
const cors = require("cors");
if (process.env.NODE_ENV == "production") {
  var knex = require("./config/database-pg-rds");
  var PORT = process.env.PORT || 9500;
} else if (process.env.NODE_ENV == "development") {
  var knex = require("./config/database-pg-local");
  var PORT = process.env.PORT || 8000;
}
const URL = process.env.URL;

const {
  createError,
  GENERIC_ERROR
} = require('./errors/error_helper')

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
app.get('/check/reservation', (request, response) => {
  knex.select().from('meetee.reservation')
    .orderBy('room_id')
    .then((results) => {
      response.send(results);
    })
})

app.post("/check/available", (request, response) => {
  const type = request.body.type;
  const startDate = request.body.startDate;
  const endDate = request.body.endDate;
  var startTime = request.body.startTime;
  startTime = startTime.substr(0, 6) + "01";
  const endTime = request.body.endTime;

  const unavailableRoomSubQuery = knex
    .select('room.id as room_id')
    .from("meetee.reservation as resv")
    .join("meetee.rooms as room", "resv.room_id", "=", "room.id")
    .where("room.roomtype_id", "=", type)
    .andWhere("resv.start_date", '=', startDate)
    .andWhere(function () {
      this.where(knex.raw("? BETWEEN resv.start_time AND resv.end_time", startTime));
      this.orWhere(
        knex.raw("? BETWEEN resv.start_time AND resv.end_time", endTime));
    })
    .orderBy("resv.id");

  const availableRoomQuery = knex
    .select('room.id as roomId', 'room.code as roomCode', 'room.floor as floor', 'room.roomtype_id as roomType')
    .from("meetee.rooms as room")
    .where("room.roomtype_id", "=", type)
    .whereNotIn('room.id', unavailableRoomSubQuery)
    .orderBy("room.id")
    .then(availableList => response.json({
      message: 'Successfully',
      availableList
    }))
    .catch(error => {
      console.log(error);
      response.status(400).send('Bad Request');
    });
});

app.post("/reserve", (request, response) => {
  const userId = request.body.userId;
  const roomId = request.body.roomId;
  const startDate = request.body.startDate;
  const endDate = request.body.endDate;
  const startTime = request.body.startTime;
  const endTime = request.body.endTime;
  knex("meetee.reservation")
    .returning(
      "id",
      "room_id",
      "user_id",
      "start_date",
      "start_time",
      "end_date",
      "end_time"
    )
    .insert([{
      user_id: userId,
      room_id: roomId,
      start_date: startDate,
      end_date: endDate,
      start_time: startTime,
      end_time: endTime
    }])
    .then(result => {
      response.send(result);
    })
    .catch(error => {
      response.send(error);
    });
});

app.get("/type/room", (request, response) => {
  knex("meetee.roomtypes")
    .where("roomtypes.category_id", "1")
    .select(
      "roomtypes.id",
      "roomtypes.name",
      "roomtypes.price",
      "roomtypes.capacity"
    )
    .then(results => {
      response.send(results);
    })
    .catch(error => {
      response.send(error);
    });
});

app.get("/type/seat", (request, response) => {
  knex("meetee.roomtypes")
    .where("roomtypes.category_id", "2")
    .select(
      "roomtypes.id",
      "roomtypes.name",
      "roomtypes.price",
      "roomtypes.capacity"
    )
    .then(results => {
      response.send(results);
    })
    .catch(error => {
      response.send(error);
    });
});

app.get("/view/rooms", (request, response) => {
  knex("meetee.rooms")
    .join("meetee.roomtypes", "rooms.roomtype_id", "=", "roomtypes.id")
    .where("roomtypes.category_id", "1")
    .select(
      "rooms.id",
      "rooms.code",
      "roomtypes.name",
      "roomtypes.price",
      "roomtypes.capacity",
      "rooms.floor"
    )
    .then(results => {
      response.send(results);
    })
    .catch(error => {
      response.send(error);
    });
});

app.get("/view/seats", (request, response) => {
  knex("meetee.rooms")
    .join("meetee.roomtypes", "rooms.roomtype_id", "=", "roomtypes.id")
    .where("roomtypes.category_id", "2")
    .select(
      "rooms.id",
      "rooms.code",
      "roomtypes.name",
      "roomtypes.price",
      "roomtypes.capacity",
      "rooms.floor"
    )
    .then(results => {
      response.send(results);
    })
    .catch(error => {
      response.send(error);
    });
});

server.listen(PORT, URL, () => {
  console.log(
    `Listening on PORT: ${server.address().port} > ${process.env.NODE_ENV} > ${
      process.env.DB_LOCAL_HOST
    }`
  );
});