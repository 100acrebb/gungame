

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "M4 Sherman"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "w"
	SWEP.ViewModelFOV		= 72
	killicon.AddFont( "gy_m4", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end
SWEP.Class				= "gy_m4"
SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_cs_base"
SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_m4a1.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_M4A1.Single" )
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 35
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.007
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 6, 0, 0.95 )
SWEP.IronSightsAng 		= Vector( 2.6, 1.37, 3.5 )

SWEP.Spray				= 5
SWEP.SprayDecay			= 1.2
SWEP.AimBoost			= .4

SWEP.LeftTend	= 1.1
SWEP.RightTend	= .4

