--[[ 
%% properties 
484 value
%% globals 
--]]

-- Don't allow the scene to run multiple times concurrently
if (fibaro:countscenes() > 1) then 
    fibaro:abort();
end



--[[
    This script controls the lighting based on motion and lux sensor data.
    It turns the light on when motion is detected and the light is off.
    The light will remain on for a specified time or until no motion is detected.
    If the user manually adjusts the dimmer, the scene will end.
    
    Variables:
    - motionSensorID: ID of the motion sensor.
    - luxSensorID: ID of the lux (light) sensor.
    - dimmerID: ID of the dimmer controlling the light.
    - timerInitialValue: Duration (in seconds) for which the light stays on after motion is detected.
    - brightnessLevel: Brightness level for the light when turned on (0-100).
    - waitTime: Time to wait before allowing the scene to be re-triggered after manual dimmer adjustment.
    - daylightUpperLimit: The lux value above which the light will not turn on (for daylight conditions).
    - turnedOnByScene: Is the scene turned on the light
    Written by Rainer Seljamäe 2025.01.12
]]
    

-- VARIABLES 
local motionSensorID = 484; -- List it in the %% properties section
local luxSensorID = 377;
local dimmerID = 498; 
local timerInitialValue = 300;
local brightnessLevel = 5;
local waitTime = 10;
local daylightUpperLimit = 20;
local turnedOnByScene = false


--[[
    Turn the lights on if motion is detected, the light is off, and it's dark enough (based on lux sensor value)
     Check if motion is detected
     Ensure the light is currently off
     Check if the ambient light level is below the threshold for night mode
]]
 if (tonumber(fibaro:getValue(motionSensorID, "value")) > 0) 
    and (tonumber(fibaro:getValue(dimmerID, "value"))) < 1 
    and tonumber(fibaro:getValue(luxSensorID, "value")) < daylightUpperLimit
then 
    turnedOnByScene = true
    fibaro:call(dimmerID, "setValue", tostring(brightnessLevel));
    fibaro:debug("Turn light on");
end


--[[ 
    Timer setup to control the light after motion is detected.
    The timer starts when the scene triggers the light.
    If the user adjusts the dimmer manually, the scene will be ended.
    If no motion is detected, the light will automatically turn off after the timer expires.
]]
if (turnedOnByScene) then
    local timer = (timerInitialValue);  -- Set the initial timer value
    fibaro:debug("Timer started");
    
    repeat 
        fibaro:sleep(1000);
        -- Check if the user manually changed the dimmer level (light adjustment)
        if (tonumber(fibaro:getValue(dimmerID, "value"))) ~= brightnessLevel then 
            fibaro:debug("User manually adjusted light, ending scene");
            fibaro:sleep(1000 * waitTime); -- Wait for the specified wait time to prevent accidental re-triggering of the scene
            fibaro:killScenes(__fibaroSceneId); -- End the scene
        end
        
        timer = timer - 1; -- Decrease the timer by 1 second
        
        -- Reset the timer if new motion is detected during the delay period
        if (tonumber(fibaro:getValue(motionSensorID, "value"))) > 0 then 
            timer = timerInitialValue; -- Reset the timer to its initial value
            fibaro:debug("Timer has been initialized by motion sensor");
        end 
    until (timer < 1) -- Exit the loop when the timer reaches 0
    
    -- Turn the light off after the timer expires
    fibaro:call(dimmerID, "setValue", tostring(0)); -- Set the dimmer to 0 (off)
    fibaro:debug("Timer expired, turning the light off"); -- Debug message indicating the light is turned off
    fibaro:killScenes(__fibaroSceneId); -- Kill the scene after it finishes
else
    fibaro:debug("The light was not turned on by the scene")
end
