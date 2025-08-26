--==========================================================================================================================
-- LOADING INFO
--==========================================================================================================================
-- LoadingInfo
-------------------------------------	
INSERT INTO LoadingInfo	
		(LeaderType,							ForegroundImage,						BackgroundImage,							PlayDawnOfManAudio)
VALUES	('LEADER_SUK_VERCINGETORIX',			'LEADER_SUK_VERCINGETORIX_NEUTRAL',		'LEADER_SUK_VERCINGETORIX_BACKGROUND',		0);
--==========================================================================================================================
-- LEADERS
--==========================================================================================================================
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,								Kind)
VALUES	('LEADER_SUK_VERCINGETORIX',		'KIND_LEADER');	
-------------------------------------
-- Leaders
-------------------------------------	
INSERT INTO Leaders	
		(LeaderType,						Name,											InheritFrom,		SceneLayers)
VALUES	('LEADER_SUK_VERCINGETORIX',		'LOC_LEADER_SUK_VERCINGETORIX_NAME',			'LEADER_DEFAULT',	4);
-------------------------------------
-- LeaderQuotes
-------------------------------------	
INSERT INTO LeaderQuotes	
		(LeaderType,						Quote)
VALUES	('LEADER_SUK_VERCINGETORIX',		'LOC_PEDIA_LEADERS_PAGE_SUK_VERCINGETORIX_QUOTE');	
-------------------------------------
-- LeaderTraits
-------------------------------------	
INSERT INTO LeaderTraits	
		(LeaderType,						TraitType)
VALUES	('LEADER_SUK_VERCINGETORIX',		'TRAIT_LEADER_SUK_GALLIC_WAR');	
-------------------------------------
-- FavoredReligions
-------------------------------------
INSERT OR REPLACE INTO FavoredReligions 
		(LeaderType,					ReligionType)
SELECT	'LEADER_SUK_VERCINGETORIX',		'RELIGION_DRUIDISM'
WHERE EXISTS (SELECT * FROM Religions WHERE ReligionType = 'RELIGION_DRUIDISM');
--==========================================================================================================================
-- TRAITS
-- Gallic War
--==========================================================================================================================
-- Types
-------------------------------------	
INSERT OR REPLACE INTO Types	
		(Type,												Kind)
VALUES	('TRAIT_LEADER_SUK_GALLIC_WAR',						'KIND_TRAIT');	
-------------------------------------			
-- Traits			
-------------------------------------				
INSERT INTO Traits				
		(TraitType,										Name,													Description)
VALUES	('TRAIT_LEADER_SUK_GALLIC_WAR',					'LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME',		'LOC_TRAIT_LEADER_SUK_GALLIC_WAR_DESCRIPTION');
--==========================================================================================================================
-- +1 [ICON_Strength] Combat Strength for each type City-State you are Suzerain of.
----------------------------------------------------------------------------------------------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,									ModifierId)
SELECT	'TRAIT_LEADER_SUK_GALLIC_WAR', 				'SUK_GALLIC_WAR_COMBAT_'||LeaderType
FROM Leaders WHERE InheritFrom = 'LEADER_MINOR_CIV_DEFAULT';
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
		'SUK_GALLIC_WAR_COMBAT_'||LeaderType,
		'MODIFIER_PLAYER_UNITS_ADJUST_COMBAT_STRENGTH',
		'SUK_GALLIC_WAR_COMBAT_REQUIREMENTS_'||LeaderType,
		NULL
FROM Leaders WHERE InheritFrom = 'LEADER_MINOR_CIV_DEFAULT';
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,								Name,			Value)
SELECT	'SUK_GALLIC_WAR_COMBAT_'||LeaderType,		'Amount',		1
FROM Leaders WHERE InheritFrom = 'LEADER_MINOR_CIV_DEFAULT';
-------------------------------------
-- ModifierStrings
-------------------------------------
INSERT INTO ModifierStrings
		(ModifierId,								Context,			'Text')
