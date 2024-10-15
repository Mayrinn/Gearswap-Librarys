--By Evalyn Simmons
--Aka Avelynne on Asura
require('vectors')
packets = require('packets')

moblist = {}
moblist.hasMP = S{ "Apex Crab", "Locus Blazer Elytra" , "Apex Blazer Elytra", "Aquarius", "Cancer", "Cargo Crab Colin", 
				"Knight Crab","King Artho","Wake Warder Wanda", "Sunderclaw", "Krabkatoa", "River Crab", "Limicoline Crab",
				"Palm Crab", "Savanna Crab", "Stone Crab","Tree Crab", "Sand Crab", "Mine Crab","Land Crab","Mole Crab",
				"Mugger Crab", "Vermivorous Crab", "Wadi Crab","Coral Crab","Passage Crab", "Ocean Crab","Sea Crab",
				"Thickshell", "Stag Crab", "Triangle Crab","Snipper", "Blind Crab", "Clipper", "Ghost Crab","Grindylow",
				"Gugru Crab","Crimson Knight Crab", "Ironshell","Bigclaw", "Cyan Deep Crab","Submarine Nipper", "Rock Crab",
				"Scavenger Crab", "Robber Crab", "Greatclaw","Aydeewa Crab","Wootzshell", "Sicklemoon Crab", "Steelsheel","Squadron Orisha","Regiment Orisha","Orisha Leader", 'Orisha Commander', 
				"Mamook Crab", "Nipper", "Soot Crab","Hill Crab", "Locus Ghost Crab","Hoplite Leader","Squadron Hoplite","Regiment Hoplite"
				,"Squadron Magian","Regiment Magian","Magian Leader","Squadron Prognosticator","Regiment Prognosticator","Prognosticator Leader","Champion Leader","Squadron Champion","Regiment Champion"
				,"Squadron Orisha","Regiment Orisha","Orisha Leader","Spy Leader","Squadron Spy","Regiment Spy",
				'Regiment Berserker', 'Squadron Berserker', 'Squadron Arcanomancer', 'Regiment Arcanomancer', 'Squadron Defiler', 'Regiment Defiler',
				'Squadron Banneret','Regiment Banneret', 'Squadron Vivifier','Regiment Vivifier','Squadron Operative' ,'Regiment Operative'
				,'Regiment Buccaneer','Squadron Buccaneer','Berserker Leader','Berserker Commander', 'Arcanomancer Leader', 'Arcanomancer Commander'
				,'Defiler Leader', 'Defiler Commander', 'Banneret Leader', 'Banneret Commander','Vivifier Leader', 'Vivifier Commander','Operative Leader'
				,'Operative Commander','Buccaneer Leader','Buccaneer Commander', "Sqaudron's Avatar", "Regiment's Avatar", "Leader's Avatar", "Commander's Avatar"
				,"Squadron's Wyvern", "Regiment's Wyvern", "Leader's Wyvern", "Commander's Wyvern","Volte Wyvern", "Leader's Hippogryph",
				"Commander's Hippogryph", "Volte's Cluster","Squadron Privateer","Regiment Privateer","Privateer Leader", 'Privateer Commander'}
moblist.targeter = S{ 'Locus Dire Bat'}
moblist.targeterex = S{'Locus Thousand Eyes', 'Apex Bats',"Moblin Topsman", "Moblin Aidman",
						'Locus Armet Beetle','Locus Bight Rarab',"Apex Crab" ,"Goblin Swordsman","Moblin Roadman","Locus Dire Bat", "Goblin Lengthman",
					"Goblin Hangman","Bugbear Deathsman","Goblin Headman","Moblin Engineman","Moblin Groundman", 
					"Moblin Engineer", "Moblin Scalpelman"}
autotargetmode = 'Off'
action = false
bot = {counter=0}
mov = {counter=0}
avghurt = 0
curegaTargs = 1
lasttargeter =  os.time()
mov.x = 0
mov.y = 0
mov.z = 0
facemode = 'On'
lastbot = currentBotTime
combatstate = false

dist = 30
mobs = windower.ffxi.get_mob_array()
targetmob = player
lasttarget = 0
if player.in_combat then
	combatstate = true
else
	combatstate = false
end
if player and player.index and windower.ffxi.get_mob_by_index(player.index) then
    mov.x = windower.ffxi.get_mob_by_index(player.index).x
    mov.y = windower.ffxi.get_mob_by_index(player.index).y
    mov.z = windower.ffxi.get_mob_by_index(player.index).z
end

backattack = false

moving = false
windower.raw_register_event('prerender',function()
    mov.counter = mov.counter + 1;
	
	
	
    if mov.counter>10 then
		currentBotTime = os.time()
		if facemode == 'On' and player.target ~= nil and player.status == 'Engaged' and player.target.type ~= nil and player.target.type == 'MONSTER' and not( facing_mob())  then
			facemob(player.target)
	
		end
		
		
        local pl = windower.ffxi.get_mob_by_index(player.index)
        if pl and pl.x and mov.x and pl.y and mov.y and pl.z and mov.z then
            local movement = math.sqrt( (pl.x-mov.x)^2 + (pl.y-mov.y)^2 + (pl.z-mov.z)^2 ) > 0.15
            if movement and not moving then
                equip(sets.aftercast.speed)
				send_command('gs c checkMove')
                moving = true
            elseif not movement and moving then
				send_command('gs c checkMove')
                moving = false
            end
		else
			moving = false
        end
        if pl and pl.x and pl.y and pl.z then
            mov.x = pl.x
            mov.y = pl.y
            mov.z = pl.z
        end
        mov.counter = 0
    end
	
	if botActive == 'On' and currentBotTime >= (lastbot + 0.5) then
		continue()
	end
end)

function castTimer()
	if lastactiontype == "Magic"  then
			return 3.38
	elseif lastactiontype == "Interrupt" then
		return 2.8
	elseif lastactiontype == "Ability" then
		return 0.8
	else
		return 1
	end
	
end

