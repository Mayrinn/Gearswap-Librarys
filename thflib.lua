--By Evalyn Simmons
--Aka Avelynne on Asura

include('evalib')

-- does a weapon skill dependent on your current weapon and circumstance.

	
function weaponSkill()
	currentBotTime = os.time()
	local actable = canAct()
	local ja_recasts = windower.ffxi.get_ability_recasts()
	local canWS = true

--	actable and player.target.distance ~= nil and player.target.type == 'MONSTER' and player.target.distance < 7 and player.tp >= 1000 and facing_mob() and (autoSC == 'Off' or currentBotTime >= lastws + 3)
	local WSproxy = "Evisceration"
	
	if autoSC == 'On' and wsrotation == 4 then
		WSproxy = "Rudra's Storm"
	elseif autoSC == 'On' and wsrotation == 2 then
		WSproxy = "Dancing Edge"
	end
	
	if canWS then
		local SAcheck =   player.main_job_level >= 15 and ja_recasts[64] <= 0
		
			

			

		
		if actable and SAcheck and (check_facing() or buffactive[76]) and (autoSC == 'Off' or ((currentBotTime - lastws) <= 4.9) and wsrotation >= 2)  then 
			
			local assembler = ''
			
			lastafter =  currentBotTime  + 2
			
			local assembler = ''
			
			if ja_recasts[67] <= 0 and not(buffactive[76]) then
				lastafter =  lastafter  + 2
				local assncharge = "Assassin's Charge"
				assembler = 'input /ja "'.. assncharge ..'" <me>;wait 1 ;'
			end
			
			if player.sub_job == 'DNC' and player.sub_job_level >= 50 and FMove() >= 2 and ja_recasts[222] <= 0 then
				lastafter =  lastafter  + 2
				assembler = 'input /ja "Building Flourish" <me>;wait 1 ;'
				
			end
			
			if  player.equipment.main == 'Naegling' then
				send_command( assembler .. 'input /ja "Sneak Attack" <me>;wait 1 ;input /ws "Savage Blade" <t>')
			elseif  player.equipment.main == 'Tauret' then
				send_command( assembler .. 'input /ja "Sneak Attack" <me>;wait 1 ;input /ws "' .. WSproxy .. '" <t>')
			else
				send_command( assembler .. 'input /ja "Sneak Attack" <me>;wait 1 ;input /ws "Fast Blade" <t>')
			end
						
		elseif SAcheck and (ja_recasts[63] <= 0 and player.main_job_level >= 45 ) and (autoSC == 'Off' or ((currentBotTime - lastws) <= 4.9) and wsrotation >= 2)  then
			lastafter =  currentBotTime  + 4
			
			local assembler = ''
			
			if ja_recasts[67] <= 0 and not(buffactive[76]) then
				lastafter =  lastafter  + 2
				local assncharge = "Assassin's Charge"
				assembler = 'input /ja "'.. assncharge ..'" <me>;wait 1 ;'
			end
			
			if player.sub_job == 'DNC' and player.sub_job_level >= 50 and FMove() >= 3 and ja_recasts[222] <= 0 then
				lastafter =  lastafter  + 2
				assembler = 'input /ja "Building Flourish" <me>;wait 1 ;'
				
			end
			
			
			if  player.equipment.main == 'Naegling' then
				send_command( assembler .. 'input /ja "Sneak Attack" <me>;wait 1 ;input /ja "Hide" <me>;wait 1 ; input /ws "Savage Blade" <t>')
			elseif  player.equipment.main == 'Tauret' then
				send_command( assembler .. 'input /ja "Sneak Attack" <me>;wait 1 ;input /ja "Hide" <me>;wait 1 ; input /ws "' .. WSproxy .. '" <t>')
			else
				send_command( assembler .. 'input /ja "Sneak Attack" <me>;wait 1 ;input /ja "Hide" <me>;wait 1 ; input /ws "Fast Blade" <t>')
			end
				
		elseif TrickAbleTarget() and party.count > 1  and ja_recasts[66] <= 0 and player.main_job_level >= 30 and (autoSC == 'Off' or ((currentBotTime - lastws) <= 4.9) and wsrotation >= 2) then
			TaWs()
		elseif player.main_job_level >= 99  then
			lastafter =  currentBotTime  + 1
			
			local assembler = ''
			
			if player.sub_job == 'DNC' and player.sub_job_level >= 50 and FMove() >= 2 and ja_recasts[222] <= 0  and (autoSC == 'Off' or ((currentBotTime - lastws) <= 4.9) and wsrotation >= 2) then
				lastafter =  lastafter  + 2
				assembler = 'input /ja "Building Flourish" <me>;wait 1.5 ;'
				
			end
			
			
			if  player.equipment.main == 'Naegling' then
				send_command( assembler .. 'input /ws "Savage Blade" <t>')
			elseif  player.equipment.main == 'Tauret' then	
				send_command( assembler .. 'input /ws "' .. WSproxy .. '" <t>')
			end
		end
	end
