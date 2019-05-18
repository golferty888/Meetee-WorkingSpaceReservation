var knex = require("../../app").knex;

const checkDensityOfRoomtype = (request, response) => {
    const type = request.body.type;
    const startDate = request.body.startDate;
    const endDate = request.body.endDate;
    var startTime = request.body.startTime;
    startTime = startTime.substr(0, 6) + "01";
    const endTime = request.body.endTime;

    const amountOfRoomQuery = knex
        .count("room.id")
        .from("meetee.rooms as room")
        .where("room.roomtype_id", "=", type)
        .then(result => {
            amountOfRoom = result[0].count;
        })

    const unavailableRoomSubQuery = knex
        .select(knex.raw("room.roomtype_id, count(distinct resv.room_id) as unavailable, count(room.id) as from"))
        // .countDistinct("resv.room_id")
        // .count("room.id")
        .from("meetee.reservation as resv")
        .fullOuterJoin("meetee.rooms as room", "resv.room_id", "=", "room.id")
        // .where("room.roomtype_id", "=", type)
        .whereNull("resv.start_date")
        .orWhere(function () {
            this.where("resv.start_date", '=', startDate);
            this.andWhere(function () {
                this.where(knex.raw("? BETWEEN resv.start_time AND resv.end_time", startTime));
                this.orWhere(
                    knex.raw("? BETWEEN resv.start_time AND resv.end_time", endTime));
            })
        })
        // .orWhere(function () {
        //   this.where("resv.start_date", '=', startDate)
        // })
        .groupBy('room.roomtype_id')
        .orderBy('room.roomtype_id')
        // .then(countUnavailable => response.json({
        //   message: 'Successfully',
        //   density: {
        //     count: parseInt(amountOfRoom) - parseInt(countUnavailable[0].count),
        //     from: parseInt(amountOfRoom)
        //   }.
        // }))
        .then(results => {
            response.send(results);
        })
        .catch(error => {
            console.log(error);
            response.status(400).send('Bad Request');
        });
}

const getAllReservations = (request, response) => {
    knex.select().from('meetee.reservation')
        .orderBy('room_id')
        .then(results => {
            response.send(results);
        })
}

module.exports = {
    checkDensityOfRoomtype,
}