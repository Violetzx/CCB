-- ======================================
-- 地图角落自动地图钉，以便小地图以全球比例显示。
-- ======================================
function OnLoadScreenClose()
	local plot_Fist = Map.GetPlotByIndex(0);
	local plot_Last = Map.GetPlotByIndex(Map.GetPlotCount() - 1);
	LuaEvents.MapPinPopup_RequestMapPin(plot_Fist:GetX(), plot_Fist:GetY());
	LuaEvents.MapPinPopup_RequestMapPin(plot_Last:GetX(), plot_Last:GetY());
	local Ctr = ContextPtr:LookUpControl("/InGame/MapPinPopup")
	UIManager:DequeuePopup( Ctr );
end
Events.LoadScreenClose.Add(OnLoadScreenClose)