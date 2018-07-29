print("mqtt setup start");
connected=0
silent=0
dhtpin=3

m = mqtt.Client("clientid", 30, "A1E-k6sqcpU3tDjLSUHvmnkrPzrqODzXVD", "")
 
m:on("message", 
 function(client, topic, data) 
  print("--received message")
  print(topic .. ":" ) 
  if data ~= nil then
    print(data) 
    if(string.match(topic,"silent")) then
        silent=data    
    end
    end 
 end
)
  

function handle_mqtt_error(client, reason) 
 print("--Disconnected - failed reason: " .. reason) 
 connected=0
 tmr.create():alarm(10 * 5000, tmr.ALARM_SINGLE, do_mqtt_connect)
end

function do_mqtt_connect()
    m:connect("things.ubidots.com",1883, 0, 
    function(client)
        print("--Connected to Ubidots!")  
        connected=1
        
            client:subscribe(
            {
              ["/v1.6/devices/home/silent/lv"]=0,
            },function(client) print("--subscribe success") end) 
            val={}    
            strength=wifi.sta.getrssi()
            val.wifisignal=math.abs(strength)
            val=sjson.encode(val) 
            print(val)
            m:publish("/v1.6/devices/home", val, 0, 0, function(client) print("sent wifisignal") end) 
    end,
    handle_mqtt_error)
end

do_mqtt_connect()


timeinterval=15

tmr.alarm(0,timeinterval*1000,1,function()
if connected==1 then  
    getValues()  
end
end)





function getValues()
    val={}    

--DHT start
    status, temperature, humidity, temp_dec, humi_dec = dht.read(dhtpin)
    if status == dht.OK then
    val.temperature=temperature
    val.humidity=humidity
    elseif status == dht.ERROR_CHECKSUM then
        print( "DHT Checksum error." )
    elseif status == dht.ERROR_TIMEOUT then
        print( "DHT timed out." )
    end
--DHT end

--DISTANCE start
if(distance~=0) then val.distance=distance end
--DISTANCE end
  
    if (next(val) == nil) then
        print("nothing to send")
    else
        val=sjson.encode(val) 
        print(val)
        m:publish("/v1.6/devices/home", val, 0, 0,function(client) print("sent sensors") end)
    end
end


print("mqtt setup end");
