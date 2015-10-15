--You can just drop new weapon ents into the master list and the game will adapt, no extra configuring needed!
mastlist = {"m9k_intervention","m9k_ithacam37","m9k_jackhammer","m9k_m3","m9k_m24","m9k_m60","m9k_m98b","m9k_m249lmg","m9k_m1918bar","m9k_minigun","m9k_mossberg590","m9k_pkm","m9k_psg1","m9k_remington870","m9k_remington7615p","m9k_sl8","m9k_spas12","m9k_striker12","m9k_svt40","m9k_svu","m9k_usas","m9k_1887winchester","m9k_1897winchester","m9k_ares_shrike","m9k_aw50","m9k_barret_m82","m9k_browningauto5","m9k_contender","m9k_dbarrel","m9k_dragunov","m9k_fg42","gy_m4","gy_mp5","gy_glock","gy_tmp","gy_deagle","gy_awp","gy_ak","gy_m3","gy_g3","gy_onii_launcher","gy_cz","gy_ppsh","weapon_python","gy_spas","gy_aa12","weapon_asmd","weapon_coilgun","weapon_prism","halo_swep_grenade","halo_swep_magnum","halo_swep_rocketlauncher","halo_swep_shotgun","halo_swep_smgsil","halo_swep_sniper","halo_swep_superassaultrifle","halo_swep_assaultrifle","halo_swep_battlerifle","halo_swep_dmr", "weapon_ss2_zapgun","weapon_ss2_autoshotgun","weapon_ss2_cannon","weapon_ss2_colt","weapon_ss2_doubleshotgun","weapon_ss2_grenadelauncher","weapon_ss2_klodovik","weapon_ss2_plasmarifle","weapon_ss2_rocketlauncher","weapon_ss2_seriousbomb","weapon_ss2_sniper","weapon_ss2_uzi","crysis_wep_ay-69","crysis_wep_feline","crysis_wep_fy71","crysis_wep_grendel","crysis_wep_hammer","crysis_wep_hmg","crysis_wep_m12nova","crysis_wep_marshall","crysis_wep_mk60","crysis_wep_scoped","hr_swep_srs99","hr_swep_assault_rifle","hr_swep_concussion_rifle","hr_swep_dmr","hr_swep_magnum","hr_swep_needle_rifle","hr_swep_needler","hr_swep_plasma_rifle","hr_swep_shotgun","hr_swep_spartan_laser","hr_swep_spiker","s8_sniper_a","s8_assault_rifle_a","s8_pistol_a","s8_shotgun"}




weplist = mastlist --Probably don't need to do this, but nothing wrong with safety

--I found this function online, was much smaller than the 3 function colossus I had :p
function RandomizeWeapons()
	local max_weapons =15
	
	weplist = table.Copy(mastlist)

	for i = #mastlist, 2, -1 do -- backwards
		local r = math.random(i) -- select a random number between 1 and i
		weplist[i], weplist[r] = weplist[r], weplist[i] -- swap the randomly selected item to position i
	end  
	
	while (weplist[max_weapons+1] ~= nil) do
		table.remove(weplist, max_weapons+1)
	end

	
end

--Counts how many weapons there are in the list at the top
function count()
	--[[local c=0
	for _ in pairs(mastlist) do
		c=c+1
	end
	return(c)]]
	
	return 15--#weplist
end



local function wepmodelinit()
	print("registering and caching all the sweps")
	for k,v in pairs(mastlist) do
		local dawep = weapons.Get( v )
		--print(dawep)
		if type(dawep) == "table" then-- PrintTable(dawep) end
			if dawep.Primary and dawep.Primary.Sound then util.PrecacheSound(dawep.Primary.Sound) end
			util.PrecacheModel(dawep.ViewModel)
			util.PrecacheModel(dawep.WorldModel)
			
			print("Registering ", v, dawep)
			weapons.Register(dawep, v)
		end
	end
	print("done caching all the weps")
end
hook.Add( "Initialize", "some_unique_namexxxx", wepmodelinit )

if (CLIENT) then
	wepmodelinit()
end