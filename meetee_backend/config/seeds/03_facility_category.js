const schema = require("../schema")
const schemaName = schema.name
const table = schema.table.facility_category

exports.seed = function (knex, Promise) {
  // Deletes ALL existing entries
  return knex(`${schemaName}.${table}`).del()
    .then(function () {
      // Inserts seed entries
      return knex(`${schemaName}.${table}`).insert([{
          id: 1,
          name: 'Meeting Room S',
          code: 'MS',
          capacity: 4,
          price: 120,
          facility_class_id: 1
        },
        {
          id: 2,
          name: 'Meeting Room M',
          code: 'MM',
          capacity: 8,
          price: 250,
          facility_class_id: 1
        },
        {
          id: 3,
          name: 'Meeting Room L',
          code: 'ML',
          capacity: 12,
          price: 400,
          facility_class_id: 1
        },
        {
          id: 4,
          name: 'Single Chair',
          code: 'NS',
          capacity: 1,
          price: 30,
          facility_class_id: 2
        },
        {
          id: 5,
          name: 'Bar Table',
          code: 'NS',
          capacity: 1,
          price: 30,
          facility_class_id: 2
        },
        {
          id: 6,
          name: 'Single Sofa',
          code: 'SF',
          capacity: 1,
          price: 40,
          facility_class_id: 2
        },
        {
          id: 7,
          name: 'Twin Sofa',
          code: 'SF',
          capacity: 2,
          price: 60,
          facility_class_id: 2
        },
        {
          id: 8,
          name: 'Seminar Room',
          code: 'SM',
          capacity: 30,
          price: 950,
          facility_class_id: 3
        }
      ]);
    });
};