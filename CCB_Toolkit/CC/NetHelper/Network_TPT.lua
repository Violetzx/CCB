--[[
 _____                      ______     ______    _____           _     
|_   _|__  __ _ _ __ ___   |  _ \ \   / /  _ \  |_   _|__   ___ | |___ 
  | |/ _ \/ _` | '_ ` _ \  | |_) \ \ / /| |_) |   | |/ _ \ / _ \| / __|
  | |  __/ (_| | | | | | | |  __/ \ V / |  __/    | | (_) | (_) | \__ \
  |_|\___|\__,_|_| |_| |_| |_|     \_/  |_|       |_|\___/ \___/|_|___/
  2023.06.10	号码菌
  ]]
-- ==============================================
-- 全局变量
-- ==============================================
local TPT_Game_Start_Cache = GameConfiguration.GetValue("TPT_Game_Start")
local PlayerFirstTurnBegin = {}
local Host_Just_ReStart = false

-- https://github.com/fab13n/metalua/blob/no-dll/src/lib/serialize.lua

local no_identity = { number=1, boolean=1, string=1, ['nil']=1 }

function serialize (x)
   
   local gensym_max =  0  -- index of the gensym() symbol generator
   local seen_once  = { } -- element->true set of elements seen exactly once in the table
   local multiple   = { } -- element->varname set of elements seen more than once
   local nested     = { } -- transient, set of elements currently being traversed
   local nest_points = { }
   local nest_patches = { }
   
   local function gensym()
      gensym_max = gensym_max + 1 ;  return gensym_max
   end

   local function mark_nest_point (parent, k, v)
      local nk, nv = nested[k], nested[v]
      assert (not nk or seen_once[k] or multiple[k])
      assert (not nv or seen_once[v] or multiple[v])
      local mode = (nk and nv and "kv") or (nk and "k") or ("v")
      local parent_np = nest_points [parent]
      local pair = { k, v }
      if not parent_np then parent_np = { }; nest_points [parent] = parent_np end
      parent_np [k], parent_np [v] = nk, nv
      table.insert (nest_patches, { parent, k, v })
      seen_once [parent], multiple [parent]  = nil, true
   end

   local function mark_multiple_occurences (x)
      if no_identity [type(x)] then return end
      if     seen_once [x]     then seen_once [x], multiple [x] = nil, true
      elseif multiple  [x]     then -- pass
      else   seen_once [x] = true end
      
      if type (x) == 'table' then
         nested [x] = true
         for k, v in pairs (x) do
            if nested[k] or nested[v] then mark_nest_point (x, k, v) else
               mark_multiple_occurences (k)
               mark_multiple_occurences (v)
            end
         end
         nested [x] = nil
      end
   end

   local dumped    = { } -- multiply occuring values already dumped in localdefs
   local localdefs = { } -- already dumped local definitions as source code lines

   local dump_val, dump_or_ref_val
         
   function dump_or_ref_val (x)
      if nested[x] then return 'false' end -- placeholder for recursive reference
      if not multiple[x] then return dump_val (x) end
      local var = dumped [x]
      if var then return "_[" .. var .. "]" end -- already referenced
      local val = dump_val(x) -- first occurence, create and register reference
      var = gensym()
      table.insert(localdefs, "_["..var.."]="..val)
      dumped [x] = var
      return "_[" .. var .. "]"
   end

   function dump_val(x)
      local  t = type(x)
      if     x==nil        then return 'nil'
      elseif t=="number"   then return tostring(x)
      elseif t=="string"   then return string.format("%q", x)
      elseif t=="boolean"  then return x and "true" or "false"
      elseif t=="function" then
         return string.format ("loadstring(%q,'@serialized')", string.dump (x))
      elseif t=="table" then

         local acc        = { }
         local idx_dumped = { }
         local np         = nest_points [x]
         for i, v in ipairs(x) do
            if np and np[v] then
               table.insert (acc, 'false') -- placeholder
            else
               table.insert (acc, dump_or_ref_val(v))
            end
            idx_dumped[i] = true
         end
         for k, v in pairs(x) do
            if np and (np[k] or np[v]) then
               --check_multiple(k); check_multiple(v) -- force dumps in localdefs
            elseif not idx_dumped[k] then
               table.insert (acc, "[" .. dump_or_ref_val(k) .. "] = " .. dump_or_ref_val(v))
            end
         end
         return "{ "..table.concat(acc,", ").." }"
      else
         error ("Can't serialize data of type "..t)
      end
   end
          
   local function dump_nest_patches()
      for _, entry in ipairs(nest_patches) do
         local p, k, v = unpack (entry)
         assert (multiple[p])
         local set = dump_or_ref_val (p) .. "[" .. dump_or_ref_val (k) .. "] = " .. 
            dump_or_ref_val (v) .. " -- rec "
         table.insert (localdefs, set)
      end
   end
   
   mark_multiple_occurences (x)
   local toplevel = dump_or_ref_val (x)
   dump_nest_patches()

   if next (localdefs) then
      return "local _={ }\n" ..
         table.concat (localdefs, "\n") .. 
         "\nreturn " .. toplevel
   else
      return "return " .. toplevel
   end
