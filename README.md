# 5500SHAC-Cbus2MQTT
 Push and pull Cbus events from a 5500SHAC to MQTT.

 I use this to integrate my Cbus installation with [Home Assistant](https://www.home-assistant.io/).

 [Based on cgateweb by the1laz](https://github.com/the1laz/cgateweb).

## Install:
1. Log into your 5500SHAC, navigate to the "Scripting" section and install the two resident scripts and the event based script into their relevant sections. 
2. Update your MQTT server hostname, username and password details in the resident scripts. 
3. Activate the scripts.
4. Tag all the objects with the "All" keyword to events are pushed to the cbus2mqtt script. You can use this script to easily do this
```lua
for i = 0,255 do
  grp.addtags('0/56/'..i, 'All')
end 
```

## Examples

 In these examples, #1, #2 and #3 represent the Cbus network number, application number, and the group number.

### Updates get published on these topics:

 - cbus/read/#1/#2/#3/state  -  ON/OFF gets published to these topics if the light is turned on/off

 - cbus/read/#1/#2/#3/level  -  The level of the light gets published to these topics

### Publish to these topics to control the lights:

 - cbus/write/#1/#2/#3/switch  -  Publish ON/OFF to these topics to turn lights on/off

 - cbus/write/#1/#2/#3/ramp  -  Publish a % to ramp to that %. Optionally add a comma then a time (e.g. 50,4s or 100,2m).

### This requests an update from all lights:

 - cbus/write/#1/#2//getall - current values get published on the cbus/read topics