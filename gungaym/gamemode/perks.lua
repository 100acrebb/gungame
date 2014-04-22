local ply = FindMetaTable("Player")

perks = {"fastreload","doubletap","deadeye"}

function ply:AwardPerk()
	local text = nil
	for k,v in RandomPairs(perks) do
		award = v
		if self:GetNWBool(award) == false then
			self:SetNWBool(award,true)
			if award == "fastreload" then
				text = "Sleight of Hand"
			elseif award == "doubletap" then
				text = "Double Tap"
			elseif award == "deadeye" then
				text = "Dead Eye"
			end
			break
		end	
	end
	
	if text ~= nil then
		self:PrintMessage(HUD_PRINTTALK,"You got the perk "..text.."!")
	else
		self:PrintMessage(HUD_PRINTTALK,"Whoops, you already got all the perks!")
	end
end


function RespawnPerk(pos)
	local round = GetGlobalInt("round")
	timer.Simple(GetConVar("gy_pickup_respawntime"):GetInt() or 25,function()
		if round ~= GetGlobalInt("round") then return end --Prevents stacking perks over rounds
		local ent = ents.Create("gy_medkit")
		ent:SetPos(pos)
		ent:Spawn()
	end)
end

function RespawnMedkit(pos)
	local round = GetGlobalInt("round")
	timer.Simple(GetConVar("gy_pickup_respawntime"):GetInt() or 25,function()
		if round ~= GetGlobalInt("round") then return end --Prevents stacking medkits over rounds
		local ent = ents.Create("gy_medkit")
		ent:SetPos(pos)
		ent:Spawn()
	end)
end