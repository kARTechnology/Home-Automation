doorval=-3
 function getdoorstatus() 
    val = adc.read(0)
     
    if(val>=870) then setState(-1,val)
    elseif(val>=650 and val <= 869) then setState(0,val)
    elseif(val>=450 and val <= 649) then setState(1,val)
    elseif(val<=449) then setState(-2,val)
    end
   -- print("---Door",val)
end

 
doortimer = tmr.create()
doortimer:register(1000, tmr.ALARM_AUTO, getdoorstatus)

doortimer:start()


function setState(val,rawval)  
 
if(val~=doorval) then
print("door:",val)
vals={}    
doorval=val
vals.door={}
vals.door.value=val
vals.door.context={}
vals.door.context.rawval=rawval;
if(val ==1) then  piezo(200) vals.door.context.state="Open"
elseif(val==0) then piezo(0) vals.door.context.state="Closed"
manuallysilenced=0
elseif(val==-1) then  piezo(50) vals.door.context.state="Short"
elseif(val==-2) then  piezo(50) vals.door.context.state="Wire Cut"
end
if connected==1 then 
vals=sjson.encode(vals) 
    print(vals)
    m:publish("/v1.6/devices/home", vals, 0, 0, function(client) print("sent door") end) 
end
end
end
