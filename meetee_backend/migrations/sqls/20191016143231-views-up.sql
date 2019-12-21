/* Replace with your SQL commands */
create or replace view meeteenew.init_activation_page as
select resv.start_time ::text,
		meeteenew.date_format1(start_time) ::text as inDate,
		array_agg(json_build_object('id', fac.id, 'code', fac.code, 'cateName', cate.name, 'icon_url', cate.icon_url, 'color_code', type.color_code, 'floor', fac.floor, 'end_time', end_time ::text
		, 'status', case when ((NOW() ::timestamp, NOW() ::timestamp) overlaps (start_time, end_time)) then 'In time'
		else 'Waiting' end)) as facList, user_id as userId
from meeteenew.reservation resv
join meeteenew.reservation_line li on resv.id = li.reserve_id
join meeteenew.facility fac on li.facility_id = fac.id
join meeteenew.facility_category cate on fac.cate_id = cate.id
join meeteenew.facility_type type on cate.type_id = type.id
where end_time >= now()
group by start_time, user_id
order by start_time asc; 

create or replace view meeteenew.view_mqtt_reservtime_lookup as
	select rs.id, us.id userId, fac.id facId, code, start_time, end_time ::text, meeteenew.time_cron_format(end_time),
		case when ((NOW() ::timestamp, NOW() ::timestamp) overlaps (start_time, end_time)) then 'in_time'
		else 'up_coming' end as status
	from meeteenew.reservation rs
	join meeteenew.reservation_line rl on rs.id = rl.reserve_id
	join meeteenew.facility fac on rl.facility_id = fac.id
	join meeteenew.users us on rs.user_id = us.id
where end_time >= now();

create or replace view meeteenew.view_reservation as
	select resv.id, line.facility_id as facId, resv.user_id as userId, resv.start_time, resv.end_time, resv.status 
	from meeteenew.reservation resv
	join meeteenew.reservation_line line on resv.id = line.reserve_id
	join meeteenew.facility fac on line.facility_id = fac.id
	join meeteenew.facility_category cate on fac.cate_id = cate.id;

create or replace view meeteenew.view_fac_status as 
	select resv.id, cate.id cateId, meeteenew.date_format2(resv.start_time) as inDate, resv.start_time, resv.end_time, resv.status, fac.id facId, fac.code code, fac.floor  :: int, cate.name cateName, cate.capacity  :: int, cate.price  :: int, cate.type_id typeId 
	from meeteenew.reservation resv
	join meeteenew.reservation_line line on resv.id = line.reserve_id
	right join meeteenew.facility fac on line.facility_id = fac.id
	join meeteenew.facility_category cate on fac.cate_id = cate.id;

create MATERIALIZED VIEW meeteenew.view_factype_detail as 
	select cate.id cateId, cate.name cateName, cate.capacity  :: int, cate.price  :: int, cate.image_url, cate.icon_url, cate.map_url, type.id typeId, type.name typeName
	from meeteenew.facility_category cate
	join meeteenew.facility_type type on cate.type_id = type.id
	order by cateId;

create MATERIALIZED VIEW meeteenew.view_faccate_detail as
	select fe.cate_id cateId, cate."name" cateName, cate.capacity :: int, cate.price :: int, cate.image_url, cate.icon_url, cate.map_url, array_agg(json_build_object('eqid', fe.equipment_id,'eqname', eq."name", 'iconcode', eq.icon_code)) eqList
	from meeteenew.facility_has_equipments fe
	join meeteenew.equipment eq on fe.equipment_id = eq.id
	join meeteenew.facility_category cate on fe.cate_id = cate.id
	group by cateId, catename, capacity, price, image_url, icon_url, map_url
	order by cateId;

create or replace view meeteenew.view_user_history as 
	select
	resv.id as reservId,
	users.id as userId,
	users.username as username,
	array_agg(json_build_object('facCode', code, 'floor', floor)) as facList,
	cate.name as cateName,
	cate.price :: int as price,
	resv.start_time ::text as startTime,
	resv.end_time ::text as endTime,
	meeteenew.date_format1(resv.start_time) ::text as date,
	meeteenew.time_period(resv.start_time, resv.end_time) as period,
	meeteenew.hour_cal(resv.start_time, resv.end_time) :: int as hour,
	resv.total_price ::int as totalPrice,
	resv.status,
	type.color_code as typeColor,
	cate.image_url,
	cate.icon_url,
	cate.map_url
	from meeteenew.users
	join meeteenew.reservation as resv on users.id = resv.user_id
	join meeteenew.reservation_line as li on resv.id = li.reserve_id
	join meeteenew.facility as fac on li.facility_id = fac.id
	join meeteenew.facility_category cate on fac.cate_id = cate.id
	join meeteenew.facility_type type on cate.type_id = type.id
	group by reservId, userId, cateName, price, date, period, hour , totalPrice, status, typeColor, image_url, icon_url, map_url
	order by reservId desc;

create or replace view meeteenew.upcoming_and_intime_reservation as
	select 
	rs.id as reservId,
	case when ((NOW() ::timestamp, NOW() ::timestamp) overlaps (rs.start_time, rs.end_time)) then 'intime'
		else 'upcoming' end as status,
	rs.user_id as userId, 
	cate.name as cateName,
	array_agg(json_build_object('facCode', code, 'floor', floor)) as facList, 
	meeteenew.date_format1(rs.start_time) ::text as date,
	meeteenew.time_period(rs.start_time, rs.end_time) ::text as period,
	meeteenew.hour_cal(rs.start_time, rs.end_time) ::int as hour,
	rs.start_time ::text as startTime , 
	rs.end_time ::text as endTime , 
	rs.total_price ::int as totalPrice
	from meeteenew.reservation as rs
	join meeteenew.reservation_line as li on rs.id = li.reserve_id
	join meeteenew.facility as fac on li.facility_id = fac.id
	join meeteenew.facility_category cate on fac.cate_id = cate.id
	where rs.end_time >= now()
	group by reservId, userId, cateName, date, period, hour, totalPrice
	order by rs.start_time asc;
