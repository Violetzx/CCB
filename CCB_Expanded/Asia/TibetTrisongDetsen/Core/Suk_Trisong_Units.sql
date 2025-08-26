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

			250,
			4,
			StrategicResource,
			PurchaseYield,

			3,
			BaseSightRange,
			ZoneOfControl,

			55,
			58,
			1,

			Domain,
			PromotionClass,
			FormationClass,
			AdvisorType,

			'TECH_ASTRONOMY',
			'TECH_ADVANCED_BALLISTICS',
			NULL,
			NULL,
			'TRAIT_CIVILIZATION_UNIT_SUK_RTA_PA'

FROM Units WHERE UnitType = 'UNIT_MONGOLIAN_KESHIG';
-----------------------------------------------------------------------------------
-- UnitUpgrades
-----------------------------------------------------------------------------------
INSERT INTO UnitUpgrades
			(Unit,								UpgradeUnit)
VALUES 		('UNIT_SUK_TIBET_RTA_PA',			'UNIT_MACHINE_GUN');
-----------------------------------------------------------------------------------
-- UnitAiInfos
-----------------------------------------------------------------------------------
INSERT INTO UnitAiInfos
			(UnitType,							AiType)
SELECT 		'UNIT_SUK_TIBET_RTA_PA',			AiType
FROM UnitAiInfos WHERE UnitType = 'UNIT_MONGOLIAN_KESHIG';
-----------------------------------------------------------------------------------
-- TypeTags
-----------------------------------------------------------------------------------
INSERT OR REPLACE INTO TypeTags
			(Type,								Tag)
VALUES		('UNIT_SUK_TIBET_RTA_PA',			'CLASS_SUK_TIBET_RTA_PA'),
			('ABILITY_SUK_TIBET_RTA_PA',		'CLASS_SUK_TIBET_RTA_PA');

INSERT INTO TypeTags
			(Type,								Tag)
SELECT 		'UNIT_SUK_TIBET_RTA_PA',			Tag
FROM TypeTags WHERE Type = 'UNIT_MONGOLIAN_KESHIG' AND Tag != 'CLASS_MONGOLIAN_KESHIG';
-----------------------------------------------------------------------------------
-- Tags
-----------------------------------------------------------------------------------
INSERT INTO Tags
			(Tag,								Vocabulary)
VALUES		('CLASS_SUK_TIBET_RTA_PA',			'ABILITY_CLASS');
--==========================================================================================================================
-- Abilities
--==========================================================================================================================
-- Types
-----------------------------------------------------------------------------------	
INSERT INTO Types	
		(Type,										Kind)
VALUES	('ABILITY_SUK_TIBET_RTA_PA',				'KIND_ABILITY');
-------------------------------------
-- UnitAbilities
-------------------------------------					
INSERT INTO UnitAbilities			
		(UnitAbilityType,							Name,										Description)
VALUES	('ABILITY_SUK_TIBET_RTA_PA',				'LOC_ABILITY_SUK_TIBET_RTA_PA_NAME',		'LOC_ABILITY_SUK_TIBET_RTA_PA_DESCRIPTION');
-------------------------------------
-- UnitAbilityModifiers
-------------------------------------
INSERT INTO UnitAbilityModifiers	
		(UnitAbilityType,							ModifierId)
VALUES	('ABILITY_SUK_TIBET_RTA_PA',				'SUK_RTA_PA_MOVE_AFTER_ATTACKING'),
		('ABILITY_SUK_TIBET_RTA_PA',				'SUK_RTA_PA_IGNORE_HILLS');
--==========================================================================================================================
-- MODIFIERS
--==========================================================================================================================
-- Modifiers
-------------------------------------					
INSERT INTO Modifiers			
		(ModifierId,										ModifierType,												SubjectRequirementSetId)
VALUES	('SUK_RTA_PA_MOVE_AFTER_ATTACKING',					'MODIFIER_PLAYER_UNIT_ADJUST_ATTACK_AND_MOVE',				NULL),
		('SUK_RTA_PA_IGNORE_HILLS',							'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_TERRAIN_COST',			NULL);
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,										Name,			Value)
VALUES	('SUK_RTA_PA_MOVE_AFTER_ATTACKING',					'CanMove',		1),
		('SUK_RTA_PA_IGNORE_HILLS',							'Ignore',		1),
		('SUK_RTA_PA_IGNORE_HILLS',							'Type',			'HILLS');
-------------------------------------
-- MomentIllustrations
-------------------------------------
INSERT INTO MomentIllustrations
		(MomentIllustrationType, 					MomentDataType,				GameDataType,					Texture)
VALUES	('MOMENT_ILLUSTRATION_UNIQUE_UNIT', 		'MOMENT_DATA_UNIT',			'UNIT_SUK_TIBET_RTA_PA',		'Moment_UniqueUnit_Suk_Tibet.dds');
--==========================================================================================================================
--==========================================================================================================================