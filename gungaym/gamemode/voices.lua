/*Categories:
On kill ("Got one!", "He's dead!", "Enemy down!"...)
On reload ("New mag!", "Topping off!" (sequential reloads only), "Reloading!"...)
On headshot ("Ha, blew his head clean off!", "Ooh, great shot!", "Damn fine shooting"...)
On kill w/ fire ("Burn, buuuuuurn!", "Mmm, toasty", "Christ, that's gonna be a closed casket funeral" (also headshots?)...)
On longshot kill ("Fuck yeah, bagged him from a hundred yards", "God-DAMN I'm a good shot!", "Aaaaand... bullseye" (also headshots?)...)
On melee kill ("Cut him up!", "Slice and dice", "Nothing wrong with some hand to hand"...)
Shot by sniper, wait a few secs (variations of "SNIPER!")
*/

vo = {}

vo.GenericKill = {
	"bot/enemy_down.wav",
	"bot/enemy_down2.wav",
	"bot/took_him_down.wav",
	"bot/took_him_out.wav",
	"bot/took_him_out2.wav",
	"ericisgay/voicesinmyhead/kill_gen01.wav", --Below are from CoD:WaW
	"ericisgay/voicesinmyhead/kill_gen02.wav",
	"ericisgay/voicesinmyhead/kill_gen03.wav",
	"ericisgay/voicesinmyhead/kill_gen04.wav",
	"ericisgay/voicesinmyhead/kill_gen05.wav",--Some CoD4's in here too
	"ericisgay/voicesinmyhead/kill_gen06.wav",
	"ericisgay/voicesinmyhead/kill_gen07.wav",
	"ericisgay/voicesinmyhead/kill_gen08.wav",
	"ericisgay/voicesinmyhead/kill_gen09.wav",
	"ericisgay/voicesinmyhead/kill_gen10.wav",
	"ericisgay/voicesinmyhead/kill_gen11.wav",
	"ericisgay/voicesinmyhead/kill_gen12.wav",
	"ericisgay/voicesinmyhead/kill_gen13.wav",
	"ericisgay/voicesinmyhead/kill_gen14.wav",
	"ericisgay/voicesinmyhead/kill_gen15.wav",
	"ericisgay/voicesinmyhead/kill_gen16.wav",
	"ericisgay/voicesinmyhead/kill_gen17.wav",
	"ericisgay/voicesinmyhead/kill_gen18.wav",
	"ericisgay/voicesinmyhead/kill_gen19.wav",
	"ericisgay/voicesinmyhead/kill_gen20.wav",
	"ericisgay/voicesinmyhead/kill_gen21.wav",
	"ericisgay/voicesinmyhead/kill_gen22.wav",
	"ericisgay/voicesinmyhead/kill_gen23.wav",
	"ericisgay/voicesinmyhead/kill_gen24.wav",
	"ericisgay/voicesinmyhead/kill_gen25.wav",
	"ericisgay/voicesinmyhead/kill_gen26.wav",
	"ericisgay/voicesinmyhead/kill_gen27.wav",
	"ericisgay/voicesinmyhead/kill_gen28.wav",
	"ericisgay/voicesinmyhead/kill_gen29.wav",
	"ericisgay/voicesinmyhead/kill_gen30.wav",
	"ericisgay/voicesinmyhead/kill_marksman01.wav",
	"ericisgay/voicesinmyhead/kill_burn01.wav"
}

vo.MeleeKill = {
	"bot/hes_broken.wav",
	"bot/i_am_dangerous.wav",
	"bot/owned.wav",
	"bot/wasted_him.wav",
	"bot/yea_baby.wav"
}

