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
        pg_connection: 'postgres://meetee_admin:meetee_admin@127.0.0.1:5432/meeteedb',
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
            timezone: '+07'
        },
        pg_connection: `postgres://${process.env.DB_USERNAME}:${process.env.DB_PASSWORD}@${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}`,
        pool: {
            afterCreate: function (connection, callback) {
                connection.query(`SET timezone = 'UTC-07';`, function (err) {
                    callback(err, connection);
                });
            }
        }
    }
}