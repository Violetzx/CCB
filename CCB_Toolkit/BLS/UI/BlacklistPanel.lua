include( "InstanceManager" );
-- ========================================================
-- 全局变量
-- ========================================================
local g_PlayerList = {}				-- 储存进入房间的玩家信息
local g_LocalBlackList = {}			-- 本地玩家的黑名单信息

local m_PlayerListIM = InstanceManager:new("PlayerListEntry", "RootContainer", Controls.PlayerListStack);
local m_PlayerListControls = {}

local m_BlackListIM = InstanceManager:new("BlackListEntry", "RootContainer", Controls.BlackListStack);
local m_BlackListControls = {}

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

local function printTable(t, indent)
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
	return deserialize(tableString) or {}
end

-- ========================================================
-- 函数
-- ========================================================
function Open()
	RefreshPlayerList()
	ContextPtr:SetHide(false);
end

function Close()
	ContextPtr:SetHide(true);
end

function RefreshPlayerList()
	for i, idata in pairs(g_PlayerList) do
		g_PlayerList[i].IsMet = Players[Game.GetLocalPlayer()]:GetDiplomacy():HasMet(idata.PlayerID)
		g_PlayerList[i].IsBan = false
		g_PlayerList[i].BanTT = ""
		for _, kData in pairs(g_LocalBlackList) do
			if g_PlayerList[i].SteamID == kData.SteamID then
				g_PlayerList[i].IsBan = true
				g_PlayerList[i].BanTT = kData.Desc
			end
		end
	end
	CreatPlayerListStack()
end

function OnMultiplayerPlayerConnected()
	for _, iPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if iPlayerID ~= Game.GetLocalPlayer() then
			local pPlayerConfig = PlayerConfigurations[iPlayerID];
			if(pPlayerConfig:IsHuman()) then
				local playerNetworkID = PlayerConfigurations[iPlayerID]:GetNetworkIdentifer();
				local IsNew = true
				for i, idata in pairs(g_PlayerList) do
					if playerNetworkID == idata.SteamID then
						IsNew = false
					end
				end
				if IsNew then
					local kData = {
						PlayerID = iPlayerID,
						SteamID = string.len(playerNetworkID) == 17 and playerNetworkID or nil,
						Name = Locale.Lookup(pPlayerConfig:GetPlayerName()),
						IsMet = Players[Game.GetLocalPlayer()]:GetDiplomacy():HasMet(iPlayerID),
						IsBan = false,
						BanTT = "",
						Icon = "[ICON_ICON_"..pPlayerConfig:GetLeaderTypeName().."]",
					}
					for _, iData in pairs(g_LocalBlackList) do
						if kData.SteamID == iData.SteamID then
							kData.IsBan = true
							kData.BanTT = iData.Desc
						end
					end
					table.insert(g_PlayerList, kData)
				end
			end		
		end
	end
	CreatPlayerListStack()
end

function RefreshBlackList()
	GetLocalBlackList()
	CreatBlackListStack()
end
-- =====================================================================
-- 显示添加弹窗
-- =====================================================================
function OnAddBlackListButton()		--检测玩家
    UI.PlaySound("Play_UI_Click");
    
	Controls.DescInputEditBox:SetText("");
	Controls.SteamIDInputEditBox:SetText("");
		
	Controls.CreateModGroupButton:SetDisabled(true);

	Controls.NameModGroupPopup:SetHide(false);
	Controls.NameModGroupPopupAlpha:SetToBeginning();
	Controls.NameModGroupPopupAlpha:Play();
	Controls.NameModGroupPopupSlide:SetToBeginning();
	Controls.NameModGroupPopupSlide:Play();
	
	Controls.SteamIDInputEditBox:TakeFocus();
end
-- =====================================================================
-- 拆分字符串成表
-- =====================================================================
function split(str,reps)
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function (w)
        table.insert(resultStrList,w)
    end)
    return resultStrList
end
-- ========================================================
-- 初始化玩家数据
-- ========================================================
function InitializePlayerData()
	for _, iPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if iPlayerID ~= Game.GetLocalPlayer() then
			local pPlayerConfig = PlayerConfigurations[iPlayerID];
			if(pPlayerConfig:IsHuman()) then
				local playerNetworkID = PlayerConfigurations[iPlayerID]:GetNetworkIdentifer();
				local kData = {
					PlayerID = iPlayerID,
					SteamID = string.len(playerNetworkID) == 17 and playerNetworkID or nil,
					Name = Locale.Lookup(pPlayerConfig:GetPlayerName()),
					IsMet = Players[Game.GetLocalPlayer()]:GetDiplomacy():HasMet(iPlayerID),
					IsBan = false,
					BanTT = "",
					Icon = "[ICON_ICON_"..pPlayerConfig:GetLeaderTypeName().."]",
				}
				for _, iData in pairs(g_LocalBlackList) do
					if kData.SteamID == iData.SteamID then
						kData.IsBan = true
						kData.BanTT = iData.Desc
					end
				end
				table.insert(g_PlayerList, kData)
			end
		end
	end
