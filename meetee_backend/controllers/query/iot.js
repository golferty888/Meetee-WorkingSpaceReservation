const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const mqtt = require("mqtt");
const mqttClient = mqtt.connect("mqtt://20.191.141.209");
exports.activateIotEquipment = (request, response) => {
  //iot-equip-list in each-room => Subscribe Topic {fac-code}
  //loop to publish message to those iot-equip in fac-code
  const facCodeList = request.facCodeList;
  console.log(facCodeList);
  facCodeList.forEach(facItem => {
    mqttClient.publish(facItem, "Hello mqtt");
  });
  const message = "Activation Success!";
  response.status(200).send({
    message: message,
    facList: facCodeList
  });
};