function followenemy( gap )
	local havecombattarget = player.target ~= nil and player.status == "Engaged" and player.target.type == 'MONSTER' 
	local mindist = 2.9
	local maxdist = 3.1
	if gap ~= nil then 
		local mindist = gap - 0.40
		local maxdist = gap + 0.40
	end
		
	thfcheck = false
	
	if player.sub_job == 'THF' or player.main_job == 'THF' then
		thfcheck = true
		 
	end
	
	local distance = 3
	local facing = facing_mob()
	local behiendtarget = check_facing()
	if player.target.distance ~= nil then
		local distance = math.floor(math.sqrt(player.target.distance) * 100)/ 100
	end
	
	local distcheck = distance >= mindist  and distance <= maxdist
	local positioned = distcheck and facing and (not(thfcheck) or behiendtarget ) 
	
	if (not( player.in_combat ) and moving) or positioned then
				cancelMove()
	elseif havecombattarget and followmode == "On" and facing ~= nil  and (not(thfcheck) or behiendtarget ~= nil)  then
		
			if positioned and moving then
				cancelMove()
			elseif not(facing)   then 
				facemob(player.target)
			elseif runmode == "On"  and distance > maxdist  then 
				followtarget(player.target, gap)
			elseif runmode == "On"  and distance < mindist  then 
				runaway(player.target, gap)
			
			elseif  backattack and runmode == "On" and not(behiendtarget) and not(moving) and following == "Off"  and distance <= maxdist and thfcheck then 
				if turnleft() then
					leftfollowtarget()
				else
					rightfollowtarget()
				end
			elseif (player.status ~= "Engaged" or not( moving ) or action)  then
				cancelMove()
			end
	else
		cancelMove()
	end
end

function target_nearest()
	
	mobs = windower.ffxi.get_mob_array()
	if not(player.in_combat) then
		combatstate = false
	else
		combatstate = true
	end
	if player.status ~= nil and player.status ~= "Engaged" then
				
				dartcheck = player.inventory["Dart"] ~= nil or player.wardrobe["Dart"] ~= nil or player.wardrobe2["Dart"] ~= nil or player.wardrobe3["Dart"] ~= nil or player.wardrobe4["Dart"] ~= nil 
		
			local closest
			if not(combatstate ) then
				 for _, mob in pairs(mobs) do
					if mob ~= nil   and not( is_outclaimed( mob ) ) and mob.distance ~= nil 
					and ((player.main_job ~= 'RDM' and ((mob.distance:sqrt() <= 24.5 and dartcheck) or mob.distance:sqrt() <= 17.5))  or mob.distance:sqrt() <= 21)
					and mob.name ~= nil and moblist.targeter[mob.name] and mob.hpp ~= nil  
					 and mob.hpp > 0   then
						if  not closest  or is_claimed(mob) or mob.distance:sqrt() < dist  then
							if is_claimed(mob)   then
								closest = mob
								dist = mob.distance:sqrt()
								break
							else
								closest = mob
								dist = mob.distance:sqrt()
							end
						end
					end
				end
			elseif combatstate and player.status ~= Engaged then
								
				dartcheck = player.inventory["Dart"] ~= nil or player.wardrobe["Dart"] ~= nil or player.wardrobe2["Dart"] ~= nil or player.wardrobe3["Dart"] ~= nil or player.wardrobe4["Dart"] ~= nil 
		
				 for _, mob in pairs(mobs) do
					if mob ~= nil and mob.valid_target and mob.id ~= nil and mob.distance ~= nil and 
					((player.main_job ~= 'RDM' and ((mob.distance:sqrt() <= 24.5 and dartcheck) or mob.distance:sqrt() <= 17.5))  or mob.distance:sqrt() <= 21) and mob.name ~= nil and moblist.targeter[mob.name] and mob.hpp ~= nil and mob.hpp > 0 
					and is_claimed(mob) then
						if  not closest  or  mob.distance:sqrt() < dist  then
							if is_claimed(mob) or mob.distance:sqrt() <= 17.5  then
								closest = mob
								dist = mob.distance:sqrt()
								break
							else
								closest = mob
								dist = mob.distance:sqrt()
							end
						end
					end
				end
			
			end
			
			dist = 30
			
			if not closest then
				windower.send_command('@input /echo No Target yet')
				return
			
			elseif  not(player.in_combat) and lasttarget ~= closest.id and not( is_claimablebool( windower.ffxi.get_mob_by_id(lasttarget) ))   then
				 windower.send_command('@input /echo Target Found!')
				 
			
				 packets.inject(packets.new('incoming', 0x058, {
					['Player'] = player.id,
					['Target'] = closest.id,
					['Player Index'] = player.index,
				}))
					
					packets.inject(packets.new('outgoing', 0x01A, {
						['Target'] = closest.id,
						['Target Index'] = closest.index,
						['Category'] = 0x0C,
					}))
				lasttarget = closest.id
				--lastmob = closest
		   end
			
			
	end
end


commands = {}

commands.save = function(set_name)
    if not set_name then
        windower.add_to_chat(settings.add_to_chat_mode, 'A saved target set needs a name: //targ save <set>')
        return
    end

    settings.sets[set_name] = L{settings.targets:unpack()}
    settings:save()
    windower.add_to_chat(settings.add_to_chat_mode, set_name .. ' saved')
end

function runaway(actor,action_distance) 
	if player.target.distance ~= nil then
	--	local distance = math.floor(math.sqrt(player.target.distance) * 100)/ 100
	
		local distance = player.target.distance

		if player.target.distance < action_distance then
			if windower.ffxi.get_player().target_locked then 
				windower.send_command("input /lockon")
			end
			local target = {}
			if actor then 
				target = actor
			else 
				target = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().target_index or 0)
			end
			local self_vector = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().index or 0)
			if target and target.name ~= self_vector.name then 
				local angle = (math.atan2((target.y - self_vector.y), (target.x - self_vector.x))*180/math.pi)*-1
				windower.ffxi.run((angle+180):radian())
				autorun = 1
				autorun_target = target
				autorun_distance = action_distance
				autorun_tofrom = 2
			else 
				windower.add_to_chat(10,"React: You're not targeting anything to run away from")
			end
		end
	end
end

function cancelMove()
		windower.ffxi.run(false)
		following = "Off"
		windower.send_command('setkey D up; setkey A up; setkey S up; setkey W up')
end


function facemob(actor)
	local target = {}
	if actor then
		target = actor
	else 
		target = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().target_index or 0)
	end
	local self_vector = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().index or 0)
	if target and target.name ~= player.name and self_vector ~= nil and target.y ~= nil and self_vector.y ~= nil 
			and target.x ~= nil and self_vector.x ~= nil then  -- Please note if you target yourself you will face Due East
		local angle = (math.atan2((target.y - self_vector.y), (target.x - self_vector.x))*180/math.pi)*-1
		windower.ffxi.turn((angle):radian())
	else
		windower.add_to_chat(10,"React: You're not targeting anything to face")
	end
end

