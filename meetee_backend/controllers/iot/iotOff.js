const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const mqtt = require("mqtt");
const mqttClient = mqtt.connect("mqtt://broker.hivemq.com");
const { ErrorHandler, handlerError } = require("../../helpers/error");
const cron = require("node-cron");

function setTimeToTurnOff(rows) {
  rows.forEach(row => {
    try {
      const time_cron = row.time_cron_format;
      const facCode = row.code;
      const task = cron.schedule(
        time_cron,
        () => {
          console.log({
            message: "Cronjob executed.",
            time: time_cron,
            facCode: facCode
          });
          mqttClient.publish(facCode, "0");
        },
        {
          scheduled: true,
          timezone: "Asia/Bangkok"
        }
      );
    } catch (error) {
      console.log(error);
      next(500, "Cron Error");
    }
  });

  // const statement = `select * from view_mqtt_reservtime_lookup`;
  // const value = ``;

  // pool.query(statement, (err, res) => {
  //   try {
  //     if (err) {
  //       console.log(err);
  //       throw new ErrorHandler(500, "Database Error");
  //     } else {
  //       console.log("****************************************");
  //       console.log(facList);
  //     }
  //   } catch (error) {
  //     console.log(error);
  //     next(error);
  //   }
  // });
}
module.exports = {
  setTimeToTurnOff
};
