/* Replace with your SQL commands */
CREATE OR REPLACE FUNCTION meeteenew.date_format1(timestamp) 
    RETURNS text AS $$
    SELECT to_char($1, 'MonthDD, YYYY');
    $$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION meeteenew.date_format2(timestamp) 
    RETURNS date AS $$
    SELECT to_char($1, 'YYYY-MM-DD') :: date;
    $$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION meeteenew.time_period(timestamp, timestamp) 
    RETURNS text AS $$
    SELECT to_char($1, 'HH24:MI') || ' - ' || to_char($2, 'HH24:MI');
    $$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION meeteenew.hour_cal(timestamp, timestamp) 
    RETURNS numeric
    AS 'SELECT ((extract (hour from $2) - extract (hour from $1)) :: numeric)' LANGUAGE SQL;

CREATE OR REPLACE FUNCTION meeteenew.price_over_hours(numeric, timestamp, timestamp) RETURNS numeric
    AS 'SELECT $1 * ((extract (hour from $3) - extract (hour from $2)) :: numeric)' LANGUAGE SQL;

CREATE OR REPLACE FUNCTION meeteenew.get_reserv_history(numeric, timestamp, timestamp) 
    RETURNS TABLE (timePeriod text, hour numeric, priceTotal numeric)
    AS $$ SELECT meeteenew.time_period($2, $3), meeteenew.hour_cal($2, $3), meeteenew.price_over_hours($1, $2, $3)
    $$ LANGUAGE SQL;

CREATE TABLE meeteenew.reserv_audit(
    operation   char(6)     NOT NULL,
    time_stamp  timestamp  NOT NULL,
    db_user     text    NOT NULL,
    user_id     integer    NOT NULL,
    start_time  timestamp without time zone NOT NULL,
    end_time    timestamp without time zone NOT NULL,
    status      text        NOT NULL
);

CREATE OR REPLACE FUNCTION meeteenew.notify_event() RETURNS TRIGGER AS $$
    DECLARE
        record RECORD;
        payload JSON;
    BEGIN
        IF (NEW.start_time >= NEW.end_time) THEN
            RAISE EXCEPTION 'Time value error: end_time must be more than start_time'
            USING HINT = 'Please check your time values';
        END IF;

        IF (TG_OP = 'INSERT') THEN
            record = NEW;
            INSERT INTO meeteenew.reserv_audit SELECT 'Insert', now(), user,  NEW.user_id, NEW.start_time, NEW.end_time, NEW.status;

        ELSIF (TG_OP = 'UPDATE') THEN
            record = NEW;
            INSERT INTO meeteenew.reserv_audit SELECT 'Update', now(), user,  NEW.user_id, NEW.start_time, NEW.end_time, NEW.status;
        ELSIF (TG_OP = 'DELETE') THEN
            record = OLD;
            INSERT INTO meeteenew.reserv_audit SELECT 'Delete', now(), user,  OLD.user_id, OLD.start_time, OLD.end_time, OLD.status;
        END IF;

        payload = json_build_object('table', TG_TABLE_NAME,
                                    'action', TG_OP,
                                    'data', row_to_json(record));
        PERFORM pg_notify('events', payload::text);
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notify_reservation_event
    AFTER INSERT OR UPDATE OR DELETE ON meeteenew.reservation
    FOR EACH ROW EXECUTE PROCEDURE meeteenew.notify_event();