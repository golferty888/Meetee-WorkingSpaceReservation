DROP VIEW IF EXISTS view_reservation;
DROP VIEW IF EXISTS view_mqtt_reservtime_lookup;
DROP VIEW IF EXISTS view_fac_status;
DROP MATERIALIZED VIEW if EXISTS view_factype_detail;
DROP MATERIALIZED VIEW if EXISTS view_faccate_detail;
DROP VIEW if EXISTS view_user_history;
DROP VIEW if EXISTS upcoming_and_intime_reservation;
DROP VIEW if EXISTS init_activation_page;

DROP TABLE IF EXISTS reserv_audit;

DROP TRIGGER IF EXISTS notify_reservation_event ON reservation CASCADE;
DROP TRIGGER IF EXISTS notify_pending_status_event ON pending_facility CASCADE;

DROP FUNCTION IF EXISTS notify_event();
DROP FUNCTION IF EXISTS notify_event_pending_status();
DROP FUNCTION IF EXISTS date_format1(timestamp);
DROP FUNCTION IF EXISTS date_format2(timestamp);
DROP FUNCTION IF EXISTS date_format(timestamp, timestamp);
DROP FUNCTION IF EXISTS time_period(timestamp, timestamp);
DROP FUNCTION IF EXISTS hour_cal(timestamp, timestamp);
DROP FUNCTION IF EXISTS price_over_hours(numeric, timestamp, timestamp);
DROP FUNCTION IF EXISTS get_reserv_history(numeric, timestamp, timestamp);
DROP FUNCTION IF EXISTS price_over_hours(numeric, timestamp, timestamp, numeric);
DROP FUNCTION IF EXISTS time_cron_format(timestamp);

DROP TABLE IF EXISTS reservation_line;
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS pending_facility;
DROP TABLE IF EXISTS facility_has_equipments;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS equipment_type;
DROP TABLE IF EXISTS facility;
DROP TABLE IF EXISTS facility_category;
DROP TABLE IF EXISTS facility_type;
DROP TABLE IF EXISTS users;

/* Users */
CREATE TABLE users(
    id          SERIAL  PRIMARY KEY,
    username    VARCHAR(20) NOT NULL UNIQUE,
    password    VARCHAR(256) NOT NULL,
    first_name  VARCHAR(256),
    last_name  VARCHAR(256),
    role        VARCHAR(256) NOT NULL,
    phone_number    VARCHAR(256),
    birthday    DATE,
    create_at   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
    CONSTRAINT chk_username_min_length CHECK (char_length(username) >= 4)
);
INSERT INTO users (id, username, password, first_name, last_name, role, phone_number, birthday)
VALUES (0, 'admin', '$2b$04$JlxUcjHySUUkTgZA6Pl9Le2l9kI90AghmCkzTts4oa.qP5DiaI/8S','Tanapat','Choochot','admin','0939452459', '2019-11-17');
INSERT INTO users (id, username, password, first_name, last_name, role, birthday)
VALUES (1, 'yoyo', '$2b$04$j12b81nj7QJj4GUFGxd.1u9NGEA8AMxHKI2XnJ0MobXjO/dCVNlaC','Pronsawan','Donpraiwan','user','2019-09-18');

/* facility_type */
CREATE TABLE facility_type(
    id      SERIAL  PRIMARY KEY,
    name    VARCHAR(256) NOT NULL,
    color_code VARCHAR(256)
);

/* facility_category */
CREATE TABLE facility_category(
    id      SERIAL  PRIMARY KEY,
    name    VARCHAR(256) NOT NULL,
    capacity    VARCHAR(256) NOT NULL,
    price   NUMERIC(5, 2) NOT NULL CHECK(price > 0),
    image_url VARCHAR(256) NOT NULL,
    icon_url VARCHAR(256) NOT NULL,
    map_url VARCHAR(256) NOT NULL,
    detail  VARCHAR(1024),
    type_id  INT    NOT NULL,
    FOREIGN KEY(type_id) REFERENCES facility_type(id)
);

/* facility */
CREATE TABLE facility(
    id      SERIAL  PRIMARY KEY,
    code    VARCHAR(256)  NOT NULL,
    floor   VARCHAR(128) NOT NULL,
    cate_id INT NOT NULL,
    FOREIGN KEY(cate_id) REFERENCES facility_category(id)
);

