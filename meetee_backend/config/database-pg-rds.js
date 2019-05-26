require('dotenv').config({
  path: '../.env'
});

var knex = require('knex')({
  client: process.env.DB_CLIENT,
  version: '10.6',
  connection: {
    host: process.env.DB_HOST,
    user: process.env.DB_USERNAME,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
  }
});

module.exports = knex;