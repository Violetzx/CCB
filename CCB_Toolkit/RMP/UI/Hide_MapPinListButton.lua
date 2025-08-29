function OnLoadScreenClose()
	local MapPinListButton = ContextPtr:LookUpControl("/InGame/MinimapPanel/MapPinListButton")
	MapPinListButton:SetHide(true);
end
Events.LoadScreenClose.Add(OnLoadScreenClose)