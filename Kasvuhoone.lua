--[[
%% properties
2166 value
%% weather
%% events
%% globals
--]]
local temp_sensor            = 2166;      -- temperature sensor ID
local window                 = 2165;      -- Window device ID
local temp_open              = 30;        --C Opening temperature
local temp_close             = 20;        --C closing temperature
local open                   = "open";    -- opening command
local close                  = "close";   -- closing command
local temp_actual            = (tonumber(fibaro:getValue(temp_sensor, "value")));  -- actual temperature 
local window_status          = (tonumber(fibaro:getValue(window, "value")));       -- actual window status

print('<font color=lightblue> # 17 Starting scene');
print('<font color=lightblue> # 18 Actual temperature is: '.. temp_actual .. '. Window status: ' .. window_status);
if(temp_actual) < (temp_close) then -------------------------------------------------------------------------------
    print('<font color=lightblue> # 20 Temperature less ' .. temp_close ..'C. checking device status.');         --
    if (window_status > 1) then -------------------------------------------------------                          --
       print('<font color=pink> # 22 Window is open. Closing the window');           --                          --
       fibaro:call(window, close);                                                   --     -- closing           --
    else                                                                             --                          --
       print('<font color=lightblue> # 25 Window is closed. Don't do anything');     --                          --
    end -------------------------------------------------------------------------------                          --
elseif (temp_actual) > (temp_open) then                                                                          --
    print('<font color=lightblue> # 28 Temperature is over ' .. temp_open .. 'C, checking is the window open');  --
    if (window_status) < 1 then -------------------------------------------------------                          --
       print('<font color=lightgreen> # 30 Window is closed, opening the window.');  --                          --
       fibaro:call(window, open);                                                    --     -- opening           --
    else                                                                             --                          --
    	print('<font color=lightblue> # 33 Window is open, don't do anything.');     --                          --
    end -------------------------------------------------------------------------------                          --
end ---------------------------------------------------------------------------------------------------------------
