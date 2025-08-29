local m_RangedAttackActionId = Input.GetActionId("RangedAttack");
function OnInputActionTriggered_CSA(actionId)
	if actionId == m_RangedAttackActionId then
		local pCity = UI.GetHeadSelectedCity()
		if CanRangeAttack(pCity) then
			UI.SetInterfaceMode(InterfaceModeTypes.CITY_RANGE_ATTACK);
		end
		return
	end
end
Events.InputActionTriggered.Add(OnInputActionTriggered_CSA)
