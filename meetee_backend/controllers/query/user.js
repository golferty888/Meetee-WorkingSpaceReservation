const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const bcrypt = require("bcrypt");
const jwt = require("jwt-simple");

exports.signup = (request, response) => {
  const round = 2;
  const username = request.body.username;
  const password = request.body.password;

  bcrypt.hash(password, round, (error, hash) => {
    const statement = `INSERT INTO meeteenew.users (username, password, role) VALUES ($1, $2, $3) RETURNING username, password`;
    const values = [username, hash, "user"];
    pool.query(statement, values, (error, result) => {
      if (error) {
        console.log(error);
        response.status(500).send("Database Error");
      }
      response.status(200).send({
        message: result.rows[0].username + " Sign up success!",
        passwordEn: result.rows[0].password
      });
    });
  });
};

exports.login = (request, response) => {
  const payload = {
    sub: request.body.username,
    iat: new Date().getTime()
  };
  const SECRET = process.env.SECRET;
  const cipherText = jwt.encode(payload, SECRET);
  response.status(200).send({ message: "Login success!", token: cipherText });
};

exports.getReservationHistoryList = (request, response) => {
  const userId = request.body.userId;
  const queryValue = [userId];
  const queryText = `select reservId, 
    array_agg(json_build_object('facCode', code, 'floor', floor)) as facList,
    cateName, price, date, period, hour, total_price, status
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
