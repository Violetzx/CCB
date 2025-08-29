-- ======================================================================
-- 全局变量
-- ======================================================================
local g_Action_ADD = false												-- 加时指令标志
local g_Action_NONE = false												-- 无限时间标志
local g_Action_reduce = false											-- 减时指令标志
local g_MinTime = 30													-- 回合最小时间
local g_AllPlayerEndTurn = false										-- 所有玩家回合结束标志(排除世界议会投票影响)
local g_FirstTurnInitialize = true										-- 初始化时间标识

local m_lastTurnTickTime = 0											-- 15秒倒计时
----------------------------------------------------------- PID控制
local g_Pre_Time = GameConfiguration.GetValue("TURN_TIMER_TIME")		-- 下一回合开始时的初始时间
local g_Pre_Time_Base = GameConfiguration.GetValue("TURN_TIMER_TIME")	-- 用于检测是否额外编辑时间
local g_HalfPlayer_UseTime = nil			-- 玩家所需回合时间中位数
local g_Pre_HalfPlayer_UseTime = nil		-- 上回合的时间中位数
local g_Era_reduce = false					-- 过时代后的下一回合减少时间

local g_target = 18 		-- 玩家等待时间中位数 24秒		-- 前期少，后期通过TimeCorrection修正
local g_Integral = 0		-- 积分
local g_Last_Error = 0		-- 上一次的误差

local Kp = 0.5				-- PID参数		-- 比例环节，Kp较小，调整比较缓和
local Ki = 0.08								-- 积分环节，消除稳态误差，但是系统波动很大，在后期作用多一些，前期基本没作用
local Kd = 0.25								-- 微分环节，超前控制，对于滞后系统提高响应速度很有效

local Blanced_Max = 10			-- 最大增幅
local Blanced_Min = -10			-- 最大降幅

local Filter = 0.5				-- 一阶滤波器

local Attenuation = 0.98		-- 衰减比，抑制后期时间过长
local TimeCorrection = 0.05		-- 用于修正等待时间中位数 后期时间越长，玩家所需时间越发散

local TurnTimer = {														-- 计时器时间
	ElapsedTime = 0,
	MaxTurnTime = 0,
	TimeRemaining = 0,
}
local g_CoolDownTime = {}												-- 冷却时间(防止同一类型短时间多次触发)
-- ======================================================================
-- 重置变量
-- ======================================================================
function ResetVariables()
	g_Pre_Time = GameConfiguration.GetValue("TURN_TIMER_TIME")
	g_Pre_Time_Base = GameConfiguration.GetValue("TURN_TIMER_TIME")
	g_Action_ADD = false
	g_Action_reduce = false
	g_Action_NONE = false
	g_HalfPlayer_UseTime = nil
	g_AllPlayerEndTurn = false
	
	g_Era_reduce = false

	TurnTimer = {
		ElapsedTime = 0,
		MaxTurnTime = 0,
		TimeRemaining = 0,
	}
end
-- ======================================================================
-- 冷却时间
-- ======================================================================
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
-- ======================================================================
-- 聊天指令
-- ======================================================================
function OnMultiplayerChat( fromPlayer, toPlayer, text, eTargetType )
	if not GameConfiguration.GetValue("TOOLS_COMMAND") or Network.GetGameHostPlayerID() ~= Network.GetLocalPlayerID() or toPlayer ~= -1 then		-- 未启用设置，非房主玩家，不是公共聊天 则返回
		return
	end

	if (string.lower(text) == "p+" or string.lower(text) == "p++") then
		if not g_Action_ADD then
			if TurnTimer.MaxTurnTime > 0 and TurnTimer.TimeRemaining < 8 then			-- 如果在小于10秒时p++, 则改为加30秒
				GameConfiguration.SetValue("TURN_TIMER_TIME", GameConfiguration.GetValue("TURN_TIMER_TIME") + 24 )
				g_Pre_Time_Base = g_Pre_Time_Base + 24
			else
				GameConfiguration.SetValue("TURN_TIMER_TIME", GameConfiguration.GetValue("TURN_TIMER_TIME") + 20 )
				g_Pre_Time_Base = g_Pre_Time_Base + 20
			end
			Network.BroadcastGameConfig()
			g_Action_ADD = true
		end
		return
	end
	
	if (string.lower(text) == "p+++" or string.lower(text) == "p++++") then
		GameConfiguration.SetTurnTimerType("TURNTIMER_NONE")							-- 无回合时间
		Network.BroadcastGameConfig()
		g_Action_NONE = true
		return
	end

	if (string.lower(text) == "p-" or string.lower(text) == "p--") then
		g_Action_reduce = true
		return
	end
