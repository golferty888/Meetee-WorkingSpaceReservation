const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");

exports.reserve = (request, response, next) => {
  const data = request.body;
  const userId = data.userId;
  const facList = data.facId;
  const startTime = data.startDate + " " + data.startTime;
  const endTime = data.startDate + " " + data.endTime;
  const totalPrice = data.totalPrice;

  const insertResv = `INSERT INTO meeteenew.reservation(user_id, start_time, end_time, total_price, status) 
    VALUES($1, $2, $3, $4, $5) RETURNING id`;
  const insertResvValues = [userId, startTime, endTime, totalPrice, "Booked"];
  const deletePending = `DELETE FROM meeteenew.pending_facility where facility_id = $1 and start_time = $2 and end_time = $3`;
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
          const values = [facId, startTime, endTime];
          client.query(deletePending, values, (err, res) => {
            if (shouldAbort(err)) {
              console.log(err);
              return;
            }
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
  const queryText = `select * from meeteenew.view_user_history`;
  pool.query(queryText, (error, results) => {
    try {
      if (error) {
        console.log(error);
        throw new ErrorHandler(500, "Database Error");
      } else {
        response.status(200).send(results.rows);
      }
    } catch (error) {
      console.log(error);
      next(error);
    }
  });
};