end
-- ========================================================
-- 获取本地储存的黑名单信息
-- ========================================================
function GetLocalBlackList()
	g_LocalBlackList = Read_tableString("TPTplayerData")
end
function RemoveDataSteamID(RemoveID)
	local HasStorage = Read_tableString("TPTplayerData")
	if HasStorage then
		for i,kData in ipairs(HasStorage) do
			if kData.SteamID == RemoveID then
				table.remove(HasStorage,i)		-- 排除重复的
				break
			end
		end
		Storage_table(HasStorage, "TPTplayerData")
	end
end
-- ========================================================
-- 添加黑名单
-- ========================================================
function OnAddBlackList(i)
	local BaseData = g_PlayerList[i]
	OnAddBlackListButton()
	if BaseData.SteamID and BaseData.SteamID ~= "" then
		Controls.SteamIDInputEditBox:SetText(BaseData.SteamID);
	end
end

function OnRemoveBlackList(i)
	local BaseData = g_LocalBlackList[i]
	OnAddBlackListButton()
	if BaseData then
		if BaseData.SteamID and BaseData.SteamID ~= "" then
			Controls.SteamIDInputEditBox:SetText(BaseData.SteamID);
		end
		if BaseData.Desc and BaseData.Desc ~= "" then
			Controls.DescInputEditBox:SetText(BaseData.Desc);
		end
	end
end
-- =====================================================================
-- 分段储存数据到"组名"
-- =====================================================================
function StorageData( isteamID	,	idesc	,	itype	)
	local HasStorage = Read_tableString("TPTplayerData")
	local NewData :table = {
		SteamID = isteamID,
		Desc = idesc
	};
	for i,kData in ipairs(HasStorage) do
		if kData.SteamID == isteamID then
			table.remove(HasStorage,i)		-- 排除重复的
			break
		end
	end
	table.insert(HasStorage, NewData)		-- 存入表
	Storage_table(HasStorage, "TPTplayerData")
end
-- ========================================================
-- 创建玩家列表
-- ========================================================
function CreatPlayerListStack()
	Controls.PlayerListStack:DestroyAllChildren()
	m_PlayerListControls = {}
	for i, iData in pairs(g_PlayerList) do
		local iControl = m_PlayerListIM:GetInstance();
		m_PlayerListControls[i] = iControl
		
		iControl.PlayerNameLen:SetText(iData.Name)
		iControl.PlayerName:SetText(iData.Name)
		
		local pSize_PlayerNameLen = iControl.PlayerNameLen:GetSizeX();
		if pSize_PlayerNameLen < 148 then
			iControl.PlayerName:SetOffsetX(	(216 - pSize_PlayerNameLen)/2 )
			iControl.PlayerName:SetAnchor("L,T")
		else
			iControl.PlayerName:SetOffsetX( 0 )
			iControl.PlayerName:SetAnchor("C,T")
		end
				
		if iData.SteamID and iData.SteamID ~= "" then
			iControl.ConnectionLabel:SetText((iData.IsBan == false) and "正常[icon_CheckmarkBlue]" or "黑名单[icon_CheckFail]")
		else
			iControl.ConnectionLabel:SetText("无法获取ID[icon_Exclamation]")
		end
		if iData.IsMet and iData.Icon and iData.Icon ~= "" then
			iControl.LeaderIcon:SetText(iData.Icon)
		else
			iControl.LeaderIcon:SetText("[ICON_ICON_LEADER_DEFAULT]")
		end
		if iData.BanTT and iData.BanTT ~= "" then
			iControl.PlayerListPull:SetToolTipString(iData.BanTT)
		else
			iControl.PlayerListPull:SetToolTipString("")
		end
		
		iControl.AddBlackListButton:SetVoid1(i)
		iControl.AddBlackListButton:RegisterCallback(Mouse.eLClick, OnAddBlackList)
	end
	Controls.PlayerListStack:CalculateSize()
