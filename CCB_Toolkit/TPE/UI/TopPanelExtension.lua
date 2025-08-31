-- ===========================================================================
-- INCLUDES
-- ===========================================================================
local files = {
    "TopPanel_Expansion2",
    "TopPanel_Expansion1",
    "TopPanel",
}

local BaseFile = ""

for _, file in ipairs(files) do
    include(file)
    if Initialize then
        print("Loading " .. file .. " as base file");
        BaseFile = file
        break
    end
end
-- ===========================================================================
-- 全局变量
-- ===========================================================================
TPE_BASE_RefreshYields = RefreshYields;
TPT_BASE_LateInitialize = LateInitialize;

local g_LocalplayerLuxury	:table = {}

local g_TopPanelResources = {};		-- 顶部面板显示资源
local g_TeamVisibleResources = {};

local m_FoodYieldButton = nil
local m_HousingYieldButton = nil
local m_AmenityYieldButton = nil
local m_PopulationYieldButton = nil
local m_ProductionYieldButton = nil

-- 兼容禁止交易模式
local isLuxuriesTradingAllowed = true
local isStrategicsTradingAllowed = true

-- FFA时的奢侈品显示
local IsFFA = true
-- ===========================================================================
-- Team PVP Tools 禁止交易模式
-- ===========================================================================
if GameConfiguration.GetValue("TPT_NO_TRADING_STRATEGICS") == true or GameConfiguration.GetValue("SETTINGS_DIPLOMATIC_DEAL") == "SETTINGS_DEAL_ALONE" then		-- 战略资源
	isStrategicsTradingAllowed = false
	print("TPT - No Trading Strategic - Toppanel")
end

if GameConfiguration.GetValue("TPT_NO_TRADING_LUXURIES") == true then	-- 奢侈品
	isLuxuriesTradingAllowed = false
	print("TPT - No Trading Luxuries - Toppanel")
end
-- ===========================================================================
-- 城市食物产出统计
-- ===========================================================================
function RefreshFood()
	m_FoodYieldButton = m_FoodYieldButton or m_YieldButtonDoubleManager:GetInstance();

	local CanRefresh = true
	local Food_Info = {
		TotalFood = 0,
		CitysInfo = {},
	}

	local pTotalFood = 0
	local pTotalFoodSurplus = 0

	local pPlayerCities = Players[Game.GetLocalPlayer()]:GetCities()

	for i, pCity in pPlayerCities:Members() do

		local pCityName = pCity:GetName()
		local pCityFood = pCity:GetYield(YieldTypes.Food)

		local pFoodSurplus, growthModifier = GetFoodSurplus(pCity)
		
		pTotalFood = pTotalFood + pCityFood
		pTotalFoodSurplus = pTotalFoodSurplus + pFoodSurplus

		local kdate = {
			CityName = Locale.Lookup(pCity:GetName()),
			CityFood = pCityFood,
			FoodSurplus = pFoodSurplus,
			GrowthModifier = growthModifier,
		}
		table.insert(Food_Info.CitysInfo, kdate)
	end
	Food_Info.TotalFood = Locale.ToNumber(pTotalFood, "#####.#");

	m_FoodYieldButton.YieldIconString:SetText("[ICON_FoodLarge]")
	m_FoodYieldButton.YieldPerTurn:SetColorByName("ResFoodLabelCS")
	m_FoodYieldButton.YieldPerTurn:SetText(Locale.ToNumber(pTotalFoodSurplus, "+#####.#;-#####.#"))
	m_FoodYieldButton.YieldBalance:SetText(Locale.ToNumber(pTotalFood, "#####.#"));
	m_FoodYieldButton.YieldBalance:SetColorByName("ResFoodLabelCS");	
	m_FoodYieldButton.YieldBacking:SetToolTipType("TooltipType_TopPanel_Food")
	m_FoodYieldButton.YieldBacking:SetColorByName("ResFoodLabelCS")
	m_FoodYieldButton.YieldBacking:ClearToolTipCallback()
	m_FoodYieldButton.YieldBacking:SetToolTipCallback(
		function()
			if CanRefresh then
				LuaEvents.TopPanelToolTip_Food_Refresh(Food_Info)
				CanRefresh = false
			end
		end
	);
	m_FoodYieldButton.YieldButtonStack:CalculateSize()
