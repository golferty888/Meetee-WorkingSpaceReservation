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
VALUES ('peemtanapat', '12345','Tanapat','Choochot','admin','0939452459', '2019-11-17');

        --   id: 2,
        --   username: 'panakit139',
        --   first_name: 'Panakit',
        --   last_name: 'Paokamol',
        --   role: 'admin',
        --   email: 'panakit.gulfz@gmail.com',
        --   phone_number: '0916295499',
        --   birthday: '2019-11-21'
        -- }