end
-- ======================================================================
-- 测试代码（可删除）
-- ======================================================================
local AdminPretime = GameConfiguration.GetValue("TURN_TIMER_TIME")
local g_Ht = 0
local g_Bt = 0
--function OnTurnBegin()
--	local AdminStr = AdminPretime.." ~ "..GameConfiguration.GetValue("TURN_TIMER_TIME").."    ( "..Locale.ToNumber(GameConfiguration.GetValue("TURN_TIMER_TIME") - AdminPretime, "+#####;-#####").." )    ".. Locale.ToNumber(g_Ht + g_target + g_Bt, "####.#;-####.#");
--	Controls.TimeRemaining:SetText(AdminStr)
--	AdminPretime = GameConfiguration.GetValue("TURN_TIMER_TIME")
--end

function GetHumanNum()
	local HumanNum = 0
	for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if PlayerConfigurations[playerID]:IsHuman() and PlayerConfigurations[playerID]:GetLeaderTypeName() ~= "LEADER_SPECTATOR" then
			HumanNum = HumanNum + 1
		end
	end
	return HumanNum
end
-- ======================================================================
-- 时间调整
-- ======================================================================
function OnTurnEnd_TimeBalance(CurrentTurn)
	if Network.GetGameHostPlayerID() ~= Network.GetLocalPlayerID() or not GameConfiguration.GetValue("TOOLS_COMMAND") then		-- 不是房主或者未开启
		ResetVariables()
		return
	end
	
	local BlancedTime = (g_Pre_Time_Base == GameConfiguration.GetValue("TURN_TIMER_TIME")) and g_Pre_Time or GameConfiguration.GetValue("TURN_TIMER_TIME")		-- 最终应用的时间,判断是否使用其他手段修改过

	local Manual_control = 0

	Manual_control = Manual_control + math.min(TimeCorrection * BlancedTime, 10)		-- 修正等待时间，后期时间越长，各个玩家所需时间差异增大		-- 限制幅度
	
	Manual_control = Manual_control + math.max(0, (8 - GetHumanNum()) * 1.5)			-- 修正人数极少时，玩家差异导致的时间过短，如11单挑

	if g_Action_ADD then
		Manual_control = Manual_control + 5
	end
	if g_Action_reduce then						-- 修正目标时间
		Manual_control = Manual_control - 15
	end
	
	g_Bt = Manual_control		-- 测试用
------------------------------------ PID 控制量获取 -----------------------------------------
	if g_HalfPlayer_UseTime then
		local Filter_HalfPlayer_UseTime = Filter * g_HalfPlayer_UseTime + (1 - Filter) * (g_Pre_HalfPlayer_UseTime or g_HalfPlayer_UseTime)		-- 一阶滤波器，给输入信号滤波
		g_Pre_HalfPlayer_UseTime = g_HalfPlayer_UseTime																-- 存储上次的半数玩家使用的时间
		local Error = (g_target + Filter_HalfPlayer_UseTime + Manual_control) - BlancedTime							-- 误差(目标减去滤波后的等待时间)
		local derivative = Error - g_Last_Error																		-- 微分
		g_Last_Error = Error																						-- 上次的误差暂存

		g_Integral = g_Integral + Error						-- 积分
		local iControl = Kp * Error + Ki * g_Integral + Kd * derivative		-- 控制量
