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
  const tx = async callback => {
    const client = await pool.connect();
    try {
      await client.query("BEGIN");
      console.log("BEGIN");
      try {
        // await callback(client);
        let overlap = false;
        let records = [];
        for (i = 0; i < facList.length; i++) {
          const result = await client.query(
            `select * from meeteenew.view_reservation
              where facid = $1 and ((TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') overlaps (start_time, end_time))`,
            [facList[i]]
          );
          if (result.rowCount >= 1) {
            records.push(result.rows);
            overlap = true;
          }
        }
        try {
          if (overlap) {
            throw new ErrorHandler(500, "Sorry about the redundancy.");
          } else {
            startTimeForResponse = await insertAndDelete(
              client,
              userId,
              startTime,
              endTime,
              totalPrice
            );
            response.send({
              message: "Transaction Done",
              startTime: startTimeForResponse
            });
          }
        } catch (e) {
          next(e);
        }
        console.log("COMMIT");
        client.query("COMMIT");
      } catch (e) {
        console.log(e);
        response.send("Transaction Error");
        console.log("ROLLBACK");
        client.query("ROLLBACK");
      }
    } finally {
      console.log("RELEASE");
      client.release();
    }
  };
  tx();

  insertAndDelete = async (client, userId, startTime, endTime, totalPrice) => {
    const insert_reservation = `INSERT INTO meeteenew.reservation(user_id, start_time, end_time, total_price, status) 
    VALUES($1, $2, $3, $4, $5) RETURNING id, start_time`;
    const insert_reservation_values = [
      userId,
      startTime,
      endTime,
      totalPrice,
      "Booked"
    ];
    const resultResv = await client.query(
      insert_reservation,
      insert_reservation_values
    );
    facList.forEach(async facId => {
      const insert_line_reservation = `INSERT INTO meeteenew.reservation_line(reserve_id, facility_id) VALUES($1, $2)`;
      const insert_line_reservation_values = [resultResv.rows[0].id, facId];
      await client.query(
        insert_line_reservation,
        insert_line_reservation_values
      );
      const delete_pending = `DELETE FROM meeteenew.pending_facility where facility_id = $1 and start_time = $2 and end_time = $3`;
      const delete_pending_values = [facId, startTime, endTime];
      await client.query(delete_pending, delete_pending_values);
    });
    const startTimeForResponse = resultResv.rows[0].start_time;
    return startTimeForResponse;
  };
};
