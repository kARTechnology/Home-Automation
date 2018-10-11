print("init begin")

speakerpin=6 
gpio.mode(speakerpin, gpio.OUTPUT)
gpio.write(speakerpin, gpio.LOW) 
 

net.dns.setdnsserver("8.8.4.4", 0)
net.dns.setdnsserver("208.67.220.220", 1) 
wifi.sta.sethostname("BedRoom-"..node.chipid())
station_cfg={}
station_cfg.ssid="Karthik_2.4GHz"
station_cfg.pwd="Karthik@123"
station_cfg.save=true
wifi.sta.config(station_cfg)
wifi.setmode(wifi.STATION)
wifi.sta.connect()


print("Startup will resume momentarily, you have 10 seconds to start endusersetup.")


tmr.create():alarm(4000, tmr.ALARM_SINGLE, function()
print("starting up")
 
dofile("dis.lua") 
dofile("speaker.lua") 
dofile("mqtt.lua") 
dofile("fgate.lua") 


 wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
 print("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
 T.BSSID.."\n\tChannel: "..T.channel)
 end)

 wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
 print("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
 T.BSSID.."\n\treason: "..T.reason)
 end)

 wifi.eventmon.register(wifi.eventmon.STA_AUTHMODE_CHANGE, function(T)
 print("\n\tSTA - AUTHMODE CHANGE".."\n\told_auth_mode: "..
 T.old_auth_mode.."\n\tnew_auth_mode: "..T.new_auth_mode)
 end)

 wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
 print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..
 T.netmask.."\n\tGateway IP: "..T.gateway)
 end)

 wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT, function()
 print("\n\tSTA - DHCP TIMEOUT")
 end)

 wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED, function(T)
 print("\n\tAP - STATION CONNECTED".."\n\tMAC: "..T.MAC.."\n\tAID: "..T.AID)
 end)

 wifi.eventmon.register(wifi.eventmon.AP_STADISCONNECTED, function(T)
 print("\n\tAP - STATION DISCONNECTED".."\n\tMAC: "..T.MAC.."\n\tAID: "..T.AID)
 end)

 wifi.eventmon.register(wifi.eventmon.AP_PROBEREQRECVED, function(T)
 print("\n\tAP - PROBE REQUEST RECEIVED".."\n\tMAC: ".. T.MAC.."\n\tRSSI: "..T.RSSI)
 end)

 wifi.eventmon.register(wifi.eventmon.WIFI_MODE_CHANGED, function(T)
 print("\n\tSTA - WIFI MODE CHANGED".."\n\told_mode: "..
 T.old_mode.."\n\tnew_mode: "..T.new_mode)
 end)
     
end)

print("init end")
