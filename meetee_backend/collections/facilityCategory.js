const Bookshelf = require('../database')
const FacilityCategory = require('../models/facility').FacilityCategory

exports.collection = Bookshelf.Collection.extend({
    model: FacilityCategory
})

