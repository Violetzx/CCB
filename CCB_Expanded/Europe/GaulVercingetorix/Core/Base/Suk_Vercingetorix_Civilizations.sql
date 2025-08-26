--==========================================================================================================================
-- CIVILIZATIONS
--==========================================================================================================================
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,								Kind)
VALUES	('CIVILIZATION_SUK_GAUL',			'KIND_CIVILIZATION');
-------------------------------------			
-- Civilizations			
-------------------------------------				
-- Types
-------------------------------------	
INSERT INTO Civilizations	
		(CivilizationType,			Name,								Description,								Adjective,								StartingCivilizationLevelType,	RandomCityNameDepth,	Ethnicity)
VALUES	('CIVILIZATION_SUK_GAUL',	'LOC_CIVILIZATION_SUK_GAUL_NAME',	'LOC_CIVILIZATION_SUK_GAUL_DESCRIPTION',	'LOC_CIVILIZATION_SUK_GAUL_ADJECTIVE',	'CIVILIZATION_LEVEL_FULL_CIV',	10,						'ETHNICITY_EURO');	
-------------------------------------			
-- CityNames			
-------------------------------------		
INSERT INTO CityNames
			(CivilizationType,					CityName)
VALUES		('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_BIBRACTE'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_VIENNE'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_ALESIA'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_GERGOVIA'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_NEMOSSOS'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_LUTETIA'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_CENABUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_DUROCORTORUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_LEMONUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_NAMNETUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_CONDATE'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_BURDIGALA'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_VESONTIO'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_ROTOMAGUS'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_SAMAROBRIVA'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_DIVODURUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_SEGODUNUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_NEMETOCENNA'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_AUTRICUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_SUINDINUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_AVARICON'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_DARIORITUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_AGEDINCUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_ARGENTORATE'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_NOVIOMAGUS'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_BAGACUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_GESORIACUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_GABILLONUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_TOLOSA'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_LUGDUNUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_UXELLODUNUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_DUROTINCON'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_BRATUSPANTION'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_NOVIODUNUM'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_DIVONA'),
			('CIVILIZATION_SUK_GAUL',			'LOC_CITY_NAME_SUK_GAUL_KARNAG');
-------------------------------------
-- CivilizationCitizenNames
-------------------------------------	
INSERT INTO CivilizationCitizenNames	
		(CivilizationType,					CitizenName,								Female,		Modern)
VALUES	('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MALE_1',				0,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MALE_2',				0,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MALE_3',				0,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MALE_4',				0,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MALE_5',				0,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MALE_6',				0,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MALE_7',				0,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MALE_8',				0,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MALE_9',				0,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MALE_10',				0,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_FEMALE_1',			1,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_FEMALE_2',			1,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_FEMALE_3',			1,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_FEMALE_4',			1,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_FEMALE_5',			1,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_FEMALE_6',			1,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_FEMALE_7',			1,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_FEMALE_8',			1,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_FEMALE_9',			1,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_FEMALE_10',			1,			0),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_MALE_1',		0,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_MALE_2',		0,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_MALE_3',		0,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_MALE_4',		0,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_MALE_5',		0,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_MALE_6',		0,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_MALE_7',		0,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_MALE_8',		0,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_MALE_9',		0,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_MALE_10',		0,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_FEMALE_1',		1,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_FEMALE_2',		1,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_FEMALE_3',		1,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_FEMALE_4',		1,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_FEMALE_5',		1,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_FEMALE_6',		1,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_FEMALE_7',		1,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_FEMALE_8',		1,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_FEMALE_9',		1,			1),
		('CIVILIZATION_SUK_GAUL',			'LOC_CITIZEN_SUK_GAUL_MODERN_FEMALE_10',	1,			1);
-------------------------------------			
-- StartBiasResources			
-------------------------------------	
INSERT INTO StartBiasResources	
		(CivilizationType,						ResourceType,	Tier)
SELECT	'CIVILIZATION_SUK_GAUL',				ResourceType,	1
FROM Improvement_ValidResources WHERE ImprovementType = 'IMPROVEMENT_MINE' AND ResourceType NOT IN(SELECT ResourceType FROM RESOURCES WHERE PrereqCivic IS NOT NULL OR PrereqTech IS NOT NULL);
-------------------------------------			
-- CivilizationInfo			
-------------------------------------		
INSERT INTO CivilizationInfo	
			(CivilizationType,				Header,						Caption,								SortIndex)	
VALUES		('CIVILIZATION_SUK_GAUL',		'LOC_CIVINFO_LOCATION',		'LOC_CIVINFO_SUK_GAUL_LOCATION',		10),	
			('CIVILIZATION_SUK_GAUL',		'LOC_CIVINFO_SIZE',			'LOC_CIVINFO_SUK_GAUL_SIZE',			20),	
			('CIVILIZATION_SUK_GAUL',		'LOC_CIVINFO_POPULATION',	'LOC_CIVINFO_SUK_GAUL_POPULATION',		30),	
			('CIVILIZATION_SUK_GAUL',		'LOC_CIVINFO_CAPITAL', 		'LOC_CIVINFO_SUK_GAUL_CAPITAL',			40);
--==========================================================================================================================
-- TRAITS
--==========================================================================================================================
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,													Kind)
VALUES	('TRAIT_CIVILIZATION_SUK_TORCS_AND_CARNYXES',			'KIND_TRAIT'),
		('TRAIT_CIVILIZATION_UNIT_SUK_OATHSWORN',				'KIND_TRAIT'),
		('TRAIT_CIVILIZATION_IMPROVEMENT_SUK_DUNON',			'KIND_TRAIT');
