--==========================================================================================================================
-- CIVILIZATIONS
--==========================================================================================================================
-- Types
-------------------------------------
INSERT INTO Types
		(Type,								Kind)
VALUES	('CIVILIZATION_SUK_SWAHILI',		'KIND_CIVILIZATION');
-------------------------------------
-- Civilizations
-------------------------------------
-- Types
-------------------------------------
INSERT INTO Civilizations
		(CivilizationType,				Name,									Description,									Adjective,									StartingCivilizationLevelType,	RandomCityNameDepth,	Ethnicity)
VALUES	('CIVILIZATION_SUK_SWAHILI',	'LOC_CIVILIZATION_SUK_SWAHILI_NAME',	'LOC_CIVILIZATION_SUK_SWAHILI_DESCRIPTION',		'LOC_CIVILIZATION_SUK_SWAHILI_ADJECTIVE',	'CIVILIZATION_LEVEL_FULL_CIV',	10,						'ETHNICITY_AFRICAN');
-------------------------------------
-- CityNames
-------------------------------------
INSERT INTO CityNames
			(CivilizationType,						CityName)
VALUES		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_KILWA_KISIWANI'),
			-- ('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_ZANZIBAR'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_MOMBASA'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_LAMU'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_MALINDI'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_SOFALA'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_PATE'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_MZIZIMA'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_BAGAMOYO'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_GEDI'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_QUELIMANE'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_MOZAMBIQUE'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_FAZA'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_ANGOCHE'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_LINDI'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_MKUMBULU'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_SHANGA'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_SONGO_MNARA'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_MERCA'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_KISIMANI_MAFIA'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_FAZA'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_IBO'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_PANGANI'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_TANGA'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_MUTSAMUDU'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_BRAVA'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_SIYU'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_KIZIMKAZI'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_VANGA'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_TAKAUNGU'),
			-- ('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_MOGADISHU'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_UNGUJA_UKUU'),
			('CIVILIZATION_SUK_SWAHILI',			'LOC_CITY_NAME_SUK_SWAHILI_KILWA_KIVINJE');
-------------------------------------
-- CivilizationCitizenNames
-------------------------------------
INSERT INTO CivilizationCitizenNames
		(CivilizationType,						CitizenName,									Female,		Modern)
VALUES	('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MALE_1',				0,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MALE_2',				0,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MALE_3',				0,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MALE_4',				0,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MALE_5',				0,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MALE_6',				0,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MALE_7',				0,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MALE_8',				0,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MALE_9',				0,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MALE_10',				0,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_FEMALE_1',				1,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_FEMALE_2',				1,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_FEMALE_3',				1,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_FEMALE_4',				1,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_FEMALE_5',				1,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_FEMALE_6',				1,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_FEMALE_7',				1,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_FEMALE_8',				1,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_FEMALE_9',				1,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_FEMALE_10',			1,			0),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_MALE_1',		0,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_MALE_2',		0,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_MALE_3',		0,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_MALE_4',		0,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_MALE_5',		0,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_MALE_6',		0,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_MALE_7',		0,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_MALE_8',		0,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_MALE_9',		0,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_MALE_10',		0,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_FEMALE_1',		1,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_FEMALE_2',		1,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_FEMALE_3',		1,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_FEMALE_4',		1,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_FEMALE_5',		1,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_FEMALE_6',		1,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_FEMALE_7',		1,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_FEMALE_8',		1,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_FEMALE_9',		1,			1),
		('CIVILIZATION_SUK_SWAHILI',			'LOC_CITIZEN_SUK_SWAHILI_MODERN_FEMALE_10',		1,			1);
-------------------------------------
-- StartBiasTerrains
-------------------------------------
INSERT INTO StartBiasTerrains
		(CivilizationType,						TerrainType,			Tier)
VALUES	('CIVILIZATION_SUK_SWAHILI',			'TERRAIN_COAST',		2);
-------------------------------------
-- StartBiasFeatures
-------------------------------------
INSERT INTO StartBiasFeatures
		(CivilizationType,							FeatureType,			Tier)
SELECT	'CIVILIZATION_SUK_SWAHILI',					FeatureType,			2
FROM Features WHERE FeatureType = 'FEATURE_REEF';
-------------------------------------
-- CivilizationInfo
-------------------------------------
INSERT INTO CivilizationInfo
			(CivilizationType,					Header,						Caption,									SortIndex)
VALUES		('CIVILIZATION_SUK_SWAHILI',		'LOC_CIVINFO_LOCATION',		'LOC_CIVINFO_SUK_SWAHILI_LOCATION',			10),
			-- ('CIVILIZATION_SUK_SWAHILI',		'LOC_CIVINFO_SIZE',			'LOC_CIVINFO_SUK_SWAHILI_SIZE',				20),
			-- ('CIVILIZATION_SUK_SWAHILI',		'LOC_CIVINFO_POPULATION',	'LOC_CIVINFO_SUK_SWAHILI_POPULATION',		30),
			('CIVILIZATION_SUK_SWAHILI',		'LOC_CIVINFO_CAPITAL', 		'LOC_CIVINFO_SUK_SWAHILI_CAPITAL',			40);
--==========================================================================================================================
-- TRAITS
--==========================================================================================================================
-- Types
-------------------------------------
INSERT INTO Types
		(Type,														Kind)
VALUES	('TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION',				'KIND_TRAIT'),
		('TRAIT_CIVILIZATION_UNIT_SUK_JAHAZI',						'KIND_TRAIT'),
		('TRAIT_CIVILIZATION_BUILDING_SUK_PILLAR_TOMB',				'KIND_TRAIT');
-------------------------------------
-- Traits
-------------------------------------
INSERT INTO Traits
		(TraitType,												Name,															Description)
VALUES	('TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION',			'LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_NAME',			'LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_DESCRIPTION'),
		('TRAIT_CIVILIZATION_UNIT_SUK_JAHAZI',					'LOC_TRAIT_CIVILIZATION_UNIT_SUK_JAHAZI_NAME',					null),
		('TRAIT_CIVILIZATION_BUILDING_SUK_PILLAR_TOMB',			'LOC_TRAIT_CIVILIZATION_BUILDING_SUK_PILLAR_TOMB_NAME',			null);

UPDATE Traits
	SET Description = 'LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_DESCRIPTION_XP1'
	WHERE TraitType= 'TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION'
	AND EXISTS (SELECT * FROM Features WHERE FeatureType = 'FEATURE_REEF');
-------------------------------------
-- CivilizationTraits
-------------------------------------
INSERT INTO CivilizationTraits
		(TraitType,													CivilizationType)
VALUES	('TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION',				'CIVILIZATION_SUK_SWAHILI'),
		('TRAIT_CIVILIZATION_UNIT_SUK_JAHAZI',						'CIVILIZATION_SUK_SWAHILI'),
		('TRAIT_CIVILIZATION_BUILDING_SUK_PILLAR_TOMB',				'CIVILIZATION_SUK_SWAHILI');
--==========================================================================================================================
-- Districts in coastal Cities receive a Major adjacency bonus from the City Center,
-- and a standard bonus from being adjacent to a Harbor.
--==========================================================================================================================
-- PREPARATION
----------------------------------------------------------------------------------------------------------------------------
	CREATE TEMPORARY TABLE "SukCoralConstructionData"(
		"DistrictType" 			TEXT,
		"RequirementId" 		TEXT,
		"YieldType" 			TEXT
	);

	INSERT INTO SukCoralConstructionData
		(
			DistrictType,
			RequirementId,
			YieldType
		)
	SELECT DISTINCT

		Districts.DistrictType,
		Requirements.RequirementId,
		Adjacency_YieldChanges.YieldType

	FROM Districts
	JOIN District_Adjacencies ON District_Adjacencies.DistrictType = Districts.DistrictType
	JOIN Adjacency_YieldChanges ON District_Adjacencies.YieldChangeId = Adjacency_YieldChanges.ID
	JOIN Requirements ON REPLACE(Districts.DistrictType, 'DISTRICT', 'REQUIRES_DISTRICT_IS') = Requirements.RequirementId
	WHERE Districts.RequiresPopulation = 1 AND Districts.DistrictType NOT IN (SELECT CivUniqueDistrictType FROM DistrictReplaces);
-------------------------------------
-- Types
-------------------------------------
INSERT OR REPLACE INTO Types
		(Type,																Kind)
VALUES	('MODIFIER_SUK_SWAHILI_CITY_DISTRICTS_ADJUST_BASE_YIELD_CHANGE',	'KIND_MODIFIER');
-------------------------------------
-- DynamicModifiers
-------------------------------------
INSERT OR REPLACE INTO DynamicModifiers
		(ModifierType,														CollectionType,					EffectType)
VALUES	('MODIFIER_SUK_SWAHILI_CITY_DISTRICTS_ADJUST_BASE_YIELD_CHANGE',	'COLLECTION_CITY_DISTRICTS',	'EFFECT_ADJUST_DISTRICT_BASE_YIELD_CHANGE');
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
	-- TraitModifiers
	--------------------------------------------------------------------------
		WITH CTE(Suffix) AS (SELECT * FROM (VALUES('_CITY_CENTER'), ('_HARBOR')))
			INSERT INTO TraitModifiers
					(TraitType,										ModifierId)
			SELECT	'TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION',	'TRAIT_SUK_SWAHILI_'||DistrictType||'_'||YieldType||Suffix
			FROM SukCoralConstructionData CROSS JOIN CTE;
	--------------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------------
		WITH CTE(Suffix, ReqSuffix) AS
			(
				SELECT * FROM (VALUES
					('_CITY_CENTER',			NULL),
					('_CITY_CENTER_MODIFIER',	'_ADJACENT_TO_CITY_CENTER'),
					('_HARBOR',					NULL),
					('_HARBOR_MODIFIER',		'_ADJACENT_TO_HARBOR')
				)
			)
			INSERT INTO Modifiers
				(
					ModifierId,
					ModifierType,
					SubjectRequirementSetId
				)
			SELECT
				'TRAIT_SUK_SWAHILI_'||DistrictType||'_'||YieldType||Suffix,
				CASE
					WHEN Suffix LIKE '%/_MODIFIER' ESCAPE '/'
					THEN 'MODIFIER_SUK_SWAHILI_CITY_DISTRICTS_ADJUST_BASE_YIELD_CHANGE'
					ELSE 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER'
				END,
				CASE
					WHEN ReqSuffix IS NOT NULL
					THEN 'SUK_SWAHILI_'||DistrictType||ReqSuffix
					ELSE 'PLOT_IS_COASTAL_LAND_REQUIREMENTS'
				END
			FROM SukCoralConstructionData CROSS JOIN CTE;
	--------------------------------------------------------------------------
	-- ModifierArguments
	--------------------------------------------------------------------------
		WITH CTE(Suffix) AS (SELECT * FROM (VALUES('_CITY_CENTER'), ('_HARBOR')))
			INSERT INTO ModifierArguments
				(
					ModifierId,
					Name,
					Value
				)
			SELECT
				'TRAIT_SUK_SWAHILI_'||DistrictType||'_'||YieldType||Suffix,
				'ModifierId',
				'TRAIT_SUK_SWAHILI_'||DistrictType||'_'||YieldType||Suffix||'_MODIFIER'
			FROM SukCoralConstructionData CROSS JOIN CTE;

		--------------------------------------------------------------------------

		WITH
			CTE(Suffix, YieldChange, LocSuffix)	AS (SELECT * FROM (
				VALUES
					('_CITY_CENTER_MODIFIER',	2,	'_CITY_CENTER'),
					('_HARBOR_MODIFIER',		1,	'_HARBOR')
			)),
			Arguments(Name)				AS (SELECT * FROM (
				VALUES
					('YieldType'),
					('Amount')
			))
			INSERT INTO ModifierArguments
				(
					ModifierId,
					Name,
					Value
				)
			SELECT
				'TRAIT_SUK_SWAHILI_'||DistrictType||'_'||YieldType||Suffix,
				Name,
				CASE
					WHEN Name = 'YieldType'		THEN YieldType
					WHEN Name = 'Amount'		THEN YieldChange
				END
			FROM SukCoralConstructionData CROSS JOIN CTE CROSS JOIN Arguments;
----------------------------------------------------------------------------------------------------------------------------
-- REQUIREMENTS
----------------------------------------------------------------------------------------------------------------------------
	-- RequirementSets
	--------------------------------------------------------------------------
		WITH CTE(Suffix) AS
			(
				SELECT * FROM (VALUES
					('_ADJACENT_TO_CITY_CENTER'),
					('_ADJACENT_TO_HARBOR')
				)
			)
			INSERT INTO RequirementSets
					(RequirementSetId,							RequirementSetType)
			SELECT	'SUK_SWAHILI_'||DistrictType||Suffix,	'REQUIREMENTSET_TEST_ALL'
			FROM SukCoralConstructionData CROSS JOIN CTE;
	--------------------------------------------------------------------------
	-- RequirementSetRequirements
	--------------------------------------------------------------------------
		WITH CTE(Suffix) AS
			(
				SELECT * FROM (VALUES
					('_ADJACENT_TO_CITY_CENTER'),
					('_ADJACENT_TO_HARBOR')
				)
			),

			Requirements(Requirement) AS
			(
				SELECT * FROM (VALUES
					('REQUIRES_DISTRICT'),
					('REQUIRES_SUK_SWAHILI_PLOT')
				)
			)
			INSERT INTO RequirementSetRequirements
				(
					RequirementSetId,
					RequirementId
				)
			SELECT
				'SUK_SWAHILI_'||DistrictType||Suffix,
				CASE
					WHEN Requirement = 'REQUIRES_DISTRICT' THEN RequirementId
					ELSE Requirement || Suffix
				END
			FROM SukCoralConstructionData CROSS JOIN CTE CROSS JOIN Requirements;
-------------------------------------
-- Requirements
-------------------------------------
INSERT INTO Requirements
		(RequirementId, 										RequirementType)
VALUES	('REQUIRES_SUK_SWAHILI_PLOT_ADJACENT_TO_CITY_CENTER',	'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES'),
		('REQUIRES_SUK_SWAHILI_PLOT_ADJACENT_TO_HARBOR',		'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES');
-------------------------------------
-- RequirementArguments
-------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 										Name,						Value)
VALUES	('REQUIRES_SUK_SWAHILI_PLOT_ADJACENT_TO_CITY_CENTER', 	'DistrictType',				'DISTRICT_CITY_CENTER'),
		('REQUIRES_SUK_SWAHILI_PLOT_ADJACENT_TO_HARBOR', 		'DistrictType',				'DISTRICT_HARBOR');
