/* Replace with your SQL commands */
CREATE TABLE meeteenew.facility_type(
    id      SERIAL  PRIMARY KEY,
    name    VARCHAR(256) NOT NULL,
    color_code VARCHAR(256)
);

CREATE TABLE meeteenew.facility_category(
    id      SERIAL  PRIMARY KEY,
    name    VARCHAR(256) NOT NULL,
    capacity    VARCHAR(256) NOT NULL,
    price   NUMERIC(5, 2) NOT NULL CHECK(price > 0),
    image_url VARCHAR(256) NOT NULL,
    icon_url VARCHAR(256) NOT NULL,
    map_url VARCHAR(256) NOT NULL,
    detail  VARCHAR(1024),
    type_id  INT    NOT NULL,
    FOREIGN KEY(type_id) REFERENCES meeteenew.facility_type(id)
);

CREATE TABLE meeteenew.facility(
    id      SERIAL  PRIMARY KEY,
    code    VARCHAR(256)  NOT NULL,
    floor   VARCHAR(128) NOT NULL,
    cate_id INT NOT NULL,
    FOREIGN KEY(cate_id) REFERENCES meeteenew.facility_category(id)
);
--TYPE
INSERT INTO meeteenew.facility_type(name, color_code) VALUES('Meeting Room', '0xFFFF8989');
INSERT INTO meeteenew.facility_type(name, color_code) VALUES('Private Seat', '0xFFFAD74E');
INSERT INTO meeteenew.facility_type(name, color_code) VALUES('Seminar Room',  '0xFF92D2FC');
--CATEGORY
INSERT INTO meeteenew.facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Meeting Room S', '4', 120, 'https://storage.googleapis.com/meetee-file-storage/img/fac/meet-s.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/meet-s.svg' 
, 'https://storage.googleapis.com/meetee-file-storage/map/meet-s.svg', 1);
INSERT INTO meeteenew.facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Meeting Room M', '8', 250, 'https://storage.googleapis.com/meetee-file-storage/img/fac/meet-m.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/meet-m.svg'
, 'https://storage.googleapis.com/meetee-file-storage/map/meet-m.svg', 1);
INSERT INTO meeteenew.facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Meeting Room L', '12', 400, 'https://storage.googleapis.com/meetee-file-storage/img/fac/meet-l.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/meet-l.svg'
, 'https://storage.googleapis.com/meetee-file-storage/map/meet-l.svg', 1);
INSERT INTO meeteenew.facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Single Chair', '1', 30, 'https://storage.googleapis.com/meetee-file-storage/img/fac/single-chair.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/single-chair.svg'
, 'https://storage.googleapis.com/meetee-file-storage/map/single-chair.svg', 2);
INSERT INTO meeteenew.facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Bar Table', '1', 30, 'https://storage.googleapis.com/meetee-file-storage/img/fac/bar-chair.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/bar-chair.svg'
, 'https://storage.googleapis.com/meetee-file-storage/map/bar-table.svg', 2);
INSERT INTO meeteenew.facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Single Sofa', '1', 40, 'https://storage.googleapis.com/meetee-file-storage/img/fac/single-sofa.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/single-sofa.svg'
, 'https://storage.googleapis.com/meetee-file-storage/map/single-sofa.svg', 2);
INSERT INTO meeteenew.facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Twin Sofa', '2', 60, 'https://storage.googleapis.com/meetee-file-storage/img/fac/twin-sofa.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/twin-sofa.svg'
, 'https://storage.googleapis.com/meetee-file-storage/map/twin-sofa.svg', 2);
INSERT INTO meeteenew.facility_category(name, capacity, price, image_url, icon_url, map_url, type_id)
VALUES('Hall room', '30', 950, 'https://storage.googleapis.com/meetee-file-storage/img/fac/hall-room.jpg'
, 'https://storage.googleapis.com/meetee-file-storage/icon/fac/hall-room.svg'
, 'https://storage.googleapis.com/meetee-file-storage/map/hall-room.svg', 3);
-- --ITEMS
-- cateId: 1 Meeting Room S
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MS-01', 1, 1);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MS-02', 1, 1);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MS-03', 1, 1);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MS-04', 1, 1);
-- cateId: 2 Meeting Room M
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MM-01', 1, 2);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MM-02', 1, 2);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MM-03', 1, 2);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MM-04', 1, 2);
-- cateId: 3 Meeting Room L
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('ML-01', 1, 3);
-- cateId: 4 Single Chair SC
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SC-01', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SC-02', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SC-03', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SC-04', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SC-05', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SC-06', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SC-07', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SC-08', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SC-09', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SC-10', 1, 4);
-- cateId: 5 Bar Table BT
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('BT-01', 1, 5);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('BT-02', 1, 5);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('BT-03', 1, 5);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('BT-04', 1, 5);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('BT-05', 1, 5);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('BT-06', 1, 5);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('BT-07', 1, 5);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('BT-08', 1, 5);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('BT-09', 1, 5);
-- cateId: 6 Sofa Single  SS
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SS-01', 1, 6);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SS-02', 1, 6);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SS-03', 1, 6);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SS-04', 1, 6);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('SS-05', 1, 6);
-- cateId: 7 Twin Sofa TS
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('TS-01', 1, 7);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('TS-02', 1, 7);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('TS-03', 1, 7);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('TS-04', 1, 7);
-- cateId: 8 Hall room
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('HR-01', 1, 8);