--TYPE
INSERT INTO facility_type(name, color_code) VALUES('Meeting Room', '0xFFFF8989');
INSERT INTO facility_type(name, color_code) VALUES('Private Seat', '0xFFFAD74E');
INSERT INTO facility_type(name, color_code) VALUES('Seminar Room',  '0xFF92D2FC');
--CATEGORY
INSERT INTO facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Meeting Room S', '4', 120, 'https://storage.googleapis.com/meetee-file-storage/img/fac/meet-s.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/meet-s.svg' 
, 'https://storage.googleapis.com/meetee-file-storage/map/meet-s.svg', 1);
INSERT INTO facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Meeting Room M', '8', 250, 'https://storage.googleapis.com/meetee-file-storage/img/fac/meet-m.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/meet-m.svg'
, 'https://storage.googleapis.com/meetee-file-storage/map/meet-m.svg', 1);
INSERT INTO facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Meeting Room L', '12', 400, 'https://storage.googleapis.com/meetee-file-storage/img/fac/meet-l.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/meet-l.svg'
, 'https://storage.googleapis.com/meetee-file-storage/map/meet-l.svg', 1);
INSERT INTO facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Single Chair', '1', 30, 'https://storage.googleapis.com/meetee-file-storage/img/fac/single-chair.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/single-chair.svg'
, 'https://storage.googleapis.com/meetee-file-storage/map/single-chair.svg', 2);
INSERT INTO facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Bar Table', '1', 30, 'https://storage.googleapis.com/meetee-file-storage/img/fac/bar-chair.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/bar-chair.svg'
, 'https://storage.googleapis.com/meetee-file-storage/map/bar-table.svg', 2);
INSERT INTO facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Single Sofa', '1', 40, 'https://storage.googleapis.com/meetee-file-storage/img/fac/single-sofa.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/single-sofa.svg'
, 'https://storage.googleapis.com/meetee-file-storage/map/single-sofa.svg', 2);
INSERT INTO facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Twin Sofa', '2', 60, 'https://storage.googleapis.com/meetee-file-storage/img/fac/twin-sofa.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/twin-sofa.svg'
, 'https://storage.googleapis.com/meetee-file-storage/map/twin-sofa.svg', 2);
INSERT INTO facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Hall room', '30', 950, 'https://storage.googleapis.com/meetee-file-storage/img/fac/hall-room.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/hall-room.svg'
, 'https://storage.googleapis.com/meetee-file-storage/map/hall-room.svg', 3);
-- --ITEMS
-- cateId: 1 Meeting Room S
INSERT INTO facility(code, floor, cate_id)
VALUES('MS-01', 1, 1);
INSERT INTO facility(code, floor, cate_id)
VALUES('MS-02', 1, 1);
INSERT INTO facility(code, floor, cate_id)
VALUES('MS-03', 1, 1);
INSERT INTO facility(code, floor, cate_id)
VALUES('MS-04', 1, 1);
-- cateId: 2 Meeting Room M
INSERT INTO facility(code, floor, cate_id)
VALUES('MM-01', 1, 2);
INSERT INTO facility(code, floor, cate_id)
VALUES('MM-02', 1, 2);
INSERT INTO facility(code, floor, cate_id)
VALUES('MM-03', 1, 2);
INSERT INTO facility(code, floor, cate_id)
VALUES('MM-04', 1, 2);
-- cateId: 3 Meeting Room L
INSERT INTO facility(code, floor, cate_id)
VALUES('ML-01', 1, 3);
-- cateId: 4 Single Chair SC
INSERT INTO facility(code, floor, cate_id)
VALUES('SC-01', 1, 4);
INSERT INTO facility(code, floor, cate_id)
VALUES('SC-02', 1, 4);
INSERT INTO facility(code, floor, cate_id)
VALUES('SC-03', 1, 4);
INSERT INTO facility(code, floor, cate_id)
VALUES('SC-04', 1, 4);
INSERT INTO facility(code, floor, cate_id)
VALUES('SC-05', 1, 4);
INSERT INTO facility(code, floor, cate_id)
VALUES('SC-06', 1, 4);
INSERT INTO facility(code, floor, cate_id)
VALUES('SC-07', 1, 4);
INSERT INTO facility(code, floor, cate_id)
VALUES('SC-08', 1, 4);
INSERT INTO facility(code, floor, cate_id)
VALUES('SC-09', 1, 4);
INSERT INTO facility(code, floor, cate_id)
VALUES('SC-10', 1, 4);
-- cateId: 5 Bar Table BT
INSERT INTO facility(code, floor, cate_id)
VALUES('BT-01', 1, 5);
INSERT INTO facility(code, floor, cate_id)
VALUES('BT-02', 1, 5);
INSERT INTO facility(code, floor, cate_id)
VALUES('BT-03', 1, 5);
INSERT INTO facility(code, floor, cate_id)
VALUES('BT-04', 1, 5);
INSERT INTO facility(code, floor, cate_id)
VALUES('BT-05', 1, 5);
INSERT INTO facility(code, floor, cate_id)
VALUES('BT-06', 1, 5);
INSERT INTO facility(code, floor, cate_id)
VALUES('BT-07', 1, 5);
INSERT INTO facility(code, floor, cate_id)
VALUES('BT-08', 1, 5);
INSERT INTO facility(code, floor, cate_id)
VALUES('BT-09', 1, 5);
-- cateId: 6 Sofa Single  SS
INSERT INTO facility(code, floor, cate_id)
VALUES('SS-01', 1, 6);
INSERT INTO facility(code, floor, cate_id)
VALUES('SS-02', 1, 6);
INSERT INTO facility(code, floor, cate_id)
VALUES('SS-03', 1, 6);
INSERT INTO facility(code, floor, cate_id)
VALUES('SS-04', 1, 6);
INSERT INTO facility(code, floor, cate_id)
VALUES('SS-05', 1, 6);
-- cateId: 7 Twin Sofa TS
INSERT INTO facility(code, floor, cate_id)
VALUES('TS-01', 1, 7);
INSERT INTO facility(code, floor, cate_id)
VALUES('TS-02', 1, 7);
INSERT INTO facility(code, floor, cate_id)
VALUES('TS-03', 1, 7);
INSERT INTO facility(code, floor, cate_id)
VALUES('TS-04', 1, 7);
-- cateId: 8 Hall room
INSERT INTO facility(code, floor, cate_id)
VALUES('HR-01', 1, 8);