------------------------------------- 防止积分饱和处理 ------------------------------------
		local Min_Contral_MinTime = math.max(Blanced_Min, g_MinTime - BlancedTime)						-- 考虑到最小时间，下限要修正
		if iControl >= Blanced_Max or iControl <= Min_Contral_MinTime or Error * iControl >= 0 then		-- 积分饱和情况：1、控制量大于幅值。2、控制量的符号和误差一致，在扩大误差。
			g_Integral = 0
		end

		if BlancedTime <= g_MinTime + g_target then				-- 在接近时间下限的时候，防止俯冲，只保留向上的量
			g_Integral = math.max(0, g_Integral)
		end
------------------------------------------------------------------
		BlancedTime = BlancedTime + math.min(math.max(Kp * Error + Ki * g_Integral + Kd * derivative, Blanced_Min), Blanced_Max)		-- 限制PID控制幅值【-15，10】
		
		BlancedTime = Attenuation * BlancedTime		-- 抑制后期时间过长  97%衰减
		

--		print("参数：", "比例：", Error, Kp * Error, "积分：", g_Integral, Ki * g_Integral, "微分：", derivative, Kd * derivative, "合计修正：", Kp * Error + Ki * g_Integral + Kd * derivative, "限幅后：", math.min(math.max(Kp * Error + Ki * g_Integral + Kd * derivative, Blanced_Min), Blanced_Max))
	end
------------------------------ 智能控制预测：过时代加时 --------------------------------------
	local pGameEras:table = Game.GetEras();
	local nextEraCountdown = pGameEras:GetNextEraCountdown();
	if nextEraCountdown == 1 then		-- 根据过时代回合加时		-- 前馈控制 增加时间
		BlancedTime = BlancedTime + 10
	elseif nextEraCountdown == 0 then
		BlancedTime = BlancedTime + 20
	elseif g_Era_reduce then
		BlancedTime = BlancedTime - 15
	end
------------------------------ 初始化时间 --------------------------------------
	if g_FirstTurnInitialize then
		g_FirstTurnInitialize = false
		
		local count = 0
		for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
			if PlayerConfigurations[playerID]:IsHuman() then
				count = count + 1
			end
		end

		if count > 1 and GameConfiguration.GetTurnTimerType() ~= 2133509568 then
			GameConfiguration.SetTurnTimerType("TURNTIMER_STANDARD")
			BlancedTime = g_MinTime
		end
	end
	if g_Action_NONE then
		GameConfiguration.SetTurnTimerType("TURNTIMER_STANDARD")
	end
---------------------------- 广播修改配置 ------------------------------------
	BlancedTime = math.ceil(math.max(BlancedTime, g_MinTime))
	GameConfiguration.SetValue("TURN_TIMER_TIME", BlancedTime)
	Network.BroadcastGameConfig()
------------------------------ 重置参数 --------------------------------------
	ResetVariables()

	if nextEraCountdown == 0 then			-- 前馈控制 减少时间
		g_Era_reduce = true
	end
end
-- ======================================================================
-- 宣战加时
-- ======================================================================
function OnDiplomacyDeclareWar( firstPlayerID, secondPlayerID )
	if Network.GetGameHostPlayerID() ~= Network.GetLocalPlayerID() or not GameConfiguration.GetValue("TOOLS_COMMAND") then		--  不是主机或者未开启
		return
	end

	if Players[firstPlayerID]:IsMajor() and Players[secondPlayerID]:IsMajor() then								-- 宣战玩家是主要玩家
		if Cooldown("MajorWar", 3) then
			GameConfiguration.SetValue("TURN_TIMER_TIME", GameConfiguration.GetValue("TURN_TIMER_TIME") + 20 )
			Network.BroadcastGameConfig()
			g_Pre_Time = g_Pre_Time + 20
			g_Pre_Time_Base = g_Pre_Time_Base + 20
		end
		return
	end

	if TurnTimer.MaxTurnTime > 0 and TurnTimer.TimeRemaining < 10 then										-- 防止卡秒顶城邦，加时
		if Cooldown("OtherWar", 3) then
			GameConfiguration.SetValue("TURN_TIMER_TIME", GameConfiguration.GetValue("TURN_TIMER_TIME") + 8 )
			Network.BroadcastGameConfig()
			g_Pre_Time_Base = g_Pre_Time_Base + 8
		end
	end
