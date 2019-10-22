/* Replace with your SQL commands */

CREATE TABLE meeteenew.facility_type(
    id      SERIAL  PRIMARY KEY,
    name    VARCHAR(256) NOT NULL
);

CREATE TABLE meeteenew.facility_category(
    id      SERIAL  PRIMARY KEY,
    name    VARCHAR(256) NOT NULL,
    capacity    VARCHAR(256) NOT NULL,
    price   NUMERIC(5, 2) NOT NULL,
    link_url VARCHAR(256) NOT NULL,
    detail  VARCHAR(1024),
    type_id  INT    NOT NULL,
    FOREIGN KEY(type_id) REFERENCES meeteenew.facility_type(id)
);

CREATE TABLE meeteenew.facility(
    id      SERIAL  PRIMARY KEY,
    code    VARCHAR(256)  NOT NULL,
    floor   INT NOT NULL,
    cate_id INT NOT NULL,
    FOREIGN KEY(cate_id) REFERENCES meeteenew.facility_category(id)
);
--TYPE
INSERT INTO meeteenew.facility_type(name) VALUES('Meeting Room');
INSERT INTO meeteenew.facility_type(name) VALUES('Private Seat');
INSERT INTO meeteenew.facility_type(name) VALUES('Seminar Room');
--CATEGORY
INSERT INTO meeteenew.facility_category(name, capacity, price, link_url, type_id)
VALUES('Meeting Room S', '4', 120, 'https://storage.googleapis.com/meetee-file-storage/img/fac/meet-s.jpg', 1);
INSERT INTO meeteenew.facility_category(name, capacity, price, link_url, type_id)
VALUES('Meeting Room M', '8', 250, 'https://storage.googleapis.com/meetee-file-storage/img/fac/meet-m.jpg', 1);
INSERT INTO meeteenew.facility_category(name, capacity, price, link_url, type_id)
VALUES('Meeting Room L', '12', 400, 'https://storage.googleapis.com/meetee-file-storage/img/fac/meet-l.jpg', 1);
INSERT INTO meeteenew.facility_category(name, capacity, price, link_url, type_id)
VALUES('Single Chair', '1', 30, 'https://storage.googleapis.com/meetee-file-storage/img/fac/single-chair.jpg', 2);
INSERT INTO meeteenew.facility_category(name, capacity, price, link_url, type_id)
VALUES('Bar Table', '1', 30, 'https://storage.googleapis.com/meetee-file-storage/img/fac/bar-chair.jpg', 2);
INSERT INTO meeteenew.facility_category(name, capacity, price, link_url, type_id)
VALUES('Single Sofa', '1', 40, 'https://storage.googleapis.com/meetee-file-storage/img/fac/single-sofa.jpg', 2);
INSERT INTO meeteenew.facility_category(name, capacity, price, link_url, type_id)
VALUES('Twin Sofa', '2', 60, 'https://storage.googleapis.com/meetee-file-storage/img/fac/twin-sofa.jpg', 2);
INSERT INTO meeteenew.facility_category(name, capacity, price, link_url, type_id)
VALUES('Hall room', '30', 950, 'https://storage.googleapis.com/meetee-file-storage/img/fac/hall-room.jpg', 3);
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
-- cateId: 4 Chair Single CS
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('CS-01', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('CS-02', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('CS-03', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('CS-04', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('CS-05', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('CS-06', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('CS-07', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('CS-08', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('CS-09', 1, 4);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('CS-10', 1, 4);
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
-- cateId: 7 Sofa Twin  ST
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('ST-01', 1, 7);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('ST-02', 1, 7);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('ST-03', 1, 7);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('ST-04', 1, 7);
-- cateId: 8 Hall room
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('HR-01', 1, 8);