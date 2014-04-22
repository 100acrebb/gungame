local ply = FindMetaTable("Player")

local teams = {}
teams[0] = {name = "Gaymers"}

function ply:ChangeStat(stat,num)
	local prevstat = self:GetPData(stat)
	if prevstat == nil then
		self:SetPData(stat,num)
	else
		self:SetPData(stat,prevstat + num)
	end
end

function yes(ply)

end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	// More damage if we're shot in the head
	if hitgroup == HITGROUP_HEAD then
		dmginfo:GetAttacker():SendLua('surface.PlaySound("player/bhit_helmet-1.wav")')
		timer.Simple(-1,function() 
			ply:EmitSound("player/bhit_helmet-1.wav", 511, 100)
			for x = 1,200 do
				local effectdata2 = EffectData()
				effectdata2:SetStart(ply:GetBonePosition(6))
				effectdata2:SetOrigin(ply:GetBonePosition(6))
				effectdata2:SetScale(100)
				util.Effect("StunstickImpact", effectdata2)
			end
		end)
	end
	
		if ply:Crouching() then
			math.ceil(dmginfo:ScaleDamage( 0.55 ))
		end
		
		if ( hitgroup == HITGROUP_HEAD ) then
			math.ceil(dmginfo:ScaleDamage( ply:GetActiveWeapon().HeadshotMult or 2 ))
			if math.ceil(dmginfo:GetDamage() * 2 ) > ply:Health() then
				 dmginfo:SetDamageForce(dmginfo:GetDamageForce()*100000) --woosh
			end
		end

	-- Less damage if we're shot in the arms or legs
	if ( hitgroup == HITGROUP_LEFTARM ||
		 hitgroup == HITGROUP_RIGHTARM || 
		 hitgroup == HITGROUP_LEFTLEG ||
		 hitgroup == HITGROUP_RIGHTLEG ||
		 hitgroup == HITGROUP_GEAR ) then
			if (dmginfo:GetInflictor():GetClass() ~= "gy_python") and (dmginfo:GetInflictor():GetClass() ~= "gy_deagle") then
				dmginfo:ScaleDamage( 0.25 )
			end
	 end

end

function ply:KillStreak()
	self:SetNWInt("lifelevel",0)
	self:AwardPerk()
	GAMEMODE:SetPlayerSpeed(self, 550, 550)
	self:SetJumpPower( 300 )
	self:SetNWBool("boosted",true)
	local trail = util.SpriteTrail(self, 0, Color(255,0,0), false, 40, 30, 5.5, 1/(15+1)*0.5, "trails/plasma.vmt")
	timer.Simple(5.5,function() 
		GAMEMODE:SetPlayerSpeed(self, 210, 350)
		trail:Remove()
		self:SetJumpPower( 200 )
		self:SetNWBool("boosted", false)
	end)
end

function ply:Demote()
	print(self:GetName().." leveled down")
	local prevlevs = self:GetNWInt("level")
	if prevlevs > 1 then
		self:SetNWInt("level", prevlevs - 1)
	end
end

function ply:SetGod(b)
	if b == true then
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:SetColor( Color(255, 255, 255, 100) )
		self:GodEnable()
	elseif b == false then
		self:SetColor( Color(255, 255, 255, 255) )
		self:GodDisable()
	end
end

function ply:GiveWeapons()
	if GetGlobalInt("gy_special_round") == ROUND_ROYALE then 
		local wep = table.Random(weplist)
			self:StripWeapons()
			self:Give("gy_knife")
			self:Give(wep)
			self:SelectWeapon(wep)
	return end
	self:StripWeapons()
	
	local y = self:GetNWInt("level")
	local weppast = weplist[y-1]
	local wep = weplist[y]
	local wepnext = weplist[y+1]
	
	if wep ~= nil then
		self:Give(wep)
		self:Give("gy_knife")
		self:Give("func_gy_trans")
		self:SelectWeapon("func_gy_trans") --For whatever reason, if I don't swap to another weapon and then...
		self:SetAmmo(weapons.Get(wep).Primary.ClipSize * 2, "smg1",true)
		timer.Simple(.01,function() self:SelectWeapon(wep);self:StripWeapon("func_gy_trans") end) --...swap to the new weapon, the new weapon doesn't do the draw anim
	else
		self:Give("gy_crowbar")
		self:Give("func_gy_trans") --I made a silent transitive weapon to avoid the SHING of the knife's draw sound
		self:SelectWeapon("func_gy_trans") 
		timer.Simple(.01,function() self:SelectWeapon("gy_crowbar");self:StripWeapon("func_gy_trans") end)
	end
	
	if GetConVar("gy_cowa_birthday"):GetInt() == 1 then --Remove this before release
		local num = self:SteamID() --If I put this in the public release, feel free to call me an idiot on steam!
		if num == "STEAM_0:0:21836277" then
			self:StripWeapons()
			self:Give("cowa")
		end
	end
end 

function GM:GetFallDamage( ply, speed )
	return speed/50 --Random num pulled out of my ass
end

function GM:PlayerDeathThink( pl )
	if GetGlobalInt("gy_special_round") == ROUND_ROYALE then return end
	if (  pl.NextSpawnTime && pl.NextSpawnTime > CurTime() ) or (GetGlobalInt("RoundState") == 2) then return end

	if ( pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) then
	
		pl:Spawn()
		
	end
	
end

local time = CurTime()

function OverhealDecay()
	if CurTime() > (time) then
		time = CurTime() + (1 / (GetConVar("gy_overheal_decay"):GetInt() or 1))
		for k,v in pairs(player.GetAll()) do
			local hp = v:Health()
			if hp > 100 then
				v:SetHealth(hp - 1)
			end
		end
	end
end

hook.Add("Tick", "OverhealDecayHook", OverhealDecay)