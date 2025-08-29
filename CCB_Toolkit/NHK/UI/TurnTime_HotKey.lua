-- ===========================================================================
--  MEMBERS
-- ===========================================================================
local m_TurnTimeAddActionId = Input.GetActionId("HotKey_TPT_TurnTimeAdd");
local m_TurnTimeReduceActionId = Input.GetActionId("HotKey_TPT_TurnTimeReduce");
--local m_OnlinePauseActionId = Input.GetActionId("OnlinePause");
local m_ForcedTurnEndActionId = Input.GetActionId("HotKey_TPT_ForcedTurnEnd");

local CanForcedTurnEnd = false
local FirstBegin = false
local NeedUnReadyTurn = false
local IsMultiplayer = GameConfiguration.IsAnyMultiplayer();

local g_Tick = 0
local g_ForcedEndTick = -1000
function OnTick()
	g_Tick = g_Tick + 1
end
-- ===========================================================================
function OnInputActionTriggered(actionId)
    if actionId == m_TurnTimeAddActionId then
		if Network.GetLocalPlayerID() == Network.GetGameHostPlayerID() then
			GameConfiguration.SetValue("TURN_TIMER_TIME", GameConfiguration.GetValue("TURN_TIMER_TIME") + 20 )
			Network.BroadcastGameConfig()
			UI.PlaySound("Play_MP_Game_Launch_Timer_Beep")
--			print("+++++++++++++25")
		elseif GameConfiguration.GetValue("TOOLS_COMMAND") == true then
			Network.SendChat("p++",-2,-1)
			UI.PlaySound("Play_MP_Game_Launch_Timer_Beep")
		end
		return
    end
    if actionId == m_TurnTimeReduceActionId then
		if Network.GetLocalPlayerID() == Network.GetGameHostPlayerID() then
			if GameConfiguration.GetValue("TURN_TIMER_TIME") > 40 then
				GameConfiguration.SetValue("TURN_TIMER_TIME", GameConfiguration.GetValue("TURN_TIMER_TIME") - 10 )
				Network.BroadcastGameConfig()
				UI.PlaySound("Play_MP_Game_Launch_Timer_Beep")
--				print("-------------10")
			else
				GameConfiguration.SetValue("TURN_TIMER_TIME", 40 )
				Network.BroadcastGameConfig()
				UI.PlaySound("Play_MP_Game_Waiting_For_Player");
--				print("变成40")			
			end
		elseif GameConfiguration.GetValue("TOOLS_COMMAND") == true then
			Network.SendChat("p--",-2,-1)
			UI.PlaySound("Play_MP_Game_Launch_Timer_Beep")
		end
		return
    end
    --[[
    if actionId == m_OnlinePauseActionId then		-- 当游戏暂停时，自动加时
		if GameConfiguration.GetValue("TOOLS_COMMAND") == true then
			local localPlayerID = Network.GetLocalPlayerID();
			local localPlayerConfig = PlayerConfigurations[localPlayerID];
			local newPause = localPlayerConfig:GetWantsPause();
			if newPause then
				if Network.GetLocalPlayerID() == Network.GetGameHostPlayerID() then
					GameConfiguration.SetValue("TURN_TIMER_TIME", GameConfiguration.GetValue("TURN_TIMER_TIME") + 25 )
					Network.BroadcastGameConfig()
					UI.PlaySound("Play_MP_Game_Launch_Timer_Beep")
					print("+++++++++++++25")
				else
					Network.SendChat("p++",-2,-1)
					UI.PlaySound("Play_MP_Game_Launch_Timer_Beep")
				end
			end
		end
		return
    end
    ]]
    if actionId == m_ForcedTurnEndActionId then
		if IsMultiplayer then
			CanForcedTurnEnd = not CanForcedTurnEnd
			UI.PlaySound("Play_UI_Click");
			if CanForcedTurnEnd then
				OnShow()
				UI.RequestAction(ActionTypes.ACTION_ENDTURN, { REASON = "UserForced" } );	-- 强制结束回合
				g_ForcedEndTick = g_Tick
			else
				Close()
				UI.RequestAction(ActionTypes.ACTION_UNREADYTURN)		-- 取消结束回合
				Events.GameCoreEventPublishComplete.Remove( OnUnReadyTurn )
				Events.GameCoreEventPublishComplete.Remove( OnForcedEnd )
			end
		end
		return
    end
end

function OnForcedEndTurn()
	if IsMultiplayer then
		CanForcedTurnEnd = not CanForcedTurnEnd
		UI.PlaySound("Play_UI_Click");
		if CanForcedTurnEnd then
			OnShow()
			UI.RequestAction(ActionTypes.ACTION_ENDTURN, { REASON = "UserForced" } );	-- 强制结束回合
			g_ForcedEndTick = g_Tick
			print("开始强制结束回合")
		else
			Close()
			UI.RequestAction(ActionTypes.ACTION_UNREADYTURN)		-- 取消结束回合
			Events.GameCoreEventPublishComplete.Remove( OnUnReadyTurn )
			Events.GameCoreEventPublishComplete.Remove( OnForcedEnd )
		end
	end
end
-- ===========================================================================
function OnTurnEnd()
	Events.GameCoreEventPublishComplete.Remove( OnUnReadyTurn )
	Events.GameCoreEventPublishComplete.Remove( OnForcedEnd )
