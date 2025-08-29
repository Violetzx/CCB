include( "InstanceManager" );

local m_TPT_TopPanel_Production_TT = {}
local m_TPT_TopPanel_Food_TT = {}
local m_TPT_TopPanel_Population_TT = {}

local UV_CITIZEN_STARVING_STATUS		:table = {};
		UV_CITIZEN_STARVING_STATUS[0] = {u=0, v=0};		-- starving
		UV_CITIZEN_STARVING_STATUS[1] = {u=0, v=100};	-- normal
		UV_CITIZEN_STARVING_STATUS[2] = {u=0, v=150};	-- growing

function OnTopPanelToolTip_Production_Refresh(Production_Info)
	m_TPT_TopPanel_Production_TT.Production_Header:SetText(Locale.Lookup("LOC_TOPPANEL_PRODUCTION_TOOLTIP_HEADER", Production_Info.TotalProduction))
	
	m_TPT_TopPanel_Production_TT.TopPanel_Production_Citys_Stack:DestroyAllChildren()
	
	if m_TPT_TopPanel_Production_TT.IM == nil then
		m_TPT_TopPanel_Production_TT.IM = InstanceManager:new("TopPanel_ProductionInstance", "BG", m_TPT_TopPanel_Production_TT.TopPanel_Production_Citys_Stack)
	end
	
	for i, kdate in ipairs(Production_Info.CitysInfo) do
		local tInstance = m_TPT_TopPanel_Production_TT.IM:GetInstance()
		
		tInstance.CityName:SetText(kdate.CityName)
		tInstance.CityProduction:SetText(Locale.ToNumber(kdate.CityProduction, "+#####.#[icon_Production]"))
	end

	m_TPT_TopPanel_Production_TT.TopPanel_Production_Citys_Stack:CalculateSize();
	m_TPT_TopPanel_Production_TT.MainStack:CalculateSize();
end

function OnTopPanelToolTip_Food_Refresh(Food_Info)
	m_TPT_TopPanel_Food_TT.Food_Header:SetText(Locale.Lookup("LOC_TOPPANEL_FOOD_TOOLTIP_HEADER", Food_Info.TotalFood))
	
	m_TPT_TopPanel_Food_TT.TopPanel_Food_Citys_Stack:DestroyAllChildren()
	
	if m_TPT_TopPanel_Food_TT.IM == nil then
		m_TPT_TopPanel_Food_TT.IM = InstanceManager:new("TopPanel_FoodInstance", "BG", m_TPT_TopPanel_Food_TT.TopPanel_Food_Citys_Stack)
	end
	
	for i, kdate in ipairs(Food_Info.CitysInfo) do
		local tInstance = m_TPT_TopPanel_Food_TT.IM:GetInstance()
		
		local GrowthModifierText = 100 * kdate.GrowthModifier.."%"
		if kdate.GrowthModifier > 1 then
			GrowthModifierText = "[COLOR:StatGoodCS]"..GrowthModifierText
		elseif kdate.GrowthModifier < 1 then
			GrowthModifierText = "[COLOR:ResMilitaryLabelCS]"..GrowthModifierText
		end
		if kdate.FoodSurplus < 0 then
			GrowthModifierText = "[COLOR:ResMilitaryLabelCS]"..Locale.Lookup("LOC_HUD_CITY_STARVING")
		end
		
		tInstance.CityName:SetText(kdate.CityName)
		tInstance.Food:SetText(Locale.ToNumber(kdate.CityFood, "+#####.#[Icon_Food]"))
		tInstance.FoodSurplus:SetText(Locale.ToNumber(kdate.FoodSurplus, "+#####.#[Icon_FoodSurplus];[COLOR:ResMilitaryLabelCS]-#####.#[Icon_FoodDeficit]"))
		tInstance.GrowthModifier:SetText(GrowthModifierText)
		
		UpdateCitizenGrowthStatusIcon(tInstance, kdate.FoodSurplus, kdate.GrowthModifier)
	end
	
	m_TPT_TopPanel_Food_TT.TopPanel_Food_Citys_Stack:CalculateSize();
end

