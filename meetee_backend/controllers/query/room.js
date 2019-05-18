var knex = require("../../app").knex;

const getRoomTypeList = (request, response) => {
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
}

const getSeatTypeList = (request, response) => {
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
}

const getRoomList = (request, response) => {
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
}

const getSeatList = (request, response) => {
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
}

module.exports = {
  getRoomTypeList,
  getSeatTypeList,
  getRoomList,
  getSeatList
}