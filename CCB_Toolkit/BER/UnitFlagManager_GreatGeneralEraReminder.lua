-- =================================================================================
-- Import base file
-- =================================================================================
local files = {
	"UnitFlagManager_BuilderCharges.lua",
    "UnitFlagManager_BarbarianClansMode.lua",
    "UnitFlagManager.lua",
}

for _, file in ipairs(files) do
    include(file)
    if Initialize then
        print("Loading " .. file .. " as base file");
        break
    end
end

-- =================================================================================
-- Globe
-- =================================================================================
local Show_BER = false

-- =================================================================================
-- Cache base functions
-- =================================================================================
local TPT_BASE_UpdatePromotions = UnitFlag.UpdatePromotions;

-- =================================================================================
-- Overrides
-- =================================================================================
function UnitFlag.UpdatePromotions(self)
	if Show_BER then
		local unit = self:GetUnit();
		if unit ~= nil and unit:GetUnitType() ~= -1 then
			local unitType = GameInfo.Units[unit:GetUnitType()].UnitType;
			if unitType == "UNIT_GREAT_GENERAL" or unitType == "UNIT_GREAT_ADMIRAL" then
				local individual = unit:GetGreatPerson():GetIndividual();
				if individual >= 0 then
					local EraType = GameInfo.GreatPersonIndividuals[individual].EraType;
					local EraText = "[Size_14]"..Locale.Lookup(GameInfo.Eras[EraType].Name)
					self.m_Instance.UnitNumPromotions:SetText(EraText);
					self.m_Instance.UnitNumPromotions:SetColor(1,1,1)
					self.m_Instance.UnitNumPromotions:SetOffsetVal(0,1)
					self.m_Instance.Promotion_Flag:SetHide(false);
					self.m_Instance.Promotion_Flag:SetTexture("ActionPanel_TurnTimerFrame");
					self.m_Instance.Promotion_Flag:SetAnchor("C,B")
					self.m_Instance.Promotion_Flag:SetOffsetVal(0,-6)
					self.m_Instance.Promotion_Flag:SetSizeVal(110, 20)
					return;
				end
			else
				if self.m_Instance.Promotion_Flag:GetAnchor() == "C,B" then
					self.m_Instance.UnitNumPromotions:SetColor(0,0,0)
					self.m_Instance.UnitNumPromotions:SetOffsetVal(0,0)
					self.m_Instance.Promotion_Flag:SetTexture("UnitFlag_Promo.dds");
					self.m_Instance.Promotion_Flag:SetAnchor("R,C")
					self.m_Instance.Promotion_Flag:SetOffsetVal(-8,0)
					self.m_Instance.Promotion_Flag:SetSizeVal(20,25)
				end
			end
		end
	end
	TPT_BASE_UpdatePromotions(self)
end

function OnTPT_Settings_Toggle(ParameterId, Value)
	if ParameterId == "GreatGeneralEraReminder_Show" then
		Show_BER = Value
		return
	end
end
LuaEvents.TPT_Settings_Toggle.Add(OnTPT_Settings_Toggle)