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
          capacity: '5',
          price: 120,
          facility_class_id: 1
        },
        {
          id: 2,
          name: 'Meeting Room M',
          code: 'MM',
          capacity: '9',
          price: 150,
          facility_class_id: 1
        },
        {
          id: 3,
          name: 'Meeting Room L',
          code: 'ML',
          capacity: '17',
          price: 200,
          facility_class_id: 1
        },
        {
          id: 4,
          name: 'Normal Seat',
          code: 'NS',
          capacity: '1',
          price: 30,
          facility_class_id: 2
        },
        {
          id: 5,
          name: 'Sofa',
          code: 'SS',
          capacity: '1',
          price: 40,
          facility_class_id: 2
        }
      ]);
    });
};