end
-- ======================================================================
-- 掉线加时
-- ======================================================================
function OnMultiplayerPrePlayerDisconnected(playerID)		-- 玩家掉线后加30秒
	if Network.GetGameHostPlayerID() ~= Network.GetLocalPlayerID() or playerID == Network.GetLocalPlayerID() or not GameConfiguration.GetValue("TOOLS_COMMAND") then		--仅允许主机进行修改
		return
	end

	if TurnTimer.MaxTurnTime > 0 and TurnTimer.TimeRemaining < 30 then
		GameConfiguration.SetValue("TURN_TIMER_TIME", GameConfiguration.GetValue("TURN_TIMER_TIME") + 30)
		Network.BroadcastGameConfig()
		g_Action_ADD = true
		g_Pre_Time_Base = g_Pre_Time_Base + 30
	end
end
-- ======================================================================
-- 回合时钟
-- ======================================================================
function OnTurnTimerUpdated(elapsedTime, maxTurnTime)				-- 记录剩余时间
	local timeRemaining = maxTurnTime - elapsedTime;

	TurnTimer.ElapsedTime = elapsedTime				-- 本回合花费的时间是我们需要的
	TurnTimer.MaxTurnTime = maxTurnTime
	TurnTimer.TimeRemaining = timeRemaining
end
-- ======================================================================
-- 半数玩家结束回合时间
-- ======================================================================
function OnPlayerTurnEnd(ePlayer)
	ePlayer = ePlayer or Network.GetLocalPlayerID()
	if not Players[ePlayer]:IsMajor() or not PlayerConfigurations[ePlayer]:IsHuman() or PlayerConfigurations[ePlayer]:GetLeaderTypeName() == "LEADER_SPECTATOR" then 		-- 不是主要文明，或人类玩家，或是观察者
		return
	end

	local Count = 0						-- 真人玩家数量
	local EndTurnCount = 0				-- 结束回合的玩家数量
	for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if PlayerConfigurations[playerID]:IsHuman() and PlayerConfigurations[playerID]:GetLeaderTypeName() ~= "LEADER_SPECTATOR" then
			Count = Count + 1
			if not Players[playerID]:IsTurnActive() then		-- 如果有玩家在结束回合状态
				EndTurnCount = EndTurnCount + 1
			end
		end
	end

	if not g_HalfPlayer_UseTime and TurnTimer.MaxTurnTime > 0 and EndTurnCount/Count >= 0.5 then
		g_HalfPlayer_UseTime = TurnTimer.ElapsedTime;		-- 获取时间
		g_Ht = g_HalfPlayer_UseTime										-- 测试用的
	end
	
	if EndTurnCount == Count then
		g_AllPlayerEndTurn = true										-- 用于避免投票时错误重置时间
	end
