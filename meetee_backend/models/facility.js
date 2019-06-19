const Bookshelf = require('../database')

const Facility = Bookshelf.Model.extend({
    tableName: 'meeteenew.facility',
    facilityCategory() {
        return this.belongsTo(FacilityCategory, 'facility_category_id')
    }
})

const FacilityClass = Bookshelf.Model.extend({
    tableName: 'meeteenew.facility_class',
    facilityCategories() {
        return this.hasMany(FacilityCategory, 'facility_class_id');
    }
})

const FacilityCategory = Bookshelf.Model.extend({
    tableName: 'meeteenew.facility_category',
    facilities() {
        return this.hasMany(Facility, 'facility_category_id')
    },
    facilityClass() {
        return this.belongsTo(FacilityClass, 'facility_class_id')
    },
    equipments() {
        return this.hasMany(EquipmentFacilityCategory, 'facility_category_id')
    }
})

const Equipment = Bookshelf.Model.extend({
    tableName: 'meeteenew.equipment',
    facilityCategories() {
        return this.hasMany(EquipmentFacilityCategory, 'equipment_id')
    }
})

const EquipmentFacilityCategory = Bookshelf.Model.extend({
    tableName: 'meeteenew.facility_has_equipments',
    facilityCategories() {
        return this.belongsTo(FacilityCategory, 'facility_category_id')
    },
    equipments() {
        return this.belongsTo(Equipment, 'equipment_id')
    }
})

const EquipmentClass = Bookshelf.Model.extend({
    tableName: 'meeteenew.equipment_class',
    equipments() {
        const Equipment = require('./equipment').model
        return this.hasMany(Equipment, 'equipment_class_id')
    }
})

module.exports = {
    Facility,
    FacilityClass,
    FacilityCategory,
    Equipment,
    EquipmentFacilityCategory
}