SELECT	'SUK_GALLIC_WAR_COMBAT_'||LeaderType,		'Preview',			'LOC_ABILITY_SUK_GALLIC_WAR_COMBAT_STRENGTH_'||LeaderType||'_DESCRIPTION'
FROM Leaders WHERE InheritFrom = 'LEADER_MINOR_CIV_DEFAULT';
----------------------------------------------------------------------------------------------------------------------------
-- REQUIREMENTS
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,										RequirementSetType)
SELECT 'SUK_GALLIC_WAR_COMBAT_REQUIREMENTS_'||LeaderType,		'REQUIREMENTSET_TEST_ALL'
FROM Leaders WHERE InheritFrom = 'LEADER_MINOR_CIV_DEFAULT';
-------------------------------------
-- RequirementSetRequirements
-------------------------------------
INSERT INTO RequirementSetRequirements
		(RequirementSetId,										RequirementId)
SELECT 'SUK_GALLIC_WAR_COMBAT_REQUIREMENTS_'||LeaderType,		'REQUIRES_SUK_GALLIC_WAR_COMBAT_'||LeaderType
FROM Leaders WHERE InheritFrom = 'LEADER_MINOR_CIV_DEFAULT';
-------------------------------------
-- Requirements
-------------------------------------
INSERT INTO Requirements
		(RequirementId, 										RequirementType)
SELECT 'REQUIRES_SUK_GALLIC_WAR_COMBAT_'||LeaderType,			'REQUIREMENT_PLAYER_IS_SUZERAIN_X_TYPE'
FROM Leaders WHERE InheritFrom = 'LEADER_MINOR_CIV_DEFAULT';
-------------------------------------
-- RequirementArguments
-------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 									Name,					Value)
SELECT 'REQUIRES_SUK_GALLIC_WAR_COMBAT_'||LeaderType,		'LeaderType',			LeaderType
FROM Leaders WHERE InheritFrom = 'LEADER_MINOR_CIV_DEFAULT';

INSERT INTO RequirementArguments
		(RequirementId, 									Name,					Value)
SELECT 'REQUIRES_SUK_GALLIC_WAR_COMBAT_'||LeaderType,		'Amount',				1
FROM Leaders WHERE InheritFrom = 'LEADER_MINOR_CIV_DEFAULT';
--==========================================================================================================================
-- Create a faux Unit Ability for the combat bonus
----------------------------------------------------------------------------------------------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,								ModifierId)
VALUES	('TRAIT_LEADER_SUK_GALLIC_WAR', 		'SUK_GALLIC_WAR_COMBAT_ABILTIY');
-------------------------------------
-- Modifiers
-------------------------------------
INSERT INTO Modifiers	
		(ModifierId,							ModifierType)
VALUES	('SUK_GALLIC_WAR_COMBAT_ABILTIY',		'MODIFIER_PLAYER_UNITS_GRANT_ABILITY');
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,							Name,					Value)
VALUES	('SUK_GALLIC_WAR_COMBAT_ABILTIY',		'AbilityType',			'ABILITY_SUK_GALLIC_WAR');
-----------------------------------------------------------------------------------
-- Abilities
-----------------------------------------------------------------------------------
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,								Kind)
VALUES	('ABILITY_SUK_GALLIC_WAR',			'KIND_ABILITY');
-------------------------------------
-- TypeTags
-------------------------------------	
INSERT INTO TypeTags
		(Type,								Tag)
VALUES	('ABILITY_SUK_GALLIC_WAR',			'CLASS_ALL_COMBAT_UNITS');
-------------------------------------
-- UnitAbilities
-------------------------------------					
INSERT INTO UnitAbilities			
	(
		UnitAbilityType,
		Name,
		Description,
		Inactive
	)
	VALUES	
	(
		'ABILITY_SUK_GALLIC_WAR',
		'LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME',
		'LOC_ABILITY_SUK_GALLIC_WAR_COMBAT_DESCRIPTION',
		 1
	);