function followtarget(actor,action_distance)
	if player.target.distance ~= nil then
	--	local distance = math.floor(math.sqrt(player.target.distance) * 100)/ 100
	local distance = player.target.distance
	
		if distance > action_distance then
			
		
			
			local target = {}
			
			if actor then 
				target = actor
			else 
				target = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().target_index or 0)
			end
			
			local self_vector = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().index or 0)
			
			if target and target.name ~= self_vector.name then 
				local angle = (math.atan2((target.y - self_vector.y), (target.x - self_vector.x))*180/math.pi)*-1
				windower.ffxi.run((angle):radian())
				autorun = 1
				autorun_target = target
				autorun_distance = action_distance
				autorun_tofrom = 2
			else 
				windower.add_to_chat(10,"React: You're not targeting anything to run toward")
			end
			
		end
	end
end




Dstate = "Up"
movingRight = false

function rightfollowtarget()
    -- Check if there's no target or if the player is not engaged
    if player.target == nil or player.status ~= "Engaged" then
        windower.send_command('setkey D up; setkey A up')
		movingRight = false
    end
    Dstate = "Up" 
    -- Ensure 'D' key is released initially
    windower.send_command('setkey D up; setkey A up')
    
	
    movingRight = true  -- Flag to track movement state
    
    -- Coroutine to start moving to the right of the target
		if not( check_facing() ) then
				rightcontinue()
		end

end

function rightcontinue()
	
		if Dstate == "Down" and (ChFacing or player.status ~= "Engaged" or player.target.distance > 7) then
			windower.send_command('setkey D up')
			Dstate = "Up"
			movingRight = false  -- Update flag to stop movement
		elseif player.status ~= "Engaged" then
			windower.send_command('setkey D up')
			Dstate = "Up"
			movingRight = false  -- Update flag to stop movement
		elseif not(moving) then
			-- Command to start moving to the right ('D' key down)
			windower.send_command('setkey D down')
			movingRight = true
			Dstate = "Down"
		end
		
		if not(check_facing()) then
			windower.send_command('wait 0.1 ; gs c rContinue')
		else
			windower.send_command('setkey D up; setkey A up')
			Dstate = "Up"
			movingRight = false  -- Update flag to stop movement
		end
		
end


Astate = "Up"
movingLeft = false

function leftfollowtarget()
    -- Check if there's no target or if the player is not engaged
    if player.target == nil or player.status ~= "Engaged" then
        windower.send_command('setkey D up; setkey A up')
		movingLeft = false
    end
    Astate = "Up" 
    -- Ensure 'A' key is released initially
    windower.send_command('setkey D up; setkey A up')
    
	
    movingLeft = true  -- Flag to track movement state
    
    -- Coroutine to start moving to the right of the target
		if not( check_facing() ) then
				leftcontinue()
		end

end

function leftcontinue()
	
		if Astate == "Down" and (ChFacing or player.status ~= "Engaged" or player.target.distance > 7) then
			windower.send_command('setkey A up')
			Astate = "Up"
			movingLeft = false  -- Update flag to stop movement
		elseif player.status ~= "Engaged" then
			windower.send_command('setkey A up')
			Astate = "Up"
			movingLeft = false  -- Update flag to stop movement
		elseif not(moving) then
			-- Command to start moving to the right ('A' key down)
			windower.send_command('setkey A down')
			movingLeft = true
			Astate = "Down"
		end
		
		if not(check_facing()) then
			windower.send_command('wait 0.1 ; gs c lContinue')
		else
			windower.send_command('setkey A up')
			Astate = "Up"
			movingLeft = false  -- Update flag to stop movement
		end
		
end


--auto turns off berserk when hp gets low, and defender when hp gets high.
function warpassivecheck()
	if ( player.sub_job == 'WAR' or player.main_job == 'WAR' ) and player.in_combat then
			if player.hpp <= 15 and buffactive[56]  then
				windower.send_command('cancel Berserk')
			elseif player.hpp >= 85 and buffactive[57] then
				windower.send_command('cancel Defender')
			end
			
	elseif ( player.sub_job == 'DRK' or player.main_job == 'DRK' ) and player.in_combat then
			if player.hpp <= 15 and buffactive[64]  then
				windower.send_command('cancel Last Resort')
			end
	end
end

--Uses items to cure various status ailments if they are in the players inventory.
function prescribe()
		if buffactive[15] and player.inventory['Holy Water'] then
			return true
		elseif ( buffactive[29] or buffactive[6] ) and player.inventory['Echo Drops'] then
			return true
		elseif ( buffactive[20] or buffactive[15] ) and player.inventory['Holy Water'] then
			return true
		elseif player.inventory['Eye Drops'] and player.status == "Engaged"  and  buffactive[5]  then
			return true
		elseif player.inventory['Antidote']  and  ( buffactive[3] or buffactive[630] ) then
			return true
		elseif player.inventory['Remedy'] and ( buffactive[29] or buffactive[6] or buffactive[5] or buffactive[3] or buffactive[630] or buffactive[4] or buffactive[8] or buffactive[31] ) then
			return true
		else
			return false
		end
end


--Uses items to cure various status ailments if they are in the players inventory.
function drugs()
		if buffactive[15] and player.inventory['Holy Water'] then
			windower.send_command('@input /item "Holy Water" <me>')
		elseif ( buffactive[29] or buffactive[6] ) and player.inventory['Echo Drops'] then
			windower.send_command('@input /item "Echo Drops" <me>')
		elseif ( buffactive[20] or buffactive[15] ) and player.inventory['Holy Water'] then
			windower.send_command('@input /item "Holy Water" <me>')
		elseif player.inventory['Eye Drops'] and player.status == "Engaged"  and  buffactive[5]  then
			windower.send_command('@input /item "Eye Drops" <me>')
		elseif player.inventory['Antidote']  and  ( buffactive[3] or buffactive[630] ) then
			windower.send_command('@input /item "Antidote" <me>')
		elseif player.inventory['Remedy'] and ( buffactive[29] or buffactive[6] or buffactive[5] or buffactive[3] or buffactive[630] or buffactive[4] or buffactive[8] or buffactive[31] ) then
			windower.send_command('@input /item "Remedy" <me>')
		end
end

--used when /sch gets current strategem count.
function get_current_strategem_count()
    -- returns recast in seconds.
    local allRecasts = windower.ffxi.get_ability_recasts()
    local stratsRecast = allRecasts[231]
	local maxStrategems = 1
	if player.main_job == 'SCH' then
		maxStrategems = (player.main_job_level + 10) / 20
	elseif player.sub_job == 'SCH' then
		maxStrategems = (player.sub_job_level + 10) / 20
	end
 
    local fullRechargeTime = 4*60
 
    local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)
 
    return currentCharges
end