end
-- ======================================================================
-- 所有玩家回合开始时重置
-- ======================================================================
function OnPlayerTurnBegin(ePlayer)
	ePlayer = ePlayer or Network.GetLocalPlayerID()
	
	if g_AllPlayerEndTurn then		-- 投票阶段
		if Network.GetGameHostPlayerID() == Network.GetLocalPlayerID() and GameConfiguration.GetValue("TOOLS_COMMAND") then
			local AllPlayerTurnBegin = true
			local HumanNum = 0		-- 排除单人测试的影响
			for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
				if PlayerConfigurations[playerID]:IsHuman() and PlayerConfigurations[playerID]:GetLeaderTypeName() ~= "LEADER_SPECTATOR" then
					HumanNum = HumanNum + 1
					if not Players[playerID]:IsTurnActive() then
						AllPlayerTurnBegin = false
					end
				end
			end
			if AllPlayerTurnBegin and Cooldown("Vote", 3) and HumanNum > 1 then
				GameConfiguration.SetValue("TURN_TIMER_TIME", 120)		-- 投票阶段
				Network.BroadcastGameConfig()
				g_Pre_Time_Base = 120
			end
		end
		return
	end

	if not Players[ePlayer]:IsMajor() or not PlayerConfigurations[ePlayer]:IsHuman() or PlayerConfigurations[ePlayer]:GetLeaderTypeName() == "LEADER_SPECTATOR" then 		-- 不是主要文明，或人类玩家，或是观察者
		return
	end

	local AllPlayerIsTurnActive = true		-- 如果中途有玩家又重新开始回合，此时所有玩家都在进行回合，则重置时间记录

	for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if PlayerConfigurations[playerID]:IsHuman() and PlayerConfigurations[playerID]:GetLeaderTypeName() ~= "LEADER_SPECTATOR" then
			if not Players[playerID]:IsTurnActive() then		-- 如果有玩家结束回合
				AllPlayerIsTurnActive = false
			end
		end
	end

	if AllPlayerIsTurnActive then
		g_HalfPlayer_UseTime = nil		-- 重新记录时间
	end
end

-- ======================================================================
-- 15秒倒计时
-- ======================================================================
function SoftRound(x)
	if(x >= 0) then
		return math.floor(x+0.5);
	else
		return math.ceil(x-0.5);
	end
end

function OnTurnTimerUpdated_15(elapsedTime :number, maxTurnTime :number)
	if(maxTurnTime > 0 and GameConfiguration.GetValue("TOOLS_15_TIME")) then

		local timeRemaining : number = maxTurnTime - elapsedTime;

		if(timeRemaining > 0) then

			local roundedTime = SoftRound(timeRemaining); 
			if( roundedTime <= 15 and roundedTime > 7) then
				if(roundedTime > m_lastTurnTickTime
					or roundedTime <= (m_lastTurnTickTime-1)) then
					m_lastTurnTickTime = roundedTime;
					UI.PlaySound("Play_MP_Game_Launch_Timer_Beep");
				end
			end
		end
	end
end
-- ======================================================================
function LateInitialize()
	Events.TurnTimerUpdated.Add( OnTurnTimerUpdated );
	
	Events.TurnTimerUpdated.Add( OnTurnTimerUpdated_15 );		-- 15秒倒计时
	
--	local ctr = ContextPtr:LookUpControl("/InGame/TopPanel")
--	Controls.TimeRemaining:ChangeParent(ctr)
end

function Initialize()
	Events.LoadScreenClose.Add( LateInitialize )

	Events.MultiplayerChat.Add( OnMultiplayerChat )	
	Events.DiplomacyDeclareWar.Add( OnDiplomacyDeclareWar )
	Events.MultiplayerPrePlayerDisconnected.Add( OnMultiplayerPrePlayerDisconnected )

	Events.TurnEnd.Add(	OnTurnEnd_TimeBalance );	
	
	Events.LocalPlayerTurnEnd.Add( OnPlayerTurnEnd )
	Events.RemotePlayerTurnEnd.Add( OnPlayerTurnEnd )
	Events.LocalPlayerTurnBegin.Add( OnPlayerTurnBegin )
	Events.RemotePlayerTurnBegin.Add( OnPlayerTurnBegin )
	
--	Events.TurnBegin.Add( OnTurnBegin );		-- 测试用
end
Initialize()