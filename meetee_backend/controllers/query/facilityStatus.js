const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");

exports.getAvaialableFacWithAmount = async (request, response, next) => {
  const data = request.body;
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
    try {
      if (error) {
        console.log(error);
        throw new ErrorHandler(500, "Database Error");
      } else {
        response.status(200).send(results.rows);
      }
    } catch (error) {
      next(error);
    }
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
  response,
  next
) => {
  const data = request.body;
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
    try {
      if (
        cateId == null ||
        startDate == null ||
        startTime == null ||
        endTime == null
      ) {
        throw new ErrorHandler(400, "Bad Request");
      } else if (error) {
        console.log(error);
        throw new ErrorHandler(500, "Database Error");
      } else {
        response.status(200).send(results.rows);
      }
    } catch (error) {
      next(error);
    }
  });
};

exports.checkStatusEachFacilityCategory = (request, response, next) => {
  const data = request.body;
  const cateId = data.cateId;
  const startDate = data.startDate;
  const startTime = data.startDate + " " + data.startTime;
  const endTime = data.startDate + " " + data.endTime;
  // var statement = `select f.id as facId, f.code, f.floor, f.cate_id, case when v.start_time is null then 'available' when v.start_time is not null then 'unavailable' end as status  from
  // (select id, code, floor, cate_id from meeteenew.facility
  // where cate_id = $1) as f
  // left join
  // (select distinct facId, start_time
  //    from meeteenew.view_fac_status
  //    where cateId = $1 and
  //    (inDate = $2 and
  //    (status = $3 and ((timestamp '${startTime}', TIMESTAMP '${endTime}') overlaps (start_time, end_time))) or
  //    (status = $4 and not ((timestamp '${startTime}', TIMESTAMP '${endTime}') overlaps (start_time, end_time))))
  //    order by facid) as v
  //   on f.id = v.facId
  // order by f.id;`;
  var statement = ` select f.id facId, f.code, f.floor, f.cate_id, 
  case when  pf.start_time is not null and ((TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') overlaps (pf.start_time, pf.end_time)) then 'pending'
  when v.start_time is null then 'available' 
  when v.start_time is not null then 'unavailable' end status  
  from
  (select id, code, floor, cate_id from meeteenew.facility
  where cate_id = $1) as f
  left join
  (select distinct facId, start_time
     from meeteenew.view_fac_status
     where cateId = $1 and
     (inDate = $2 and
     (status = $3 and ((TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') overlaps (start_time, end_time))) or
     (status = $4 and not ((TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') overlaps (start_time, end_time))))
     order by facid) as v
    on f.id = v.facId
  left join meeteenew.pending_facility as pf on f.id = pf.facility_id
  order by f.id;`;
  const values = [cateId, startDate, "Booked", "Cancelled"];

  pool.query(statement, values, (error, results) => {
    try {
      if (
        cateId == null ||
        startDate == null ||
        startTime == null ||
        endTime == null
      ) {
        throw new ErrorHandler(400, "Bad Request");
      } else if (error) {
        console.log(error);
        throw new ErrorHandler(500, "Database Error");
      } else {
        if (request.url == "/facility/cate/lock") {
        }
        response.status(200).send(results.rows);
      }
    } catch (error) {
      next(error);
    }
  });
};

exports.checkStatusAvaialableAllCategories = (request, response, next) => {
  const data = request.body;
  const typeId = data.typeId;
  const startDate = data.startDate;
  const startTime = data.startDate + " " + data.startTime;
  const endTime = data.startDate + " " + data.endTime;
  const statement = 
  `select fac.cate_id cateId, cate.name cateName, case when array_length(unav.unavailable_list, 1) >=1 then count(fac.id) - array_length(unav.unavailable_list, 1) else count(fac.id) end ::int as available_count
  from meeteenew.facility fac
  left join (select v1.cateid, array_agg(distinct v1.facId) as unavailable_list,
    count(distinct v1.facid) as unavailable_count, (select count(fac.id) from meeteenew.facility fac where fac.cate_id = v1.cateid) - count(distinct v1.facid) as available_count
      from meeteenew.view_fac_status as v1
      where v1.typeid = $1 and
      (inDate = $2 and
      (v1.status = $3 and ((TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') overlaps (v1.start_time, v1.end_time))) or
      (v1.status = $4 and not ((TIMESTAMP '${startTime}', TIMESTAMP '${endTime}') overlaps (v1.start_time, v1.end_time))))
      group by 1) unav on unav.cateid = fac.cate_id 
  join meeteenew.facility_category cate on fac.cate_id = cate.id
  where cate.type_id = $1
  group by 1, 2, unav.unavailable_list`;
  const values = [typeId, startDate, "Booked", "Cancelled"];
  pool.query(statement, values, (error, results) => {
    try {
      if (
        typeId == null ||
        startDate == null ||
        startTime == null ||
        endTime == null
      ) {
        throw new ErrorHandler(400, "Bad Request");
      } else if (error) {
        console.log(error);
        throw new ErrorHandler(500, "Database Error");
      } else {
        response.status(200).send(results.rows);
      }
    } catch (error) {
      next(error);
    }
  });
};

exports.lockAndUnlockPendingFacilityInSpecificPeriod = (
  request,
  response,
  next
) => {
  const data = request.body;
  const facList = data.facList;
  const startTime = data.startDate + " " + data.startTime;
  const endTime = data.startDate + " " + data.endTime;
  var statement;
  if (request.url == "/facility/pending/lock") {
    statement = `INSERT INTO meeteenew.pending_facility(facility_id, start_time, end_time) VALUES($1, $2, $3)`;
  } else if (request.url == "/facility/pending/unlock") {
    statement = `DELETE FROM meeteenew.pending_facility where facility_id = $1 and start_time = $2 and end_time = $3`;
  }

  facList.forEach(facId => {
    const values = [facId, startTime, endTime];
    pool.query(statement, values, (err, res) => {
      try {
        if (err) {
          console.log(err);
          throw new ErrorHandler(500, "Database Error");
        }
      } catch (error) {
        console.log(error);
        next(error);
      }
    });
  });
  response.send("Success!");
};
