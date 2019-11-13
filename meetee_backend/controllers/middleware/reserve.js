const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");

exports.middleWare = (request, response, next) => {
  const data = request.body;
  const userId = data.userId;
  const facList = data.facId;
  const start_time = data.startDate + " " + data.startTime;
  const end_time = data.startDate + " " + data.endTime;

  const statement = `select id from meeteenew.reservation
    where user_id = $1 and start_time = $2 and end_time = $3`;
  const values = [userId, start_time, end_time];
  pool.query(statement, values, async (error, results) => {
    try {
      if (
        userId == null ||
        start_time == null ||
        end_time == null ||
        facList == null
      ) {
        console.log("Some parameter is null");
        throw new ErrorHandler(400, "Bad Request");
      } else if (error) {
        console.log("Database Error" + error.stack);
        throw new ErrorHandler(500, "Database Error");
      } else if (facList != null && facList.length > 10) {
        console.log("facList is null or more than 10 items");
        throw new ErrorHandler(400, "Bad Request");
      } else if (new Date(start_time) < new Date()) {
        console.log("start_time is less than present time");
        throw new ErrorHandler(400, "Bad Request");
      } else if (facList != null) {
        const statement = `select id from meeteenew.view_reservation as v
          where v.status = 'Booked' and v.facId = $1 and
          (TIMESTAMP '${start_time}', TIMESTAMP '${end_time}') OVERLAPS (v.start_time, v.end_time)`;
        var errDetect = false;

        for (let i = 0; i < facList.length; i++) {
          const value = [facList[i]];
          pool.query(statement, value, (err, res) => {
            try {
              if (err) {
                throw new ErrorHandler(500, "Database Error");
              } else if (res.rowCount > 0) {
                errDetect = true;
              }
            } catch (error) {
              next(error);
            } finally {
              if (i == facList.length - 1)
                try {
                  if (errDetect) {
                    throw new ErrorHandler(500, "Sorry about the redundancy.");
                  } else {
                    next();
                  }
                } catch (error) {
                  next(error);
                }
            }
          });
        }
      }
    } catch (error) {
      console.log(error);
      next(error);
    }
  });
};