end

function TaWs()
			local ja_recasts = windower.ffxi.get_ability_recasts()
			lastafter =  currentBotTime  + 8
			local assembler = ''
			
			if ja_recasts[67] <= 0 then
				local assncharge = "Assassin's Charge"
				assembler = 'input /ja "' .. assncharge ..'" <me>;wait 1 ;'
			end
			
			if player.sub_job == 'DNC' and player.sub_job_level >= 50 and FMove() >= 2 and ja_recasts[222] <= 0 then
				lastafter =  lastafter  + 2
				assembler = 'input /ja "Building Flourish" <me>;wait 1 ;'
				
			end
			
			if  player.equipment.main == 'Naegling' then
				send_command( assembler .. 'input /ja "Trick Attack" <me> ;wait 1 ;input /ws "Savage Blade" <t>')
			elseif  player.equipment.main == 'Tauret' then
				send_command( assembler .. 'input /ja "Trick Attack" <me> ;wait 1 ;input /ws "' .. WSproxy .. '" <t>')
			else
				send_command( assembler ..'input /ja "Trick Attack" <me> ;wait 1 ;input /ws "Fast Blade" <t>')
			end
end

--will cure the most hurt person. assuming you are able to cast a cure and the most injured person has taken at least 30 damage.
function Dncure()
	local ja_recasts = windower.ffxi.get_ability_recasts()

	if cureParser(30) and canAct() and player.sub_job == 'DNC' then
		if injury >= 900 and player.tp >= 500 and ja_recasts[229] <= 0 and ja_recasts[187] <= 0 and player.sub_job_level >= 50 then
			lastafter =  currentBotTime  + 3
			
			send_command('input /ja "Contradance" <me> ; wait 1 ;input /ja "Curing Waltz III" '.. mosthurt .. '')
		elseif injury >= 625 and player.tp >= 500 and ja_recasts[187] <= 0 and player.sub_job_level >= 45 then
			windower.send_command('@input /ja "Curing Waltz III" '.. mosthurt .. '')
		elseif injury >= 400 and player.tp >= 350 and ja_recasts[186] <= 0 and player.sub_job_level >= 30 then
			windower.send_command('@input /ja "Curing Waltz II" '.. mosthurt .. '')
		elseif injury >= 150 and curegaTargs >= 3 and ja_recasts[225] <= 0 and player.sub_job_level >= 25 and player.tp >= 400  then
			windower.send_command('@input /ja "Divine Waltz" <me>')
		elseif injury >= 150 and player.tp >= 200  and ja_recasts[217] <= 0 and player.sub_job_level >= 15 then
			windower.send_command('@input /ja "Curing Waltz" '.. mosthurt .. '')
		end
	end

end

function Dncurechecker()
	local ja_recasts = windower.ffxi.get_ability_recasts()
	if cureParser(30) and canAct() and player.sub_job == 'DNC' and player.sub_job_level >= 15 then
		if injury >= 625 and player.tp >= 500 and ja_recasts[187] <= 0 and player.sub_job_level >= 45 then
			return true
		elseif injury >= 400 and player.tp >= 350 and ja_recasts[186] <= 0 and player.sub_job_level >= 30 then
			return true
		elseif avghurt >= 150 and curegaTargs >= 3 and ja_recasts[225] <= 0 and player.sub_job_level >= 25 and player.tp >= 400  then
			return true
		elseif injury >= 150 and player.tp >= 200 and ja_recasts[217] <= 0 and player.sub_job_level >= 15 then
			return true
		end
	end
	return false
end

--used for command receipts.
function commandChat( com )
	if botActive == 'On' then
		if dirComm ~= 'NA' then
			windower.send_command('@input /echo dirComm Recieved: '.. dirComm ..'')
		end
	else
		windower.send_command('@input /echo Command Recieved: '.. com ..'')
	end
end



