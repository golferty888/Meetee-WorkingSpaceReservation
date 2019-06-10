const knex = require('knex')(
    require('./knexfile')[process.env.NODE_ENV]
)
module.exports = knex