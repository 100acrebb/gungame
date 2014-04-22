

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "soopa shotsy"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	SWEP.IconLetter			= "k"
	
	killicon.AddFont( "gy_m3", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_cs_base"
SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_M3.Single" )
SWEP.Primary.Recoil			= 7
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 70
SWEP.Primary.Cone			= 0.4
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.8
SWEP.Primary.DefaultClip	= 16
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 5.7, -3, 3 )

SWEP.RunPenalty				= 1
SWEP.AimBoost				= .8


/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
	
	//if ( CLIENT ) then return end
	
	self:SetIronsights( false )
	
	// Already reloading
	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
	
	// Start reloading if we can
	if ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNetworkedBool( "reloading", true )
		self.Weapon:SetNetworkedBool( "reloading2", true )
		self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Owner:DoReloadEvent()
	end

end
/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()
	self:IronSight()
	local reloading = true
	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then
	
		if self.Owner:KeyPressed(IN_ATTACK) then
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
				self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
			end
			self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
			self.Weapon:SetNetworkedBool( "reloading", false)
			timer.Simple((.5), function() self.Weapon:SetNWBool("reloading2", false) end) --reloading2 prevents the gun from firing while still playing the pump anim
			return
			
		end
	
	
		if reloading then
			if ( self.Weapon:GetVar( "reloadtimer", 0 ) < CurTime() ) then
				
				// Finsished reload -
				if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
					self.Weapon:SetNetworkedBool( "reloading", false )
					return
				end
				
				// Next cycle

				self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
				self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
				self.Owner:DoReloadEvent()
				
				local num = 1
				
				if self.Owner:GetNWBool("fastreload") then
					if !(self.Weapon:Clip1() + 1 >= self.Primary.ClipSize) and (self.Owner:GetAmmoCount( self.Primary.Ammo) >= 2) then
						num = 2
					end
				end
				
				// Add ammo
				self.Owner:RemoveAmmo( num, self.Primary.Ammo, false )
				self.Weapon:SetClip1(  self.Weapon:Clip1() + num )
				
				// Finish filling, final pump
				if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
					self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
					self.Owner:DoReloadEvent()
					self.Weapon:SetNetworkedBool( "reloading2", false )
				else
				
				end
				
			end
		end
	end

end
