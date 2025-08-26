--==========================================================================================================================
-- LOADING INFO
--==========================================================================================================================
-- LoadingInfo
-------------------------------------	
INSERT INTO LoadingInfo	
		(LeaderType,							ForegroundImage,						BackgroundImage,							PlayDawnOfManAudio)
VALUES	('LEADER_SUK_TRISONG_DETSEN',			'LEADER_SUK_TRISONG_DETSEN_NEUTRAL',	'LEADER_SUK_TRISONG_DETSEN_BACKGROUND',		0);
--==========================================================================================================================
-- LEADERS
--==========================================================================================================================
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,									Kind)
VALUES	('LEADER_SUK_TRISONG_DETSEN',			'KIND_LEADER');	
-------------------------------------
-- Leaders
-------------------------------------	
INSERT INTO Leaders	
		(LeaderType,							Name,										InheritFrom,		SceneLayers,	SameSexPercentage)
VALUES	('LEADER_SUK_TRISONG_DETSEN',			'LOC_LEADER_SUK_TRISONG_DETSEN_NAME',		'LEADER_DEFAULT',	4,				100);	
-------------------------------------
-- LeaderQuotes
-------------------------------------	
INSERT INTO LeaderQuotes	
		(LeaderType,							Quote)
VALUES	('LEADER_SUK_TRISONG_DETSEN',			'LOC_PEDIA_LEADERS_PAGE_SUK_TRISONG_DETSEN_QUOTE');	
-- -------------------------------------
-- -- HistoricalAgendas
-- -------------------------------------	
INSERT INTO HistoricalAgendas	
		(LeaderType,							AgendaType)
VALUES	('LEADER_SUK_TRISONG_DETSEN',			'AGENDA_SUK_ENLIGHTENED_LORD');	
-------------------------------------
-- LeaderTraits
-------------------------------------	
INSERT INTO LeaderTraits	
		(LeaderType,							TraitType)
VALUES	('LEADER_SUK_TRISONG_DETSEN',			'TRAIT_LEADER_SUK_CAPTURE_OF_CHANGAN');
-- -------------------------------------
-- -- FavoredReligions
-- -------------------------------------	
INSERT INTO FavoredReligions 
		(LeaderType,							ReligionType)
VALUES	('LEADER_SUK_TRISONG_DETSEN',			'RELIGION_BUDDHISM');

UPDATE FavoredReligions
SET ReligionType = 'RELIGION_B2_VAJRAYANA'
WHERE LeaderType = 'LEADER_SUK_TRISONG_DETSEN'
AND EXISTS (SELECT * FROM Religions WHERE ReligionType = 'RELIGION_B2_VAJRAYANA');
--==========================================================================================================================
-- TRAITS
--==========================================================================================================================
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,													Kind)
VALUES	('TRAIT_LEADER_SUK_CAPTURE_OF_CHANGAN',					'KIND_TRAIT');	
-------------------------------------			
-- Traits			
-------------------------------------				
INSERT INTO Traits				
		(TraitType,												Name,												Description)
VALUES	('TRAIT_LEADER_SUK_CAPTURE_OF_CHANGAN',					'LOC_TRAIT_LEADER_SUK_CAPTURE_OF_CHANGAN_NAME',		'LOC_TRAIT_LEADER_SUK_CAPTURE_OF_CHANGAN_DESCRIPTION');
--==========================================================================================================================
-- +2 [ICON_GreatGeneral] Great General points in cities with both an Encampment and a Dzong.
--==========================================================================================================================
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,										ModifierId)
VALUES 	('TRAIT_LEADER_SUK_CAPTURE_OF_CHANGAN',			'SUK_CAPTURE_OF_CHANGAN_GREAT_GENERAL_POINTS');
-------------------------------------
-- Modifiers
-------------------------------------
INSERT INTO Modifiers	
		(ModifierId,										ModifierType,											SubjectRequirementSetId)
