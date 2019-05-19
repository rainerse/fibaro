--[[ 
%% properties 
1952 value
98 value
%% globals 
--]]
--Stseen käivitatakse kui liikumisandur tuvastab liikumist 
--VÕI valgustirelee lülitatakse mujalt (käsitsi või teisest stseenist) sisse
-- ************************** seadmed - seaded ***************************** 
local stseen               = 30;   -- selle stseeni ID (vajalik selle tegevuse sunniviisiliseks lõpetamiseks)
local liikumisandur        = 1952; -- liikumisanduri ID
local valgustugevus_andur  = 383;  -- Valgusandur
local valgusti_relee       = 98;   -- valgusti relee
local valgustugevus_min    = 40;   -- valgustugevus (tuvastamaks kas ruumis on hämar)

-- Korduva stseeni peatamine (valgustugevus muutub kiiresti ja stseen võib uuesti käivituda enne kui stseen jõuab lõpuni käia)
if (fibaro:countScenes()>1) then 
 fibaro:abort(); 
end
   print('<font color=lightblue>20# käivitasin stseeni.');
-- valgusti sisse-välja lülitamine
--(kui liikumisandur tuvastas liikumise JA lüliti on väljas JA valgustugevus on alla 'hämara' väärtuse)
if (tonumber(fibaro:getValue(liikumisandur, "value")) > 0 ) 
  and (tonumber(fibaro:getValue(valgusti_relee, "value"))) < 1 
  and tonumber(fibaro:getValue(valgustugevus_andur, "value")) < valgustugevus_min then 
   fibaro:call(valgusti_relee, "turnOn");
   print('<font color=lightgreen>27# lülitasin valguse sisse');
end
-- viivituse lisamine enne kui valgusti lülitatakse välja****************************
if (tonumber(fibaro:getValue(valgusti_relee, "value"))) > 0 then                  --*
 local starttimer = 120;	 --aeg sekundites                                        --*
 local timer = (starttimer); --viivitus                                           --*
    print('<font color=lightgreen>33# Viivituse alustamine');                     --*
-- kordab tegevust kuni timer jõuab nulli**************************************   --*
 repeat                                                                     --*   --*
   fibaro:sleep(1000);                                                      --*   --*
   -- kui vajutatakse lülitit siis ootab 10 sek                             --*   --*
   -- välitmaks juhuslikku liikumise peale sisselülitamist                  --*   --*
   if (tonumber(fibaro:getValue(valgusti_relee, "value"))) < 1 then         --*   --*
     timer=1;                                                               --*   --*
     fibaro:call(valgusti_relee, "turnOff");                                --*   --*
     print('<font color=pink>42# lülitasin valgusti välja');                --*   --*      
     fibaro:sleep(10000);                                                   --*   --*
     break                                                                  --*   --*
   end                                                                      --*   --*
   timer=timer-1;                                                           --*   --*
   -- lähtestab taimeri kui tuvastatakse liikumine                          --*   --*
   if (tonumber(fibaro:getValue(liikumisandur, "value"))) > 0 then          --*   --*
     timer=starttimer;                                                      --*   --*
     print('<font color=lightgreen>50# lähtestain timeri liikumise tõttu'); --*   --*
   end                                                                      --*   --*
 until (timer<1)                                                            --*   --*
--*****************************************************************************   --*
   -- Lülita välja kuna taimer on aegunud                                         --*
   fibaro:call(valgusti_relee, "turnOff");                                        --*
   print('<font color=pink>56# lülitasin valgusti välja');                        --*
   fibaro:killScenes(stseen);                                                     --*
end                                                                               --*
--***********************************************************************************
