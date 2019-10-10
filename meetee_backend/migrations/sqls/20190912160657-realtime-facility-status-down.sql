/* Replace with your SQL commands */
DROP FUNCTION IF EXISTS meeteenew.time_period(timestamp with time zone, timestamp with time zone);
DROP FUNCTION IF EXISTS meeteenew.hour_cal(timestamp with time zone, timestamp with time zone);
DROP FUNCTION IF EXISTS meeteenew.price_over_hours(numeric, timestamp with time zone, timestamp with time zone);
DROP FUNCTION IF EXISTS meeteenew.get_reserv_history(numeric, timestamp with time zone, timestamp with time zone);
DROP TRIGGER IF EXISTS notify_reservation_event ON meeteenew.reservation CASCADE;
DROP FUNCTION IF EXISTS meeteenew.notify_trigger();
DROP TABLE IF EXISTS meeteenew.reserv_audit;