function canHealingWaltz()
	currentBotTime = os.time() 
	if player.tp >= 200 and canAct() and currentBotTime >= lastHWaltz + 8 and ((player.sub_job == 'DNC' and player.sub_job_level >= 35) or (player.main_job == 'DNC' and player.main_job_level >= 35)) and 
	(  buffactive[20] or buffactive[21] or buffactive[13] or buffactive['Bind'] or buffactive[12] or buffactive[11] or buffactive[10] 
	or buffactive[9] or buffactive[8] or buffactive[6] or buffactive[5] or buffactive[4] or buffactive[3] or buffactive[128] 
	or buffactive[128] or buffactive['Attack Down'] or buffactive[129] or buffactive[130] or buffactive[131] or buffactive[132] or buffactive[133] or buffactive[134] or buffactive[135]
	or buffactive[136] or buffactive[137] or buffactive[138] or buffactive[139] or buffactive[140] or buffactive[141] or buffactive[142]
	or buffactive[144] or buffactive[145] or buffactive[146] or buffactive[147] or buffactive[148] or buffactive[149] or buffactive[167] or buffactive[174] 
	or buffactive[175]) then
		return true
	else
		return false
	end
end

function canNA()

	currentBotTime = os.time() 
	
	if player.sub_job == 'WHM' and canCast() then
		local spell_recasts = windower.ffxi.get_spell_recasts()
		
		-- poisona
		if player.sub_job_level >= 6 and player.mp >= 8 and spell_recasts[14] <= 0
				and (buffactive[3]  or buffactive[540] ) then
			return true
			
		--paralyna
		elseif player.sub_job_level >= 9 and player.mp >= 12 and spell_recasts[15] <= 0
				and (buffactive[4]   ) then
			return true
			
		--blindna
		elseif player.sub_job_level >= 14 and player.mp >= 16 and spell_recasts[16] <= 0
				and (buffactive[5]   ) then
			return true	
			
		--Silena
		elseif player.sub_job_level >= 19 and player.mp >= 24 and spell_recasts[17] <= 0
				and (buffactive[6]   ) then
			return true	
			
		--Cursna
		elseif player.sub_job_level >= 29 and player.mp >= 30 and spell_recasts[20] <= 0
				and (buffactive[29]  or  buffactive[15] or  buffactive[9] ) then
			return true	
			
		--Viruna
		elseif player.sub_job_level >= 34 and player.mp >= 48 and spell_recasts[19] <= 0
				and (buffactive[8] or  buffactive[31]   ) then
			return true	
			
		--Stona
		elseif player.sub_job_level >= 39 and player.mp >= 40 and spell_recasts[18] <= 0
				and (buffactive[18] or  buffactive[7]   ) then
			return true	
			
		--erase		
		elseif player.sub_job_level >= 32 and player.mp >= 18 and spell_recasts[143] <= 0 and (  buffactive[20] or buffactive[21] or buffactive[13] or buffactive['Bind'] or buffactive[12] or buffactive[11] or buffactive[10] 
				or buffactive[128] or buffactive[128] or buffactive['Attack Down'] or buffactive[129] or buffactive[130] or buffactive[131] or buffactive[132] or buffactive[133] or buffactive[134] or buffactive[135]
				or buffactive[136] or buffactive[137] or buffactive[138] or buffactive[139] or buffactive[140] or buffactive[141] or buffactive[142]
				or buffactive[144] or buffactive[145] or buffactive[146] or buffactive[147] or buffactive[148] or buffactive[149] or buffactive[167] or buffactive[174] 
				or buffactive[175]) then
			return true	
		end
	end
	return false

end


function NA()

	currentBotTime = os.time() 
	
	if player.sub_job == 'WHM' and canCast() then
		local spell_recasts = windower.ffxi.get_spell_recasts()
		
		-- poisona
		if player.sub_job_level >= 6 and player.mp >= 8 and spell_recasts[14] <= 0
				and (buffactive[3]  or buffactive[540] ) then
			windower.send_command('@input /ma "Poisona" <me>')
			
		--paralyna
		elseif player.sub_job_level >= 9 and player.mp >= 12 and spell_recasts[15] <= 0
				and (buffactive[4]   ) then
			windower.send_command('@input /ma "Paralyna" <me>')
			
		--blindna
		elseif player.sub_job_level >= 14 and player.mp >= 16 and spell_recasts[16] <= 0
				and (buffactive[5]   ) then
			windower.send_command('@input /ma "Blindna" <me>')
			
		--Silena
		elseif player.sub_job_level >= 19 and player.mp >= 24 and spell_recasts[17] <= 0
				and (buffactive[6]   ) then
			windower.send_command('@input /ma "Silena" <me>')
			
		--Cursna
		elseif player.sub_job_level >= 29 and player.mp >= 30 and spell_recasts[20] <= 0
				and (buffactive[29]  or  buffactive[15] or  buffactive[9] ) then
			windower.send_command('@input /ma "Cursna" <me>')
			
		--Viruna
		elseif player.sub_job_level >= 34 and player.mp >= 48 and spell_recasts[19] <= 0
				and (buffactive[8] or  buffactive[31]   ) then
			windower.send_command('@input /ma "Viruna" <me>')
			
		--Stona
		elseif player.sub_job_level >= 39 and player.mp >= 40 and spell_recasts[18] <= 0
				and (buffactive[18] or  buffactive[7]   ) then
			windower.send_command('@input /ma "Stona" <me>')
			
		--erase		
		elseif player.sub_job_level >= 32 and player.mp >= 18 and spell_recasts[143] <= 0 and (  buffactive[20] or buffactive[21] or buffactive[13] or buffactive['Bind'] or buffactive[12] or buffactive[11] or buffactive[10] 
				or buffactive[128] or buffactive[128] or buffactive['Attack Down'] or buffactive[129] or buffactive[130] or buffactive[131] or buffactive[132] or buffactive[133] or buffactive[134] or buffactive[135]
				or buffactive[136] or buffactive[137] or buffactive[138] or buffactive[139] or buffactive[140] or buffactive[141] or buffactive[142]
				or buffactive[144] or buffactive[145] or buffactive[146] or buffactive[147] or buffactive[148] or buffactive[149] or buffactive[167] or buffactive[174] 
				or buffactive[175]) then
			windower.send_command('@input /ma "Erase" <me>')	
		end
	end

end


function HealingWaltz()
	if canHealingWaltz() then
		windower.send_command('@input /ja "Healing Waltz" <me>')
	end
end

