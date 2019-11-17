const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");

exports.middleWare = async (request, response, next) => {
  const data = request.body;
  const userId = data.userId;
  const facList = data.facId;
  const startTime = data.startDate + " " + data.startTime;
  const endTime = data.startDate + " " + data.endTime;

  const checkRedundancy = `select * from meeteenew.view_reservation
  where facid = $1 and ((TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') overlaps (start_time, end_time))`;
  let overlap = false;
  for (i = 0; i < facList.length; i++) {
    pool.query(checkRedundancy, [facList[i]], (err, res) => {
      try {
        if (err) {
          console.log(err);
          throw new ErrorHandler(500, "Database Error in Middleware");
        } else if (res.rowCount >= 1) {
          overlap = true;
          throw new ErrorHandler(500, "Sorry about the redundancy.");
        } else {
          next();
        }
      } catch (e) {
        console.log(e);
        next(e);
      }
    });
  }
};
