--[[
%% properties
117 value
%% weather
%% events
%% globals
--]]
local temp_andur = 117  	--temperatuuri andur 1347 value  minu temp andur on id117
local seade = 112           -- seade mida lülitatakse > 1346 value  minu relee on id 28
local avamis_temp = 30		-- avamistemperatuur
local sulgemis_temp = 20	-- sulgemistemperatuur
local avamine = "turnOn"	-- "open"  avamine
local sulgemine = "turnOff"	-- "close" sulgemine
local temp_value = (tonumber(fibaro:getValue(temp_andur, "value")));
local akna_olek = (tonumber(fibaro:getValue(seade, "value")));
--local startSource = fibaro:getSourceTrigger();
print("<font color='aqua'># Käivitan stseeni</font>");    
print("<font color='lightgreen'># Temperatuur: " .. temp_value);
print("<font color='lightgreen'># Akna olek:" .. akna_olek);
-----------------------------------------------------------------------------------------------------------------------
if temp_value <= sulgemis_temp then                                                                                  --
    print("<font color='aqua'># temperatuur on alla " .. sulgemis_temp .." kraadi. Kontrollin kas aken on lahti.");  --
    if ((tonumber(fibaro:getValue(seade, "value"))) == 1) then                                                       --
       print("<font color='Salmon'># Aken on lahti, panen akna kinni");                                              --
       fibaro:call(seade, sulgemine);                                                 --sulgemine                    --
    else                                                                                                             --
       print("<font color='aqua'># Aken on kinni, ei tee midagi");                                                   --
    end                                                                                                              --
end                                                                                                                  --
-----------------------------------------------------------------------------------------------------------------------
if temp_value >= avamis_temp then                                                                                    --
    print("<font color='aqua'># Temperatuue on üle " .. avamis_temp .. " kraadi, kontrollin kas aken on kinni");     --
    if akna_olek ==0 then                                                                                            --
       print("<font color='Salmon'># Aken on kinni, avan akna.");                                                    --
       fibaro:call(seade, avamine);                                                   --avamine                      --
    else                                                                                                             --
    	print("<font color='aqua'># Aken on lahti, ei tee midagi.");                                                 --
    end                                                                                                              --
end                                                                                                                  --
-----------------------------------------------------------------------------------------------------------------------
if temp_value < avamis_temp and temp_value > sulgemis_temp then                                                      --
    print("<font color='aqua'># temperatuur on sulgemise ja avamise vahel. Ei tee midagi");                          --
end                                                                                                                  --
-----------------------------------------------------------------------------------------------------------------------
