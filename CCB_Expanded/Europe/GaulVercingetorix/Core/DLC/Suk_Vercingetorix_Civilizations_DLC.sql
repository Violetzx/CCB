--==========================================================================================================================
-- CIVILIZATIONS
--==========================================================================================================================
-- Traits
-------------------------------------
UPDATE Traits
	SET Description = 'LOC_TRAIT_CIVILIZATION_GAUL_DESCRIPTION_REWORK'
	WHERE TraitType = 'TRAIT_CIVILIZATION_GAUL';
-------------------------------------
-- TraitModifiers
-------------------------------------
DELETE FROM TraitModifiers
	WHERE TraitType = 'TRAIT_CIVILIZATION_GAUL'
	AND ModifierId IN ('GAUL_MINE_CULTURE', 'TRAIT_CIVILIZATION_GAUL_CITY_NO_ADJACENT_DISTRICT');
-------------------------------------
-- StartBiasResources
-------------------------------------
DELETE FROM StartBiasResources
WHERE CivilizationType = 'CIVILIZATION_GAUL';

INSERT INTO StartBiasResources
		(CivilizationType,					ResourceType,	Tier)
SELECT	'CIVILIZATION_GAUL',				ResourceType,	1
FROM Improvement_ValidResources WHERE
	ImprovementType = 'IMPROVEMENT_MINE' AND
	ResourceType NOT IN (
		SELECT ResourceType FROM RESOURCES WHERE
			SeaFrequency > 0 OR
			PrereqCivic IS NOT NULL OR
			PrereqTech IS NOT NULL
	);
--==========================================================================================================================
-- Cities founded on mineable resources provide that resource's yield modifier to adjacent tiles
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers
		(TraitType,							ModifierId)
SELECT 'TRAIT_CIVILIZATION_GAUL', 			'SUK_TORCS_AND_CARNYXES_' || ResourceType || '_' || YieldType
FROM Resource_YieldChanges WHERE ResourceType IN (SELECT ResourceType FROM Improvement_ValidResources WHERE ImprovementType = 'IMPROVEMENT_MINE');
-------------------------------------
-- Modifiers
-------------------------------------
INSERT INTO Modifiers
		(ModifierId,																	ModifierType,											SubjectRequirementSetId)
SELECT	'SUK_TORCS_AND_CARNYXES_' || ResourceType || '_' || YieldType,					'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',				'SUK_TORCS_AND_CARNYXES_CITY_ON_' || ResourceType
FROM Resource_YieldChanges WHERE ResourceType IN (SELECT ResourceType FROM Improvement_ValidResources WHERE ImprovementType = 'IMPROVEMENT_MINE');

INSERT INTO Modifiers
		(ModifierId,																	ModifierType,											SubjectRequirementSetId)
SELECT	'SUK_TORCS_AND_CARNYXES_' || ResourceType || '_' || YieldType || '_MOD',		'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',			'SUK_TORCS_AND_CARNYXES_IS_ADJACENT'
FROM Resource_YieldChanges WHERE ResourceType IN (SELECT ResourceType FROM Improvement_ValidResources WHERE ImprovementType = 'IMPROVEMENT_MINE');
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,														Name,				Value)
SELECT	'SUK_TORCS_AND_CARNYXES_' || ResourceType || '_' || YieldType,		'ModifierId',		'SUK_TORCS_AND_CARNYXES_' || ResourceType || '_' || YieldType || '_MOD'
FROM Resource_YieldChanges WHERE ResourceType IN (SELECT ResourceType FROM Improvement_ValidResources WHERE ImprovementType = 'IMPROVEMENT_MINE');

INSERT INTO ModifierArguments
		(ModifierId,																Name,				Value)
SELECT	'SUK_TORCS_AND_CARNYXES_' || ResourceType || '_' || YieldType || '_MOD',	'YieldType',		YieldType
FROM Resource_YieldChanges WHERE ResourceType IN (SELECT ResourceType FROM Improvement_ValidResources WHERE ImprovementType = 'IMPROVEMENT_MINE');

INSERT INTO ModifierArguments
		(ModifierId,																Name,				Value)
SELECT	'SUK_TORCS_AND_CARNYXES_' || ResourceType || '_' || YieldType || '_MOD',		'Amount',			YieldChange
FROM Resource_YieldChanges WHERE ResourceType IN (SELECT ResourceType FROM Improvement_ValidResources WHERE ImprovementType = 'IMPROVEMENT_MINE');
----------------------------------------------------------------------------------------------------------------------------
-- Requirements
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,											RequirementSetType)
SELECT	'SUK_TORCS_AND_CARNYXES_CITY_ON_' || ResourceType,			'REQUIREMENTSET_TEST_ALL'
FROM Improvement_ValidResources WHERE ImprovementType = 'IMPROVEMENT_MINE';

INSERT INTO RequirementSets
		(RequirementSetId,											RequirementSetType)
VALUES	('SUK_TORCS_AND_CARNYXES_IS_ADJACENT',						'REQUIREMENTSET_TEST_ALL');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------
INSERT INTO RequirementSetRequirements
		(RequirementSetId,											RequirementId)
SELECT	'SUK_TORCS_AND_CARNYXES_CITY_ON_' || ResourceType,			'REQUIRES_SUK_TORCS_AND_CARNYXES_CITY_ON_' || ResourceType
FROM Improvement_ValidResources WHERE ImprovementType = 'IMPROVEMENT_MINE';

INSERT INTO RequirementSetRequirements
		(RequirementSetId,											RequirementId)
SELECT	'SUK_TORCS_AND_CARNYXES_CITY_ON_' || ResourceType,			'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE'
FROM Improvement_ValidResources WHERE ImprovementType = 'IMPROVEMENT_MINE';

	--------------------
	--------------------

INSERT INTO RequirementSetRequirements
		(RequirementSetId,											RequirementId)
VALUES	('SUK_TORCS_AND_CARNYXES_IS_ADJACENT',						'REQUIRES_SUK_TORCS_AND_CARNYXES_IS_ADJACENT');
-------------------------------------
-- Requirements
-------------------------------------
INSERT INTO Requirements
		(RequirementId, 													RequirementType)
SELECT	'REQUIRES_SUK_TORCS_AND_CARNYXES_CITY_ON_' || ResourceType,			'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES'
FROM Improvement_ValidResources WHERE ImprovementType = 'IMPROVEMENT_MINE';

	--------------------
	--------------------

INSERT INTO Requirements
		(RequirementId, 										RequirementType)
VALUES	('REQUIRES_SUK_TORCS_AND_CARNYXES_IS_ADJACENT',			'REQUIREMENT_PLOT_ADJACENT_TO_OWNER');
-------------------------------------
-- RequirementArguments
-------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 														Name,					Value)
SELECT	'REQUIRES_SUK_TORCS_AND_CARNYXES_CITY_ON_' || ResourceType, 			'ResourceType',			ResourceType
FROM Improvement_ValidResources WHERE ImprovementType = 'IMPROVEMENT_MINE';

	--------------------
	--------------------

INSERT INTO RequirementArguments
		(RequirementId, 										Name,						Value)
VALUES	('REQUIRES_SUK_TORCS_AND_CARNYXES_IS_ADJACENT', 		'MinDistance',				1),
		('REQUIRES_SUK_TORCS_AND_CARNYXES_IS_ADJACENT', 		'MaxDistance',				1);
--==========================================================================================================================
--==========================================================================================================================