end
-- ===========================================================================
-- 获取城市余粮
-- ===========================================================================
function GetFoodSurplus(pCity)
	local FoodSurplusNum = 0
	local growthModifier = 1
	local pCityGrowth	:table = pCity:GetGrowth();
	local isStarving:boolean = pCityGrowth:GetTurnsUntilStarvation() ~= -1;
	local HappinessGrowthModifier		= pCityGrowth:GetHappinessGrowthModifier();
	local OtherGrowthModifiers			= pCityGrowth:GetOtherGrowthModifier();
	local FoodSurplus					= Round( pCityGrowth:GetFoodSurplus(), 1);
	local HousingMultiplier				= pCityGrowth:GetHousingGrowthModifier();
	local Occupied                      = pCity:IsOccupied();
	local OccupationMultiplier			= pCityGrowth:GetOccupationGrowthModifier();

	if not isStarving then
		growthModifier =  math.max(1 + (HappinessGrowthModifier/100) + OtherGrowthModifiers, 0);
		local iModifiedFood = Round(FoodSurplus * growthModifier, 2);
		FoodSurplusNum = iModifiedFood * HousingMultiplier;
		if Occupied then
			FoodSurplusNum = iModifiedFood * OccupationMultiplier;
		end
	else
		FoodSurplusNum = FoodSurplus;
	end

	growthModifier = Round(growthModifier, 2)

	return FoodSurplusNum, growthModifier
end
-- ===========================================================================
-- 城市人口统计
-- ===========================================================================
function RefreshPopulation()
	m_PopulationYieldButton = m_PopulationYieldButton or m_YieldButtonDoubleManager:GetInstance()
	
	local CanRefresh = true
	local Population_Info = {
		TotalPopulation = 0,
		PopulationPerTurn = 0,
		CitysInfo = {},
	}
	
	local pTotalPopulation = 0
	local pTotalPopulationPerTurn = 0
	
	local pPlayerCities = Players[Game.GetLocalPlayer()]:GetCities()
	
	for i, pCity in pPlayerCities:Members() do
		local pPopulation = pCity:GetPopulation()
		local pPopulationPerTurn = GetPopulationPerTurn(pCity)
			
		local pCityGrowth = pCity:GetGrowth()
		
		pTotalPopulation = pTotalPopulation + pPopulation
		pTotalPopulationPerTurn = pTotalPopulationPerTurn + pPopulationPerTurn
		
		local kdate = {
			CityName = Locale.Lookup(pCity:GetName()),
			Population = pPopulation,
			Housing = pCityGrowth:GetHousing() - pPopulation,
			HousingMultiplier = pCityGrowth:GetHousingGrowthModifier(),
			Amenity = pCityGrowth:GetAmenities() - pCityGrowth:GetAmenitiesNeeded(),
			HappinessGrowthModifier = pCityGrowth:GetHappinessNonFoodYieldModifier() / 100,
		}
		table.insert(Population_Info.CitysInfo, kdate)
	end
	
	Population_Info.TotalPopulation = Locale.ToNumber(pTotalPopulation, "#####.#");
	Population_Info.PopulationPerTurn = Locale.ToNumber(Round(pTotalPopulationPerTurn, 1), "#####.#");

	m_PopulationYieldButton.YieldIconString:SetText("[ICON_Citizen]")
	m_PopulationYieldButton.YieldIconString:SetOffsetY(6)
	m_PopulationYieldButton.YieldPerTurn:SetColorByName("StatNormalCS")
	m_PopulationYieldButton.YieldPerTurn:SetText(Locale.ToNumber(Round(pTotalPopulationPerTurn, 1), "+####.#;-####.#"))		-- 也许四舍五入更好？	
	m_PopulationYieldButton.YieldPerTurn:SetOffsetY(-2)
	m_PopulationYieldButton.YieldBalance:SetText(Locale.ToNumber(pTotalPopulation, "#####"));
	m_PopulationYieldButton.YieldBalance:SetOffsetY(-1)
	m_PopulationYieldButton.YieldBalance:SetColorByName("StatNormalCS");	
	m_PopulationYieldButton.YieldBacking:SetColorByName("ChatMessage_Whisper")
	m_PopulationYieldButton.YieldBacking:SetToolTipType("TooltipType_TopPanel_Population")	
	m_PopulationYieldButton.YieldBacking:ClearToolTipCallback()
	m_PopulationYieldButton.YieldBacking:SetToolTipCallback(
		function()
			if CanRefresh then
				LuaEvents.TopPanelToolTip_Population_Refresh(Population_Info)
				CanRefresh = false
			end
		end
	);
	m_PopulationYieldButton.YieldButtonStack:CalculateSize()
