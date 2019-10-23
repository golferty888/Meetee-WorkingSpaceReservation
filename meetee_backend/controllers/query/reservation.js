const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");

exports.reserve = (request, response, next) => {
  const data = request.body;
  const userId = data.userId;
  const facList = data.facId;
  const start_time = data.startDate + " " + data.startTime;
  const end_time = data.startDate + " " + data.endTime;
  const totalPrice = data.totalPrice;
  console.log("-------------------------------------------------------------");
  console.log({ request: "POST /reserve", body: JSON.stringify(data) });

  const insertResv = `INSERT INTO meeteenew.reservation(user_id, start_time, end_time, total_price, status) 
    VALUES($1, $2, $3, $4, $5) RETURNING id`;
  const insertResvValues = [userId, start_time, end_time, totalPrice, "Booked"];

  pool.connect((err, client, done) => {
    const shouldAbort = err => {
      if (err) {
        console.error("Error in transaction", err.stack);
        client.query("ROLLBACK", err => {
          if (err) {
            console.error("Error rolling back client", err.stack);
          }
          done();
        });
      }
      return !!err;
    };
    client.query("BEGIN", async err => {
      if (shouldAbort(err)) return;

      client.query(insertResv, insertResvValues, (err, res) => {
        if (shouldAbort(err)) return;
        facList.forEach(facId => {
          const insertResvLine = `INSERT INTO meeteenew.reservation_line(reserve_id, facility_id)
            VALUES(${res.rows[0].id}, ${facId});`;
          client.query(insertResvLine, (err, res) => {
            if (shouldAbort(err)) return;
          });
        });
        client.query("COMMIT", err => {
          if (err) {
            console.error("Error committing transaction", err.stack);
          }
          response.send("Transaction Done.");
        });
      });
    });
  });
};

exports.getAllReservations = (request, response, next) => {
  console.log("-------------------------------------------------------------");
  console.log({ request: "GET /reservations" });
  const queryText = `select reservId, 
    array_agg(json_build_object('facCode', code, 'floor', floor)) as facList,
    cateName, price :: int, date, period, hour :: int, total_price :: int, status
    from meeteenew.view_user_history
    group by reservId, cateName, price, date, period, hour , total_price, status
    order by reservId desc`;
  pool.query(queryText, (error, results) => {
    if (error) {
      throw new ErrorHandler(500, "Database Error");
    } else {
      response.status(200).send(results.rows);
    }
  });
};