-------------------------------------			
-- Traits			
-------------------------------------				
INSERT INTO Traits				
		(TraitType,												Name,															Description)
VALUES	('TRAIT_CIVILIZATION_SUK_TORCS_AND_CARNYXES',			'LOC_TRAIT_CIVILIZATION_SUK_TORCS_AND_CARNYXES_NAME',			'LOC_TRAIT_CIVILIZATION_SUK_TORCS_AND_CARNYXES_DESCRIPTION'),
		('TRAIT_CIVILIZATION_UNIT_SUK_OATHSWORN',				'LOC_TRAIT_CIVILIZATION_UNIT_SUK_OATHSWORN_NAME',				null),
		('TRAIT_CIVILIZATION_IMPROVEMENT_SUK_DUNON',			'LOC_TRAIT_CIVILIZATION_IMPROVEMENT_SUK_DUNON_NAME',			null);
-------------------------------------
-- CivilizationTraits
-------------------------------------	
INSERT INTO CivilizationTraits	
		(TraitType,													CivilizationType)
VALUES	('TRAIT_CIVILIZATION_SUK_TORCS_AND_CARNYXES',				'CIVILIZATION_SUK_GAUL'),
		('TRAIT_CIVILIZATION_UNIT_SUK_OATHSWORN',					'CIVILIZATION_SUK_GAUL'),
		('TRAIT_CIVILIZATION_IMPROVEMENT_SUK_DUNON',				'CIVILIZATION_SUK_GAUL');
--==========================================================================================================================
-- Cities founded on mineable resources provide that resource's yield modifier to adjacent tiles
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,												ModifierId)
SELECT 'TRAIT_CIVILIZATION_SUK_TORCS_AND_CARNYXES', 			'SUK_TORCS_AND_CARNYXES_' || ResourceType || '_' || YieldType
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
-- When adjacent to minable resources, Encampments provide +2 [ICON_Production] Production, +1 [ICON_Housing] Housing,
-- and Commercial Hubs provide +2 [ICON_Gold] Gold, +1 [ICON_Amenities] Amenity.
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,													ModifierId)
VALUES	('TRAIT_CIVILIZATION_SUK_TORCS_AND_CARNYXES', 				'SUK_TORCS_AND_CARNYXES_ENCAMPMENT_PRODUCTION'),
		('TRAIT_CIVILIZATION_SUK_TORCS_AND_CARNYXES', 				'SUK_TORCS_AND_CARNYXES_ENCAMPMENT_HOUSING'),
		('TRAIT_CIVILIZATION_SUK_TORCS_AND_CARNYXES', 				'SUK_TORCS_AND_CARNYXES_COMMERCIAL_GOLD'),
		('TRAIT_CIVILIZATION_SUK_TORCS_AND_CARNYXES', 				'SUK_TORCS_AND_CARNYXES_COMMERCIAL_AMENITY');
-------------------------------------
-- Modifiers
-------------------------------------
INSERT INTO Modifiers	
		(ModifierId,											ModifierType,												SubjectRequirementSetId)