/* equipment_type */
CREATE TABLE equipment_type(
    id      SERIAL  PRIMARY KEY,
    name    VARCHAR(256) NOT NULL
);

/* equipment */
CREATE TABLE equipment(
    id      SERIAL  PRIMARY KEY,
    name    VARCHAR(256) NOT NULL,
    icon_code INT,
    type_id  INT    NOT NULL,
    FOREIGN KEY(type_id) REFERENCES equipment_type(id)
);

/* facility_has_equipments */
CREATE TABLE facility_has_equipments(
    cate_id      INT     NOT NULL,
    equipment_id INT     NOT NULL,
    FOREIGN KEY(cate_id) REFERENCES facility_category(id),
    FOREIGN KEY(equipment_id) REFERENCES equipment(id)
);

-- EQUIP TYPES
INSERT INTO equipment_type (name) VALUES ('Stationary');
INSERT INTO equipment_type (name) VALUES ('Electronic');
INSERT INTO equipment_type (name) VALUES ('Furniture');

-- EQUIP LISTS
-- White Boards
INSERT INTO equipment (name, icon_code, type_id) VALUES ('Whiteboard 120x180cm', '58303', 1); --1
INSERT INTO equipment (name, icon_code, type_id) VALUES ('Whiteboard 120x240cm', '58301', 1); --2
INSERT INTO equipment (name, icon_code, type_id) VALUES ('Whiteboard 120x300cm', '58300', 1); --3
-- Televisions
INSERT INTO equipment (name, icon_code, type_id) VALUES ('LED TV 40in', '58163', 2); --4
-- Projectors
INSERT INTO equipment (name, icon_code, type_id) VALUES ('Projector 8ft"', '59562', 2); --5
INSERT INTO equipment (name, icon_code, type_id) VALUES ('Projector 16ft', '59562', 2); --6
-- Wifi
INSERT INTO equipment (name, icon_code, type_id) VALUES ('High Speed Wifi', '57786', 2); --7
-- Power Bar
INSERT INTO equipment (name, icon_code, type_id) VALUES ('PowerBar 1 Slot', '58940', 2); --8
INSERT INTO equipment (name, icon_code, type_id) VALUES ('PowerBar 2 Slots', '58940', 2); --9

