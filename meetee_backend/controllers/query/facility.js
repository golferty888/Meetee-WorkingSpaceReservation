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

exports.getFacilityFromClass = (request, response) => {
  const typeId = request.params.id;
  console.log("--> Request /fac/type/:id: " + "params.id=" + typeId);

  const statement = `select v1.cateId, v1.cateName, v1.price, v1.capacity, v1.link_url, v1.typeId, v1.typeName from meeteenew.view_category_detail as v1
    where v1.typeId = ${typeId}
    order by v1.cateId`;

  pool.query(statement, (error, result) => {
    if (error) {
      throw error;
    }
    response.status(200).json(result.rows);
  });

  // Facility
  //     .query(qb => {
  //         qb.join('meeteenew.facility_category', 'facility.facility_category_id', 'facility_category.id')
  //         // qb.join('meeteenew.facility_class', 'facility_category.facility_class_id', 'facility_class.id')
  //         // qb.where('facility_class.id', '=', id)
  //         // qb.where('facility_category.id', '=', id)
  //     })
  //     .fetchAll()
  //     .then(data => {
  //         response.send(data)
  //     })
};

// exports.getFacilityCategory = (request, response) => {
//     FacilityClass
//         .forge({
//             id: request.params.id
//         })
//         .fetch({
//             withRelated: ['facilityCategories.equipments.equipment.class']
//         })
//         .then(data => response.json({
//             successful: true,
//             data
//         }))
// }

// exports.getFacilityCategoryEquipment = (request, response) => {
//     FacilityCategory
//         .forge({
//             id: request.params.id
//         })
//         .fetch({
//             withRelated: ['equipments']
//         })
//         .then(data => response.json({
//             successful: true,
//             data
//         }))
// }
