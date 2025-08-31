local m_AddMapMessageId:number = Input.GetActionId("AddMapMessage");
local m_AddMapTackId:number = Input.GetActionId("AddMapTack");
local m_DeleteMapTackId:number = Input.GetActionId("DeleteMapTack");
local m_ToggleMapTackVisibilityId:number = Input.GetActionId("ToggleMapTackVisibility");
local m_MapPinListBtn = nil;
local m_MapPinFlags = nil;

local g_mapPinStr = nil;
local g_X = nil;
local g_Y = nil;

function OnInputActionTriggered(actionId:number)
	if GameConfiguration.GetValue("CPL_NO_PINS") == true then
		return
	end
    if actionId == m_ToggleMapTackVisibilityId then
		HideMapPins()
	elseif actionId == m_DeleteMapTackId then
		DeleteMapPin();
	elseif actionId == m_AddMapTackId then
		AddMapPin();
	elseif actionId == m_AddMapMessageId then
		AddMapMessage();
	end
end

function AddMapMessage()
	local plotX, plotY = UI.GetCursorPlotCoord();
	if plotX and plotY then
		LuaEvents.MapPinPopup_RequestMapPin(plotX, plotY);
		local Ctr = ContextPtr:LookUpControl("/InGame/MapPinPopup")
		UIManager:DequeuePopup( Ctr );

		local pPlayerCfg = PlayerConfigurations[Game.GetLocalPlayer()];
		local pMapPin = pPlayerCfg:GetMapPin(plotX, plotY);
		if pMapPin ~= nil then
			LuaEvents.MapPinPopup_SendPinToChat(Game.GetLocalPlayer(), pMapPin:GetID());
			g_mapPinStr = "[pin:" .. Game.GetLocalPlayer() .. "," .. pMapPin:GetID() .. "]";
			g_X, g_Y = plotX, plotY;
		end
	end
end

function OnMultiplayerChat( fromPlayer, toPlayer, text, eTargetType )
	if fromPlayer == Game.GetLocalPlayer() and text == g_mapPinStr then
		DeleteMapPinAtPlot(Game.GetLocalPlayer(), g_X, g_Y);
	end
end

function AddMapPin()
    -- Make sure the map pins are shown before adding.
    ShowMapPins();
    local plotX, plotY = UI.GetCursorPlotCoord();
    LuaEvents.MapPinPopup_RequestMapPin(plotX, plotY);
end

function ShowMapPins()
    if m_MapPinFlags == nil then
        m_MapPinFlags = ContextPtr:LookUpControl("/InGame/MapPinManager/MapPinFlags");
    end
    m_MapPinFlags:SetHide(false)
end

function DeleteMapPin()
    if m_MapPinFlags == nil then
        m_MapPinFlags = ContextPtr:LookUpControl("/InGame/MapPinManager/MapPinFlags");
    end
    if not m_MapPinFlags:IsHidden() then
        -- Only delete if the map pins are not hidden.
        local plotX, plotY = UI.GetCursorPlotCoord();
        DeleteMapPinAtPlot(Game.GetLocalPlayer(), plotX, plotY);
	else
		m_MapPinFlags:SetHide(false)
    end
end

function DeleteMapPinAtPlot(playerID, plotX, plotY)
    local playerCfg = PlayerConfigurations[playerID];
    local mapPin = playerCfg and playerCfg:GetMapPin(plotX, plotY);
    if mapPin then
        -- Update map pin yields.
        LuaEvents.DMT_MapPinRemoved(mapPin);
        -- Delete the pin.
        playerCfg:DeleteMapPin(mapPin:GetID());
        Network.BroadcastPlayerInfo();
        UI.PlaySound("Map_Pin_Remove");
    end
end

function HideMapPins()
	UI.PlaySound("Play_UI_Click");
	if m_MapPinListBtn == nil then
		m_MapPinListBtn = ContextPtr:LookUpControl("/InGame/MinimapPanel/MapPinListButton");
	end
	if not m_MapPinListBtn:IsSelected() then
		if m_MapPinFlags == nil then
			m_MapPinFlags = ContextPtr:LookUpControl("/InGame/MapPinManager/MapPinFlags");
		end
		-- Only toggle the map pin visibility if MapPinListButton is not selected. i.e. not trying to add new pins.
		m_MapPinFlags:SetHide(not m_MapPinFlags:IsHidden());
	end
end

function Initialize()
	Events.InputActionTriggered.Add(OnInputActionTriggered);
	Events.MultiplayerChat.Add( OnMultiplayerChat )
end
Initialize()