--checks if autordm has been given a bad command
function commandcheck()
	local ja_recasts = windower.ffxi.get_ability_recasts()
	cureParser(30)
			currentBotTime = os.time()
	if dirComm == "Cure" and hurtpercent >= 92 then
			dirComm = "NA"
		elseif (dirComm == "WS" or dirComm == "TA") and (player.target ~= nil or player.tp < 1000 or player.target.type ~= 'MONSTER' or not( facing )) then
				dirComm = "NA"
		elseif dirComm ~= "NA" and currentBotTime >= lastsuccesscast + 10 then
			dirComm = "NA"
		elseif ( dirComm ~= "NA") and (currentBotTime - commandTime) >= 10 then
				dirComm = "NA"
		end
end


	--This function is used to check what gear should be equiped for the given situation.
function postcast()
			currentBotTime = os.time()
	if not(action) or (  currentBotTime > laststart  ) or (currentBotTime >= (lastcasttime + 1)) then
		action = false
		postcast2()
	end
end

function castersubbool()
	if (player.sub_job == 'DRK' or player.sub_job == 'PLD' or player.sub_job == 'WHM' 
						or player.sub_job == 'BLM' or player.sub_job == 'RDM' or player.sub_job == 'GEO' or player.sub_job == 'SMN' 
						or player.sub_job == 'SCH' or player.sub_job == 'BLU' or player.sub_job == 'RUN' ) then
					return true	
	else
		return false
	end
end

function needmpbool() 
	if castersubbool() and player.mpp < 70 then
		return true
	else
		return false
	end
end

function postcast2()
	local ableDo = canDo()
		if player.status == "Engaged" then
			if player.target.distance == nil or player.target.distance >= 7 or not( facing_mob()) or not( ableDo )  then
						
						equip(sets.aftercast.idle)		
						
			
			else
				if player.hpp <= 20 then
					equip(sets.aftercast.tp25 )
				elseif player.hpp <= 35 then
					equip(sets.aftercast.tp50 )
				elseif player.hpp <= 50 then
					equip(sets.aftercast.tp75 )
				else
					if player.tp >= 950 then
						equip(sets.aftercast.lowtp )
					elseif player.tp >= 800 then
						equip(sets.aftercast.softtp )
					else
						equip(sets.aftercast.tp )
					end
				end
			end
			
			
			if player.mpp < 80 and castersubbool() then
				equip(sets.aftercast.tpfresh)
			end
			
			if THmode == "On" and player.target.hpp ~= nil and player.target.hpp > 95 and player.hpp >= 75  then
				equip( sets.aftercast.TH )
			end
			
		elseif player.status == "Idle" and player.sub_job == 'DNC' and steptracker ~= 1 then
				steptracker = 1
			

			
		else
			equip(sets.aftercast.idle)
			
			if player.hpp <= 80 then
				
				if moving then
					equip( set_combine(sets.aftercast.regen, {ring1 = "Meghanada Ring"}))
				else
					equip(sets.aftercast.regen)
				end
			end
			if player.tp < 1000 then 
				equip(sets.aftercast.idleregain)
			end
			if player.mpp < 90 and 
			(player.sub_job == 'DRK' or player.sub_job == 'PLD' or player.sub_job == 'WHM' or player.sub_job == 'BLM' or player.sub_job == 'RDM' or player.sub_job == 'GEO' or player.sub_job == 'SMN' 
			or player.sub_job == 'SCH' or player.sub_job == 'BLU' or player.sub_job == 'RUN' ) then
				equip(sets.aftercast.idlefresh)
			end
			
		end
		
		if moving then
			equip(sets.aftercast.speed)
		end
end

function is_claimable(claim_id)
    for _, member in pairs(windower.ffxi.get_party()) do
        if type(member) == 'table' and member.mob and claim_id == member.mob.id then
            return true
        end
    end
    return false
end

function continue()
	local currentzone = windower.ffxi.get_info().zone 
		
		if botActive == 'On' and currentzone == playerzone2 then
			RDMBOT()
		elseif currentzone ~= playerzone2 then
			botActive = 'Off'
			playerzone2 = windower.ffxi.get_info().zone 
			windower.send_command('@input /echo Zone Changed Auto RDM is: '.. botActive .. '')
		else
		
		end
end



function updateVariables()

actable = canAct()
castable = canCast()
facing = facing_mob()
fcount = FMove()
dnchecked = Dncurechecker()
notsneakvis = buffactive[69] == nil and buffactive[71] == nil 
targetingmonster = player.target ~= nil and player.target.type ~= nil and player.target.type == 'MONSTER' and player.target.distance ~= nil
inMelee = player.target ~= nil and targetingmonster and facing and player.target.distance <= 7 and player.status == "Engaged" 
if targetingmonster then
	set_hp_colors_for_target(player.target)
