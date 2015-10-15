/* ROUND STATES
0 = Pre-round freeze
1 = In round
2 = Post round (The winner is slaughtering everyone)
3 = We don't talk about round state 3
*/

function SpecialRound(force)
	if GetConVar("gy_special_rounds"):GetInt() == 0 then return end
	if true then return end--The lazy man's way of commenting out
	local rounds = {ROUND_SPLODE,ROUND_BARREL,ROUND_ROYALE,ROUND_BOOTY}

	if force ~= nil then
		if force == 0 then
			selection = 0
		else
			selection = rounds[force]
		end
	else
		selection = table.Random(rounds)
		if (selection == ROUND_ROYALE) and (#player.GetAll() < 2) then
			SpecialRound()
			return
		end
	end
	
	print("Special round! "..L.Round[selection])
	PrintMessage(HUD_PRINTTALK,"--"..L.RoundDesc[selection].."--")
	
	SetGlobalInt("gy_special_round",selection)
	SetGlobalBool("LastSpec",true)
end

function RoundStart()
	--ImportEntities(game.GetMap())
	SetGlobalInt("RoundState", 0)
	ClearEnts()
	round = GetGlobalInt("round")
	SetGlobalInt("round", round+1)
	RandomizeWeapons()
	
	if math.random(1,5) == 7 then -- never gonna happen!
		SpecialRound()
	else
		SetGlobalInt("gy_special_round",0)
		SetGlobalBool("LastSpec",false)
	end
	for k,v in pairs(player.GetAll()) do
		net.Start("wepcl")
			net.WriteTable(weplist)
		net.Send(v)
		v:SetNWInt("level",1)
		v:Spawn()
		v:Lock()
		
		if CLIENT then
			v:cl_PrevNextWeps(level)
		end
		
		timer.Simple(2,function()
			v:UnLock() --Unfreeze
			SetGlobalInt("RoundState",1)--Start the round
		end)
	end
end

function RoundEnd(winner)
	if winner == 99 then
		PrintMessage(HUD_PRINTCENTER, ("Good job, you all fucked up!"))
	else	
		for k,v in pairs(player.GetAll()) do
			if v ~= winner then
				v:StripWeapons()
			end
		end
		--winner:Give("func_gy_wingun")
		--winner:SelectWeapon("func_gy_wingun")
		PrintMessage(HUD_PRINTCENTER, (winner:GetName().." won the round!"))
	end
	SetGlobalInt("MaxRounds", GetConVarNumber("gy_rounds"))
	local maxround = GetGlobalInt("MaxRounds")
	local round = GetGlobalInt("round")


	SetGlobalInt("RoundState", 2)
	
	

	if round >= maxround then
		--timer.Simple(1, function() MapVote.Start(10, false, 12, {"gg_","ttt_"}) end)
		timer.Simple(1, function() MapVote.Start() end)
	else
		timer.Simple(8,function() RoundStart() end)
	end
end