local g_CoolDownTime = os.clock()							-- 冷却时间(防止同一类型短时间多次触发)

CallbackDict = {};
AuxiliaryTiming = {};
ATnum = 0;
-- =============================================================================
-- 定时器：皮皮凯  https://gitee.com/XPPK/pk-civ6-LuaTimer/blob/master/README.md
-- =============================================================================
function AddTimer(TimeInSeconds, callbackFunc, loop, FuncID, Values, Needunpack)
	ATnum = ATnum + 1;
	-- 如果loop为nil
	loop = loop or false;
	FuncID = FuncID or "Func_" .. ATnum;
	
--	如果FuncID发生重复
	if AuxiliaryTiming[FuncID] ~= nil then
--		print("警告FuncID: "..FuncID, "发生重复，移除旧任务");
		RemoveTimer(FuncID)		-- 移除重复进程
	end
	AuxiliaryTiming[FuncID] = TimeInSeconds;

	-- callbackFunc插入到定时循环中
--	local function CreateLoopFunc()
--		return function()
--			AuxiliaryTiming[FuncID] = AuxiliaryTiming[FuncID] - 1;
--			if AuxiliaryTiming[FuncID] == 0 then
--				if type(Values) == "table" and Needunpack then
--					callbackFunc(unpack(Values));
--				else
--					callbackFunc(Values);
--				end
--				AuxiliaryTiming[FuncID] = TimeInSeconds;
--			end
--		end
--	end

	-- callbackFunc插入到延时触发中
	local function CreateFunc()
		return function()
			AuxiliaryTiming[FuncID] = AuxiliaryTiming[FuncID] - 1;
			if AuxiliaryTiming[FuncID] <= 0 then
				if type(Values) == "table" and Needunpack then
					callbackFunc(unpack(Values));
				else
					callbackFunc(Values);
				end
				CallbackDict[FuncID]()
			end
		end
	end

	local func = CreateFunc();
	Events.GameCoreEventPublishComplete.Add(func);

	-- 直接构造好对应的关闭循环的函数，亦或者提前关闭延迟的函数以免找不到对应func
	CallbackDict[FuncID] = function()
		Events.GameCoreEventPublishComplete.Remove(func);
		CallbackDict[FuncID] = nil;
		AuxiliaryTiming[FuncID] = nil;
	end
	return ATnum;
end

function RemoveTimer(FuncID)
	if CallbackDict[FuncID] then 		-- 还是要检测一下否则为nil又报错
		CallbackDict[FuncID](); 
	end
end

function RemoveAllTimer()
	for i, v in pairs(CallbackDict) do
		if CallbackDict[i] then
			CallbackDict[i]()
		end
	end
end
-- ===========================================================
-- 刷新
-- ===========================================================
Events.LocalPlayerTurnBegin.Add(function() g_CoolDownTime = os.clock() + 1; end )		-- 1秒刷新取消：官方会正常刷新，1秒后是人类操作
Events.TurnEnd.Add( RemoveAllTimer )

function OnTPT_ClickCitizen( playerID, cityID )
	local pSelectedCity = CityManager.GetCity(playerID, cityID)
	local tParameters	:table = {};
	tParameters[CityCommandTypes.PARAM_MANAGE_CITIZEN] = UI.GetInterfaceModeParameter(CityCommandTypes.PARAM_MANAGE_CITIZEN);
	tParameters[CityCommandTypes.PARAM_X] = pSelectedCity:GetX();
	tParameters[CityCommandTypes.PARAM_Y] = pSelectedCity:GetY();

	local tResults :table = CityManager.RequestCommand( pSelectedCity, CityCommandTypes.MANAGE, tParameters );
	
	local FuncID = "Refresh_" .. tostring(cityID)
	AddTimer(2, RefreshBanner, false, FuncID, {playerID; cityID;}, true)
end

Events.CityWorkerChanged.Add(function( playerID, cityID )
	if playerID == Game.GetLocalPlayer() and os.clock() > g_CoolDownTime then
		local FuncID = "Refresh_" .. tostring(cityID)
		AddTimer(2, RefreshBanner, false, FuncID, {playerID; cityID;}, true)
	end
end)

Events.CityTileOwnershipChanged.Add(function( playerID, cityID )
	if playerID == Game.GetLocalPlayer() and os.clock() > g_CoolDownTime then
		local FuncID = "City_" .. tostring(cityID)
		AddTimer(4, OnTPT_ClickCitizen, false, FuncID, {playerID; cityID;}, true)
	end
end)

Events.CityPopulationChanged.Add(function(playerID, cityID)
	if playerID == Game.GetLocalPlayer() and os.clock() > g_CoolDownTime then
		local FuncID = "City_" .. tostring(cityID)
		AddTimer(4, OnTPT_ClickCitizen, false, FuncID, {playerID; cityID;}, true)
	end
end)

Events.PlotYieldChanged.Add(function(x, y)
	if os.clock() <= g_CoolDownTime then
		return
	end
	
	local pPlot = Map.GetPlot(x, y);
	local playerID = pPlot:GetOwner();

	if playerID == Game.GetLocalPlayer() then
		local pCity = Cities.GetPlotPurchaseCity(pPlot);
		if pCity ~= nil then
			local cityID = pCity:GetID();
			AddTimer(2, OnTPT_ClickCitizen, false, cityID, {playerID; cityID;}, true)
		end
	end
end)