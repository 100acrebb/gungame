

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Mas Fuego"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	SWEP.IconLetter			= "k"
	
	killicon.AddFont( "gy_m3", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.Class 				= "gy_spas"
SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_gy_shotgun_base"
SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_shot_m3super91.mdl"
SWEP.WorldModel			= "models/weapons/w_shotgun.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_M3.Single" )
SWEP.Primary.Recoil			= 7
SWEP.Primary.Damage			= 7
SWEP.Primary.NumShots		= 15
SWEP.Primary.Cone			= 0.1
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.8
SWEP.Primary.DefaultClip	= 16
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos   = Vector( 2.000, 1, -1.55 )
SWEP.IronSightsAng   = Vector(0,0, 0 ) 	
SWEP.RunPenalty				= 1
SWEP.AimBoost				= .8

/*---------------------------------------------------------
   Name: SWEP:CSShootBullet( )
---------------------------------------------------------*/
function SWEP:CSShootBullet( dmg, recoil, numbul, cone )
	local d = 0
	local num = 0
	local hitplys = {}
	local info = {}
	
	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01
	
	local ang = self.Owner:GetAimVector()
	local pun = self.Owner:GetPunchAngle():Forward()

	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= ang		// Dir of bullet
	bullet.Spread 	= Vector( cone, cone, 0)			// Aim Cone
	bullet.Tracer	= 4									// Show a tracer on every x bullets 
	bullet.Force	= 300									// Amount of force to give to phys objects
	bullet.Damage	= dmg
	bullet.Callback = function(att, tr, dmginfo)
		if SERVER then
			ent = tr.Entity
			if ent:GetClass() == "player" then
				hitplys[num] = ent
				num = num + 1
				d = d + dmginfo:GetDamage()
				info = {att=dmginfo:GetAttacker(), infl=dmginfo:GetInflictor()}
			end
		end
	end
	
	
	self.Owner:FireBullets( bullet )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	if ( self.Owner:IsNPC() ) then return end
	
	if SERVER and d > 30 then //Ignites people whenver it does 30+ damage, even if it's split between multiple people
		for k,ent in pairs(hitplys) do
			ent.ignite_info = info
			ent:Ignite(5, 10)
			timer.Simple(5.1, function()
				if IsValid(ent) then
					ent.ignite_info = nil
				end
            end)
		end
	end
	
	// CUSTOM RECOIL !
	if ( (game.SinglePlayer() && SERVER) || ( !game.SinglePlayer() && CLIENT && IsFirstTimePredicted() ) ) then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil * 1
		self.Owner:SetEyeAngles( eyeang )
	
	end

end
