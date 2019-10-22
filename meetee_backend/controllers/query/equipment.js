const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");

exports.getFacilityCategoryDetail = (request, response, next) => {
  const cateId = request.params.id;
  console.log("-------------------------------------------------------------");
  console.log({ request: "POST /fac/cate/:id", param: { cateId: cateId } });
  const statement = `SELECT * from meeteenew.view_faccate_detail
    WHERE cateId = $1`;
  const value = [cateId];
  pool.query(statement, value, (error, results) => {
    try {
      if (cateId == null || !cateId.match(/^[0-9]+$/)) {
        throw new ErrorHandler(400, "Bad Request");
      } else if (error) {
        console.log(error);
        throw new ErrorHandler(500, "Database Error");
      } else {
        response.status(200).send(results.rows);
      }
    } catch (error) {
      console.log(error);
      next(error);
    }
  });
};
