const knex = require('../../config/connection')

exports.checkAvailability = (request, response) => {
    const type = request.body.type;
    const startDate = request.body.startDate;
    const endDate = request.body.endDate;
    const startTime = request.body.startTime;
    const endTime = request.body.endTime;
    console.log(startTime + " " + endTime)

    const unavailableQuery =
        knex("meetee.reservation as resv")
        .distinct("resv.room_id")
        .join("meetee.rooms as room", "resv.room_id", "=", "room.id")
        .where("room.roomtype_id", "=", type)
        .andWhere("resv.start_date", '=', startDate)
        .andWhere(function () {
            this.orWhere(
                knex.raw(`(TIME '${startTime}', TIME '${endTime}') OVERLAPS (resv.start_time, resv.end_time)`)
            )
        })

    const availableQuery =
        knex
        .select('room.id as roomId', 'room.code as roomCode', 'room.floor as floor', 'room.roomtype_id as roomType')
        .from("meetee.rooms as room")
        .where("room.roomtype_id", "=", type)
        .andWhere("room.id", "NOT IN", unavailableQuery)
        .orderBy("room.id")
        .then(data => response.json({
            successful: true,
            data
        }))
        .catch(error => {
            console.log(error)
            response.status(400).send('Bad request')
        })
}

exports.checkUnavailability = (request, response) => {
    const type = request.body.type;
    const startDate = request.body.startDate;
    const endDate = request.body.endDate;
    const startTime = request.body.startTime;
    const endTime = request.body.endTime;
    console.log(startTime + " " + endTime)

    const unavailableQuery =
        knex("meetee.reservation as resv")
        .select('room.id as roomId', 'room.code as roomCode', 'room.floor as floor', 'room.roomtype_id as roomType')
        .distinct("resv.room_id")
        .join("meetee.rooms as room", "resv.room_id", "=", "room.id")
        .where("room.roomtype_id", "=", type)
        .andWhere("resv.start_date", '=', startDate)
        .andWhere(function () {
            this.orWhere(
                knex.raw(`(TIME '${startTime}', TIME '${endTime}') OVERLAPS (resv.start_time, resv.end_time)`)
            )
        })
        .then(data => response.json({
            successful: true,
            data
        }))
        .catch(error => {
            console.log(error)
            response.status(400).send('Bad request')
        })
}