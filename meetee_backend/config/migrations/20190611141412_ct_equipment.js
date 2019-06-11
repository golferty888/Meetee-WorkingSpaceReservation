const schema = require("../schema")
const schemaName = schema.name
const mainTable = schema.table.equipment
const refTable = schema.table.equipment_class
const refColumn = schema.column.equip_ref_equipclass

exports.up = function (knex, Promise) {
    return Promise.all([
        knex.schema.createTable(`${schemaName}.${mainTable}`, function (table) {
            table.increments('id').primary();
            table.string('name').notNull();
            table.integer(`${refColumn}`)
                .unsigned()
                .notNull()
                .references('id')
                .inTable(`${schemaName}.${refTable}`)
                .onDelete('CASCADE');
        })
    ]);
};

exports.down = function (knex, Promise) {
    return knex.schema.dropTable(`${schemaName}.${mainTable}`)
};