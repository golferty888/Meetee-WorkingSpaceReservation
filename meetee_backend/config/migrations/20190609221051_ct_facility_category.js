const schema = require("../schema")
const schemaName = schema.name
const mainTable = schema.table.facility_category
const refTable = schema.table.facility_class
const refColumn = schema.column.faccate_ref_facclass

exports.up = function (knex, Promise) {
    return Promise.all([
        knex.schema.createTable(`${schemaName}.${mainTable}`, function (table) {
            table.increments('id').primary();
            table.string('name').notNull();
            table.string('code').notNull();
            table.string('capacity').notNull();
            table.decimal('price', 8, 2).notNull();
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