end

function deserialize (x)
	return loadstring(x)()
end

function printTable(t, indent)
    indent = indent or 0

    for k, v in pairs(t) do
        if type(v) == "table" then
            print(string.rep(" ", indent) .. k .. ": {")
            printTable(v, indent + 4)
            print(string.rep(" ", indent) .. "}")
        else
            print(string.rep(" ", indent) .. k .. ": " .. tostring(v))
        end
    end
end

-- ===========================================================================
-- 使用字符串创建组名，并防止玩家在使用的组混乱
-- ===========================================================================
function CreateGroups(str)
	local g = Modding.GetCurrentModGroup();		-- 当前使用的组
	local currentGroup = Modding.GetCurrentModGroup();
	Modding.CreateModGroup(str, currentGroup);
	Modding.SetCurrentModGroup(g);				-- 还原回初始使用的组
end
-- ===========================================================================
-- 输入表和索引，将字符串储存
-- ===========================================================================
function Storage_table(t, title)
	if not title or title == "" then return end;
	local Title = "[size_0][" .. tostring(title) .. "][";
	
	local groups = Modding.GetModGroups();		-- 首先删除原有的表
	for i, v in ipairs(groups) do
		if Title == string.sub(v.Name, 1, #Title) then
			Modding.DeleteModGroup( v.Handle )
		end
	end

	local Para = 1;		-- 当字符超过2000时，储存一部分字符串先;
	local InfoStr = serialize(t)
	for i = 1, #InfoStr, 2000 do
		local iStr = Title .. tostring(Para) .. "]" .. string.sub(InfoStr, i, i + 1999);		-- 截取2000字符串为一组
		Para = Para + 1;
		CreateGroups(iStr)
	end
end
-- ===========================================================================
-- 读取数据
-- ===========================================================================
function Read_tableString(title)
	if not title or title == "" then return end;
	local Title = "[size_0][" .. tostring(title) .. "][";
	local Tstrings = {}
	local tableString = ""
	local groups = Modding.GetModGroups();
	for i, v in ipairs(groups) do
		if Title == string.sub(v.Name, 1, #Title) then
			local Str = string.sub(v.Name, #Title + 1)
			local sp = string.find(Str, "]")
			local Para = tonumber(string.sub(Str, 1, sp - 1))
			Tstrings[Para] = string.sub(Str, sp + 1)
		end
	end
	for i, v in ipairs(Tstrings) do
		tableString = tableString .. v;
	end
	return deserialize(tableString)
end

function GetCivStats()
	-- 第一步，获取上一局的信息
	local Last_Civs = {
		Seed = 0,
		Civs = {},
		OtherSeeds = {},		-- 储存用于排重的种子
	}
	Last_Civs_Sqlite = Read_tableString("Last_Civs") or Last_Civs;
	tbroadcast = {				-- 用于广播的信息
		Seed = Last_Civs_Sqlite.Seed,
		Civs = Last_Civs_Sqlite.Civs,
	}
	local strbroadcast = serialize(tbroadcast)		-- 表转字符串
	local LocalplayerID = Network.GetLocalPlayerID();
	PlayerConfigurations[LocalplayerID]:SetValue("Last_Civs", strbroadcast);
	Network.BroadcastPlayerInfo(LocalplayerID);				-- 第二步，广播自己的信息给其他玩家
	local CivStats = {		-- 第三步，将本局信息写入统计数据
		Seed = 0,
		Civs = {},
	}
	t = Read_tableString("CivStats") or CivStats
	GameSeed = GameConfiguration.GetValue("GAME_SYNC_RANDOM_SEED")
	if t.Seed == GameSeed then return end
	t.Seed = GameSeed
	table.insert(Last_Civs_Sqlite.OtherSeeds, GameSeed)		-- 写入本局种子

	local player_ids = PlayerManager.GetAliveMajorIDs();
	local PlayerNum = 0
	Civ_Leaders = {}
	for _, iPlayerID in ipairs(player_ids) do
		local pPlayerConfig = PlayerConfigurations[iPlayerID];
		if pPlayerConfig ~= nil then
			if(pPlayerConfig:IsHuman()) then
				PlayerNum = PlayerNum + 1;
				local Type = pPlayerConfig:GetLeaderTypeName()
				if Type then
					local leaderType = string.gsub(Type, "LEADER_", "", 1)
					table.insert(Civ_Leaders, leaderType)
				end
			end
		end
	end
	if PlayerNum < 2 then return end		-- 仅计算多人游戏时
	for i, v in pairs(Civ_Leaders) do
		local n = t.Civs[v] or 0
		n = n + 1
		t.Civs[v] = n
	end
	Storage_table(t, "CivStats")
	Events.TurnEnd.Add( StatsOnTurnEnd );
end

function StatsOnTurnEnd()		-- 第四步，获取其他玩家的
	Events.TurnEnd.Remove( StatsOnTurnEnd )
	local NewSeeds = {}		-- 储存新的种子库（最多50个）
	for i, iseed in pairs(Last_Civs_Sqlite.OtherSeeds) do
		table.insert(NewSeeds, iseed)
	end

	local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();		
	for _, iPlayerID in ipairs(player_ids) do
		if iPlayerID ~= Network.GetLocalPlayerID() then		--  仅记录其他玩家
			local pPlayerConfig = PlayerConfigurations[iPlayerID];
			if pPlayerConfig and pPlayerConfig:IsHuman() then
				local ValueStr = pPlayerConfig:GetValue("Last_Civs");		-- 读取字符串
				local itbroadcast = {
					Seed = 0,
					Civs = {},
				}
				local totherplayerbroadcast = deserialize(ValueStr) or itbroadcast		-- 字符串转表
				local IsNew = true		-- 判断这个玩家发送的信息是否是新的
				for i, iseed in pairs(NewSeeds) do		-- 排除重复
					if iseed == totherplayerbroadcast.Seed then
						IsNew = false
						break
					end
				end
				if IsNew then	-- 是新的，开展下一步
					table.insert(NewSeeds, totherplayerbroadcast.Seed)		-- 把这个种子也加入库中
					for i, v in pairs(totherplayerbroadcast.Civs) do		-- 读取其他玩家的领袖表
						local n = t.Civs[v] or 0
						n = n + 1
						t.Civs[v] = n
					end
				end
			end
		end
	end
	Storage_table(t, "CivStats")		-- 储存这个表
	
	-- 下一步，处理种子库，去除超过50个的部分
	for i = #NewSeeds - 50, 1, -1 do
		table.remove(NewSeeds, i)
	end
	Last_Civs_Sqlite.OtherSeeds = NewSeeds		-- 写入暂存表的数据，并储存
	Last_Civs_Sqlite.Seed = GameSeed
	Last_Civs_Sqlite.Civs = Civ_Leaders
	Storage_table(Last_Civs_Sqlite, "Last_Civs")
end

-- ==============================================
-- 检测玩家电脑水平
-- ==============================================
function OnLocalPlayerTurnBegin()
	Events.LocalPlayerTurnBegin.Remove( OnLocalPlayerTurnBegin )		-- 只触发一次
	if TPT_Game_Start_Cache ~= "Y" then
--		print("首次开始游戏")
		Network.SendChat("[ENDCOLOR][Icon_CheckmarkBlue]", -2, -1)
	end
end

function OnLoadScreenClose_Check()
	if TPT_Game_Start_Cache == "Y" then				-- 如果是重新载入游戏，则立即发送标志
--		print("二次载入游戏")
		Network.SendChat("[ENDCOLOR][Icon_CheckmarkBlue]", -2, -1)
	end
end

function OnTurnEnd()
	Events.TurnEnd.Remove( OnTurnEnd );
	if Network.GetGameHostPlayerID() == Network.GetLocalPlayerID() then
		GameConfiguration.SetValue("TPT_Game_Start", "Y")
		Network.BroadcastGameConfig()
	end
end

-- ==============================================
-- 重新开始游戏
-- ==============================================
function NotSingle()				-- 是否是单人游戏？
	if GameConfiguration.IsAnyMultiplayer() then
		for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
			if playerID ~= Game.GetLocalPlayer() then
				if PlayerConfigurations[playerID]:IsHuman() then
					return true
				end
			end
		end
	end
	return false
end

function Reset()
	PlayerFirstTurnBegin = {}
	for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do		-- 初始化标记
		if Players[playerID]:IsHuman() and playerID ~= Network.GetGameHostPlayerID() then		-- 所有非房主玩家
			PlayerFirstTurnBegin[playerID] = false
		end
	end
end

function OnReallyRestartGame()
--	print("暂停游戏，配置参数")
	if (GameConfiguration.IsPaused() == true) then							-- 第一步，取消其他玩家的暂停
		local pausePlayerID = GameConfiguration.GetPausePlayer();
		if pausePlayerID ~= Network.GetGameHostPlayerID() then
			local localPlayerConfig = PlayerConfigurations[pausePlayerID];
			if(localPlayerConfig) then
				localPlayerConfig:SetWantsPause(false);
			end
			Network.BroadcastPlayerInfo();
		end
	end
	
	GameConfiguration.RegenerateSeeds()										-- 第二步，随机化地图和游戏种子
	Network.BroadcastGameConfig();
	
	GameConfiguration.SetValue("TPT_GAME_HOST_IS_JUST_RELOADING", "Y")		-- 第三步，发送主机重载标志
	GameConfiguration.SetValue("TPT_Game_Start", "Y")						-- 游戏已经开始标志

	Network.BroadcastGameConfig();

	if (GameConfiguration.IsPaused() == false) then							-- 第四步，主机暂停游戏
		local localPlayerID = Network.GetGameHostPlayerID();
		local localPlayerConfig = PlayerConfigurations[localPlayerID];
		local newPause = not localPlayerConfig:GetWantsPause();
		localPlayerConfig:SetWantsPause(newPause);
		Network.BroadcastPlayerInfo();
	end
--	print("房主重开")
	Network.RestartGame()													-- 第五步，房主重开
end

function OnLoadScreenClose()
--	print("加载界面关闭")
	if Network.GetGameHostPlayerID() == Network.GetLocalPlayerID() then
		if GameConfiguration.GetValue("TPT_GAME_HOST_IS_JUST_RELOADING") == "Y" then				-- 有重开标记
--			print("有重开标志")
			GameConfiguration.SetValue("TPT_GAME_HOST_IS_JUST_RELOADING", "N")		-- 重置标记
			Network.BroadcastGameConfig();

			if NotSingle() then				-- 第六步，多人游戏时，发送聊天信息触发其他玩家重载
				Network.SendChat("请不要解除暂停，直到所有其他玩家重新载入游戏", -2, Network.GetGameHostPlayerID())
				Network.SendChat("[size_0]RequestSnapshot", -2, -1)

				Reset()
				Host_Just_ReStart = true		-- 开始检测其他玩家是否加载完成
--				print("通过聊天消息确认")
			end
		elseif (GameConfiguration.IsPaused() == true) then
			local pausePlayerID = GameConfiguration.GetPausePlayer();
			local localPlayerConfig = PlayerConfigurations[pausePlayerID];
			if(localPlayerConfig) then
				localPlayerConfig:SetWantsPause(false);
			end
			Network.BroadcastPlayerInfo();
		end
	end
	OnLoadScreenClose_Check()
end

function CheckAllTrue(kDate)
	for _, v in pairs(kDate) do
		if not v then
			return false
		end
	end
	return true
end

function OnMultiplayerChat( fromPlayer, toPlayer, text, eTargetType )
	if toPlayer ~= -1 then		-- 仅公共聊天
		return
	end

	if text == "[size_0]RequestSnapshot" then						-- 第七步，其他玩家开始重载
		if fromPlayer == Network.GetGameHostPlayerID() and Network.GetGameHostPlayerID() ~= Network.GetLocalPlayerID() then
--			print("其他玩家开始同步")
			Network.RequestSnapshot()		
		end
		return
	end

	if text == "[ENDCOLOR][Icon_CheckmarkBlue]" then
		if Host_Just_ReStart and Network.GetGameHostPlayerID() == Network.GetLocalPlayerID() then				-- 第八步，房主检测其他玩家是否加载完毕
			if fromPlayer ~= Network.GetGameHostPlayerID() then
				PlayerFirstTurnBegin[fromPlayer] = true
			end

			if CheckAllTrue(PlayerFirstTurnBegin) then		-- 所有玩家到齐了？开始下一步
				Reset()										-- 重置标记
				Host_Just_ReStart = false

				if (GameConfiguration.IsPaused() == true) then						-- 取消暂停
					local pausePlayerID = GameConfiguration.GetPausePlayer();
					local localPlayerConfig = PlayerConfigurations[pausePlayerID];
					if(localPlayerConfig) then
						localPlayerConfig:SetWantsPause(false);
					end
					Network.BroadcastPlayerInfo();
--					print("确认所有玩家到齐")
				end
			end
		end
		return
	end
end

function Initialize()
	if GameConfiguration.IsAnyMultiplayer() then
		Reset()
		Events.LoadScreenClose.Add(OnLoadScreenClose);
		Events.LoadScreenClose.Add(GetCivStats);

		Events.MultiplayerChat.Add( OnMultiplayerChat );
		Events.LocalPlayerTurnBegin.Add( OnLocalPlayerTurnBegin )
		Events.TurnEnd.Add( OnTurnEnd );
		LuaEvents.TPT_Restart_Game.Add( OnReallyRestartGame )
	end
end
Initialize();