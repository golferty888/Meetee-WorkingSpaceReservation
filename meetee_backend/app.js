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

app.post("/check/available", (request, response) => {
  const type = request.body.type;
  const startDate = request.body.startDate;
  const endDate = request.body.endDate;
  var startTime = request.body.startTime;
  startTime = startTime.substr(0, 6) + "01";
  const endTime = request.body.endTime;

  var query = knex
    .select("room.id", "room.code")
    .distinct()
    .from("meetee.reservation as resv")
    .fullOuterJoin("meetee.rooms as room", "resv.room_id", "=", "room.id")
    .where("room.roomtype_id", "=", type)
    .andWhere(function () {
      this.where(knex.raw("resv.start_date <> ?", startDate));
      this.orWhereNull("resv.start_date");
      this.orWhere(function () {
        this.where(knex.raw("resv.start_date = ?", startDate));
        this.andWhere(function () {
          this.where(knex.raw("? NOT BETWEEN resv.start_time AND resv.end_time", startTime));
          this.andWhere(
            knex.raw("? NOT BETWEEN resv.start_time AND resv.end_time", endTime));
        });
      });
    })
    .then(results => {
      console.log(results);
      response.send(results);
    })
    .catch(error => {
      console.log(error);
    });
});

app.post("/reserve", (request, response) => {
  const userId = request.body.userId;
  const roomId = request.body.roomId;
  const startDate = request.body.startDate;
  const endDate = request.body.endDate;
  var startTime = request.body.startTime;
  startTime = startTime.substr(0, 6) + "01";
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