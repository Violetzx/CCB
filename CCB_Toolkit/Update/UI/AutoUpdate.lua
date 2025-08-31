include( "InstanceManager" );
-- ===========================================
-- Globals
-- ===========================================
local TPT_SubscriptionID = string.sub(Locale.Lookup( "LOC_TEAM_PVP_TOOLS_SUBSCRIPTION_ID" ), 2);

local m_TPT_Update_TT = {}
TTManager:GetTypeControlTable("TooltipType_TPT_Update", m_TPT_Update_TT)
-- ===========================================
-- Function
-- ===========================================
function UpdateMods(isubscriptionId)
	local mods = Modding.GetInstalledMods();
	for i,v in ipairs(mods) do
		if v.SubscriptionId == tostring(isubscriptionId) then
			Modding.UpdateSubscription(isubscriptionId);
			break
		end
	end
end

function EnableMods(isubscriptionId)
	local mods = Modding.GetInstalledMods();
	for i,v in ipairs(mods) do	
		if v.SubscriptionId == tostring(isubscriptionId) then
			Modding.EnableMod(v.Handle, true);
			break
		end
	end
end

function UpdateAllMods()
	local enabledMods = GameConfiguration.GetEnabledMods();
	local mods = Modding.GetInstalledMods();
	for _, curMod in ipairs(enabledMods) do
		if not curMod.Official	then		-- 非官方包
			for i,v in ipairs(mods) do
				if curMod.Id == v.Id then
					if v.SubscriptionId and v.SubscriptionId ~= "" then
						Modding.UpdateSubscription(v.SubscriptionId);		-- 更新
					end
				end
			end
		end
	end
end
--[[
function CheckSubscribed(isubscriptionId)
	local subs = Modding.GetSubscriptions();
	for i,v in ipairs(subs) do
		if v == tostring(isubscriptionId) then
			return true
		end
	end
	return false
end
]]
function OnMods()
--	UpdateMods(3085243555)		--联机工具箱
--	UpdateMods(2997927787)		--顶部面板
	UpdateMods(3041524474)		--外交能见度模式
--	UpdateMods(3036707997)		--真实科文进度
--	UpdateMods(3084856138)		--宣传框架
	
	EnableMods(TPT_SubscriptionID)		--联机工具箱
--	EnableMods(3084856138)		--宣传框架
end
-- =====================================================================
-- 获取更新内容
-- =====================================================================
function Get_TPT_Update_Text()
	local g_TPT_Update = {};
	local LOC_Base = "LOC_TEAM_PVP_TOOLS_UPDATE_"
	for i = 1, 100 do
		local loc_UpdateStr = LOC_Base..i
		if Locale.Lookup(loc_UpdateStr) ~= loc_UpdateStr then
			table.insert(g_TPT_Update, Locale.Lookup(loc_UpdateStr))
		else
			break
		end
	end
	return g_TPT_Update
end

function Creat_TPT_Update()
	local TPT_Update_Text = Get_TPT_Update_Text()
	
	if m_TPT_Update_TT.IM == nil then
		m_TPT_Update_TT.IM = InstanceManager:new("TPT_UpdateInstance", "BG", m_TPT_Update_TT.TPT_Update_Stack)
	end
	
	m_TPT_Update_TT.IM:ResetInstances()
	
	for i, iUpdateText in ipairs(TPT_Update_Text) do
		local tInstance = m_TPT_Update_TT.IM:GetAllocatedInstance(i)
		if not tInstance then
			tInstance = m_TPT_Update_TT.IM:GetInstance()
		end
		tInstance.SerialNumber:SetText(i)
		tInstance.UpdateText:SetText(iUpdateText)
		tInstance.BGStack:CalculateSize()
	end
end
-- ===========================================
-- 显示更新内容与版本号
-- ===========================================
function OnLoadScreenClose()
	local Lable_WorldTracker = ContextPtr:LookUpControl("/InGame/WorldTracker/WorldTracker")
	Lable_WorldTracker:SetText( Locale.Lookup( "LOC_TEAM_PVP_TOOLS_HEADER" ).." "..Locale.Lookup( "LOC_TEAM_PVP_VERSION" ) );

	Lable_WorldTracker:SetToolTipType("TooltipType_TPT_Update")
	Creat_TPT_Update()
end

function Initialize()
	UpdateAllMods()
	OnMods()
	Events.LoadScreenClose.Add( OnLoadScreenClose )
	Events.ExitToMainMenu.Add( function() Modding.UpdateSubscription(TPT_SubscriptionID); end );		-- 联机工具箱
end
Initialize()