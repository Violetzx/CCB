--======================================================================================================================
-- SUK_VERCINGETORIX_COREFUNCTIONS
-- Author: Sukritact
--======================================================================================================================
print("Suk_Vercingetorix_CoreFunctions: Loaded")
--======================================================================================================================
-- UTILITY FUNCTIONS
--======================================================================================================================
--GetPlotsInRange

--This function returns an array of plots in a given radius of a tile, including itself
--(i.e, a radius of 1 would return 7 plots, the centre and 6 surrounding ones)
--------------------------------------------------------------
function GetPlotsInRange(iX, iY, iRange)
	local tTempTable = {}

	for dx = (iRange * -1), iRange do
		for dy = (iRange * -1), iRange do
			local pOtherPlot = Map.GetPlotXYWithRangeCheck(iX, iY, dx, dy, iRange);
			if pOtherPlot then
				table.insert(tTempTable, pOtherPlot)
			end
		end
	end

	return tTempTable
end
--======================================================================================================================
-- CORE FUNCTIONS
--======================================================================================================================
-- When an Oathsworn is killed in combat, all friendly adjacent land combat units heal for 40 HP.
------------------------------------------------------------------------------------------------------------------------
-- Defines
--------------------------------------------------------------
local iAbility		= GameInfo.Units.UNIT_SUK_OATHSWORN
						and	GameInfo.UnitAbilities.ABILITY_OATHSWORN_HEALING.Index
						or	GameInfo.UnitAbilities.ABILITY_SUK_GAUL_GAESATAE_HEALING.Index

local iHeal			= GameInfo.Units.UNIT_SUK_OATHSWORN
						and	40
						or	30

local tLandCombatUnits	= {}
for tRow in GameInfo.Units() do
	if tRow.FormationClass == 'FORMATION_CLASS_LAND_COMBAT' then
		tLandCombatUnits[tRow.Index] = true
	end
end
--------------------------------------------------------------
-- Core
--------------------------------------------------------------
function ProcessOathswornCombat(tUnit)

	tUnit.IsUnit 	= tUnit[CombatResultParameters.ID].type == ComponentType.UNIT
	if not(tUnit.IsUnit) then return end

	tUnit.IsDead 	= tUnit[CombatResultParameters.FINAL_DAMAGE_TO] >= tUnit[CombatResultParameters.MAX_HIT_POINTS]
	tUnit.playerID 	= tUnit[CombatResultParameters.ID].player
	tUnit.unitID 	= tUnit[CombatResultParameters.ID].id
	if not(tUnit.IsDead) then return end

	tUnit.unit		= UnitManager.GetUnit(tUnit.playerID, tUnit.unitID)
	if not tUnit.unit then return end

	local pUnitAbility = tUnit.unit:GetAbility()
	if not pUnitAbility then return end

	if not pUnitAbility:HasAbility(iAbility) then return end

	tUnit.X = tUnit[CombatResultParameters.LOCATION].x
	tUnit.Y = tUnit[CombatResultParameters.LOCATION].y

	if tUnit.X > -1 then
		local tPlots = GetPlotsInRange(tUnit.X, tUnit.Y, 1)
		for _, pAdjacentPlot in pairs(tPlots) do
			local tUnitList = Units.GetUnitsInPlotLayerID(pAdjacentPlot:GetX(), pAdjacentPlot:GetY(), MapLayers.ANY);
			for _, pUnit in pairs(tUnitList) do
				if pUnit:GetOwner() == tUnit.playerID then
					local iUnitType = pUnit:GetType() or -1
					if tLandCombatUnits[iUnitType] then
						pUnit:ChangeDamage(-iHeal)
					end
				end
			end
		end
	end

end
--------------------------------------------------------------
-- Hook up event
--------------------------------------------------------------
function OnCombat( tCombatResult )

	local tAttacker = tCombatResult[CombatResultParameters.ATTACKER]
	local tDefender = tCombatResult[CombatResultParameters.DEFENDER]
	ProcessOathswornCombat(tAttacker)
	ProcessOathswornCombat(tDefender)

end
-- Events.Combat.Add( OnCombat )
--======================================================================================================================
--======================================================================================================================