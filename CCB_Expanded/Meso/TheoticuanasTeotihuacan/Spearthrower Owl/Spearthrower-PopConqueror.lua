-- Spearthrower-PopConqueror
-- Author: K'ap'tan Li'im
-- DateCreated: 2/8/2022 14:10:11
--------------------------------------------------------------

--Chrisy's Valid Trait Checker
function C15_GetValidTraitPlayersNew(sTrait)
    local tValid = {}
    for k, v in ipairs(PlayerManager.GetWasEverAliveIDs()) do
        local leaderType = PlayerConfigurations[v]:GetLeaderTypeName()
        for trait in GameInfo.LeaderTraits() do
            if trait.LeaderType == leaderType and trait.TraitType == sTrait then 
                tValid[v] = true 
            end;
        end
        if not tValid[v] then
            local civType = PlayerConfigurations[v]:GetCivilizationTypeName()
            for trait in GameInfo.CivilizationTraits() do
                if trait.CivilizationType == civType and trait.TraitType == sTrait then 
                    tValid[v] = true 
                end;
            end
        end
    end
    return tValid
end
--print("PL Teotihuacan - Spearthrower Owl - Trait Checker Loaded")
local tValidPlayers = C15_GetValidTraitPlayersNew("TRAIT_LEADER_LIME_TEO_OWL_FIRE_IS_BORN")

function LimeTeotihuacan_SpearthrowerOwl_PopConqueror(newPlayerID, oldPlayerID)
--	print("A city was conquered!")

	if not tValidPlayers[newPlayerID] then 
--		print("Spearthrower did not conquer. This time.")
		return 
	end
--	print("Spearthrower Owl conquered the City!")

	print(oldPlayerID)
	local pCS = Players[oldPlayerID]

	if pCS:GetInfluence():CanReceiveInfluence() then
--		print("Spearthrower Owl conquered a City-State!")
		Players[newPlayerID]:GetCities():GetCapitalCity():ChangePopulation(1)
--		print("Spearthrower's Capital has increased in population.")
	end
end

-- GameEvents.CityConquered.Add(LimeTeotihuacan_SpearthrowerOwl_PopConqueror)
print("Function Loaded.")