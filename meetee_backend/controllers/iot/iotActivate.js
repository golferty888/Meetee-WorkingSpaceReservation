const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");
const iotCron = require("./iotOff");
const mqtt = require("mqtt");
const mqttClient = mqtt.connect("mqtt://20.191.141.209");
exports.activateIotEquipment = (request, response) => {
  //iot-equip-list in each-room => Subscribe Topic {fac-code}
  //loop to publish message to those iot-equip in fac-code
  const rows = request.rows;
  var facCodeList = [];
  rows.forEach(row => {
    facCodeList.push(row.code);
    mqttClient.publish(row.code, "ON");
  });
  iotCron.setTimeToTurnOff(rows);
  const message = "Activation Success!";
  response.status(200).send({
    message: message,
    facList: facCodeList
  });
};
