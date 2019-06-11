const schema = require("../schema")
const schemaName = schema.name
const table = schema.table.equipment

exports.seed = function (knex, Promise) {
  // Deletes ALL existing entries
  return knex(`${schemaName}.${table}`).del()
    .then(function () {
      // Inserts seed entries
      return knex(`${schemaName}.${table}`).insert([{
          id: 1,
          name: 'Whiteboard size S',
          equipment_class_id: 1
        },
        {
          id: 2,
          name: 'Whiteboard size M',
          equipment_class_id: 1
        },
        {
          id: 3,
          name: 'Whiteboard size L',
          equipment_class_id: 1
        },
        {
          id: 4,
          name: 'Projector mini',
          equipment_class_id: 2
        },
        {
          id: 5,
          name: 'Projector',
          equipment_class_id: 2
        },
        {
          id: 6,
          name: 'Television',
          equipment_class_id: 2
        }
      ]);
    });
};