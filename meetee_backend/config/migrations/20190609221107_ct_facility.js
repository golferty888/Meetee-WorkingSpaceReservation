const schema = require("../schema")
const schemaName = schema.name
const mainTable = schema.table.facility
const refTable = schema.table.facility_category
const refColumn = schema.column.fac_ref_factcate

exports.up = function (knex, Promise) {
    return Promise.all([
        knex.schema.createTable(`${schemaName}.${mainTable}`, function (table) {
            table.increments('id').primary();
            table.string('code').notNull();
            table.string('floor').notNull();
            table.integer(`${refColumn}`)
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