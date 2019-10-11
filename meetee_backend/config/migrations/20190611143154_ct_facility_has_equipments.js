const schema = require("../schema")
const schemaName = schema.name
const mainTable = schema.table.facility_equipment
const refTable1 = schema.table.facility_category
const refTable2 = schema.table.equipment
const refColumn1 = schema.column.fac_equip_ref_faccate
const refColumn2 = schema.column.fac_equip_ref_equip

exports.up = function (knex, Promise) {
    return Promise.all([
        knex.schema.createTable(`${schemaName}.${mainTable}`, function (table) {
            table.integer(`${refColumn1}`)
                .unsigned()
                .notNull()
                .references('id')
                .inTable(`${schemaName}.${refTable1}`)
                .onDelete('CASCADE');
            table.integer(`${refColumn2}`)
                .unsigned()
                .notNull()
                .references('id')
                .inTable(`${schemaName}.${refTable2}`)
                .onDelete('CASCADE');
            table.unique([`${refColumn1}`, `${refColumn2}`]);
        })
    ]);
};

exports.down = function (knex, Promise) {
    return knex.schema.dropTableIfExists(`${schemaName}.${mainTable}`)
};