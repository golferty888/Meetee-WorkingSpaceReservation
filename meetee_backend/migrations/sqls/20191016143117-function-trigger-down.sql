/* Replace with your SQL commands */

DROP TABLE IF EXISTS meeteenew.reserv_audit;

DROP TRIGGER IF EXISTS notify_reservation_event ON meeteenew.reservation CASCADE;
DROP TRIGGER IF EXISTS notify_pending_status_event ON meeteenew.pending_facility CASCADE;

DROP FUNCTION IF EXISTS meeteenew.notify_event();
DROP FUNCTION IF EXISTS meeteenew.notify_event_pending_status();
DROP FUNCTION IF EXISTS meeteenew.date_format1(timestamp);
DROP FUNCTION IF EXISTS meeteenew.date_format2(timestamp);
DROP FUNCTION IF EXISTS meeteenew.date_format(timestamp, timestamp);
DROP FUNCTION IF EXISTS meeteenew.time_period(timestamp, timestamp);
DROP FUNCTION IF EXISTS meeteenew.hour_cal(timestamp, timestamp);
DROP FUNCTION IF EXISTS meeteenew.price_over_hours(numeric, timestamp, timestamp);
DROP FUNCTION IF EXISTS meeteenew.get_reserv_history(numeric, timestamp, timestamp);