const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");

exports.getAllFacility = (request, response, next) => {
  const statement = `select * from meeteenew.facility`;

  pool.query(statement, (error, results) => {
    try {
      if (error) {
        console.log(error);
        throw new ErrorHandler(500, "Database Error");
      } else {
        response.status(200).send(results.rows);
      }
    } catch (error) {
      next(error);
    }
  });
};

exports.getFacilityCategoriesFromType = (request, response, next) => {
  const typeId = request.params.id;
  const statement = `select * from meeteenew.view_factype_detail as v
    where v.typeId = $1`;
  const value = [typeId];

  pool.query(statement, value, (error, results) => {
    try {
      if (typeId == null || !typeId.match(/^[0-9]+$/)) {
        throw new ErrorHandler(400, "Bad Request");
      } else if (error) {
        console.log(error);
        throw new ErrorHandler(500, "Database Error");
      } else {
        response.status(200).send(results.rows);
      }
    } catch (error) {
      next(error);
    }
  });
};
