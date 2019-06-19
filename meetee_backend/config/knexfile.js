require('dotenv').config({
    path: '../.env'
});

module.exports = {
    development: {
        client: 'pg',
        version: '10.7',
        connection: {
            host: 'localhost',
            user: 'meetee_admin',
            password: 'meetee_admin',
            database: 'meeteedb',
            schema: 'meeteenew',
            charset: 'utf8',
            timezone: '+07'
        },
        pool: {
            afterCreate: function (connection, callback) {
                connection.query(`SET timezone = 'UTC-07';`, function (err) {
                    callback(err, connection);
                });
            }
        }
    },
    production: {
        client: 'pg',
        version: '10.6',
        connection: {
            host: process.env.DB_HOST,
            user: process.env.DB_USERNAME,
            password: process.env.DB_PASSWORD,
            database: process.env.DB_NAME,
            schema: 'meetee'
        },
        migrations: {
            directory: '../knex/migrations'
        }
    }
}