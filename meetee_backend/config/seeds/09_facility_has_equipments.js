const schema = require("../schema")
const schemaName = schema.name
const table = schema.table.facility_equipment

exports.seed = function (knex, Promise) {
  // Deletes ALL existing entries
  return knex(`${schemaName}.${table}`).del()
    .then(function () {
      // Inserts seed entries
      return knex(`${schemaName}.${table}`).insert([{
          facility_category_id: 1,
          equipment_id: 1
        },
        {
          facility_category_id: 2,
          equipment_id: 2
        },
        {
          facility_category_id: 2,
          equipment_id: 4
        },
        {
          facility_category_id: 3,
          equipment_id: 3
        },
        {
          facility_category_id: 3,
          equipment_id: 5
        },
        {
          facility_category_id: 3,
          equipment_id: 6
        }
      ]);
    });
};