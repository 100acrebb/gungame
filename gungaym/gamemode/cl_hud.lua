t = {}
t.i = {}
keel = false
ded = false
sui = false

local asp = 0
if (ScrW() / ScrH()) == 16/10 then
	asp = 1.072
elseif (ScrW() / ScrH()) == 16/9 then
	asp = 1.069	
elseif (ScrW() / ScrH()) == 4/3 then
	asp = 1.0785
end
--If you don't have one of these aspect ratios, then you're SOL



--Right off the bat, I'm terrible with HUD's, so enjoy lots of text instead of a nice pretty bunch of health/ammo bars
--jk to the above, thanks Cowabanga for your mock HUD <3
function InitializeFonts()
	surface.CreateFont( "healthindicator",
	{
	font      = "Tahoma",
	size      = ScreenScale(10),
	weight    = 500
	}
	)

	surface.CreateFont( "lvlindicator",
	{
	font      = "Tahoma",
	size      = ScreenScale(9.24),
	weight    = 500
	}
	)

	surface.CreateFont( "reservedammo",
	{
	font      = "Tahoma",
	size      = ScreenScale(20),
	weight    = 500
	}
	)

	surface.CreateFont( "remainingammo",
	{
	font      = "Tahoma",
	size      = ScreenScale(32.34),
	weight    = 500
	}
	)

	surface.CreateFont( "currentweapon",
	{
	font      = "Tahoma",
	size      = ScreenScale(17.16),
	weight    = 500
	}
	)

	surface.CreateFont( "nextweapon",
	{
	font      = "Tahoma",
	size      = ScreenScale(12),
	weight    = 500
	}	)
	
	surface.CreateFont( "specround",
	{
	font      = "Tahoma",
	size      = ScreenScale(12),
	weight    = 500
	})
end


function GM:HUDPaint()

	hook.Run( "HUDDrawTargetID" )
	hook.Run( "HUDDrawPickupHistory" )
	hook.Run( "DrawDeathNotice", 0.85, 0.04 )

end

function cl_randlist()
	for k,v in pairs(weapons.GetList()) do
		if v.ClassName ~= nil then
			table.insert(t,k,(v.ClassName))
			table.insert(t.i,k,v.PrintName)
			
			--print("t list has ", v.PrintName)
		end
	end
end


function cl_randlistEx()

	--print("caching all the weps")
	for k,v in pairs(mastlist) do
		local dawep = weapons.Get( v )
		if type(dawep) == "table" then-- PrintTable(dawep) end
			if dawep.Primary and dawep.Primary.Sound then util.PrecacheSound(dawep.Primary.Sound) end
			util.PrecacheModel(dawep.ViewModel)
			util.PrecacheModel(dawep.WorldModel)
			
			--print("Registering ", v, dawep)
			weapons.Register(dawep, v)
		end
		
		
		if dawep.ClassName ~= nil then
			table.insert(t,k,(dawep.Class))
			table.insert(t.i,k,dawep.PrintName)
			
			--print("t list has ", dawep.PrintName)
		end
	end
	--print("done caching all the weps")


end

function cl_ReceiveList()
	randlist = net.ReadTable()
	--for k,v in pairs(randlist) do
	--	print ("randlist has ", k,v)
	--end
	cl_randlist()
end
net.Receive("wepcl",cl_ReceiveList)

function cl_PrevNextWeps(level)
	--print("inside cl_PrevNextWeps")
	nextwep = randlist[level+1]
	for l,p in pairs(t) do
	
		if nextwep == p then
			--print ("inside nextwep check")
			for k,v in pairs(t.i) do
				if l == k then
					--print("matched ", v)
					nextname = v
				end
			end
		end
	end
end

