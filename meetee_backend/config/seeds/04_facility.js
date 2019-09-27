const schema = require("../schema")
const schemaName = schema.name
const table = schema.table.facility
const facility_category_id = schema.column.fac_factype_ref

exports.seed = function (knex, Promise) {
  // Deletes ALL existing entries
  return knex(`${schemaName}.${table}`).del()
    .then(function () {
      // Inserts seed entries
      const facilityList = [];
      const data = require("../../controllers/co-working-space.json")
      let i = 1;
      let runFacId = 1;
      // Meetingroom S
      while (i <= data.amount.ms) {
        facilityList.push({
          id: runFacId,
          // code: 'MS-' + i,
          code: i,
          floor: 1,
          facility_category_id: 1
        })
        runFacId++;
        i++;
      }
      // Meetingroom M
      i = 1;
      while (i <= data.amount.mm) {
        facilityList.push({
          id: runFacId,
          // code: 'MM-' + i,
          code: i,
          floor: 1,
          facility_category_id: 2
        })
        runFacId++;
        i++;
      }
      // Meetingroom L
      i = 1;
      while (i <= data.amount.ml) {
        facilityList.push({
          id: runFacId,
          // code: 'ML-' + i,
          code: i,
          floor: 1,
          facility_category_id: 3
        })
        runFacId++;
        i++;
      }
      // Seminarroom 
      i = 1;
      while (i <= data.amount.sm) {
        facilityList.push({
          id: runFacId,
          // code: 'SM-' + i,
          code: i,
          floor: 1,
          facility_category_id: 8
        })
        runFacId++;
        i++;
      }
      // Single Chair
      i = 1;
      while (i <= data.amount.ch_single) {
        facilityList.push({
          id: runFacId,
          // code: 'NSC-' + i,
          code: i,
          floor: 1,
          facility_category_id: 4
        })
        runFacId++;
        i++;
      }
      // Chair Bar Table
      i = 1;
      while (i <= data.amount.ch_bar_table) {
        facilityList.push({
          id: runFacId,
          // code: 'NSB-' + i,
          code: i,
          floor: 1,
          facility_category_id: 5
        })
        runFacId++;
        i++;
      }
      // Sofa Single
      i = 1;
      while (i <= data.amount.sf_single) {
        facilityList.push({
          id: runFacId,
          // code: 'SFS-' + i,
          code: i,
          floor: 1,
          facility_category_id: 6
        })
        runFacId++;
        i++;
      }
      // Sofa Twin
      i = 1;
      while (i <= data.amount.sf_twin) {
        facilityList.push({
          id: runFacId,
          // code: 'SFT-' + i,
          code: i,
          floor: 1,
          facility_category_id: 7
        })
        runFacId++;
        i++;
      }

      return knex(`${schemaName}.${table}`).insert(facilityList);

      // return knex(`${schemaName}.${table}`).insert([{
      //     id: 1,
      //     code: 'MS-101',
      //     floor: '1',
      //     facility_category_id: 1
      //   },
      //   {
      //     id: 2,
      //     code: 'MS-102',
      //     floor: '1',
      //     facility_category_id: 1
      //   },
      //   {
      //     id: 3,
      //     code: 'MS-103',
      //     floor: '1',
      //     facility_category_id: 1
      //   },
      //   {
      //     id: 4,
      //     code: 'MS-201',
      //     floor: '2',
      //     facility_category_id: 1
      //   },
      //   {
      //     id: 5,
      //     code: 'MS-202',
      //     floor: '2',
      //     facility_category_id: 1
      //   },
      //   {
      //     id: 6,
      //     code: 'MS-203',
      //     floor: '2',
      //     facility_category_id: 1
      //   },
      //   {
      //     id: 7,
      //     code: 'MM-101',
      //     floor: '1',
      //     facility_category_id: 2
      //   },
      //   {
      //     id: 8,
      //     code: 'MM-102',
      //     floor: '1',
      //     facility_category_id: 2
      //   },
      //   {
      //     id: 9,
      //     code: 'MM-201',
      //     floor: '2',
      //     facility_category_id: 2
      //   },
      //   {
      //     id: 10,
      //     code: 'MM-202',
      //     floor: '2',
      //     facility_category_id: 2
      //   },
      //   {
      //     id: 11,
      //     code: 'ML-101',
      //     floor: '1',
      //     facility_category_id: 3
      //   },
      //   {
      //     id: 12,
      //     code: 'ML-201',
      //     floor: '2',
      //     facility_category_id: 3
      //   },
      //   {
      //     id: 13,
      //     code: 'NS-A101',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 14,
      //     code: 'NS-A102',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 15,
      //     code: 'NS-A103',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 16,
      //     code: 'NS-A104',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 17,
      //     code: 'NS-A105',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 18,
      //     code: 'NS-A106',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 19,
      //     code: 'NS-A107',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 20,
      //     code: 'NS-A108',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 21,
      //     code: 'NS-A109',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 22,
      //     code: 'NS-A110',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 23,
      //     code: 'NS-B101',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 24,
      //     code: 'NS-B102',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 25,
      //     code: 'NS-B103',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 26,
      //     code: 'NS-B104',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 27,
      //     code: 'NS-B104',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 28,
      //     code: 'NS-B105',
      //     floor: '1',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 29,
      //     code: 'NS-C201',
      //     floor: '2',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 30,
      //     code: 'NS-C202',
      //     floor: '2',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 31,
      //     code: 'NS-C203',
      //     floor: '2',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 32,
      //     code: 'NS-C204',
      //     floor: '2',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 33,
      //     code: 'NS-C205',
      //     floor: '2',
      //     facility_category_id: 4
      //   },
      //   {
      //     id: 34,
      //     code: 'SS-D101',
      //     floor: '1',
      //     facility_category_id: 5
      //   },
      //   {
      //     id: 35,
      //     code: 'SS-D102',
      //     floor: '1',
      //     facility_category_id: 5
      //   },
      //   {
      //     id: 36,
      //     code: 'SS-D103',
      //     floor: '1',
      //     facility_category_id: 5
      //   },
      //   {
      //     id: 37,
      //     code: 'SS-D104',
      //     floor: '1',
      //     facility_category_id: 5
      //   },
      //   {
      //     id: 38,
      //     code: 'SS-D201',
      //     floor: '2',
      //     facility_category_id: 5
      //   },
      //   {
      //     id: 39,
      //     code: 'SS-D202',
      //     floor: '2',
      //     facility_category_id: 5
      //   }
      // ]);
    });
};