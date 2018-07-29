print("dis begin")
interval=10
echo=1
trigger=2 

gpio.mode(trigger, gpio.OUTPUT)
gpio.mode(echo, gpio.INT) 

distance=0  
trig=gpio.trig  


function calcDistance()
   prevpulse=0
   distance=0
   gpio.write(trigger, gpio.HIGH) tmr.delay(10) gpio.write(trigger, gpio.LOW)
   trig(echo, "high", pin1cb)
   trig(echo, "down", pin1cb)

end
  
function pin1cb(level, pulse)
    print( "---",level, pulse, pulse - prevpulse )
    if(level==0 and prevpulse~=0) then 
        distance=(pulse - prevpulse)*0.034/2  
        --print("Distance:",distance)
    end
    if(level==1) then 
        prevpulse = pulse   
    end         
end
     
distancetimer = tmr.create()
distancetimer:register(interval*1000, tmr.ALARM_AUTO, calcDistance)



distancetimer:start()

print("dis end")