end
-- ===========================================================================
-- 获取城市人口增长
-- 余粮除以所需粮食（负增长也许不准？）
-- ===========================================================================
function GetPopulationPerTurn(pCity)
	local pCityGrowth		:table = pCity:GetGrowth();
	local growthThreshold  	:number = pCityGrowth:GetGrowthThreshold();
	local FoodSurPlus = GetFoodSurplus(pCity)

	return FoodSurPlus / growthThreshold
end
-- ===========================================================================
-- 城市生产力统计
-- ===========================================================================
function RefreshProduction()
	m_ProductionYieldButton = m_ProductionYieldButton or m_YieldButtonSingleManager:GetInstance()
	
	local CanRefresh = true
	local Production_Info = {
		TotalProduction = 0,
		CitysInfo = {},
	}
	
	local pPlayerCities = Players[Game.GetLocalPlayer()]:GetCities()
	local pTotalProduction = 0
		
	for i, pCity in pPlayerCities:Members() do
		local pCityProduction = pCity:GetYield(YieldTypes.PRODUCTION)

		pTotalProduction = pTotalProduction + pCityProduction
		
		local kdate = {
			CityName = Locale.Lookup(pCity:GetName()),		
			CityProduction = pCityProduction,
		}
		table.insert(Production_Info.CitysInfo, kdate)
	end
	
	Production_Info.TotalProduction = Locale.ToNumber(pTotalProduction, "#####.#");
	
	m_ProductionYieldButton.YieldIconString:SetText("[ICON_ProductionLarge]")
	m_ProductionYieldButton.YieldPerTurn:SetText(Locale.ToNumber(pTotalProduction, "+#####.#;-#####.#"))
	m_ProductionYieldButton.YieldPerTurn:SetColorByName("ResProductionLabelCS")
	m_ProductionYieldButton.YieldBacking:SetColorByName("ChatMessage_Whisper")
	m_ProductionYieldButton.YieldBacking:SetToolTipType("TooltipType_TopPanel_Production")	
	m_ProductionYieldButton.YieldBacking:ClearToolTipCallback()
	m_ProductionYieldButton.YieldBacking:SetToolTipCallback(
		function()
			if CanRefresh then
				LuaEvents.TopPanelToolTip_Production_Refresh(Production_Info)
				CanRefresh = false
			end
		end
	);
	m_ProductionYieldButton.YieldButtonStack:CalculateSize()
