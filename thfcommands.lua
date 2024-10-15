function thfcommand( command )
	if command == "checkMove" then
		if moving then
			equip(sets.aftercast.speed)
		elseif not(midaction()) then
			postcast()
		end
		
	end
	
	if commmand == "AFalse" then
		action = false
		postcast2()
	end
	

	
	if command == "Toggle" then
		if botActive == 'On' then
			botActive = 'Off'
		else
			botActive = 'On'
			playerzone2 = windower.ffxi.get_info().zone 
			
		end
		windower.send_command('@input /echo Auto THF is: '.. botActive .. '')
	end
	
	if command == "RA" then
		lastranged = os.time()
		if not(facing) and player.target ~=nil   then 
				facemob(player.target)
		end
		
		if botActive == 'On' and autotargetmode == "On" then
			dirComm = 'RA'
			commandTime = currentBotTime
		else
			lastranged = currentBotTime  + 1
			send_command('gs equip sets.precast.raThrow; gs disable ammo; gs equip sets.precast.raThrow; wait 1 ;input /equip Ammo Dart;input /ra <t>; wait 2; gs enable ammo')
		end
		
	end
	
	if command == "THga" then
		local spell_recasts = windower.ffxi.get_spell_recasts()
		if botActive == 'On' then
			dirComm = 'THga'
		elseif player.sub_job == 'BLU' and player.target ~= nil and player.target.distance ~= nil and player.target.type ~= nil and player.target.type == 'Monster' and player.target.distance <= 6  then
					 lastbotexec  = currentBotTime + 1
					if  spell_recasts[561] <= 0 and player.mp >= 32 then 
						dirComm = "NA"
						send_command('input /ma "Frightful Roar" <t>')
					elseif spell_recasts[537] <= 0 and player.mp >= 37 then
						dirComm = "NA"
						send_command('input /ma "Stinking Gas" <t>')
					end
		else
			 lastbotexec  = currentBotTime + 1
					if  spell_recasts[561] <= 0 and player.mp >= 32 then 
						send_command('input /ma "Frightful Roar" <t>')
					elseif spell_recasts[537] <= 0 and player.mp >= 37 then
						send_command('input /ma "Stinking Gas" <t>')
					end
		end
	end
	
	if command == "TA" then
		dirComm = 'NA'
		local ja_recasts = windower.ffxi.get_ability_recasts()
		if botActive == 'On' and ja_recasts[67] <= 0 then
			dirComm = 'TA'
			commandTime = currentBotTime
		elseif ja_recasts[67] <= 0  then
			TaWs()
		end
	end
	
	
	if command == "rContinue" then
		rightcontinue()
	end
	
	if command == "lContinue" then
		leftcontinue()
	end
	
	if command == "Followmode" then
		if followmode == "On" then
			followmode = 'Off'
		else
			followmode = 'On'
		end
		windower.send_command('@input /echo follow mode: '.. followmode .. '')
	end
	
	if command == "Rangemode" or command == "RAmode" or command == "ramode" or command == "Ramode" then
		if autoranged == "On" then
			autoranged = 'Off'
		else
			autoranged = 'On'
		end
		windower.send_command('@input /echo Auto Ranged mode: '.. autoranged .. '')
	end
	
	if command == "Jigmode" then
		if jigmode == "On" then
			jigmode = 'Off'
		else
			jigmode = 'On'
		end
		windower.send_command('@input /echo Jig mode: '.. jigmode .. '')
	end
	
	if command == "SCmode" then
		if autoSC == "On" then
			autoSC = 'Off'
		else
			autoSC = 'On'
		end
		windower.send_command('@input /echo Auto SC mode: '.. autoSC .. '')
	end
	
	
	if command == "Debuffmode" then
		if debuffmode == "On" then
			debuffmode = 'Off'
		else
			debuffmode = 'On'
		end
		windower.send_command('@input /echo Debuff mode: '.. debuffmode .. '')
	end
	
	
	if command == "Curemode" then
		if curemode == 'Party' then
			curemode = "Self"
		elseif curemode == 'Self' then
			curemode = "Off"
		else
			curemode = "Party"
		end
		windower.send_command('@input /echo Cure Mode is: '.. curemode .. '')
	end
	
	if command == "Runmode" then
		if runmode == "On" then
			runmode = 'Off'
		else
			runmode = 'On'
		end
		windower.send_command('@input /echo Run mode: '.. runmode .. '')
	end
	
	if command == "Autotargetmode" then
			if autotargetmode == "On" then
				autotargetmode = 'Off'
			else
				autotargetmode = 'On'
				automob = player.target.name
			end
		windower.send_command('@input /echo autotarget mode: '.. autotargetmode .. '')
	end
	
	if command == "THmode" then
		if THmode == "On" then
			THmode = "Off"
		else
			THmode = "On"
		end
		windower.send_command('@input /echo Treasure Hunter mode: '.. THmode .. '')
	end
	
	
	if command == "Stepmode" then
		if stepmode == "On" then
			stepmode = "Off"
		else
			stepmode = "On"
		end
		windower.send_command('@input /echo Step spell mode: '.. stepmode .. '')
	end
	
	
	if command == "Namode" then
		if namode == "On" then
			namode = "Off"
		else
			namode = "On"
		end
		windower.send_command('@input /echo NA spell mode: '.. namode .. '')
	end
	
	if command == "WSmode" then
		if wsmode == "On" then
			wsmode = "Off"
		else
			wsmode = "On"
		end
		windower.send_command('@input /echo Weapon Skill mode: '.. wsmode .. '')
	end
	
	if command == "Backmode" then
		if backattack then
			backattack = false
			windower.send_command('@input /echo back attack mode: Off')
		else
			windower.send_command('@input /echo back attack mode: On')
			backattack = true
		end
		
		
	end
	
	if command == "Utsumode" then
		if utsumode == "On" then
			utsumode = 'Off'
		else
			utsumode = 'On'
		end
		windower.send_command('@input /echo Utsu spell mode: '.. utsumode .. '')
	end
	
	 
	
	if command == "Facemode" then
		if facemode == "On" then
			facemode = 'Off'
		else
			facemode = 'On'
		end
		windower.send_command('@input /echo Auto Face mode: '.. facemode .. '')
	end
	
	if command == "AEmode" then
		if AEmode == "On" then
			AEmode = 'Off'
		else
			AEmode = 'On'
		end
		wsrotation = 1
		windower.send_command('@input /echo AoE Attack mode: '.. AEmode .. '')
	end
	
	if command == "Pull" then
		if player.target.name == nil or is_outclaimed(player.target) then
		
		else
			Puller()
		end
	end
end

