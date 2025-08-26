--==========================================================================================================================
-- Districts
--==========================================================================================================================
-- Types
-----------------------------------------------------------------------------------	
INSERT INTO Types	
		(Type,									Kind)
VALUES	('DISTRICT_SUK_DZONG',			'KIND_DISTRICT');
-----------------------------------------------------------------------------------
-- Districts
-----------------------------------------------------------------------------------
INSERT INTO Districts
			(DistrictType,				Name,								Description,								TraitType,										Cost,		PrereqTech,		Aqueduct,	AllowsHolyCity,		PlunderType,		PlunderAmount,		AdvisorType,		CostProgressionModel,		CostProgressionParam1,		RequiresPlacement,		RequiresPopulation,		NoAdjacentCity,		InternalOnly,		ZOC,		CaptureRemovesBuildings,		CaptureRemovesCityDefenses,		MilitaryDomain,		TravelTime,		CityStrengthModifier)
SELECT		'DISTRICT_SUK_DZONG',		'LOC_DISTRICT_SUK_DZONG_NAME',		'LOC_DISTRICT_SUK_DZONG_DESCRIPTION',		'TRAIT_CIVILIZATION_DISTRICT_SUK_DZONG',		Cost/2,		PrereqTech,		Aqueduct,	AllowsHolyCity,		PlunderType,		PlunderAmount,		AdvisorType,		CostProgressionModel,		CostProgressionParam1,		RequiresPlacement,		RequiresPopulation,		NoAdjacentCity,		InternalOnly,		ZOC,		CaptureRemovesBuildings,		CaptureRemovesCityDefenses,		MilitaryDomain,		TravelTime,		CityStrengthModifier
FROM Districts WHERE DistrictType = 'DISTRICT_HOLY_SITE';
-----------------------------------------------------------------------------------
-- DistrictReplaces
-----------------------------------------------------------------------------------
INSERT INTO DistrictReplaces
			(CivUniqueDistrictType,					ReplacesDistrictType)
VALUES		('DISTRICT_SUK_DZONG',					'DISTRICT_HOLY_SITE');
-----------------------------------------------------------------------------------
-- District_GreatPersonPoints
-----------------------------------------------------------------------------------
INSERT INTO District_GreatPersonPoints
			(DistrictType,					GreatPersonClassType,		PointsPerTurn)
SELECT 		'DISTRICT_SUK_DZONG',			GreatPersonClassType,		PointsPerTurn
FROM District_GreatPersonPoints WHERE DistrictType = 'DISTRICT_HOLY_SITE';
-----------------------------------------------------------------------------------
-- District_TradeRouteYields
-----------------------------------------------------------------------------------
INSERT INTO District_TradeRouteYields
			(DistrictType,					YieldType,	YieldChangeAsOrigin,	YieldChangeAsDomesticDestination,	YieldChangeAsInternationalDestination)
SELECT 		'DISTRICT_SUK_DZONG',			YieldType,	YieldChangeAsOrigin,	YieldChangeAsDomesticDestination,	YieldChangeAsInternationalDestination
FROM District_TradeRouteYields WHERE DistrictType = 'DISTRICT_HOLY_SITE';
-----------------------------------------------------------------------------------
-- District_ValidTerrains
-----------------------------------------------------------------------------------
INSERT INTO District_ValidTerrains
			(DistrictType,					TerrainType)
SELECT 		'DISTRICT_SUK_DZONG',			TerrainType
FROM District_ValidTerrains WHERE DistrictType = 'DISTRICT_ACROPOLIS';
-----------------------------------------------------------------------------------
-- District_Adjacencies
-----------------------------------------------------------------------------------
INSERT INTO District_Adjacencies
			(DistrictType,					YieldChangeId)
SELECT 		'DISTRICT_SUK_DZONG',			YieldChangeId
FROM District_Adjacencies WHERE DistrictType = 'DISTRICT_HOLY_SITE';
-----------------------------------------------------------------------------------
-- District_CitizenYieldChanges
-----------------------------------------------------------------------------------
INSERT INTO District_CitizenYieldChanges
			(DistrictType,					YieldType,		YieldChange)
SELECT 		'DISTRICT_SUK_DZONG',			YieldType,		YieldChange
FROM District_CitizenYieldChanges WHERE DistrictType = 'DISTRICT_HOLY_SITE';
-----------------------------------------------------------------------------------
-- DistrictModifiers
-----------------------------------------------------------------------------------
INSERT INTO DistrictModifiers
			(DistrictType,					ModifierId)
