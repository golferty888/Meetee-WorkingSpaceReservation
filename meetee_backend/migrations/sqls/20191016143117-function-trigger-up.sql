/* Replace with your SQL commands */
    

CREATE OR REPLACE FUNCTION meeteenew.date_format1(timestamp) 
    RETURNS date AS $$
    SELECT to_char($1, 'MonthDD, YYYY') :: date;
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

CREATE OR REPLACE FUNCTION meeteenew.price_over_hours(numeric, timestamp, timestamp, numeric) RETURNS numeric
    AS 'SELECT $1 * meeteenew.hour_cal($2, $3) * $4' LANGUAGE SQL;

CREATE OR REPLACE FUNCTION meeteenew.time_cron_format(timestamp) 
    RETURNS text  AS $$
    select to_char($1, 'SS MI HH24 DD MM *') ::text as end_cron
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

CREATE OR REPLACE FUNCTION meeteenew.notify_event_pending_status() RETURNS TRIGGER AS $$
    DECLARE
        record RECORD;
        payload JSON;
    BEGIN
        IF (TG_OP = 'INSERT') THEN record = NEW;
        ELSIF (TG_OP = 'UPDATE') THEN record = NEW;
        ELSIF (TG_OP = 'DELETE') THEN record = OLD;
        END IF;

        payload = json_build_object('table', TG_TABLE_NAME,
                                    'action', TG_OP,
                                    'data', row_to_json(record));
        PERFORM pg_notify('events', payload::text);
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notify_pending_status_event
    AFTER INSERT OR UPDATE OR DELETE ON meeteenew.pending_facility
    FOR EACH ROW EXECUTE PROCEDURE meeteenew.notify_event_pending_status();