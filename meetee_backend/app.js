const dotenv = require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
if (process.env.NODE_ENV == 'production') {
    var knex = require('./config/database-pg-rds');
    var PORT = process.env.PORT || 9000;
} else if (process.env.NODE_ENV == 'development') {
    var knex = require('./config/database-pg-local');
    var PORT = process.env.PORT || 8000;
}
const URL = process.env.URL;

const app = express();
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(cors({ origin: true }));

app.get('/', (request, response) => {
    response.send('Meetee welcome!');
});

app.listen(PORT, URL, () => {
    console.log(`Listening on PORT: ${PORT} > ${process.env.NODE_ENV} > ${process.env.DB_LOCAL_HOST}`);
})