end

		cureParser(22)
		warpassivecheck()
		
		if (player.target == nil or is_outclaimed(player.target)) then
			claimed = true 
		else
			claimed =	false 
		end
	
	
	if player.target ~= nil and player.target.type ~= nil and player.target.type == 'MONSTER' and player.target.mob ~= nil and player.target.mob.id ~= nil and (player.target ~= oldtarget or player.name == oldtarget.name) then
		currenttarget = player.target.mob.id
		tagged = false
	end
	
	if player.in_combat then
		combatstate = true
	else
		combatstate = false
	end
	
	if player.tp ~= nil then
		currentTP = player.tp
	else
		currentTP = 0
	end
	
	
	if player.hpp ~= nil then
		plhpp =  player.hpp 
	else
		plhpp = 100
	end
	
	
	if player.mp ~= nil then
		plmp = player.mp 
	else
		plmp = 300
	end
	
	
	if player.mpp ~= nil then
		plmp = player.mpp 
	else
		plmpp = 100
	end
	
	
	if player.target ~= nil then
		outclaimedQbool = is_outclaimed(player.target)
	else
		outclaimedQbool = true 
	end
	
	if player.target.hpp ~= nil then
		targethpp = player.target.hpp
	else
		targethpp = 100
	end
	
	fmcount = FMove()
	
	
	if player.status == "Engaged" then
		engaged = true
	else
		engaged = false
	end
	
	
	if player.target ~= nil then
		claimableQBool = is_claimable(player.target)
	else
		claimableQBool = false
	end
	
	
	if player.target.type ~= nil and player.target.type == 'MONSTER' then
		mobtarbool = true
	else
		mobtarbool = false
	end
	
	
	if player.target.name ~= nil then
		mobname = player.target.name
	else
		mobname = ''
	end
	
	if player.target.distance == nil then
		mobdist = 30
	elseif player.target.distance ~= nil then
		mobdist = player.target.distance
	end
	
	if (player.target.name == nil or not(moblist.targeter[player.target.name])) then
		propermob = false 
	else
		propermob =	true 
	end
	
		if player.target ~= nil then
				
				set_hp_colors_for_target(player.target)
		end	
end


function cure()
	local spell_recasts = windower.ffxi.get_spell_recasts()
	if cureParser(30) and canCast() then
		if injury >= 600 and player.mp >= 88 and spell_recasts[4] <= 0 and player.sub_job_level >= 48 then
			windower.send_command('@input /ma "Cure IV" '.. mosthurt .. '')
		elseif injury >= 300 and player.mp >= 46 and spell_recasts[3] <= 0 and player.sub_job_level >= 26 then
			windower.send_command('@input /ma "Cure III" '.. mosthurt .. '')
		elseif injury >= 150 and player.mp >= 24 and spell_recasts[2] <= 0 and player.sub_job_level >= 14 then
			windower.send_command('@input /ma "Cure II" '.. mosthurt .. '')
		elseif spell_recasts[1] <= 0 and player.mp >= 8 and player.sub_job_level >= 3 then
			windower.send_command('@input /ma "Cure" '.. mosthurt .. '')
		end
	end

end

function Puller()
	local fcountnum = FMove()
	local ja_recasts = windower.ffxi.get_ability_recasts()
		if autotargetmode == "On" and dirComm ~= 'RA' and player.target.name ~= nil and not(is_outclaimed(player.target)) and moblist.targeter[player.target.name]  then
				if player.target.distance ~= nil and fcountnum >= 1 and not( is_outclaimed(player.target) ) and player.target.hpp ~= nil and player.target.hpp > 0 and player.target.distance <= 17.5 
					and ja_recasts[221] <= 0 and player.sub_job == 'DNC' then
					lastbotexec  =  currentBotTime  + 1
					windower.send_command('@input /ja "Animated Flourish" <t>')
				
				elseif  (player.sub_job ~= 'DNC' or player.target.distance > 17.5 or fcountnum < 1) and player.target.name ~= nil and not(is_outclaimed(player.target))
						and player.target.distance ~= nil  and player.target.distance < 24.5 
						and player.target.hpp ~= nil and player.target.hpp > 0 and dartcheck and dirComm ~= "RA"  then
							if player.target ~= nil  and not( facing_mob()) then
									facemob(player.target)
								
								end
				
								dirComm = 'RA'
				else 
					dirComm = 'RA'
				end
		end
end