-- ===========================================================================
-- INCLUDES
-- ===========================================================================
include( "WorldViewIconsManager" );

-- ===========================================================================
--	OVERRIDES
-- ===========================================================================
BASE_Initialize = Initialize

-- ===========================================================================
-- Globals
-- ===========================================================================	

local m_techsThatUnlockResources : table = {};
local m_civicsThatUnlockResources : table = {};
local m_techsThatUnlockImprovements : table = {};

local m_TeamVisibleResources = {};
local m_UnlockResources = {};		-- 未解锁的资源

-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================
function GetTeamVisibleResources()
	local NeedRebuid = false
	for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if Players[Game.GetLocalPlayer()]:GetTeam() == Players[playerID]:GetTeam() and Game.GetLocalPlayer() ~= playerID then		-- 是队友
			local pPlayer = Players[playerID];
			if pPlayer ~= nil then
				local pPlayerResources = pPlayer:GetResources();
				for i = #m_UnlockResources, 1, -1 do												-- 倒序移除
					if pPlayerResources:IsResourceVisible(m_UnlockResources[i].Hash) then
						if not m_TeamVisibleResources[m_UnlockResources[i].Index] then
							NeedRebuid = true
							m_TeamVisibleResources[m_UnlockResources[i].Index] = true
							table.remove(m_UnlockResources,i)				
						end
					end
				end
			end
		end
	end
	if NeedRebuid then
		Rebuild()
	end
end

function GetTeamVisibleResources_Governor(playerID, governorID)		-- 加入结社？
	local NeedRebuid = false
	if Players[Game.GetLocalPlayer()]:GetTeam() == Players[playerID]:GetTeam() and Game.GetLocalPlayer() ~= playerID then		-- 是队友
		local pPlayer = Players[playerID];
		if pPlayer ~= nil then
			local pPlayerResources = pPlayer:GetResources();
			for i = #m_UnlockResources, 1, -1 do
				if pPlayerResources:IsResourceVisible(m_UnlockResources[i].Hash) then
					if not m_TeamVisibleResources[m_UnlockResources[i].Index] then
						NeedRebuid = true
						m_TeamVisibleResources[m_UnlockResources[i].Index] = true
						table.remove(m_UnlockResources,i)
					end
				end
			end
		end
	end
	if NeedRebuid then
		Rebuild()
		Events.GovernorAppointed.Remove(GetTeamVisibleResources_Governor)
	end
end

function GetNonEmptyAt(plotIndex, state)
	local eObserverID = Game.GetLocalObserver();
	local pLocalPlayerVis = PlayerVisibilityManager.GetPlayerVisibility(eObserverID);
	if (pLocalPlayerVis ~= nil) then
		local pInstance = nil;
		local pPlot = Map.GetPlotByIndex(plotIndex);
		-- Have a Resource?
		local eResource = pLocalPlayerVis:GetLayerValue(VisibilityLayerTypes.RESOURCES, plotIndex);
		local bHideResource = ( pPlot ~= nil and ( pPlot:GetDistrictType() > 0 or pPlot:IsCity() ) );
		local eResourceType : number = pPlot:GetResourceType();		-- 单元格上存在的资源
		if (eResource ~= nil and eResource ~= -1 and not bHideResource and GameCapabilities.HasCapability("CAPABILITY_DISPLAY_MINIMAP_RESOURCES")) then
			pInstance = GetInstanceAt(plotIndex);
			SetResourceIcon(pInstance, pPlot, eResource, state);
		elseif (eResourceType ~= nil and eResourceType ~= -1 and m_TeamVisibleResources[eResourceType] and not bHideResource and GameCapabilities.HasCapability("CAPABILITY_DISPLAY_MINIMAP_RESOURCES")) then		-- 不可见资源判断
			pInstance = GetInstanceAt(plotIndex);
			SetResourceIcon(pInstance, pPlot, eResourceType, RevealedState.REVEALED);
		else
			UnloadResourceIconAt(plotIndex);
		end
		if (pPlot) then
			-- Starting plot?
			if pPlot:IsStartingPlot() and WorldBuilder.IsActive() and WorldBuilder.GetWBAdvancedMode() then
				pInstance = GetInstanceAt(plotIndex);
				pInstance.RecommendationIconTexture:TrySetIcon("ICON_UNITOPERATION_FOUND_CITY", 256);
				pInstance.RecommendationIconText:SetHide( false );

				local iPlayer = GetStartingPlotPlayer( pPlot );
				if (iPlayer >= 0) then
					pInstance.RecommendationIconText:SetText( tostring(iPlayer + 1) );
				else
					pInstance.RecommendationIconText:SetText( "" );
				end
			else
				UnloadRecommendationIconAt(plotIndex);
			end
		end
		return pInstance;
	end