VALUES	('SUK_CAPTURE_OF_CHANGAN_GREAT_GENERAL_POINTS',		'MODIFIER_PLAYER_CITIES_ADJUST_GREAT_PERSON_POINT',		'SUK_CAPTURE_OF_CHANGAN_DZONG_ENCAMPMENT_REQUIREMENTS');
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,												Name,							Value)
VALUES	('SUK_CAPTURE_OF_CHANGAN_GREAT_GENERAL_POINTS',				'Amount',						1),
		('SUK_CAPTURE_OF_CHANGAN_GREAT_GENERAL_POINTS',				'GreatPersonClassType',			'GREAT_PERSON_CLASS_GENERAL');
----------------------------------------------------------------------------------------------------------------------------
-- REQUIREMENTS
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,														RequirementSetType)
VALUES	('SUK_CAPTURE_OF_CHANGAN_DZONG_ENCAMPMENT_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------	
INSERT INTO RequirementSetRequirements
		(RequirementSetId,														RequirementId)
VALUES	('SUK_CAPTURE_OF_CHANGAN_DZONG_ENCAMPMENT_REQUIREMENTS',				'SUK_CAPTURE_OF_CHANGAN_HAS_DZONG'),
		('SUK_CAPTURE_OF_CHANGAN_DZONG_ENCAMPMENT_REQUIREMENTS',				'REQUIRES_CITY_HAS_ENCAMPMENT');
-------------------------------------
-- Requirements
-------------------------------------
INSERT INTO Requirements
		(RequirementId, 										RequirementType)
VALUES	('SUK_CAPTURE_OF_CHANGAN_HAS_DZONG',					'REQUIREMENT_CITY_HAS_DISTRICT');
-------------------------------------
-- RequirementArguments
-------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 								Name,					Value)
VALUES	('SUK_CAPTURE_OF_CHANGAN_HAS_DZONG', 			'DistrictType',			'DISTRICT_SUK_DZONG');
--==========================================================================================================================
-- Land combat units in those cities begin with a free promotion if the city has a Worship Building.
--==========================================================================================================================
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,																Kind)
VALUES	('MODIFIER_SUK_CAPTURE_OF_CHANGAN_CITY_UNITS_EXPERIENCE',			'KIND_MODIFIER');
-------------------------------------
-- DynamicModifiers
-------------------------------------					
INSERT INTO DynamicModifiers			
		(ModifierType,														CollectionType,							EffectType)
VALUES	('MODIFIER_SUK_CAPTURE_OF_CHANGAN_CITY_UNITS_EXPERIENCE',			'COLLECTION_CITY_TRAINED_UNITS',		'EFFECT_ADJUST_UNIT_GRANT_EXPERIENCE');
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,										ModifierId)
VALUES 	('TRAIT_LEADER_SUK_CAPTURE_OF_CHANGAN',			'SUK_CAPTURE_OF_CHANGAN_FREE_PROMOTION');
-------------------------------------
-- Modifiers
-------------------------------------
INSERT INTO Modifiers	
		(ModifierId,											ModifierType,													SubjectRequirementSetId)
VALUES	('SUK_CAPTURE_OF_CHANGAN_FREE_PROMOTION',				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',						'SUK_CAPTURE_OF_CHANGAN_DZONG_ENCAMPMENT_WORSHIP_REQUIREMENTS'),
		('SUK_CAPTURE_OF_CHANGAN_FREE_PROMOTION_MODIFIER',		'MODIFIER_SUK_CAPTURE_OF_CHANGAN_CITY_UNITS_EXPERIENCE',		'UNIT_IS_DOMAIN_LAND');
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,												Name,						Value)
VALUES	('SUK_CAPTURE_OF_CHANGAN_FREE_PROMOTION',					'ModifierId',				'SUK_CAPTURE_OF_CHANGAN_FREE_PROMOTION_MODIFIER'),
		('SUK_CAPTURE_OF_CHANGAN_FREE_PROMOTION_MODIFIER',			'Amount',					-1);
