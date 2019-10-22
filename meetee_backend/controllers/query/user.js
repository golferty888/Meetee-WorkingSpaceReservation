const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");
const bcrypt = require("bcrypt");
const jwt = require("jwt-simple");

exports.signup = (request, response, next) => {
  const round = 2;
  const username = request.body.username;
  const password = request.body.password;

  bcrypt.hash(password, round, (error, hash) => {
    const statement = `INSERT INTO meeteenew.users (username, password, role) VALUES ($1, $2, $3) RETURNING username, password`;
    const values = [username, hash, "user"];
    pool.query(statement, values, (error, result) => {
      try {
        if (username == null || password == null) {
          throw new ErrorHandler(400, "Bad Request");
        } else if (error) {
          console.log(error);
          throw new ErrorHandler(500, "Database Error");
        } else {
          response.status(200).send({
            message: result.rows[0].username + " Sign up success!",
            passwordEn: result.rows[0].password
          });
        }
      } catch (error) {
        next(error);
      }
    });
  });
};

exports.login = (request, response, next) => {
  const payload = {
    sub: request.body.username,
    iat: new Date().getTime()
  };
  const SECRET = process.env.SECRET;
  const cipherText = jwt.encode(payload, SECRET);
  response.status(200).send({ message: "Login success!", token: cipherText });
};

exports.getReservationHistoryList = (request, response, next) => {
  const data = request.body;
  console.log("-------------------------------------------------------------");
  console.log({ request: "POST /user/history", body: JSON.stringify(data) });
  const userId = data.userId;
  const queryValue = [userId];
  const queryText = `select reservId, 
    array_agg(json_build_object('facCode', code, 'floor', floor)) as facList,
    cateName, price, date, period, hour, total_price, status
    from meeteenew.view_user_history
    where userId = $1
    group by reservId, cateName, price, date, period, hour , total_price, status
    order by reservId desc`;
  pool.query(queryText, queryValue, (error, results) => {
    try {
      if (userId == null || !userId.match(/^[0-9]+$/)) {
        throw new ErrorHandler(400, "Bad Request");
      } else if (error) {
        console.log(error);
        throw new ErrorHandler(500, "Database Error");
      } else {
        response.status(200).send(results.rows);
      }
    } catch (error) {
      next(error);
    }
  });
};
