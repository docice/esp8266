
-- setup I2c and connect display
function init_i2c_display()
     -- SDA and SCL can be assigned freely to available GPIOs
     sda = 5 -- GPIO14
     scl = 6 -- GPIO12
     sla = 0x3c
     i2c.setup(0, sda, scl, i2c.SLOW)
     disp = u8g.ssd1306_128x64_i2c(sla)
end


function draw(hum,temp)

     disp:setFont(u8g.font_fub25)
     disp:drawStr( 0+0, 28+0, string.format("%.2f", temp).." C")
     disp:drawStr( 0+0, 20+43,string.format("%.2f", hum).." %")
end


function rotation_test()

         sda=5 --GPIO2               --  declare your I2C interface PIN's
          scl=6 --GPIO0
         
          htu21df:init(sda, scl)      -- initialize I2C  
          htu21df:read_reg(0x40,0xe7) --check the status reg
          temp = htu21df:readTemp()   -- read temperature
          print(temp)                 -- print it
          hum = htu21df:readHum()
          print(hum)
          disp:firstPage()
          repeat
               draw(hum,temp)
          until disp:nextPage() == false
    	  conn=net.createConnection(net.TCP, 0)
	  conn:connect(80,"192.168.178.30")
	  conn:send("GET /dht11.php?hum="..hum.."&temp="..temp.." HTTP/1.1\r\nHost: www.baidu.com\r\n".."Connection: keep-alive\r\nAccept: */*\r\n\r\n")
end

init_i2c_display()
rotation_test()
tmr.alarm(2, 60000, 1, function() rotation_test() end )