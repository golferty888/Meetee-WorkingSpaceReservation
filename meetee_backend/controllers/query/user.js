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
  response
    .status(200)
    .send({
      message: "Login success!",
      userId: request.userId,
      token: cipherText
    });
};

exports.getReservationHistoryList = (request, response, next) => {
  const data = request.body;
  const userId = data.userId;
  const queryValue = [userId];
  const queryText = `select * from meeteenew.view_user_history
    where userId = $1`;
  pool.query(queryText, queryValue, (error, results) => {
    
    try {
      if (userId == null) {
        throw new ErrorHandler(400, "Bad Request");
      } else if (error) {
        console.log(error);
        throw new ErrorHandler(500, "Database Error");
      } else {
        if (results.rowCount == 0) {
          response.status(200).send({
            userId: userId,
            errorCode: "01",
            message: "User have never made a booking before."
          });
        } else {
          response.status(200).send(results.rows);
        }
      }
    } catch (error) {
      console.log(error);
      next(error);
    }
  });
};

exports.getUpcomingAndIntimeReservation = (request, response, next) => {
  const data = request.body;
  const userId = data.userId;
  const statement = `select * from meeteenew.upcoming_and_intime_reservation
    where userId = $1`;
  const value = [userId];
  pool.query(statement, value, (err, res) => {
    try {
      if (err) {
        throw new ErrorHandler(500, "Database Error");
      } else {
        response.send(res.rows);
      }
    } catch (error) {
      console.log(error);
      next(error);
    }
  });
};

exports.getAllUsers = (request, response, next) => {
  if (request.url == "/userx") {
    response.send("yes!");
  } else {
    const statement = `select * from meeteenew.users`;
    const value = [];
    pool.query(statement, (err, res) => {
      try {
        if (err) {
          throw new ErrorHandler(500, "Database Error");
        } else {
          response.send(res.rows);
        }
      } catch (error) {
        console.log(error);
        next(error);
      }
    });
  }
};
