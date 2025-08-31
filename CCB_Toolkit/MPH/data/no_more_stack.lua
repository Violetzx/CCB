
function NoMoreStack()
	if ( Game.GetCurrentGameTurn() ~= GameConfiguration.GetStartTurn()) then
	for i = 0, PlayerManager.GetAliveMajorsCount() - 1 do
		if (PlayerConfigurations[i]:GetLeaderTypeName() ~= "LEADER_SPECTATOR" and PlayerConfigurations[i]:GetHandicapTypeID() ~= 2021024770) then
			local pPlayerCulture:table = Players[i]:GetCulture();
			if pPlayerCulture:GetProgressingCivic() == -1 and pPlayerCulture:GetCultureYield()>0 then
				print("Player",PlayerConfigurations[i]:GetLeaderTypeName()," forgot to pick a civic: Adjust. Turn",Game.GetCurrentGameTurn())
				for k = 0, 58 do
					if (pPlayerCulture:HasCivic(k) == false) then
						pPlayerCulture:SetProgressingCivic(k)
						break
					end	
				end
			end
			local pPlayerTechs:table = Players[i]:GetTechs();
			if pPlayerTechs:GetResearchingTech() == -1 and pPlayerTechs:GetScienceYield()>0 then
				print("Player",PlayerConfigurations[i]:GetLeaderTypeName()," forgot to pick a tech: Adjust. Turn",Game.GetCurrentGameTurn())
				for k = 0, 73 do
					if (pPlayerTechs:HasTech(k) == false) then
						pPlayerTechs:SetResearchingTech(k)
						break
					end	
				end
			end
		end		
	end
	end	
end



function Initialize():
	-- GameEvents.OnGameTurnStarted.Add(OnGameTurnStarted);
	GameEvents.OnGameTurnStarted.Add(NoMoreStack);

Initialize();