----------------------------------------------------------------------------------------------------------------------------
-- REQUIREMENTS
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,														RequirementSetType)
VALUES	('SUK_CAPTURE_OF_CHANGAN_DZONG_ENCAMPMENT_WORSHIP_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
		('SUK_CAPTURE_OF_CHANGAN_HAS_WORSHIP_BUILDING_REQUIREMENTS',			'REQUIREMENTSET_TEST_ANY');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------	
INSERT INTO RequirementSetRequirements
		(RequirementSetId,														RequirementId)
VALUES	('SUK_CAPTURE_OF_CHANGAN_DZONG_ENCAMPMENT_WORSHIP_REQUIREMENTS',		'SUK_CAPTURE_OF_CHANGAN_HAS_DZONG'),
		('SUK_CAPTURE_OF_CHANGAN_DZONG_ENCAMPMENT_WORSHIP_REQUIREMENTS',		'REQUIRES_CITY_HAS_ENCAMPMENT'),
		('SUK_CAPTURE_OF_CHANGAN_DZONG_ENCAMPMENT_WORSHIP_REQUIREMENTS',		'SUK_CAPTURE_OF_CHANGAN_HAS_WORSHIP_BUILDING');

INSERT INTO RequirementSetRequirements
		(RequirementSetId,													RequirementId)
SELECT	'SUK_CAPTURE_OF_CHANGAN_HAS_WORSHIP_BUILDING_REQUIREMENTS',			'SUK_CAPTURE_OF_CHANGAN_' || BuildingType || '_REQUIREMENT'
FROM Buildings WHERE EnabledByReligion = 1;
-------------------------------------
-- Requirements
-------------------------------------
INSERT INTO Requirements
		(RequirementId, 													RequirementType)
VALUES	('SUK_CAPTURE_OF_CHANGAN_HAS_WORSHIP_BUILDING',						'REQUIREMENT_REQUIREMENTSET_IS_MET');

INSERT INTO Requirements
		(RequirementId, 													RequirementType)
SELECT	'SUK_CAPTURE_OF_CHANGAN_' || BuildingType || '_REQUIREMENT',		'REQUIREMENT_CITY_HAS_BUILDING'		
FROM Buildings WHERE EnabledByReligion = 1;
-------------------------------------
-- RequirementArguments
-------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 												Name,					Value)
VALUES	('SUK_CAPTURE_OF_CHANGAN_HAS_WORSHIP_BUILDING', 				'RequirementSetId',		'SUK_CAPTURE_OF_CHANGAN_HAS_WORSHIP_BUILDING_REQUIREMENTS');

INSERT INTO RequirementArguments
		(RequirementId, 												Name,					Value)
SELECT	'SUK_CAPTURE_OF_CHANGAN_' || BuildingType || '_REQUIREMENT', 	'BuildingType',			BuildingType
FROM Buildings WHERE EnabledByReligion = 1;
--==========================================================================================================================
-- AGENDAS
--==========================================================================================================================
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,										Kind)
VALUES	('TRAIT_AGENDA_SUK_ENLIGHTENED_LORD',		'KIND_TRAIT');			
-------------------------------------			
-- Agendas			
-------------------------------------				
INSERT INTO Agendas				
		(AgendaType,							Name,										Description)
VALUES	('AGENDA_SUK_ENLIGHTENED_LORD',			'LOC_AGENDA_SUK_ENLIGHTENED_LORD_NAME',		'LOC_AGENDA_SUK_ENLIGHTENED_LORD_DESCRIPTION');
-------------------------------------			
-- ExclusiveAgendas			
-------------------------------------				
INSERT INTO ExclusiveAgendas				
		(AgendaOne,								AgendaTwo)
VALUES	('AGENDA_SUK_ENLIGHTENED_LORD',			'AGENDA_SYCOPHANT'),
		('AGENDA_SUK_ENLIGHTENED_LORD',			'AGENDA_SYMPATHIZER'),	
		('AGENDA_SUK_ENLIGHTENED_LORD',			'AGENDA_DEVOUT');
-------------------------------------			
-- Traits			
-------------------------------------				
INSERT INTO Traits				
		(TraitType,									Name,										Description)
VALUES	('TRAIT_AGENDA_SUK_ENLIGHTENED_LORD',		'LOC_AGENDA_SUK_ENLIGHTENED_LORD_NAME',		'LOC_AGENDA_SUK_ENLIGHTENED_LORD_DESCRIPTION');	
-------------------------------------			
-- AgendaTraits			
-------------------------------------
INSERT INTO AgendaTraits				
		(AgendaType,							TraitType)
