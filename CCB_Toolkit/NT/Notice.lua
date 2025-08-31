function OnLoadScreenClose()
	local msgString = ""
	local sumString = ""
	if GameConfiguration.GetValue("NEW_HOTKEYS") == true then
		msgString = Locale.Lookup("LOC_TPT_NOTIFICATION_NEW_HOTKEYS_MESSAGE");
		sumString = Locale.Lookup("LOC_TPT_NOTIFICATION_NEW_HOTKEYS_SUMMARY");
		NotificationManager.SendNotification(Players[Game.GetLocalPlayer()], NotificationTypes.REBELLION,msgString,sumString)
	end
	if GameConfiguration.GetValue("CPL_NO_PINS") == true then
		msgString = Locale.Lookup("LOC_TPT_NOTIFICATION_NO_PINS_MESSAGE");
		sumString = Locale.Lookup("LOC_TPT_NOTIFICATION_NO_PINS_SUMMARY");
		NotificationManager.SendNotification(Players[Game.GetLocalPlayer()], NotificationTypes.SPY_ENEMY_CAPTURED,msgString,sumString)
	end
end
Events.LoadScreenClose.Add( OnLoadScreenClose );