--==========================================================================================================================
-- Units
--==========================================================================================================================
-- Types
-----------------------------------------------------------------------------------	
INSERT INTO Types	
		(Type,						Kind)
VALUES	('UNIT_SUK_TIBET_RTA_PA',			'KIND_UNIT');
-----------------------------------------------------------------------------------
-- Units
-----------------------------------------------------------------------------------
INSERT INTO Units
		(
			UnitType,
			Name, 
			Description,

			Cost,
			Maintenance,
			StrategicResource,
			PurchaseYield,

			BaseMoves,
			BaseSightRange,
			ZoneOfControl,

			Combat,
			RangedCombat,
			Range,

			Domain,
			PromotionClass,
			FormationClass,
			AdvisorType,

			PrereqTech,
			MandatoryObsoleteTech,
			PrereqCivic,
			MandatoryObsoleteCivic,
			TraitType
		)
SELECT			
			'UNIT_SUK_TIBET_RTA_PA',
			'LOC_UNIT_SUK_TIBET_RTA_PA_NAME', 
			'LOC_UNIT_SUK_TIBET_RTA_PA_DESCRIPTION',

			Cost,
			Maintenance,
			StrategicResource,
			PurchaseYield,

			BaseMoves,
			BaseSightRange,
			ZoneOfControl,

			46,
			44,
			1,

			Domain,
			PromotionClass,
			FormationClass,
			AdvisorType,

			'TECH_MILITARY_TACTICS',
			'TECH_GUNPOWDER',
			PrereqCivic,
			MandatoryObsoleteCivic,
			'TRAIT_CIVILIZATION_UNIT_SUK_RTA_PA'

FROM Units WHERE UnitType = 'UNIT_MAN_AT_ARMS';
INSERT INTO UnitReplaces(civuniqueunittype, replacesunittype) VALUES 
('UNIT_SUK_TIBET_RTA_PA','UNIT_MAN_AT_ARMS');

-- 风云变幻扩展包给Units表补充的额外信息
INSERT INTO Units_XP2(UnitType, ResourceMaintenanceAmount, ResourceCost, ResourceMaintenanceType, TourismBomb,
                      CanEarnExperience, TourismBombPossible, CanFormMilitaryFormation, MajorCivOnly, CanCauseDisasters,
                      CanSacrificeUnits)
SELECT 'UNIT_SUK_TIBET_RTA_PA',
       ResourceMaintenanceAmount, -- 每回合消耗的战略资源数量
       10, -- 建造单位需要的战略资源数量
       ResourceMaintenanceType, -- 战略资源维护
       TourismBomb,
       CanEarnExperience,
       TourismBombPossible,
       CanFormMilitaryFormation, -- 是否能组成军团或军队
       MajorCivOnly, -- 是否只有主要文明才能建造
       CanCauseDisasters, -- 是否能召唤灾难
       CanSacrificeUnits
FROM Units_XP2
WHERE UnitType = 'UNIT_MAN_AT_ARMS';

-----------------------------------------------------------------------------------
-- UnitUpgrades
-----------------------------------------------------------------------------------
INSERT INTO UnitUpgrades
			(Unit,								UpgradeUnit)
SELECT 		'UNIT_SUK_TIBET_RTA_PA',			UpgradeUnit
FROM UnitUpgrades WHERE Unit = 'UNIT_MAN_AT_ARMS';
-----------------------------------------------------------------------------------
-- UnitAiInfos
-----------------------------------------------------------------------------------
INSERT INTO UnitAiInfos
			(UnitType,							AiType)
SELECT 		'UNIT_SUK_TIBET_RTA_PA',			AiType
FROM UnitAiInfos WHERE UnitType = 'UNIT_MAN_AT_ARMS';
-----------------------------------------------------------------------------------
-- TypeTags
-----------------------------------------------------------------------------------
INSERT OR REPLACE INTO TypeTags
			(Type,								Tag)
VALUES		('UNIT_SUK_TIBET_RTA_PA',			'CLASS_SUK_TIBET_RTA_PA');

INSERT INTO TypeTags
			(Type,								Tag)
SELECT 		'UNIT_SUK_TIBET_RTA_PA',			Tag
FROM TypeTags WHERE Type = 'UNIT_MAN_AT_ARMS';
-----------------------------------------------------------------------------------
-- Tags
-----------------------------------------------------------------------------------
INSERT INTO Tags
			(Tag,								Vocabulary)
VALUES		('CLASS_SUK_TIBET_RTA_PA',			'ABILITY_CLASS');
-------------------------------------
-- MomentIllustrations
-------------------------------------
INSERT INTO MomentIllustrations
		(MomentIllustrationType, 					MomentDataType,				GameDataType,					Texture)
VALUES	('MOMENT_ILLUSTRATION_UNIQUE_UNIT', 		'MOMENT_DATA_UNIT',			'UNIT_SUK_TIBET_RTA_PA',		'Moment_UniqueUnit_Suk_Tibet.dds');
--==========================================================================================================================
--==========================================================================================================================


INSERT  INTO Types(Type, Kind)
VALUES ( 'ABILITY_CCB_TBCSJ_ADD_MOVEMENT','KIND_ABILITY');
INSERT  INTO TypeTags(Type,Tag)
VALUES ('ABILITY_CCB_TBCSJ_ADD_MOVEMENT','CLASS_SUK_TIBET_RTA_PA');
INSERT  INTO UnitAbilities(UnitAbilityType,Name,Description)
VALUES ( 'ABILITY_CCB_TBCSJ_ADD_MOVEMENT' ,'LOC_ABILITY_CCB_TBCSJ_ADD_MOVEMENT_NAME','LOC_ABILITY_CCB_TBCSJ_ADD_MOVEMENT_DESCRIPTION');
INSERT  INTO UnitAbilityModifiers(UnitAbilityType,ModifierId)
VALUES ( 'ABILITY_CCB_TBCSJ_ADD_MOVEMENT', 'ABILITY_CCB_TBCSJ_ADD_MOVEMENT_CCB_TB');
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES
('ABILITY_CCB_TBCSJ_ADD_MOVEMENT_CCB_TB', 'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT', 0, 0, 0, NULL, 'CCB_UNIT_TB_REQUIREMENT');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
('ABILITY_CCB_TBCSJ_ADD_MOVEMENT_CCB_TB', 'Amount', '1');

-- RequirementSets
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
('CCB_UNIT_TB_REQUIREMENT', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
('CCB_UNIT_TB_REQUIREMENT', 'REQ_TERRAIN_IS_CLASS_SNOW'),
('CCB_UNIT_TB_REQUIREMENT', 'REQ_TERRAIN_IS_CLASS_TUNDRA');

-- Requirements
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
('REQ_TERRAIN_IS_CLASS_SNOW', 'REQUIREMENT_PLOT_TERRAIN_CLASS_MATCHES'),
('REQ_TERRAIN_IS_CLASS_TUNDRA', 'REQUIREMENT_PLOT_TERRAIN_CLASS_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
('REQ_TERRAIN_IS_CLASS_SNOW', 'TerrainClass', 'TERRAIN_CLASS_SNOW'),
('REQ_TERRAIN_IS_CLASS_TUNDRA', 'TerrainClass', 'TERRAIN_CLASS_TUNDRA');