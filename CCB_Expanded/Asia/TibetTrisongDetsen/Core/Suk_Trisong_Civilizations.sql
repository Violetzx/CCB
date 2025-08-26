--==========================================================================================================================
-- CIVILIZATIONS
--==========================================================================================================================
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,								Kind)
VALUES	('CIVILIZATION_SUK_TIBET',			'KIND_CIVILIZATION');
-------------------------------------			
-- Civilizations			
-------------------------------------				
-- Types
-------------------------------------	
INSERT INTO Civilizations	
		(CivilizationType,				Name,									Description,									Adjective,									StartingCivilizationLevelType,	RandomCityNameDepth,	Ethnicity)
VALUES	('CIVILIZATION_SUK_TIBET',		'LOC_CIVILIZATION_SUK_TIBET_NAME',		'LOC_CIVILIZATION_SUK_TIBET_DESCRIPTION',		'LOC_CIVILIZATION_SUK_TIBET_ADJECTIVE',		'CIVILIZATION_LEVEL_FULL_CIV',	10,						'ETHNICITY_ASIAN');	
-------------------------------------			
-- CityNames			
-------------------------------------		
INSERT INTO CityNames	
			(CivilizationType,					CityName)	
VALUES		('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_LHASA'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_ZHIKATSE'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_GYANTSE'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_CHAMDO'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_TSETANG'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_SENGGE_KHABAP'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_PARO'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_NAKCHU'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_KYEGUDO'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_KHYUNGLUNG'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_DARTSEDO'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_NYINGTRI'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_NEDONG'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_TSOCHEN'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_BARKHAM'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_SAKYA'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_KARDZE'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_PEMBAR'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_LHATSE'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_GANGGA'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_MACHEN'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_NAGORMO'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_TAWANG'),	
			('CIVILIZATION_SUK_TIBET',			'LOC_CITY_NAME_SUK_TIBET_LE');
-------------------------------------
-- CivilizationCitizenNames
-------------------------------------	
INSERT INTO CivilizationCitizenNames	
		(CivilizationType,						CitizenName,							Female,		Modern)
VALUES	('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MALE_1',				0,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MALE_2',				0,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MALE_3',				0,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MALE_4',				0,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MALE_5',				0,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MALE_6',				0,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MALE_7',				0,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MALE_8',				0,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MALE_9',				0,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MALE_10',			0,			0),

		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_FEMALE_1',			1,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_FEMALE_2',			1,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_FEMALE_3',			1,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_FEMALE_4',			1,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_FEMALE_5',			1,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_FEMALE_6',			1,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_FEMALE_7',			1,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_FEMALE_8',			1,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_FEMALE_9',			1,			0),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_FEMALE_10',			1,			0),

		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_MALE_1',		0,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_MALE_2',		0,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_MALE_3',		0,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_MALE_4',		0,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_MALE_5',		0,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_MALE_6',		0,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_MALE_7',		0,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_MALE_8',		0,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_MALE_9',		0,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_MALE_10',		0,			1),

		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_FEMALE_1',	1,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_FEMALE_2',	1,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_FEMALE_3',	1,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_FEMALE_4',	1,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_FEMALE_5',	1,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_FEMALE_6',	1,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_FEMALE_7',	1,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_FEMALE_8',	1,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_FEMALE_9',	1,			1),
		('CIVILIZATION_SUK_TIBET',			'LOC_CITIZEN_SUK_TIBET_MODERN_FEMALE_10',	1,			1);			
-------------------------------------			
-- StartBiasTerrains			
-------------------------------------	
INSERT INTO StartBiasTerrains	
		(CivilizationType,					TerrainType,					Tier)
VALUES	('CIVILIZATION_SUK_TIBET',			'TERRAIN_DESERT_MOUNTAIN',		3),
		('CIVILIZATION_SUK_TIBET',			'TERRAIN_GRASS_MOUNTAIN',		3),
		('CIVILIZATION_SUK_TIBET',			'TERRAIN_PLAINS_MOUNTAIN',		3),
		('CIVILIZATION_SUK_TIBET',			'TERRAIN_TUNDRA_MOUNTAIN',		5),
		('CIVILIZATION_SUK_TIBET',			'TERRAIN_SNOW_MOUNTAIN',		5);
-------------------------------------			
-- CivilizationInfo			
-------------------------------------		
INSERT INTO CivilizationInfo	
			(CivilizationType,				Header,						Caption,									SortIndex)	
