var knex = require("../../app").knex;

const getReservationHistoryList = (request, response) => {
    const id = request.body.userId;

    knex.select().from('meetee.users as user')
    .join('meetee.reservation as resv', 'resv.user_id', '=', 'user.id')
    .where('user.id', '=', id)
    .orderBy('resv.id', 'desc')
    .then(results => response.json({
        results
    }))
}

module.exports = {
    getReservationHistoryList
}