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

app.post('/check/available', (request, response) => {
    const startDate = request.body.startDate;
    const endDate = request.body.endDate;
    const startTime = request.body.startTime;
    const endTime = request.body.endTime;

    var subQuery = knex.select('room_id').from('meetee.reservation')
        .where('start_date', '=', startDate)
        .andWhere(function () {
            this.whereBetween('start_time', [startTime, endTime])
                .orWhereBetween('end_time', [startTime, endTime])
        })

    knex('meetee.reservation')
        .rightJoin('meetee.rooms', 'reservation.room_id', '=', 'rooms.id')
        .whereNotIn('rooms.id', subQuery)
        .orderBy('rooms.id')
        .distinct('rooms.id', 'rooms.code')
        .then((results) => {
            response.send(results);
        })
        .catch((error) => {
            response.send(error);
        })
})

app.post('/reserve', (request, response) => {
    const userId = request.body.userId;
    const roomId = request.body.roomId;
    const startDate = request.body.startDate;
    const endDate = request.body.endDate;    
    var startTime = request.body.startTime;
    startTime = startTime.substr(0,6) + '01';
    const endTime = request.body.endTime;
    knex('meetee.reservation')
        .returning('id', 'room_id', 'user_id', 'start_date', 'start_time', 'end_date', 'end_time')
        .insert([{
            user_id: userId,
            room_id: roomId,
            start_date: startDate,
            end_date: endDate,
            start_time: startTime,
            end_time: endTime
        }])
        .then((result) => {
            response.send(result);
        })
        .catch((error) => {
            response.send(error);
        })
});

app.get('/view/rooms', (request, response) => {
    knex('meetee.rooms')
        .join('meetee.roomtypes', 'rooms.roomtype_id', '=', 'roomtypes.id')
        .where('roomtypes.category_id', '1')
        .select('rooms.id', 'rooms.code', 'roomtypes.name', 'roomtypes.price', 'roomtypes.capacity', 'rooms.floor')
        .then((results) => {
            response.send(results);
        }).catch((error) => {
            response.send(error);
        })
});

app.get('/view/seats', (request, response) => {
    knex('meetee.rooms')
        .join('meetee.roomtypes', 'rooms.roomtype_id', '=', 'roomtypes.id')
        .where('roomtypes.category_id', '2')
        .select('rooms.id', 'rooms.code', 'roomtypes.name', 'roomtypes.price', 'roomtypes.capacity', 'rooms.floor')
        .then((results) => {
            response.send(results);
        }).catch((error) => {
            response.send(error);
        })
});

app.listen(PORT, URL, () => {
    console.log(`Listening on PORT: ${PORT} > ${process.env.NODE_ENV} > ${process.env.DB_LOCAL_HOST}`);
})