end

function OnResearchCompleted( player:number, tech:number, isCanceled:boolean)
	if Players[Game.GetLocalPlayer()]:GetTeam() == Players[player]:GetTeam() or player == Game.GetLocalPlayer() then		-- 是队友
		for i, kdate in ipairs(m_techsThatUnlockResources) do
			if (kdate.PrereqTech == GameInfo.Technologies[tech].TechnologyType) then
				if not m_TeamVisibleResources[kdate.Index] then
					m_TeamVisibleResources[kdate.Index] = true
					Rebuild();
				end
				return;
			end
		end
		for i, techType in ipairs(m_techsThatUnlockImprovements) do
			if (techType == GameInfo.Technologies[tech].TechnologyType) then
				Rebuild();
				return;
			end
		end
	end
end

function OnCivicCompleted( player:number, civic:number, isCanceled:boolean)
	if Players[Game.GetLocalPlayer()]:GetTeam() == Players[player]:GetTeam() or player == Game.GetLocalPlayer() then		-- 是队友
		for i, kdate in ipairs(m_civicsThatUnlockResources) do
			if (kdate.PrereqTech == GameInfo.Civics[civic].CivicType) then
				if not m_TeamVisibleResources[kdate.Index] then
					m_TeamVisibleResources[kdate.Index] = true
					Rebuild();
				end
				return;
			end
		end
	end
end

function OnDistrictAddedToMap(playerID, districtID, cityID, iX, iY, districtType, percentComplete)		-- 拍区域盖住了未解锁的资源？
	if UI.IsInGame() == false then
		return;
	end
	local eObserverID = Game.GetLocalObserver();
	local pLocalPlayerVis = PlayerVisibilityManager.GetPlayerVisibility(eObserverID);
	if (pLocalPlayerVis ~= nil) then
		local visibilityType	= pLocalPlayerVis:GetState(iX, iY);
		local plotIndex:number = GetPlotIndex(iX, iY);
		if plotIndex == -1 then
			return;
		end
		if (visibilityType == RevealedState.HIDDEN) then
			UnloadResourceIconAt(plotIndex);
		else
			if (visibilityType == RevealedState.REVEALED) then
				ChangeToMidFog(plotIndex);
			else
				if (visibilityType == RevealedState.VISIBLE) then
					ChangeToVisible(plotIndex);
				end
			end
		end
	end
end

function Initialize()
	BASE_Initialize();

	Events.LocalPlayerTurnEnd.Add(GetTeamVisibleResources);
	Events.DistrictAddedToMap.Add(OnDistrictAddedToMap);
	Events.GovernorAppointed.Add(GetTeamVisibleResources_Governor);		-- 结社选择？
	LuaEvents.TPT_WorldViewIcon_Rebuild.Add( Rebuild );					-- 保留一个刷新接口

	m_techsThatUnlockResources  	= {};		-- 重建表
	m_civicsThatUnlockResources  	= {};

	for row in GameInfo.Resources() do
		if row.PrereqTech ~= nil then
			local kdate = {
				PrereqTech = row.PrereqTech,
				Index = row.Index,
			}
			table.insert(m_techsThatUnlockResources, kdate);
		end
		if row.PrereqCivic~= nil then
			local kdate = {
				PrereqTech = row.PrereqCivic,
				Index = row.Index,
			}
			table.insert(m_civicsThatUnlockResources, kdate);
		end
	end

	local pPlayer = Players[Game.GetLocalPlayer()];
	if pPlayer ~= nil then
		local pPlayerResources = pPlayer:GetResources();
		for row in GameInfo.Resources() do
			if not pPlayerResources:IsResourceVisible(row.Hash) then
				table.insert(m_UnlockResources, row);
			end
		end
	end
end
Initialize()