VALUES		('CIVILIZATION_SUK_TIBET',		'LOC_CIVINFO_LOCATION',		'LOC_CIVINFO_SUK_TIBET_LOCATION',			10),	
			('CIVILIZATION_SUK_TIBET',		'LOC_CIVINFO_SIZE',			'LOC_CIVINFO_SUK_TIBET_SIZE',				20),	
			('CIVILIZATION_SUK_TIBET',		'LOC_CIVINFO_POPULATION',	'LOC_CIVINFO_SUK_TIBET_POPULATION',			30),	
			('CIVILIZATION_SUK_TIBET',		'LOC_CIVINFO_CAPITAL', 		'LOC_CIVINFO_SUK_TIBET_CAPITAL',			40);
--==========================================================================================================================
-- TRAITS
--==========================================================================================================================
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,													Kind)
VALUES	('TRAIT_CIVILIZATION_SUK_DHARMA_KINGS',					'KIND_TRAIT'),
		('TRAIT_CIVILIZATION_UNIT_SUK_RTA_PA',					'KIND_TRAIT'),
		('TRAIT_CIVILIZATION_DISTRICT_SUK_DZONG',				'KIND_TRAIT');
-------------------------------------			
-- Traits			
-------------------------------------				
INSERT INTO Traits				
		(TraitType,											Name,															Description)
VALUES	('TRAIT_CIVILIZATION_SUK_DHARMA_KINGS',				'LOC_TRAIT_CIVILIZATION_SUK_DHARMA_KINGS_NAME',					'LOC_TRAIT_CIVILIZATION_SUK_DHARMA_KINGS_DESCRIPTION'),
		('TRAIT_CIVILIZATION_UNIT_SUK_RTA_PA',				'LOC_UNIT_SUK_RTA_PA_NAME',										null),
		('TRAIT_CIVILIZATION_DISTRICT_SUK_DZONG',			'LOC_DISTRICT_SUK_DZONG_NAME',									null);
-------------------------------------
-- CivilizationTraits
-------------------------------------	
INSERT INTO CivilizationTraits	
		(TraitType,												CivilizationType)
VALUES	('TRAIT_CIVILIZATION_SUK_DHARMA_KINGS',					'CIVILIZATION_SUK_TIBET'),
		('TRAIT_CIVILIZATION_UNIT_SUK_RTA_PA',					'CIVILIZATION_SUK_TIBET'),
		('TRAIT_CIVILIZATION_DISTRICT_SUK_DZONG',				'CIVILIZATION_SUK_TIBET');
--==========================================================================================================================
-- Cities with an established Governor receive +5% [ICON_Faith] Faith for each promotion that Governor has.
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,											ModifierId)
VALUES	('TRAIT_CIVILIZATION_SUK_DHARMA_KINGS', 			'SUK_DHARMA_KINGS_ADJUST_CITY_FAITH_PER_GOVERNOR_TITLE_MODIFIER');
-------------------------------------
-- Modifiers
-------------------------------------
INSERT INTO Modifiers	
		(ModifierId,															ModifierType)
VALUES	('SUK_DHARMA_KINGS_ADJUST_CITY_FAITH_PER_GOVERNOR_TITLE_MODIFIER',		'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER_PER_GOVERNOR_TITLE');
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,																	Name,							Value)
VALUES	('SUK_DHARMA_KINGS_ADJUST_CITY_FAITH_PER_GOVERNOR_TITLE_MODIFIER',				'YieldType',					'YIELD_FAITH'),
		('SUK_DHARMA_KINGS_ADJUST_CITY_FAITH_PER_GOVERNOR_TITLE_MODIFIER',				'Amount',						5);
--==========================================================================================================================
												-- BEGIN PREPARATION --		
--==========================================================================================================================
-- Preparation for all the "Specialty District next to to a mountain in your borders" stuff
----------------------------------------------------------------------------------------------------------------------------
CREATE TEMPORARY TABLE "SukDharmaKingsData"(
	"DistrictType" 			TEXT,
	"RequirementId" 		TEXT,
	"YieldType" 			TEXT,
	"CustomRequirementId"	BOOLEAN
);

INSERT INTO SukDharmaKingsData			
	(
		DistrictType,
		YieldType,
		RequirementId,
		CustomRequirementId
	)
SELECT DISTINCT
	Districts.DistrictType,
	Adjacency_YieldChanges.YieldType,
	CASE 
		WHEN Requirements.RequirementId IS NULL 
		THEN REPLACE(Districts.DistrictType, 'DISTRICT', 'SUK_DHARMA_KINGS_REQUIRES_DISTRICT_IS')
		ELSE Requirements.RequirementId
	END,
	CASE 
		WHEN Requirements.RequirementId IS NULL THEN 1
		ELSE 0
	END
