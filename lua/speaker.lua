speakerpin=6 
gpio.mode(speakerpin, gpio.OUTPUT)
gpio.write(speakerpin, gpio.LOW) 

ledpin=4
gpio.mode(ledpin,gpio.OUTPUT)

switchpin=0 
gpio.mode(switchpin, gpio.INPUT)



speakerstate=0
speakerinterval=0
manuallysilenced=0

speaker = tmr.create()
speaker:register(250, tmr.ALARM_AUTO, function() 
    if(speakerstate==1) then 
        speakerstate=0
        gpio.write(ledpin,gpio.LOW)
        gpio.write(speakerpin, gpio.LOW)
    else
        speakerstate=1
        gpio.write(ledpin,gpio.HIGH)
        
        if(gpio.read(switchpin)==1) then 
            manuallysilenced=1
            print("manually silenced" )
        end
    
        if(silent=="0" or manuallysilenced==1) then 
            print("silenced")
        else
            gpio.write(speakerpin, gpio.HIGH) 
        end
        
    end
end)
 
function piezo(interval) 
    if(interval==0) then speaker:stop() 
        gpio.write(speakerpin, gpio.LOW) 
        speakerinterval=interval
    else
         running, mode = speaker:state()
         if(running~=true or speakerinterval~=interval) then
             speakerinterval=interval
             print("starting")
             speaker:stop()
             speaker:interval(interval)
             speaker:start()
            end
    end
end
