var knex = require("../../app").knex;

const checkUnAvailability = (request, response) => {
    const type = request.body.type;
    const startDate = request.body.startDate;
    const endDate = request.body.endDate;
    var startTime = request.body.startTime;
    startTime = startTime.substr(0, 6) + "01";
    const endTime = request.body.endTime;

    const unavailableRoomSubQuery = knex
        .select('room.id as room_id', 'room.code as room_code', 'roomtype.name as roomtype_name', 'resv.start_time', 'resv.end_time')
        .distinct('room.id')
        .from("meetee.reservation as resv")
        .join("meetee.rooms as room", "resv.room_id", "=", "room.id")
        .join("meetee.roomtypes as roomtype", "room.roomtype_id", "=", "roomtype.id")
        .join("meetee.categories as cate", "roomtype.category_id", "=", "cate.id")
        .where("cate.id", "=", type)
        .andWhere("resv.start_date", '=', startDate)
        .andWhere(function () {
            this.where(knex.raw("? BETWEEN resv.start_time AND resv.end_time", startTime));
            this.orWhere(
                knex.raw("? BETWEEN resv.start_time AND resv.end_time", endTime));
        })
        .orderBy("room.id")
        .then(unAvailableList => response.json({
            message: 'Successfully',
            unAvailableList
        }))
        .catch(error => {
            console.log(error);
            response.status(400).send('Bad Request');
        });
}

module.exports = {
    checkUnAvailability
}