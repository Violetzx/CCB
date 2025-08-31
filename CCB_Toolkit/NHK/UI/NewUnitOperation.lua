local m_PromoteActionId = Input.GetActionId("ExtraHotkeysPromote");
local m_FastPromoteActionId = Input.GetActionId("HotKey_TPT_FastPromote");
--local m_CancelAllActionId = Input.GetActionId("HotKey_TPT_CancelAll");
--local m_FortifyAllActionId = Input.GetActionId("HotKey_TPT_FortifyAll");

function OnInputActionTriggered_CSA(actionId)
	if actionId == m_PromoteActionId then
		local pSelectedUnit = UI.GetHeadSelectedUnit();
		if pSelectedUnit ~= nil then
			if UnitManager.CanStartCommand(pSelectedUnit, UnitCommandTypes.CANCEL) and GameInfo.Units[pSelectedUnit:GetType()].UnitType ~= "UNIT_SPY" then
				UnitManager.RequestCommand(pSelectedUnit, UnitCommandTypes.CANCEL)				
			end
		end
		return
	end
	
	if actionId == m_FastPromoteActionId then
		local pSelectedUnit = UI.GetHeadSelectedUnit();
		if pSelectedUnit ~= nil then	
			local bCanStart, tResults = UnitManager.CanStartCommand( pSelectedUnit, UnitCommandTypes.PROMOTE, true, true);
			if UnitManager.CanStartCommand(pSelectedUnit, UnitCommandTypes.CANCEL) and GameInfo.Units[pSelectedUnit:GetType()].UnitType ~= "UNIT_SPY" then
				UnitManager.RequestCommand(pSelectedUnit, UnitCommandTypes.CANCEL)				
			end
			if (bCanStart and tResults) then
				if (tResults[UnitCommandResults.PROMOTIONS] ~= nil and #tResults[UnitCommandResults.PROMOTIONS] ~= 0) then
					local tPromotions		= tResults[UnitCommandResults.PROMOTIONS];
					local item_index = math.random(1,#tPromotions)		-- 随机选择升级
					local tParameters = {};
					tParameters[UnitCommandTypes.PARAM_PROMOTION_TYPE] = tPromotions[item_index];
					UnitManager.RequestCommand( pSelectedUnit, UnitCommandTypes.PROMOTE, tParameters );
				end
			end
		end
		return
	end	
--[[	
	if actionId == m_CancelAllActionId then
		UI.PlaySound("Play_UI_Click");
		local pPlayer = Players[Game.GetLocalPlayer()];
		for i, pUnit in pPlayer:GetUnits():Members() do
			if GameInfo.Units[pUnit:GetType()].UnitType ~= "UNIT_SPY" then
				if UnitManager.CanStartCommand(pUnit, UnitCommandTypes.CANCEL) then
					UnitManager.RequestCommand(pUnit, UnitCommandTypes.CANCEL);
				end
				if UnitManager.CanStartCommand(pUnit, UnitCommandTypes.WAKE) then
					UnitManager.RequestCommand(pUnit, UnitCommandTypes.WAKE);
				end				
			end
		end
		return
	end
	
	if actionId == m_FortifyAllActionId then
		UI.PlaySound("Play_UI_Click");
		local pPlayer = Players[Game.GetLocalPlayer()];
		for i, pUnit in pPlayer:GetUnits():Members() do		
			if UnitManager.CanStartOperation(pUnit, UnitOperationTypes.FORTIFY) then
				UnitManager.RequestOperation(pUnit, UnitOperationTypes.FORTIFY)
			end			
		end
		return
	end
	]]
end
Events.InputActionTriggered.Add(OnInputActionTriggered_CSA)