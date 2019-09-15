const schema = require("../schema")
const schemaName = schema.name
const table = schema.table.reserv_detail

exports.seed = function (knex, Promise) {
  // Deletes ALL existing entries
  // return knex(`${schemaName}.${table}`).del()
  //   .then(function () {
  //     // Inserts seed entries
  //     // return knex(`${schemaName}.${table}`).insert([{
  //     //     reservation_id: 10001,
  //     //     facility_id: 1
  //     //   },
  //     //   {
  //     //     reservation_id: 10001,
  //     //     facility_id: 2
  //     //   },
  //     //   {
  //     //     reservation_id: 10001,
  //     //     facility_id: 3
  //     //   }
  //     // ]);
  //   });
};