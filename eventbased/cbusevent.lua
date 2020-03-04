-- This script efficiently pushes Cbus events to the cbus2mqtt resident
-- script via an internal socket without having to reestablish an MQTT
-- connection for each and every event.

-- Install this script as an event based script against the keyword "All"

-- You'll need to tag every object with the "All" keyword so this script is run
-- whenever an object changes. You can do this easily by running a function
-- like:

-- for i = 0,255 do
--   grp.addtags('0/56/'..i, 'All')
-- end 

require('socket').udp():sendto(event.dst .. "/" .. event.getvalue(), '127.0.0.1', 5432)