end
-- ========================================================
-- 创建黑名单列表
-- ========================================================
function CreatBlackListStack()
	Controls.BlackListStack:DestroyAllChildren()
	m_BlackListControls = {}
	for i, iData in pairs(g_LocalBlackList) do
		local iControl = m_BlackListIM:GetInstance();
		m_BlackListControls[i] = iControl
		iControl.BlackListPlayerLabel:SetText(iData.SteamID)
		if iData.Desc and iData.Desc ~= "" then
			iControl.DescLen:SetText(iData.Desc)
			iControl.DescLabel:SetText(iData.Desc)
			DescLen_SizeX = iControl.DescLen:GetSizeX()
			if DescLen_SizeX < 280 then
				iControl.DescLabel:SetOffsetX( (300 - DescLen_SizeX)/2 )
				iControl.DescLabel:SetAnchor("L,T")
			else
				iControl.DescLabel:SetOffsetX(0)
				iControl.DescLabel:SetAnchor("C,T")
			end
		end
		
		iControl.BlackListPlayerButton:SetVoid1(i)
		iControl.BlackListPlayerButton:RegisterCallback(Mouse.eLClick, OnRemoveBlackList)
	end
	if #m_BlackListControls == 0 then
		local iControl = m_BlackListIM:GetInstance();
		m_BlackListControls[-1] = iControl
		
		iControl.BlackListPlayerLabel:SetText("")
		
		
		iControl.DescLen:SetText("添加黑名单")
		iControl.DescLabel:SetText("添加黑名单")
		DescLen_SizeX = iControl.DescLen:GetSizeX()
		iControl.DescLabel:SetOffsetX( (300 - DescLen_SizeX)/2 )
		iControl.DescLabel:SetOffsetY(18)
		iControl.DescLabel:SetAnchor("L,T")
		
		iControl.BlackListPlayerButton:SetVoid1(-1)
		iControl.BlackListPlayerButton:RegisterCallback(Mouse.eLClick, OnRemoveBlackList)
	end
	Controls.BlackListStack:CalculateSize();
end

function Initialize()
	GetLocalBlackList()
	InitializePlayerData()
	
	CreatPlayerListStack()
	CreatBlackListStack()

	Controls.CloseButton:RegisterCallback( Mouse.eLClick, Close );
	
	Controls.CancelBindingButton:RegisterCallback(Mouse.eLClick, function()
		Controls.NameModGroupPopup:SetHide(true);
	end);
	
	Controls.SteamIDInputEditBox:RegisterStringChangedCallback(function()
		local str = Controls.SteamIDInputEditBox:GetText();
		if str and #str > 17 then		-- 粘贴时超长，自动截取
			str = string.sub(str,1,17)
			Controls.SteamIDInputEditBox:SetText(str);
		end
		
		Controls.CreateModGroupButton:SetDisabled(str == nil or #str ~= 17 or not tonumber(str) );	-- 必须是17位id输入
		
		Controls.RemoveGroupButton:SetHide(str == nil or #str ~= 17 or not tonumber(str))
		Controls.SteamHomePageButton:SetHide(str == nil or #str ~= 17 or not tonumber(str))
		if str and #str == 17 then
			local ShowRemoveButton = false
			for i, kdata in ipairs(g_LocalBlackList) do
				if kdata.SteamID == str then
					ShowRemoveButton = true
				end
			end
			Controls.RemoveGroupButton:SetHide(not ShowRemoveButton)
		end
	end);

	Controls.SteamHomePageButton:RegisterCallback(Mouse.eLClick, function()
		local str = Controls.SteamIDInputEditBox:GetText();
		local url = "https://steamcommunity.com/profiles/"..str;
		Steam.ActivateGameOverlayToUrl(url)
	end);
	
	Controls.CreateModGroupButton:RegisterCallback(Mouse.eLClick, function()
		Controls.NameModGroupPopup:SetHide(true);
		local SteamID = Controls.SteamIDInputEditBox:GetText();
		local Desc = Controls.DescInputEditBox:GetText();
		StorageData(SteamID,Desc,"Ban")
		RefreshBlackList()
		RefreshPlayerList()
	end);

	Controls.RemoveGroupButton:RegisterCallback(Mouse.eLClick, function()
		Controls.NameModGroupPopup:SetHide(true);
		local SteamID = Controls.SteamIDInputEditBox:GetText();
		RemoveDataSteamID( SteamID )
		RefreshBlackList()
		RefreshPlayerList()
	end);
	Events.MultiplayerPlayerConnected.Add( OnMultiplayerPlayerConnected );
	LuaEvents.Open_BlackListOanel.Add(Open)
end
Initialize()