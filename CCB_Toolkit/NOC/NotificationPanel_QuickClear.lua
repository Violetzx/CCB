NPQC_BASE_OnDefaultAddNotification = OnDefaultAddNotification;
NPQC_BASE_ReleaseNotificationEntry = ReleaseNotificationEntry;

local NPQC_notifications = {};
local NPQC_notifications_index = {};

local NPQC_ClearButton = nil;

local HideClearButton = false

function NPQC_CreateClearButton()
	local playerID = Game.GetLocalPlayer();
	if playerID < 0 then return; end

	NPQC_ClearButton = m_genericItemIM:GetInstance();
	if NPQC_ClearButton == nil then return; end

	toolTip = Locale.Lookup("LOC_HUD_MAP_SEARCH_CLEAR_SEARCH");

	NPQC_ClearButton.Icon:SetTexture('QueueTrash');
	NPQC_ClearButton.Icon:SetToolTipString(toolTip);

	NPQC_ClearButton.CountImage:SetHide(true);
	NPQC_ClearButton.TitleCount:SetHide(true);
	NPQC_ClearButton.LeftArrow:SetHide(true);
	NPQC_ClearButton.RightArrow:SetHide(true);
	NPQC_ClearButton.PagePipStack:SetHide(true);

	NPQC_ClearButton.MouseInArea:RegisterCallback(Mouse.eLClick, function() NPQC_ClearNotifications(playerID); end);
	NPQC_ClearButton.MouseInArea:RegisterCallback(Mouse.eRClick, function() UI.PlaySound("Play_UI_Click"); NPQC_ClearNotifications(playerID); end);
	NPQC_ClearButton.MouseOutArea:RegisterCallback(Mouse.eLClick, function() NPQC_ClearNotifications(playerID); end);
	NPQC_ClearButton.MouseOutArea:RegisterCallback(Mouse.eRClick, function() UI.PlaySound("Play_UI_Click"); NPQC_ClearNotifications(playerID); end);
end


function OnDefaultAddNotification(pNotification)
	local playerID	= pNotification:GetPlayerID();
	local notificationID = pNotification:GetID();

	if NPQC_ClearButton == nil then
		NPQC_CreateClearButton();
	end

	NPQC_BASE_OnDefaultAddNotification(pNotification);
	if #m_genericItemIM.m_AllocatedInstances > 1 then
		if not HideClearButton then
			NPQC_ClearButton.Top:SetHide(false);
		end
	end
	if playerID == nil or notificationID == nil then return; end

	NPQC_notifications[playerID] = NPQC_notifications[playerID] or {};
	NPQC_notifications_index[playerID] = NPQC_notifications_index[playerID] or 1;
	NPQC_notifications[playerID][NPQC_notifications_index[playerID]] = notificationID;

	NPQC_notifications_index[playerID] = NPQC_notifications_index[playerID] + 1;
	-- avoid the table is too large 
	if NPQC_notifications_index[playerID] > 100 then
		NPQC_notifications_index[playerID] = NPQC_notifications_index[playerID] - 100;
	end
end


function ReleaseNotificationEntry(playerID, notificationID, isShuttingDown)
	NPQC_BASE_ReleaseNotificationEntry(playerID, notificationID, isShuttingDown);

	if NPQC_ClearButton ~= nil and #m_genericItemIM.m_AllocatedInstances <= 1 then
		NPQC_ClearButton.Top:SetHide(true);
	end
end


function NPQC_ClearNotifications(playerID)
	NPQC_notifications_index[playerID] = 1;

	for _, id in ipairs(NPQC_notifications[playerID]) do
		local pNotification = NotificationManager.Find( playerID, id );
		if (pNotification ~= nil) then
			if (pNotification:CanUserDismiss()) then
				NotificationManager.Dismiss( pNotification:GetPlayerID(), pNotification:GetID() );
			end

			NPQC_notifications[playerID][NPQC_notifications_index[playerID]] = id;
			NPQC_notifications_index[playerID] = NPQC_notifications_index[playerID] + 1;
		end
	end

	NPQC_notifications[playerID][NPQC_notifications_index[playerID]] = nil;

	NPQC_ClearButton.Top:SetHide(true);
end	

function OnTPT_Settings_Toggle(ParameterId, Value)
	if ParameterId == "NotificationPanel_QuickClear" then
		HideClearButton = Value
		NPQC_ClearButton.Top:SetHide(Value);
		return
	end
end
LuaEvents.TPT_Settings_Toggle.Add(OnTPT_Settings_Toggle)