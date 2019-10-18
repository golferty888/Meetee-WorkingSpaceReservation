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
INSERT INTO meeteenew.facility_type(name) VALUES('Seat');
INSERT INTO meeteenew.facility_type(name) VALUES('Seminar Room');
--CATEGORY
INSERT INTO meeteenew.facility_category(name, capacity, price, type_id)
VALUES('Meeting Room S', '4', 120, 1);
INSERT INTO meeteenew.facility_category(name, capacity, price, type_id)
VALUES('Meeting Room M', '8', 250, 1);
INSERT INTO meeteenew.facility_category(name, capacity, price, type_id)
VALUES('Meeting Room L', '12', 400, 1);
INSERT INTO meeteenew.facility_category(name, capacity, price, type_id)
VALUES('Single Chair', '1', 30, 2);
INSERT INTO meeteenew.facility_category(name, capacity, price, type_id)
VALUES('Bar Table', '1', 30, 2);
INSERT INTO meeteenew.facility_category(name, capacity, price, type_id)
VALUES('Single Sofa', '1', 40, 2);
INSERT INTO meeteenew.facility_category(name, capacity, price, type_id)
VALUES('Twin Sofa', '2', 60, 2);
INSERT INTO meeteenew.facility_category(name, capacity, price, type_id)
VALUES('Hall room', '30', 950, 3);
-- --ITEMS
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MS-01', 1, 1);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MS-02', 1, 1);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MS-03', 1, 1);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MS-04', 1, 1);

INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MM-01', 1, 2);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MM-02', 1, 2);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MM-03', 1, 2);
INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('MM-04', 1, 2);

INSERT INTO meeteenew.facility(code, floor, cate_id)
VALUES('ML-01', 1, 3);
