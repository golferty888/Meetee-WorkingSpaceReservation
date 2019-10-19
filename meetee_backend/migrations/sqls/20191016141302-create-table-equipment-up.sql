/* Replace with your SQL commands */
CREATE TABLE meeteenew.equipment_type(
    id      SERIAL  PRIMARY KEY,
    name    VARCHAR(256) NOT NULL
);

CREATE TABLE meeteenew.equipment(
    id      SERIAL  PRIMARY KEY,
    name    VARCHAR(256) NOT NULL,
    url_link VARCHAR(256),
    type_id  INT    NOT NULL,
    FOREIGN KEY(type_id) REFERENCES meeteenew.equipment_type(id)
);

CREATE TABLE meeteenew.facility_has_equipments(
    cate_id      INT     NOT NULL,
    equipment_id INT     NOT NULL,
    FOREIGN KEY(cate_id) REFERENCES meeteenew.facility_category(id),
    FOREIGN KEY(equipment_id) REFERENCES meeteenew.equipment(id)
);
-- EQUIP TYPES
INSERT INTO meeteenew.equipment_type (name) VALUES ('Stationary');
INSERT INTO meeteenew.equipment_type (name) VALUES ('Electronic');
INSERT INTO meeteenew.equipment_type (name) VALUES ('Furniture');

-- EQUIP LISTS
-- White Boards
INSERT INTO meeteenew.equipment (name, type_id) VALUES ('Whiteboard 120x180cm', 1); --1
INSERT INTO meeteenew.equipment (name, type_id) VALUES ('Whiteboard 120x240cm', 1); --2
INSERT INTO meeteenew.equipment (name, type_id) VALUES ('Whiteboard 120x300cm', 1); --3
-- Televisions
INSERT INTO meeteenew.equipment (name, type_id) VALUES ('LED TV 40in', 2); --4
-- Projectors
INSERT INTO meeteenew.equipment (name, type_id) VALUES ('Projector 8ft"', 2); --5
INSERT INTO meeteenew.equipment (name, type_id) VALUES ('Projector 16ft', 2); --6
-- Wifi
INSERT INTO meeteenew.equipment (name, type_id) VALUES ('High Speed Wifi', 2); --7
-- Power Bar
INSERT INTO meeteenew.equipment (name, type_id) VALUES ('PowerBar 1 Slot', 2); --8
INSERT INTO meeteenew.equipment (name, type_id) VALUES ('PowerBar 2 Slots', 2); --9

-- EQUIP LINK FAC_CATE
-- 1 Meet S
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (1, 1);
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (1, 4);
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (1, 7);
-- 2 Meet M
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (2, 2);
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (2, 7);
-- 3 Meet L
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (3, 3);
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (3, 7);
-- 4 Single Chair
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (4, 8);
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (4, 7);
-- 5 Bar Chair
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (5, 8);
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (5, 7);
-- 6 Single Sofa
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (6, 8);
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (6, 7);
-- 7 Twin Sofa
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (7, 9);
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (7, 7);
-- 8 Hall Room
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (8, 6);
INSERT INTO meeteenew.facility_has_equipments (cate_id, equipment_id) 
VALUES (8, 7);
