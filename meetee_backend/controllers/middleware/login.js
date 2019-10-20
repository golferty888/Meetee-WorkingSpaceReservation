const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const bcrypt = require("bcrypt");

exports.middleware = async (request, response, next) => {
  const username = request.body.username;
  const userPassword = request.body.password;
  console.log("-------------------------------------------------------------");
  console.log({ request: "POST /login", body: JSON.stringify(request.body) });
  // เอา plainpassword มา encode แล้วไป query หา
  const statement = `select password from meeteenew.users
        where username = $1`;
  const values = [username];
  try {
    const dbPassword = await pool.query(statement, values);
    bcrypt.compare(
      userPassword,
      dbPassword.rows[0].password,
      (err, loginPass) => {
        if (loginPass) {
          next();
        } else {
          console.log(err);
          response.status(500).send("Login fail. Wrong username or password.");
        }
      }
    );
  } catch (error) {
    response.status(500).send("Login fail. Wrong username or password.");
    return;
  }
};
