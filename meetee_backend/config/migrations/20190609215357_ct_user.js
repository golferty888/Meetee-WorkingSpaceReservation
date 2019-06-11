const schema = require("../schema")
const schemaName = schema.name
const mainTable = schema.table.user

exports.up = function (knex, Promise) {
    return Promise.all([
        knex.schema.createTable(`${schemaName}.${mainTable}`, function (table) {
            table.increments('id').primary();
            table.string('username').unique();
            table.string('first_name');
            table.string('last_name');
            table.string('role');
            table.string('email').unique();
            table.string('phone_number').unique();
            table.date('birthday');
            table.jsonb('meta');
            table.timestamp('updated_at').defaultTo(knex.fn.now());
            table.timestamp('created_at').defaultTo(knex.fn.now());
        })
    ]);
};

exports.down = function (knex, Promise) {
    return knex.schema.dropTable(`${schemaName}.${mainTable}`)
};