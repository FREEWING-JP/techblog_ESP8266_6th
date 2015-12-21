--ifttt.lua
motion_sensor = 5
gpio.mode(motion_sensor,gpio.INPUT)
     --in_out_log  change own event
     --cgEUrKuMnLOMhNWefBYB2RlRu415komCuxchVLVdqVO change own maker key
ifttturl = "GET /trigger/in_out_log/with/key/cgEUrKuMnLOMhNWefBYB2RlRu415komCuxchVLVdqVO"
conn = nil
net.dns.setdnsserver("8.8.8.8", 1)
conn=net.createConnection(net.TCP, 0) 

conn:on("receive", function(conn, payload) 
     print(payload) 
     end) 
     
conn:on("connection", function(conn, payload) 
     print('\nConnected') 
     
       --add value1
       local temp1 = adc.read(0)

       tmr.delay(1000)
       
       local temp2 = (adc.read(0) + temp1)/2

        local temp3

        if gpio.read(motion_sensor)==0 then 
            temp3 = "OUT"
         else
            temp3 = "IN"
        end

       
        ifttturl = ifttturl.."?".."value1="..temp3.."&".."value2="..temp2
     print(ifttturl)
     conn:send(ifttturl
      .." HTTP/1.1\r\n" 
      .."Host: maker.ifttt.com\r\n"
      .."Accept: */*\r\n" 
      .."User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n" 
      .."\r\n")
     end) 
     
conn:on("disconnection", function(conn, payload) 
      print('\nDisconnected') 
      end)
      
print('Posting to ifttt.com')                                    
conn:connect(80,'maker.ifttt.com')
