include( "InstanceManager" );	--InstanceManager

local m_CheckBoxsIM:table = InstanceManager:new("CheckboxInstance", "ButtonRoot", Controls.CheckBoxStack);
local m_CheckBoxsControls = {}

local TPT_Settings_CheckBoxs = {}

local First_Use = true				-- 初次使用

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
	return deserialize(tableString)
end

-- =====================================================================
-- 创造按钮
-- =====================================================================
function CreatCheckBoxStack()
	m_CheckBoxsIM:ResetInstances();
	for i, idata in pairs(TPT_Settings_CheckBoxs) do
		local CheckBoxsControl = m_CheckBoxsIM:GetInstance();
		m_CheckBoxsControls[i] = CheckBoxsControl
		
		CheckBoxsControl.Settings_Box:SetText(Locale.Lookup(idata.String));
		if idata.ToolTip then
			CheckBoxsControl.Settings_Box:SetToolTipString(Locale.Lookup(idata.ToolTip))
		end
		CheckBoxsControl.Settings_Box:SetSelected(idata.Value)
		CheckBoxsControl.Settings_Box:SetVoid1(i)
		CheckBoxsControl.Settings_Box:RegisterCallback(Mouse.eLClick, OnCheckBoxs)
	end
	Controls.CheckBoxStack:CalculateSize();
	Controls.Listings:CalculateSize();
end

function SetCheck()
	for i, iControl in ipairs(m_CheckBoxsControls) do
		iControl.Settings_Box:SetSelected(TPT_Settings_CheckBoxs[i].Value)
		LuaEvents.TPT_Settings_Toggle(TPT_Settings_CheckBoxs[i].ParameterId, TPT_Settings_CheckBoxs[i].Value)
	end
end
-- =====================================================================
-- 按钮响应
-- =====================================================================
function OnCheckBoxs(i)
	local CheckBoxsControl = m_CheckBoxsIM:GetAllocatedInstance(i)
	TPT_Settings_CheckBoxs[i].Value = not TPT_Settings_CheckBoxs[i].Value
	
	CheckBoxsControl.Settings_Box:SetSelected(TPT_Settings_CheckBoxs[i].Value)
	LuaEvents.TPT_Settings_Toggle(TPT_Settings_CheckBoxs[i].ParameterId, TPT_Settings_CheckBoxs[i].Value)		-- 在对应文件触发
end
-- =====================================================================
-- 显示/隐藏面板
-- =====================================================================
function OnShow()
	ContextPtr:SetHide(false);
end

function OnClose()
	ContextPtr:SetHide(true);
	storageData()
end

function OnSettingButton()
	if ContextPtr:IsHidden() then
		OnShow()
	else
		OnClose()
	end
end
-- =====================================================================
-- 储存数据
-- =====================================================================
function storageData()
	local t = {}
	for i, idata in pairs(TPT_Settings_CheckBoxs) do
		local kdata = {
			ParameterId = idata.ParameterId,
			Value = idata.Value,
		}
		table.insert(t, kdata)
	end
	Storage_table(t, "TPTsettings")
end
-- =====================================================================
-- 读取储存的数据
-- =====================================================================
function Initializedata()
	local CheckboxValus = Read_tableString("TPTsettings")
	if CheckboxValus then
		for i, v in pairs(CheckboxValus) do
			First_Use = false
			local InUse = false
			for j, idata in pairs(TPT_Settings_CheckBoxs) do
				if v.ParameterId == idata.ParameterId then
					TPT_Settings_CheckBoxs[j].Value = v.Value
					InUse = true
				end
			end
			if not InUse then		-- 在玩家数据库中，但是本局游戏未使用,需要存回去
				local jdata = {
					ParameterId = v.ParameterId,
					Value = v.Value,
				}
				table.insert(TPT_Settings_CheckBoxs, jdata)
			end
		end	
	end
end

function split(str,reps)
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function (w)
        table.insert(resultStrList,w)
    end)
    return resultStrList
end

function LateInitialize()
	SetCheck()
	-- 绑定弹窗按钮
	local ctr = ContextPtr:LookUpControl("/InGame/WorldTracker/WorldTrackerHeader")
	Controls.TPTSettingButton:ChangeParent(ctr)
	Controls.TPTSettingButton:RegisterCallback(	Mouse.eLClick, OnSettingButton);
	-- 确认按钮
	Controls.ConfirmButton:RegisterCallback( Mouse.eLClick, OnClose);
	Controls.ConfirmButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end );
	
	if First_Use then		-- 初次使用的玩家，弹出窗口
		OnShow()
	end
end

function Initialize()
	for kData in GameInfo.TPT_Settings() do
		local idata = {
			ParameterId = kData.ParameterId,
			Value = kData.DefaultValue,
			String = kData.String,
			ToolTip = kData.ToolTip,
		}
		table.insert(TPT_Settings_CheckBoxs, idata)
	end
	CreatCheckBoxStack()	-- 创造按钮列
	Initializedata()		-- 读取用户储存的数据

	Events.LoadScreenClose.Add(LateInitialize)
end
Initialize()