const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");

exports.getStartTimeForActivation = (request, response, next) => {
  const userId = request.body.userId;
  const statement = `select * from meeteenew.init_activation_page
  where userId = $1`;
  const value = [userId];
  pool.query(statement, value, (err, res) => {
    try {
      if (err) {
        console.log(err);
        throw new ErrorHandler(500, "Database Error");
      } else {
        response.send(res.rows);
      }
    } catch (error) {
      next(error);
    }
  });
};
