-- ===========================================================================
-- INCLUDES
-- ===========================================================================
local files = {
    "Expansion1_InGameTopOptionsMenu",
    "InGameTopOptionsMenu",
}

local TPT_Basefiles = ""

for _, file in ipairs(files) do
    include(file)
    if Initialize then
        print("Loading " .. file .. " as base file");
        TPT_Basefiles = file
        break
    end
end

-- ===========================================================================
--	OVERRIDES
-- ===========================================================================
BASE_Close = Close;
BASE_Initialize = Initialize;
BASE_SetupButtons = SetupButtons;

-- ===========================================================================
-- Globals
-- ===========================================================================
local PlayerFirstTurnBegin = {}

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
local _, m_screenHeight : number = UIManager:GetScreenSizeVal();
local m_SettingModsInUseSize = 680;
local BaseModsInUseSizeY = Controls.ModsInUse:GetSizeY()		-- 100

local TPT_SubscriptionID = string.sub(Locale.Lookup( "LOC_TEAM_PVP_TOOLS_SUBSCRIPTION_ID" ), 2);

-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================
function Close()
	BASE_Close()
	Refresh()
end

function NotSingle()
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

-- ===========================================================================
--	重开游戏
-- ===========================================================================
function SetupButtons()		-- 显示重开按钮
	BASE_SetupButtons()
	
	local bWorldBuilder : boolean = WorldBuilder and WorldBuilder:IsActive();
	local bCanRestart = Network.GetGameHostPlayerID() == Network.GetLocalPlayerID()
	bCanRestart = bCanRestart and not bWorldBuilder;
	Controls.RestartButton:SetHide( not bCanRestart );
end

function OnReallyRestart()
	if NotSingle() then
		print("开始重开进程")
		LuaEvents.TPT_Restart_Game()		-- CC\NetHelper
	else
		Network.RestartGame();
	end
end
-- ===========================================================================
--	扩展使用中的模组界面
-- ===========================================================================
function OnLoadScreenClose_TPT()	-- 根据玩家屏幕尺寸调整
	if m_screenHeight < 1080 then
		m_SettingModsInUseSize = 0.8*m_screenHeight-190;
	end
	if m_SettingModsInUseSize < BaseModsInUseSizeY then
		m_SettingModsInUseSize = BaseModsInUseSizeY
		Controls.ModsInUseInfoOpenButton:SetHide(true)		-- 屏幕太小了？不要使用此功能
	end
end

function OnModsInUseInfoOpenButton()
	local ModsInUseSizeY :number = Controls.ModsInUse:GetSizeY();
	if ModsInUseSizeY == BaseModsInUseSizeY then
		Controls.ModsInUse:SetSizeY(m_SettingModsInUseSize)
		Controls.Buttons:SetHide(true)
		GetModInUseString()
	else
		Refresh()
	end
end

function Refresh()
	Controls.ModsInUse:SetSizeY(BaseModsInUseSizeY)
	Controls.Buttons:SetHide(false)
end
-- ===========================================================================
--	生成使用中的模组字符串
-- ===========================================================================
function GetModInUseString()
	local ModInUseStr = ""
	local enabledMods = GameConfiguration.GetEnabledMods();
	for _, curMod in ipairs(enabledMods) do
		if not curMod.Official then
			local TitleStr = string.gsub(curMod.Title,"%b[]","")
			ModInUseStr = ModInUseStr..TitleStr.."\n"
		end
	end
	UIManager:SetClipboardString(ModInUseStr)
end

-- ===========================================================================
--	TPT FUNCTIONS
-- ===========================================================================
function CheckSubscribed(isubscriptionId)
	local subs = Modding.GetSubscriptions();
	for i,v in ipairs(subs) do
		if v == tostring(isubscriptionId) then
			return true
		end
	end
	return false
end

function Initialize()
	BASE_Initialize();
	
	Controls.ModsInUseInfoOpenButton:RegisterCallback( Mouse.eLClick, OnModsInUseInfoOpenButton );
	Controls.ModsInUseInfoOpenButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	
	Controls.SubscribeButton:RegisterCallback( Mouse.eLClick, function() Steam.ActivateGameOverlayToUrl("http://steamcommunity.com/sharedfiles/filedetails/?id="..TPT_SubscriptionID); end );
	Controls.SubscribeButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.SubscribeButton:SetHide( CheckSubscribed(TPT_SubscriptionID) )		-- 联机工具箱

	if TPT_Basefiles == "InGameTopOptionsMenu" then
		Controls.ExpansionNewFeatures:SetHide(true);
	end

	Events.LoadScreenClose.Add(OnLoadScreenClose_TPT);
end
Initialize()