end
-- ===========================================================================
-- 奢侈品资源统计
-- ===========================================================================
function RefreshLuxuryResourcesType()
	m_LuxuryResourcesTypeYieldButton = m_LuxuryResourcesTypeYieldButton or m_YieldButtonSingleManager:GetInstance()
	
	g_LocalplayerLuxury = {}		-- 清空表
	
	local sTextColorGreen = "[COLOR:StatGoodCS]"
	local sTextColorEnd = "[ENDCOLOR]"
	local Morestr = Locale.Lookup("LOC_TOP_PANEL_MORE_LUXURY_NAME")
	
	local sLuxuryResourceListText = ""
	local pLuxuryTotalAmount = 0
	local pLuxuryTotalType = 0
	local More = false
	
	local pPlayerResources = Players[Game.GetLocalPlayer()]:GetResources()	
	
	for resource in GameInfo.Resources() do
		if resource.ResourceClassType ~= nil and resource.ResourceClassType == "RESOURCECLASS_LUXURY" then
			local amount = pPlayerResources:GetResourceAmount(resource.ResourceType)
			if (amount > 0) then
				local addLuxuryResourceText = "[NEWLINE][ICON_"..resource.ResourceType.."] "..Locale.Lookup(resource.Name)
				sLuxuryResourceListText = sLuxuryResourceListText..addLuxuryResourceText
				pLuxuryTotalAmount = pLuxuryTotalAmount + amount
				pLuxuryTotalType = pLuxuryTotalType + 1
				table.insert(g_LocalplayerLuxury,resource.ResourceType)		-- 将已有奢侈写入表			
				if (amount > 1) then
					if	IsTradableResources(resource) then
						More = true
						local Moreamount = amount - 1
						local MoreaddLuxuryResourceText = "[NEWLINE][ICON_"..resource.ResourceType.."] "..Locale.Lookup(resource.Name).." "..Moreamount
						Morestr = Morestr..MoreaddLuxuryResourceText
					end
				end
			end
		end
	end
	
	local sYieldPerTurnText = ""
	
	if pLuxuryTotalAmount > pLuxuryTotalType and More == true then
		sYieldPerTurnText = sTextColorGreen..pLuxuryTotalAmount..sTextColorEnd.."/"..pLuxuryTotalType
	else
		sYieldPerTurnText = pLuxuryTotalAmount.."/"..pLuxuryTotalType
	end

	local sToolTopText = Locale.Lookup("LOC_TPT_TOP_PANEL_LUXURY_RESOURCES", pLuxuryTotalType).."[NEWLINE]"..sLuxuryResourceListText

	if More == true and isLuxuriesTradingAllowed == true then
		sToolTopText = sToolTopText..Morestr
	end
	-- 队友额外奢侈品
	local LUXURYtext = Locale.Lookup("LOC_TOP_PANEL_TEAM_MORE_LUXURY_NAME")
	local TeamMore = false
	
	for j, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if (Players[Game.GetLocalPlayer()]:GetTeam() == Players[playerID]:GetTeam() or IsFFA) and Game.GetLocalPlayer() ~= playerID and not Players[Game.GetLocalPlayer()]:GetDiplomacy():IsAtWarWith( playerID ) and Players[Game.GetLocalPlayer()]:GetDiplomacy():HasMet(playerID) then		-- 是队友
			local LUXURYstr = GetMoreLUXURYstr(playerID)
			if	LUXURYstr then
				TeamMore = true
				LUXURYtext = LUXURYtext..LUXURYstr
			end
		end
	end
	
	if TeamMore == true and isLuxuriesTradingAllowed == true then
		sToolTopText = sToolTopText..LUXURYtext
		sYieldPerTurnText = sYieldPerTurnText.."[icon_PressureHigh]"
	end

	m_LuxuryResourcesTypeYieldButton.YieldIconString:SetText("[ICON_RESOURCE_TOYS]")
	m_LuxuryResourcesTypeYieldButton.YieldPerTurn:SetText(sYieldPerTurnText)
	m_LuxuryResourcesTypeYieldButton.YieldPerTurn:SetColorByName("StatNormalCS")	
	m_LuxuryResourcesTypeYieldButton.YieldBacking:SetToolTipString(sToolTopText)
	m_LuxuryResourcesTypeYieldButton.YieldBacking:SetColorByName("ChatMessage_Whisper")
	m_LuxuryResourcesTypeYieldButton.YieldButtonStack:CalculateSize()
