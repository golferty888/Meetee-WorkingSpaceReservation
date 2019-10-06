/* Replace with your SQL commands */
DROP TRIGGER IF EXISTS notify_reservation_event ON meeteenew.reservation CASCADE;
DROP FUNCTION IF EXISTS meeteenew.notify_trigger();
DROP FUNCTION IF EXISTS meeteenew.price_over_hours(numeric, timestamp, timestamp);
DROP TABLE IF EXISTS meeteenew.reserv_audit;
