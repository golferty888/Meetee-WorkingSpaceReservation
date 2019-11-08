const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");

exports.req = (request, response, next) => {
  console.log("-------------------------------------------------------------");
  console.log({
    request: request.method + " " + request.url,
    body: JSON.stringify(request.body)
  });
  const userId = request.body.userId;
  if (userId != null) {
    const statement = `SELECT * FROM meeteenew.users WHERE id = $1`;
    const value = [userId];
    pool.query(statement, value, (err, res) => {
      try {
        if (err) {
          console.log(error);
          throw new ErrorHandler(500, "Database Error");
        } else if (res.rowCount == 0) {
          response.send({
            errorCode: "02",
            userId: userId,
            message: "User does not exists."
          });
        } else {
          next();
        }
      } catch (error) {
        console.log(error);
        next(error);
      }
    });
  }
};