VALUES	('AGENDA_SUK_ENLIGHTENED_LORD',			'TRAIT_AGENDA_SUK_ENLIGHTENED_LORD');
-------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,										ModifierId)
VALUES	('TRAIT_AGENDA_SUK_ENLIGHTENED_LORD', 			'AGENDA_SUK_ENLIGHTENED_LORD_KUDOS'),
		('TRAIT_AGENDA_SUK_ENLIGHTENED_LORD', 			'AGENDA_SUK_ENLIGHTENED_LORD_WARNING');
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- Modifiers
-------------------------------------
INSERT INTO Modifiers	
		(ModifierId,											ModifierType,											SubjectRequirementSetId)
VALUES	('AGENDA_SUK_ENLIGHTENED_LORD_KUDOS',					'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',			'SUK_ENLIGHTENED_LORD_KUDOS'),
		('AGENDA_SUK_ENLIGHTENED_LORD_WARNING',					'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',			'SUK_ENLIGHTENED_LORD_WARNING');
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,									Name,							Value)
VALUES	('AGENDA_SUK_ENLIGHTENED_LORD_KUDOS',			'InitialValue',					8),
		('AGENDA_SUK_ENLIGHTENED_LORD_KUDOS',			'StatementKey',					'LOC_DIPLO_KUDO_EXIT_LEADER_SUK_TRISONG_DETSEN_ANY'),
		('AGENDA_SUK_ENLIGHTENED_LORD_KUDOS',			'SimpleModifierDescription',	'LOC_DIPLO_MODIFIER_SUK_ENLIGHTENED_LORD_KUDOS'),

		('AGENDA_SUK_ENLIGHTENED_LORD_WARNING',			'InitialValue',					-12),
		('AGENDA_SUK_ENLIGHTENED_LORD_WARNING',			'StatementKey',					'LOC_DIPLO_WARNING_EXIT_LEADER_SUK_TRISONG_DETSEN_ANY'),
		('AGENDA_SUK_ENLIGHTENED_LORD_WARNING',			'SimpleModifierDescription',	'LOC_DIPLO_MODIFIER_SUK_ENLIGHTENED_LORD_WARNING');
-------------------------------------
-- ModifierStrings
-------------------------------------
INSERT INTO ModifierStrings
		(ModifierId,										Context,                        'Text')
VALUES	('AGENDA_SUK_ENLIGHTENED_LORD_KUDOS',				'Sample',						'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL'),
		('AGENDA_SUK_ENLIGHTENED_LORD_WARNING',				'Sample',						'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL');
----------------------------------------------------------------------------------------------------------------------------
-- REQUIREMENTS
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,							RequirementSetType)
VALUES	('SUK_ENLIGHTENED_LORD_KUDOS',				'REQUIREMENTSET_TEST_ALL'),

		('SUK_ENLIGHTENED_LORD_WARNING_REQS',		'REQUIREMENTSET_TEST_ANY'),
		('SUK_ENLIGHTENED_LORD_WARNING',			'REQUIREMENTSET_TEST_ALL');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------
INSERT INTO RequirementSetRequirements
		(RequirementSetId,							RequirementId)
VALUES	('SUK_ENLIGHTENED_LORD_KUDOS',				'REQUIRES_HAS_HIGH_FAITH'),
		('SUK_ENLIGHTENED_LORD_KUDOS',				'REQUIRES_PLAYER_HAS_GOLDEN_AGE'),
		('SUK_ENLIGHTENED_LORD_KUDOS',				'REQUIRES_MAJOR_CIV_OPPONENT'),
		('SUK_ENLIGHTENED_LORD_KUDOS',				'REQUIRES_MET_10_TURNS_AGO'),

		('SUK_ENLIGHTENED_LORD_WARNING_REQS',		'REQUIRES_HAS_LOW_FAITH'),
		('SUK_ENLIGHTENED_LORD_WARNING_REQS',		'REQUIRES_PLAYER_HAS_DARK_AGE'),
			
		('SUK_ENLIGHTENED_LORD_WARNING',			'REQUIRES_SUK_ENLIGHTENED_LORD_WARNING_REQS'),
		('SUK_ENLIGHTENED_LORD_WARNING',			'REQUIRES_MAJOR_CIV_OPPONENT'),
		('SUK_ENLIGHTENED_LORD_WARNING',			'REQUIRES_MET_10_TURNS_AGO');
