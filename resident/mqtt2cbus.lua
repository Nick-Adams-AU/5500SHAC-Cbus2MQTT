-- A resident script to run on a Clipsal 5500SHAC to push MQTT events to Cbus.

-- Tested with 5500SHAC firmware v1.6

-- Install this script as a resident script with a sleep interval of 5 seconds

mqtt_broker = 'YOUR_MQTT_HOST'
mqtt_username = 'YOUR_MQTT_USERNAME'
mqtt_password = 'YOUR_MQTT_PASSWORD'

mqtt_read_topic = 'cbus/read/'
mqtt_write_topic = 'cbus/write/#';

-- load mqtt module
mqtt = require("mosquitto")

-- create new mqtt client
client = mqtt.new()

log("created MQTT client", client)

client.ON_CONNECT = function()
  log("MQTT connected - receive")
  local mid = client:subscribe(mqtt_write_topic, 2)
end

client.ON_MESSAGE = function(mid, topic, payload)

  log(topic, payload)
  
  parts = string.split(topic, "/")

  if not parts[6] then
    
    log('MQTT error', 'Invalid message format')
    
  elseif parts[6] == "getall" then
    
    datatable = grp.all()
    for key,value in pairs(datatable) do
      dataparts = string.split(value.address, "/")
		  network = tonumber(dataparts[1])
		  app = tonumber(dataparts[2])
      group = tonumber(dataparts[3])
      if app == tonumber(parts[4]) and group ~= 0 then
		    level = tonumber(value.data)
    		state = (level ~= 0) and "ON" or "OFF"
        log(parts[3], app, group, state, level)
        client:publish(mqtt_read_topic .. parts[3] .. "/" .. app .. "/" .. group .. "/state", state, 1, true)
    		client:publish(mqtt_read_topic .. parts[3] .. "/" .. app .. "/" .. group .. "/level", level, 1, true)
  		end	
  	end
    log('Done')
  elseif parts[6] == "switch" then
    
    if payload == "ON" then
			SetCBusLevel(0, parts[4], parts[5], 255, 0)
    elseif payload == "OFF" then
      SetCBusLevel(0, parts[4], parts[5], 0, 0)
    end
    
  elseif parts[6] == "measurement" then

    SetCBusMeasurement(0, parts[4], parts[5], (payload / 10), 0)
    
  elseif parts[6] == "ramp" then

    if payload == "ON" then
			SetCBusLevel(0, parts[4], parts[5], 255)
    elseif payload == "OFF" then
      SetCBusLevel(0, parts[4], parts[5], 0)
    else
      ramp = string.split(payload, ",")
      num = round(ramp[1])
      if num and num < 256 then
        if ramp[2] ~= nil and tonumber(ramp[2]) > 1 then
	        SetCBusLevel(0, parts[4], parts[5], num, ramp[2])
        else
	        SetCBusLevel(0, parts[4], parts[5], num, 0)
        end
      end
    end
    
  end
  
end

client:login_set(mqtt_username, mqtt_password)
client:connect(mqtt_broker)
client:loop_forever()

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end