FROM Districts
LEFT JOIN District_Adjacencies ON District_Adjacencies.DistrictType = Districts.DistrictType
LEFT JOIN Adjacency_YieldChanges ON District_Adjacencies.YieldChangeId = Adjacency_YieldChanges.ID
LEFT JOIN Requirements ON REPLACE(Districts.DistrictType, 'DISTRICT', 'REQUIRES_DISTRICT_IS') = Requirements.RequirementId
WHERE Districts.RequiresPopulation = 1 AND Districts.DistrictType NOT IN (SELECT CivUniqueDistrictType FROM DistrictReplaces);
--==========================================================================================================================
-- Adjacent to Mountain within Player Borders Requirement.
----------------------------------------------------------------------------------------------------------------------------
-- REQUIREMENTS
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,															RequirementSetType)
VALUES	('SUK_DHARMA_KINGS_MOUNTAIN_PLOT_ADJACENT_DISTRICT_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
		('SUK_DHARMA_KINGS_PLOT_IS_MOUNTAIN_REQUIREMENTS',							'REQUIREMENTSET_TEST_ANY');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------	
INSERT INTO RequirementSetRequirements
		(RequirementSetId,															RequirementId)
VALUES	('SUK_DHARMA_KINGS_MOUNTAIN_PLOT_ADJACENT_DISTRICT_REQUIREMENTS',			'SUK_DHARMA_KINGS_PLOT_IS_MOUNTAIN'),
		('SUK_DHARMA_KINGS_MOUNTAIN_PLOT_ADJACENT_DISTRICT_REQUIREMENTS',			'SUK_DHARMA_KINGS_ADJACENT_TO_OWNER');

INSERT INTO RequirementSetRequirements
		(RequirementSetId,															RequirementId)
SELECT	'SUK_DHARMA_KINGS_PLOT_IS_MOUNTAIN_REQUIREMENTS',							'SUK_DHARMA_KINGS_PLOT_IS_' || Terrains.TerrainType
FROM Terrains WHERE Terrains.TerrainType LIKE '%MOUNTAIN';
-------------------------------------
-- Requirements
-------------------------------------
INSERT INTO Requirements
		(RequirementId, 											RequirementType)
VALUES	('SUK_DHARMA_KINGS_MOUNTAINS_ADJACENT',						'REQUIREMENT_COLLECTION_COUNT_ATLEAST'),
		('SUK_DHARMA_KINGS_PLOT_IS_MOUNTAIN',						'REQUIREMENT_REQUIREMENTSET_IS_MET'),

		('SUK_DHARMA_KINGS_ADJACENT_TO_OWNER',						'REQUIREMENT_PLOT_ADJACENT_TO_OWNER');

INSERT INTO Requirements
		(RequirementId, 											RequirementType)
SELECT	'SUK_DHARMA_KINGS_PLOT_IS_' || Terrains.TerrainType,		'REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES'
FROM Terrains WHERE Terrains.TerrainType LIKE '%MOUNTAIN';	
-------------------------------------
-- RequirementArguments
-------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 								Name,						Value)
VALUES	('SUK_DHARMA_KINGS_MOUNTAINS_ADJACENT', 		'CollectionType',			'COLLECTION_PLAYER_PLOT_YIELDS'),
		('SUK_DHARMA_KINGS_MOUNTAINS_ADJACENT', 		'Count',					1),
		('SUK_DHARMA_KINGS_MOUNTAINS_ADJACENT', 		'RequirementSetId',			'SUK_DHARMA_KINGS_MOUNTAIN_PLOT_ADJACENT_DISTRICT_REQUIREMENTS'),

		('SUK_DHARMA_KINGS_PLOT_IS_MOUNTAIN', 			'RequirementSetId',			'SUK_DHARMA_KINGS_PLOT_IS_MOUNTAIN_REQUIREMENTS'),

		('SUK_DHARMA_KINGS_ADJACENT_TO_OWNER', 			'MinDistance',				1),
		('SUK_DHARMA_KINGS_ADJACENT_TO_OWNER', 			'MaxDistance',				1);

INSERT INTO RequirementArguments
		(RequirementId, 												Name,						Value)
SELECT	'SUK_DHARMA_KINGS_PLOT_IS_' || Terrains.TerrainType,			'TerrainType',				TerrainType
FROM Terrains WHERE Terrains.TerrainType LIKE '%MOUNTAIN';
--==========================================================================================================================
-- Specialty Districts Adjacent to Mountain within Player Borders Requirement Sets.
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,													RequirementSetType)
SELECT	'SUK_DHARMA_KINGS_' || DistrictType || '_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'
FROM SukDharmaKingsData;
-------------------------------------
-- RequirementSetRequirements
-------------------------------------
INSERT INTO RequirementSetRequirements
		(RequirementSetId,													RequirementId)
