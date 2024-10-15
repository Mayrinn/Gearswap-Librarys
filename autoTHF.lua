-- contains rdm specfic additional functions made by evalyn. needed for this.
include('thflib')
-- contains various non job specfic functions made by evalyn. needed for this.
include('evalib')

--It cures, it uses drugs, it spams WSs, it nukes it's a basic rdm bot o.o
oldtarget = 0
sambamode = "haste"
tagged = false
engaged = false
fmcount = FMove()
claimableQBool = false
mobtarbool = false
lastbottime = currentBotTime
mename = player.name
plmpp = 100
plmp = 300
plhpp = 100
mobname = ''
mobdist = 30
propermob = false 
newtargetneed = true
function RDMBOT()
	updateVariables()
	local pl = windower.ffxi.get_player()
	if (not( action ) or not (moving )) and combatstate  and ( currentBotTime > ( lastcasttime + 5) or currentBotTime > ( laststart  + 25 ) or currentBotTime > (  lastsuccesscast+ 5 ) ) then
		action = false
		moving = false
	end
	lastbot = currentBotTime
	
	botBool = currentBotTime > ( lastranged + 1)  and currentBotTime > ( lastcasttime ) and currentBotTime > (lastafter ) and currentBotTime > (lastbottime  + 0.8)  and currentBotTime > (lastbotexec + 0.5)
				
	updategearbool = currentBotTime > ( laststart + 2) and currentBotTime > (lastafter + 2) and currentBotTime > ( lastcasttime + 2) and currentBotTime > (  lastranged + 8 )
	
	if not(botBool) and (currentBotTime > ( lastcasttime + 6 ) or currentBotTime > ( laststart  + 6 )) then
		botBool = true
	end
	local currenttarget = oldtarget
	if player.target.id ~= nil   and player.target.id ~= oldtarget and player.target.type ~= nil and player.target.type == 'MONSTER' then
		currenttarget = player.target.id
		
	elseif player.target.id == nil or player.target.type == nil or player.target.type ~= 'MONSTER' then
		currenttarget = 0
	end
	
	updateVariables()
	

		if (lasttarget == 0 or not( is_claimablebool( windower.ffxi.get_mob_by_id(lasttarget) ))) and (  not( moblist.targeter[mobname]) or not( targetingmonster ) or player.target.hpp == nil or ( player.target.hpp <= 99 and not(combatstate)) 
					or outclaimedQbool or ((mobdist > 24.5  or (not(dartcheck) and mobdist > 17.5 )) and not(combatstate))   ) and currentBotTime > ( lastranged + 5)    then
			newtargetneed = true
		else
			newtargetneed = false
		end
		
		local midcombatswap = false
		if (lasttarget == 0 or not( is_claimablebool( windower.ffxi.get_mob_by_id(lasttarget) ))) and autotargetmode == "On" and  currentBotTime > (lasttargeter + 1) then 
			midcombatswap = true
		end
		
		if autotargetmode == "On" and currentBotTime > (lasttargeter + 0.5) and party.count ~= nil and party.count == 6 
		and (newtargetneed or player.target.name == nil or player.target.name == player.name or not(moblist.targeter[player.target.name] )) and not(combatstate) then
	
			target_nearest()
			lasttargeter =  currentBotTime 
		--elseif midcombatswap then
		--	target_nearest()
		--	lasttargeter =  currentBotTime 
		
		end
	
	if botActive == 'On' and botBool then
		local ja_recasts = windower.ffxi.get_ability_recasts()
		local spell_recasts = windower.ffxi.get_spell_recasts()
		lastbottime = currentBotTime
	
		
		dartcheck = player.inventory["Dart"] ~= nil or player.wardrobe["Dart"] ~= nil or player.wardrobe2["Dart"] ~= nil or player.wardrobe3["Dart"] ~= nil or player.wardrobe4["Dart"] ~= nil 
		local canWS = mobdist < 7 and currentTP >= 1000  and buffactive['Amnesia'] == nil and buffactive[7] == nil and buffactive['Sleep'] == nil  and ( wsrotation == 1 or (currentBotTime >= lastws + 3 and currentBotTime <= lastws + 6.25)) and (autoSC == 'Off' or currentBotTime >= lastws + 3) and (autotargetmode ~= "On" or not(outclaimedQbool) ) 
	
		local edrainbool = castersubbool() ~= nil and castersubbool() and plmpp <= 75 and wsmode == "On" and currentTP >= 1000 and player.main_job_level >= 55 and engaged and actable and inMelee  and moblist.hasMP[mobname]
		local canSC = AEmode == "Off"  and autoSC == 'On'   and mobdist < 7 and currentTP >= 1000  and buffactive['Amnesia'] == nil and buffactive[7] == nil and buffactive['Sleep'] == nil  and ( wsrotation == 1 or (currentBotTime >= lastws + 3 and currentBotTime <= lastws + 8.9))
					
		
		
	--	if combatstate then
	--		if not(engaged) and autotargetmode == "On" and dirComm == "NA" and targetingmonster and mobdist < 8 then
	--				windower.send_command('@input /attack')
	--		end
	--	end
		
		if ((currentBotTime > lastws + 8.5 and wsrotation ~= 1 )  ) or (player.target.id == nil or player.target.id ~= oldtarget) then
			wsrotation = 1
		end
		
		if (ja_recasts[67] > 0 		or currentTP < 800 		or not(engaged) 		or not( mobtarbool ))  and dirComm == "TA" then
			dirComm = ""
		elseif (not( targetingmonster ) or mobdist > 24.5 or (autotargetmode == "On"  and (outclaimedQbool )))  and dirComm == "RA" then
			dirComm = ""
		elseif autotargetmode == "On"  and dirComm == "RA" then
			dirComm = ""
		elseif dirComm == 'THga' and player.sub_job ~= 'BLU' then
			dirComm = ""
		end
		
		
			
		
		
		if not(action) and currentBotTime >= lastbotexec   and autotargetmode == "On" and not(combatstate) and not(engaged) and party.count ~= nil and party.count < 6 then
				lastbotexec  =  currentBotTime  + 3
			
				send_command('input /ma "Koru-Moru" <me>; wait 0.4; input /ma "Sylvie (UC)" <me>; wait 0.4; input /ma "Joachim" <me>; wait 0.4; input /ma "Qultada" <me>; wait 0.4; input /ma "Cornelia" <me>')
			
		elseif wsmode == "On" and canSC and engaged  then
						lastbotexec  =  currentBotTime  + 1
						if player.target ~= nil  and not( facing_mob()) then
							facemob(player.target)			
						end
						weaponSkill()		
					
					elseif actable and currentBotTime >= lastranged + 4 and mobdist <=  24.5 
						and (dirComm == "RA" or (autotargetmode == "On" and not(newtargetneed)  and moblist.targeter[mobname] 
						and not(combatstate) and (mobdist >= 17.5 or (fmcount < 1 and mobdist >= 4  ))) or (autoranged == "On" and engaged and mobdist >= 4)) and not( outclaimedQbool )  then
								lastranged = currentBotTime  
								dirComm = "NA"
						if player.target ~= nil  and not( facing_mob()) then
							facemob(player.target)			
						end
						send_command('gs equip sets.precast.raThrow; gs disable ammo; gs equip sets.precast.raThrow; wait 1 ;input /equip Ammo Dart;input /ra <t>; wait 2; gs enable ammo')
					
					elseif autotargetmode == "On"  and not(newtargetneed) and targetingmonster  and player.target.name ~= nil 
								and player.target.hpp ~= nil and moblist.targeter[mobname] and not( outclaimedQbool ) and not(combatstate)  and mobdist <= 24.5  then
									
									Puller()
								lastbotexec  =  currentBotTime  + 1
					
					
					
					elseif autotargetmode == "On" and engaged and (not(moblist.targeter[mobname]) or mobdist >= 24.8 or outclaimedQbool) then
							
								windower.send_command('@input /attack')
					elseif autotargetmode == "On"   and combatstate  and not( engaged) 
									and moblist.targeter[mobname] and not(outclaimedQbool)  and targethpp > 0 then
										
											windower.send_command('@input /attack')
		elseif actable and dirComm == "WS" and canws  then
					lastbotexec  =  currentBotTime  + 1
					weaponSkill()
		
		
					
	elseif edrainbool and canws and dirComm == "WS"  then
						lastbotexec  =  currentBotTime  + 1
						send_command('input /ws "Energy Drain" <t>')			
					
					
		elseif actable and dirComm == "TA"  and inMelee and currentTP >= 1000 then
					lastbotexec  =  currentBotTime  + 1
					TaWs()
		
		elseif castable and player.sub_job == 'BLU' and dirComm == "THga" and targetingmonster and mobdist <= 6 and plmp >= 32 then
					 lastbotexec  = currentBotTime + 1
					if spell_recasts[537] <= 0 and plmp >= 37 then
						send_command('input /ma "Stinking Gas" <t>')
					elseif  spell_recasts[561] <= 0 and plmp >= 32 then 
						send_command('input /ma "Frightful Roar" <t>')
					
					end
		
									
														
										
											
										
		elseif wsmode == "On" and AEmode == "Off" and ((currentTP >= 2500  and canWS and not(edrainbool)) or (currentTP >2800 and engaged and mobdist <= 4.5 and actable and facing_mob())) then
					lastbotexec  =  currentBotTime  + 1
					weaponSkill()
		
		
		elseif namode == "On" and canHealingWaltz() and currentTP >= 250 and player.sub_job == "DNC" and not( moving) and wsrotation == 1 then
					send_command('input /ja "Healing Waltz" <me>')
					lastbotexec  =  currentBotTime  + 1
		elseif namode == "On" and canNA() and player.sub_job == "WHM" and not( moving) and castable then
					lastbotexec  =  currentBotTime  + 1
					NA()		
		
		elseif  ( actable or castable ) and notsneakvis and not( buffactive[76] )   then
			
			if player.sub_job == 'DNC' and player.sub_job_level >= 55 and not( combatstate ) and
				(ja_recasts[218] == nil or ja_recasts[218] <= 0) and jigmode == "On" and buffactive['Flee'] == nil and buffactive['Quickening'] == nil and moving and actable then
					lastbotexec  =  currentBotTime  + 1
					send_command('input /ja "Chocobo Jig" <me>')
				elseif player.sub_job == 'DNC' and currentTP >= 200 and not( moving) and hurtpercent <= 75 and dnchecked and actable and (wsrotation == 1 or hurtpercent <= 15) then
						lastbotexec  =  currentBotTime  + 1
						Dncure()
				elseif player.sub_job == 'BLU' and player.sub_job_level >= 58 and not( moving) and (mosthurt ~= player.name or hurtpercent <= 83)
					and injury > 300 and plmp >= 72 and castable and spell_recasts[593] <= 0 and (wsrotation == 1 or hurtpercent <= 20)  then
						
						
						send_command('input /ma "Magic Fruit" ' .. mosthurt .. '')
						lastbotexec  =  currentBotTime  + 1
				elseif player.sub_job == 'BLU' and not( moving) and injury > 200 and plmp >= 60 and (mosthurt ~= player.name or hurtpercent <= 83)
				and castable and spell_recasts[578] <= 0 and (wsrotation == 1 or hurtpercent <= 20)  then
						
						
						send_command('input /ma "Wild Carrot" ' .. mosthurt .. '')
						lastbotexec  =  currentBotTime  + 1
					
				elseif player.sub_job == 'BLU' and avghurt >= 250  and not( moving)  and plmp >= 60 and (mosthurt ~= player.name or hurtpercent <= 83)
							and castable and spell_recasts[581] <= 0 and (wsrotation == 1 or hurtpercent <= 20)  then
						
						
						send_command('input /ma "Healing Breeze" <me>')
						lastbotexec  =  currentBotTime  + 1
				
				elseif ja_recasts[65] <= 0   and player.main_job_level >= 35 and actable  and plhpp <= 65 and (autotargetmode ~= "On" or not(outclaimedQbool) )  and inMelee and mobname ~= 'Lady Lilith' and (wsrotation == 1 or hurtpercent <= 20)  then
						send_command('input /ja "Mug" <t>')
						lastbotexec  =  currentBotTime  + 1
				elseif ja_recasts[240] <= 0   and targethpp <= 95 and hurtpercent <= 50 and (autotargetmode ~= "On" or not(outclaimedQbool) )  and player.main_job_level >= 99 and actable and inMelee and (wsrotation == 1 or hurtpercent <= 20)  then
						send_command('input /ja "Bully" <t>')
						lastbotexec  =  currentBotTime  + 1
				
				elseif player.sub_job == 'BLU' and plmp >= 29 and player.sub_job_level >= 50 and castable and (buffactive['Haste'] == nil
						or not(buffactive['Haste'])) and (buffactive['Slow'] == nil or not(buffactive['Slow']))then
						send_command('input /ma "Refueling" <me>')
				elseif player.sub_job == 'BLU' and plmp >= 50 and player.sub_job_level >= 8 and castable and (buffactive['Defense Boost'] == nil
						or not(buffactive['Defense Boost'])) then
						send_command('input /ma "Cocoon" <me>')
						lastbotexec  =  currentBotTime  + 1
				elseif actable and prescribe() then
							lastbotexec  =  currentBotTime  + 3
							drugs()
				elseif engaged  then 
					if ja_recasts[61] <= 0   and (windower.ffxi.get_bag_info(0).max - windower.ffxi.get_bag_info(0).count) > 0 and player.main_job_level >= 76 and actable and inMelee and targethpp <= 95	and currentTP <= 350  and (autotargetmode ~= "On" or not(outclaimedQbool) )  then
						lastbotexec  =  currentBotTime  + 1
						send_command('input /ja "Despoil" <t>')
					elseif ja_recasts[0] <= 0   and player.main_job_level >= 1 and actable  and plhpp <= 30 and targethpp > 5 then
						lastbotexec  =  currentBotTime  + 1
						send_command('input /ja "Perfect Dodge" <me>')
					
					
					elseif wsmode == "On" and (autotargetmode ~= "On" or not(outclaimedQbool) )  and AEmode == "On" and actable and inMelee and currentTP >= 1000 and player.main_job_level >= 99 and not(edrainbool) then
						lastbotexec  =  currentBotTime  + 1
						if wsrotation == 2  and autoSC == 'On' and currentBotTime - lastws > 3 and currentBotTime - lastws < 6.1 then
							send_command('input /ws "Cyclone" <t>')
						elseif wsrotation == 1 or autoSC == 'Off' then
							send_command('input /ws "Aeolian Edge" <t>')
						end
					elseif wsmode == "On" and actable and inMelee and not(edrainbool) and canWS and   (currentTP >= 1500 or (currentTP >= 1000 and (buffactive[185] or buffactive['Max TP Down'] or stepmode ~= "On" ))) then
						lastbotexec  =  currentBotTime  + 1
						weaponSkill()
					elseif player.sub_job == 'DNC' and targetingmonster
								and (( fmcount < 3 and stepmode == "On" )or ( fmcount < 1 and autotargetmode == "On" )) and actable and currentTP >= oldTP and currentTP >= 100
						and inMelee and player.sub_job_level >= 20 and (ja_recasts[220] == nil or ja_recasts[220] <= 0) then
						lastbotexec  =  currentBotTime  + 1
						if autotargetmode == "On" then
							steptracker = 2
						end
						Stepper()
					
					elseif player.sub_job == 'DNC'  and debuffmode == "On" and ja_recasts[216] <= 0 and player.sub_job_level ~= nil and  player.sub_job_level ~= 0  and player.sub_job_level >= 40 
								and buffactive[370] == nil and actable and currentTP >= 350 
								and inMelee and ( autoSC == 'Off' or (wsrotation == 1 and (currentBotTime - lastws) > 1.5 )) then
								
						send_command('input /ja "Haste Samba" <me>')
						lastbotexec  =  currentBotTime  + 1
					elseif plhpp >= 80 and autotargetmode == "On" and mosthurt ~= mename and hurtpercent <= 75 and actable and ja_recasts[69] <= 0 and curedist <= 12.4 then
							windower.send_command('@input /ja "Accomplice" '.. mosthurt .. '')
							lastbotexec  =  currentBotTime  + 1
					elseif autotargetmode == "On" and canAct and buffactive[251] == nil or not(buffactive[251]) and player.inventory["Grape Daifuku"] ~= nil and wsrotation == 1 then
						send_command('input /item "Grape Daifuku" <me>')
						lastbotexec  =  currentBotTime  + 4
					elseif ja_recasts[68] <= 0 and debuffmode == "On" and (autotargetmode ~= "On" or not(outclaimedQbool) )  and player.main_job_level >= 75 and targethpp <= 98 and actable and inMelee and wsrotation == 1  then
						send_command('input /ja "Feint" <me>')
						lastbotexec  =  currentBotTime  + 1
					elseif ja_recasts[60] <= 0 and (windower.ffxi.get_bag_info(0).max - windower.ffxi.get_bag_info(0).count) > 0  and (autotargetmode ~= "On" or not(outclaimedQbool) )  and actable and (check_facing() or targethpp <= 25) and targethpp <= 90 and inMelee and wsrotation == 1 then
						send_command('input /ja "Steal" <t>')
						lastbotexec  =  currentBotTime  + 1
					elseif player.sub_job == 'WAR' and ja_recasts[3] <= 0  and player.sub_job_level >= 25 and actable  and inMelee  and plhpp <= 35 and wsrotation == 1 then
						send_command('input /ja "Defender" <me>')
						lastbotexec  =  currentBotTime  + 1
					elseif player.sub_job == 'WAR' and ja_recasts[1] <= 0  and player.sub_job_level >= 15 and actable   and currentTP >= 900 and wsrotation == 1 and buffactive[68] == nil and plhpp >= 80 then
						send_command('input /ja "Berserk" <me>')
						lastbotexec  =  currentBotTime  + 1
					elseif player.sub_job == 'DRK' and ja_recasts[87] <= 0  and player.sub_job_level >= 15 and actable   and currentTP >= 900 and wsrotation == 1 and buffactive[64] == nil and plhpp >= 80 then
						send_command('input /ja "Last Resort" <me>')
						lastbotexec  =  currentBotTime  + 1
					elseif ja_recasts[40] <= 0  and party.count > 1 and player.main_job_level >= 90 and targethpp <= 98  and actable  and inMelee  and currentTP >= 100 and plhpp >= 80 and wsrotation == 1 then
						send_command('input /ja "Conspirator" <me>')
						lastbotexec  =  currentBotTime  + 1
					elseif player.sub_job == 'WAR' and ja_recasts[4] <= 0  and player.sub_job_level >= 45   and actable  and inMelee  and currentTP >= 100 and plhpp >= 80 and wsrotation == 1 then
						send_command('input /ja "Aggressor" <me>')
						lastbotexec  =  currentBotTime  + 1
					elseif player.sub_job == 'WAR' and ja_recasts[2] <= 0  and player.sub_job_level >= 35 and actable  and inMelee  and currentTP >= 900 and wsrotation == 1 and buffactive[56] == nil and buffactive[68] == nil then
						send_command('input /ja "Warcry" <me>')
						lastbotexec  =  currentBotTime  + 1
					elseif player.sub_job == 'DNC' and actable and currentTP <= 600 and player.sub_job_level >= 40 and (ja_recasts[222] == nil or ja_recasts[222] <= 0) and fmcount == 5 then
						send_command('input /ja "Reverse Flourish" <me>')
						lastbotexec  =  currentBotTime  + 1
					elseif player.sub_job == 'DNC' and  dnchecked and hurtpercent < 80  and currentTP <= 800 and currentTP >= 200 and actable and (wsrotation == 1 or hurtpercent <= 15)  then
						lastbotexec  =  currentBotTime  + 1
						Dncure()
					elseif not( action ) and updategearbool  then
						postcast()
					end
			elseif not( engaged )  then
				if (not(combatstate) or autotargetmode ~= "On") and hurtpercent <= 80  and player.sub_job == "DNC"  and not( moving) and dnchecked and actable and (wsrotation == 1 or hurtpercent <= 20)  then
					lastbotexec  =  currentBotTime  + 1
					Dncure()
				elseif player.sub_job == 'BLU' and not( moving) and hurtpercent <= 80 and plmp >= 60 and castable and spell_recasts[578] <= 0 and (wsrotation == 1 or hurtpercent <= 20)  then
						send_command('input /ma "Wild Carrot" ' .. mosthurt .. '')
						lastbotexec  =  currentBotTime  + 1
				
				
				elseif not( action ) and updategearbool then
						postcast()
				end
			elseif not( action ) and updategearbool then
				postcast()
			end
		
		end
		
	elseif not( action ) and updategearbool then
			postcast()
		
	end

	

	
	
	if botActive == 'On' then
		
		
		
		
		
		if autotargetmode == "On"  and not(moving) then
				
			local ja_recasts = windower.ffxi.get_ability_recasts()
			local spell_recasts = windower.ffxi.get_spell_recasts()
			swapclaim = false
			
			
			
			
			
			
		end
		
			
			
			
				

	end
	
	oldTP = currentTP
	oldtarget = currenttarget
end


