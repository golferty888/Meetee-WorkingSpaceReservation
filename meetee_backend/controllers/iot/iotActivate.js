const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");
const iotCron = require("./iotOff");
const mqtt = require("mqtt");
const mqttClient = mqtt.connect("mqtt://broker.hivemq.com");
exports.activateIotEquipment = (request, response) => {
  //iot-equip-list in each-room => Subscribe Topic {fac-code}
  //loop to publish message to those iot-equip in fac-code
  const rows = request.rows;
  var facCodeList = [];
  var endTimeList = [];
  rows.forEach(row => {
    facCodeList.push(row.code);
    endTimeList.push(row.end_time);
    mqttClient.publish(row.code, "1");
  });
  iotCron.setTimeToTurnOff(rows);
  try {
    response.status(200).send({
      message: "Activation Success!",
      facList: facCodeList,
      endTimeList: endTimeList
    });
  } catch (error) {
    console.log(error);
    next(500, "Response Error");
  }
};
