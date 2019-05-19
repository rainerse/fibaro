--[[
%% properties
1347
%% weather
%% events
%% globals
--]]
local temp_andur            = 1347      -- temperatuuri andur
local seade                 = 1346      -- seade mida lülitatakse
local temperatuur_avamine   = 30        -- avamistemperatuur
local temperatuur_sulgemine = 20        -- sulgemistemperatuur
local avamine               = "open"    -- avamine
local sulgemine             = "close"   -- sulgemine
local temperatuur_tegelik   = (tonumber(fibaro:getValue(temp_andur, "value")));
local akna_olek             = (tonumber(fibaro:getValue(seade, "value")));
print('<font color=lightblue> # 16 Käivitan stseeni');
print('<font color=lightblue> # 17 Kasvuhoone temperatuur: '.. temperatuur_tegelik);
print('<font color=lightblue> # 18 Akna olek: ' .. akna_olek);
if(temperatuur_tegelik) < (temperatuur_sulgemine) then --;
    print('<font color=lightblue> # 20 Temperatuur on alla ' .. temperatuur_sulgemine ..' kraadi. Kontrollin kas aken on lahti.');
    if (akna_olek == 1) then 
       print('<font color=pink> # 22 aken on lahti, panen akna kinni');
       fibaro:call(seade, sulgemine);--sulgemine
    else
       print('<font color=lightblue> # 25 Aken on kinni, ei tee midagi');
    end
elseif (temperatuur_tegelik) > (temperatuur_avamine)) then 
    print('<font color=lightblue> # 28 Temperatuur on üle ' .. temperatuur_avamine .. ' kraadi, kontrollin kas aken on kinni');
    if (akna_olek) ==0) then 
       print('<font color=lightgreen> # 31 Aken on kinni, avan akna.');
       fibaro:call(seade, avamine);--avamine
    else 
    	print('<font color=lightblue> # 33 Aken on lahti, ei tee midagi.');
    end
end