SELECT 		'DISTRICT_SUK_DZONG',			ModifierId
FROM DistrictModifiers WHERE DistrictType = 'DISTRICT_HOLY_SITE';
--==========================================================================================================================
-- Modifiers
--==========================================================================================================================
-- Buildings in the Dzong district are 20% cheaper to purchase with [ICON_GOLD] Gold and [ICON_FAITH] Faith.
----------------------------------------------------------------------------------------------------------------------------
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,																Kind)
VALUES	('MODIFIER_SUK_DZONG_OWNER_ADJUST_BUILDING_PURCHASE_COST',			'KIND_MODIFIER');
-------------------------------------
-- DynamicModifiers
-------------------------------------					
INSERT INTO DynamicModifiers			
		(ModifierType,														CollectionType,			EffectType)
VALUES	('MODIFIER_SUK_DZONG_OWNER_ADJUST_BUILDING_PURCHASE_COST',			'COLLECTION_OWNER',		'EFFECT_ADJUST_BUILDING_PURCHASE_COST');
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- DistrictModifiers
-------------------------------------
INSERT INTO DistrictModifiers			
		(DistrictType,					ModifierId)
SELECT 	'DISTRICT_SUK_DZONG',			'SUK_DZONG_' || BuildingType
FROM Buildings WHERE PrereqDistrict = 'DISTRICT_HOLY_SITE';
--------------------------------------------------------------------------------------------------------------------------
-- Modifiers
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO Modifiers	
		(ModifierId,							ModifierType)
SELECT	'SUK_DZONG_' || BuildingType,			'MODIFIER_SUK_DZONG_OWNER_ADJUST_BUILDING_PURCHASE_COST'
FROM Buildings WHERE PrereqDistrict = 'DISTRICT_HOLY_SITE';
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,							Name,						Value)
SELECT	'SUK_DZONG_' || BuildingType,			'BuildingType',				BuildingType
FROM Buildings WHERE PrereqDistrict = 'DISTRICT_HOLY_SITE';

INSERT INTO ModifierArguments
		(ModifierId,							Name,						Value)
SELECT	'SUK_DZONG_' || BuildingType,			'Amount',					20
FROM Buildings WHERE PrereqDistrict = 'DISTRICT_HOLY_SITE';
----------------------------------------------------------------------------------------------------------------------------
-- Occupying unit receives +7 [ICON_Strength] Defense Strength.
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,										ModifierId)
VALUES 	('TRAIT_CIVILIZATION_DISTRICT_SUK_DZONG',		'SUK_DZONG_DEFENSE_STRENGTH');
-------------------------------------
-- Modifiers
-------------------------------------
INSERT INTO Modifiers	
		(ModifierId,						ModifierType,										SubjectRequirementSetId)
VALUES	('SUK_DZONG_DEFENSE_STRENGTH',		'MODIFIER_PLAYER_UNITS_ADJUST_COMBAT_STRENGTH',		'SUK_DZONG_IS_DEFENDER_ON_FRIENDLY_DZONG');
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,								Name,							Value)
VALUES	('SUK_DZONG_DEFENSE_STRENGTH',				'Amount',						10);
----------------------------------------------------------------------------------------------------------------------------
-- REQUIREMENTS
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,															RequirementSetType)
VALUES	('SUK_DZONG_IS_DEFENDER_ON_FRIENDLY_DZONG',									'REQUIREMENTSET_TEST_ALL');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------	
INSERT INTO RequirementSetRequirements
		(RequirementSetId,											RequirementId)
VALUES	('SUK_DZONG_IS_DEFENDER_ON_FRIENDLY_DZONG',					'PLAYER_IS_DEFENDER_REQUIREMENTS'),
		('SUK_DZONG_IS_DEFENDER_ON_FRIENDLY_DZONG',					'SUK_DZONG_PLOT_IS_FRIENDLY'),
		('SUK_DZONG_IS_DEFENDER_ON_FRIENDLY_DZONG',					'SUK_DZONG_PLOT_IS_DZONG');
-------------------------------------
-- Requirements
-------------------------------------
INSERT INTO Requirements
		(RequirementId, 										RequirementType)
VALUES	('SUK_DZONG_PLOT_IS_FRIENDLY',							'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_TERRITORY'),
		('SUK_DZONG_PLOT_IS_DZONG',								'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES');
-------------------------------------
-- RequirementArguments
-------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 						Name,					Value)
VALUES	('SUK_DZONG_PLOT_IS_FRIENDLY', 			'MaxRange',				0),
		('SUK_DZONG_PLOT_IS_FRIENDLY', 			'MinRange',				0),

		('SUK_DZONG_PLOT_IS_DZONG', 			'DistrictType',			'DISTRICT_SUK_DZONG');
-------------------------------------
-- MomentIllustrations
-------------------------------------
INSERT INTO MomentIllustrations
		(MomentIllustrationType, 						MomentDataType,					GameDataType,					Texture)
VALUES	('MOMENT_ILLUSTRATION_UNIQUE_DISTRICT', 		'MOMENT_DATA_DISTRICT',			'DISTRICT_SUK_DZONG',			'Moment_Infrastructure_Suk_Tibet.dds');			
--==========================================================================================================================
--==========================================================================================================================