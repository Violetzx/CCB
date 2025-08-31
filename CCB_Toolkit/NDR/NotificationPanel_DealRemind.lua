TPT_BASE_OnDefaultAddNotification = OnDefaultAddNotification

local DealRemindSound = true
local g_CoolDownTime = {}
local PassText = {
	"LOC_DIPLOMACY_MAKE_DEAL_NOTIFICATION_MESSAGE_PROPOSED",		-- 提出交易
	"LOC_DIPLOMACY_MAKE_DEAL_NOTIFICATION_MESSAGE_INITIAL",			-- 交易请求
	"LOC_DIPLOMACY_SEND_DELEGATION_NOTIFICATION_MESSAGE_INITIAL",	-- 外交团
	"LOC_DIPLOMACY_EMBASSY_NOTIFICATION_MESSAGE_INITIAL",			-- 大使馆请求
	"LOC_DIPLOMACY_MAKE_ALLIANCE_NOTIFICATION_MESSAGE_INITIAL",		-- 联盟请求
	"LOC_DIPLOMACY_DECLARE_FRIEND_NOTIFICATION_MESSAGE_INITIAL",	-- 友好宣言请求
	"LOC_DIPLOMACY_MAKE_PEACE_NOTIFICATION_MESSAGE_INITIAL",		-- 和平请求
	"LOC_DIPLOMACY_OPEN_BORDERS_NOTIFICATION_MESSAGE_INITIAL",		-- 开放边界请求
	"LOC_DIPLOMACY_MAKE_DEAL_NOTIFICATION_MESSAGE_ADJUSTED",		-- 调整交易
}

function CheckPassText(Str)
	for _, v in pairs(PassText) do
		if Str == Locale.Lookup(v) then
			return true
		end
	end
	return false
end

function Cooldown(parameterID, delay)
	if not g_CoolDownTime[parameterID] then
		g_CoolDownTime[parameterID] = 0
	end
	
	if os.time() < g_CoolDownTime[parameterID] + delay then
		return false
	else
		g_CoolDownTime[parameterID] = os.time()
		return true
	end
end

function OnDefaultAddNotification( pNotification:table )
	TPT_BASE_OnDefaultAddNotification(pNotification)

	local typeName = pNotification:GetTypeName();
	if typeName == "NOTIFICATION_DIPLOMACY_SESSION" then	
		local playerID				= pNotification:GetPlayerID();
		local notificationID		= pNotification:GetID();
		local notificationEntry		= GetNotificationEntry( playerID, notificationID );
		OnMouseEnterNotification( notificationEntry.m_Instance )

		local messageName = Locale.Lookup( pNotification:GetMessage() );
		if DealRemindSound and CheckPassText(messageName) then
			if Cooldown("RemindSound", 3) then
				UI.PlaySound("Play_MP_Game_Waiting_For_Player");
			end
		end
	end
end

function OnTPT_Settings_Toggle(ParameterId, Value)
	if ParameterId == "NotificationPanel_DealRemind" then
		DealRemindSound = Value
		return
	end
end
LuaEvents.TPT_Settings_Toggle.Add(OnTPT_Settings_Toggle)