var knex = require("../../app").knex;

const reserve = (request, response) => {
    const userId = request.body.userId;
    const roomId = request.body.roomId;
    const startDate = request.body.startDate;
    const endDate = request.body.endDate;
    const startTime = request.body.startTime;
    const endTime = request.body.endTime;
    knex("meetee.reservation")
      .returning(
        "id"
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
  }

const getAllReservations = (request, response) => {
    knex.select().from('meetee.reservation')
        .orderBy('room_id')
        .then((results) => {
            response.send(results);
        })
}

module.exports = {
    getAllReservations,
    reserve
}