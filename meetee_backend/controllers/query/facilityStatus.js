const knex = require('../../config/connection')

exports.checkStatusAvaialableEachFacilityCategory = (request, response) => {
    const data = request.body
    console.log("--> Request facility/category/status: " + JSON.stringify(data))
    const cateId = data.cateId
    const startDate = data.startDate
    const startTime = data.startDate + ' ' + data.startTime
    const endTime = data.endDate + ' ' + data.endTime
    const status = 'Booked'
    const user_id = data.userId

    const unavailableQuery =
        knex('meeteenew.reservation as resv')
        .distinct('resv.facility_id as id')
        // .select('fac.code as code', 'fac.floor as floor', 'cate.id as cateId', 'cate.name as cateName')
        .join('meeteenew.facility as fac', 'resv.facility_id', '=', 'fac.id')
        .join('meeteenew.facility_category as cate', 'fac.facility_category_id', '=', 'cate.id')
        .where('cate.id', '=', cateId)
        .whereNot('resv.status', 'Cancelled')
        .andWhere(function () {
            this.orWhere(
                knex.raw(`(TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') OVERLAPS (resv.start_time, resv.end_time)`)
            )
        })
        .orderBy('id')

    const availiaQuery =
        knex('meeteenew.facility as fac')
        .select('fac.id as facId', 'fac.code as code', 'fac.floor as floor', 'cate.id as cateId', 'cate.name as cateName')
        .join('meeteenew.facility_category as cate', 'fac.facility_category_id', '=', 'cate.id')
        .where('cate.id', '=', cateId)
        .andWhere('fac.id', 'NOT IN', unavailableQuery)
        .orderBy('facId')
        .then(data => {
            response.send(data)
        })
        .catch(error => {
            console.log(error)
            response.status(400).send('Bad request')
        });
}

exports.checkStatusEachFacilityCategory = (request, response) => {
    const data = request.body
    console.log("--> Request facility/category/status: " + JSON.stringify(data))
    const cateId = data.cateId
    const startDate = data.startDate
    const startTime = data.startDate + ' ' + data.startTime
    const endTime = data.endDate + ' ' + data.endTime
    const status = 'Booked'
    const user_id = data.userId

    const facilityListInCategory =
        knex('meeteenew.facility as fac')
        .select('fac.id as facId', 'fac.code as code', 'fac.floor as floor', 'cate.id as cateId', 'cate.name as cateName')
        .join('meeteenew.facility_category as cate', 'fac.facility_category_id', '=', 'cate.id')
        .where('cate.id', '=', cateId)
        .orderBy('facId')
        .catch(error => {
            console.log(error)
            response.status(400).send('Bad request')
        });

    const unavailableQuery =
        knex('meeteenew.reservation as resv')
        .distinct('resv.facility_id as facId')
        .select('fac.code as code', 'fac.floor as floor', 'cate.id as cateId', 'cate.name as cateName')
        .join('meeteenew.facility as fac', 'resv.facility_id', '=', 'fac.id')
        .join('meeteenew.facility_category as cate', 'fac.facility_category_id', '=', 'cate.id')
        .where('cate.id', '=', cateId)
        .whereNot('resv.status', 'Cancelled')
        .andWhere(function () {
            this.orWhere(
                knex.raw(`(TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') OVERLAPS (resv.start_time, resv.end_time)`)
            )
        })
        .orderBy('facId')
        .catch(error => {
            console.log(error)
            response.status(400).send('Bad request')
        });

    facilityListInCategory.then(facList => {
        assignStatusFacList(facList)
        unavailableQuery.then(facUna => {
                updateStatusFacList(facList, facUna)
                response.send(facList)
            })
            .catch(error => {
                console.log(error)
                response.status(400).send('Bad request')
            })
    })
}

exports.checkStatusEachFacilityClass = (request, response) => {
    const data = request.body
    console.log("--> Request facility/class/status: " + JSON.stringify(data))
    const classId = data.classId
    const startDate = data.startDate;
    const startTime = data.startDate + ' ' + data.startTime
    const endTime = data.endDate + ' ' + data.endTime
    const status = 'Booked'
    const user_id = data.userId
    console.log(startTime + ' ' + endTime)

    const facilityInClassQuery =
        knex('meeteenew.facility as fac')
        .select('fac.id as facId', 'fac.code as code', 'fac.floor as floor', 'cate.id as cateId', 'cate.name as cateName')
        .join('meeteenew.facility_category as cate', 'fac.facility_category_id', '=', 'cate.id')
        .join('meeteenew.facility_class as class', 'cate.facility_class_id', '=', 'class.id')
        .where('class.id', '=', classId)
        .orderBy('facId');

    const unavailableQuery =
        knex('meeteenew.reservation as resv')
        .distinct('resv.facility_id as facId')
        .select('fac.code as code', 'fac.floor as floor', 'cate.id as cateId', 'cate.name as cateName')
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
        .orderBy('facId')
        .catch(error => {
            console.log(error)
            response.status(400).send('Bad request')
        });

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
    console.log("--> Request facility/all/status: " + JSON.stringify(data))
    const startDate = data.startDate;
    const startTime = data.startDate + ' ' + data.startTime
    const endTime = data.endDate + ' ' + data.endTime
    const status = 'Booked'
    const user_id = data.userId

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
        .orderBy('facId')
        .catch(error => {
            console.log(error)
            response.status(400).send('Bad request')
        });

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
    for (i = 0; i < facList.length; i++) {
        facList[i] = Object.assign(facList[i], {
            status: "available"
        })
    }
}

function updateStatusFacList(facAll, facUna) {
    for (i = 0; i < facUna.length; i++) {
        for (j = 0; j < facAll.length; j++) {
            if (facUna[i].code == facAll[j].code) {
                facAll[j].status = "unavailable"
            }
        }
    }
}

exports.checkUnavailability = (request, response) => {
    const data = request.body;
    const cateId = body.cateId;
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
        .where('facility.facility_category_id', '=', cateId)
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
}