--==========================================================================================================================
-- Receive a free [ICON_Envoy] Envoy whenever you recruit a [ICON_GreatGeneral] Great General.
----------------------------------------------------------------------------------------------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,								ModifierId)
VALUES	('TRAIT_LEADER_SUK_GALLIC_WAR', 		'SUK_GALLIC_WAR_ENVOY');
-------------------------------------
-- Modifiers
-------------------------------------
INSERT INTO Modifiers	
		(
			ModifierId,
			ModifierType,
			SubjectRequirementSetId
		)
VALUES
		(
			'SUK_GALLIC_WAR_ENVOY',
			'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',
			'SUK_GALLIC_WAR_UNIT_IS_GREAT_GENERAL'
		);
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,					Name,					Value)
VALUES	('SUK_GALLIC_WAR_ENVOY',		'ModifierId',			'GREATPERSON_INFLUENCE_TOKENS_SMALL');
-------------------------------------			
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,									RequirementSetType)
VALUES	('SUK_GALLIC_WAR_UNIT_IS_GREAT_GENERAL',			'REQUIREMENTSET_TEST_ALL');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------	
INSERT INTO RequirementSetRequirements
		(RequirementSetId,									RequirementId)
VALUES	('SUK_GALLIC_WAR_UNIT_IS_GREAT_GENERAL',			'REQUIREMENT_SUK_GALLIC_WAR_UNIT_IS_GENERAL');
-------------------------------------
-- Requirements
-------------------------------------
INSERT INTO Requirements
		(RequirementId, 									RequirementType)
VALUES	('REQUIREMENT_SUK_GALLIC_WAR_UNIT_IS_GENERAL',		'REQUIREMENT_GREAT_PERSON_TYPE_MATCHES');
-------------------------------------
-- RequirementArguments
-------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 									Name,						Value)
VALUES	('REQUIREMENT_SUK_GALLIC_WAR_UNIT_IS_GENERAL', 		'GreatPersonClassType',		'GREAT_PERSON_CLASS_GENERAL');
--==========================================================================================================================
-- When an Encampment or Dūnon is built, receive Ancient Walls in that City.
----------------------------------------------------------------------------------------------------------------------------
-- Modifiers
-------------------------------------
INSERT INTO Modifiers	
		(
			ModifierId,
			ModifierType,
			SubjectRequirementSetId,

			RunOnce,
			Permanent
		)
VALUES
		(
			'SUK_GALLIC_WAR_FREE_WALLS',
			'MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE',
			'SUK_GALLIC_WAR_FREE_WALLS_IS_VERCINGETORIX_REQUIREMENTS',

			1,
			1
		),
		(
			'SUK_GALLIC_WAR_FREE_WALLS_DISTRICTS',
			'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',
			'SUK_GALLIC_WAR_FREE_WALLS_DISTRICTS_REQUIREMENTS',

			0,
			0
		);
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,								Name,					Value)
VALUES	('SUK_GALLIC_WAR_FREE_WALLS',				'BuildingType',			'BUILDING_WALLS'),
		('SUK_GALLIC_WAR_FREE_WALLS_DISTRICTS',		'ModifierId',			'SUK_GALLIC_WAR_FREE_WALLS');
-------------------------------------			
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,												RequirementSetType)
VALUES	('SUK_GALLIC_WAR_FREE_WALLS_IS_VERCINGETORIX_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
		('SUK_GALLIC_WAR_FREE_WALLS_DISTRICTS_REQUIREMENTS',			'REQUIREMENTSET_TEST_ANY');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------	
INSERT INTO RequirementSetRequirements
		(RequirementSetId,												RequirementId)
VALUES	('SUK_GALLIC_WAR_FREE_WALLS_IS_VERCINGETORIX_REQUIREMENTS',		'REQUIRES_PLAYER_IS_SUK_VERCINGETORIX'),
		('SUK_GALLIC_WAR_FREE_WALLS_DISTRICTS_REQUIREMENTS',			'REQUIRES_CITY_HAS_ENCAMPMENT');
-------------------------------------
-- Requirements
-------------------------------------
INSERT INTO Requirements
		(RequirementId, 								RequirementType)
VALUES	('REQUIRES_PLAYER_IS_SUK_VERCINGETORIX',		'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES');
-------------------------------------
-- RequirementArguments
-------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 								Name,						Value)
VALUES	('REQUIRES_PLAYER_IS_SUK_VERCINGETORIX', 		'LeaderType',				'LEADER_SUK_VERCINGETORIX');
-------------------------------------
-- TraitModifiers/ImprovementModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,								ModifierId)
VALUES	('TRAIT_LEADER_SUK_GALLIC_WAR', 		'SUK_GALLIC_WAR_FREE_WALLS_DISTRICTS');