-- -------------------------------------
-- -- Requirements
-- -------------------------------------
INSERT INTO Requirements
		(RequirementId, 										RequirementType)
VALUES	('REQUIRES_SUK_ENLIGHTENED_LORD_WARNING_REQS',			'REQUIREMENT_REQUIREMENTSET_IS_MET');
-- -------------------------------------
-- -- RequirementArguments
-- -------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 										Name,						Value)
VALUES	('REQUIRES_SUK_ENLIGHTENED_LORD_WARNING_REQS',			'RequirementSetId',			'SUK_ENLIGHTENED_LORD_WARNING_REQS');
--==========================================================================================================================
-- AI Lists
--==========================================================================================================================
-- AiListTypes
-------------------------------------	
INSERT INTO AiListTypes	
		(ListType)
VALUES	('Suk_Trisong_Detsen_Wonders'),
		('Suk_Trisong_Detsen_Districts'),
		('Suk_Trisong_Detsen_Civics'),
		('Suk_Trisong_Detsen_Techs');
-------------------------------------
-- AiLists
-------------------------------------	
INSERT INTO AiLists	
		(ListType,							AgendaType,										System)
VALUES	('Suk_Trisong_Detsen_Wonders',		'AGENDA_SUK_ENLIGHTENED_LORD',					'Buildings'),
		('Suk_Trisong_Detsen_Districts',	'AGENDA_SUK_ENLIGHTENED_LORD',					'Districts'),
		('Suk_Trisong_Detsen_Civics',		'AGENDA_SUK_ENLIGHTENED_LORD',					'Civics'),
		('Suk_Trisong_Detsen_Techs',		'AGENDA_SUK_ENLIGHTENED_LORD',					'Technologies');
-------------------------------------		
-- AiFavoredItems
-------------------------------------	
INSERT INTO AiFavoredItems	
		(ListType,							Item)
VALUES	('Suk_Trisong_Detsen_Wonders',		'BUILDING_POTALA_PALACE'),

		('Suk_Trisong_Detsen_Districts',	'DISTRICT_SUK_DZONG'),
		('Suk_Trisong_Detsen_Districts',	'DISTRICT_ENCAMPMENT'),

		('Suk_Trisong_Detsen_Civics',		'CIVIC_THEOLOGY'),
		('Suk_Trisong_Detsen_Civics',		'CIVIC_REFORMED_CHURCH'),

		('Suk_Trisong_Detsen_Techs',		'TECH_ASTRONOMY'),
		('Suk_Trisong_Detsen_Techs',		'TECH_ASTROLOGY');	
--==========================================================================================================================
-- CivilizationLeaders
--==========================================================================================================================
INSERT INTO CivilizationLeaders
		(LeaderType, 					CivilizationType,			CapitalName)
VALUES  ('LEADER_SUK_TRISONG_DETSEN',	'CIVILIZATION_SUK_TIBET',	'LOC_CITY_NAME_SUK_TIBET_LHASA');
--==========================================================================================================================
-- TSL
--==========================================================================================================================
CREATE TABLE IF NOT EXISTS StartPosition
	(MapName TEXT,
	Civilization TEXT,
	Leader TEXT,
	X INT default 0,
	Y INT default 0);

INSERT INTO StartPosition
		(Civilization,					Leader,								MapName,				X,		Y)
VALUES	('CIVILIZATION_SUK_TIBET',		'LEADER_SUK_TRISONG_DETSEN',		'GiantEarth',			69,		54),
		('CIVILIZATION_SUK_TIBET',		'LEADER_SUK_TRISONG_DETSEN',		'LargestEarthCustom',	91,		68),
		('CIVILIZATION_SUK_TIBET',		'LEADER_SUK_TRISONG_DETSEN',		'GreatestEarthMap',		78,		44);
--==========================================================================================================================
--==========================================================================================================================