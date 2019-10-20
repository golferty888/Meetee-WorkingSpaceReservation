const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});

exports.getAllFacility = (request, response) => {
  const statement = `select * from meeteenew.facility`;

  pool.query(statement, (error, results) => {
    if (error) {
      response.status(500).send("Database Error");
    }
    response.status(200).json(results.rows);
  });
};

exports.getFacilityCategoriesFromType = (request, response) => {
  const typeId = request.params.id;
  console.log("--> Request /fac/type/:id: " + "params.id=" + typeId);

  const statement = `select * from meeteenew.view_factype_detail as v
    where v.typeId = $1`;
  const value = [typeId];

  pool.query(statement, value, (error, result) => {
    if (error) {
      response.status(500).send("Database Error");
      throw error;
    }
    response.status(200).json(result.rows);
  });
};
