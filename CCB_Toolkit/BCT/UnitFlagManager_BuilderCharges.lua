-- =================================================================================
-- Import base file
-- =================================================================================
local files = {
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
-- Cache base functions
-- =================================================================================
local BASE_Subscribe        = Subscribe;
local BASE_Unsubscribe      = Unsubscribe;
local BASE_UpdatePromotions	= UnitFlag.UpdatePromotions;

-- =================================================================================
-- Overrides
-- =================================================================================
function OnUnitChargesChanged(playerID, unitID)
    local flagInstance = GetUnitFlag(playerID, unitID);
    if flagInstance ~= nil then 
        flagInstance:UpdatePromotions();
    end
end

function UnitFlag.UpdatePromotions(self)
    local unit = self:GetUnit();
    if unit ~= nil and unit:GetUnitType() ~= -1 then
        local unitType = GameInfo.Units[unit:GetUnitType()].UnitType;
        if unitType == "UNIT_BUILDER" or unitType == "UNIT_MILITARY_ENGINEER" then
            -- The unit is a builder or military engineer, try updating it's builder charges.
            local buildCharges = unit:GetBuildCharges();
            if buildCharges > 0 then
                -- Only need to update if has charges.
                self.m_Instance.UnitNumPromotions:SetText(buildCharges);
                self.m_Instance.Promotion_Flag:SetHide(false);
            end
            return;
        end
    end
    BASE_UpdatePromotions(self);
end

function Subscribe()
    BASE_Subscribe();
    Events.UnitChargesChanged.Add(OnUnitChargesChanged);
end

function Unsubscribe()
    BASE_Unsubscribe();
    Events.UnitChargesChanged.Remove(OnUnitChargesChanged);
end