end
-- ===========================================================================
-- 获取额外奢侈品字符串
-- ===========================================================================
function GetMoreLUXURYstr(playerID)

	local pPlayerConfig = PlayerConfigurations[playerID];
	local leaderType = PlayerConfigurations[playerID]:GetLeaderTypeName();
	local LeaderName = Locale.Lookup(GameInfo.Leaders[leaderType].Name);

	local LUXURYstr = "[NEWLINE][NEWLINE][icon_Bullet]"..LeaderName

	local pPlayerResources = Players[playerID]:GetResources()
	local More = false

	for resource in GameInfo.Resources() do
		if resource.ResourceClassType ~= nil and resource.ResourceClassType == "RESOURCECLASS_LUXURY" then
			local amount = pPlayerResources:GetResourceAmount(resource.ResourceType)
			if (amount > 1 and IsNewLuxury(resource)) then
				if PopulateAvailableResources(playerID,resource) then
					More = true
					local MoreaddLuxuryResourceText = "[NEWLINE][ICON_"..resource.ResourceType.."] "..Locale.Lookup(resource.Name)

					LUXURYstr = LUXURYstr..MoreaddLuxuryResourceText
				end
			end
		end
	end
	if More == true then
		return LUXURYstr
	else
		return false
	end
end
-- ===========================================================================
-- 是自己未拥有的新奢侈品？
-- ===========================================================================
function IsNewLuxury(resource)
	local IsNew = true
	for _,iResourceType in ipairs(g_LocalplayerLuxury) do
		if resource.ResourceType == iResourceType then
			IsNew = false
		end
	end
	return IsNew
end
-- ===========================================================================
-- 判断是否是可交易的奢侈品
-- ===========================================================================	local isMet			:boolean = Players[localPlayerID]:GetDiplomacy():HasMet(playerID);
function IsTradableResources(Resource)
	local localPlayerID = Game.GetLocalPlayer()
	for j, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if (Players[Game.GetLocalPlayer()]:GetTeam() == Players[playerID]:GetTeam() or IsFFA) and Game.GetLocalPlayer() ~= playerID and not Players[localPlayerID]:GetDiplomacy():IsAtWarWith( playerID ) and Players[localPlayerID]:GetDiplomacy():HasMet(playerID) then		-- 是队友
			local pForDeal			:table = DealManager.GetWorkingDeal(DealDirection.OUTGOING, localPlayerID, playerID);
			local possibleResources	:table = DealManager.GetPossibleDealItems(localPlayerID, playerID, DealItemTypes.RESOURCES, pForDeal);
				if (possibleResources ~= nil) then
					for i, entry in ipairs(possibleResources) do
						local resourceDesc : table = GameInfo.Resources[entry.ForType];
						if resourceDesc == Resource then
							return true
						end
					end
				end			
			break
		end
	end
	return false
end
-- ===========================================================================
-- 判断是否是可交易的资源
-- ===========================================================================
function PopulateAvailableResources(otherPlayerID,Resource)
	local localPlayerID = Game.GetLocalPlayer()
	local pForDeal			:table = DealManager.GetWorkingDeal(DealDirection.OUTGOING, localPlayerID, otherPlayerID);
	local possibleResources	:table = DealManager.GetPossibleDealItems(otherPlayerID, localPlayerID, DealItemTypes.RESOURCES, pForDeal);
	if (possibleResources ~= nil) then
		for i, entry in ipairs(possibleResources) do
			local resourceDesc : table = GameInfo.Resources[entry.ForType];
			if resourceDesc == Resource then
				if entry.MaxAmount > 1 then
					return true
				end
			end
		end
	end
	return false
