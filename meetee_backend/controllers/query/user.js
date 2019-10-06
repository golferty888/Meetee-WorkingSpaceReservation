const knex = require('../../config/connection')
const {
    User
} = require('../../models/user')

exports.getReservationHistoryList = (request, response) => {
    const id = request.body.userId;
    knex.select('resv.id as reservId' , 'fac.id as facId', 'cate.name', 'fac.code', 'fac.floor', 'resv.start_time', 'resv.end_time', 'resv.status', 'cate.price')
        .from('meeteenew.user as user')
        .join('meeteenew.reservation as resv', 'user.id', '=', 'resv.user_id')
        .join('meeteenew.facility as fac', 'resv.facility_id', '=', 'fac.id')
        .join('meeteenew.facility_category as cate', 'fac.facility_category_id', '=', 'cate.id')
        .where('user.id', '=', id)
        .orderBy('resv.id', 'desc')
        .then(data => {
            response.send(data)
        })
}

exports.getReservationHistory = (request, response) => {
    User
        .forge({
            id: request.body.userId
        })
        .fetch({
            withRelated: ['historyList']
        })
        .then(data => {
            response.send(data)
        })
}