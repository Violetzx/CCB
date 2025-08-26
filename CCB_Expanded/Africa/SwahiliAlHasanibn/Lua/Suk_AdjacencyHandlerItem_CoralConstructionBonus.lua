-- -- Suk_AdjacencyHanderItem_CoralConstructionBonus
-- -- Author: Sukrit
-- -- DateCreated: 8/29/2017 12:08:51 AM
-- --===========================================================================
-- --===========================================================================
-- print("Suk_AdjacencyHanderItem_CoralConstructionBonus : Loading")

-- local sLocalCiv = PlayerConfigurations[Game.GetLocalPlayer()]:GetCivilizationTypeName()
-- if sLocalCiv ~= "CIVILIZATION_SUK_SWAHILI" then print("		Swahili not local player, aborting."); return end
-- --===========================================================================
-- -- TEMPLATES
-- --===========================================================================
-- local tTable_CityCentre = {
-- 	GetAdjacentIconArtdefName = function(pPlayer, pCity, pPlot, eDistrict)
-- 		if not Suk_CoralConstruction_IsCityCoastal(pCity) then return end
-- 		if pPlot:GetDistrictType() == GameInfo.Districts["DISTRICT_CITY_CENTER"].Index then return "Districts_Generic_District" end
-- 		return
-- 	 end,

-- 	-------------------------------------------------------

-- 	GetAdjacentYieldBonus = function(pPlayer, pCity, tPlots, eDistrict, eYield)
-- 		if Suk_CoralConstruction_IsCityCoastal(pCity) then
-- 			local iBonus = Suk_CoralConstruction_AdjacentCityCenter(tPlots)
-- 			local sBonusKey = "LOC_SUK_CORAL_CONSTRUCTION_" ..  GameInfo.Yields[eYield].YieldType .."_CITY_CENTER"
-- 			local sBonus = Locale.Lookup(sBonusKey, iBonus * 2)

-- 			if iBonus > 0 then return iBonus * 2, sBonus end
-- 		end
-- 		return
-- 	end,
-- }

-- ---------------------------------------------------------------------------------------------------------------------------

-- local tTable_Harbor = {
-- 	GetAdjacentIconArtdefName = function(pPlayer, pCity, pPlot, eDistrict)
-- 		if not Suk_CoralConstruction_IsCityCoastal(pCity) then return end
-- 		if pPlot:GetDistrictType() == GameInfo.Districts["DISTRICT_CITY_CENTER"].Index then return "Districts_Generic_District" end
-- 		return
-- 	 end,

-- 	-------------------------------------------------------

-- 	GetAdjacentYieldBonus = function(pPlayer, pCity, tPlots, eDistrict, eYield)
-- 		if Suk_CoralConstruction_IsCityCoastal(pCity) then
-- 			local iBonus = Suk_CoralConstruction_AdjacentHarbor(tPlots)
-- 			local sBonusKey = "LOC_SUK_CORAL_CONSTRUCTION_" ..  GameInfo.Yields[eYield].YieldType .."_HARBOR"
-- 			local sBonus = Locale.Lookup(sBonusKey, iBonus)

-- 			if iBonus > 0 then return iBonus, sBonus end
-- 		end
-- 		return
-- 	end,
-- }
-- --===========================================================================
-- -- UTILITY FUNCTIONS
-- --===========================================================================
-- function Suk_CoralConstruction_IsCityCoastal(pCity)
-- 	local iX = pCity:GetX()
-- 	local iY = pCity:GetY()

-- 	local pPlot = Map.GetPlot(iX, iY)
-- 	for pRingPlot in PlotRingIterator(pPlot, 1) do
-- 		if pRingPlot:IsWater() and not pRingPlot:IsLake() then
-- 			return true
-- 		end
-- 	end

-- 	return false
-- end

-- function Suk_CoralConstruction_AdjacentCityCenter(tPlots)
-- 	local iPlots = 0
-- 	for i,v in ipairs(tPlots) do
-- 		if v:GetDistrictType() == GameInfo.Districts["DISTRICT_CITY_CENTER"].Index then
-- 			iPlots = iPlots + 1
-- 			break
-- 		end
-- 	end
-- 	return iPlots
-- end

-- function Suk_CoralConstruction_AdjacentHarbor(tPlots)
-- 	local iPlots = 0
-- 	for i,v in ipairs(tPlots) do
-- 		if v:GetDistrictType() == GameInfo.Districts["DISTRICT_HARBOR"].Index then
-- 			iPlots = iPlots + 1
-- 			break
-- 		end
-- 	end
-- 	return iPlots
-- end
-- --===========================================================================
-- -- INITIALISE
-- --===========================================================================
-- local sQuery = [[
-- 	SELECT DISTINCT

-- 	Districts.DistrictType,
-- 	Adjacency_YieldChanges.YieldType

-- 	FROM Districts
-- 	JOIN District_Adjacencies ON District_Adjacencies.DistrictType = Districts.DistrictType
-- 	JOIN Adjacency_YieldChanges ON District_Adjacencies.YieldChangeId = Adjacency_YieldChanges.ID
-- 	WHERE Districts.RequiresPopulation = 1 AND Districts.DistrictType NOT IN (SELECT CivUniqueDistrictType FROM DistrictReplaces)
-- ]]

-- local tQuery = DB.Query(sQuery)
-- for _, tRow in pairs(tQuery) do
-- 	table.insert(g_AdjacencyHandlers[GameInfo.Districts[tRow.DistrictType].Index][GameInfo.Yields[tRow.YieldType].Index], tTable_CityCentre)
-- 	table.insert(g_AdjacencyHandlers[GameInfo.Districts[tRow.DistrictType].Index][GameInfo.Yields[tRow.YieldType].Index], tTable_Harbor)
-- end

-- print("		Loaded")
-- --===========================================================================
-- --===========================================================================