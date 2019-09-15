const schema = require("../schema")
const schemaName = schema.name
const mainTable = schema.table.reserv_detail
const refTable1 = schema.table.reserv
const refTable2 = schema.table.facility
const refColumn1 = schema.column.reservline_ref_reserv
const refColumn2 = schema.column.reservline_ref_facility

exports.up = function (knex, Promise) {
    // return Promise.all([
    //     knex.schema.createTable(`${schemaName}.${mainTable}`, function (table) {
    //         table.integer(`${refColumn1}`)
    //             .unsigned()
    //             .notNull()
    //             .references('id')
    //             .inTable(`${schemaName}.${refTable1}`)
    //             .onDelete('CASCADE');
    //         table.integer(`${refColumn2}`)
    //             .unsigned()
    //             .notNull()
    //             .references('id')
    //             .inTable(`${schemaName}.${refTable2}`)
    //             .onDelete('CASCADE');
    //         table.unique([`${refColumn1}`, `${refColumn2}`]);
    //     })
    // ]);
};

exports.down = function (knex, Promise) {
    // return knex.schema.dropTable(`${schemaName}.${mainTable}`)
};