function FMove()
	if not( player.sub_job == 'DNC' or player.main_job == 'DNC') then
		return 0
	elseif buffactive[385]  then
		return 5
	elseif buffactive[384]  then
		return 4
	elseif buffactive[383]  then
		return 3
	elseif buffactive[382]  then
		return 2
	elseif buffactive[381] then
		return 1
	else
		return 0
	end
end

--for melee checks
function facing_mob()
	if player.target ~= nil and player.target.type ~= nil and player.target.type == 'MONSTER' then
	
		local target = windower.ffxi.get_mob_by_target('t')
		local player = windower.ffxi.get_mob_by_target('me')
		if target ~= nil and target.x ~= nil and target.y ~= nil and player ~= nil and player.x ~= nil and player.y ~= nil then
			local dir_player = V{target.x, target.y} - V{player.x, player.y}
			local player_heading = V{}.from_radian(player.facing)
			local player_angle = V{}.angle(dir_player, player_heading):degree():abs()
			if player_angle < 30 then
				return true
			else
				return false
			end
					
		else
			return false
		end
	else
		return false
	end
	
end

--for melee checks
function facing_MobIndex( mobid )
	if player.target ~= nil and player.target.type ~= nil and player.target.type == 'MONSTER' then
	
		local target = windower.get_mob_by_index( mobid )
		local player = windower.ffxi.get_mob_by_target('me')
		if target ~= nil and target.x ~= nil and target.y ~= nil and player ~= nil and player.x ~= nil and player.y ~= nil then
			local dir_player = V{target.x, target.y} - V{player.x, player.y}
			local player_heading = V{}.from_radian(player.facing)
			local player_angle = V{}.angle(dir_player, player_heading):degree():abs()
			if player_angle < 30 then
				return true
			else
				return false
			end
					
		else
			return false
		end
	else
		return false
	end
	
end




function check_facing()
   if player.target ~= nil and player.target.heading ~= nil and player.facing ~= nil then
        local playerheading = player.facing
        local mobfacing = player.target.heading
        local pi = math.pi
        
        -- Normalize player's heading to be within [0, 2*pi)
        if playerheading < 0 then
            playerheading = playerheading + 2 * pi
        end
        
        -- Normalize mob's heading to be within [0, 2*pi)
        if mobfacing < 0 then
            mobfacing = mobfacing + 2 * pi
        end
        
        -- Calculate the angle difference between player's and target's headings
        local angleDifference = math.abs(playerheading - mobfacing)
        
        -- Normalize angle difference to be within [0, pi)
        if angleDifference > pi then
            angleDifference = 2 * pi - angleDifference
        end
        
        -- Define a threshold angle (e.g., 1 radian) to determine "facing the back"
        local thresholdAngle = 1  -- 90 degrees (pi/2 radians) from mob's heading
        
        -- Check if the angle difference suggests the player is facing the mob's back
        if angleDifference <= thresholdAngle and facing_mob() then
            return true
        else
            return false
        end
    else
        return false  -- Return false if conditions are not met (target or headings are nil)
    end
end

--for back attacks, sneak attack, steal, etc
function check_facingold()
	if player.target ~= nil and  player.target.heading ~= nil and  player.facing ~= nil then
		local playerheading = player.facing
		local mobfacing = player.target.heading
		local facingdifference = playerheading 
		local pi = math.pi
		if playerheading < 0 then
			playerheading = pi + (pi - math.abs(playerheading))
		end
		 
		local facingdifference = math.abs( mobfacing - playerheading )

		
		
		if facingdifference <= 1 and facing_mob() then
			return true
		else
			return false
		end
	else
		return false
	end	
end


function TrickAbleTarget()
	if player.target.type ~= nil and player.target.type == 'MONSTER' and facing_mob() then
		local partysize = party.count
		if partysize == 1 then
				return false
		elseif partysize >= 2 then		
				local zone = windower.ffxi.get_info().zone
				for i=1, partysize do
					if party[i] ~= nil and party[i].zone ~= nil and party[i].zone == zone and party[i].hpp ~= nil and party[i].hpp > 50 and party[i].index ~= nil then
					
							local target = windower.get_mob_by_index( party[i].index )
							local player = windower.ffxi.get_mob_by_target('me')
							if target ~= nil and target.x ~= nil and target.y ~= nil and player ~= nil and player.x ~= nil and player.y ~= nil then
								local dir_player = V{target.x, target.y} - V{player.x, player.y}
								local player_heading = V{}.from_radian(player.facing)
								local player_angle = V{}.angle(dir_player, player_heading):degree():abs()
								if player_angle < 30 and (party[i].distance < player.target.distance) then
										return true
								else
									return false
								end
							else
								return false
							end
					else
						return false
					end
				end
			
		else
			return false
		end
	else
		return false
	end
end



function turnleft()
    if player.target ~= nil and player.target.heading ~= nil and player.facing ~= nil then
        local playerheading = player.facing
        local mobheading = player.target.heading
        local pi = math.pi
        
        -- Normalize angles to be within [0, 2*pi)
        if playerheading < 0 then
            playerheading = playerheading + 2 * pi
        end
        if mobheading < 0 then
            mobheading = mobheading + 2 * pi
        end
        
        -- Calculate the angle difference between player's and target's headings
        local angleDifference = mobheading - playerheading
        
        -- Normalize angle difference to be within [-pi, pi)
        if angleDifference < -pi then
            angleDifference = angleDifference + 2 * pi
        elseif angleDifference >= pi then
            angleDifference = angleDifference - 2 * pi
        end
        
        -- Determine if turning left (counter-clockwise) is the shorter path
        -- Check if angle difference is positive and less than pi
        if angleDifference > 0 and angleDifference <= pi then
            return true
        else
            return false
        end
    else
        return false  -- Return false if conditions are not met (target or headings are nil)
    end
end

function turnleftold()
	if player.target ~= nil and  player.target.heading ~= nil and  player.facing ~= nil then
		local playerheading = player.facing
		local mobfacing = player.target.heading
		local facingdifference = playerheading 
		local pi = math.pi
		if playerheading < 0 then
			playerheading = pi + (pi - math.abs(playerheading))
		end
		 
		if (mobfacing - playerheading ) < math.pi / 2 then
			return true
		else
			return false
		end
	end	
end



steptracker = 1
function steptrack()
			local tempprox = steptracker
			if player.main_job == 'RDM' then
				if player.sub_job_level >= 40 then
					steptracker = (( tempprox + 1) % 3) +1
				elseif player.sub_job_level >= 30 then
					steptracker = (( tempprox + 1) % 2) +1
				else
					steptracker = 1
				end
			else
				if steptracker ~= 1 then
					steptracker = 1
				else
					steptracker = 2
				end
			
			end	
