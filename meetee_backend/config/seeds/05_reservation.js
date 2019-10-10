const schema = require("../schema");
const schemaName = schema.name;
const table = schema.table.reserv;

exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex(`${schemaName}.${table}`)
    .del()
    .then(
      function() {
        const reservList = [];
        var i = 4;
        reservList.push({
          facility_id: i,
          start_time: "2019-11-17" + " 08:00:00",
          end_time: "2019-11-17" + "  10:00:00",
          status: "Booked",
          user_id: 1
        });
        i = 8;
        reservList.push({
          facility_id: i,
          start_time: "2019-11-17" + " 08:00:00",
          end_time: "2019-11-17" + "  09:00:00",
          status: "Booked",
          user_id: 1
        });
        i = 17;
        reservList.push({
          facility_id: i,
          start_time: "2019-11-17" + " 08:00:00",
          end_time: "2019-11-17" + "  11:00:00",
          status: "Booked",
          user_id: 1
        });
        return knex(`${schemaName}.${table}`).insert(reservList);
        // Inserts seed entries
        // const reservList = [];
        // const amountOfFacilities = 22;
        // for (i = 1; i <= amountOfFacilities; i++) {
        //   for (j = 1; j <= 30; j++) {
        //     reservList.push({
        //       facility_id: i,
        //       start_time: '2019-11-' + j + ' 08:00:00',
        //       end_time: '2019-11-' + j + '  10:00:00',
        //       status: 'Booked',
        //       user_id: 1
        //     })
        //   }
        // }
        // for (i = 1; i <= amountOfFacilities; i++) {
        //   for (j = 1; j <= 31; j++) {
        //     reservList.push({
        //       facility_id: i,
        //       start_time: '2019-12-' + j + ' 08:00:00',
        //       end_time: '2019-12-' + j + '  10:00:00',
        //       status: 'Booked',
        //       user_id: 1
        //     })
        //   }
        // }
        // return knex(`${schemaName}.${table}`).insert(reservList);
        // for (i = 1; i < 40; i++) {
        //   reservList.push({
        //     facility_id: i,
        //     start_time: '2019-11-10 08:00:00',
        //     end_time: '2019-11-10 10:00:00',
        //     status: 'Booked',
        //     user_id: 1
        //   })
        // }
        // for (i = 1; i < 40; i++) {
        //   reservList.push({
        //     facility_id: i,
        //     start_time: '2019-11-11 08:00:00',
        //     end_time: '2019-11-11 10:00:00',
        //     status: 'Booked',
        //     user_id: 1
        //   })
        // }
        // for (i = 1; i < 40; i++) {
        //   reservList.push({
        //     facility_id: i,
        //     start_time: '2019-11-12 08:00:00',
        //     end_time: '2019-11-12 10:00:00',
        //     status: 'Booked',
        //     user_id: 1
        //   })
        // }
        // return knex(`${schemaName}.${table}`).insert(reservList);
      }
      // return knex(`${schemaName}.${table}`).insert([{
      //     facility_id: 1,
      //     start_time: '2019-11-10 11:00:00',
      //     end_time: '2019-11-10 12:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      //   {
      //     facility_id: 3,
      //     start_time: '2019-11-10 10:00:00',
      //     end_time: '2019-11-10 13:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      //   {
      //     facility_id: 5,
      //     start_time: '2019-11-10 08:00:00',
      //     end_time: '2019-11-10 10:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      //   {
      //     facility_id: 6,
      //     start_time: '2019-11-10 08:00:00',
      //     end_time: '2019-11-10 09:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      //   {
      //     facility_id: 3,
      //     start_time: '2019-11-10 08:00:00',
      //     end_time: '2019-11-10 09:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      //   {
      //     facility_id: 12,
      //     start_time: '2019-11-10 08:00:00',
      //     end_time: '2019-11-10 13:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      //   {
      //     facility_id: 10,
      //     start_time: '2019-11-10 09:00:00',
      //     end_time: '2019-11-10 11:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      //   {
      //     facility_id: 15,
      //     start_time: '2019-11-10 08:00:00',
      //     end_time: '2019-11-10 09:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      //   {
      //     facility_id: 14,
      //     start_time: '2019-11-10 10:00:00',
      //     end_time: '2019-11-10 13:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      //   {
      //     facility_id: 1,
      //     start_time: '2019-11-11 10:00:00',
      //     end_time: '2019-11-11 13:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      //   {
      //     facility_id: 2,
      //     start_time: '2019-11-11 10:00:00',
      //     end_time: '2019-11-11 13:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      //   {
      //     facility_id: 3,
      //     start_time: '2019-11-11 10:00:00',
      //     end_time: '2019-11-11 13:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      //   {
      //     facility_id: 4,
      //     start_time: '2019-11-11 10:00:00',
      //     end_time: '2019-11-11 13:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      //   {
      //     facility_id: 5,
      //     start_time: '2019-11-11 10:00:00',
      //     end_time: '2019-11-11 13:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      //   {
      //     facility_id: 6,
      //     start_time: '2019-11-11 10:00:00',
      //     end_time: '2019-11-11 13:00:00',
      //     status: 'Booked',
      //     user_id: 1
      //   },
      // {
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
      // ]);
    );
};
