-- Copyright 2017-2019, Firaxis Games.
-- Leader container list on top of the HUD

include("InstanceManager");
include("LeaderIcon");
include("PlayerSupport");
include("SupportFunctions");

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
local SCROLL_SPEED			 = 3;
local UPDATE_FRAMES			 = 2;	-- HACK: Require 2 frames to update size change :(
local LEADER_ART_OFFSET_X	 = -4;
local LEADER_ART_OFFSET_Y	 = -10;

local Invisible = ""		-- 不可见时的符号
-- ===========================================================================
--	自定义设置，显示玩家ID和文明名称
-- ===========================================================================
local HidePlayerInfo_PlayerName = false
local HidePlayerInfo_CiviName = false
local PlayerInfo_Text = {}

function OnTPT_Settings_Toggle(ParameterId, Value)
	if ParameterId == "DiplomacyRibbon_PlayerInfo_PlayerName" then
		HidePlayerInfo_PlayerName = not Value
		UpdateLeaders();
		return
	end
	if ParameterId == "DiplomacyRibbon_PlayerInfo_CiviName" then
		HidePlayerInfo_CiviName = not Value
		UpdateLeaders();
		return
	end	
end
LuaEvents.TPT_Settings_Toggle.Add(OnTPT_Settings_Toggle)
-- ===========================================================================
--	获取当前外交能见度模式类型
-- ===========================================================================
local Model = 0		-- 游戏模式
if GameConfiguration.GetValue("SETTINGS_DIPLOMACYRIBBON_TPT") == "SETTINGS_DIPLOMACYRIBBON_NORM" then
	Model = 0
	print("模式：标准(推荐)")
end

if GameConfiguration.GetValue("SETTINGS_DIPLOMACYRIBBON_TPT") == "SETTINGS_DIPLOMACYRIBBON_VISIBILITY_TEAM" then
	Model = 1
--	Modding.UpdateSubscription(3041524474)
	print("模式：外交能见度模式(团队)")
end

if GameConfiguration.GetValue("SETTINGS_DIPLOMACYRIBBON_TPT") == "SETTINGS_DIPLOMACYRIBBON_PUBLIC" then
	Model = 2
	print("模式：公开(完全透明)")
end

--Model = 2		--debug

--[[		规则说明
模式0

分数：		所有人✓			
军力：		仅队友			人口：		仅队友
科技：		所有人✓			粮食：		仅队友
文化：		所有人✓			生产力：		仅队友
金币：		所有人✓			回合金：		所有人✓
信仰：		所有人✓			回合信仰：	所有人✓
外交支持：	所有人✓			回合外交：	所有人✓

模式1

能见度0：										能见度1：											能见度2：											能见度3

分数：		所有人✓			      				|	分数：		所有人✓			      				|	分数：		所有人✓			      				|	分数：		所有人✓			      				|
军力：		仅队友			人口：		仅队友	|	军力：		仅队友			人口：		仅队友	|	军力：		仅队友			人口：		所有人✓	|	军力：		所有人✓			人口：		所有人✓	|		
科技：		仅队友			粮食：		仅队友	|	科技：		仅队友			粮食：		仅队友	|	科技：		所有人✓			粮食：		所有人✓	|	科技：		所有人✓			粮食：		所有人✓	|
文化：		仅队友			生产力：		仅队友	|	文化：		仅队友			生产力：		仅队友	|	文化：		所有人✓			生产力：		仅队友	|	文化：		所有人✓			生产力：		所有人✓	|
金币：		仅队友			回合金：		仅队友	|	金币：		所有人✓			回合金：		所有人✓	|	金币：		所有人✓			回合金：		所有人✓	|	金币：		所有人✓			回合金：		所有人✓	|
信仰：		仅队友			回合信仰：	仅队友	|	信仰：		所有人✓			回合信仰：	所有人✓	|	信仰：		所有人✓			回合信仰：	所有人✓	|	信仰：		所有人✓			回合信仰：	所有人✓	|
外交支持：	仅队友			回合外交：	仅队友	|	外交支持：	所有人✓			回合外交：	所有人✓	|	外交支持：	所有人✓			回合外交：	所有人✓	|	外交支持：	所有人✓			回合外交：	所有人✓	|

模式2

分数：		所有人✓			
军力：		所有人✓			人口：		所有人✓
科技：		所有人✓			粮食：		所有人✓
文化：		所有人✓			生产力：		所有人✓
金币：		所有人✓			回合金：		所有人✓
信仰：		所有人✓			回合信仰：	所有人✓
外交支持：	所有人✓			回合外交：	所有人✓
]]
-- ===========================================================================
--	获取队伍信息
-- ===========================================================================
local IsTeamPlayer  = {}		-- 是否是队友
for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
	local localplayerTeam = Players[Game.GetLocalPlayer()]:GetTeam();
	if Players[playerID]:GetTeam() == localplayerTeam then
		IsTeamPlayer[playerID] = true
	else
		IsTeamPlayer[playerID] = false
	end
end
-- ===========================================================================
--	获取最高能见度
-- ===========================================================================	
local g_AccessLevel	 = {}		--本地玩家对所有其他玩家的能见度	。
function RefreshAccessLevel()		
	local localplayerID = Game.GetLocalPlayer()
	local localplayer 	= Players[localplayerID]
	
	for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do		-- 这个playerID是目标
		local localPlayerDiplomacy = localplayer:GetDiplomacy();
		local localPlayerAccessLevel = localPlayerDiplomacy:GetVisibilityOn(playerID);	
		g_AccessLevel[playerID] = localPlayerAccessLevel;		-- 先获取自己对所有人的能见度
		if not IsTeamPlayer[playerID] then		--目标不是队友时，以队友对目标的最高能见度为准
			for _, iplayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do		--开始遍历队友
				if IsTeamPlayer[iplayerID] then		--是队友时
					local pPlayerDiplomacy = Players[iplayerID]:GetDiplomacy();		-- 队友i的能见度
					local iTeamAccessLevel = pPlayerDiplomacy:GetVisibilityOn(playerID);		--目标是playerID的玩家
					if	iTeamAccessLevel > g_AccessLevel[playerID] then
						g_AccessLevel[playerID] = iTeamAccessLevel		--用更高的能见度替换
					end
				end
			end
		end
		if playerID == localplayerID then	--当目标是自己时，能见度是最高
			g_AccessLevel[playerID] = 4
		end
	end
end
RefreshAccessLevel();		--立即运行，初始化
-- ===========================================================================
--	获取额外的尤里卡加成
-- ===========================================================================
local cached_turn	 = {};
local cached_extra_techboost	 = {};
local cached_extra_civicboost	 = {};
function GetExtraBoostFromModifiers(playerID, isTech)		--获取修改器额外提示

    local cur = Game.GetCurrentGameTurn()

    if cur == cached_turn[playerID] then		-- 如果是本回合，则快速返回储存的值，减少运算量
        if isTech then
            return cached_extra_techboost[playerID] or 0
        else
            return cached_extra_civicboost[playerID] or 0
        end
    end

	cached_turn[playerID] = cur;
	
    local tech_ratio = 0;
    local civic_ratio = 0;
    for _, modifierObjID in ipairs(GameEffects.GetModifiers()) do
        -- Check player ids.
        local isActive = GameEffects.GetModifierActive(modifierObjID);
        local ownerObjID = GameEffects.GetModifierOwner(modifierObjID);
        if isActive and IsOwnerRequirementSetMet(modifierObjID) and (GameEffects.GetObjectsPlayerId(ownerObjID) == playerID) then
            -- The modifier is active, belongs to the given player, and owner requirement set is met.
            local modifierDef = GameEffects.GetModifierDefinition(modifierObjID);
            local modifierType = GameInfo.Modifiers[modifierDef.Id].ModifierType;
            if modifierType then
                local modifierTypeRow = GameInfo.DynamicModifiers[modifierType];
                -- print(modifierTypeRow.EffectType)
                if modifierTypeRow then
                    if modifierTypeRow.EffectType == 'EFFECT_ADJUST_TECHNOLOGY_BOOST' then
                        tech_ratio = tech_ratio + modifierDef.Arguments.Amount;
                    end
                    if modifierTypeRow.EffectType == 'EFFECT_ADJUST_CIVIC_BOOST' then
                        civic_ratio = civic_ratio + modifierDef.Arguments.Amount;
                    end
                end
            end
        end
    end
    -- print(cur, tech_ratio, civic_ratio)
    cached_extra_techboost[playerID] = tech_ratio;
    cached_extra_civicboost[playerID] = civic_ratio;
    if isTech then
        return cached_extra_techboost[playerID];
    else
        return cached_extra_civicboost[playerID];
    end
end
function IsOwnerRequirementSetMet(modifierObjId)
    -- Check if owner requirements are met.
    if modifierObjId ~= nil and modifierObjId ~= 0 then
        local ownerRequirementSetId = GameEffects.GetModifierOwnerRequirementSet(modifierObjId);
        if ownerRequirementSetId then
            return GameEffects.GetRequirementSetState(ownerRequirementSetId) == "Met";
        end
    end
    return true;
end
-- ===========================================================================
--	刷新仪表盘
-- ===========================================================================
local m_currentTechID	 = {}	-- 存储ID
local m_currentCivicID	 = {}
function InitcurrentID()
	for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do		--初始化
		m_currentTechID[playerID] = -1
		m_currentCivicID[playerID] = -1
	end
end
InitcurrentID()

function RefreshTechMeter(playerID, uiLeader)	
	local localPlayer = Players[playerID]
	if localPlayer ~= nil  then
		local playerTechs			= localPlayer:GetTechs();
		local currentTechID		 = playerTechs:GetResearchingTech();
----------------------------------------------------------------------------------------------		
		if(currentTechID >= 0) then
			local progress			 = playerTechs:GetResearchProgress(currentTechID);
			local cost					= playerTechs:GetResearchCost(currentTechID);
			uiLeader.ScienceProgressMeter:SetPercent(progress/cost);		-- 设置研究进度
			
			if playerTechs:HasTech(currentTechID) then	-- 上个研究的项目完成了
				uiLeader.ScienceProgressMeter:SetPercent(1);
			end			
			---------------------------------------------------
			local isBoostable	 = false;
			local boostAmount	 = 0;
			local Estimates		 = progress;			
			
			local techType = GameInfo.Technologies[currentTechID].TechnologyType;
			local boosted = playerTechs:HasBoostBeenTriggered(currentTechID)
			for row in GameInfo.Boosts() do
				if row.TechnologyType == techType then		
					isBoostable	= true;		
					boostAmount = ((row.Boost + GetExtraBoostFromModifiers(playerID, true)) *.01 );
					break;
				end
			end
			if isBoostable and not boosted then
				Estimates = math.min(progress + math.floor(math.max(cost * boostAmount - ((cost * boostAmount % 0.5 == 0) and 0.5 or 1),0)),cost)
			end	
			uiLeader.ScienceBoostMeter:SetPercent(Estimates/cost);			-- 设置尤里卡进度			
----------------------------------------------------------------------------------------------				
			local techInfo = GameInfo.Technologies[currentTechID];
			if (techInfo ~= nil) then
				local textureString = "ICON_" .. techInfo.TechnologyType;
				local textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(textureString,38);
				if textureSheet ~= nil then
					uiLeader.ResearchIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
					local namestr = Locale.Lookup(GameInfo.Technologies[currentTechID].Name )
					if namestr ~= nil then
						if string.len(namestr) > 13 then
							namestr = string.sub(namestr,1,12)
						end
						uiLeader.ScienceText:SetText( namestr )
						
						if uiLeader.ScienceText:GetSizeX() > 60 and string.len(namestr) > 10 then
							namestr = string.sub(namestr,1,9)
							uiLeader.ScienceText:SetText( namestr )
						end
					end
					uiLeader.ScienceTurnsLeft:SetText( "[ICON_Turn] "..playerTechs:GetTurnsLeft().." " )
				end
			end
			if playerTechs:HasTech(currentTechID) then
				uiLeader.ScienceTurnsLeft:SetText(Locale.Lookup("LOC_RESEARCH_CHOOSER_JUST_COMPLETED"))
			end
		end
	end
	SetOffsetX2Center( uiLeader.ScienceText , 60 )
	SetOffsetX2Center( uiLeader.ScienceTurnsLeft , 60 )
end
function RefreshCivisMeter(playerID, uiLeader)		-- 神奇的是，结算市政环节很靠后
	local localPlayer = Players[playerID]
	if localPlayer ~= nil  then
	
		local pPlayerCulture		= localPlayer:GetCulture();
		local currentCivicID     = pPlayerCulture:GetProgressingCivic();
----------------------------------------------------------------------------------------------					
		if(currentCivicID >= 0) then
			local civicProgress	 = pPlayerCulture:GetCulturalProgress(currentCivicID);
			local civicCost			= pPlayerCulture:GetCultureCost(currentCivicID);	
			uiLeader.CultureProgressMeter:SetPercent(civicProgress/civicCost);		-- 设置研究进度
			
			if pPlayerCulture:HasCivic(currentCivicID) then		-- 上个研究的项目完成了
				uiLeader.CultureProgressMeter:SetPercent(1);
			end				
			----------------------------------------------------------------------------------------------		
			local isBoostable	 = false;
			local boostAmount	 = 0;
			local Estimates		 = civicProgress;
			
			local civicType = GameInfo.Civics[currentCivicID].CivicType;
			local boosted = pPlayerCulture:HasBoostBeenTriggered(currentCivicID)
			for row in GameInfo.Boosts() do
				if row.CivicType == civicType then				
					isBoostable	= true;		
					boostAmount = ((row.Boost + GetExtraBoostFromModifiers(playerID, false)) *.01 );
					break;
				end
			end
			if isBoostable and not boosted then
				Estimates = math.min(civicProgress + math.floor(math.max(civicCost * boostAmount - ((civicCost * boostAmount % 0.5 == 0) and 0.5 or 1),0)),civicCost)
			end
			uiLeader.CultureBoostMeter:SetPercent(Estimates/civicCost);		--	设置尤里卡进度	
----------------------------------------------------------------------------------------------				
			local CivicInfo = GameInfo.Civics[currentCivicID];
			if (CivicInfo ~= nil) then
				local civictextureString = "ICON_" .. CivicInfo.CivicType;
				local civictextureOffsetX, civictextureOffsetY, civictextureSheet = IconManager:FindIconAtlas(civictextureString,38);
				if civictextureSheet ~= nil then
					uiLeader.CultureIcon:SetTexture(civictextureOffsetX, civictextureOffsetY, civictextureSheet);
					local namestr = Locale.Lookup(GameInfo.Civics[currentCivicID].Name )		
					if namestr ~= nil then
						if string.len(namestr) > 13 then
							namestr = string.sub(namestr,1,12)
						end
						uiLeader.CultureText:SetText( namestr )
						
						if uiLeader.CultureText:GetSizeX() > 60 and string.len(namestr) > 10 then
							namestr = string.sub(namestr,1,9)
							uiLeader.CultureText:SetText( namestr )
						end						
					end
					uiLeader.CultureTurnsLeft:SetText( "[ICON_Turn] "..pPlayerCulture:GetTurnsLeft().." ")
				end
			end
			if pPlayerCulture:HasCivic(currentCivicID) then
				uiLeader.CultureTurnsLeft:SetText(Locale.Lookup("LOC_CIVICS_CHOOSER_JUST_COMPLETED"))
			end	
			m_currentCivicID[playerID] = currentCivicID
		elseif pPlayerCulture:HasCivic(m_currentCivicID[playerID]) then
			uiLeader.CultureProgressMeter:SetPercent(1);
			uiLeader.CultureTurnsLeft:SetText(Locale.Lookup("LOC_CIVICS_CHOOSER_JUST_COMPLETED"))
		end
	end
	SetOffsetX2Center( uiLeader.CultureText , 60 )
	SetOffsetX2Center( uiLeader.CultureTurnsLeft , 60 )	
end
-- ===========================================================================
--	左键和右键的响应
-- ===========================================================================
local m_TechCivisProgress = true		-- 是否隐藏 正在研究的项目
local m_Totalyield = true				-- 是否隐藏 粮锤部分

function OnMouseClick_TPT_Control_1L()
	m_TechCivisProgress = not m_TechCivisProgress
	UpdateLeaders();
end
function OnMouseClick_TPT_Control_1R()
	UI.PlaySound("Play_UI_Click");		-- 右键没有直接的声音反馈
	m_Totalyield = not m_Totalyield
	UpdateLeaders();
end
-- ===========================================================================
--	绑定快捷键
-- ===========================================================================
local m_TechCivisProgressActionId = Input.GetActionId("HotKey_DPR_TechCivisProgress");
local m_TotalyieldActionId = Input.GetActionId("HotKey_DPR_Totalyield");
function OnInputActionTriggered(actionId)
	if actionId == m_TechCivisProgressActionId then
		UI.PlaySound("Play_UI_Click");
		OnMouseClick_TPT_Control_1L()
	end
	if actionId == m_TotalyieldActionId then
		OnMouseClick_TPT_Control_1R()
	end
end
Events.InputActionTriggered.Add(OnInputActionTriggered)
-- ===========================================================================
--	获取统计数据
-- ===========================================================================
function GetPopulation(playerID)
	local pPlayerCities = Players[playerID]:GetCities()
	local pTotalPopulation = 0
	for i, pCity in pPlayerCities:Members() do
		pTotalPopulation = pTotalPopulation + pCity:GetPopulation()
	end
	return pTotalPopulation
end

function GetFoodSurplusTotal(playerID)
	local pPlayerCities = Players[playerID]:GetCities()
	local pTotalFood = 0
	for i, pCity in pPlayerCities:Members() do
		pTotalFood = pTotalFood + GetFoodSurplus(pCity)
	end
	return pTotalFood
end
function GetFoodSurplus(pCity)
	local FoodSurplusNum = 0
	local iModifiedFood;
	local pCityGrowth	 = pCity:GetGrowth();
	local isStarving = pCityGrowth:GetTurnsUntilStarvation() ~= -1;
	local HappinessGrowthModifier		= pCityGrowth:GetHappinessGrowthModifier();
	local OtherGrowthModifiers			= pCityGrowth:GetOtherGrowthModifier();
	local FoodSurplus					= Round( pCityGrowth:GetFoodSurplus(), 1);
	local HousingMultiplier				= pCityGrowth:GetHousingGrowthModifier();
	local Occupied                      = pCity:IsOccupied();
	local OccupationMultiplier			= pCityGrowth:GetOccupationGrowthModifier();

	if not isStarving then
		local growthModifier =  math.max(1 + (HappinessGrowthModifier/100) + OtherGrowthModifiers, 0);
		iModifiedFood = Round(FoodSurplus * growthModifier, 2);
		FoodSurplusNum = iModifiedFood * HousingMultiplier;		
		if Occupied then
			FoodSurplusNum = iModifiedFood * OccupationMultiplier;
		end
	else
		iModifiedFood = FoodSurplus;
		FoodSurplusNum = iModifiedFood;		
	end		

	return FoodSurplusNum
end

function GetProduction(playerID)
	local pPlayerCities = Players[playerID]:GetCities()
	local pTotalProduction = 0
	for i, pCity in pPlayerCities:Members() do
		pTotalProduction = pTotalProduction + pCity:GetYield(YieldTypes.PRODUCTION)
	end
	return pTotalProduction
end

-- ===========================================================================
--	GLOBALS
-- ===========================================================================
g_maxNumLeaders	= 0;		-- Number of leaders that can fit in the ribbon
g_kRefreshRequesters = {}	-- Who requested a (refresh of stats)


-- ===========================================================================
--	MEMBERS
-- ===========================================================================
local m_kLeaderIM			 = InstanceManager:new("LeaderInstance", "LeaderContainer", Controls.LeaderStack);
local m_leadersMet			 = 0;		-- Number of leaders in the ribbon
local m_scrollIndex			 = 0;		-- Index of leader that is supposed to be on the far right.  TODO: Remove this and instead scroll based on visible area.
local m_scrollPercent		 = 0;		-- Necessary for scroll lerp
local m_isScrolling			 = false;
local m_uiLeadersByID		 = {};		-- map of (entire) leader controls based on player id
local m_uiLeadersByPortrait	 = {};		-- map of leader portraits based on player id
local m_uiChatIconsVisible	 = {};
local m_leaderInstanceHeight = 0;		-- How tall is an instantiated leader instance.
local m_ribbonStats			 = -1;		-- From Options menu, enum of how this should display.
local m_isIniting			 = true;	-- Tracking if initialization is occuring.
local m_kActiveIds			 = {};		-- Which player(s) are active.
local m_isYieldsSubscribed	 = false;	-- Are yield events subscribed to?


-- ===========================================================================
--	Cleanup leaders
-- ===========================================================================
function ResetLeaders()
	m_kLeaderIM:ResetInstances();
	m_leadersMet = 0;
	m_uiLeadersByID = {};	
	m_uiLeadersByPortrait = {};
	m_scrollPercent = 0;
	m_scrollIndex = 0;
	m_leaderInstanceHeight = 0;
	RealizeScroll();
end

-- ===========================================================================
function OnLeaderClicked(playerID  )
	-- Send an event to open the leader in the diplomacy view (only if they met)

	local localPlayerID = Game.GetLocalPlayer();
	local pPlayer = PlayerConfigurations[localPlayerID];
	local isAlive = (localPlayerID ~= PlayerTypes.NONE and pPlayer:IsAlive())
	if (playerID == localPlayerID or Players[localPlayerID]:GetDiplomacy():HasMet(playerID)) and isAlive then
		LuaEvents.DiplomacyRibbon_OpenDiplomacyActionView( playerID );
	end
end

-- ===========================================================================
function ShowStats( uiLeader )
	uiLeader.StatStack:SetHide(false);
	uiLeader.StatStack:CalculateSize();
	uiLeader.StatBacking:SetColorByName("HUDRIBBON_STATS_SHOW");
	uiLeader.ActiveLeaderAndStats:SetHide(false);
end

-- ===========================================================================
function HideStats( uiLeader )
	uiLeader.StatStack:SetHide(true);			
	uiLeader.StatBacking:SetColorByName("HUDRIBBON_STATS_HIDE");
	uiLeader.ActiveLeaderAndStats:SetHide(true);
end

-- ===========================================================================
--	UI Callback
-- ===========================================================================
function OnLeaderSizeChanged( uiLeader )	
--	local pSize = uiLeader.LeaderContainer:GetSize();
--	uiLeader.ActiveLeaderAndStats:SetSizeVal( pSize.x + LEADER_ART_OFFSET_X, pSize.y + LEADER_ART_OFFSET_Y );
end

-- ===========================================================================
-- The four following getter functions are exposed for scenario/mod usage
-- ===========================================================================
function GetLeaderIcon()
	return LeaderIcon:GetInstance(m_kLeaderIM);
end

-- ===========================================================================
function GetUILeadersByID()
	return m_uiLeadersByID;
end

-- ===========================================================================
function GetUILeadersByPortrait()
	return m_uiLeadersByPortrait;
end

-- ===========================================================================
function GetLeadersMet()
	return m_leadersMet;
end

-- ===========================================================================
--	Add a leader (from right to left)
--	iconName,	What icon to draw for the leader portrait
--	playerID,	gamecore's player ID
--	kProps,		(optional) properties about the leader
--					isUnique, no other leaders are like this one
--					isMasked, even if stats are show, hide their values.
-- ===========================================================================

function GetPlayerAbilityText(playerID)
	if PlayerInfo_Text and PlayerInfo_Text[playerID] then
		return PlayerInfo_Text[playerID]
	end
	local pPlayerConfig	 = PlayerConfigurations[playerID];
	local leaderName = pPlayerConfig:GetLeaderTypeName()
	local civilizationName = pPlayerConfig:GetCivilizationTypeName();
	-- 找到领袖技能
	local leaTraits = {}
	for row in GameInfo.LeaderTraits() do
		if row.LeaderType == leaderName then
			table.insert(leaTraits,row.TraitType)
		end
	end
	-- 找到文明技能
	local civTraits = {}
	for row in GameInfo.CivilizationTraits() do
		if row.CivilizationType == civilizationName then
			table.insert(civTraits,row.TraitType)
		end
	end
	local result = Locale.Lookup( GameInfo.Leaders[leaderName].Name ) ..'[NEWLINE]' ..Locale.Lookup( GameInfo.Civilizations[civilizationName].Name )
			..Trait2Text(leaTraits,'TEXT')
			..Trait2Text(civTraits,'TEXT')
			..Trait2Text(leaTraits,'District')
			..Trait2Text(civTraits,'District')
			..Trait2Text(leaTraits,'Building')
			..Trait2Text(civTraits,'Building')
			..Trait2Text(leaTraits,'Improvement')
			..Trait2Text(civTraits,'Improvement')
			..Trait2Text(leaTraits,'Unit')
			..Trait2Text(civTraits,'Unit');
	PlayerInfo_Text[playerID] = result;
	return result
end

function Trait2Text(Traits,Type)
	local result = ''
	local newline = '[NEWLINE]'
	local line = newline..'------------------'..newline
	for _,TraitType in ipairs(Traits) do
		if Type == 'District' then
			for row in GameInfo.Districts() do
				if row.TraitType == TraitType and row.Name and row.Description then
					result = result..line..Locale.Lookup( row.Name )..newline..Locale.Lookup( row.Description )
				end
			end
		elseif  Type == 'Building' then
			for row in GameInfo.Buildings() do
				if row.TraitType == TraitType and row.Name and row.Description then
					result = result..line..Locale.Lookup( row.Name )..newline..Locale.Lookup( row.Description )
				end
			end
		elseif  Type == 'Improvement' then
			for row in GameInfo.Improvements() do
				if row.TraitType == TraitType and row.Name and row.Description then
					result = result..line..Locale.Lookup( row.Name )..newline..Locale.Lookup( row.Description )
				end
			end
		elseif  Type == 'Unit' then
			for row in GameInfo.Units() do
				if row.TraitType == TraitType and row.Name and row.Description then
					result = result..line..Locale.Lookup( row.Name )..newline..Locale.Lookup( row.Description )
				end
			end
		else
			for row in GameInfo.Traits() do
				if row.Name and row.Description then
					local LocaleName = Locale.Lookup( row.Name )
					if row.TraitType == TraitType and row.Name ~= LocaleName then
						result = result..line..Locale.Lookup( row.Name )..newline..Locale.Lookup( row.Description )
					end
				end
			end
		end
	end
	return result
end

function AddLeader(iconName , playerID , kProps)
	
	local isUnique = false;
	if kProps == nil then kProps={}; end
	if kProps.isUnqiue then	isUnqiue=kProps.isUnqiue; end

	m_leadersMet = m_leadersMet + 1;

	-- Create a new leader instance
	local oLeaderIcon  = GetLeaderIcon();
	local uiPortraitButton  = oLeaderIcon.Controls.SelectButton;
	m_uiLeadersByID[playerID] = oLeaderIcon;
	m_uiLeadersByPortrait[uiPortraitButton] = oLeaderIcon;

	oLeaderIcon:UpdateIcon(iconName, playerID, isUnqiue);
	oLeaderIcon:RegisterCallback(Mouse.eLClick, function() OnLeaderClicked(playerID); end);
	if iconName ~= 'ICON_LEADER_DEFAULT' then
		oLeaderIcon.Controls.LeaderContainer:SetToolTipString(GetPlayerAbilityText(playerID))
	end

	-- If using focus, setup mouse in/out callbacks... otherwise clear them.
	if 	m_ribbonStats == RibbonHUDStats.FOCUS then
		uiPortraitButton:RegisterMouseEnterCallback( 
			function( uiControl )
				ShowStats( oLeaderIcon );
			end
		);
		uiPortraitButton:RegisterMouseExitCallback( 
			function( uiControl )
				HideStats( oLeaderIcon );
			end	
		);
	else
		uiPortraitButton:ClearMouseEnterCallback(); 
		uiPortraitButton:ClearMouseExitCallback();
	end

	oLeaderIcon.LeaderContainer:RegisterSizeChanged( 
		function( uiControl ) 
			OnLeaderSizeChanged( oLeaderIcon );
		end
	);

	FinishAddingLeader( playerID, oLeaderIcon, kProps );

	-- Returning so mods can override them and modify the icons
	return oLeaderIcon;
end


-- ===========================================================================
--	Complete adding a leader.
--	Two steps for allowing easier MOD overrides/explansion.
-- ===========================================================================
function FinishAddingLeader( playerID, uiLeader, kProps)
	
	if PlayerConfigurations[playerID]:GetLeaderTypeName() == "LEADER_SPECTATOR" then	-- 号码菌：隐藏观察者
		uiLeader.LeaderContainer:SetHide(true)
	end
	
	local isMasked = false;
	if kProps.isMasked then
		isMasked = kProps.isMasked;
	end	

	uiLeader.TPT_Control_1:SetHide(isMasked);
	
	if Model ~= 2 then
		if m_TechCivisProgress	then
			uiLeader.Score:SetHide(isMasked);
			--------------------------------------------------------------------------------------------------
			-- 组合1
			uiLeader.Military:SetHide( not m_Totalyield or isMasked);
			uiLeader.Science:SetHide( not m_Totalyield or isMasked );
			uiLeader.Culture:SetHide( not m_Totalyield or isMasked );
			uiLeader.Gold:SetHide( not m_Totalyield or isMasked );
			uiLeader.Faith:SetHide( not m_Totalyield or isMasked );
			uiLeader.Favor:SetHide( not m_Totalyield or isMasked );			
			
			-- 组合2
			uiLeader.Cities:SetHide(m_Totalyield or isMasked);
			uiLeader.Food_Total:SetHide(m_Totalyield or isMasked);
			uiLeader.Production_Total:SetHide(m_Totalyield or isMasked);
			uiLeader.GoldPerTurn:SetHide(m_Totalyield or isMasked);
			uiLeader.FaithperTurn:SetHide(m_Totalyield or isMasked);
			uiLeader.FavorperTurn:SetHide(m_Totalyield or isMasked);
			--------------------------------------------------------------------------------------------------
		else
			uiLeader.Score:SetHide(IsTeamPlayer[playerID] or isMasked);
			--------------------------------------------------------------------------------------------------	
			uiLeader.Military:SetHide( not m_Totalyield or IsTeamPlayer[playerID] or isMasked);
			uiLeader.Science:SetHide( not m_Totalyield or IsTeamPlayer[playerID] or isMasked );
			uiLeader.Culture:SetHide( not m_Totalyield or IsTeamPlayer[playerID] or isMasked );
			uiLeader.Gold:SetHide( not m_Totalyield or IsTeamPlayer[playerID] or isMasked );
			uiLeader.Faith:SetHide( not m_Totalyield or IsTeamPlayer[playerID] or isMasked );
			uiLeader.Favor:SetHide( not m_Totalyield or IsTeamPlayer[playerID] or isMasked );			
			
			-- 组合2
			uiLeader.Cities:SetHide(m_Totalyield or IsTeamPlayer[playerID] or isMasked);
			uiLeader.Food_Total:SetHide(m_Totalyield or IsTeamPlayer[playerID] or isMasked);
			uiLeader.Production_Total:SetHide(m_Totalyield or IsTeamPlayer[playerID] or isMasked);
			uiLeader.GoldPerTurn:SetHide(m_Totalyield or IsTeamPlayer[playerID] or isMasked);
			uiLeader.FaithperTurn:SetHide(m_Totalyield or IsTeamPlayer[playerID] or isMasked);
			uiLeader.FavorperTurn:SetHide(m_Totalyield or IsTeamPlayer[playerID] or isMasked);	
		end
	else		-- 模式2
		uiLeader.Score:SetHide(not m_TechCivisProgress or isMasked);
		-- 组合1
		uiLeader.Military:SetHide(not m_TechCivisProgress or not m_Totalyield or isMasked);
		uiLeader.Science:SetHide(not  m_TechCivisProgress or not m_Totalyield or isMasked);
		uiLeader.Culture:SetHide(not  m_TechCivisProgress or not m_Totalyield or isMasked);
		uiLeader.Gold:SetHide(not  m_TechCivisProgress or not m_Totalyield or isMasked);
		uiLeader.Faith:SetHide(not  m_TechCivisProgress or not m_Totalyield or isMasked);
		uiLeader.Favor:SetHide(not  m_TechCivisProgress or not m_Totalyield or isMasked);			
		
		-- 组合2
		uiLeader.Cities:SetHide(not  m_TechCivisProgress or m_Totalyield or isMasked);
		uiLeader.Food_Total:SetHide(not  m_TechCivisProgress or m_Totalyield or isMasked);
		uiLeader.Production_Total:SetHide(not  m_TechCivisProgress or m_Totalyield or isMasked);
		uiLeader.GoldPerTurn:SetHide(not  m_TechCivisProgress or m_Totalyield or isMasked);
		uiLeader.FaithperTurn:SetHide(not  m_TechCivisProgress or m_Totalyield or isMasked);
		uiLeader.FavorperTurn:SetHide(not  m_TechCivisProgress or m_Totalyield or isMasked);		
	end
	-- 科文
	local CanHide = m_TechCivisProgress  or ( not IsTeamPlayer[playerID] and Model ~= 2) or isMasked
	
	uiLeader.ScienceButton:SetHide(CanHide);
	uiLeader.ScienceText:SetHide(CanHide);
	uiLeader.ScienceTurnsLeft:SetHide(CanHide);
	uiLeader.CultureButton:SetHide(CanHide);
	uiLeader.CultureText:SetHide(CanHide);
	uiLeader.CultureTurnsLeft:SetHide(CanHide);
	
	uiLeader.PlayerName:SetHide( HidePlayerInfo_PlayerName or isMasked );
	uiLeader.CivName:SetHide( HidePlayerInfo_CiviName or isMasked );
	
	--------------------------------------------------------------------------------------------------		

	uiLeader.StatStack:CalculateSize();
	local pSize_StatStack = uiLeader.StatStack:GetSize();
	local pSize_LeaderContainer = uiLeader.LeaderContainer:GetSize();
	uiLeader.ActiveLeaderAndStats:SetSizeVal( pSize_LeaderContainer.x + LEADER_ART_OFFSET_X, pSize_StatStack.y + LEADER_ART_OFFSET_Y + 65 );

	if uiLeader.TPT_Control_1 ~= nil then		-- 绑定按钮
		uiLeader.TPT_Control_1:RegisterCallback( Mouse.eLClick, OnMouseClick_TPT_Control_1L)		--左键点击
		uiLeader.TPT_Control_1:RegisterCallback( Mouse.eRClick, OnMouseClick_TPT_Control_1R)		--右键点击
	end

	UpdateStatValues( playerID, uiLeader );
end

-- ===========================================================================
--	Clears leaders and re-adds them to the stack
-- ===========================================================================
function UpdateLeaders()

	ResetLeaders();	

	m_ribbonStats = Options.GetUserOption("Interface", "RibbonStats");


	-- Add entries for everyone we know (Majors only)
	local kPlayers		 = PlayerManager.GetAliveMajors();
	local kMetPlayers	 = {};
	local kUniqueLeaders = {};

	local localPlayerID = Game.GetLocalPlayer();
	local pPlayer  = PlayerConfigurations[localPlayerID];
	if localPlayerID ~= -1 then
		local localPlayer	 = Players[localPlayerID];
		local localDiplomacy = localPlayer:GetDiplomacy();
		table.sort(kPlayers, function(a,b) return localDiplomacy:GetMetTurn(a:GetID()) < localDiplomacy:GetMetTurn(b:GetID()) end);
		
		AddLeader("ICON_"..PlayerConfigurations[localPlayerID]:GetLeaderTypeName(), localPlayerID, {});		--First, add local player.

		kMetPlayers, kUniqueLeaders = GetMetPlayersAndUniqueLeaders();										--Fill table for other players.
	else
		-- No local player so assume it's auto-playing, or local player is dead and observing; show everyone.
		for _, pPlayer in ipairs(kPlayers) do
			local playerID = pPlayer:GetID();
			kMetPlayers[ playerID ] = true;
			if (kUniqueLeaders[playerID] == nil) then
				kUniqueLeaders[playerID] = true;
			else
				kUniqueLeaders[playerID] = false;
			end	
		end
	end
	
	--Then, add the leader icons.
	for _, pPlayer in ipairs(kPlayers) do
		local playerID = pPlayer:GetID();
		if(playerID ~= localPlayerID ) then
			local isMet			 = kMetPlayers[playerID];
			local pPlayerConfig	 = PlayerConfigurations[playerID];
			local isHumanMP		 = (GameConfiguration.IsAnyMultiplayer() and pPlayerConfig:IsHuman());
			if (isMet or isHumanMP) then
				local leaderName = pPlayerConfig:GetLeaderTypeName();
				local isMasked	 = (isMet==false) and isHumanMP;	-- Multiplayer human but haven't met
				local isUnique	 = kUniqueLeaders[leaderName];
				local iconName	 = "ICON_LEADER_DEFAULT";
				
				-- If in an MP game and a player leaves the name returned will be NIL.				
				if isMet and (leaderName ~= nil) then
					iconName = "ICON_"..leaderName;
				end
				
				AddLeader(iconName, playerID, { 
					isMasked=isMasked,
					isUnique=isUnique
					}
				);
			end
		end
	end

	RealizeSize();
end


-- ===========================================================================
--	Updates size and location of BG and Scroll controls
--	additionalElementsWidth, from MODS that add additional content.
-- ===========================================================================
function RealizeSize( additionalElementsWidth )
	
	if additionalElementsWidth == nil then
		additionalElementsWidth = 0;
	end

	local MIN_LEFT_HOOKS			= 260;
	local RIGHT_HOOKS_INITIAL		= 163;
	local WORLD_TRACKER_OFFSET		= 80;					-- Amount of additional space the World Tracker check-box takes up.
	local launchBarWidth		 = MIN_LEFT_HOOKS;
	local partialScreenBarWidth  = RIGHT_HOOKS_INITIAL;	--Width of the upper right-hand of screen.

	-- Loop through leaders in determining size.
	m_leaderInstanceHeight = 0;
	for _,uiLeader in ipairs(m_uiLeadersByID) do
		-- If all are shown  then use max size.
		if m_ribbonStats == RibbonHUDStats.SHOW then
			m_leaderInstanceHeight = math.max( uiLeader.LeaderContainer:GetSizeY(), m_leaderInstanceHeight );
		else
			-- just the leader portrait.
			m_leaderInstanceHeight = uiLeader.SelectButton:GetSizeY();
		end
	end


	-- When not showing stats, leaders can be pushed closer together.
	if m_ribbonStats == RibbonHUDStats.SHOW then
		Controls.LeaderStack:SetStackPadding( 0 );		
	else
		Controls.LeaderStack:SetStackPadding( -8 );
	end
	Controls.LeaderStack:CalculateSize();

	-- Obtain controls
	local uiPartialScreenHookRoot	= ContextPtr:LookUpControl( "/InGame/PartialScreenHooks/RootContainer" );
	local uiPartialScreenHookBar 	= ContextPtr:LookUpControl( "/InGame/PartialScreenHooks/ButtonStack" );
	local uiLaunchBar			 	= ContextPtr:LookUpControl( "/InGame/LaunchBar/ButtonStack" );
	
	if (uiLaunchBar ~= nil) then
			launchBarWidth = math.max(uiLaunchBar:GetSizeX() + WORLD_TRACKER_OFFSET, MIN_LEFT_HOOKS);
	end
	if (uiPartialScreenHookBar~=nil) then
		if uiPartialScreenHookRoot and uiPartialScreenHookRoot:IsVisible() then
			partialScreenBarWidth = uiPartialScreenHookBar:GetSizeX();
		else
			partialScreenBarWidth = 0;  -- There are no partial screen hooks at all; backing is invisible.
		end

	end

	local screenWidth, screenHeight = UIManager:GetScreenSizeVal(); -- Cache screen dimensions
	
	local SIZE_LEADER	 = 63;	-- Size of leader icon and border.
	local paddingLeader	 = Controls.LeaderStack:GetStackPadding();
	local maxSize		 = screenWidth - launchBarWidth - partialScreenBarWidth;	
	local size			 = maxSize;

	g_maxNumLeaders = math.floor(maxSize / (SIZE_LEADER + paddingLeader));

	if m_leadersMet > 0 then
		-- Compute size of the background shadow
		local BG_PADDING_EDGE	 = 50;		-- Account for the (tons of) alpha on edges of shadow graphic.
		local MINIMUM_BG_SIZE	 = 100;
		local bgSize			 = 0;
		if (m_leadersMet > g_maxNumLeaders) then
			bgSize = g_maxNumLeaders * (SIZE_LEADER + paddingLeader) + additionalElementsWidth + BG_PADDING_EDGE;
		else
			bgSize = m_leadersMet * (SIZE_LEADER + paddingLeader) + additionalElementsWidth + BG_PADDING_EDGE;
		end		
		bgSize = math.max(bgSize, MINIMUM_BG_SIZE);
		Controls.RibbonContainer:SetSizeX( bgSize );

		-- Compute actual size of the container
		local PADDING_EDGE		 = 8;
		size = g_maxNumLeaders * (SIZE_LEADER + paddingLeader) + PADDING_EDGE + additionalElementsWidth;
	end
	Controls.ScrollContainer:SetSizeX(size);
	Controls.ScrollContainer:SetSizeY( m_leaderInstanceHeight );
	Controls.LeaderScroll:SetSizeX(size);
	Controls.RibbonContainer:SetOffsetX(partialScreenBarWidth);	
	Controls.LeaderScroll:CalculateSize();
	RealizeScroll();
end

-- ===========================================================================
--	Updates visibility of previous and next buttons
-- ===========================================================================
function RealizeScroll()
	Controls.NextButtonContainer:SetHide( not CanScrollLeft() );
	Controls.PreviousButtonContainer:SetHide( not CanScrollRight() );	
end

-- ===========================================================================
function CanScrollLeft()
	return m_scrollIndex > 0;
end
-- ===========================================================================
function CanScrollRight()
	return m_leadersMet - m_scrollIndex > g_maxNumLeaders;
end

-- ===========================================================================
--	Initialize scroll animation in a particular direction
-- ===========================================================================
function Scroll(direction )
 
	m_scrollPercent = 0;
	m_scrollIndex = m_scrollIndex + direction;

	if(m_scrollIndex < 0) then 
		m_scrollIndex = 0; 
	end

	if(not m_isScrolling) then
		ContextPtr:SetUpdate( UpdateScroll );
		m_isScrolling = true;
	end

	RealizeScroll();
end

-- ===========================================================================
--	Update scroll animation (only called while animating)
-- ===========================================================================
function UpdateScroll(deltaTime )
	
	local start			 = Controls.LeaderScroll:GetScrollValue();
	local destination	 = 1.0 - (m_scrollIndex / (m_leadersMet - g_maxNumLeaders));

	m_scrollPercent = m_scrollPercent + (SCROLL_SPEED * deltaTime);
	if(m_scrollPercent >= 1) then
		m_scrollPercent = 1
		EndScroll();
	end

	Controls.LeaderScroll:SetScrollValue(start + (destination - start) * m_scrollPercent);
end

-- ===========================================================================
--	Cleans up scroll update callback when done scrollin
-- ===========================================================================
function EndScroll()
	ContextPtr:ClearUpdate();
	m_isScrolling = false;
	RealizeScroll();
end

-- ===========================================================================
--	SystemUpdateUI Callback
-- ===========================================================================
function OnUpdateUI(type, tag, iData1, iData2, strData1)
	if(type == SystemUpdateUI.ScreenResize) then
		RealizeSize();
	end
end

-- ===========================================================================
--	EVENT
--	Options menu changed
-- ===========================================================================
function OnUserOptionChanged( eOptionSet, hOptionKey, newOptionValue )
	local ribbonStatsHash  = DB.MakeHash("RibbonStats");
	if hOptionKey == ribbonStatsHash then
	
		RealizeYieldEvents();			-- Change subscription to events (if necessary)	
		m_kLeaderIM:DestroyInstances();	-- Look is changing, start with new instances.
		m_scrollIndex = 0;				-- Reset scroll position to start.
		UpdateLeaders();				-- Now update all the leaders.
		RealizeScroll();

		-- Play appropriate animations
		for id,_ in pairs(m_kActiveIds) do
			if Players[id] and Players[id]:IsTurnActive() then
				OnTurnBegin( id );
			end
		end
	end	
end

-- ===========================================================================
--	EVENT
--	Diplomacy Callback
-- ===========================================================================
function OnDiplomacyMeet(player1ID, player2ID)
	
	local localPlayerID = Game.GetLocalPlayer();
	-- Have a local player?
	if(localPlayerID ~= PlayerTypes.NONE) then
		-- Was the local player involved?
		if (player1ID == localPlayerID or player2ID == localPlayerID) then
			UpdateLeaders();
		end
	end
end

-- ===========================================================================
--	EVENT
--	Diplomacy Callback
-- ===========================================================================
function OnDiplomacyWarStateChange(player1ID, player2ID)
	
	local localPlayerID = Game.GetLocalPlayer();
	-- Have a local player?
	if(localPlayerID ~= PlayerTypes.NONE) then
		-- Was the local player involved?
		if (player1ID == localPlayerID or player2ID == localPlayerID) then
			UpdateLeaders();
		end
	end
end

-- ===========================================================================
--	EVENT
--	Diplomacy Callback
-- ===========================================================================
function OnDiplomacySessionClosed(sessionID)

	local localPlayerID = Game.GetLocalPlayer();
	-- Have a local player?
	if(localPlayerID ~= PlayerTypes.NONE) then
		-- Was the local player involved?
		local diplomacyInfo = DiplomacyManager.GetSessionInfo(sessionID);
		if(diplomacyInfo ~= nil and (diplomacyInfo.FromPlayer == localPlayerID or diplomacyInfo.ToPlayer == localPlayerID)) then
			UpdateLeaders();
		end
	end
end

-- ===========================================================================
--	EVENT
-- ===========================================================================
function OnInterfaceModeChanged(eOldMode, eNewMode)
	if eNewMode == InterfaceModeTypes.VIEW_MODAL_LENS then
		ContextPtr:SetHide(true);
	end
	if eOldMode == InterfaceModeTypes.VIEW_MODAL_LENS then
		ContextPtr:SetHide(false);
	end
end

-- ===========================================================================
function SetOffsetX2Center( Ctr , width )
	local sizeX = Ctr:GetSizeX();
	if sizeX < width then
		Ctr:SetOffsetX( (width-sizeX)/2 )
	else
		Ctr:SetOffsetX( 0 )
	end
end


function UpdateStatValues( playerID, uiLeader )	

	if uiLeader.PlayerName:IsVisible() then
		if uiLeader.PlayerName:GetText() == "PlayerName" or uiLeader.PlayerName:GetText() ~= Locale.Lookup( PlayerConfigurations[playerID]:GetPlayerName() )then
			uiLeader.PlayerName:SetText( Locale.Lookup( PlayerConfigurations[playerID]:GetPlayerName() ) )
			uiLeader.PlayerNameLen:SetText( Locale.Lookup( PlayerConfigurations[playerID]:GetPlayerName() ) )
		end
		
		local pSize_PlayerNameLen = uiLeader.PlayerNameLen:GetSizeX();
		if pSize_PlayerNameLen < 60 then
			uiLeader.PlayerName:SetOffsetX(	(60 - pSize_PlayerNameLen)/2 )
		else
			uiLeader.PlayerName:SetOffsetX( 0 )
		end
	end
	
	if uiLeader.CivName:IsVisible() then
		uiLeader.CivName:SetText( Locale.Lookup( PlayerConfigurations[playerID]:GetCivilizationShortDescription() ) )
		SetOffsetX2Center( uiLeader.CivName , 60 )
	end

	RefreshAccessLevel()		-- 刷新能见度
	
	local pPlayer = Players[playerID];
	
	if uiLeader.Score:IsVisible() then 		-- 分数
		local score	 = Round( pPlayer:GetScore() );
		uiLeader.Score:SetText("[ICON_Capital]"..tostring(score));
	end
	
	--组合1
	if uiLeader.Military:IsVisible() then	-- 军事实力
		local Canshow = true
		if Model == 0 then
			if not IsTeamPlayer[playerID] then
				Canshow = false
			end
		end	
		if Model == 1 then
			if not IsTeamPlayer[playerID] then
				if g_AccessLevel[playerID] < 3 then
					Canshow = false
				end
			end
		end				
		if Canshow then
			local military  = Round( Players[playerID]:GetStats():GetMilitaryStrengthWithoutTreasury() );
			uiLeader.Military:SetText( "[ICON_Strength]"..tostring(military));	
		else
			uiLeader.Military:SetText( "[ICON_Strength]"..Invisible);		
		end
	end
	if uiLeader.Science:IsVisible() then 		-- 科技
		local Canshow = true
		if Model == 1 then
			if not IsTeamPlayer[playerID] then
				if g_AccessLevel[playerID] < 2 then
					Canshow = false
				end
			end
		end			
		if Canshow then
			local science  = Round(pPlayer:GetTechs():GetScienceYield() );
			uiLeader.Science:SetText( "[ICON_Science]"..tostring(science));
		else
			uiLeader.Science:SetText( "[ICON_Science]"..Invisible);
		end
	end
	if uiLeader.Culture:IsVisible() then 		-- 文化
		local Canshow = true
		if Model == 1 then
			if not IsTeamPlayer[playerID] then
				if g_AccessLevel[playerID] < 2 then
					Canshow = false
				end
			end
		end
		if Canshow then		
			local culture  = Round(pPlayer:GetCulture():GetCultureYield() );
			uiLeader.Culture:SetText( "[ICON_Culture]"..tostring(culture));
		else
			uiLeader.Culture:SetText( "[ICON_Culture]"..Invisible);
		end
	end
	if uiLeader.Gold:IsVisible() then		-- 金币储备
		local Canshow = true
		if Model == 1 then
			if not IsTeamPlayer[playerID] then
				if g_AccessLevel[playerID] < 1 then
					Canshow = false
				end
			end
		end
		if Canshow then		
			local pTreasury		= pPlayer:GetTreasury();
			local gold		 = math.floor( pTreasury:GetGoldBalance() );
			uiLeader.Gold:SetText( "[ICON_Gold]"..tostring(gold));
		else
			uiLeader.Gold:SetText( "[ICON_Gold]"..Invisible);
		end
	end
	if uiLeader.Faith:IsVisible() then		-- 信仰储备
		local Canshow = true
		if Model == 1 then
			if not IsTeamPlayer[playerID] then
				if g_AccessLevel[playerID] < 1 then
					Canshow = false
				end
			end
		end
		if Canshow then		
			local faith	 = Round( Players[playerID]:GetReligion():GetFaithBalance() );
			uiLeader.Faith:SetText( "[ICON_Faith]"..tostring(faith));
		else
			uiLeader.Faith:SetText( "[ICON_Faith]"..Invisible);
		end
	end
	if uiLeader.Favor:IsVisible() then 		-- 外交支持储备
		local Canshow = true
		if Model == 1 then
			if not IsTeamPlayer[playerID] then
				if g_AccessLevel[playerID] < 1 then
					Canshow = false
				end
			end
		end
		if Canshow then		
			local favor	 = Round( Players[playerID]:GetFavor() );
			uiLeader.Favor:SetText( " [ICON_Favor] "..tostring(favor)); 
		else
			uiLeader.Favor:SetText( " [ICON_Favor] "..Invisible); 
		end
	end
	
	--组合2
	if uiLeader.Cities:IsVisible() then			-- 人口总量
		local Canshow = true
		if Model == 0 then
			if not IsTeamPlayer[playerID] then
				Canshow = false
			end
		end
		if Model == 1 then
			if not IsTeamPlayer[playerID] then
				if g_AccessLevel[playerID] < 2 then
					Canshow = false
				end
			end
		end
		if 	Canshow then
			local cities = Round(	GetPopulation(playerID) );	
			uiLeader.Cities:SetText( "[ICON_Citizen]"..tostring(cities));
		else
			uiLeader.Cities:SetText( "[ICON_Citizen]"..Invisible);
		end
	end	
	if uiLeader.Food_Total:IsVisible() then 		-- 食物产出总量
		local Canshow = true
		if Model == 0 then
			if not IsTeamPlayer[playerID] then
				Canshow = false
			end
		end
		if Model == 1 then
			if not IsTeamPlayer[playerID] then
				if g_AccessLevel[playerID] < 2 then
					Canshow = false
				end
			end
		end		
		if 	Canshow then
			local foodsurplus_Total = Round(	GetFoodSurplusTotal(playerID) );	
			uiLeader.Food_Total:SetText( "[ICON_Food]"..tostring(foodsurplus_Total));		
		else
			uiLeader.Food_Total:SetText( "[ICON_Food]"..Invisible);	
		end	
	end		
	if uiLeader.Production_Total:IsVisible() then 		-- 生产力总量
		local Canshow = true
		if Model == 0 then
			if not IsTeamPlayer[playerID] then
				Canshow = false
			end
		end
		if Model == 1 then
			if not IsTeamPlayer[playerID] then
				if g_AccessLevel[playerID] < 3 then
					Canshow = false
				end
			end
		end			
		if 	Canshow then
			local production_Total = Round(	GetProduction(playerID) );	
			uiLeader.Production_Total:SetText( "[ICON_Production]"..tostring(production_Total));		
		else
			uiLeader.Production_Total:SetText( "[ICON_Production]"..Invisible);	
		end	
	end	
	if uiLeader.GoldPerTurn:IsVisible() then 				-- 回合金币产出
		local Canshow = true
		if Model == 1 then
			if not IsTeamPlayer[playerID] then
				if g_AccessLevel[playerID] < 1 then
					Canshow = false
				end
			end
		end
		if Canshow then		
			local pTreasury		= pPlayer:GetTreasury();	
			local goldPerTurn = math.floor( pTreasury:GetGoldYield() - pTreasury:GetTotalMaintenance() );
			uiLeader.GoldPerTurn:SetText( "[ICON_Gold]"..tostring(goldPerTurn));
		else
			uiLeader.GoldPerTurn:SetText( "[ICON_Gold]"..Invisible);
		end
	end	
	if uiLeader.FaithperTurn:IsVisible() then		-- 回合信仰产出
		local Canshow = true
		if Model == 1 then
			if not IsTeamPlayer[playerID] then
				if g_AccessLevel[playerID] < 1 then
					Canshow = false
				end
			end
		end
		if Canshow then		
			local faithperTurn = Round( Players[playerID]:GetReligion():GetFaithYield());
			uiLeader.FaithperTurn:SetText( "[ICON_Faith]"..tostring(faithperTurn));
		else
			uiLeader.FaithperTurn:SetText( "[ICON_Faith]"..Invisible);
		end
	end			
	if uiLeader.FavorperTurn:IsVisible() then		-- 回合外交支持增量
		local Canshow = true
		if Model == 1 then
			if not IsTeamPlayer[playerID] then
				if g_AccessLevel[playerID] < 1 then
					Canshow = false
				end
			end
		end
		if Canshow then		
			local favorperTurn = Round( Players[playerID]:GetFavorPerTurn() );			
			uiLeader.FavorperTurn:SetText( " [ICON_Favor] "..tostring(favorperTurn));
		else
			uiLeader.FavorperTurn:SetText( " [ICON_Favor] "..Invisible);
		end
	end	
	
	-- 仪表

	if not m_TechCivisProgress then
		RefreshCivisMeter(playerID, uiLeader)
		RefreshTechMeter(playerID, uiLeader)
	end
	
	-- Show or hide all stats based on options.
	if m_ribbonStats == RibbonHUDStats.SHOW then
		if uiLeader.StatStack:IsHidden() or m_isIniting then
			ShowStats( uiLeader );
		end
	elseif m_ribbonStats == RibbonHUDStats.FOCUS or m_ribbonStats == RibbonHUDStats.HIDE then
		if uiLeader.StatStack:IsVisible() or m_isIniting then			
			HideStats( uiLeader );
		end
	end
end

-- ===========================================================================
--	EVENT
-- ===========================================================================
function OnTurnBegin( playerID )
	local uiLeader		 = m_uiLeadersByID[playerID];
	if(uiLeader ~= nil) then
		UpdateStatValues( playerID, uiLeader );

		local localPlayerID = Game.GetLocalPlayer();
		if(localPlayerID == PlayerTypes.NONE or localPlayerID == PlayerTypes.OBSERVER)then
			return;
		end

		-- Update the approripate animation (alpha vs slide) based on what mode is being used.
		if 	m_ribbonStats == RibbonHUDStats.SHOW then
			if(not(playerID == localPlayerID or Players[localPlayerID]:GetDiplomacy():HasMet(playerID))) then
				uiLeader.LeaderContainer:SetSizeVal(63,63);
			end
			local pSize = uiLeader.LeaderContainer:GetSize();
--			uiLeader.ActiveLeaderAndStats:SetSizeVal( pSize.x + LEADER_ART_OFFSET_X, pSize.y + LEADER_ART_OFFSET_Y );		-- 不适配变化的尺寸
			uiLeader.ActiveLeaderAndStats:SetToBeginning();
			uiLeader.ActiveLeaderAndStats:Play();
		else
			uiLeader.ActiveSlide:SetToBeginning();
			uiLeader.ActiveSlide:Play();
		end
	end

	-- Kluge: autoplay layout will frequently size ribbon before other panels and place it behind them in the HUD.
	local localPlayer = Game.GetLocalPlayer();
	local isAutoPlay = (localPlayer == PlayerTypes.NONE or localPlayer == PlayerTypes.OBSERVER);
	if isAutoPlay then
		RealizeSize();
	end

	m_kActiveIds[playerID] = true;

	UpdateLeaders();
end

-- ===========================================================================
function ResetActiveAnim( playerID )
	local uiLeader  = m_uiLeadersByID[playerID];
	if(uiLeader ~= nil) then
		uiLeader.ActiveLeaderAndStats:SetToBeginning();
		uiLeader.ActiveSlide:SetToBeginning();
	end
end

-- ===========================================================================
--	EVENT
-- ===========================================================================
function OnTurnEnd( playerID )
	local uiLeader  = m_uiLeadersByID[playerID];
	if(uiLeader ~= nil) then
		if m_ribbonStats == RibbonHUDStats.SHOW then
			uiLeader.ActiveLeaderAndStats:Reverse();
		else
			uiLeader.ActiveSlide:Reverse();
		end
	end
	m_kActiveIds[playerID] = nil;
end

-- ===========================================================================
--	EVENT
-- ===========================================================================
function OnLocalTurnBegin()
	local playerID	 = Game.GetLocalPlayer();
	if playerID == PlayerTypes.NONE then return; end;
	OnTurnBegin( playerID );
end

-- ===========================================================================
--	EVENT
-- ===========================================================================
function OnLocalTurnEnd()
	local playerID	 = Game.GetLocalPlayer();
	if playerID == PlayerTypes.NONE then return; end;
	OnTurnEnd( playerID );
end

-- ===========================================================================
--	LUAEvent
-- ===========================================================================
function OnLaunchBarResized( width )
	RealizeSize();
end

-- ===========================================================================
--	UI Callback
-- ===========================================================================
function OnScrollLeft()
	if CanScrollLeft() then 
		Scroll(-1); 
	end
end

-- ===========================================================================
--	UI Callback
-- ===========================================================================
function OnScrollRight()
	if CanScrollRight() then 
		Scroll(1); 
	end
end

-- ===========================================================================
function OnChatReceived(fromPlayer, stayOnScreen)
	local instance= m_uiLeadersByID[fromPlayer];
	if instance == nil then return; end
	if stayOnScreen then
		Controls.ChatIndicatorWaitTimer:Stop();
		instance.ChatIndicatorFade:RegisterEndCallback(function() end);
		table.insert(m_uiChatIconsVisible, instance.ChatIndicatorFade);
	else
		Controls.ChatIndicatorWaitTimer:Stop();

		instance.ChatIndicatorFade:RegisterEndCallback(function() 
			Controls.ChatIndicatorWaitTimer:RegisterEndCallback(function()
				instance.ChatIndicatorFade:RegisterEndCallback(function() instance.ChatIndicatorFade:SetToBeginning(); end);
				instance.ChatIndicatorFade:Reverse();
			end);
			Controls.ChatIndicatorWaitTimer:SetToBeginning();
			Controls.ChatIndicatorWaitTimer:Play();
		end);
	end
	instance.ChatIndicatorFade:Play();
end

-- ===========================================================================
function OnChatPanelShown(fromPlayer, stayOnScreen)
	for _, chatIndicatorFade in ipairs(m_uiChatIconsVisible) do
		chatIndicatorFade:RegisterEndCallback(function() chatIndicatorFade:SetToBeginning(); end);
		chatIndicatorFade:Reverse();
	end
	chatIndicatorFade = {};
end

-- ===========================================================================
function OnLoadGameViewStateDone()
	if(GameConfiguration.IsAnyMultiplayer()) then
		for leaderID, uiLeader in pairs(m_uiLeadersByID) do
			if Players[leaderID]:IsTurnActive() then
				uiLeader.ActiveLeaderAndStats:SetToBeginning();
				uiLeader.ActiveLeaderAndStats:Play();
			end
		end
	end
end

-- ===========================================================================
--	UI Callback
--	Refresh the stats.
-- ===========================================================================
function OnRefresh()
	ContextPtr:ClearRequestRefresh();

	if table.count(g_kRefreshRequesters) > 0 then
		local localPlayerID = Game.GetLocalPlayer();
		if localPlayerID ~= PlayerTypes.NONE and localPlayerID ~= PlayerTypes.OBSERVER and Players[localPlayerID]:IsTurnActive() then 
			local uiLeader  = m_uiLeadersByID[localPlayerID];
			if uiLeader ~= nil then
				UpdateStatValues( localPlayerID, uiLeader );
			end	
		end
	else
		UI.DataError("Attempt to refresh diplomacy ribbon stats but no event triggered the refresh!");
	end
	g_kRefreshRequesters = {};	-- Clear out for next refresh
end

-- ===========================================================================
--	Event
--	Special from most other yield events as this may trigger on players other
--	than the local player for actions such as making a deal.
-- ===========================================================================
function OnTreasuryChanged( playerID, yield , balance)	
	local uiLeader  = m_uiLeadersByID[playerID];
	if uiLeader ~= nil then
		UpdateStatValues( playerID, uiLeader );
	end	

	-- If refresh is pending for local player, it can be cleared.
	if playerID == Game.GetLocalPlayer() and table.count(g_kRefreshRequesters) > 0 then
		ContextPtr:ClearRequestRefresh();
	end
end

-- ===========================================================================
--	Only the local player's yields should be update by event to prevent
--	multiplay changes that telgraph to others what is occuring.
-- ===========================================================================
function OnLocalStatUpdateRequest( eventName )
	table.insert( g_kRefreshRequesters, eventName );
	ContextPtr:RequestRefresh();
end

-- ===========================================================================
--	For use in scenarios to force show ribbon yields (i.e. PirateScenario)
-- ===========================================================================
function SetRibbonOption( option  )
	m_ribbonStats = option;
end

-- ===========================================================================
--	For use in scenarios/mods
-- ===========================================================================
function GetLeaderInstanceByID(playerID )
	return m_uiLeadersByID[playerID];
end

-- ===========================================================================
function StopRibbonAnimation(playerID)
	local uiLeader		 = m_uiLeadersByID[playerID];
	if(uiLeader ~= nil) then
		uiLeader.ActiveLeaderAndStats:SetToBeginning();
		uiLeader.ActiveSlide:SetToBeginning();
	end
end

-- ===========================================================================
function OnStartObserverMode()
	UpdateLeaders();
end

-- ===========================================================================
--	Define EVENT callback functions so they can be added/removed based on
--	whether or not yield stats are being shown.
-- ===========================================================================
OnAnarchyBegins				= function() OnLocalStatUpdateRequest( "OnAnarchyBegins" ); end
OnAnarchyEnds				= function() OnLocalStatUpdateRequest( "OnAnarchyEnds" ); end
OnCityFocusChanged			= function() OnLocalStatUpdateRequest( "OnCityFocusChanged" ); end
OnCityInitialized			= function() OnLocalStatUpdateRequest( "OnCityInitialized" ); end
OnCityProductionChanged		= function() OnLocalStatUpdateRequest( "OnCityProductionChanged" ); end
OnCityWorkerChanged			= function() OnLocalStatUpdateRequest( "OnCityWorkerChanged" ); end
OnDiplomacySessionClosed	= function() OnLocalStatUpdateRequest( "OnDiplomacySessionClosed" ); end
OnFaithChanged				= function() OnLocalStatUpdateRequest( "OnFaithChanged" ); end
OnGovernmentChanged			= function() OnLocalStatUpdateRequest( "OnGovernmentChanged" ); end
OnGovernmentPolicyChanged	= function() OnLocalStatUpdateRequest( "OnGovernmentPolicyChanged" ); end
OnGovernmentPolicyObsoleted	= function() OnLocalStatUpdateRequest( "OnGovernmentPolicyObsoleted" ); end
OnGreatWorkCreated			= function() OnLocalStatUpdateRequest( "OnGreatWorkCreated" ); end
OnImprovementAddedToMap		= function() OnLocalStatUpdateRequest( "OnImprovementAddedToMap" ); end
OnImprovementRemovedFromMap	= function() OnLocalStatUpdateRequest( "OnImprovementRemovedFromMap" ); end
OnPantheonFounded			= function() OnLocalStatUpdateRequest( "OnPantheonFounded" ); end
OnPlayerAgeChanged			= function() OnLocalStatUpdateRequest( "OnPlayerAgeChanged" ); end
OnResearchCompleted			= function() OnLocalStatUpdateRequest( "OnResearchCompleted" ); end
OnUnitAddedToMap			= function() OnLocalStatUpdateRequest( "OnUnitAddedToMap" ); end
OnUnitGreatPersonActivated	= function() OnLocalStatUpdateRequest( "OnUnitGreatPersonActivated" ); end
OnUnitKilledInCombat		= function() OnLocalStatUpdateRequest( "OnUnitKilledInCombat" ); end
OnUnitRemovedFromMap		= function() OnLocalStatUpdateRequest( "OnUnitRemovedFromMap" ); end

-- ===========================================================================
function SubscribeYieldEvents()
	m_isYieldsSubscribed = true;
	
	Events.AnarchyBegins.Add( OnAnarchyBegins );
	Events.AnarchyEnds.Add( OnAnarchyEnds );
	Events.CityFocusChanged.Add( OnCityFocusChanged );
	Events.CityInitialized.Add( OnCityInitialized );			
	Events.CityProductionChanged.Add( OnCityProductionChanged );
	Events.CityWorkerChanged.Add( OnCityWorkerChanged );	
	Events.FaithChanged.Add( OnFaithChanged );
	Events.GovernmentChanged.Add( OnGovernmentChanged );
	Events.GovernmentPolicyChanged.Add( OnGovernmentPolicyChanged );
	Events.GovernmentPolicyObsoleted.Add( OnGovernmentPolicyObsoleted );
	Events.GreatWorkCreated.Add( OnGreatWorkCreated );
	Events.ImprovementAddedToMap.Add( OnImprovementAddedToMap );
	Events.ImprovementRemovedFromMap.Add( OnImprovementRemovedFromMap );
	Events.PantheonFounded.Add( OnPantheonFounded );
	Events.PlayerAgeChanged.Add( OnPlayerAgeChanged );
	Events.ResearchCompleted.Add( OnResearchCompleted );
	Events.TreasuryChanged.Add( OnTreasuryChanged );	
	Events.UnitAddedToMap.Add( OnUnitAddedToMap );
	Events.UnitGreatPersonActivated.Add( OnUnitGreatPersonActivated );
	Events.UnitKilledInCombat.Add( OnUnitKilledInCombat );
	Events.UnitRemovedFromMap.Add( OnUnitRemovedFromMap );
end

-- ===========================================================================
function UnsubscribeYieldEvents()
	m_isYieldsSubscribed = false;

	Events.AnarchyBegins.Remove( OnAnarchyBegins );
	Events.AnarchyEnds.Remove( OnAnarchyEnds );
	Events.CityFocusChanged.Remove( OnCityFocusChanged );
	Events.CityInitialized.Remove( OnCityInitialized );			
	Events.CityProductionChanged.Remove( OnCityProductionChanged );
	Events.CityWorkerChanged.Remove( OnCityWorkerChanged );	
	Events.FaithChanged.Remove( OnFaithChanged );
	Events.GovernmentChanged.Remove( OnGovernmentChanged );
	Events.GovernmentPolicyChanged.Remove( OnGovernmentPolicyChanged );
	Events.GovernmentPolicyObsoleted.Remove( OnGovernmentPolicyObsoleted );
	Events.GreatWorkCreated.Remove( OnGreatWorkCreated );
	Events.ImprovementAddedToMap.Remove( OnImprovementAddedToMap );
	Events.ImprovementRemovedFromMap.Remove( OnImprovementRemovedFromMap );
	Events.PantheonFounded.Remove( OnPantheonFounded );
	Events.PlayerAgeChanged.Remove( OnPlayerAgeChanged );
	Events.ResearchCompleted.Remove( OnResearchCompleted );
	Events.TreasuryChanged.Remove( OnTreasuryChanged );	
	Events.UnitAddedToMap.Remove( OnUnitAddedToMap );
	Events.UnitGreatPersonActivated.Remove( OnUnitGreatPersonActivated );
	Events.UnitKilledInCombat.Remove( OnUnitKilledInCombat );
	Events.UnitRemovedFromMap.Remove( OnUnitRemovedFromMap );
end

-- ===========================================================================
--	Only listen for events related to yield updates if they are showing.
-- ===========================================================================
function RealizeYieldEvents()
	if m_ribbonStats == RibbonHUDStats.HIDE then
		if m_isYieldsSubscribed==false then 
			return;									-- Already un-subscribed.
		end
		UnsubscribeYieldEvents();
	else
		if m_isYieldsSubscribed then return; end;	-- Already subscribed.
		SubscribeYieldEvents();
	end
end


-- ===========================================================================
--	CALLBACK
-- ===========================================================================
function OnShutdown()
	if m_isYieldsSubscribed then
		UnsubscribeYieldEvents();
	end

	Events.DiplomacyDeclareWar.Remove( OnDiplomacyWarStateChange ); 
	Events.DiplomacyMakePeace.Remove( OnDiplomacyWarStateChange ); 
	Events.DiplomacyMeet.Remove( OnDiplomacyMeet );
	Events.DiplomacyRelationshipChanged.Remove( UpdateLeaders ); 
	Events.DiplomacySessionClosed.Remove( OnDiplomacySessionClosed );
	Events.InterfaceModeChanged.Remove( OnInterfaceModeChanged );
	Events.LoadGameViewStateDone.Remove( OnLoadGameViewStateDone );
	Events.LocalPlayerChanged.Remove(UpdateLeaders);
	Events.LocalPlayerTurnBegin.Remove( OnLocalTurnBegin );
	Events.LocalPlayerTurnEnd.Remove( OnLocalTurnEnd );
	Events.MultiplayerPlayerConnected.Remove(UpdateLeaders);
	Events.MultiplayerPostPlayerDisconnected.Remove(UpdateLeaders);
	Events.PlayerInfoChanged.Remove(UpdateLeaders);
	Events.PlayerDefeat.Remove(UpdateLeaders);
	Events.PlayerRestored.Remove(UpdateLeaders);
	Events.PlayerIntroduced.Remove(UpdateLeaders);
	Events.RemotePlayerTurnBegin.Remove( OnTurnBegin );
	Events.RemotePlayerTurnEnd.Remove( OnTurnEnd );
	Events.SystemUpdateUI.Remove( OnUpdateUI );
	Events.UserOptionChanged.Remove( OnUserOptionChanged );	

	LuaEvents.ChatPanel_OnChatReceived.Remove(OnChatReceived);
	LuaEvents.EndGameMenu_StartObserverMode.Remove( OnStartObserverMode );
	LuaEvents.LaunchBar_Resize.Remove( OnLaunchBarResized );
	LuaEvents.PartialScreenHooks_Realize.Remove(RealizeSize);
	LuaEvents.WorldTracker_OnChatShown.Remove(OnChatPanelShown);
end

-- ===========================================================================
function LateInitialize()
	RealizeYieldEvents();

	ContextPtr:SetRefreshHandler( OnRefresh );

	Controls.NextButton:RegisterCallback( Mouse.eLClick, OnScrollLeft );
	Controls.PreviousButton:RegisterCallback( Mouse.eLClick, OnScrollRight );
	Controls.LeaderScroll:SetScrollValue(1);

	Events.DiplomacyDeclareWar.Add( OnDiplomacyWarStateChange ); 
	Events.DiplomacyMakePeace.Add( OnDiplomacyWarStateChange ); 
	Events.DiplomacyMeet.Add( OnDiplomacyMeet );
	Events.DiplomacyRelationshipChanged.Add( UpdateLeaders ); 
	Events.DiplomacySessionClosed.Add( OnDiplomacySessionClosed );
	Events.InterfaceModeChanged.Add( OnInterfaceModeChanged );
	Events.LoadGameViewStateDone.Add( OnLoadGameViewStateDone );
	Events.LocalPlayerChanged.Add(UpdateLeaders);
	Events.LocalPlayerTurnBegin.Add( OnLocalTurnBegin );
	Events.LocalPlayerTurnEnd.Add( OnLocalTurnEnd );
	Events.MultiplayerPlayerConnected.Add(UpdateLeaders);
	Events.MultiplayerPostPlayerDisconnected.Add(UpdateLeaders);
	Events.PlayerInfoChanged.Add(UpdateLeaders);
	Events.PlayerDefeat.Add(UpdateLeaders);
	Events.PlayerRestored.Add(UpdateLeaders);
	Events.PlayerIntroduced.Add(UpdateLeaders);
	Events.RemotePlayerTurnBegin.Add( OnTurnBegin );
	Events.RemotePlayerTurnEnd.Add( OnTurnEnd );	
	Events.SystemUpdateUI.Add( OnUpdateUI );
	Events.UserOptionChanged.Add( OnUserOptionChanged );	

	Events.ResearchChanged.Add(function(playerID)
		if not m_TechCivisProgress then
			local uiLeader  = m_uiLeadersByID[playerID];
			if uiLeader ~= nil then
				UpdateStatValues( playerID, uiLeader );
				if not m_TechCivisProgress then
					RefreshTechMeter(playerID, uiLeader)
				end
			end
		end
	end);
	
	Events.CivicChanged.Add(function(playerID)
		if not m_TechCivisProgress then
			local uiLeader  = m_uiLeadersByID[playerID];
			if uiLeader ~= nil then
				UpdateStatValues( playerID, uiLeader );
				if not m_TechCivisProgress then
					RefreshCivisMeter(playerID, uiLeader)
				end
			end
		end
	end);

	LuaEvents.ChatPanel_OnChatReceived.Add(OnChatReceived);
	LuaEvents.EndGameMenu_StartObserverMode.Add( OnStartObserverMode );
	LuaEvents.LaunchBar_Resize.Add( OnLaunchBarResized );
	LuaEvents.PartialScreenHooks_Realize.Add(RealizeSize);
	LuaEvents.WorldTracker_OnChatShown.Add(OnChatPanelShown);
		
	if not BASE_LateInitialize then	-- Only update leaders if this is the last in the call chain.
		UpdateLeaders();
	end
end

-- ===========================================================================
function OnInit( isReload )
	LateInitialize();
	m_isIniting = false;

	local localPlayerID = Game.GetLocalPlayer();
	if localPlayerID ~= PlayerTypes.NONE and localPlayerID ~= PlayerTypes.OBSERVER and Players[localPlayerID]:IsTurnActive() then 
		OnLocalTurnBegin();
	end
end

-- ===========================================================================
--	Main Initialize
-- ===========================================================================
function Initialize()	
	ContextPtr:SetInitHandler( OnInit );
	ContextPtr:SetShutdown( OnShutdown );
end
Initialize();


-- ===========================================================================
-- ex1
-- ===========================================================================
BASE_AddLeader = AddLeader;

-- ===========================================================================
function AddLeader(iconName , playerID , kProps)	
	local oLeaderIcon	 = BASE_AddLeader(iconName, playerID, kProps);
	local localPlayerID	 = Game.GetLocalPlayer();

	if localPlayerID == PlayerTypes.NONE or localPlayerID == PlayerTypes.OBSERVER then
		return;
	end

	if GameCapabilities.HasCapability("CAPABILITY_DISPLAY_HUD_RIBBON_RELATIONSHIPS") then
		-- Update relationship pip tool with details about our alliance if we're in one
		local localPlayerDiplomacy = Players[localPlayerID]:GetDiplomacy();
		if localPlayerDiplomacy then
			local allianceType = localPlayerDiplomacy:GetAllianceType(playerID);
			if allianceType ~= -1 then
				local allianceName = Locale.Lookup(GameInfo.Alliances[allianceType].Name);
				local allianceLevel = localPlayerDiplomacy:GetAllianceLevel(playerID);
				oLeaderIcon.Controls.Relationship:SetToolTipString(Locale.Lookup("LOC_DIPLOMACY_ALLIANCE_FLAG_TT", allianceName, allianceLevel));
			end
		end
	end

	return oLeaderIcon;
end

include("CongressButton");


-- ===========================================================================
-- ex2
-- ===========================================================================
BASE_LateInitialize = LateInitialize;
BASE_UpdateLeaders = UpdateLeaders;
BASE_RealizeSize = RealizeSize;
BASE_FinishAddingLeader = FinishAddingLeader;
BASE_UpdateStatValues = UpdateStatValues;


-- ===========================================================================
--	MEMBERS
-- ===========================================================================
local m_kCongressButtonIM	 = nil;
local m_oCongressButton		 = nil;
local m_congressButtonWidth	 = 0;


-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================

-- ===========================================================================
function UpdateLeaders()
	-- Create and add World Congress button if one was allocated (based on capabilities)
	if m_kCongressButtonIM then
		if Game.GetEras():GetCurrentEra() >= GlobalParameters.WORLD_CONGRESS_INITIAL_ERA then		
			m_kCongressButtonIM:ResetInstances();
			local pPlayer = PlayerConfigurations[Game.GetLocalPlayer()];
			if(pPlayer ~= nil and pPlayer:IsAlive())then
				m_oCongressButton = CongressButton:GetInstance( m_kCongressButtonIM );
				m_congressButtonWidth = m_oCongressButton.Top:GetSizeX();
			else
				m_congressButtonWidth = 0;
			end
		end
	end

	BASE_UpdateLeaders();	
end


-- ===========================================================================
--	OVERRIDE
-- ===========================================================================
function RealizeSize( additionalElementsWidth )			
	BASE_RealizeSize( m_congressButtonWidth );
	--The Congress button takes up one leader slot, so the max num of leaders used to calculate scroll is reduced by one in XP2	
	g_maxNumLeaders = g_maxNumLeaders - 1;
end

-- ===========================================================================
--	OVERRIDE
-- ===========================================================================
--[[		-- 号码菌 -- 并入原文件，方便管理
function FinishAddingLeader( playerID, uiLeader, kProps)	

	local isMasked = false;
	if kProps.isMasked then	isMasked = kProps.isMasked; end
	
	local isHideFavor	 = isMasked or (not Game.IsVictoryEnabled("VICTORY_DIPLOMATIC"));		--TODO: Change to capability check when favor is added to capability system.
	uiLeader.Favor:SetHide( isHideFavor );

	BASE_FinishAddingLeader( playerID, uiLeader, kProps );
end
]]
-- ===========================================================================
--	OVERRIDE
-- ===========================================================================
--[[		-- 号码菌 -- 并入原文件，方便管理
function UpdateStatValues( playerID, uiLeader )	
	BASE_UpdateStatValues( playerID, uiLeader );
	local favor	 = Round( Players[playerID]:GetFavor() );
	if uiLeader.Favor:IsVisible() then uiLeader.Favor:SetText( " [ICON_Favor] "..tostring(favor)); end
end
]]
-- ===========================================================================
function OnLeaderClicked(playerID  )
	-- Send an event to open the leader in the diplomacy view (only if they met)
	local pWorldCongress = Game.GetWorldCongress();
	local localPlayerID = Game.GetLocalPlayer();

	if localPlayerID == -1 or localPlayerID == 1000 then
		return;
	end

	if playerID == localPlayerID or Players[localPlayerID]:GetDiplomacy():HasMet(playerID) then
		if pWorldCongress:IsInSession() then
			LuaEvents.DiplomacyActionView_OpenLite(playerID);
		else
			LuaEvents.DiplomacyRibbon_OpenDiplomacyActionView(playerID);
		end
	end
end

-- ===========================================================================
function LateInitialize()

	BASE_LateInitialize();

	if GameCapabilities.HasCapability("CAPABILITY_WORLD_CONGRESS") then
		m_kCongressButtonIM = InstanceManager:new("CongressButton", "Top", Controls.LeaderStack);
	end

	if not XP2_LateInitialize then	-- Only update leaders if this is the last in the call chain.
		UpdateLeaders();
	end
end
