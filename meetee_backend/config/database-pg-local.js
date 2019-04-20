require('dotenv').config({
  path: './.env'
});

var knex = require('knex')({
  client: process.env.DB_CLIENT,
  version: process.env.DB_LOCAL_VERSION,
  connection: {
    host: process.env.DB_LOCAL_HOST,
    user: process.env.DB_LOCAL_USERNAME,
    password: process.env.DB_LOCAL_PASSWORD,
    database: process.env.DB_NAME
  }
});

module.exports = knex;