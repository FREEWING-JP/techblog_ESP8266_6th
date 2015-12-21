hall_ic_Pin = 2 
timer_count = 0
thirty_minutes = 1800
timer_forty_eight_hours = 0
forty_eight_hours = 48*2
gpio.mode(hall_ic_Pin,gpio.INT,gpio.PULLUP)

function debounce (func)
    local last = 0
    local delay = 200000

    return function (...)
        local now = tmr.now()
        if now - last < delay then return end

        last = now
        return func(...)
    end
end

function onChange()
    if gpio.read(hall_ic_Pin) == 1 then

        if(gpio.read(5) == 1) then
                timer_forty_eight_hours = 0
        end
        
        print("That was easy! ")
        dofile("ifttt.lua") 
    end
end

gpio.trig(hall_ic_Pin,"up", debounce(onChange))
gpio.mode(1,gpio.INPUT,gpio.PULLUP)

tmr.alarm(2, 1000, 1, function()

    timer_count = timer_count + 1

    print(timer_count)

    if( timer_count >= thirty_minutes) then
        timer_count = 0
        dofile("timer30min.lua")
        
        timer_forty_eight_hours  = timer_forty_eight_hours  + 1

        if(timer_forty_eight_hours >= forty_eight_hours) then
            dofile("timer48hour.lua")
            timer_forty_eight_hours = 0
        end
        
    end


end)