end
--[[
function OnTurnBegin()		-- 如果是首次开始回合，开始高频率强制结束回合操作
	NeedUnReadyTurn = false
	if CanForcedTurnEnd then
		Events.GameCoreEventPublishComplete.Add( OnForcedEnd )
	end
	CanForcedTurnEnd = false
end

function OnLocalPlayerTurnBegin()
	Events.GameCoreEventPublishComplete.Remove( OnUnReadyTurn )		-- 移除高频开始回合
	Close()
	NeedUnReadyTurn = false
end

function OnLocalPlayerTurnEnd()			-- 成功结束回合，移除高频强制结束回合
	Events.GameCoreEventPublishComplete.Remove( OnForcedEnd )
	if NeedUnReadyTurn == true then		-- 需要开始回合？
		Events.GameCoreEventPublishComplete.Add( OnUnReadyTurn )		-- 高频开始回合
	end
	NeedUnReadyTurn = false
end
]]
function OnLocalPlayerTurnBegin()
	print("本地玩家回合开始")

	Close()		-- 关闭UI文字
	Events.GameCoreEventPublishComplete.Remove( OnUnReadyTurn )		-- 取消高频开始回合操作
	NeedUnReadyTurn = false

	if g_ForcedEndTick + 5 > g_Tick then		-- 系统自定取消结束回合了？再次尝试
		print("再次尝试结束回合")
		g_ForcedEndTick = -1000
		NeedUnReadyTurn = true
		UI.RequestAction(ActionTypes.ACTION_ENDTURN, { REASON = "UserForced" } );
	end

	if CanForcedTurnEnd then		-- 回合开始时开始高频强制结束回合
		OnForcedEnd()
		Events.GameCoreEventPublishComplete.Add( OnForcedEnd )
	end
	CanForcedTurnEnd = false
end

function OnLocalPlayerTurnEnd()
	print("本地玩家回合结束")
	Events.GameCoreEventPublishComplete.Remove( OnForcedEnd )
	if NeedUnReadyTurn == true then		-- 需要开始回合？
		Events.GameCoreEventPublishComplete.Add( OnUnReadyTurn )		-- 高频开始回合
	end
	NeedUnReadyTurn = false
end

function OnForcedEnd()		-- 强制结束回合
	print("强制结束回合")
	UI.RequestAction(ActionTypes.ACTION_ENDTURN, { REASON = "UserForced" } );	-- 强制结束回合
	NeedUnReadyTurn = true		-- 玩家回合结束时，会要求取消结束状态
	g_ForcedEndTick = g_Tick
end

function OnUnReadyTurn()
	print("取消结束回合")
	UI.RequestAction(ActionTypes.ACTION_UNREADYTURN)
end
-- ===========================================================================
function OnShow()
	Controls.AlphaIn:SetHide(false);
	if not ContextPtr:IsHidden() then
		EffectsManager:PauseAllEffects();
		Controls.AlphaIn:SetToBeginning();
		Controls.AlphaIn:Play();
	end
end

function Close()
	Controls.AlphaIn:SetHide(true);		-- 隐藏动画
end

function OnGameConfigChanged()
	Controls.AddTimeButton:SetHide(not GameConfiguration.GetValue("TOOLS_COMMAND"));
	Controls.ReduceTimeButton:SetHide(not GameConfiguration.GetValue("TOOLS_COMMAND"));
end
-- ===========================================================================
function Initialize()
	local ctr1 = ContextPtr:LookUpControl("/InGame/WorldInput")
	Controls.AlphaIn:ChangeParent(ctr1)
	
	local ctr2 = ContextPtr:LookUpControl("/InGame/WorldTracker/ChatPanelContainer")
	Controls.AddTimeButton:ChangeParent(ctr2)
	Controls.ReduceTimeButton:ChangeParent(ctr2)
	
	Controls.AddTimeButton:RegisterCallback( Mouse.eLClick, function()
		Network.SendChat("p++",-2,-1);
		UI.PlaySound("Play_MP_Game_Launch_Timer_Beep");
	end);

	Controls.ReduceTimeButton:RegisterCallback( Mouse.eLClick, function()
		Network.SendChat("p--",-2,-1);
		UI.PlaySound("Play_MP_Game_Launch_Timer_Beep");
	end);
	
	Controls.AddTimeButton:SetHide(not GameConfiguration.GetValue("TOOLS_COMMAND"));
	Controls.ReduceTimeButton:SetHide(not GameConfiguration.GetValue("TOOLS_COMMAND"));

    Events.InputActionTriggered.Add(OnInputActionTriggered)
--    Events.TurnBegin.Add( OnTurnBegin )
    Events.LocalPlayerTurnBegin.Add( OnLocalPlayerTurnBegin );    
	Events.LocalPlayerTurnEnd.Add( OnLocalPlayerTurnEnd );
    Events.TurnEnd.Add( OnTurnEnd );
	Events.GameConfigChanged.Add(OnGameConfigChanged);    
    Events.GameCoreEventPublishComplete.Add(OnTick)
    
    LuaEvents.ForcedEndTurn.Add(OnForcedEndTurn)
end
Events.LoadScreenClose.Add(Initialize)