SELECT	'SUK_DHARMA_KINGS_' || DistrictType || '_REQUIREMENTS',				'SUK_DHARMA_KINGS_MOUNTAINS_ADJACENT'
FROM SukDharmaKingsData;

INSERT INTO RequirementSetRequirements
		(RequirementSetId,													RequirementId)
SELECT	'SUK_DHARMA_KINGS_' || DistrictType || '_REQUIREMENTS',				RequirementId
FROM SukDharmaKingsData;
---------------------------------------
---- Requirements
---------------------------------------
INSERT INTO Requirements
		(RequirementId,				RequirementType)
SELECT	RequirementId,				'REQUIREMENT_DISTRICT_TYPE_MATCHES'
FROM SukDharmaKingsData WHERE CustomRequirementId = 1;
---------------------------------------
---- RequirementArguments
---------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 			Name,							Value)
SELECT	RequirementId,				'DistrictType',					DistrictType
FROM SukDharmaKingsData WHERE CustomRequirementId = 1;
--==========================================================================================================================
												-- END PREPARATION --
--==========================================================================================================================
-- When built next to a Mountain within your borders, Specialty Districts provide +2 of the appropriate yield
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,										ModifierId)
SELECT 	'TRAIT_CIVILIZATION_SUK_DHARMA_KINGS',			'SUK_DHARMA_KINGS_' || DistrictType || '_' || YieldType || '_MODIFIER'
FROM SukDharmaKingsData WHERE YieldType IS NOT NULL;
--------------------------------------------------------------------------------------------------------------------------
-- Modifiers
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO Modifiers	
		(ModifierId,																	ModifierType,											SubjectRequirementSetId)
SELECT	'SUK_DHARMA_KINGS_' || DistrictType || '_' || YieldType || '_MODIFIER',			'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',		'SUK_DHARMA_KINGS_' || DistrictType || '_REQUIREMENTS'
FROM SukDharmaKingsData WHERE YieldType IS NOT NULL;
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,																	Name,						Value)
SELECT	'SUK_DHARMA_KINGS_' || DistrictType || '_' || YieldType || '_MODIFIER',			'YieldType',				YieldType
FROM SukDharmaKingsData WHERE YieldType IS NOT NULL;

INSERT INTO ModifierArguments
		(ModifierId,																	Name,						Value)
SELECT	'SUK_DHARMA_KINGS_' || DistrictType || '_' || YieldType || '_MODIFIER',			'Amount',					2
FROM SukDharmaKingsData WHERE YieldType IS NOT NULL;
--==========================================================================================================================
-- When built next to a Mountain within your borders, you may purchase buildings within the Specialty Districts
----------------------------------------------------------------------------------------------------------------------------
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,																Kind)
VALUES	('MODIFIER_SUK_DHARMA_KINGS_ENABLE_BUILDING_FAITH_PURCHASE',		'KIND_MODIFIER');
-------------------------------------
-- DynamicModifiers
-------------------------------------					
INSERT INTO DynamicModifiers			
		(ModifierType,														CollectionType,							EffectType)
VALUES	('MODIFIER_SUK_DHARMA_KINGS_ENABLE_BUILDING_FAITH_PURCHASE',		'COLLECTION_PLAYER_DISTRICTS',			'EFFECT_ENABLE_BUILDING_FAITH_PURCHASE');
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,										ModifierId)
SELECT 	'TRAIT_CIVILIZATION_SUK_DHARMA_KINGS',			'SUK_DHARMA_KINGS_' || DistrictType || '_FAITH_PURCHASE_MODIFIER'
FROM SukDharmaKingsData;
--------------------------------------------------------------------------------------------------------------------------
-- Modifiers
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO Modifiers	
		(ModifierId,																ModifierType,													SubjectRequirementSetId)
SELECT	'SUK_DHARMA_KINGS_' || DistrictType || '_FAITH_PURCHASE_MODIFIER',			'MODIFIER_SUK_DHARMA_KINGS_ENABLE_BUILDING_FAITH_PURCHASE',		'SUK_DHARMA_KINGS_' || DistrictType || '_REQUIREMENTS'
FROM SukDharmaKingsData;
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,																Name,						Value)
SELECT	'SUK_DHARMA_KINGS_' || DistrictType || '_FAITH_PURCHASE_MODIFIER',			'DistrictType',				DistrictType
FROM SukDharmaKingsData;
--==========================================================================================================================
--==========================================================================================================================