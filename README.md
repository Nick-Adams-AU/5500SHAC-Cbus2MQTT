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

 - cbus/read/#1/#2/#3/state  -  ON/OFF gets published to these topics if the group is turned ON/OFF.

 - cbus/read/#1/#2/#3/level  -  The level of the group gets published to these topics. 0-255

### Publish to these topics to control a group address:

 - cbus/write/#1/#2/#3/switch  -  Publish ON/OFF to these topics to turn lights on/off

 - cbus/write/#1/#2/#3/ramp  -  Publish a % to ramp to that %. Optionally add a comma then a time (e.g. 50,4s or 100,2m).

 - cbus/write/#1/#2/#3/measurement - Publish a measurement value (i.e. temperature) to a Cbus measurement application. Values are divided by 10 so a MQTT value of 301 becomes 30.1 when published to Cbus.

### This requests an update from all addresses:

 - cbus/write/#1/#2//getall - Current values get published on the cbus/read topics. This is handy to periodically "re-sync" your MQTT subscribers on reboot or if they miss an update.