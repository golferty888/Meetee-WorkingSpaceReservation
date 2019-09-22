CREATE TABLE meeteenew.reserv_audit(
    operation   char(6)     NOT NULL,
    time_stamp  timestamp  NOT NULL,
    db_user     text    NOT NULL,
    facility_id integer     NOT NULL,
    user_id     integer    NOT NULL,
    start_time  timestamp with time zone NOT NULL,
    end_time    timestamp with time zone NOT NULL,
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
            INSERT INTO meeteenew.reserv_audit SELECT 'Insert', now(), user, NEW.facility_id, NEW.user_id, NEW.start_time, NEW.end_time, NEW.status;

        ELSIF (TG_OP = 'UPDATE') THEN
            record = NEW;
            INSERT INTO meeteenew.reserv_audit SELECT 'Update', now(), user, NEW.facility_id, NEW.user_id, NEW.start_time, NEW.end_time, NEW.status;
        ELSIF (TG_OP = 'DELETE') THEN
            record = OLD;
            INSERT INTO meeteenew.reserv_audit SELECT 'Delete', now(), user, OLD.facility_id, OLD.user_id, OLD.start_time, OLD.end_time, OLD.status;
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

-- CREATE OR REPLACE FUNCTION meeteenew.notify_trigger_delete() 
--     RETURNS trigger AS 
--     $BODY$
--     -- DECLARE
--     BEGIN
--         PERFORM pg_notify('new_delete_data', row_to_json(NEW)::text);
--         RETURN NULL;
--     END;
--     $BODY$
--     LANGUAGE plpgsql VOLATILE;

-- CREATE TRIGGER reservation_insert_trigger 
--     AFTER INSERT OR UPDATE ON meeteenew.reservation
--     FOR EACH ROW EXECUTE PROCEDURE meeteenew.notify_trigger();

-- CREATE TRIGGER reservation_delete_trigger 
--     AFTER DELETE ON meeteenew.reservation
--     FOR EACH ROW EXECUTE PROCEDURE meeteenew.notify_trigger_delete();

-- CREATE OR REPLACE FUNCTION meeteenew.notify_trigger() 
--     RETURNS trigger AS 
--     $BODY$
--     -- DECLARE
--     BEGIN
--         PERFORM pg_notify('new_reserv_data', row_to_json(NEW)::text);
--         RETURN NULL;
--     END;
--     $BODY$
--     LANGUAGE plpgsql VOLATILE;

-- CREATE OR REPLACE FUNCTION meeteenew.notify_trigger_update() 
--     RETURNS trigger AS 
--     $BODY$
--     -- DECLARE
--     BEGIN
--         PERFORM pg_notify('new_update_data', row_to_json(NEW)::text);
--         RETURN NULL;
--     END;
--     $BODY$
--     LANGUAGE plpgsql VOLATILE;

-- CREATE TRIGGER reservation_update_status_trigger 
--     AFTER UPDATE OF status ON meeteenew.reservation
--     FOR EACH ROW EXECUTE PROCEDURE meeteenew.notify_trigger_update();