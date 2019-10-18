/* Replace with your SQL commands */
CREATE TABLE meeteenew.equipment_type(
    id      SERIAL  PRIMARY KEY,
    name    VARCHAR(256) NOT NULL
);

CREATE TABLE meeteenew.equipment(
    id      SERIAL  PRIMARY KEY,
    name    VARCHAR(256) NOT NULL,
    type_id  INT    NOT NULL,
    FOREIGN KEY(type_id) REFERENCES meeteenew.equipment_type(id)
);

CREATE TABLE meeteenew.facility_has_equipments(
    facility_category_id   INT     PRIMARY KEY,
    equipment_id INT     NOT NULL,
    FOREIGN KEY(facility_category_id) REFERENCES meeteenew.facility_category(id),
    FOREIGN KEY(equipment_id) REFERENCES meeteenew.equipment(id)
);



