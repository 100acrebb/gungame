CreateClientConVar( "gy_nextwep_enabled", "1", true, false )
CreateClientConVar( "gy_nextwep_delay", ".4", true, false )
include( "shared.lua" )
include( "cl_hud.lua" )
include( "wepgen.lua" )
include( "cl_hudpickup.lua" )
InitializeFonts()
include( "cl_deathnotices.lua" )

 


print("caching all the weps")
	for k,v in pairs(weplist) do
		print (v)
		local dawep = weapons.Get( v )
		print(dawep)

		--[[if (dawep.Primary and dawep.Primary.Sound) then util.PrecacheSound(dawep.Primary.Sound) end
		print (dawep.ViewModel)
		util.PrecacheModel(dawep.ViewModel)
		print (dawep.WorldModel)
		util.PrecacheModel(dawep.WorldModel)
		dawep:Remove()]]
	end
	print("done caching all the weps")