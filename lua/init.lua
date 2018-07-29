print("init begin")

speakerpin=6 
gpio.mode(speakerpin, gpio.OUTPUT)
gpio.write(speakerpin, gpio.LOW) 
 




print("Startup will resume momentarily, you have 10 seconds to start endusersetup.")


tmr.create():alarm(4000, tmr.ALARM_SINGLE, function()
print("starting up")
 
dofile("dis.lua") 
dofile("speaker.lua") 
dofile("mqtt.lua") 
dofile("fgate.lua") 
     
end)

print("init end")
