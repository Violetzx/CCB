-- ===========================================================================
-- Diplomacy Trade View Manager
-- ===========================================================================

-- ===========================================================================
-- INCLUDES
-- ===========================================================================

local isGoldTradingAllowed = true;
local isFavorTradingAllowed = true;
local isStrategicsTradingAllowed = true;
local isLuxuriesTradingAllowed = true;
local isCitiesTradingAllowed = true;
local isCaptivesTradingAllowed = true;
local isGreatWorksTradingAllowed = true;
local isAgreementsTradingAllowed = true;

if GameConfiguration.GetValue("TPT_NO_TRADING_FAVOR") == true then	-- 外交支持
	isFavorTradingAllowed = false
	print("TPT - No Trading Favor")
end

if GameConfiguration.GetValue("TPT_NO_TRADING_GOLD") == true then	-- 金币
	isGoldTradingAllowed = false
	print("TPT - No Trading Gold")
end

if GameConfiguration.GetValue("TPT_NO_TRADING_STRATEGICS") == true then		-- 战略资源
	isStrategicsTradingAllowed = false
	print("TPT - No Trading Strategic")
end

if GameConfiguration.GetValue("TPT_NO_TRADING_LUXURIES") == true then	-- 奢侈品
	isLuxuriesTradingAllowed = false
	print("TPT - No Trading Luxuries")
end

if GameConfiguration.GetValue("TPT_NO_TRADING_CITIES") == true then		-- 城市
	isCitiesTradingAllowed = false
	print("TPT - No Trading Cities")
end

if GameConfiguration.GetValue("TPT_NO_TRADING_CAPTIVES") == true then		-- 俘虏
	isCaptivesTradingAllowed = false
	print("TPT - No Trading Captibve")
end

if GameConfiguration.GetValue("TPT_NO_TRADING_GREATWORKS") == true then		-- 巨作
	isGreatWorksTradingAllowed = false
	print("TPT - No Trading Great Works")
end

if GameConfiguration.GetValue("TPT_NO_TRADING_AGREEMENTS") == true then		-- 外交协议（开放边界）
	isAgreementsTradingAllowed = false
	print("TPT - No Trading Agreements")
end
if GameConfiguration.GetValue("SETTINGS_DIPLOMATIC_DEAL") == "SETTINGS_DEAL_NORM" then
	isGoldTradingAllowed = true;
	isFavorTradingAllowed = true;
	isStrategicsTradingAllowed = true;
	isLuxuriesTradingAllowed = true;
	isCitiesTradingAllowed = false;
	isCaptivesTradingAllowed = true;
	isGreatWorksTradingAllowed = true;
	isAgreementsTradingAllowed = true;
	
	print("TPT - 交易常规")
end
if GameConfiguration.GetValue("SETTINGS_DIPLOMATIC_DEAL") == "SETTINGS_DEAL_CLASSIC" then
	isGoldTradingAllowed = false;
	isFavorTradingAllowed = true;
	isStrategicsTradingAllowed = true;
	isLuxuriesTradingAllowed = true;
	isCitiesTradingAllowed = false;
	isCaptivesTradingAllowed = true;
	isGreatWorksTradingAllowed = true;
	isAgreementsTradingAllowed = true;
	
	print("TPT - 交易经典")
end
if GameConfiguration.GetValue("SETTINGS_DIPLOMATIC_DEAL") == "SETTINGS_DEAL_ALONE" then
	isGoldTradingAllowed = false;
	isFavorTradingAllowed = false;
	isStrategicsTradingAllowed = false;
	isLuxuriesTradingAllowed = true;
	isCitiesTradingAllowed = false;
	isCaptivesTradingAllowed = false;
	isGreatWorksTradingAllowed = false;
	isAgreementsTradingAllowed = false;
	
	print("TPT - 交易独立")
end

print("TPT DiplomacyDealView")
-- ===========================================================================
-- CACHE BASE FUNCTIONS
-- ===========================================================================


BASE_PopulateAvailableGold = PopulateAvailableGold;
BASE_PopulateAvailableLuxuryResources =  PopulateAvailableLuxuryResources;
BASE_PopulateAvailableStrategicResources = PopulateAvailableStrategicResources;
BASE_PopulateAvailableCaptives = PopulateAvailableCaptives;
BASE_PopulateAvailableGreatWorks = PopulateAvailableGreatWorks;
BASE_PopulateAvailableCities = PopulateAvailableCities;
BASE_PopulateAvailableAgreements = PopulateAvailableAgreements;
BASE_PopulateAvailableFavor = PopulateAvailableFavor;


-- ===========================================================================
--	OVERRIDE
-- ===========================================================================

function PopulateAvailableFavor(player: table, iconList: table)
	if isFavorTradingAllowed == false then
		return 1;		-- 防止因为没有可交易选项，导致无法签同盟
	end
	
	return BASE_PopulateAvailableFavor(player,iconList);
	
end

function PopulateAvailableGold(player : table, iconList : table)

	if isGoldTradingAllowed == false then
		return 1;
	end
	
	return BASE_PopulateAvailableGold(player,iconList);
	
end

function PopulateAvailableStrategicResources(player : table, iconList : table)

	if isStrategicsTradingAllowed == false then
		iconList.GetTopControl():SetHide(true);
		return 1;
	end
	
	return BASE_PopulateAvailableStrategicResources(player,iconList);
	
end

function PopulateAvailableLuxuryResources(player : table, iconList : table)

	if isLuxuriesTradingAllowed == false then
		iconList.GetTopControl():SetHide(true);
		return 1;
	end
	
	return BASE_PopulateAvailableLuxuryResources(player,iconList);
	
end

function PopulateAvailableAgreements(player : table, iconList : table)

	if isAgreementsTradingAllowed == false then
		iconList.GetTopControl():SetHide(true);
		return 1;
	end
	
	return BASE_PopulateAvailableAgreements(player,iconList);
	
end

function PopulateAvailableCities(player : table, iconList : table)

	if isCitiesTradingAllowed == false then
		iconList.GetTopControl():SetHide(true);
		return 1;
	end
	
	return BASE_PopulateAvailableCities(player,iconList);
	
end

function PopulateAvailableGreatWorks(player : table, iconList : table)

	if isGreatWorksTradingAllowed == false then
		iconList.GetTopControl():SetHide(true);
		return 1;
	end
	
	return BASE_PopulateAvailableGreatWorks(player,iconList);
	
end

function PopulateAvailableCaptives(player : table, iconList : table)

	if isCaptivesTradingAllowed == false then
		iconList.GetTopControl():SetHide(true);
		return 1;
	end
	
	return BASE_PopulateAvailableCaptives(player,iconList);
	
end