end
-- ===========================================================================
--	OVERRIDE
-- ===========================================================================
if BaseFile == "TopPanel_Expansion2" then
	function RefreshResources()
		if not GameCapabilities.HasCapability("CAPABILITY_DISPLAY_TOP_PANEL_RESOURCES") then
			m_kResourceIM:ResetInstances();
			return;
		end
		local localPlayerID = Game.GetLocalPlayer();
		local localPlayer = Players[localPlayerID];
		if (localPlayerID ~= -1) then
			m_kResourceIM:ResetInstances(); 
			local pPlayerResources:table	=  localPlayer:GetResources();
			local yieldStackX:number		= Controls.YieldStack:GetSizeX();
			local infoStackX:number		= Controls.StaticInfoStack:GetSizeX();
			local metaStackX:number		= Controls.RightContents:GetSizeX();
			local screenX, _:number = UIManager:GetScreenSizeVal();
			local maxSize:number = screenX - yieldStackX - infoStackX - metaStackX - m_viewReportsX - META_PADDING;
			if (maxSize < 0) then maxSize = 0; end
			local currSize:number = 0;
			local isOverflow:boolean = false;
			local overflowString:string = "";
			local plusInstance:table;
			for resource in GameInfo.Resources() do
				if (resource.ResourceClassType ~= nil and resource.ResourceClassType ~= "RESOURCECLASS_BONUS" and resource.ResourceClassType ~="RESOURCECLASS_LUXURY" and resource.ResourceClassType ~="RESOURCECLASS_ARTIFACT") then

					local stockpileAmount:number = pPlayerResources:GetResourceAmount(resource.ResourceType);
					local stockpileCap:number = pPlayerResources:GetResourceStockpileCap(resource.ResourceType);
					local reservedAmount:number = pPlayerResources:GetReservedResourceAmount(resource.ResourceType);
					local accumulationPerTurn:number = pPlayerResources:GetResourceAccumulationPerTurn(resource.ResourceType);
					local importPerTurn:number = pPlayerResources:GetResourceImportPerTurn(resource.ResourceType);
					local bonusPerTurn:number = pPlayerResources:GetBonusResourcePerTurn(resource.ResourceType);
					local unitConsumptionPerTurn:number = pPlayerResources:GetUnitResourceDemandPerTurn(resource.ResourceType);
					local powerConsumptionPerTurn:number = pPlayerResources:GetPowerResourceDemandPerTurn(resource.ResourceType);
					local totalConsumptionPerTurn:number = unitConsumptionPerTurn + powerConsumptionPerTurn;
					local totalAmount:number = stockpileAmount + reservedAmount;

					if (totalAmount > stockpileCap) then
						totalAmount = stockpileCap;
					end

					local iconName:string = "[ICON_"..resource.ResourceType.."]";

					local totalAccumulationPerTurn:number = accumulationPerTurn + importPerTurn + bonusPerTurn;

					resourceText = iconName .. " " .. stockpileAmount;

					local numDigits:number = 3;
					if (stockpileAmount >= 10) then
						numDigits = 4;
					end
					local guessinstanceWidth:number = math.ceil(numDigits * FONT_MULTIPLIER);

					local tooltip:string = iconName .. " " .. Locale.Lookup(resource.Name);
					if (reservedAmount ~= 0) then
						--instance.ResourceText:SetColor(UI.GetColorValue("COLOR_YELLOW"));
						tooltip = tooltip .. "[NEWLINE]" .. totalAmount .. "/" .. stockpileCap .. " " .. Locale.Lookup("LOC_RESOURCE_ITEM_IN_STOCKPILE");
						tooltip = tooltip .. "[NEWLINE]-" .. reservedAmount .. " " .. Locale.Lookup("LOC_RESOURCE_ITEM_IN_RESERVE");
					else
						--instance.ResourceText:SetColor(UI.GetColorValue("COLOR_WHITE"));
						tooltip = tooltip .. "[NEWLINE]" .. totalAmount .. "/" .. stockpileCap .. " " .. Locale.Lookup("LOC_RESOURCE_ITEM_IN_STOCKPILE");
					end
					if (totalAccumulationPerTurn >= 0) then
						tooltip = tooltip .. "[NEWLINE]" .. Locale.Lookup("LOC_RESOURCE_ACCUMULATION_PER_TURN", totalAccumulationPerTurn);
					else
						tooltip = tooltip .. "[NEWLINE][COLOR_RED]" .. Locale.Lookup("LOC_RESOURCE_ACCUMULATION_PER_TURN", totalAccumulationPerTurn) .. "[ENDCOLOR]";
					end
					if (accumulationPerTurn > 0) then
						tooltip = tooltip .. "[NEWLINE] " .. Locale.Lookup("LOC_RESOURCE_ACCUMULATION_PER_TURN_EXTRACTED", accumulationPerTurn);
					end
					if (importPerTurn > 0) then
						tooltip = tooltip .. "[NEWLINE] " .. Locale.Lookup("LOC_RESOURCE_ACCUMULATION_PER_TURN_FROM_CITY_STATES", importPerTurn);
					end
					if (bonusPerTurn > 0) then
						tooltip = tooltip .. "[NEWLINE] " .. Locale.Lookup("LOC_RESOURCE_ACCUMULATION_PER_TURN_FROM_BONUS_SOURCES", bonusPerTurn);
					end
					if (totalConsumptionPerTurn > 0) then
						tooltip = tooltip .. "[NEWLINE]" .. Locale.Lookup("LOC_RESOURCE_CONSUMPTION", totalConsumptionPerTurn);
						if (unitConsumptionPerTurn > 0) then
							tooltip = tooltip .. "[NEWLINE]" .. Locale.Lookup("LOC_RESOURCE_UNIT_CONSUMPTION_PER_TURN", unitConsumptionPerTurn);
						end
						if (powerConsumptionPerTurn > 0) then
							tooltip = tooltip .. "[NEWLINE]" .. Locale.Lookup("LOC_RESOURCE_POWER_CONSUMPTION_PER_TURN", powerConsumptionPerTurn);
						end
					end
	-------------------------------------------------------------
					local TeamStrategicYtext = Locale.Lookup("LOC_TOP_PANEL_TEAM_MORE_STRATEGIC_NAME")
					local TeamMore = false
					for j, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
						if Players[Game.GetLocalPlayer()]:GetTeam() == Players[playerID]:GetTeam() and Game.GetLocalPlayer() ~= playerID then		-- 是队友
							local Strategicstr = GetMoreStrategicstr(playerID,resource)
							if	Strategicstr ~= 0 then
								TeamMore = true
								TeamStrategicYtext = TeamStrategicYtext..Strategicstr
							end
						end
					end
					
					if TeamMore == true and isStrategicsTradingAllowed == true then
						tooltip = tooltip .. "[NEWLINE]" .. TeamStrategicYtext
					end
	------------------------------------
					if (stockpileAmount > 0 or totalAccumulationPerTurn > 0 or totalConsumptionPerTurn > 0 or g_TeamVisibleResources[resource.Index]) then		-- 当解锁时显示
						if(currSize + guessinstanceWidth < maxSize and not isOverflow) then
							if (stockpileCap > 0) then
								local instance:table = m_kResourceIM:GetInstance();
								if (totalAccumulationPerTurn > totalConsumptionPerTurn) then
									instance.ResourceVelocity:SetHide(false);
									instance.ResourceVelocity:SetTexture("CityCondition_Rising");
								elseif (totalAccumulationPerTurn < totalConsumptionPerTurn) then
									instance.ResourceVelocity:SetHide(false);
									instance.ResourceVelocity:SetTexture("CityCondition_Falling");
								else
									instance.ResourceVelocity:SetHide(true);
								end

								instance.ResourceText:SetText(resourceText);
								instance.ResourceText:SetToolTipString(tooltip);
								instanceWidth = instance.ResourceText:GetSizeX();
								currSize = currSize + instanceWidth;
							end
						else
							if (not isOverflow) then 
								overflowString = tooltip;
								local instance:table = m_kResourceIM:GetInstance();
								instance.ResourceText:SetText("[ICON_Plus]");
								plusInstance = instance.ResourceText;
							else
								overflowString = overflowString .. "[NEWLINE]" .. tooltip;
							end
							isOverflow = true;
						end
					end
				end
			end

			if (plusInstance ~= nil) then
				plusInstance:SetToolTipString(overflowString);
			end
			
			Controls.ResourceStack:CalculateSize();
			
			if(Controls.ResourceStack:GetSizeX() == 0) then
				Controls.Resources:SetHide(true);
			else
				Controls.Resources:SetHide(false);
			end
		end
	end
	----------------------
	function GetMoreStrategicstr(playerID,resource)

		local MoreStrategicstr = ""

		local leaderType = PlayerConfigurations[playerID]:GetLeaderTypeName();
		local LeaderName = Locale.Lookup(GameInfo.Leaders[leaderType].Name);					-- 获取领袖名字

		local pPlayerResources:table	=  Players[playerID]:GetResources();
		local stockpileAmount:number = pPlayerResources:GetResourceAmount(resource.ResourceType);
		local stockpileCap:number = pPlayerResources:GetResourceStockpileCap(resource.ResourceType);
		local reservedAmount:number = pPlayerResources:GetReservedResourceAmount(resource.ResourceType);

		local totalAmount:number = stockpileAmount + reservedAmount;

		if (totalAmount > stockpileCap) then
			totalAmount = stockpileCap;
		end
		if totalAmount > 0 then
			MoreStrategicstr = MoreStrategicstr .. "[NEWLINE][icon_bullet]" ..LeaderName.. "[NEWLINE]" .."[ICON_"..resource.ResourceType.."]"..totalAmount
			return MoreStrategicstr
		else
			return 0
		end
	end
