
------ main.lua

local o_teleporter = Object.find("Teleporter", "vanilla")

local teleporterSyncPacket = net.Packet("Sync Teleporter", function(sender, net_teleporter)
	local i_teleporter = net_teleporter:resolve()
	i_teleporter:set("active", 3)
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
			i_teleporter:set("active", 3)
			
			net_teleporter = i_teleporter:getNetIdentity()
			teleporterSyncPacket:sendAsHost(net.ALL, nil, net_teleporter)
		end
	end
end)