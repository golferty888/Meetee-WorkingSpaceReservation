const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});

exports.getFacilityCategoryDetail = (request, response) => {
  const cateId = parseInt(request.params.id);
  console.log("--> Request /fac/type/:id/detail " + "params.id=" + cateId);
  const queryText = `SELECT cateId, cateName, capacity, price, link_url, array_agg(json_build_object('eqid', eqid,'eqname', eqname)) eqList
    from meeteenew.view_faccate_detail
    WHERE cateId = $1
    group by cateId, catename, capacity, price, link_url;`;
  const queryValue = [cateId];
  pool.query(queryText, queryValue, (error, results) => {
    const eqList = [];
    if (error) {
      response.status(500).send("Database Error");
    }
    response.status(200).send(results.rows[0]);
  });
};
