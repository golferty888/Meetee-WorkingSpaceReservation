const {
  Facility,
  FacilityCategory,
  FacilityClass
} = require("../../models/facility");

const { Pool } = require("pg");
const connectionString = process.env.POSTGRES_CONNECTION_URL;
const pool = new Pool({
  connectionString: connectionString
});

exports.getAllFacility = (request, response) => {
  Facility.forge()
    .fetchAll({
      withRelated: ["facilityCategory"]
    })
    .then(data => {
      response.send(data);
    });
};

exports.getAllFacilityCategory = (request, response) => {
  FacilityCategory.forge()
    .fetchAll({
      // columns: ['id'],
      withRelated: ["facilityClass"],
      withRelated: [
        {
          "equipments.equipment": function(qb) {
            qb.column("equipment.id", "equipment.name");
          }
        }
      ]
    })
    .then(data => {
      response.send(data);
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
      response.status(500).send('Database Error')
      throw error;
    }
    response.status(200).json(result.rows);
  });
};