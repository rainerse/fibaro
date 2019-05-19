--[[
%% properties
2166                                     -- käivitaja seade
%% weather
%% events
%% globals
--]]
local temp_andur            = 2166;      -- temperatuuriandur
local seade                 = 2165;      -- seade mida lülitatakse
local temperatuur_avamine   = 30;        --C avamistemperatuur
local temperatuur_sulgemine = 20;        --C sulgemistemperatuur
local avamine               = "open";    -- avamine
local sulgemine             = "close";   -- sulgemine
local temperatuur_tegelik   = (tonumber(fibaro:getValue(temp_andur, "value")));
local akna_olek             = (tonumber(fibaro:getValue(seade, "value")));
print('<font color=lightblue> # 16 Käivitan stseeni');
print('<font color=lightblue> # 17 Kasvuhoone temperatuur: '.. temperatuur_tegelik .. '. Akna olek: ' .. akna_olek);
if(temperatuur_tegelik) < (temperatuur_sulgemine) then -------------------------------------------------------------------------
    print('<font color=lightblue> # 19 Temperatuur on alla ' .. temperatuur_sulgemine ..'C. Kontrollin kas aken on lahti.');  --
    if (akna_olek > 1) then -------------------------------------------------------                                          --
       print('<font color=pink> # 21 aken on lahti, panen akna kinni');           --                                          --
       fibaro:call(seade, sulgemine);                                             --     --sulgemine                          --
    else                                                                          --                                          --
       print('<font color=lightblue> # 24 Aken on kinni, ei tee midagi');         --                                          --
    end ----------------------------------------------------------------------------                                          --
elseif (temperatuur_tegelik) > (temperatuur_avamine) then                                                                    --
    print('<font color=lightblue> # 27 Temperatuur on üle ' .. temperatuur_avamine .. 'C, kontrollin kas aken on kinni');     --
    if (akna_olek) < 1 then ------------------------------------------------------                                          --
       print('<font color=lightgreen> # 29 Aken on kinni, avan akna.');           --                                          --
       fibaro:call(seade, avamine);                                               --     --avamine                            --
    else                                                                          --                                          --
    	print('<font color=lightblue> # 32 Aken on lahti, ei tee midagi.');       --                                          --
    end ----------------------------------------------------------------------------                                          --
end ----------------------------------------------------------------------------------------------------------------------------