function DrawHUD()

	hook.Run( "HUDDrawTargetID" )
	hook.Run( "HUDDrawPickupHistory" )
	hook.Run( "DrawDeathNotice", 0.85, 0.04 )
	ply = LocalPlayer()
	local round = GetGlobalInt("round")
	health = ply:Health()
	level = ply:GetNWInt("level")
	if ply:Alive() then
	
		if GetConVarNumber("gy_nextwep_enabled") == 1 and GetGlobalInt("gy_special_round") ~= ROUND_ROYALE then
			if lasttime == nil or lasttime < CurTime() - (GetConVarNumber("gy_nextwep_delay")) then
				lasttime = CurTime()
				cl_PrevNextWeps(level)
			end
			if nextname ~= nil and level == count() then
				draw.SimpleTextOutlined("Crowbar","nextweapon", ScrW()/1.215, ScrH() /1.046, Color(161,161,161), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(74,74,74))
			elseif nextname ~= nil and level < count() then
				draw.SimpleTextOutlined((nextname),"nextweapon", ScrW()/1.215, ScrH() /1.046, Color(161,161,161), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(74,74,74))
			end
		end
		
		if IsValid(ply:GetActiveWeapon()) then
			local mag_left = ply:GetActiveWeapon():Clip1() //How much ammunition you have inside the cusrrent magazine
			local mag_extra = ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType()) //How much ammunition you have outside the current magazine
			
			name = ply:GetActiveWeapon().PrintName
			draw.SimpleTextOutlined((name) ,"currentweapon", ScrW()/1.215, ScrH()/1.08, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP,1.5, Color(74,74,74))
			

			
			if level < count() + 1 then
				draw.SimpleTextOutlined(("Level: "..level.."/"..count()) ,"lvlindicator", ScrW()/9.9, ScrH() /1.1, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(74,74,74))
			end
			
			--if prevname ~= nil and level ~= 1 then
				--draw.SimpleText((prevname) ,"prevwep", ScrW()-350, ScrH() - 180, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			--end
			
			if mag_left ~= -1 then
				draw.SimpleTextOutlined((mag_left) ,"remainingammo", ScrW()/1.145, ScrH() - 41, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1.5, Color(74,74,74))
				draw.SimpleTextOutlined(("/"..mag_extra) ,"reservedammo", ScrW()/1.145, ScrH() - 50, Color(161,161,161), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(74,74,74))
			end
			--draw.RoundedBox(10, ScrW()/15, ScrH() - 100, 250, 50, Color(100,25,25,200))
			draw.RoundedBox(2, ScrW()/9.9, ScrH() / 1.1, ScreenScale(100), ScreenScale(10), Color(106,17,17))
			draw.RoundedBox(2, ScrW()/9.9, ScrH() / 1.1, ScreenScale(math.Min(LocalPlayer():Health(),100)), ScreenScale(10), Color(33,107,33))
			if health > 100 then
				draw.RoundedBox(2, ScrW()/9.9, ScrH() / 1.1, ScreenScale(math.Min(LocalPlayer():Health()-100),100), ScreenScale(10), Color(33,33,107))
			end
			draw.SimpleTextOutlined((health) ,"healthindicator", ScrW()/3.92, ScrH() / asp, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP,1,Color(74,74,74))
			
		end
	end
	
	if lastertime == nil or lastertime < CurTime() - 4 then
		lastertime = CurTime()
		local round = GetGlobalInt("round")
		maxrounds = GetGlobalInt("MaxRounds")
	end
		
	draw.SimpleTextOutlined(("Round "..round.."/"..maxrounds) ,"reservedammo", ScrW()/10, ScrH()/1.015, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP,1,Color(74,74,74))
	
	local spec = GetGlobalVar("gy_special_round")
	if spec ~= 0 then
		local text = L.Round[spec]
		if text ~= nil then
			draw.SimpleTextOutlined(("Special Round: "..text) ,"specround", ScrW()/1.1, ScrH()/1.013, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP,1,Color(74,74,74))
		end
	end
end

hook.Add("HUDPaint","DrawHUD",DrawHUD)

function hidehud(name)
	for k, v in pairs({"CHudHealth", "CHudBattery","CHudAmmo","CHudSecondaryAmmo"})do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "HideOldHud", hidehud)
