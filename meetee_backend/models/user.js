const Bookshelf = require('../database')
require('./reservation')

const User = Bookshelf.Model.extend({
    tableName: 'meeteenew.user',
    historyList() {
        return this.hasMany('Reservation', 'user_id')
    }
})

module.exports = {
    User
}, Bookshelf.model("User", User)