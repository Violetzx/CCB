function Initialize()
    local ctr = ContextPtr:LookUpControl("/InGame/EndGameMenu/ButtonStack")
    local EndGameMenu = ContextPtr:LookUpControl("/InGame/EndGameMenu")
    Controls.NewBackButton:ChangeParent(ctr)    
	Controls.NewBackButton:RegisterCallback( Mouse.eLClick, function()
		EndGameMenu:SetHide(true);
	end );
	Controls.NewBackButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
end
Events.LoadScreenClose.Add(Initialize)
