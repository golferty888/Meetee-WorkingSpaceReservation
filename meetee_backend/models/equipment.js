const Bookshelf = require('../database')
const {
    FacilityCategory,
    EquipmentFacilityCategory
} = require('./facility')

const Equipment = Bookshelf.Model.extend({
    tableName: 'meeteenew.equipment',
    facilityCategories() {
        return this.belongsTo(EquipmentFacilityCategory)
    }
})

module.exports = {
    Equipment,
    FacilityCategory
}