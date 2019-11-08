const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");

exports.userAndReservation = (request, response, next) => {
  // reservation rs&li
  // signup user
  const statement = `DELETE FROM meeteenew.reservation 
        where start_time = '2020-01-20 08:00:00'`;
  pool.query(statement, (err, res) => {
    try {
      if (err) {
        console.log(err);
        throw new ErrorHandler(500, "Database Error");
      } else {
      }
    } catch (error) {
      next(error);
    }
  });
  const statement2 = `DELETE FROM meeteenew.users
    where username = 'test'`;
  pool.query(statement2, (err, res) => {
    try {
      if (err) {
        console.log(err);
        throw new ErrorHandler(500, "Database Error");
      } else {
      }
    } catch (error) {
      next(error);
    }
  });
  response.send("Delete Success");
};