VALUES	('SUK_TORCS_AND_CARNYXES_ENCAMPMENT_PRODUCTION',		'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE', 			'SUK_TORCS_AND_CARNYXES_ENCAMPMENT'),
		('SUK_TORCS_AND_CARNYXES_ENCAMPMENT_HOUSING',			'MODIFIER_PLAYER_DISTRICTS_ADJUST_HOUSING', 				'SUK_TORCS_AND_CARNYXES_ENCAMPMENT'),
		('SUK_TORCS_AND_CARNYXES_COMMERCIAL_GOLD',				'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE', 			'SUK_TORCS_AND_CARNYXES_COMMERCIAL'),
		('SUK_TORCS_AND_CARNYXES_COMMERCIAL_AMENITY',			'MODIFIER_PLAYER_DISTRICTS_ADJUST_EXTRA_ENTERTAINMENT', 	'SUK_TORCS_AND_CARNYXES_COMMERCIAL');
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,											Name,				Value)
VALUES	('SUK_TORCS_AND_CARNYXES_ENCAMPMENT_PRODUCTION',		'YieldType',		'YIELD_PRODUCTION'),
		('SUK_TORCS_AND_CARNYXES_ENCAMPMENT_PRODUCTION',		'Amount',			2),
		('SUK_TORCS_AND_CARNYXES_ENCAMPMENT_HOUSING',			'Amount',			1),

		('SUK_TORCS_AND_CARNYXES_COMMERCIAL_GOLD',				'YieldType',		'YIELD_GOLD'),
		('SUK_TORCS_AND_CARNYXES_COMMERCIAL_GOLD',				'Amount',			2),
		('SUK_TORCS_AND_CARNYXES_COMMERCIAL_AMENITY',			'Amount',			1);
-------------------------------------			
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,								RequirementSetType)
VALUES	('SUK_TORCS_AND_CARNYXES_ENCAMPMENT',			'REQUIREMENTSET_TEST_ALL'),
		('SUK_TORCS_AND_CARNYXES_COMMERCIAL',			'REQUIREMENTSET_TEST_ALL'),
		('SUK_TORCS_AND_CARNYXES_IS_MINABLE',			'REQUIREMENTSET_TEST_ALL');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------	
INSERT INTO RequirementSetRequirements
		(RequirementSetId,											RequirementId)
VALUES	('SUK_TORCS_AND_CARNYXES_ENCAMPMENT',						'REQUIRES_DISTRICT_IS_ENCAMPMENT'),
		('SUK_TORCS_AND_CARNYXES_ENCAMPMENT',						'REQUIRES_SUK_TORCS_AND_CARNYXES_ADJACENT_MINABLE'),

		('SUK_TORCS_AND_CARNYXES_COMMERCIAL',						'REQUIRES_DISTRICT_IS_COMMERCIAL_HUB'),
		('SUK_TORCS_AND_CARNYXES_COMMERCIAL',						'REQUIRES_SUK_TORCS_AND_CARNYXES_ADJACENT_MINABLE'),

		('SUK_TORCS_AND_CARNYXES_IS_MINABLE',						'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE'),
		('SUK_TORCS_AND_CARNYXES_IS_MINABLE',						'REQUIRES_SUK_TORCS_AND_CARNYXES_IS_ADJACENT'),
		('SUK_TORCS_AND_CARNYXES_IS_MINABLE',						'REQUIRES_SUK_TORCS_AND_CARNYXES_IS_MINABLE');
-------------------------------------
-- -- Requirements
-------------------------------------
INSERT INTO Requirements
		(RequirementId, 											RequirementType)
VALUES	('REQUIRES_SUK_TORCS_AND_CARNYXES_ADJACENT_MINABLE',		'REQUIREMENT_COLLECTION_COUNT_ATLEAST'),
		('REQUIRES_SUK_TORCS_AND_CARNYXES_IS_MINABLE',				'REQUIREMENT_PLOT_RESOURCE_TAG_MATCHES');
-------------------------------------
-- -- RequirementArguments
-------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 											Name,							Value)
VALUES	('REQUIRES_SUK_TORCS_AND_CARNYXES_ADJACENT_MINABLE',		'CollectionType',				'COLLECTION_CITY_PLOT_YIELDS'),
		('REQUIRES_SUK_TORCS_AND_CARNYXES_ADJACENT_MINABLE',		'Count',						1),
		('REQUIRES_SUK_TORCS_AND_CARNYXES_ADJACENT_MINABLE', 		'RequirementSetId',				'SUK_TORCS_AND_CARNYXES_IS_MINABLE'),

		('REQUIRES_SUK_TORCS_AND_CARNYXES_IS_MINABLE',				'Tag',							'CLASS_TORCS_AND_CARNYXES');
-------------------------------------
-- Tags
-------------------------------------
INSERT INTO Tags
			(Tag,								Vocabulary)
VALUES		('CLASS_TORCS_AND_CARNYXES',		'RESOURCE_CLASS');
-------------------------------------
-- TypeTags
-------------------------------------
INSERT INTO TypeTags
			(Type,							Tag)
SELECT		ResourceType,					'CLASS_TORCS_AND_CARNYXES'
FROM Improvement_ValidResources WHERE ImprovementType = 'IMPROVEMENT_MINE';
--==========================================================================================================================
--==========================================================================================================================