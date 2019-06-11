const schema = require("../schema")
const schemaName = schema.name
const table = schema.table.reserv

exports.seed = function (knex, Promise) {
  // Deletes ALL existing entries
  return knex(`${schemaName}.${table}`).del()
    .then(function () {
      // Inserts seed entries
      return knex(`${schemaName}.${table}`).insert([{
          start_time: '2019-11-01 23:00:00',
          end_time: '2019-11-02 02:00:00',
          status: 'Booked',
          user_id: 1
        }
        //   start_date: '2019-11-10',
        //   end_date: '2019-11-10',
        //   start_time: '08:00:00',
        //   end_time: '10:00:00',
        //   status: 'Booked',
        //   user_id: 1
        // },
        // {
        //   start_date: '2019-11-10',
        //   end_date: '2019-11-10',
        //   start_time: '09:00:00',
        //   end_time: '10:00:00',
        //   status: 'Booked',
        //   user_id: 1
        // },
        // {
        //   start_date: '2019-11-10',
        //   end_date: '2019-11-10',
        //   start_time: '07:00:00',
        //   end_time: '11:00:00',
        //   status: 'Booked',
        //   user_id: 2
        // },
        // {
        //   start_date: '2019-11-10',
        //   end_date: '2019-11-10',
        //   start_time: '08:00:00',
        //   end_time: '09:00:00',
        //   status: 'Booked',
        //   user_id: 2
        // }
      ]);
    });
};