--Some of these nicked from TTT
vo.GenericDeath = {
	"ericisgay/voicesinmyhead/death_burn01.wav",
	"ericisgay/voicesinmyhead/death_gen01.wav",
	"ericisgay/voicesinmyhead/death_gen02.wav",
	"ericisgay/voicesinmyhead/death_gen03.wav",
	"ericisgay/voicesinmyhead/death_gen04.wav",
	"ericisgay/voicesinmyhead/death_gen05.wav",
	"ericisgay/voicesinmyhead/death_gen06.wav",
	"ericisgay/voicesinmyhead/death_gen07.wav",
	"ericisgay/voicesinmyhead/death_gen08.wav",
	"ericisgay/voicesinmyhead/death_gen09.wav",
	"ericisgay/voicesinmyhead/death_gen10.wav",
	"ericisgay/voicesinmyhead/death_gen11.wav",
	"ericisgay/voicesinmyhead/death_gen12.wav",
	"ericisgay/voicesinmyhead/death_gen13.wav",
	"ericisgay/voicesinmyhead/death_gen14.wav",
	"ericisgay/voicesinmyhead/death_gen15.wav",
	"ericisgay/voicesinmyhead/death_gen16.wav",
	"ericisgay/voicesinmyhead/death_gen17.wav",
	"ericisgay/voicesinmyhead/death_gen18.wav",
	"ericisgay/voicesinmyhead/death_gen19.wav",
	"ericisgay/voicesinmyhead/death_gen20.wav",
	"ericisgay/voicesinmyhead/death_gen21.wav",
	"player/death1.wav",
	"player/death2.wav",
	"player/death5.wav",
	"player/death3.wav",
	"player/death6.wav",
	"player/death4.wav",
	"vo/npc/male01/pain07.wav",
	"vo/npc/male01/pain08.wav",
	"vo/npc/male01/pain09.wav",
	"vo/npc/male01/pain04.wav",
	"vo/npc/Barney/ba_pain06.wav",
	"vo/npc/Barney/ba_pain07.wav",
	"vo/npc/Barney/ba_pain09.wav",
	"vo/npc/Barney/ba_ohshit03.wav",
	"vo/npc/Barney/ba_no01.wav",
	"vo/npc/male01/no02.wav",
	"hostage/hpain/hpain1.wav",
	"hostage/hpain/hpain2.wav",
	"hostage/hpain/hpain3.wav",
	"hostage/hpain/hpain4.wav",
	"hostage/hpain/hpain5.wav",
	"hostage/hpain/hpain6.wav",
	"bot/ow_its_me.wav"
}

vo.KillUrslef = {
	"ericisgay/voicesinmyhead/suicide01.wav",
	"ericisgay/voicesinmyhead/suicide02.wav",
	"ericisgay/voicesinmyhead/suicide03.wav",
	"ericisgay/voicesinmyhead/suicide04.wav",
	"ericisgay/voicesinmyhead/suicide05.wav",
	"ericisgay/voicesinmyhead/suicide06.wav"
}

for i,j in pairs(vo) do
	for k,v in pairs(j) do
		util.PrecacheSound( v )
	end
end


function VoiceOnKill(victim, weapon, killer)
	local chance = GetConVar("gy_killvoice_chance"):GetInt()
	if chance < 1 then return end
	local case = nil
	
	if victim == killer then
		case = vo.KillUrslef
	else
		weapon = killer:GetActiveWeapon()
		if ((weapon:GetClass() == "gy_knife") or (weapon:GetClass() == "gy_crowbar")) then
			case = vo.MeleeKill
		else
			case = vo.GenericKill
		end
		
		local roll = math.random(1,chance or 6)
		if roll == 1 then
			timer.Simple(.5, function() killer:EmitSound(table.Random(case),150) end)
		end
		
		if weapon:GetClass() ~= "gy_tmp" then
			victim:EmitSound(table.Random(vo.GenericDeath),150)
		end
	end
	
	if case == vo.KillUrslef then 
		killer:EmitSound(table.Random(case),150)
	else
		local roll = math.random(1,chance or 6)
		if roll == 1 then
			timer.Simple(.5, function() killer:EmitSound(table.Random(case),150) end)
		end
		print(roll)
	end
	

end

//hook.Add( "PlayerDeath", "speechkill", VoiceOnKill )