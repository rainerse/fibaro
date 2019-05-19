--[[
%% properties
976 value
978 value
973 value
%% globals 
--]]

-- Sensor IDs, separated with commas
local sensors = {
    976
}
-- Light IDs, separated with commas
local lights = {
    973
}
local lux = 978; -- Lux sensor ID
local delay = 300; -- delay in seconds, how long after LAST DETECTED MOTION should the lights stay on
local scene = 31; -- ID of THIS SCENE 
local minLevel =34; -- Lux level above which the scene WILL NOT trigger 
local dimLevel = 4; -- Night time light level for dimmers
local night = tonumber(fibaro:getGlobalValue("isNight")); -- Global variable that determines if it's currently night or day. Use [local night = 0] to disable
local debug = true; -- Change to true for debugging
 
------------------------------------

------------------------------------
 
local instances = tonumber(fibaro:countScenes());
local trigger = fibaro:getSourceTrigger();
local time = tonumber(os.time());
local level = 100;
 
if (night and night > 0) then
    level = dimLevel;
end
 
    local function inArray(needle, haystack)
    for i,n in ipairs(haystack) do
        if (tonumber(needle)==tonumber(n)) then
            return true;
        end
    end
    return false;
end
 
local function getSensorStatus()
    for i,n in ipairs(sensors) do
        if (tonumber(fibaro:getValue(n, "value")) > 0) then
            return 1;
        end
    end
    return 0;
end
 
local function getLastBreach()
    local breach = 0;
    for i,n in ipairs(sensors) do
        local nBreach = tonumber(fibaro:getValue(n, "lastBreached"));
        if(nBreach > breach) then
            breach = nBreach;
        end
    end
    return breach;
end
 
local lastBreached = getLastBreach();
 
local function getLightStatus()
    for i,n in ipairs(lights) do
        if (tonumber(fibaro:getValue(n, "value")) > 0) then
            return 1;
        end
    end
    return 0;
end
 
local lightStatus = getLightStatus();
 
local function setLightStatus(command)
    for i,n in ipairs(lights) do
        if (tonumber(fibaro:getValue(n, "value"))~=tonumber(command)) then
            if (debug) then fibaro:debug("Setting device "..n.." to "..command); end
            local type = fibaro:getType(n);
            if ( type == "com.fibaro.FGD212") then
                fibaro:call(n, "setValue", command );
            elseif (command > 1 ) then
                fibaro:call(n, "turnOn");
            else
                fibaro:call(n, "turnOff");
            end
 
        end
    end
end
 
local function keepLightOn()
    lastBreached = getLastBreach();
    time = os.time();
    if (debug) then fibaro:debug("Last breach:"..(time-lastBreached).."sec ago"); end
 
    if (getSensorStatus() == 1) then
        return true;
    end
 
    if ((time-lastBreached)>=delay) then
        return false;
    end
    return true;
end
 
local function checkLightLevel()
    if (lux == 0 or minLevel == 0) then
        return true;
    end
    local lightLevel = tonumber(fibaro:getValue(lux, "value"));
    if (lightLevel < minLevel) then
 
        return true;
    end
 
    return false;
end
 
if ((fibaro:getSourceTriggerType() == 'property') and (inArray(trigger['deviceID'], lights))) then
    if ((time-lastBreached) > 1 and lightStatus == 0) then
        if (debug) then fibaro:debug("Manual override detected. Terminating scenes."); end
        fibaro:debug(fibaro:killScenes(scene));
    else
        fibaro:abort();
    end
 
elseif ( (fibaro:getSourceTriggerType() == 'property') and getSensorStatus() == 1 and checkLightLevel() and getLightStatus() == 0) then
    if (instances > 1) then fibaro:abort(); end
 
    while (keepLightOn()) do
        if (getLightStatus() == 0) then
            setLightStatus(level);
        end
        fibaro:sleep(1000);
    end
 
    if (debug) then fibaro:debug("Reached delay threshold without motion. Turning off the light."); end
    setLightStatus(0);
 
else
    if (debug) then fibaro:debug("No matching conditions. Doing nothing"); end
    fibaro:abort();
end