end
-- ===========================================================================
--	判断队友是否解锁了资源
-- ===========================================================================
function GetTeamVisibleResources(playerID)
	if Players[Game.GetLocalPlayer()]:GetTeam() == Players[playerID]:GetTeam() or playerID == Game.GetLocalPlayer() then		-- 是队友
		local pPlayerResources = Players[playerID]:GetResources();
		for i, kdate in ipairs(g_TopPanelResources) do
			if pPlayerResources:IsResourceVisible(kdate.Hash) then
				g_TeamVisibleResources[kdate.Index] = true
			end
		end
	end
end

function RefreshYields()
	TPE_BASE_RefreshYields();
	
	RefreshFood()
	RefreshProduction()
	RefreshPopulation()
	RefreshLuxuryResourcesType()

	Controls.YieldStack:CalculateSize();
	Controls.StaticInfoStack:CalculateSize();
	Controls.InfoStack:CalculateSize();
end

function LateInitialize()
	TPT_BASE_LateInitialize()
	
	Events.ResearchCompleted.Add(GetTeamVisibleResources);
	Events.CivicCompleted.Add(GetTeamVisibleResources);

	for j, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if Players[playerID]:GetTeam() ~= playerID then		-- 没有选择队伍的情况下，队伍id等于玩家id
			IsFFA = false
		end
	end

	for resource in GameInfo.Resources() do
		if (resource.ResourceClassType ~= nil and resource.ResourceClassType ~= "RESOURCECLASS_BONUS" and resource.ResourceClassType ~="RESOURCECLASS_LUXURY" and resource.ResourceClassType ~="RESOURCECLASS_ARTIFACT") then
			table.insert(g_TopPanelResources, resource);
		end
	end
	GetTeamVisibleResources(Game.GetLocalPlayer())
end