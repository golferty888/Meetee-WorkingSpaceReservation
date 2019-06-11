const schema = require("../schema")
const schemaName = schema.name
const table = schema.table.user

exports.seed = function (knex, Promise) {
  // Deletes ALL existing entries
  return knex(`${schemaName}.${table}`).del()
    .then(function () {
      // Inserts seed entries
      return knex(`${schemaName}.${table}`).insert([{
          id: 1,
          username: 'tanapat128',
          first_name: 'Tanapat',
          last_name: 'Choochot',
          role: 'admin',
          email: 'pm.tanapat@gmail.com',
          phone_number: '0939452459',
          birthday: '2019-11-17'
        },
        {
          id: 2,
          username: 'panakit139',
          first_name: 'Panakit',
          last_name: 'Paokamol',
          role: 'admin',
          email: 'panakit.gulfz@gmail.com',
          phone_number: '0916295499',
          birthday: '2019-11-21'
        }
      ]);
    });
};