-- EQUIP LINK FAC_CATE
-- 1 Meet S
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (1, 1);
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (1, 4);
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (1, 7);
-- 2 Meet M
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (2, 2);
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (2, 5);
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (2, 7);
-- 3 Meet L
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (3, 3);
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (3, 6);
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (3, 7);
-- 4 Single Chair
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (4, 8);
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (4, 7);
-- 5 Bar Chair
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (5, 8);
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (5, 7);
-- 6 Single Sofa
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (6, 8);
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (6, 7);
-- 7 Twin Sofa
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (7, 9);
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (7, 7);
-- 8 Hall Room
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (8, 6);
INSERT INTO facility_has_equipments (cate_id, equipment_id) 
VALUES (8, 7);

/* pending_facility */
CREATE TABLE pending_facility(
    id  SERIAL  PRIMARY KEY,
    facility_id INT NOT NULL,
    start_time  TIMESTAMP WITHOUT TIME ZONE NOT NULL,          
    end_time    TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    FOREIGN KEY(facility_id) REFERENCES facility(id),
    CONSTRAINT check_period CHECK(end_time > start_time),
    CONSTRAINT check_past_time CHECK(start_time >= now() and end_time >= now())
);

/* reservation */
CREATE TABLE reservation(
    id          INT GENERATED ALWAYS AS IDENTITY (START WITH 10001) PRIMARY KEY NOT NULL,
    user_id     INT             NOT NULL,
    start_time  TIMESTAMP WITHOUT TIME ZONE NOT NULL,          
    end_time    TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    total_price   NUMERIC(5, 2) NOT NULL,
    status      VARCHAR(128)    NOT NULL CHECK(status IN ('Booked', 'Cancelled', 'Pending')),
    create_at   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
    FOREIGN KEY(user_id) REFERENCES users(id),
    CONSTRAINT check_price_more_than_zero CHECK(total_price > 0),
    CONSTRAINT check_period CHECK(end_time > start_time),
    CONSTRAINT check_past_time CHECK(start_time >= now() and end_time >= now())
);

/* reservation_line */
create TABLE reservation_line(
    reserve_id  INT     NOT NULL,
    facility_id     INT     NOT NULL,
    FOREIGN KEY(reserve_id) REFERENCES reservation(id) ON DELETE CASCADE,
    FOREIGN KEY(facility_id) REFERENCES facility(id)
);

INSERT INTO reservation(user_id, start_time, end_time, total_price, status)
VALUES(1,'2030-11-30 08:00', '2030-11-30 10:00', 720.00, 'Booked');
INSERT INTO reservation_line(reserve_id, facility_id)
VALUES(10001, 1);
INSERT INTO reservation_line(reserve_id, facility_id)
VALUES(10001, 2);
INSERT INTO reservation_line(reserve_id, facility_id)
VALUES(10001, 3);

INSERT INTO reservation(user_id, start_time, end_time, total_price, status)
VALUES(1,'2030-11-30 11:00', '2030-11-30 12:00', 240.00, 'Booked');
INSERT INTO reservation_line(reserve_id, facility_id)
VALUES(10002, 1);
INSERT INTO reservation_line(reserve_id, facility_id)
VALUES(10002, 4);

/* FUNCTION, TRIGGER and Addition Table*/
CREATE OR REPLACE FUNCTION date_format1(timestamp) 
    RETURNS date AS $$
    SELECT to_char($1, 'Month DD, YYYY') :: date;
    $$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION date_format2(timestamp) 
    RETURNS date AS $$
    SELECT to_char($1, 'YYYY-MM-DD') :: date;
    $$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION time_period(timestamp, timestamp) 
    RETURNS text AS $$
    SELECT to_char($1, 'HH24:MI') || ' - ' || to_char($2, 'HH24:MI');
    $$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION hour_cal(timestamp, timestamp) 
    RETURNS numeric
    AS 'SELECT ((extract (hour from $2) - extract (hour from $1)) :: numeric)' LANGUAGE SQL;

