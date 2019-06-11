module.exports = {
    name: 'meeteenew',
    table: {
        user: 'user',
        facility_class: 'facility_class',
        facility_category: 'facility_category',
        facility: 'facility',
        reserv: 'reservation',
        reserv_detail: 'reservation_detail',
        equipment_class: 'equipment_class',
        equipment: 'equipment',
        facility_equipment: 'facility_has_equipments'
        // user: 'users',
        // category: 'categories',
        // facility_type: 'room_types',
        // facility: 'rooms',
        // reserv: 'reservation',
        // reserv_facility: 'reservation_has_facilities',
        // equip_type: 'equipment_type',
        // equip: 'equipment',
    },
    column: {
        faccate_ref_facclass: 'facility_class_id',
        fac_ref_factcate: 'facility_category_id',
        reserv_ref_user: 'user_id',
        reservline_ref_facility: 'facility_id',
        reservline_ref_reserv: 'reservation_id',
        equip_ref_equipclass: 'equipment_class_id',
        fac_equip_ref_faccate: 'facility_category_id',
        fac_equip_ref_equip: 'equipment_id',
    }
}