-- A resident script to run on a Clipsal 5500SHAC to push Cbus events to MQTT

-- Tested with 5500SHAC firmware v1.6

-- Install this script as a resident script with a sleep interval of 5 seconds

mqtt_broker = 'YOUR_MQTT_HOST'
mqtt_username = 'YOUR_MQTT_USERNAME'
mqtt_password = 'YOUR_MQTT_PASSWORD'

mqtt_read_topic = 'cbus/read/'

-- load mqtt module
mqtt = require("mosquitto")

-- create new mqtt client
client = mqtt.new()

log("created MQTT client", client)

-- C-Bus events to MQTT local listener
server = require('socket').udp()
server:settimeout(1)
server:setsockname('127.0.0.1', 5432)

client.ON_CONNECT = function()
  log("MQTT connected - send")
end

client:login_set(mqtt_username, mqtt_password)
client:connect(mqtt_broker)
client:loop_start()

while true do
	cmd = server:receive()
	if cmd then
    parts = string.split(cmd, "/")
    network = 254
    app = tonumber(parts[2])
    group = tonumber(parts[3])
    level = tonumber(parts[4])
  	state = (level ~= 0) and "ON" or "OFF"
    client:publish(mqtt_read_topic .. network .. "/" .. app .. "/" .. group .. "/state", state, 1, true)
    client:publish(mqtt_read_topic .. network .. "/" .. app .. "/" .. group .. "/level", level, 1, true)
	end
end