

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Other Kalash"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "b"
	
	killicon.AddFont( "gy_ak", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end
SWEP.Class				= "gy_ak47"
SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_cs_base"
SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_ak47.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Recoil			= .5
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
//SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.07
SWEP.Primary.DefaultClip	= 60
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos = Vector(6.063, -2.599, 2.282)
SWEP.IronSightsAng = Vector(2.48, -0.101, 0)

SWEP.ZoomFOV	= 70
SWEP.ZoomTime 	= .1
SWEP.AimBoost = .3
SWEP.Spray = 5

SWEP.ReloadMult = 4
SWEP.LeftTend = .1
SWEP.RightTend = 1.5

function SWEP:PrimaryAttack()
	local recoil = self.Primary.Recoil
	local cone = self.Primary.Cone
	local delay = self.Primary.Delay
	local shots = self.Primary.NumShots
	
	if self.Owner:GetNWBool("doubletap") then
		delay = self.Primary.Delay / 2
		shots = self.Primary.NumShots * 2
	end
	
	self.Weapon:SetNextSecondaryFire( CurTime() + delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + delay )
	
	if ( !self:CanPrimaryAttack() ) then return end
	if  self:GetNWBool("reloading") then return end --WHERE THE ACTUAL SHOOTY BITS BEGIN
	
	// Play shoot sound
	if GetGlobalInt("gy_special_round") == ROUND_BOOTY then
		self.Weapon:EmitSound( "ericisgay/sillyblacks.wav")
	else
		self.Weapon:EmitSound( self.Primary.Sound )
	end
	
	if self.dt.Ironsight then
		recoil =  recoil * (self.AimBoost or .75)
		cone = cone * (self.AimBoost or .75)
	elseif self.Owner:KeyDown(IN_SPEED) and (self.Owner:GetVelocity():Length() > (self.Owner:GetWalkSpeed() + 1)) then
		recoil =  recoil * (self.RunPenalty or 1.5)
		cone = cone * (self.RunPenalty or 1.5)
	end
	
	if SERVER then
		self.Owner:SetGod(false)
	end
	
	--This will measure how many shots have been fired in the last second (or whatever SprayDecay is)
	--for use when calculating spray (more shots = more spray)
	self:SetNWFloat("SprayAdditive",self:GetNWFloat("SprayAdditive") + 1 )
	timer.Simple(self.SprayDecay, function() if IsValid(self) then self:SetNWFloat("SprayAdditive",math.max(0, self:GetNWFloat("SprayAdditive") - 1)) end end)
	
	
	recoil = recoil * (self:GetNWFloat("SprayAdditive") ^ .2)
	// Shoot the bullet
	self:CSShootBullet( self.Primary.Damage, recoil, shots, cone )
	
	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )
	
	if ( self.Owner:IsNPC() ) then return end
	
	// Punch the player's view
	self.Owner:ViewPunch( Angle( math.Rand(-1.5,-.5) * recoil, math.Rand(-0.5 * self:GetNWFloat("SprayAdditive") ^ .5 ,0.5 * self:GetNWFloat("SprayAdditive") ^ .5) * recoil, 0 ) )
	
	// In singleplayer this function doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (game.SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
end


/*---------------------------------------------------------
   Name: SWEP:CSShootBullet( )
---------------------------------------------------------*/
function SWEP:CSShootBullet( dmg, recoil, numbul, cone )

	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01
	
	local conemult = 4 --Needed to offset the extra viewpunch
	
	local ang = self.Owner:GetAimVector()
	local pun = self.Owner:GetPunchAngle():Forward()
	local spray = self.Spray
	
	iron = ( self.dt.Ironsight )
	if iron then
		spray = spray * .25
	end
	
	if self.Owner:GetNWBool("deadeye") then
		spray = 0
		cone = cone * .65
		recoil = recoil * .5
	end
	
	if spray > 0 then
		ang = Vector(ang.x, ang.y+ ((math.abs(self:GetNWFloat("SprayAdditive"))* .001 * spray) * math.Rand(-self.RightTend,self.LeftTend)), ang.z + (math.abs(self:GetNWFloat("SprayAdditive"))* .002 * spray))
	end

	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= ang		// Dir of bullet
	bullet.Spread 	= Vector( cone*conemult, cone, 0 )			// Aim Cone
	bullet.Tracer	= 1									// Show a tracer on every x bullets 
	bullet.Force	= 1000									// Amount of force to give to phys objects
	bullet.Damage	= dmg
	
	self.Owner:FireBullets( bullet )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	if self.Owner:GetNWBool("doubletap") then
		self.Owner:GetViewModel():SetPlaybackRate(2)
	end
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
	if ( self.Owner:IsNPC() ) then return end
	
	// CUSTOM RECOIL !
	if ( (game.SinglePlayer() && SERVER) || ( !game.SinglePlayer() && CLIENT && IsFirstTimePredicted() ) ) then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil *0.1
		eyeang.yaw = eyeang.yaw + recoil * math.Rand(-self.RightTend, self.LeftTend) * (self:GetNWFloat("SprayAdditive") * .05) * .3
		self.Owner:SetEyeAngles( eyeang )
	
	end

end