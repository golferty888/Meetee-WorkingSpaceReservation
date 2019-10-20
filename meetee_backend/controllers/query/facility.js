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

  const statement = `select v1.cateId, v1.cateName, v1.price, v1.capacity, v1.link_url, v1.typeId, v1.typeName from meeteenew.view_factype_detail as v1
    where v1.typeId = ${typeId}
    order by v1.cateId`;

  pool.query(statement, (error, result) => {
    if (error) {
      response.status(500).send("Database Error");
      throw error;
    }
    response.status(200).json(result.rows);
  });
};
