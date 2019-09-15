const Bookshelf = require('../database')
// const FacilityClass = require('../models/facilityClass').model
const FacilityClass = require('../models/facility').FacilityClass

exports.collection = Bookshelf.Collection.extend({
    model: FacilityClass
})