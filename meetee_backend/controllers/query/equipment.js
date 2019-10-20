const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});

exports.getFacilityCategoryDetail = (request, response) => {
  const cateId = parseInt(request.params.id);
  console.log("--> Request /fac/cate/:id " + "params.id=" + cateId);
  const statement = `SELECT * from meeteenew.view_faccate_detail
    WHERE cateId = $1`;
  const value = [cateId];
  pool.query(statement, value, (error, results) => {
    if (error) {
      response.status(500).send("Database Error");
    }
    response.status(200).send(results.rows[0]);
  });
};
