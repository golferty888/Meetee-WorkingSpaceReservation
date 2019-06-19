const knex = require('../../config/connection')
const {
    User
} = require('../../models/user')

exports.getReservationHistoryList = (request, response) => {
    const id = request.body.userId;
    knex.select().from('meetee.users as user')
        .join('meetee.reservation as resv', 'resv.user_id', '=', 'user.id')
        .where('user.id', '=', id)
        .orderBy('resv.id', 'desc')
        .then(results => response.json({
            results
        }))
}

exports.getReservationHistory = (request, response) => {
    User
        .forge({
            id: request.body.userId
        })
        .fetch({
            withRelated: ['historyList']
        })
        .then(data => response.json({
            successful: true,
            data
        }))
}