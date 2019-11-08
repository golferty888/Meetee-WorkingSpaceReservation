/* Replace with your SQL commands */
CREATE TABLE meeteenew.pending_facility(
    id  SERIAL  PRIMARY KEY,
    facility_id INT NOT NULL,
    start_time  TIMESTAMP WITHOUT TIME ZONE NOT NULL,          
    end_time    TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    FOREIGN KEY(facility_id) REFERENCES meeteenew.facility(id),
    CONSTRAINT check_period CHECK(end_time > start_time),
    CONSTRAINT check_past_time CHECK(start_time >= now() and end_time >= now())
);

CREATE TABLE meeteenew.reservation(
    id          INT GENERATED ALWAYS AS IDENTITY (START WITH 10001) PRIMARY KEY NOT NULL,
    user_id     INT             NOT NULL,
    start_time  TIMESTAMP WITHOUT TIME ZONE NOT NULL,          
    end_time    TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    total_price   NUMERIC(5, 2) NOT NULL,
    status      VARCHAR(128)    NOT NULL CHECK(status IN ('Booked', 'Cancelled', 'Pending')),
    create_at   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
    FOREIGN KEY(user_id) REFERENCES meeteenew.users(id),
    CONSTRAINT check_price_more_than_zero CHECK(total_price > 0),
    CONSTRAINT check_period CHECK(end_time > start_time),
    CONSTRAINT check_past_time CHECK(start_time >= now() and end_time >= now())
);

create TABLE meeteenew.reservation_line(
    reserve_id  INT     NOT NULL,
    facility_id     INT     NOT NULL,
    FOREIGN KEY(reserve_id) REFERENCES meeteenew.reservation(id) ON DELETE CASCADE,
    FOREIGN KEY(facility_id) REFERENCES meeteenew.facility(id)
);

INSERT INTO meeteenew.reservation(user_id, start_time, end_time, total_price, status)
VALUES(1,'2019-11-17 08:00', '2019-11-17 10:00', 720.00, 'Booked');
INSERT INTO meeteenew.reservation_line(reserve_id, facility_id)
VALUES(10001, 1);
INSERT INTO meeteenew.reservation_line(reserve_id, facility_id)
VALUES(10001, 2);
INSERT INTO meeteenew.reservation_line(reserve_id, facility_id)
VALUES(10001, 3);

INSERT INTO meeteenew.reservation(user_id, start_time, end_time, total_price, status)
VALUES(1,'2019-11-17 11:00', '2019-11-17 12:00', 240.00, 'Booked');
INSERT INTO meeteenew.reservation_line(reserve_id, facility_id)
VALUES(10002, 1);
INSERT INTO meeteenew.reservation_line(reserve_id, facility_id)
VALUES(10002, 4);