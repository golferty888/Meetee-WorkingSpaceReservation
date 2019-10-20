const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});

exports.getReservationHistoryList = (request, response) => {
  const userId = request.body.userId;
  const queryValue = [userId];
  const queryText = `select reservId, 
    array_agg(json_build_object('facCode', code, 'floor', floor)) as facList,
    cateName, price :: int, date, period, hour :: int, total_price :: int, status
    from meeteenew.view_user_history
    where userId = $1
    group by reservId, cateName, price, date, period, hour , total_price, status
    order by reservId desc`;
  pool.query(queryText, queryValue, (error, results) => {
    if (error) {
      response.status(500).send("Database Error");
    }
    response.status(200).send(results.rows);
  });
};