----------------------------------------------------------------------------------------------------------------------------
-- REQUIREMENTS
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
-------------------------------------
INSERT OR IGNORE INTO RequirementSets
		(RequirementSetId,						RequirementSetType)
VALUES	('SUK_SWAHILI_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
		('PLOT_IS_COASTAL_LAND_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------
INSERT OR IGNORE INTO RequirementSetRequirements
		(RequirementSetId,						RequirementId)
VALUES	('SUK_SWAHILI_REQUIREMENTS',			'PLAYER_IS_SUK_SWAHILI'),
		('PLOT_IS_COASTAL_LAND_REQUIREMENTS',	'PLOT_IS_COASTAL_LAND');
-------------------------------------
-- Requirements
-------------------------------------
INSERT OR IGNORE INTO Requirements
		(RequirementId, 					RequirementType)
VALUES	('PLAYER_IS_SUK_SWAHILI',			'REQUIREMENT_PLAYER_TYPE_MATCHES'),
		('PLOT_IS_COASTAL_LAND',			'REQUIREMENT_PLOT_IS_COASTAL_LAND');
-------------------------------------
-- RequirementArguments
-------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 					Name,						Value)
VALUES	('PLAYER_IS_SUK_SWAHILI', 			'CivilizationType',			'CIVILIZATION_SUK_SWAHILI');
--==========================================================================================================================
-- +2 [ICON_Production] Production from Reefs.
--==========================================================================================================================
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers
		(TraitType,													ModifierId)
SELECT	'TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION', 				'TRAIT_SUK_SWAHILI_REEF_PRODUCTION'
WHERE EXISTS (SELECT * FROM Requirements WHERE RequirementId = "REQUIRES_PLOT_HAS_REEF");
-------------------------------------
-- Modifiers
-------------------------------------
INSERT INTO Modifiers
		(
			ModifierId,
			ModifierType,
			OwnerRequirementSetId,
			SubjectRequirementSetId
		)
	SELECT

			'TRAIT_SUK_SWAHILI_REEF_PRODUCTION',
			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',
			NULL,
			'SUK_SWAHILI_REEF_REQUIREMENTS'
	WHERE EXISTS (SELECT * FROM Requirements WHERE RequirementId = "REQUIRES_PLOT_HAS_REEF");
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
	(ModifierId,								Name,				Value)
	SELECT * FROM (VALUES
		('TRAIT_SUK_SWAHILI_REEF_PRODUCTION',		'YieldType',		'YIELD_PRODUCTION'),
		('TRAIT_SUK_SWAHILI_REEF_PRODUCTION',		'Amount',			2)
	)
	WHERE EXISTS (SELECT * FROM Requirements WHERE RequirementId = "REQUIRES_PLOT_HAS_REEF");
----------------------------------------------------------------------------------------------------------------------------
-- REQUIREMENTS
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,					RequirementSetType)
SELECT	'SUK_SWAHILI_REEF_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'
WHERE EXISTS (SELECT * FROM Requirements WHERE RequirementId = "REQUIRES_PLOT_HAS_REEF");
-------------------------------------
-- RequirementSetRequirements
-------------------------------------
INSERT INTO RequirementSetRequirements
		(RequirementSetId,					RequirementId)
SELECT	'SUK_SWAHILI_REEF_REQUIREMENTS',	'REQUIRES_PLOT_HAS_REEF'
WHERE EXISTS (SELECT * FROM Requirements WHERE RequirementId = "REQUIRES_PLOT_HAS_REEF");
--==========================================================================================================================
--==========================================================================================================================