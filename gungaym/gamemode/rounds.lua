/* ROUND STATES
0 = Pre-round freeze
1 = In round
2 = Post round (The winner is slaughtering everyone)
3 = End of the game?
*/
function RoundStart(prevwin)
	SetGlobalInt("RoundState", 0)
	game.CleanUpMap()
	ClearEnts()
	round = GetGlobalInt("round")
	SetGlobalInt("round", round+1)
	RandomizeWeapons()
	ResetSpecial()
	
	/*local SR_go = math.random(1,1)
	if SR_go == 1 then
		SpecialRandom()
		print("Special Round!")
		--for k,v in pairs(SpecialRound) do
			--print(k,v)
		--end
	end*/
	
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
	SetGlobalInt("MaxRounds", GetConVarNumber("gy_rounds"))
	ResetSpecial()
	local maxround = GetGlobalInt("MaxRounds")
	local round = GetGlobalInt("round")
	for k,v in pairs(player.GetAll()) do
		if v ~= winner then
			v:StripWeapons()
		end
	end
	winner:Give("func_gy_wingun")
	winner:SelectWeapon("func_gy_wingun")
	SetGlobalInt("RoundState", 2)
	
	PrintMessage(HUD_PRINTCENTER, (winner:GetName().." won the round!"))
	wins = (winner:GetNWInt("wins") + 1)
	winner:SetNWInt("wins",wins)
	if wins >= 3 then
		PrintMessage(HUD_PRINTCENTER, (winner:GetName().." won the game!"))
		for k,v in pairs(player.GetAll()) do
			changemap()
		end
	end
	if round >= maxround then
		timer.Simple(1, function() changemap() end)
	else
		timer.Simple(8,function() RoundStart(wins) end)
	end
end