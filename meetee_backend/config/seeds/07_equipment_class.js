const schema = require("../schema")
const schemaName = schema.name
const table = schema.table.equipment_class

exports.seed = function (knex, Promise) {
  // Deletes ALL existing entries
  return knex(`${schemaName}.${table}`).del()
    .then(function () {
      // Inserts seed entries
      return knex(`${schemaName}.${table}`).insert([{
          id: 1,
          name: 'Stationary'
        },
        {
          id: 2,
          name: 'Electronic'
        },
        {
          id: 3,
          name: 'Furniture'
        }
      ]);
    });
};