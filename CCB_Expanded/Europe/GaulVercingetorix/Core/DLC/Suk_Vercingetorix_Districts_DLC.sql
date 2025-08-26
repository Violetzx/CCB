--==========================================================================================================================
-- DISTRICTS
--==========================================================================================================================
UPDATE Districts
SET Description		= "LOC_DISTRICT_OPPIDUM_REWORK_DESCRIPTION",
	NoAdjacentCity	= 1
WHERE DistrictType = "DISTRICT_OPPIDUM";
-------------------------------------
-- District_Adjacencies
-------------------------------------
INSERT INTO District_Adjacencies
			(DistrictType,					YieldChangeId)
VALUES		('DISTRICT_OPPIDUM',			'Oppidum_PastureFood'),
			('DISTRICT_OPPIDUM',			'Oppidum_CampFood');
-------------------------------------
-- Adjacency_YieldChanges
-------------------------------------
INSERT OR REPLACE INTO Adjacency_YieldChanges
	(
		ID,
		Description,

		YieldType,
		YieldChange,

		AdjacentImprovement,
		TilesRequired
	)
VALUES
	(
		'Oppidum_PastureFood',
		'LOC_DISTRICT_OPPIDUM_PASTUREFOOD',

		'YIELD_FOOD',
		1,

		'IMPROVEMENT_PASTURE',
		1
	),
	(
		'Oppidum_CampFood',
		'LOC_DISTRICT_OPPIDUM_CAMPFOOD',

		'YIELD_FOOD',
		1,

		'IMPROVEMENT_CAMP',
		1
	);
-------------------------------------
-- DistrictModifiers
-------------------------------------
DELETE FROM DistrictModifiers
WHERE ModifierId = "OPPIDUM_GRANT_TECH_APPRENTICESHIP";
-- --==========================================================================================================================
-- -- The Dūnon doubles the base yield modifier of adjacent Pasture resources.
-- --==========================================================================================================================
-- -- TraitModifiers
-- -------------------------------------
-- INSERT INTO TraitModifiers
-- 			(TraitType,										ModifierId)
-- SELECT 		'TRAIT_CIVILIZATION_DISTRICT_OPPIDUM',			'SUK_OPPIDUM_'||ResourceType||'_'||YieldType
-- FROM Resource_YieldChanges WHERE
-- 	ResourceType IN (SELECT ResourceType FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_PASTURE', 'IMPROVEMENT_CAMP'));
-- -------------------------------------
-- -- Modifiers
-- -------------------------------------
-- INSERT INTO Modifiers
-- 		(ModifierId,										ModifierType,								SubjectRequirementSetId)
-- SELECT	'SUK_OPPIDUM_'||ResourceType||'_'||YieldType,		'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',		'SUK_OPPIDUM_'||ResourceType
-- FROM Resource_YieldChanges WHERE
-- 	ResourceType IN (SELECT ResourceType FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_PASTURE', 'IMPROVEMENT_CAMP'));
-- -------------------------------------
-- -- ModifierArguments
-- -------------------------------------
-- INSERT INTO ModifierArguments
-- 		(ModifierId,									Name,				Value)
-- SELECT	'SUK_OPPIDUM_'||ResourceType||'_'||YieldType,	'YieldType',		YieldType
-- FROM Resource_YieldChanges WHERE
-- 	ResourceType IN (SELECT ResourceType FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_PASTURE', 'IMPROVEMENT_CAMP'));

-- INSERT INTO ModifierArguments
-- 		(ModifierId,									Name,				Value)
-- SELECT	'SUK_OPPIDUM_'||ResourceType||'_'||YieldType,	'Amount',			YieldChange
-- FROM Resource_YieldChanges WHERE
-- 	ResourceType IN (SELECT ResourceType FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_PASTURE', 'IMPROVEMENT_CAMP'));
-- -------------------------------------
-- -- RequirementSets
-- -------------------------------------
-- INSERT INTO RequirementSets
-- 		(RequirementSetId,						RequirementSetType)
-- SELECT	'SUK_OPPIDUM_'||ResourceType,			'REQUIREMENTSET_TEST_ALL'
-- FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_PASTURE', 'IMPROVEMENT_CAMP');
-- -------------------------------------
-- -- RequirementSetRequirements
-- -------------------------------------
-- INSERT INTO RequirementSetRequirements
-- 		(RequirementSetId,						RequirementId)
-- SELECT	'SUK_OPPIDUM_'||ResourceType,			'REQUIRES_PLOT_ADJACENT_TO_OPPIDUM'
-- FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_PASTURE', 'IMPROVEMENT_CAMP');

-- INSERT INTO RequirementSetRequirements
-- 		(RequirementSetId,						RequirementId)
-- SELECT	'SUK_OPPIDUM_'||ResourceType,			'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE'
-- FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_PASTURE', 'IMPROVEMENT_CAMP');

-- INSERT INTO RequirementSetRequirements
-- 		(RequirementSetId,						RequirementId)
-- SELECT	'SUK_OPPIDUM_'||ResourceType,			'REQUIRES_SUK_OPPIDUM_'||ResourceType||'_IN_PLOT'
-- FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_PASTURE', 'IMPROVEMENT_CAMP');
-- -------------------------------------
-- -- Requirements
-- -------------------------------------
-- INSERT OR REPLACE INTO Requirements
-- 		(RequirementId, 							RequirementType)
-- VALUES	('REQUIRES_PLOT_ADJACENT_TO_OPPIDUM',		'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES');

-- INSERT INTO Requirements
-- 		(RequirementId, 														RequirementType)
-- SELECT	'REQUIRES_SUK_OPPIDUM_'||ResourceType||'_IN_PLOT',		'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES'
-- FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_PASTURE', 'IMPROVEMENT_CAMP');
-- -------------------------------------
-- -- RequirementArguments
-- -------------------------------------
-- INSERT INTO RequirementArguments
-- 		(RequirementId, 								Name,					Value)
-- VALUES	('REQUIRES_PLOT_ADJACENT_TO_OPPIDUM',			'DistrictType',			'DISTRICT_OPPIDUM');

-- INSERT INTO RequirementArguments
-- 		(RequirementId, 										Name,					Value)
-- SELECT	'REQUIRES_SUK_OPPIDUM_'||ResourceType||'_IN_PLOT', 		'ResourceType',			ResourceType
-- FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_PASTURE', 'IMPROVEMENT_CAMP');
--==========================================================================================================================
--==========================================================================================================================