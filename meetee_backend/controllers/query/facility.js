const {
    Facility,
    FacilityCategory,
    FacilityClass
} = require('../../models/facility')

exports.getAllFacility = (request, response) => {
    Facility
        .forge()
        .fetch({
            withRelated: ['facilityCategory']
        })
        .then(data => response.json({
            successful: true,
            data
        }))
}

exports.getFacilityCategory = (request, response) => {
    FacilityClass
        .forge({
            id: request.params.id
        })
        .fetch({
            withRelated: ['facilityCategories.equipments.equipments']
        })
        .then(data => response.json({
            successful: true,
            data
        }))
}

exports.getFacilityCategoryEquipment = (request, response) => {
    FacilityCategory
        .forge({
            id: request.params.id
        })
        .fetch({
            withRelated: ['equipments.equipments']
        })
        .then(data => response.json({
            successful: true,
            data
        }))
}