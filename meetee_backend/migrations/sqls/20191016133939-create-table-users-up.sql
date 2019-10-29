/* Replace with your SQL commands */
CREATE TABLE meeteenew.users(
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

INSERT INTO meeteenew.users (username, password, first_name, last_name, role, phone_number, birthday)
VALUES ('admin', '$2b$04$JlxUcjHySUUkTgZA6Pl9Le2l9kI90AghmCkzTts4oa.qP5DiaI/8S','Tanapat','Choochot','admin','0939452459', '2019-11-17');
INSERT INTO meeteenew.users (username, password, first_name, last_name, role, birthday)
VALUES ('yoyo', '$2b$04$j12b81nj7QJj4GUFGxd.1u9NGEA8AMxHKI2XnJ0MobXjO/dCVNlaC','Pronsawan','Donpraiwan','user','2019-09-18');