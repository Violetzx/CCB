local Cfg_TPT_BSM_compatible_cache = GameConfiguration.GetValue("TPT_BSM_compatible")		-- 游戏初始数值

local Spectator_Num = 0

local PlayerFirstTurnBegin = {}
-- ==============================================
-- 第一步，观察者暂停游戏
-- ==============================================
function OnTurnBegin()
	Events.TurnBegin.Remove(OnTurnBegin)		-- 只触发一次
	TogglePause(true)													-- 观察者暂停游戏
	if Network.GetGameHostPlayerID() == Network.GetLocalPlayerID() then
		Network.SendChat("等待所有玩家进入游戏，请房主不要取消暂停", -2, -1)			-- 房主发送信息
	end
end
-- ==============================================
-- 玩家发送开始标志		-- CC\NetHelper 已启用
-- ==============================================
--function OnLocalPlayerTurnBegin()				-- 开启兼容模式时，并且是第一次
--	Events.LocalPlayerTurnBegin.Remove( OnLocalPlayerTurnBegin )		-- 只触发一次
--	Network.SendChat("[ENDCOLOR][Icon_CheckmarkBlue]",-2,-1)		-- 发送标记
--end
-- ==============================================
-- 第二步，接收玩家开始标志
-- ==============================================
function OnMultiplayerChat( fromPlayer, toPlayer, text, eTargetType )
	if toPlayer ~= -1 then		-- 仅公共聊天
		return
	end
	if text == "[ENDCOLOR][Icon_CheckmarkBlue]" then
		PlayerFirstTurnBegin[fromPlayer] = true
		if CheckAllTrue(PlayerFirstTurnBegin) then		-- 所有玩家到齐了？开始下一步
			PlayerFirstTurnBegin = {}		-- 重置标记
			Host_ChangeGameConfig()
		end
		return
	end
end
-- ==============================================
-- 检测所有玩家到齐
-- ==============================================
function CheckAllTrue(kDate)
	for _, v in pairs(kDate) do
		if not v then
			return false
		end
	end
	return true
end
-- ==============================================
-- 开始触发重载
-- ==============================================
function Host_ChangeGameConfig()
	Network.SendChat("所有玩家进入游戏完毕，观察者开始二次加载，请房主不要取消暂停",-2,-1)
	GameConfiguration.SetValue("TPT_BSM_compatible", false)
	GameConfiguration.SetValue("TPT_BSM_Reload", true)
	Network.BroadcastGameConfig()
end
-- ==============================================
-- 玩家接收到重载信号
-- ==============================================
function OnGameConfigChanged()
	if Cfg_TPT_BSM_compatible_cache and not GameConfiguration.GetValue("TPT_BSM_compatible") then		-- 游戏刚开始时启用了，但是在中途关闭，作为一个重新载入的信号
		if PlayerConfigurations[Game.GetLocalPlayer()]:GetLeaderTypeName() == "LEADER_SPECTATOR" then		-- 观察者玩家重载
			Events.GameConfigChanged.Remove( OnGameConfigChanged )
			Network.RequestSnapshot()
		end
	end
end
-- ==============================================
-- 玩家重载完成，发送重载完成标志
-- ==============================================
function OnLoadScreenClose()
	Events.LoadScreenClose.Remove( OnLoadScreenClose )
	if GameConfiguration.GetValue("TPT_BSM_Reload") then
		TogglePause(false)
		Network.SendChat("观察者载入完成", -2, -1)
	end
end
-- ==============================================
-- 切换暂停
-- ==============================================
function TogglePause(WantsPause)
	local localPlayerID = Network.GetLocalPlayerID();
	local localPlayerConfig = PlayerConfigurations[localPlayerID];
	localPlayerConfig:SetWantsPause(WantsPause);
	Network.BroadcastPlayerInfo();
end
-- ==============================================
-- 取消订阅事件
-- ==============================================
function Unsubscribe()
	Events.TurnBegin.Remove( OnTurnBegin );
--	Events.LocalPlayerTurnBegin.Remove( OnLocalPlayerTurnBegin )
	Events.LoadScreenClose.Remove( OnLoadScreenClose )
	Events.GameConfigChanged.Remove( OnGameConfigChanged );
	Events.MultiplayerChat.Remove( OnMultiplayerChat )	
	Events.TurnEnd.Remove( Unsubscribe );
	if Network.GetGameHostPlayerID() == Network.GetLocalPlayerID() then
		if GameConfiguration.GetValue("TPT_BSM_Reload") then
			GameConfiguration.SetValue("TPT_BSM_compatible", true)
		end
		GameConfiguration.SetValue("TPT_BSM_Reload", false)
		Network.BroadcastGameConfig()
	end
end

function Initialize()
	if not GameConfiguration.IsAnyMultiplayer() then
		return
	end
	for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do		-- 初始化标记
		if Players[playerID]:IsHuman() then
			PlayerFirstTurnBegin[playerID] = false
			if PlayerConfigurations[playerID]:GetLeaderTypeName() == "LEADER_SPECTATOR" then		-- 二次重载只检测观察者玩家
--				PlayerLoadScreenClose[playerID] = false
				Spectator_Num = Spectator_Num + 1
			end
		end
	end
	if Spectator_Num > 0 then
		Events.TurnEnd.Add( Unsubscribe );				-- 取消订阅事件
		if PlayerConfigurations[Game.GetLocalPlayer()]:GetLeaderTypeName() == "LEADER_SPECTATOR" then
			Events.LoadScreenClose.Add( OnLoadScreenClose )						-- 观察者需要取消暂停
		end
		if GameConfiguration.GetValue("TPT_BSM_compatible") then		-- 启用时才初始化
			if Network.GetGameHostPlayerID() == Network.GetLocalPlayerID() then		-- 这个仅需主机								
				Events.MultiplayerChat.Add( OnMultiplayerChat )
			end
			if PlayerConfigurations[Game.GetLocalPlayer()]:GetLeaderTypeName() == "LEADER_SPECTATOR" then		-- 仅需要观察者重载
				Events.TurnBegin.Add( OnTurnBegin );				-- 观察者暂停，并且房主发出聊天提示
				Events.GameConfigChanged.Add( OnGameConfigChanged );		-- 观察者重载
			end
--			Events.LocalPlayerTurnBegin.Add( OnLocalPlayerTurnBegin )			-- 所有玩家发送准备就绪标记
		end
	end
end
Initialize()

--[[
运行逻辑v.7：
	房主（观察者）进入游戏后，回合开始时，立即暂停游戏
	其他玩家进入游戏，且本地玩家回合开始后发送聊天信息"[ENDCOLOR][Icon_CheckmarkBlue]"作为进入游戏的信号
	全体玩家到齐后，房主广播配置
	所有观察者立即重载？
	重载完成后，发送重载完成信号"[ENDCOLOR][Icon_Checkmark]"作为完成标志
	所有玩家重载完成后，主机自动结束暂停，开始游戏	
]]