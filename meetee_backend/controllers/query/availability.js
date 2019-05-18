var knex = require("../../app").knex;

const checkAvailability = (request, response) => {
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
}

module.exports = {
    checkAvailability
}