INSERT INTO ImprovementModifiers			
		(ImprovementType,						ModifierId)
VALUES	('IMPROVEMENT_SUK_DUNON', 				'SUK_GALLIC_WAR_FREE_WALLS');
--==========================================================================================================================
-- AGENDAS
-- King Over Warriors
--==========================================================================================================================
-- -- HistoricalAgendas
-- -------------------------------------	
INSERT INTO HistoricalAgendas	
		(LeaderType,								AgendaType)
VALUES	('LEADER_SUK_VERCINGETORIX',				'AGENDA_SUK_KING_OVER_WARRIORS');
-------------------------------------
-- Agendas			
-------------------------------------				
INSERT INTO Agendas				
		(AgendaType,								Name,											Description)
VALUES	('AGENDA_SUK_KING_OVER_WARRIORS',			'LOC_AGENDA_SUK_KING_OVER_WARRIORS_NAME',		'LOC_AGENDA_SUK_KING_OVER_WARRIORS_DESCRIPTION');
-------------------------------------			
-- ExclusiveAgendas			
-------------------------------------				
INSERT INTO ExclusiveAgendas				
		(AgendaOne,									AgendaTwo)
VALUES	('AGENDA_SUK_KING_OVER_WARRIORS',			'AGENDA_EXPLORER');
-------------------------------------			
-- AgendaTraits			
-------------------------------------				
INSERT INTO AgendaTraits				
		(AgendaType,								TraitType)
VALUES	('AGENDA_SUK_KING_OVER_WARRIORS',			'TRAIT_AGENDA_SUK_KING_OVER_WARRIORS');
-------------------------------------
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,										Kind)
VALUES	('TRAIT_AGENDA_SUK_KING_OVER_WARRIORS',		'KIND_TRAIT');	
-------------------------------------			
-- Traits			
-------------------------------------				
INSERT INTO Traits				
		(TraitType,									Name,												Description)
VALUES	('TRAIT_AGENDA_SUK_KING_OVER_WARRIORS',		'LOC_AGENDA_SUK_KING_OVER_WARRIORS_NAME',			'LOC_AGENDA_SUK_KING_OVER_WARRIORS_DESCRIPTION');
-------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,									ModifierId)
VALUES	('TRAIT_AGENDA_SUK_KING_OVER_WARRIORS', 	'AGENDA_SUK_KING_OVER_WARRIORS_KUDOS'),
		('TRAIT_AGENDA_SUK_KING_OVER_WARRIORS', 	'AGENDA_SUK_KING_OVER_WARRIORS_WARNING');
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- Modifiers
-------------------------------------
INSERT INTO Modifiers	
		(ModifierId,										ModifierType,										OwnerRequirementSetId,		SubjectRequirementSetId)