end

--Decides what element should be used for offensive purposes should one not be locked in.
function eleAuto()
	local earth = 0
	local water = 0
	local wind = 0
	local fire = 0
	local ice = 0
	local lightning = 0
	
	if world.day_element == "Earth" then
		earth = earth + 1
	elseif world.day_element == "Water" then
		water = water + 1
	elseif world.day_element == "Wind" then
		wind = wind + 1
	elseif world.day_element == "Fire" then
		fire = fire + 1
	elseif world.day_element == "Ice" then
		ice = ice + 1
	elseif world.day_element == "Lightning" then
		lightning = lightning + 1
	end
	
	if not(buffactive['Aurorastorm'] == nil) or not(buffactive['Voidstorm'] == nil) then
		if world.real_weather_element == "Earth" then
			earth = earth + world.real_weather_intensity
		elseif world.real_weather_element == "Water" then
			water = water + world.real_weather_intensity
		elseif world.real_weather_element == "Wind" then
			wind = wind + world.real_weather_intensity
		elseif world.real_weather_element == "Fire" then
			fire = fire + world.real_weather_intensity
		elseif world.real_weather_element == "Ice" then
			ice = ice + world.real_weather_intensity
		elseif world.real_weather_element == "Lightning" then
			lightning = lightning + world.real_weather_intensity
		end
	else
		if world.weather_element == "Earth" then
			earth = earth + world.weather_intensity
		elseif world.weather_element == "Water" then
			water = water + world.weather_intensity
		elseif world.weather_element == "Wind" then
			wind = wind + world.weather_intensity
		elseif world.weather_element == "Fire" then
			fire = fire + world.weather_intensity
		elseif world.weather_element == "Ice" then
			ice = ice + world.weather_intensity
		elseif world.weather_element == "Lightning" then
			lightning = lightning + world.weather_intensity
		end
	end
	
	if earth > lightning and earth >= water and earth >= fire and earth > ice and earth > wind then
		autoele = "Stone"
	elseif lightning >= water and lightning >= fire and lightning > ice and lightning > wind then
		autoele = "Thunder"
	elseif water > fire and water > ice and water > wind then
		autoele = "Water"
	elseif fire > ice and fire > wind then
		autoele = "Fire"
	elseif ice > wind then
		autoele = "Blizzard"
	else
		autoele = "Aero"
	end
	
end


curedist = 1
--returns true if a target is more hurt then the desired amount, and sets mosthurt to them and sets injury to thier injury level.
function cureParser(threshhold)
	avghurt = 0
	curegaTargs = 0
	local totalhurt	= 0
    if (canCast() or player.main_job == 'DNC' or player.sub_job == 'DNC') and player.main_job_level >= 3 and player.mp >= 8 then
			mosthurt = ""
			injury = 0
			hurtpercent = 100
		local partysize = party.count
		
		local allysize = 0
		
		if partysize > 1 then 
			allysize = 1
		end
		if alliance[2].count ~= nil and  alliance[2].count > 0 then
				allysize = allysize  + 1
		end
				
		if alliance[3].count ~= nil and alliance[3].count > 0 then
			allysize = allysize + 1
		end
		
		if (partysize == 1 or curemode == 'Self' or player.hpp <= 40 ) and player.hpp <= 92 and player.hpp > 0  then
			mosthurt = player.name
			injury = player.max_hp - player.hp
			hurtpercent = player.hpp
		elseif allysize > 1 and curemode == 'On' then
			for party_index,ally_party in ipairs(alliance) do
				--for j=1, allysize do
					--partysize = alliance[j].count
				local j = party_index	
				
					for player_index,_player in ipairs(ally_party) do
						local i = player_index
	--					for i=1, partysize do
						local currentmenber =  alliance[j][i]
										
						if currentmenber ~= nil and currentmenber.hp ~= nil and currentmenber.hpp ~= nil and  currentmenber.mob ~= nil and  currentmenber.mob.distance ~= nil and currentmenber.hpp < 95 then
							
							distance = math.floor(math.sqrt(currentmenber.mob.distance) * 100)/ 100

							if currentmenber.hpp ~= nil and currentmenber.hpp <= hurtpercent and currentmenber.hpp > 0 and distance <= 20 and currentmenber.hpp ~= 0  then 
								injury = (( currentmenber.hp / currentmenber.hpp ) * 100) - currentmenber.hp
								hurtpercent = currentmenber.hpp
								mosthurt =  currentmenber.name
								curedist = distance
								
								if distance <= 10 and j == 1 then
									totalhurt = totalhurt + injury
									curegaTargs = curegaTargs + 1
								end
								
							end
						end
					end
			end
		elseif partysize >= 2 and (curemode == 'On' or curemode == 'Party') then		
			local zone = windower.ffxi.get_info().zone
			
			for i=1, partysize do
				if party[i] ~= nil and party[i].mob ~= nil and party[i].zone ~= nil and party[i].zone == zone and party[i].hp ~= nil and party[i].hpp ~= nil and  party[i].mob.distance ~= nil and party[i].hpp < 95 then
						distance = math.floor(math.sqrt(party[i].mob.distance) * 100)/ 100
						
							if party[i].hpp <= hurtpercent and distance <= 20 and party[i].hpp ~= 0 then 
								mosthurt = party[i].name
								injury = (( party[i].hp / party[i].hpp ) * 100) - party[i].hp
								hurtpercent = party[i].hpp
								curedist = distance
								
								if distance <= 10 then
									totalhurt = totalhurt + injury
									curegaTargs = curegaTargs + 1
								end
							end
							
							
				end
			end
		end
		
		
		avghurt = totalhurt / curegaTargs
	else
		return false
	end
	
	if injury >= threshhold then
		return true
	elseif injury < threshhold then
		return false
	end
end

-- Attempt to locate a specified name within the current alliance.
function find_player_in_alliance(name)
	for party_index,ally_party in ipairs(alliance) do
		for player_index,_player in ipairs(ally_party) do
			if _player.name == name then
				return _player
			end
		end
	end
end

