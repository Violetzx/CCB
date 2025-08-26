--==========================================================================================================================
-- IMPROVEMENTS
--==========================================================================================================================
-- Types
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO Types	
		(Type,							Kind)
VALUES	('IMPROVEMENT_SUK_DUNON',		'KIND_IMPROVEMENT');		
--------------------------------------------------------------------------------------------------------------------------
-- Improvements
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO Improvements	
		(ImprovementType,			Name,								Description,								Icon, 							TraitType, 									Buildable, PlunderType)
SELECT	'IMPROVEMENT_SUK_DUNON',	'LOC_IMPROVEMENT_SUK_DUNON_NAME',	'LOC_IMPROVEMENT_SUK_DUNON_DESCRIPTION',	'ICON_IMPROVEMENT_SUK_DUNON',	'TRAIT_CIVILIZATION_IMPROVEMENT_SUK_DUNON',	Buildable, PlunderType
FROM Improvements WHERE ImprovementType = 'IMPROVEMENT_CHATEAU';

UPDATE Improvements
SET	
	OnePerCity				= 1,

	DefenseModifier			= 4,
	GrantFortification		= 2,

	Housing					= 2,
	TilesRequired			= 2,

	PlunderType				= 'PLUNDER_HEAL',
	PlunderAmount			= 100,

	PrereqCivic 			= 'CIVIC_DEFENSIVE_TACTICS'
WHERE ImprovementType = 'IMPROVEMENT_SUK_DUNON';
-----------------------------------------------------------------------------------
-- Improvement_ValidBuildUnits
-----------------------------------------------------------------------------------
INSERT INTO Improvement_ValidBuildUnits
			(ImprovementType,							UnitType)
VALUES 		('IMPROVEMENT_SUK_DUNON',					'UNIT_BUILDER');
-----------------------------------------------------------------------------------
-- Improvement_ValidResources
-----------------------------------------------------------------------------------
INSERT INTO Improvement_ValidResources	
		(ImprovementType,				ResourceType,					MustRemoveFeature)
SELECT	'IMPROVEMENT_SUK_DUNON',		ResourceType,					0
FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_CAMP','IMPROVEMENT_PASTURE');
-----------------------------------------------------------------------------------
-- Improvement_YieldChanges
-----------------------------------------------------------------------------------	
INSERT INTO Improvement_YieldChanges	
		(ImprovementType,				YieldType,						YieldChange)
VALUES	('IMPROVEMENT_SUK_DUNON',		'YIELD_FOOD',					1);
--==========================================================================================================================
-- +1 [ICON_Production] Production if built on a Hill
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- ImprovementModifiers
-------------------------------------
INSERT INTO ImprovementModifiers			
		(ImprovementType,						ModifierId)
VALUES	('IMPROVEMENT_SUK_DUNON', 				'SUK_DUNON_HILL_PRODUCTION');
-------------------------------------
-- Modifiers
-------------------------------------
INSERT INTO Modifiers	
		(ModifierId,						ModifierType,										SubjectRequirementSetId)
VALUES	('SUK_DUNON_HILL_PRODUCTION',		'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS', 			'SUK_DUNON_ON_HILL');
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,						Name,				Value)
VALUES	('SUK_DUNON_HILL_PRODUCTION',		'YieldType',		'YIELD_PRODUCTION'),
		('SUK_DUNON_HILL_PRODUCTION',		'Amount',			1);
----------------------------------------------------------------------------------------------------------------------------
-- Requirements
----------------------------------------------------------------------------------------------------------------------------			
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,					RequirementSetType)
VALUES	('SUK_DUNON_ON_HILL',				'REQUIREMENTSET_TEST_ALL');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------	
INSERT INTO RequirementSetRequirements
		(RequirementSetId,					RequirementId)
VALUES	('SUK_DUNON_ON_HILL',				'PLOT_IS_HILLS_REQUIREMENT');
--==========================================================================================================================
-- The Dunon must be built on a Camp or Pasture resource and provides that resource's yield modifier to adjacent tiles.
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- ImprovementModifiers
-------------------------------------
INSERT INTO ImprovementModifiers
		(ImprovementType,					ModifierId)
SELECT	'IMPROVEMENT_SUK_DUNON', 			'IMPROVEMENT_SUK_DUNON_' || ResourceType || '_' || YieldType
FROM Resource_YieldChanges WHERE ResourceType IN (SELECT ResourceType FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_CAMP','IMPROVEMENT_PASTURE'));
-------------------------------------
-- Modifiers
-------------------------------------	
INSERT INTO Modifiers
		(ModifierId,																	ModifierType,									OwnerRequirementSetId,				SubjectRequirementSetId)
SELECT	'IMPROVEMENT_SUK_DUNON_' || ResourceType || '_' || YieldType,					'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',			'SUK_DUNON_' || ResourceType,		'SUK_TORCS_AND_CARNYXES_IS_ADJACENT'
FROM Resource_YieldChanges WHERE ResourceType IN (SELECT ResourceType FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_CAMP','IMPROVEMENT_PASTURE'));
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,															Name,				Value)
SELECT	'IMPROVEMENT_SUK_DUNON_' || ResourceType || '_' || YieldType,			'YieldType',		YieldType
FROM Resource_YieldChanges WHERE ResourceType IN (SELECT ResourceType FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_CAMP','IMPROVEMENT_PASTURE'));

INSERT INTO ModifierArguments
		(ModifierId,															Name,				Value)
SELECT	'IMPROVEMENT_SUK_DUNON_' || ResourceType || '_' || YieldType,			'Amount',			YieldChange
FROM Resource_YieldChanges WHERE ResourceType IN (SELECT ResourceType FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_CAMP','IMPROVEMENT_PASTURE'));
----------------------------------------------------------------------------------------------------------------------------
-- Requirements
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,											RequirementSetType)
SELECT	'SUK_DUNON_' || ResourceType,								'REQUIREMENTSET_TEST_ALL'
FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_CAMP','IMPROVEMENT_PASTURE');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------
INSERT INTO RequirementSetRequirements
		(RequirementSetId,						RequirementId)
SELECT	'SUK_DUNON_' || ResourceType,			'REQUIRES_SUK_DUNON_' || ResourceType
FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_CAMP','IMPROVEMENT_PASTURE');

INSERT INTO RequirementSetRequirements
		(RequirementSetId,						RequirementId)
SELECT	'SUK_DUNON_' || ResourceType,			'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE'
FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_CAMP','IMPROVEMENT_PASTURE');
-------------------------------------
-- Requirements
-------------------------------------
INSERT INTO Requirements
		(RequirementId, 								RequirementType)
SELECT	'REQUIRES_SUK_DUNON_' || ResourceType,			'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES'
FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_CAMP','IMPROVEMENT_PASTURE');
-------------------------------------
-- RequirementArguments
-------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 								Name,					Value)
SELECT	'REQUIRES_SUK_DUNON_' || ResourceType, 			'ResourceType',			ResourceType
FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_CAMP','IMPROVEMENT_PASTURE');
--==========================================================================================================================
--==========================================================================================================================