-- Ahiram - Lua
-- Author: Lime
-- DateCreated: 8/21/2019 13:19:55
--------------------------------------------------------------
--============================================================
-- HELPER FUNCTIONS
--============================================================
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

local localPlayerID = Game.GetLocalPlayer()
function Player_IsLocalPlayer(playerID)
	local player = Players[playerID]
	if (playerID == localPlayerID and player:IsHuman() and player:IsTurnActive()) then
		return true
	else
		return false
	end
end

--============================================================
-- Variables
--============================================================

local tValidPlayers = C15_GetValidTraitPlayersNew("TRAIT_LEADER_LIME_PHOE_AHIRAM_MERCHANT_PRINCES")
local turnMod = GameInfo.GameSpeeds[GameConfiguration.GetGameSpeedType()].CostMultiplier
local greatMerchantIndex = GameInfo.GreatPersonClasses['GREAT_PERSON_CLASS_MERCHANT'].Index
local localPlayerID = Game.GetLocalPlayer()
-- Controls for yields given
local greatMerchantMod = 1 
local buildingCostMod = 5

--============================================================
-- Actual stuff
--============================================================
-- I can't differentiate between faith and gold purchases
-- that would be too convenient

function LimePhoeniciaAhiram_BuildingPurchases(playerID, cityID, iX, iY, number,	TypeIndex)
	local ahiramPlayer = Players[playerID]
	if tValidPlayers[playerID] then
		--print("Port Lime (Ahiram): Player has Ahiram's Trait")
		--print(TypeIndex)
		--print(number)
		if number == -660405657 then -- this is the one for specifically building purchases
			--print("Port Lime (Ahiram): Purchase was Building")
			local buildingCost = GameInfo.Buildings[TypeIndex].Cost/buildingCostMod
			local iAmountMerchant = (turnMod*greatMerchantMod/100)*buildingCost
			ahiramPlayer:GetGreatPeoplePoints():ChangePointsTotal(greatMerchantIndex, iAmountMerchant)
			--print("Port Lime (Ahiram): GM points given")

			if Player_IsLocalPlayer(playerID) then
				Game.AddWorldViewText(playerID, Locale.Lookup("LOC_LIME_PHOE_AHIRAM_GMERCHANT_DROPTEXT", iAmountMerchant), iX, iY, 0)
			end
		end
	end--]]
end

-- Events.CityMadePurchase.Add(LimePhoeniciaAhiram_BuildingPurchases);

print("Port Lime (Phoenicia): Load successful");