-- Teotihuacan-EnvoyDoubler
-- Author: Limer
-- DateCreated: 2/8/2022 14:10:32
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
--print("PL Teotihuacan - Trait Checker Loaded")

local tValidPlayers = C15_GetValidTraitPlayersNew("TRAIT_CIVILIZATION_UNIT_LIME_TEO_OWL_WARRIOR")
local tOwlWarriorType = "UNIT_LIME_TEO_OWL_WARRIOR"
local iRadius = 3
local mapLayerAny = MapLayers.ANY

function LimeTeotihuacan_OwlWarrior_EnvoyDoubler(playerID, cityStateID, iAmount)
--	print("Someone has sent this many envoys! "..iAmount)
	if not tValidPlayers[playerID] then return end
--	print("That person was Teotihuacan!")

	if iAmount < 0 then return end
	local pCityStateCapital = Players[cityStateID]:GetCities():GetCapitalCity()
	local iX_CS = pCityStateCapital:GetX()
	local iY_CS = pCityStateCapital:GetY()
	--print("City-State is located at " .. iX_CS .. ", " .. iY_CS)

	local pPlayerUnits = Players[playerID]:GetUnits()
	for dx = (iRadius * -1), iRadius do
		for dy = (iRadius * -1), iRadius do
			local pPlot = Map.GetPlotXYWithRangeCheck(iX_CS, iY_CS, dx, dy, iRadius);
			if pPlot == nil then
		--		print("no plot found")
			elseif pPlot ~= nil then	
		--		print("plot found at " .. pPlot:GetX() .. ", " .. pPlot:GetY())
				local pUnits = Units.GetUnitsInPlotLayerID(pPlot:GetX(), pPlot:GetY(), mapLayerAny)
				for k, pUnit in ipairs(pUnits) do
		--			print("unit detected")
					if pUnit:GetType() == GameInfo.Units[tOwlWarriorType].Index then
		--				print("The envoy was sent to a city-state that had an Ehuatl Wearer nearby")
						if pUnit:GetOwner() == playerID then
		--					print("The Ehuatl Wearer was owned by the sending player!")
							for j=1,iAmount do																								
								GameEvents.OnPlayerGaveInfluenceToken.Remove(LimeTeotihuacan_OwlWarrior_EnvoyDoubler)
								local pPlayer = Players[playerID]														-- funny thing about the OnPlayerGaveInfluenceToken event that I learned from Yuknoom
								pPlayer:GetInfluence():GiveFreeTokenToPlayer(cityStateID)								-- using the GiveFreeTokenToPlayer function triggers it, so this code will cause an infinite loop
								GameEvents.OnPlayerGaveInfluenceToken.Add(LimeTeotihuacan_OwlWarrior_EnvoyDoubler)		-- so the function needs to be removed before we put in more influence, then readded after.
		--						print("Envoy given")
							end
		--					print("All envoys given!")
							return
						end
					end
				end
			end
		end
	end
end
-- GameEvents.OnPlayerGaveInfluenceToken.Add(LimeTeotihuacan_OwlWarrior_EnvoyDoubler)

--local tUnitType = "UNIT_SETTLER"
--
--function LimeTeotihuacan_AISettlerDeleter(playerID,	unitID)
--	if not tValidPlayers[playerID] then return end
--	print("player is teotihuacano")
--	if Players[playerID]:IsHuman() then return end
--	print("player is AI")
--	if ((Players[playerID]:GetCities():GetCount() ~= nil) and (Players[playerID]:GetCities():GetCount() > 0)) then
--		print("player has a city")
--		UnitManager.Kill(UnitManager.GetUnit(playerID, unitID))
--		print("killed it")
--	end
--end
--GameEvents.UnitAddedToMap.Add(LimeTeotihuacan_AISettlerDeleter)

print("Functions Loaded")