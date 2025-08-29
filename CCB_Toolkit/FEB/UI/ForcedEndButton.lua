local Show_FEB = false

function OnTPT_Settings_Toggle(ParameterId, Value)
	if ParameterId == "ForcedEndButton_Show" then
		Show_FEB = Value
		Controls.ForcedEnd_Button:SetHide(not Show_FEB)
		return
	end
end

function LateInitialize()
	local ctr = ContextPtr:LookUpControl("/InGame/ActionPanel")
	Controls.ForcedEnd_Button:ChangeParent(ctr)
	Controls.ForcedEnd_Button:SetToolTipString(Locale.Lookup("LOC_FORCEEND_TT"))
	Controls.ForcedEnd_Button:RegisterCallback(	Mouse.eLClick, function() UI.RequestAction(ActionTypes.ACTION_ENDTURN, { REASON = "UserForced" } ); end);
	Controls.ForcedEnd_Button:RegisterCallback(	Mouse.eRClick, function() LuaEvents.ForcedEndTurn(); end);
	Controls.ForcedEnd_Button:SetHide(not Show_FEB)
end

function Initialize()
	Events.LoadScreenClose.Add(LateInitialize)
	LuaEvents.TPT_Settings_Toggle.Add(OnTPT_Settings_Toggle)
end
Initialize()