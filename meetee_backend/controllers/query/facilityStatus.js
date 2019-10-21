const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});

exports.getAvaialableFacWithAmount = async (request, response) => {
  const data = request.body;
  console.log(
    "--> Request /facility/cate/xxxxxxxxxxxx: " + JSON.stringify(data)
  );
  const classId = data.classId;
  const cateId = data.cateId;
  const startDate = data.startDate;
  const startTime = data.startDate + " " + data.startTime;
  const endTime = data.startDate + " " + data.endTime;

  const statement1 = `select v1.classId, count(distinct v1.facId) :: int from meeteenew.view_fac_status as v1
  where
  (v1.inDate is null or (inDate = $1 and 
  (v1.status = $2 and not ((timestamp '${startTime}', timestamp '${endTime}') overlaps (v1.start_time, v1.end_time))) or
  (v1.status = $3 and ((timestamp '${startTime}', timestamp '${endTime}') overlaps (v1.start_time, v1.end_time)))))
  group by v1.classId
  order by 1 asc`;
  const values1 = [startDate, "Booked", "Cancelled"];

  pool.query(statement1, values1, (error, results) => {
    if (error) {
      response.status(500).send("Database Error");
    }
    response.status(200).json(results.rows);
  });

  // const statement2 = `select v1.cateId, count(distinct v1.facId) :: int from meeteenew.view_fac_status as v1
  // where
  // v1.classId = $1 and
  // (v1.inDate is null or (inDate = $2 and
  // (v1.status = $3 and not ((timestamp '${startTime}', timestamp '${endTime}') overlaps (v1.start_time, v1.end_time))) or
  // (v1.status = $4 and ((timestamp '${startTime}', timestamp '${endTime}') overlaps (v1.start_time, v1.end_time)))))
  // group by v1.cateId
  // order by 1 asc`;
  // const values2 = [classId, startDate, "Booked", "Cancelled"];

  // pool.query(statement2, values2, (error, results) => {
  //   if (error) {
  //     throw error;
  //   }
  //   output = results.rows;
  //   // response.status(200).json(output);
  //   console.log("Query is successful.");
  // });

  // const statement = `select distinct v1.facId, v1.code, v1.floor, v1.cateId ,v1.cateName
  // from meeteenew.view_fac_status as v1
  // where v1.cateId = $1 and
  // (v1.inDate is null or (inDate = $2 and
  // (v1.status = $3 and not ((timestamp '${startTime}', TIMESTAMP '${endTime}') overlaps (v1.start_time, v1.end_time))) or
  // (v1.status = $4 and ((timestamp '${startTime}', TIMESTAMP '${endTime}') overlaps (v1.start_time, v1.end_time)))))`;
  // const values = [cateId, startDate, "Booked", "Cancelled"];
  // pool.query(statement, values, (error, results) => {
  //   if (error) {
  //     throw error;
  //   }
  //   console.log(output);
  //   output = Object.assign(results.rows, output);
  //   response.status(200).json(output);
  //   console.log("Query is successful.");
  // });
};

exports.checkStatusAvaialableEachFacilityCategory = async (
  request,
  response
) => {
  const data = request.body;
  console.log("-------------------------------------------------------------");
  console.log({
    request: "POST /facility/cate/status/av",
    body: JSON.stringify(data)
  });
  const cateId = data.cateId;
  const startDate = data.startDate;
  const startTime = data.startDate + " " + data.startTime;
  const endTime = data.startDate + " " + data.endTime;
  // const statement = `select distinct v1.facId, v1.code, v1.floor, v1.cateId ,v1.cateName
  const statement = `select distinct v1.facId, v1.code, v1.floor, v1.cateId ,v1.cateName
  from meeteenew.view_fac_status as v1
  where cateId = $1 and facId not in
    (select distinct v1.facId 
    from meeteenew.view_fac_status as v1
    where v1.cateId = $1 and
    (inDate = $2 and
    (v1.status = $3 and ((timestamp '${startTime}', TIMESTAMP '${endTime}') overlaps (v1.start_time, v1.end_time))) or
    (v1.status = $4 and not ((timestamp '${startTime}', TIMESTAMP '${endTime}') overlaps (v1.start_time, v1.end_time)))))`;
  const values = [cateId, startDate, "Booked", "Cancelled"];
  pool.query(statement, values, (error, results) => {
    if (error) {
      response.status(500).send("Database Error");
    }
    response.status(200).json(results.rows);
  });
};

exports.checkStatusEachFacilityCategory = (request, response) => {
  const data = request.body;
  console.log("-------------------------------------------------------------");
  console.log({
    request: "POST /facility/category/status",
    body: JSON.stringify(data)
  });
  const cateId = data.cateId;
  const startDate = data.startDate;
  const startTime = data.startDate + " " + data.startTime;
  const endTime = data.startDate + " " + data.endTime;
  const statement = `select f.id as facId, f.code, f.floor, f.cate_id, case when v.start_time is null then 'available' when v.start_time is not null then 'unavailable' end as status  from
  (select id, code, floor, cate_id from meeteenew.facility
  where cate_id = $1) as f
  left join
  (select distinct facId, start_time
     from meeteenew.view_fac_status
     where cateId = $1 and
     (inDate = $2 and
     (status = $3 and ((timestamp '${startTime}', TIMESTAMP '${endTime}') overlaps (start_time, end_time))) or
     (status = $4 and not ((timestamp '${startTime}', TIMESTAMP '${endTime}') overlaps (start_time, end_time))))
     order by facid) as v
    on f.id = v.facId
  order by f.id;`;
  const values = [cateId, startDate, "Booked", "Cancelled"];

  pool.query(statement, values, (error, results) => {
    if (error) {
      console.log(error);
      response.status(500).send("Database Error");
    }
    response.status(200).json(results.rows);
  });
};

