const Bookshelf = require('../database')
const Facility = require('../models/facility').model

exports.collection = Bookshelf.Collection.extend({
    model: Facility
})