/* Replace with your SQL commands */
create or replace view meeteenew.view_reservation as
	select resv.id, line.facility_id as facId, resv.user_id as userId, resv.start_time, resv.end_time, resv.status from meeteenew.reservation resv
	join meeteenew.reservation_line line on resv.id = line.reserve_id;

create or replace view meeteenew.view_fac_status as 
	select resv.id, cate.id cateId, meeteenew.date_format2(resv.start_time) as inDate, resv.start_time, resv.end_time, resv.status, fac.id facId, fac.code code, fac.floor, cate.name cateName, cate.capacity, cate.price, cate.type_id typeId 
	from meeteenew.reservation resv
	join meeteenew.reservation_line line on resv.id = line.reserve_id
	right join meeteenew.facility fac on line.facility_id = fac.id
	join meeteenew.facility_category cate on fac.cate_id = cate.id;

create or replace view meeteenew.view_category_detail as 
	select cate.id cateId, cate.name cateName, cate.capacity, cate.price, cate.link_url, type.id typeId, type.name typeName
	from meeteenew.facility_category cate
	join meeteenew.facility_type type on cate.type_id = type.id;