VALUES	('AGENDA_SUK_KING_OVER_WARRIORS_KUDOS',				'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',		'ON_TURN_STARTED',			'KING_OVER_WARRIORS_KUDOS'),
		('AGENDA_SUK_KING_OVER_WARRIORS_WARNING',			'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',		'ON_TURN_STARTED',			'KING_OVER_WARRIORS_WARNING');
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,										Name,							Value)
VALUES	('AGENDA_SUK_KING_OVER_WARRIORS_KUDOS',				'InitialValue',					8),
		('AGENDA_SUK_KING_OVER_WARRIORS_KUDOS',				'StatementKey',					'LOC_DIPLO_KUDO_EXIT_LEADER_SUK_VERCINGETORIX_ANY'),
		('AGENDA_SUK_KING_OVER_WARRIORS_KUDOS',				'SimpleModifierDescription',	'LOC_DIPLO_MODIFIER_SUK_KING_OVER_WARRIORS_KUDO'),

		('AGENDA_SUK_KING_OVER_WARRIORS_WARNING',			'InitialValue',					-12),
		('AGENDA_SUK_KING_OVER_WARRIORS_WARNING',			'StatementKey',					'LOC_DIPLO_WARNING_EXIT_LEADER_SUK_VERCINGETORIX_ANY'),
		('AGENDA_SUK_KING_OVER_WARRIORS_WARNING',			'SimpleModifierDescription',	'LOC_DIPLO_MODIFIER_SUK_KING_OVER_WARRIORS_WARNING');
-------------------------------------
-- ModifierStrings
-------------------------------------
INSERT INTO ModifierStrings
		(ModifierId,										Context,                        'Text')
VALUES	('AGENDA_SUK_KING_OVER_WARRIORS_KUDOS',				'Sample',						'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL'),
		('AGENDA_SUK_KING_OVER_WARRIORS_WARNING',			'Sample',						'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL');
----------------------------------------------------------------------------------------------------------------------------
-- REQUIREMENTS
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,								RequirementSetType)
VALUES	('KING_OVER_WARRIORS_KUDOS',					'REQUIREMENTSET_TEST_ALL'),
		('KING_OVER_WARRIORS_WARNING',					'REQUIREMENTSET_TEST_ALL');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------
INSERT INTO RequirementSetRequirements
		(RequirementSetId,						RequirementId)
VALUES	('KING_OVER_WARRIORS_KUDOS',			'REQUIRES_HAS_HIGH_STANDING_ARMY'),
			
		('KING_OVER_WARRIORS_WARNING',			'REQUIRES_HAS_HIGH_STANDING_ARMY'),
		('KING_OVER_WARRIORS_WARNING',			'REQUIRES_KING_OVER_WARRIORS_HAS_CAPTURED_CITIES');
-- -------------------------------------
-- -- Requirements
-- -------------------------------------
INSERT INTO Requirements
		(RequirementId, 											RequirementType)
VALUES	('REQUIRES_KING_OVER_WARRIORS_HAS_CAPTURED_CITIES',			'REQUIREMENT_COLLECTION_COUNT_ATLEAST');
-- -------------------------------------
-- -- RequirementArguments
-- -------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 											Name,							Value)
VALUES	('REQUIRES_KING_OVER_WARRIORS_HAS_CAPTURED_CITIES',			'CollectionType',				'COLLECTION_PLAYER_CAPTURED_CITIES'),
		('REQUIRES_KING_OVER_WARRIORS_HAS_CAPTURED_CITIES',			'Count',						1);
--==========================================================================================================================
-- CivilizationLeaders
--==========================================================================================================================
INSERT INTO CivilizationLeaders
		(LeaderType, 						CivilizationType,				CapitalName)
VALUES  ('LEADER_SUK_VERCINGETORIX',		'CIVILIZATION_SUK_GAUL',		'LOC_CITY_NAME_SUK_GAUL_BIBRACTE');
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
		(Civilization,					Leader,							MapName,				X,		Y)
VALUES	('CIVILIZATION_SUK_GAUL',		'LEADER_SUK_VERCINGETORIX',		'GiantEarth',			14,		65),
		('CIVILIZATION_SUK_GAUL',		'LEADER_SUK_VERCINGETORIX',		'GreatestEarthMap',		43,		46),
		('CIVILIZATION_SUK_GAUL',		'LEADER_SUK_VERCINGETORIX',		'LargeEurope',			28,		40),
		('CIVILIZATION_SUK_GAUL',		'LEADER_SUK_VERCINGETORIX',		'PlayEuropeAgain',		33,		49);
--==========================================================================================================================
--==========================================================================================================================