CREATE OR REPLACE FUNCTION price_over_hours(numeric, timestamp, timestamp, numeric) RETURNS numeric
    AS 'SELECT $1 * hour_cal($2, $3) * $4' LANGUAGE SQL;

CREATE OR REPLACE FUNCTION time_cron_format(timestamp) 
    RETURNS text  AS $$
    select to_char($1, 'SS MI HH24 DD MM *') ::text as end_cron
   $$ LANGUAGE SQL;

CREATE TABLE reserv_audit(
    operation   char(6)     NOT NULL,
    time_stamp  timestamp  NOT NULL,
    db_user     text    NOT NULL,
    user_id     integer    NOT NULL,
    start_time  timestamp without time zone NOT NULL,
    end_time    timestamp without time zone NOT NULL,
    status      text        NOT NULL
);

CREATE OR REPLACE FUNCTION notify_event() RETURNS TRIGGER AS $$
    DECLARE
        record RECORD;
        payload JSON;
    BEGIN

        IF (TG_OP != 'DELETE' AND NEW.start_time >= NEW.end_time) THEN
            RAISE EXCEPTION 'Time value error: end_time must be more than start_time'
            USING HINT = 'Please check your time values';
        END IF;

        IF (TG_OP = 'INSERT') THEN
            record = NEW;
            INSERT INTO reserv_audit SELECT 'Insert', now(), user,  NEW.user_id, NEW.start_time, NEW.end_time, NEW.status;

        ELSIF (TG_OP = 'UPDATE') THEN
            record = NEW;
            INSERT INTO reserv_audit SELECT 'Update', now(), user,  NEW.user_id, NEW.start_time, NEW.end_time, NEW.status;
        ELSIF (TG_OP = 'DELETE') THEN
            record = OLD;
            INSERT INTO reserv_audit SELECT 'Delete', now(), user,  OLD.user_id, OLD.start_time, OLD.end_time, OLD.status;
        END IF;

        payload = json_build_object('table', TG_TABLE_NAME,
                                    'action', TG_OP,
                                    'data', row_to_json(record));
        PERFORM pg_notify('events', payload::text);
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notify_reservation_event
    AFTER INSERT OR UPDATE OR DELETE ON reservation
    FOR EACH ROW EXECUTE PROCEDURE notify_event();

CREATE OR REPLACE FUNCTION notify_event_pending_status() RETURNS TRIGGER AS $$
    DECLARE
        record RECORD;
        payload JSON;
    BEGIN
        IF (TG_OP = 'INSERT') THEN record = NEW;
        ELSIF (TG_OP = 'UPDATE') THEN record = NEW;
        ELSIF (TG_OP = 'DELETE') THEN record = OLD;
        END IF;

        payload = json_build_object('table', TG_TABLE_NAME,
                                    'action', TG_OP,
                                    'data', row_to_json(record));
        PERFORM pg_notify('events', payload::text);
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notify_pending_status_event
    AFTER INSERT OR UPDATE OR DELETE ON pending_facility
    FOR EACH ROW EXECUTE PROCEDURE notify_event_pending_status();

/* VIEWS */
create or replace view init_activation_page as
select resv.start_time ::text,
		date_format1(start_time) ::text as inDate,
		array_agg(json_build_object('id', fac.id, 'code', fac.code, 'cateName', cate.name, 'icon_url', cate.icon_url, 'color_code', type.color_code, 'floor', fac.floor, 'end_time', end_time ::text
		, 'status', case when ((NOW() ::timestamp, NOW() ::timestamp) overlaps (start_time, end_time)) then 'In time'
		else 'Waiting' end)) as facList, user_id as userId
from reservation resv
join reservation_line li on resv.id = li.reserve_id
join facility fac on li.facility_id = fac.id
join facility_category cate on fac.cate_id = cate.id
join facility_type type on cate.type_id = type.id
where end_time >= now()
group by start_time, user_id
order by start_time asc; 

