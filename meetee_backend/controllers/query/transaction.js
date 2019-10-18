const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});

exports.reserve = (request, response) => {
  const data = request.body;
  const userId = data.userId;
  const facList = data.facId;
  const start_time = data.startDate + " " + data.startTime;
  const end_time = data.startDate + " " + data.endTime;
  const checkRD = `select id from meeteenew.view_reservation as v
            where v.status = $1 and v.facId = $2 and
            (TIMESTAMP '${start_time}', TIMESTAMP '${end_time}') OVERLAPS (v.start_time, v.end_time)`;
  const insertResv = `INSERT INTO meeteenew.reservation(user_id, start_time, end_time, status) 
            VALUES($1, $2, $3, $4) RETURNING id`;
  const insertResvValues = [userId, start_time, end_time, "Booked"];

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
      var count = 0;
      var checkPass = true;

      // CHECK REDUNDANCY BOOKING

      try {
        for (let i = 0; i < facList.length; i++) {
          console.log(count);
          const checkRDValues = ["Booked", facList[i]];
          const rowFromCheckRD = await client.query(checkRD, checkRDValues);
          if (rowFromCheckRD.rowCount > 0) {
            console.log("in......................");
            checkPass = false;
            throw new Error("RedundancyError");
          }
          count++;
        }
      } catch (error) {
        console.log("out......................");
        response.status(500).send("Something went wrong about redundancy.");
        return checkPass;
      }

      // INSERT ITEMS

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
