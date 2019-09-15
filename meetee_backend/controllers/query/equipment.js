const {
    Equipment
} = require('../../models/equipment')

exports.getFacilityCategoryEquipment = (request, response) => {
    Equipment
        .forge({
            id: request.params.id
        })
        .fetch({
            withRelated: ['facilityCategories']
        })
        .then(data => response.json({
            success: true,
            data
        }))
}