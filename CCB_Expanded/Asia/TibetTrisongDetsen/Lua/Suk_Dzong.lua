-- Suk_Dzong
-- Author: Sukritact
-- DateCreated: 12/16/2018 6:57:56 PM
print("loaded")
--==========================================================================================================================
-- UTILITY FUNCTIONS
--==========================================================================================================================
-- Credits to Chrisy for this function
--------------------------------------------------------------
function GetPlayersWithTrait(sTrait)
	local tValid = {}
	for k, v in pairs(PlayerManager.GetWasEverAliveIDs()) do
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
--------------------------------------------------------------
-- Iterate Plots in Range
--------------------------------------------------------------
function IterPlotsInRange(iX, iY, iRange, bExcludeCenter)
	local tTempTable = {}

	for dx = (iRange * -1), iRange do
		for dy = (iRange * -1), iRange do
			if bExcludeCenter and (iX == dx) and (iY == dy) then
				-- do nothing
			else
				local pOtherPlot = Map.GetPlotXYWithRangeCheck(iX, iY, dx, dy, iRange);
				if pOtherPlot then
					table.insert(tTempTable, pOtherPlot)
				end
			end
		end
	end

	local iNum = 0
	local iMax = #tTempTable
	return function ()
		iNum = iNum + 1
		if iNum <= iMax then return tTempTable[iNum] end
	end
end
--==========================================================================================================================
-- CORE FUNCTIONS
--==========================================================================================================================
-- Awards +1 [Icon_Governor] Governor Title when built adjacent to at least 3 Mountains.
--------------------------------------------------------------
local sDzongTrait		= "TRAIT_CIVILIZATION_DISTRICT_SUK_DZONG"
local tDzongPlayers		= GetPlayersWithTrait(sDzongTrait)

local sDzong			= "DISTRICT_SUK_DZONG"
local iMountainsReq		= 3; if GameInfo.NamedRivers then iMountainsReq = 4 end; -- 4 Mountains in XP2+
local iReward			= 1;

local sNotification		= "+{1} [ICON_Governor] {LOC_ACTION_PANEL_GOVERNOR_OPPORTUNITY}"
---------------------------

function OnDistrictConstructed(iPlayer, eDistrictType, iX, iY)

	if not tDzongPlayers[iPlayer] then return end

	local sDistrict = GameInfo.Districts[eDistrictType].DistrictType
	if sDistrict ~= sDzong then return end

	local iMountains = 0
	for pPlot in IterPlotsInRange(iX, iY, 1) do
		if pPlot:IsMountain() then
			iMountains = iMountains + 1
		end
		if iMountains >= iMountainsReq then break end
	end

	if iMountains < iMountainsReq then return end

	local pPlayer			= Players[iPlayer]
	local pPlayerGov		= pPlayer:GetGovernors()
	pPlayerGov:ChangeGovernorPoints(iReward)

	Game.AddWorldViewText(0, Locale.Lookup(sNotification, iReward), iX, iY, Game.GetLocalPlayer())
	
end
-- GameEvents.OnDistrictConstructed.Add(OnDistrictConstructed)
--==========================================================================================================================
--==========================================================================================================================
