const Bookshelf = require('../database')
const {
    FacilityCategory
} = require('./facility')

const Equipment = Bookshelf.Model.extend({
    tableName: 'meeteenew.equipment',
    facilityCategories() {
        return this.belongToMany(FacilityCategory)
    }
})

FacilityCategory({
    equipments() {
        return this.belongToMany(Equipment)
    }
})

module.exports = {
    Equipment,
    FacilityCategory
}