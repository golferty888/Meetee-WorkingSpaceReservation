const { Pool } = require("pg");
const connectionString = process.env.POSTGRES_CONNECTION_URL;
const pool = new Pool({
  connectionString: connectionString
});

exports.getFacilityCategoryDetail = (request, response) => {
  const cateId = parseInt(request.params.id);
  console.log("--> Request /fac/type/:id/detail " + "params.id=" + cateId);
  const queryText = `SELECT * FROM meeteenew.view_faccate_detail as v
    WHERE cateId = ${cateId}`;
  pool.query(queryText, (error, results) => {
    const eqList = [];
    if (error) {
      console.log(error);
      response.status(500).send('Database Error')
    }
    const capacity = results.rows[0].capacity;
    const price = parseFloat(results.rows[0].price);
    const linkUrl = results.rows[0].link_url;

    results.rows.forEach(element => {
      eqList.push(element.eqname);
    });
    console.log(eqList);
    // response.status(200).send(results.rows[0].eqname);
    response.status(200).send({
      cateId: cateId,
      capacity: capacity,
      price: price,
      linkUrl: linkUrl,
      eqList: eqList
    });
  });
};