--returns amount needed to heal the most hurt party member to full.
function cureAmount()
	
	
    if canCast() or canDo() then
			mosthurt = ""
			injury = 0
		local partysize = party.count
		
		if partysize == 1 and player.hpp <= 92 then
			mosthurt = player.name
			injury = player.max_hp - player.hp
			hurtpercent = player.hpp
		elseif partysize >= 2 then		
			local zone = windower.ffxi.get_info().zone
			hurtpercent = 100
			for i=1, partysize do
				if party[i] ~= nil and party[i].zone ~= nil and party[i].zone == zone and party[i].hp ~= nil and party[i].hpp ~= nil and party[i].mob ~= nil and party[i].mob.distance ~= nil and party[i].hpp < 95 then
						distance = math.floor(math.sqrt(party[i].mob.distance) * 100)/ 100
						
							if party[i].hpp <= hurtpercent and distance <= 20 then 
								mosthurt = party[i].name
								injury = (( party[i].hp / party[i].hpp ) * 100) - party[i].hp
								hurtpercent = party[i].hpp
							end
				end
			end
		end
	else
		return false
	end
	
	return injury
end



--returns a string with who is the most hurt in your party.
function cureWho()
	
	
    if canCast() and player.main_job_level >= 3 and player.mp >= 8 then
			mosthurt = ""
			injury = 0
		local partysize = party.count
		
		if partysize == 1 and player.hpp <= 92 then
			mosthurt = player.name
			injury = player.max_hp - player.hp
		elseif partysize >= 2 then		
			local zone = windower.ffxi.get_info().zone
			hurtpercent = 100
			for i=1, partysize do
				if party[i] ~= nil and party[i].zone ~= nil and party[i].zone == zone and party[i].hp ~= nil and party[i].hpp ~= nil and party[i].mob ~= nil and party[i].mob.distance ~= nil and party[i].hpp < 95 then
						local distance = math.floor(math.sqrt(party[i].mob.distance) * 100)/ 100
						
							if party[i].hpp <= hurtpercent and distance <= 20 then 
								mosthurt = party[i].name
								injury = (( party[i].hp / party[i].hpp ) * 100) - party[i].hp
								hurtpercent = party[i].hpp
							end
				end
			end
		end
	else
		return false
	end
	
	return mosthurt
end

--returns a percent 1-100 with the current HPP of the most hurt party member.
function cureTargetPercent()
	
	
    if canCast() and player.main_job_level >= 3 and player.mp >= 8 then
			mosthurt = ""
			injury = 0
		local partysize = party.count
		
		if partysize == 1 and player.hpp <= 92 then
			mosthurt = player.name
			injury = player.max_hp - player.hp
		elseif partysize >= 2 then		
			local zone = windower.ffxi.get_info().zone
			hurtpercent = 100
			for i=1, partysize do
				if party[i] ~= nil and party[i].zone ~= nil and party[i].zone == zone and party[i].hp ~= nil and party[i].hpp ~= nil and party[i].mob ~= nil and party[i].mob.distance ~= nil and party[i].hpp < 95 then
						distance = math.floor(math.sqrt(party[i].mob.distance) * 100)/ 100
						
							if party[i].hpp <= hurtpercent and distance <= 20 then 
								mosthurt = party[i].name
								injury = (( party[i].hp / party[i].hpp ) * 100) - party[i].hp
								hurtpercent = party[i].hpp
							end
				end
			end
		end
	else
		return false
	end
	
	return hurtpercent
end



--Checks if the character can do anything.	
function canDo()	
	if buffactive[2] or buffactive[7] or buffactive[14] or buffactive[10] or buffactive[28] or buffactive[633] then
		return false
	else
		return true
	end
end

--Checks if the player can use a Ability or Weapon Skill. Doesn't use timers.	
function canActGen()	
	if player.status == "Resting" or buffactive[16] or buffactive[19] or not(canDo()) then
		return false
	else
		return true
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


--Checks if the player can Cast a spell. Doesn't use timers.
function canCastGen()
	if player.status == "Resting" or moving or buffactive[6] or buffactive[29] or not(canDo) then
		return false
	else
		return true
	end
end
	
	
--Checks if the player can use a Ability or Weapon Skill	
function canAct()	
	currentBotTime = os.time()
	if not( canActGen()	) or action  then
		return false
	elseif currentBotTime >= ( lastcasttime + 1 ) then
		return true
	else
		return false
	end
end

--Checks if the player can Cast a spell.
function canCast()
	currentBotTime = os.time()
		
	if not(canCastGen()) or action then
		return false
	elseif currentBotTime >= ( lastcasttime + 1.5 ) then
		return true
	else
		return false
	end
end


function cancastQer( spell )
	local spell_recasts = windower.ffxi.get_spell_recasts()
	local castable = canCast()
	return (spell.action_type == 'Magic' and castable and spell_recasts[spell.recast_id or spell.id] and spell_recasts[spell.recast_id or spell.id] <= 0 )

end

function candoQer( spell ) 

		local actable = canAct()
		local ja_recasts = windower.ffxi.get_ability_recasts()

		return (spell.type == 'WeaponSkill' or  (spell.type == 'JobAbility' and (( player.sub_job == 'SCH' and
				get_current_strategem_count() >= 1 and  spell.type == "Scholar"  )  or 
				( ja_recasts[spell.recast_id or spell.id] and  ja_recasts[spell.recast_id or spell.id] <= 0 and  spell.type ~= "Scholar"  ))
				))
				and actable
				
end

function shouldcancelQer( spell )


		return ( action or (((currentBotTime < ( lastcasttime + castimer ))or (spell.action_type == 'Magic' and not(cancastQer( spell ))) 
			or (( spell.type == 'WeaponSkill' or  spell.type == 'JobAbility') and not(candoQer( spell ) )))))


end

function shouldfalseaction()
		currentBotTime = os.time()
	if currentBotTime >= lastactiontimer + 6 and action then
		action = false
	end
end

--Uses Steps when RDM/DNC. Will alternate between available steps.
function Stepper()
	local ja_recasts = windower.ffxi.get_ability_recasts()
	if player.sub_job == 'DNC' and canAct() and player.tp >= 100 and player.sub_job_level >= 20 and (ja_recasts[220] == nil or ja_recasts[220] <= 0) then
		if player.sub_job_level >= 40 and steptracker >= 3 then
			windower.send_command('@input /ja "Stutter Step" <t>')
		elseif steptracker >= 2 then
			windower.send_command('@input /ja "Box Step" <t>')
		else 
			windower.send_command('@input /ja "Quickstep" <t>')
		end	
	end
end

