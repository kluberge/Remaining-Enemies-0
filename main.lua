
------ main.lua

require("cyclonelib/main")

local o_teleporter = Object.find("Teleporter", "vanilla")

local tele_sync = CycloneLib.net.AllPacket("next_stage", function(net_teleporter, active)
	local i_teleporter = net_teleporter:resolve()
	if i_teleporter and (i_teleporter:get("active") < active) then
		i_teleporter:set("active", active)
	end
end)

registercallback("onStep", function() 
	local i_teleporter = o_teleporter:find(1)
		
	if not i_teleporter then
		return nil
	end
	
	if i_teleporter:get("active") == 2 then
		local num_bosses = 0
		for _,object in ipairs(ParentObject.find("enemies", "vanilla"):findAll()) do
			if object.isBoss and object:isBoss() then
				num_bosses = num_bosses + 1
			end
		end
		
		if num_bosses == 0 and (not net.online or net.host) then
			net_teleporter = i_teleporter:getNetIdentity()
			tele_sync(net_teleporter, 3)
		end
	end
end)