function UpdateCitizenGrowthStatusIcon(Controls, FoodSurplus, GrowthModifier)

	local color;
	if FoodSurplus < 0 then
		-- Starving
		statusIndex = 0;
		color = "StatBadCSGlow";
	elseif FoodSurplus == 0 then
		-- Neutral
		statusIndex = 1;
		color = "StatNormalCSGlow";
	else
		-- Growing
		statusIndex = 2;
		
		if GrowthModifier >= 1 then
			color = "StatGoodCSGlow";
		else
			color = "PolicyEconomic"
		end
	end

	Controls.CitizenGrowthStatus:SetColorByName(color);
	Controls.CitizenGrowthStatusIcon:SetColorByName(color);

	local uv = UV_CITIZEN_STARVING_STATUS[statusIndex];
	Controls.CitizenGrowthStatus:SetTextureOffsetVal( uv.u, uv.v );
end

function OnTopPanelToolTip_Population_Refresh(Population_Info)
	m_TPT_TopPanel_Population_TT.Population_Header:SetText(Locale.Lookup("LOC_TOPPANEL_POPULATION_TOOLTIP_HEADER", Population_Info.TotalPopulation))
 
	m_TPT_TopPanel_Population_TT.TopPanel_Population_Citys_Stack:DestroyAllChildren()
 
	if m_TPT_TopPanel_Population_TT.IM == nil then
		m_TPT_TopPanel_Population_TT.IM = InstanceManager:new("TopPanel_PopulationInstance", "BG", m_TPT_TopPanel_Population_TT.TopPanel_Population_Citys_Stack)
	end
 
	for i, kdate in ipairs(Population_Info.CitysInfo) do
		local tInstance = m_TPT_TopPanel_Population_TT.IM:GetInstance()
 
		local HouseText = ""
		if kdate.HousingMultiplier >= 1 then
			HouseText = Locale.ToNumber(kdate.Housing, "+#####[Icon_Housing];-#####[Icon_Housing]")
		else
			-- JNNR:	avoids stack buffer overflow and crash on Mac
			local housingNum = Locale.ToNumber(kdate.Housing, "+#####;-#####")
			HouseText = "[COLOR:ResMilitaryLabelCS]" .. housingNum .. "[Icon_HousingInsufficient]"
		end
 
		local AmenityText = Locale.ToNumber(kdate.Amenity, "+####[ICON_Amenities];-####[ICON_Amenities]")
		if kdate.HappinessGrowthModifier > 0 then
			AmenityText = Locale.ToNumber(kdate.Amenity, "[COLOR:StatGoodCS]+####[ICON_Amenities];[COLOR:StatGoodCS]-####[ICON_Amenities]")
		elseif kdate.HappinessGrowthModifier < 0 then
			AmenityText = Locale.ToNumber(kdate.Amenity, "[COLOR:ResMilitaryLabelCS]+####[ICON_Amenities];[COLOR:ResMilitaryLabelCS]-####[ICON_Amenities]")
		end
 
		tInstance.CityName:SetText(kdate.CityName)
		tInstance.YieldModifier:SetText(kdate.HappinessGrowthModifier == 0 and "0%" or Locale.ToNumber(kdate.HappinessGrowthModifier, "[COLOR:StatGoodCS]+#####.#%;[COLOR:ResMilitaryLabelCS]-#####.#%"))
		tInstance.House:SetText(HouseText)
		tInstance.Amenity:SetText(AmenityText)
		tInstance.Population:SetText(kdate.Population)
	end
	m_TPT_TopPanel_Population_TT.TopPanel_Population_Citys_Stack:CalculateSize();
end

function Initialize()
	TTManager:GetTypeControlTable("TooltipType_TopPanel_Production", m_TPT_TopPanel_Production_TT)
	TTManager:GetTypeControlTable("TooltipType_TopPanel_Food", m_TPT_TopPanel_Food_TT)
	TTManager:GetTypeControlTable("TooltipType_TopPanel_Population", m_TPT_TopPanel_Population_TT)
	
	LuaEvents.TopPanelToolTip_Production_Refresh.Add(OnTopPanelToolTip_Production_Refresh)
	LuaEvents.TopPanelToolTip_Food_Refresh.Add(OnTopPanelToolTip_Food_Refresh)
	LuaEvents.TopPanelToolTip_Population_Refresh.Add(OnTopPanelToolTip_Population_Refresh)
end
Initialize();