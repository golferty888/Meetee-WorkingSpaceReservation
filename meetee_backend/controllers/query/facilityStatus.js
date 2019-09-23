const knex = require('../../config/connection')

exports.checkStatusEachFacilityClass = (request, response) => {
    const data = request.body
    const classId = data.classId
    const startDate = data.startDate;
    const startTime = data.startDate + ' ' + data.startTime
    const endTime = data.endDate + ' ' + data.endTime
    const status = 'Booked'
    const user_id = data.userId
    console.log(startTime + ' ' + endTime)

    const facilityInClassQuery =
        knex('meeteenew.facility as fac')
        .select('fac.id as facId', 'fac.code as code', 'fac.floor as floor', 'fac.facility_category_id as cateId')
        .join('meeteenew.facility_category as cate', 'fac.facility_category_id', '=', 'cate.id')
        .join('meeteenew.facility_class as class', 'cate.facility_class_id', '=', 'class.id')
        .where('class.id', '=', classId)
        .orderBy('facId');

    const unavailableQuery =
        knex('meeteenew.reservation as resv')
        .distinct('resv.facility_id as facId')
        .select('fac.code as code', 'fac.floor as floor', 'fac.facility_category_id as cateId')
        .join('meeteenew.facility as fac', 'resv.facility_id', '=', 'fac.id')
        .join('meeteenew.facility_category as cate', 'fac.facility_category_id', '=', 'cate.id')
        .join('meeteenew.facility_class as class', 'cate.facility_class_id', '=', 'class.id')
        .where('class.id', '=', classId)
        .whereNot('resv.status', 'Cancelled')
        .andWhere(function () {
            this.orWhere(
                knex.raw(`(TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') OVERLAPS (resv.start_time, resv.end_time)`)
            )
        })
        .orderBy('facId');

    facilityInClassQuery.then(facAll => {
        assignStatusFacList(facAll)
        unavailableQuery.then(facUna => {
                updateStatusFacList(facAll, facUna)
                response.send(facAll)
            })
            .catch(error => {
                console.log(error)
                response.status(400).send('Bad request')
            })
    })
}

exports.checkStatusAllFacilities = (request, response) => {
    const data = request.body
    const startDate = data.startDate;
    const startTime = data.startDate + ' ' + data.startTime
    const endTime = data.endDate + ' ' + data.endTime
    const status = 'Booked'
    const user_id = data.userId
    console.log("checkStatusAllFac: " + startTime + ' ' + endTime)

    const allFacilityQuery =
        knex('meeteenew.facility as fac')
        .select('fac.id as facId', 'fac.code as code', 'fac.floor as floor', 'fac.facility_category_id as cateId')
        .orderBy('facId');

    const unavailableQuery =
        knex('meeteenew.reservation as resv')
        .distinct('resv.facility_id as facId')
        .select('fac.code as code', 'fac.floor as floor', 'fac.facility_category_id as cateId')
        .join('meeteenew.facility as fac', 'resv.facility_id', '=', 'fac.id')
        .whereNot('resv.status', 'Cancelled')
        .andWhere(function () {
            this.orWhere(
                knex.raw(`(TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') OVERLAPS (resv.start_time, resv.end_time)`)
            )
        })
        .orderBy('facId');

    allFacilityQuery.then(facAll => {
        assignStatusFacList(facAll)
        unavailableQuery.then(facUna => {
                updateStatusFacList(facAll, facUna)
                response.send(facAll)
            })
            .catch(error => {
                console.log(error)
                response.status(400).send('Bad request')
            })
    })
}

function assignStatusFacList(facList) {
    console.log("FacList Length: " + facList.length)
    for (i = 0; i < facList.length; i++) {
        facList[i] = Object.assign(facList[i], {
            status: "available"
        })
    }
}

function updateStatusFacList(facAll, facUna) {
    console.log("UnavailableList: " + JSON.stringify(facUna))
    for (i = 0; i < facUna.length; i++) {
        for (j = 0; j < facAll.length; j++) {
            if (facUna[i].code == facAll[j].code) {
                facAll[j].status = "unavailable"
            }
        }
    }
}

exports.checkUnavailability = (request, response) => {
    const type = request.body.type;
    const data = request.body
    const startDate = data.startDate;
    const startTime = data.startDate + ' ' + data.startTime
    const endTime = data.endDate + ' ' + data.endTime
    const status = 'Booked'
    const user_id = data.userId
    console.log(type)
    console.log(startTime + ' ' + endTime)

    const unavailableQuery =
        knex('meeteenew.reservation as resv')
        .distinct('resv.facility_id as facId')
        .select('facility.code as code', 'fac.floor as floor', 'fac.facility_category_id as categoryIdd')
        .join('meeteenew.facility as fac', 'resv.facility_id', '=', 'fac.id')
        .where('facility.facility_category_id', '=', type)
        .andWhereNot('resv.status', 'Cancelled')
        // .andWhere('resv.start_date', '=', startDate)
        .andWhere(function () {
            this.orWhere(
                knex.raw(`(TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') OVERLAPS (resv.start_time, resv.end_time)`)
            )
        })
        .then(data => response.send(data))
        .catch(error => {
            console.log(error)
            response.status(400).send('Bad request')
        })
    // knex('meeteenew.reservation as resv')
    // .distinct('resv.facility_id as facId')
    // .select('facility.code as code', 'facility.floor', 'facility.facility_category_id')
    // // for mutiple-choose .join('meeteenew.reservation_detail as detail', 'resv.id', '=', 'detail.reservation_id')
    // .join('meeteenew.facility as facility', 'resv.facility_id', '=', 'facility.id')
    // .where('facility.facility_category_id', '=', type)
    // // .andWhere('resv.start_date', '=', startDate)
    // .andWhere(function () {
    //     this.orWhere(
    //         knex.raw(`(TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') OVERLAPS (resv.start_time, resv.end_time)`)
    //     )
    // })
}

exports.checkAvailability = (request, response) => {
    const type = request.body.type;
    const startDate = request.body.startDate;
    const endDate = request.body.endDate;
    const startTime = request.body.startTime;
    const endTime = request.body.endTime;
    console.log(startTime + ' ' + endTime)

    const unavailableQuery =
        knex('meeteenew.reservation as resv')
        .distinct('resv.facility_id')
        .join('meeteenew.facility as facility', 'resv.facility_id', '=', 'facility.id')
        .where('facility.facility_category_id', '=', type)
        .andWhere('resv.start_date', '=', startDate)
        .andWhere(function () {
            this.orWhere(
                knex.raw(`(TIMESTAMP '${startTime}', TIME '${endTime}') OVERLAPS (resv.start_time, resv.end_time)`)
            )
        })

    const availableQuery =
        knex
        .select('facility.id as roomId', 'facility.code as roomCode', 'facility.floor as floor', 'facility.facility_category_id as roomType')
        .from('meeteenew.facility as facility')
        .where('facility.facility_category_id', '=', type)
        .andWhere('facility.id', 'NOT IN', unavailableQuery)
        .orderBy('facility.id')
        .then(data => response.json({
            successful: true,
            data
        }))
        .catch(error => {
            console.log(error)
            response.status(400).send('Bad request')
        })
}