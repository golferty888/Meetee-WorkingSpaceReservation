/* Replace with your SQL commands */
-- create or replace view meeteenew.view_user_authen as
-- 	select id as userId, username, password
-- 	from meeteenew.users;

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
	select cate.id cateId, cate.name cateName, cate.capacity  :: int, cate.price  :: int, cate.link_url, type.id typeId, type.name typeName
	from meeteenew.facility_category cate
	join meeteenew.facility_type type on cate.type_id = type.id
	order by cateId;

create MATERIALIZED VIEW meeteenew.view_faccate_detail as
	select fe.cate_id cateId, cate."name" cateName, cate.capacity :: int, cate.price :: int, cate.link_url, array_agg(json_build_object('eqid', fe.equipment_id,'eqname', eq."name", 'iconName', eq.icon_name)) eqList
	from meeteenew.facility_has_equipments fe
	join meeteenew.equipment eq on fe.equipment_id = eq.id
	join meeteenew.facility_category cate on fe.cate_id = cate.id
	group by cateId, catename, capacity, price, link_url
	order by cateId;

create or replace view meeteenew.view_user_history as 
select
        resv.id as reservId,
		users.id as userId, 
		users.username as username, 
        fac.id as facId, 
        cate.name as cateName, 
        fac.code, 
        fac.floor  :: int, 
        cate.price :: int as price, 
		resv.start_time as start_time,
		resv.end_time as end_time,
        meeteenew.date_format1(resv.start_time) as date, 
        meeteenew.time_period(resv.start_time, resv.end_time) as period, 
        meeteenew.hour_cal(resv.start_time, resv.end_time) :: int as hour, 
        meeteenew.price_over_hours(cate.price, resv.start_time, resv.end_time) :: int as total_price, 
     	resv.status
from meeteenew.users
join meeteenew.reservation as resv on users.id = resv.user_id
join meeteenew.reservation_line as li on resv.id = li.reserve_id
join meeteenew.facility as fac on li.facility_id = fac.id
join meeteenew.facility_category cate on fac.cate_id = cate.id
order by reservId desc;