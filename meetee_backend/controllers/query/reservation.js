var knex = require("../../app").knex;
const { Reservation } = require("../../models/reservation");

exports.reserve = (request, response, callback) => {
  const userId = request.body.userId;
  const facId = request.body.facId;
  const startDate = request.body.startDate;
  // const endDate = request.body.endDate;
  const startTime = request.body.startTime;
  const endTime = request.body.endTime;
  const start_time = startDate + " " + startTime;
  const end_time = startDate + " " + endTime;
  // const end_time = endDate + ' ' + endTime;
  const status = "Booked";
  console.log("pre: " + start_time + " " + end_time);

  knex("meeteenew.reservation as resv")
    .select("resv.id")
    .where("resv.status", "=", status)
    .andWhere("resv.facility_id", "=", facId)
    .andWhereRaw(
      `(TIMESTAMP '${start_time}', TIMESTAMP '${end_time}') OVERLAPS (resv.start_time, resv.end_time)`
    )
    .then(data => {
      console.log("length: " + Object.keys(data).length);
      if (Object.keys(data).length != 0) {
        throw new Error("Redundancy");
      }
      insertReserveList();
    })
    .catch(error => {
      console.log(error);
      response.status(500).send("Sorry, The booking is redundant.");
    });

  function insertReserveList() {
    knex("meeteenew.reservation")
      .returning("id")
      .insert([
        {
          user_id: userId,
          facility_id: facId,
          start_time: start_time,
          end_time: end_time,
          status: status
        }
      ])
      .then(result => {
        response.send(result);
      })
      .catch(error => {
        response.send(error);
      });
  }
};

exports.getAllReservations = (request, response) => {
  Reservation.forge()
    .fetchAll({
      withRelated: [
        {
          reservationDetail: function(query) {
            query.orderBy("facility_id", "DESC");
          }
        },
        "user"
      ]
    })
    .then(data => {
      response.send(data);
    });
};

exports.reserv2 = (request, response) => {
  const {
    startDate,
    startTime,
    endDate,
    endTime,
    userId,
    facilityList
  } = request.body;
  Reservation.forge({
    start_time: startDate + " " + startTime,
    end_time: endDate + " " + endTime,
    status: "Booked",
    user_id: userId
  })
    .save()
    .tap(reservation =>
      Promise.map(reservation, facilityList =>
        reservation.related("reservationDetail.facilities").create(facilityList)
      )
    )
    .then(reservation => {
      response.json({
        successful: true,
        data: {
          id: reservation.get("id")
        }
      });
    })
    .catch(error => {
      response.status(500).json({
        error: true,
        data: {
          message: error.message
        }
      });
    });
};
