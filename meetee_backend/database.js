'use strict'

var knex = require('./config/connection')
var bookshelf = require('bookshelf')(knex)
var jsonColumns = require('bookshelf-json-columns')

bookshelf.plugin('registry')
bookshelf.plugin(jsonColumns)

module.exports = bookshelf