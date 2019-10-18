/* Replace with your SQL commands */
CREATE TABLE meeteenew.reservation(
    id          INT GENERATED ALWAYS AS IDENTITY (START WITH 10001) PRIMARY KEY NOT NULL,
    user_id     INT             NOT NULL,
    -- facility_id INT             NOT NULL,
    start_time  TIMESTAMP WITHOUT TIME ZONE NOT NULL,          
    end_time    TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    status      VARCHAR(128)    NOT NULL,
    create_at   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
    FOREIGN KEY(user_id) REFERENCES meeteenew.users(id)
    -- FOREIGN KEY(facility_id) REFERENCES meeteenew.facility(id)
);

create TABLE meeteenew.reservation_line(
    reserve_id  INT     NOT NULL,
    facility_id     INT     NOT NULL,
    FOREIGN KEY(reserve_id) REFERENCES meeteenew.reservation(id),
    FOREIGN KEY(facility_id) REFERENCES meeteenew.facility(id)
);

INSERT INTO meeteenew.reservation(user_id, start_time, end_time, status)
VALUES(1,'2019-11-17 08:00', '2019-11-17 10:00', 'Booked');
INSERT INTO meeteenew.reservation_line(reserve_id, facility_id)
VALUES(10001, 1);
INSERT INTO meeteenew.reservation_line(reserve_id, facility_id)
VALUES(10001, 2);
INSERT INTO meeteenew.reservation_line(reserve_id, facility_id)
VALUES(10001, 3);

INSERT INTO meeteenew.reservation(user_id, start_time, end_time, status)
VALUES(1,'2019-11-17 11:00', '2019-11-17 12:00', 'Booked');
INSERT INTO meeteenew.reservation_line(reserve_id, facility_id)
VALUES(10002, 1);
INSERT INTO meeteenew.reservation_line(reserve_id, facility_id)
VALUES(10002, 4);