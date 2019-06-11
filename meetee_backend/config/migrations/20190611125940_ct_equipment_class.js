const schema = require("../schema")
const schemaName = schema.name
const mainTable = schema.table.equipment_class

exports.up = function (knex, Promise) {
    return Promise.all([
        knex.schema.createTable(`${schemaName}.${mainTable}`, function (table) {
            table.increments('id').primary();
            table.string('name').notNull();
        })
    ]);
};

exports.down = function (knex, Promise) {
    return knex.schema.dropTable(`${schemaName}.${mainTable}`)
};