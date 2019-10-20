const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});

exports.middleware = async (request, response, next) => {
  const data = request.body;
  const username = data.username;
  const password = data.password;
  const statement = `select id from meeteenew.users where username = $1`;
  const value = [username];
  var redundancy = false;
  var userData = await pool.query(statement, value);
  if (userData.rowCount > 0) {
    redundancy = true;
  }
  if (redundancy) {
    response.status(400).send("That username is taken. Try another.");
  } else if (username.length < 4) {
    response.status(400).send("Use 4 characters or more for your username.");
  } else if (!username.match(/^[A-Za-z0-9]+$/)) {
    response.status(400).send("Use letters or numbers only for your username.");
  } else if (password.length < 4) {
    response.status(400).send("Use 4 characters or more for your password.");
  } else {
    next();
  }
};
