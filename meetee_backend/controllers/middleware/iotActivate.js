const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");

exports.middleware = (request, response, next) => {
  const userId = request.body.userId;
  const statement = `select * from meeteenew.view_mqtt_reservtime_lookup
      where userId = $1 and status = $2`;
  // where userId = $1 and ((NOW() ::timestamp, NOW() ::timestamp) overlaps (start_time, end_time))`;
  const value = [userId, "in_this_time"];
  pool.query(statement, value, (error, results) => {
    try {
      if (error) {
        console.log(error);
        throw new ErrorHandler(500, "Database Error");
      } else if (userId == null) {
        throw new ErrorHandler(400, "Bad Request");
      } else if (results.rowCount == 0) {
        throw new ErrorHandler(200, "You don't have any booking in this time.");
      } else {
        request.rows = results.rows;
        next();
      }
    } catch (error) {
      console.log({ error: error });
      if (error.name == "RangeError") {
        next(500, "Internal Server Error");
      }
      next(error);
    }
  });
  //รับ request {Header: jwt-token} {username: string, reservId: int}
  //เช็คเวลาที่จองไป query to get date and time-period เพื่อเทียบกับ now() ว่า overlaps กันหรือไม่
  //true=>next() false=>400 Bad Request
};
