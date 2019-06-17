--[[
%% properties
%% weather
%% events
%% globals
--]]
-- Daria stseen, mis käivitab valvestamise (igal kasutajal on oma stseen)


gl_var = 'Valve_Daria';
tegevus = 'arm';
valve = 'gsm_valve';
--vajalik ainult muutujate kirjete loomiseks
function CreateGlobalVar(var, value) -------------------------------------------------------
  local http = net.HTTPClient()                                                           --
  http:request("http://127.0.0.1:11111/api/globalVariables", { ------------------------   --
      options = {                                                                    --   --
        method = 'POST',                                                             --   --
        headers = {},                                                                --   --
        data = '{"name":"'..var..'","value":"'..value..'"}',                         --   --
        timeout = 2000},                                                             --   --
        success = function(status)                                                   --   --
	      print('<font color=green>21 # muutuja ' .. var .. ' loodud.')              --   --
        end,                                                                         --   --
        error = function(err)                                                        --   --
          print('<font color=red>24 # Ei suuda teha ' ..gl_var..' muutujat '.. err)  --   --
        end                                                                          --   --
    })---------------------------------------------------------------------------------   --
end ----------------------------------------------------------------------------------------
--*****************kontrollib kas muutujad on olemas****************************************
	if (fibaro:getGlobalValue(gl_var) == nil) then CreateGlobalVar(gl_var, 'z') end; 	--**
	if (fibaro:getGlobalValue(valve) == nil) then CreateGlobalVar(valve, 'z') end; 	    --**
--******************************************************************************************
 --fibaro:setGlobal(valve, 'arm');

--::::::::muuujate muutmine:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if (fibaro:getGlobalValue(valve) ~= 'arm') then --kui gsm_valve <> 'arm'                  ::
  print('<font color=green>36 # Muudan parameetri '..gl_var..' väärtuse: '..tegevus); --  ::
  fibaro:setGlobal(gl_var, tegevus);	--	                                              ::
  fibaro:sleep(5000);  --ootan 5 sek                                                      ::
  print('<font color=blue>39 # Muudan parameetri '.. gl_var ..' väärtuse: 0-ks'); --      ::
  fibaro:setGlobal(gl_var, 0);--	  	                                                  ::
  fibaro:setGlobal(valve, 'arm');--                                                       ::
else                                       -- kui oli valves                              ::
  print('<font color=red>42 # Hoone oli juba valves, ei tee midagi.'); --                 ::
  api.post('/mobile/push', {["mobileDevices"]={8}, --                                     ::
  ["message"]=[[Kodu on juba valves]], ["title"]='Künka:', --                             ::
  ["category"]='RUN_CANCEL', ["data"]={["sceneId"]=0}}); --                              ::
end --                                                                                    ::
--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
