-- ===========================================================================
-- INCLUDES
-- ===========================================================================
local files = {
	"unitpanel_spec.lua",
    "UnitPanel_Expansion2.lua",
    "UnitPanel_Expansion1.lua",
    "UnitPanel.lua",
}

for _, file in ipairs(files) do
    include(file)
    if Initialize then
        print("Loading " .. file .. " as base file");
        break
    end
end

-- ===========================================================================
--	OVERRIDE
-- ===========================================================================
function OnUnitActionClicked_FoundCity(kResults:table)
	if (g_isOkayToProcess) then
		local pSelectedUnit = UI.GetHeadSelectedUnit();
		if ( pSelectedUnit ~= nil ) then
			if kResults ~= nil and table.count(kResults) ~= 0 then
				local popupString:string = Locale.Lookup("LOC_FOUND_CITY_CONFIRM_POPUP");
				if (kResults[UnitOperationResults.FEATURE_TYPE] ~= nil) then
					local featureName = GameInfo.Features[kResults[UnitOperationResults.FEATURE_TYPE]].Name;
					popupString = popupString .. "[NEWLINE]" .. Locale.Lookup("LOC_FOUND_CITY_WILL_REMOVE_FEATURE", featureName);
				end			
--				Request confirmation		移除了坐城提示，不用再为在地貌上坐城点确定了
--				local pPopupDialog :table = PopupDialogInGame:new("FoundCityAt"); -- unique identifier
--				pPopupDialog:AddText(popupString);
--				pPopupDialog:AddConfirmButton(Locale.Lookup("LOC_YES"), function()
				UnitManager.RequestOperation( pSelectedUnit, UnitOperationTypes.FOUND_CITY );
--				end);
--				pPopupDialog:AddCancelButton(Locale.Lookup("LOC_NO"), nil);
--				pPopupDialog:Open();
			else
				UnitManager.RequestOperation( pSelectedUnit, UnitOperationTypes.FOUND_CITY );
			end
		end
	end
	if UILens.IsLayerOn( m_HexColoringWaterAvail ) then
		UILens.ToggleLayerOff(m_HexColoringWaterAvail);
	end
	UILens.SetActive("Default");
end