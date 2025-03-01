

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Five-SeveN"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 5
	SWEP.IconLetter			= "u"
	
	killicon.AddFont( "gy_57", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end
SWEP.Class				= "gy_57"
SWEP.HoldType			= "pistol"
SWEP.Base				= "weapon_cs_base"
SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_fiveseven.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_FiveSeven.Single" )
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 24
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.015
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay			= 0
SWEP.Primary.DefaultClip	= 40
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "smg1"
SWEP.Spray					= 5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos = Vector(4.519, 0, 3.359)
SWEP.IronSightsAng = Vector(-0.5, 0, 0)