create or replace view view_mqtt_reservtime_lookup as
	select rs.id, us.id userId, fac.id facId, code, start_time, end_time ::text, time_cron_format(end_time),
		case when ((NOW() ::timestamp, NOW() ::timestamp) overlaps (start_time, end_time)) then 'in_time'
		else 'up_coming' end as status
	from reservation rs
	join reservation_line rl on rs.id = rl.reserve_id
	join facility fac on rl.facility_id = fac.id
	join users us on rs.user_id = us.id
where end_time >= now();

create or replace view view_reservation as
	select resv.id, line.facility_id as facId, resv.user_id as userId, resv.start_time, resv.end_time, resv.status 
	from reservation resv
	join reservation_line line on resv.id = line.reserve_id
	join facility fac on line.facility_id = fac.id
	join facility_category cate on fac.cate_id = cate.id;

create or replace view view_fac_status as 
	select resv.id, cate.id cateId, date_format2(resv.start_time) as inDate, resv.start_time, resv.end_time, resv.status, fac.id facId, fac.code code, fac.floor  :: int, cate.name cateName, cate.capacity  :: int, cate.price  :: int, cate.type_id typeId 
	from reservation resv
	join reservation_line line on resv.id = line.reserve_id
	right join facility fac on line.facility_id = fac.id
	join facility_category cate on fac.cate_id = cate.id;

create MATERIALIZED VIEW view_factype_detail as 
	select cate.id cateId, cate.name cateName, cate.capacity  :: int, cate.price  :: int, cate.image_url, cate.icon_url, cate.map_url, type.id typeId, type.name typeName
	from facility_category cate
	join facility_type type on cate.type_id = type.id
	order by cateId;

create MATERIALIZED VIEW view_faccate_detail as
	select fe.cate_id cateId, cate."name" cateName, cate.capacity :: int, cate.price :: int, 
	cate.image_url, cate.icon_url, cate.map_url, 
	array_agg(json_build_object('eqid', fe.equipment_id,'eqname', eq."name", 'iconcode', eq.icon_code)) eqList
	from facility_has_equipments fe
	join equipment eq on fe.equipment_id = eq.id
	join facility_category cate on fe.cate_id = cate.id
	group by cateId, catename, capacity, price, image_url, icon_url, map_url
	order by cateId;

create or replace view view_user_history as 
	select
	resv.id as reservId,
	users.id as userId,
	users.username as username,
	array_agg(json_build_object('facCode', code, 'floor', floor)) as facList,
	cate.name as cateName,
	cate.price :: int as price,
	resv.start_time ::text as startTime,
	resv.end_time ::text as endTime,
	date_format1(resv.start_time) ::text as date,
	time_period(resv.start_time, resv.end_time) as period,
	hour_cal(resv.start_time, resv.end_time) :: int as hour,
	resv.total_price ::int as totalPrice,
	resv.status,
	type.color_code as typeColor,
	cate.image_url,
	cate.icon_url,
	cate.map_url
	from users
	join reservation as resv on users.id = resv.user_id
	join reservation_line as li on resv.id = li.reserve_id
	join facility as fac on li.facility_id = fac.id
	join facility_category cate on fac.cate_id = cate.id
	join facility_type type on cate.type_id = type.id
	group by reservId, userId, cateName, price, date, period, hour , totalPrice, status, typeColor, image_url, icon_url, map_url
	order by reservId desc;

create or replace view upcoming_and_intime_reservation as
	select 
	rs.id as reservId,
	case when ((NOW() ::timestamp, NOW() ::timestamp) overlaps (rs.start_time, rs.end_time)) then 'intime'
		else 'upcoming' end as status,
	rs.user_id as userId, 
	cate.name as cateName,
	array_agg(json_build_object('facCode', code, 'floor', floor)) as facList, 
	date_format1(rs.start_time) ::text as date,
	time_period(rs.start_time, rs.end_time) ::text as period,
	hour_cal(rs.start_time, rs.end_time) ::int as hour,
	rs.start_time ::text as startTime , 
	rs.end_time ::text as endTime , 
	rs.total_price ::int as totalPrice
	from reservation as rs
	join reservation_line as li on rs.id = li.reserve_id
	join facility as fac on li.facility_id = fac.id
	join facility_category cate on fac.cate_id = cate.id
	where rs.end_time >= now()
	group by reservId, userId, cateName, date, period, hour, totalPrice
	order by rs.start_time asc;

