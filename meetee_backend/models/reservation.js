const Bookshelf = require('../database')
require('./user')

const Reservation = Bookshelf.Model.extend({
    tableName: 'meeteenew.reservation',
    reservationDetail() {
        return this.hasMany(ReservationDetail, 'reservation_id')
    },
    user() {
        return this.belongsTo('User', 'user_id')
    }
})

const Facility = Bookshelf.Model.extend({
    tableName: 'meeteenew.facility',
    reservationDetail() {
        return this.hasMany(ReservationDetail, 'facility_id')
    }
})

const ReservationDetail = Bookshelf.Model.extend({
    tableName: 'meeteenew.reservation_detail',
    reservations() {
        return this.belongsTo(Reservation, 'reservation_id')
    },
    facilities() {
        return this.belongsTo(Facility, 'facility_id')
    }
})

module.exports = {
    Facility,
    Reservation,
    ReservationDetail
}, Bookshelf.model('Reservation', Reservation)