exports.checkStatusEachFacilityType = (request, response) => {
  const data = request.body;
  console.log("-------------------------------------------------------------");
  console.log({
    request: "POST /facility/type/status",
    body: JSON.stringify(data)
  });
  const classId = data.classId;
  const startDate = data.startDate;
  const startTime = data.startDate + " " + data.startTime;
  const endTime = data.endDate + " " + data.endTime;
  const status = "Booked";
  const user_id = data.userId;
  console.log(startTime + " " + endTime);

  const facilityInClassQuery = knex("meeteenew.facility as fac")
    .select(
      "fac.id as facId",
      "fac.code as code",
      "fac.floor as floor",
      "cate.id as cateId",
      "cate.name as cateName"
    )
    .join(
      "meeteenew.facility_category as cate",
      "fac.facility_category_id",
      "=",
      "cate.id"
    )
    .join(
      "meeteenew.facility_class as class",
      "cate.facility_class_id",
      "=",
      "class.id"
    )
    .where("class.id", "=", classId)
    .orderBy("facId");

  const unavailableQuery = knex("meeteenew.reservation as resv")
    .distinct("resv.facility_id as facId")
    .select(
      "fac.code as code",
      "fac.floor as floor",
      "cate.id as cateId",
      "cate.name as cateName"
    )
    .join("meeteenew.facility as fac", "resv.facility_id", "=", "fac.id")
    .join(
      "meeteenew.facility_category as cate",
      "fac.facility_category_id",
      "=",
      "cate.id"
    )
    .join(
      "meeteenew.facility_class as class",
      "cate.facility_class_id",
      "=",
      "class.id"
    )
    .where("class.id", "=", classId)
    .whereNot("resv.status", "Cancelled")
    .andWhere(function() {
      this.orWhere(
        knex.raw(
          `(TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') OVERLAPS (resv.start_time, resv.end_time)`
        )
      );
    })
    .orderBy("facId")
    .catch(error => {
      console.log(error);
      response.status(400).send("Bad request");
    });

  facilityInClassQuery.then(facAll => {
    assignStatusFacList(facAll);
    unavailableQuery
      .then(facUna => {
        updateStatusFacList(facAll, facUna);
        response.send(facAll);
      })
      .catch(error => {
        console.log(error);
        response.status(400).send("Bad request");
      });
  });
};

exports.checkStatusAllFacilities = (request, response) => {
  const data = request.body;
  console.log("--> Request facility/all/status: " + JSON.stringify(data));
  const startDate = data.startDate;
  const startTime = data.startDate + " " + data.startTime;
  const endTime = data.endDate + " " + data.endTime;
  const status = "Booked";
  const user_id = data.userId;

  const allFacilityQuery = knex("meeteenew.facility as fac")
    .select(
      "fac.id as facId",
      "fac.code as code",
      "fac.floor as floor",
      "fac.facility_category_id as cateId"
    )
    .orderBy("facId");

  const unavailableQuery = knex("meeteenew.reservation as resv")
    .distinct("resv.facility_id as facId")
    .select(
      "fac.code as code",
      "fac.floor as floor",
      "fac.facility_category_id as cateId"
    )
    .join("meeteenew.facility as fac", "resv.facility_id", "=", "fac.id")
    .whereNot("resv.status", "Cancelled")
    .andWhere(function() {
      this.orWhere(
        knex.raw(
          `(TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') OVERLAPS (resv.start_time, resv.end_time)`
        )
      );
    })
    .orderBy("facId")
    .catch(error => {
      console.log(error);
      response.status(400).send("Bad request");
    });

  allFacilityQuery.then(facAll => {
    assignStatusFacList(facAll);
    unavailableQuery
      .then(facUna => {
        updateStatusFacList(facAll, facUna);
        response.send(facAll);
      })
      .catch(error => {
        console.log(error);
        response.status(400).send("Bad request");
      });
  });
};

function assignStatusFacList(facList) {
  for (i = 0; i < facList.length; i++) {
    facList[i] = Object.assign(facList[i], {
      status: "available"
    });
  }
}

function updateStatusFacList(facAll, facUna) {
  for (i = 0; i < facUna.length; i++) {
    for (j = 0; j < facAll.length; j++) {
      if (facUna[i].code == facAll[j].code) {
        facAll[j].status = "unavailable";
      }
    }
  }
}

exports.checkUnavailability = (request, response) => {
  const data = request.body;
  const cateId = body.cateId;
  const startDate = data.startDate;
  const startTime = data.startDate + " " + data.startTime;
  const endTime = data.endDate + " " + data.endTime;
  const status = "Booked";
  const user_id = data.userId;
  console.log(type);
  console.log(startTime + " " + endTime);

  const unavailableQuery = knex("meeteenew.reservation as resv")
    .distinct("resv.facility_id as facId")
    .select(
      "facility.code as code",
      "fac.floor as floor",
      "fac.facility_category_id as categoryIdd"
    )
    .join("meeteenew.facility as fac", "resv.facility_id", "=", "fac.id")
    .where("facility.facility_category_id", "=", cateId)
    .andWhereNot("resv.status", "Cancelled")
    // .andWhere('resv.start_date', '=', startDate)
    .andWhere(function() {
      this.orWhere(
        knex.raw(
          `(TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') OVERLAPS (resv.start_time, resv.end_time)`
        )
      );
    })
    .then(data => response.send(data))
    .catch(error => {
      console.log(error);
      response.status(400).send("Bad request");
    });
};