--Casts Utsu ni or ichi. For rdm/nin. Helps maintain shadows.
function utsu(maxTier)
	local spell_recasts = windower.ffxi.get_spell_recasts()
	if not(moving) and canCast() and player.sub_job == 'NIN' and buffactive['Copy Image (3)'] == nil and buffactive['Copy Image (2)'] == nil and player.main_job_level >= 24 and player.inventory["Shihei"] ~= nil then
			if spell_recasts[339] <= 0 and player.main_job_level >= 74 and maxTier >= 2 then
				windower.send_command('@input /ma "Utsusemi: Ni" <me>')
			
			elseif spell_recasts[338] <= 0 and player.main_job_level >= 24 then
				windower.send_command('@input /ma "Utsusemi: Ichi" <me>')
			end
		
		
	elseif player.inventory["Shihei"] == nil and player.inventory["Toolbag (Shihe)"] ~= nil then
		windower.send_command('@input /item "Toolbag (Shihe)" <me>')
	elseif player.inventory["Shihei"] == nil and player.inventory["Toolbag (Shihe)"] == nil then
		windower.send_command('@input /echo Need more Ninja Tools: Shihei')
	end
end

claimstatus = "unclaimed"
color = 'unclaimed'
function is_claimable(target)
	color = 'unclaimed'
	claimstatus = color
    if is_player(target) then
        color = 'player'
		return false
    elseif target.spawn_type == 2 or target.spawn_type == 14 then
        color = 'npc'
		return false
    elseif target.spawn_type == 16 then
        if target.status == 1 then
            local party = windower.ffxi.get_party()
            local party_claimed = false
				for i=1, party.party1_count do
					if not party['p' .. i] then
						break
					end
				
					if target.claim_id ~= nil and
						party['p' .. i].mob.id ~= nil and
						target.claim_id ==  party['p' .. i].mob.id  then
						claimstatus = color
						party_claimed = true
						break
					end
				end
            if party_claimed then
				
                color = 'claimed'
				claimstatus = color
				return true
            else
				
                color = 'outclaimed'
				claimstatus = color
				return false
            end
        elseif target.status == 2 or target.status == 3 then
            color = 'defeated'
			claimstatus = color
			return false
        end
    end
	if color == 'unclaimed' then
		return true
	end
	
	
end


function is_claimablebool(target)
	if target ~= nil and  target.distance ~= nil and target.distance:sqrt() <= 24.5 then
		local lcolor = 'unclaimed'
		if target.spawn_type == 16 then
			if target.status == 1 then
				local party = windower.ffxi.get_party()
				local party_claimed = false
					for i=1, party.party1_count do
						if not party['p' .. i] then
							break
						end
					
						if target.claim_id ~= nil and party['p' .. i].mob ~= nil and
							party['p' .. i].mob.id ~= nil and
							target.claim_id ==  party['p' .. i].mob.id  then
							party_claimed = true
							break
						end
					end
				if party_claimed then
					lcolor = 'claimed'
					return true
				else
					lcolor = 'outclaimed'
					return false
				end
			elseif target.status == 2 or target.status == 3 then
				lcolor = 'defeated'
				return false
			
			end
		end
		if lcolor == 'unclaimed' then
			
			return true
		end
	else
		return false
	end
	
end

function set_hp_colors_for_target(target)
    local color = 'unclaimed'

    if is_player(target) then
        color = 'player'
    elseif target.spawn_type == 2 or target.spawn_type == 14 then
        color = 'npc'
    elseif target.spawn_type == 16 then
        if target.status == 1 then
            local party = windower.ffxi.get_party()
            local party_claimed = false
			
            for i=1, party.party1_count do
                if party[i].mob.id == target.claim_id then
                    party_claimed = true
                    break
                end
            end

            if party_claimed then
                color = 'claimed'
            else
                color = 'outclaimed'
            end
        elseif target.status == 2 or target.status == 3 then
            color = 'defeated'
        end
    end
	claimstatus = color
end


function set_hp_colors_for_targetold(target)
    local color = 'unclaimed'

    if is_player(target) then
        color = 'player'
    elseif target.spawn_type == 2 or target.spawn_type == 14 then
        color = 'npc'
    elseif target.spawn_type == 16 then
        if target.status == 1 then
            local party = windower.ffxi.get_party()
            local party_claimed = false
            for i = 0, 5 do
                if not party['p' .. i] then
                    break
                end
                if party['p' .. i].mob.id == target.claim_id then
                    party_claimed = true
                    break
                end
            end

            if party_claimed then
                color = 'claimed'
            else
                color = 'outclaimed'
            end
        elseif target.status == 2 or target.status == 3 then
            color = 'defeated'
        end
    end
	claimstatus = color
end

function is_outclaimed( target )
	local lcolor = 'unclaimed'
	if target == nil or target.spawn_type == nil then
		return false
	else
		if is_player(target) then
			lcolor = 'player'
			return false
		elseif target.spawn_type == 2 or target.spawn_type == 14 then
			lcolor = 'npc'
			return false
		elseif target.spawn_type == 16 then
			if target.status == 1 then
				local party = windower.ffxi.get_party()
				local party_claimed = false
					for i=1, party.party1_count do
						if not party['p' .. i] then
							break
						end
					
						if target.claim_id ~= nil  and party['p' .. i].mob ~= nil and party['p' .. i].mob.id ~= nil and
							target.claim_id ==  party['p' .. i].mob.id  then
							party_claimed = true
							break
						end
					end
				if party_claimed then
					
					lcolor = 'claimed'
					return false
				else
					
					lcolor = 'outclaimed'
					return true
				end
			elseif target.status == 2 or target.status == 3 then
				lcolor = 'defeated'
				return false
			end
		end
		if lcolor == 'unclaimed' then
			return false
		end
	end
end

function is_claimed(target)
	if target == nil or target.spawn_type == nil or target.status == nil then
	
	else	
		if target.spawn_type == 16 then
			if target.status == 1 then
				local party = windower.ffxi.get_party()
				local party_claimed = false
					for i=1, party.party1_count do
						if not party['p' .. i] then
							break
						end
					
						if target.claim_id ~= nil and
							party['p' .. i].mob.id ~= nil and
							target.claim_id ==  party['p' .. i].mob.id  then
							party_claimed = true
							break
						end
					end
				if party_claimed then
					return true
			   
				end
			end
		end
	end
	return false
	
end

function is_claimedbool(target)
	if target ~= nil then
    if target.spawn_type == 16 then
        if target.status == 1 then
            local party = windower.ffxi.get_party()
            local party_claimed = false
				for i=1, party.party1_count do
					if not party['p' .. i] then
						break
					end
				
					if target.claim_id ~= nil and
						party['p' .. i].mob.id ~= nil and
						target.claim_id ==  party['p' .. i].mob.id  then
						party_claimed = true
						break
					end
				end
            if party_claimed then
				return true
            end
        end
    end
	
	end
	return false
	
end

function is_player(target)
	if target ~= nil then
		return target.spawn_type == 1 or target.spawn_type == 13
	end
end
