const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");

exports.middleware = (request, response, next) => {
  console.log("-------------------------------------------------------------");
  console.log({
    request: "POST /activate",
    body: JSON.stringify(request.body)
  });
  const userId = request.body.userId;
  // const reservId = request.body.reservId;
  const queryText = `select reservId, array_agg(json_build_object('facCode', code, 'floor', floor)) as facList 
      from meeteenew.view_user_history
      where userId = $1 and ((NOW() ::timestamp, NOW() ::timestamp) overlaps (start_time, end_time))
      group by reservId`;
  const queryValues = [userId];
  pool.query(queryText, queryValues, (error, results) => {
    try {
      if (error) {
        throw new ErrorHandler(500, "Database Error");
      } else if (userId == null) {
        throw new ErrorHandler(400, "Bad Request");
      } else if (results.rowCount == 0) {
        throw new ErrorHandler(200, "You don't have any booking in this time.");
      } else {
        const facCodeList = [];
        results.rows.forEach(element => {
          element.faclist.forEach(facItem => {
            facCodeList.push(facItem.facCode);
          });
        });
        request.facCodeList = facCodeList;
        next();
      }
    } catch (error) {
      console.log(error);
      next(error);
    }
  });
  //รับ request {Header: jwt-token} {username: string, reservId: int}
  //เช็คเวลาที่จองไป query to get date and time-period เพื่อเทียบกับ now() ว่า overlaps กันหรือไม่
  //true=>next() false=>400 Bad Request
};
