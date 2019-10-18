const knex = require('../../config/connection')
const {
    User
} = require('../../models/user')

exports.getReservationHistoryList = (request, response) => {
    console.log("getHistory")
    const id = request.body.userId;
    knex('meeteenew.users as user')
        .select(knex.raw(`
        resv.id as reservId, 
        fac.id as facId, 
        cate.name, 
        fac.code, 
        fac.floor, 
        cate.price as price, 
        meeteenew.date_format1(resv.start_time) as date, 
        meeteenew.time_period(resv.start_time, resv.end_time) as period, 
        meeteenew.hour_cal(resv.start_time, resv.end_time) as hour, 
        meeteenew.price_over_hours(cate.price, resv.start_time, resv.end_time) as total_price, 
        resv.status`))
        .join('meeteenew.reservation as resv', 'user.id', '=', 'resv.user_id')
        .join('meeteenew.facility as fac', 'resv.facility_id', '=', 'fac.id')
        .join('meeteenew.facility_category as cate', 'fac.facility_category_id', '=', 'cate.id')
        .where('user.id', '=', id)
        .orderBy('resv.id', 'desc')
        .then(data => {
            response.send(data)
        })
        .catch(error => {
            console.log(error)
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