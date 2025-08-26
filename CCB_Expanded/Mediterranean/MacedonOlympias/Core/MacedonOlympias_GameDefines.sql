--==========================================================================================================================
-- LEADERS
--==========================================================================================================================
--------------------------------------------------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO Types	
		(Type,					Kind)
VALUES	('LEADER_JFD_OLYMPIAS',	'KIND_LEADER');	
--------------------------------------------------------------------------------------------------------------------------
-- Leaders
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO Leaders	
		(LeaderType,			Name,							InheritFrom,		Sex,		SceneLayers)
VALUES	('LEADER_JFD_OLYMPIAS',	'LOC_LEADER_JFD_OLYMPIAS_NAME',	'LEADER_DEFAULT',	'Female',	4);	
--------------------------------------------------------------------------------------------------------------------------
-- LeaderQuotes
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO LeaderQuotes	
		(LeaderType,			Quote)
VALUES	('LEADER_JFD_OLYMPIAS',	'LOC_PEDIA_LEADERS_PAGE_LEADER_JFD_OLYMPIAS_QUOTE');		
--------------------------------------------------------------------------------------------------------------------------
-- HistoricalAgendas
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO HistoricalAgendas	
		(LeaderType,			AgendaType)
VALUES	('LEADER_JFD_OLYMPIAS',	'AGENDA_JFD_ORACLE_CHTONICS');	
--------------------------------------------------------------------------------------------------------------------------
-- LeaderTraits
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO LeaderTraits	
		(LeaderType,			TraitType)
VALUES	('LEADER_JFD_OLYMPIAS',	'TRAIT_LEADER_JFD_CABEIRI_MYSTERIES');	
--------------------------------------------------------------------------------------------------------------------------
-- FavoredReligions
--------------------------------------------------------------------------------------------------------------------------	
INSERT OR REPLACE INTO FavoredReligions	
		(LeaderType,			ReligionType)
SELECT	'LEADER_JFD_OLYMPIAS',	ReligionType
FROM Religions WHERE ReligionType = 'RELIGION_HELLENISM';	

CREATE TRIGGER JFD_Macedon_Olympias_FavoredReligions 
AFTER INSERT ON Religions WHEN 'RELIGION_HELLENISM' = NEW.ReligionType 
BEGIN 
INSERT OR REPLACE INTO FavoredReligions 
		(LeaderType, 		 	ReligionType) 
VALUES 	('LEADER_JFD_OLYMPIAS','RELIGION_HELLENISM'); 
END;
--==========================================================================================================================
-- LEADER: AGENDAS
--==========================================================================================================================
--------------------------------------------------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO Types	
		(Type,									Kind)
VALUES	('TRAIT_AGENDA_JFD_ORACLE_CHTONICS',	'KIND_TRAIT');			
--------------------------------------------------------------------------------------------------------------------------			
-- Agendas			
--------------------------------------------------------------------------------------------------------------------------				
INSERT INTO Agendas				
		(AgendaType,							Name,									 Description)
VALUES	('AGENDA_JFD_ORACLE_CHTONICS',			'LOC_AGENDA_JFD_ORACLE_CHTONICS_NAME',	 'LOC_AGENDA_JFD_ORACLE_CHTONICS_DESCRIPTION');	
--------------------------------------------------------------------------------------------------------------------------			
-- Traits			
--------------------------------------------------------------------------------------------------------------------------				
INSERT INTO Traits				
		(TraitType,								Name,				Description)
VALUES	('TRAIT_AGENDA_JFD_ORACLE_CHTONICS',	'LOC_PLACEHOLDER',	'LOC_PLACEHOLDER');	
--------------------------------------------------------------------------------------------------------------------------			
-- AgendaTraits			
--------------------------------------------------------------------------------------------------------------------------				
INSERT INTO AgendaTraits				
		(AgendaType,							TraitType)
VALUES	('AGENDA_JFD_ORACLE_CHTONICS',			'TRAIT_AGENDA_JFD_ORACLE_CHTONICS');	
--------------------------------------------------------------------------------------------------------------------------			
-- ExclusiveAgendas			
--------------------------------------------------------------------------------------------------------------------------				
INSERT INTO ExclusiveAgendas				
		(AgendaOne,								AgendaTwo)
VALUES	('AGENDA_JFD_ORACLE_CHTONICS',			'AGENDA_CITY_STATE_ALLY'),	
		('AGENDA_JFD_ORACLE_CHTONICS',			'AGENDA_DEVOUT');	
--------------------------------------------------------------------------------------------------------------------------		
-- TraitModifiers		
--------------------------------------------------------------------------------------------------------------------------			
INSERT INTO TraitModifiers			
		(TraitType,								ModifierId)
VALUES	('TRAIT_AGENDA_JFD_ORACLE_CHTONICS',	'JFD_ORACLE_CHTONICS_LAGS_FAITH_AND_COMPETING_MINORS'),
		('TRAIT_AGENDA_JFD_ORACLE_CHTONICS',	'JFD_ORACLE_CHTONICS_LEADS_FAITH_AND_COMPETING_MINORS');
----------------------------------------------------------------------------------------------------------------------------
-- Modifiers
----------------------------------------------------------------------------------------------------------------------------
INSERT INTO Modifiers	
		(ModifierId,												ModifierType,									SubjectRequirementSetId)
VALUES	('JFD_ORACLE_CHTONICS_LAGS_FAITH_AND_COMPETING_MINORS',		'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',	'JFD_ORACLE_CHTONICS_LAGS_FAITH_AND_COMPETING_MINORS_REQ_SET'),
		('JFD_ORACLE_CHTONICS_LEADS_FAITH_AND_COMPETING_MINORS',	'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',	'JFD_ORACLE_CHTONICS_LEADS_FAITH_AND_COMPETING_MINORS_REQ_SET');
----------------------------------------------------------------------------------------------------------------------------
-- ModifierArguments
----------------------------------------------------------------------------------------------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,												Name,						 	Value)
VALUES	('JFD_ORACLE_CHTONICS_LAGS_FAITH_AND_COMPETING_MINORS',		'InitialValue',				 	8),
		('JFD_ORACLE_CHTONICS_LAGS_FAITH_AND_COMPETING_MINORS',		'StatementKey',				 	'LOC_DIPLO_KUDO_LEADER_JFD_OLYMPIAS_REASON_LAGS_FAITH_AND_COMPETING_MINORS'),
		('JFD_ORACLE_CHTONICS_LAGS_FAITH_AND_COMPETING_MINORS',		'SimpleModifierDescription', 	'LOC_DIPLO_MODIFIER_AGENDA_JFD_ORACLE_CHTONICS_LAGS_FAITH_AND_COMPETING_MINORS'),
		('JFD_ORACLE_CHTONICS_LEADS_FAITH_AND_COMPETING_MINORS',	'InitialValue',				 	-8),
		('JFD_ORACLE_CHTONICS_LEADS_FAITH_AND_COMPETING_MINORS',	'StatementKey',				 	'LOC_DIPLO_WARNING_LEADER_JFD_OLYMPIAS_REASON_LEADS_FAITH_AND_COMPETING_MINORS'),
		('JFD_ORACLE_CHTONICS_LEADS_FAITH_AND_COMPETING_MINORS',	'SimpleModifierDescription', 	'LOC_DIPLO_MODIFIER_AGENDA_JFD_ORACLE_CHTONICS_LEADS_FAITH_AND_COMPETING_MINORS');		
--------------------------------------------------------------------------------------------------------------------------		
-- ModifierStrings		
--------------------------------------------------------------------------------------------------------------------------			
INSERT INTO ModifierStrings			
		(ModifierId,												Context,	Text)
VALUES	('JFD_ORACLE_CHTONICS_LAGS_FAITH_AND_COMPETING_MINORS',		'Sample',	'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL'),
		('JFD_ORACLE_CHTONICS_LEADS_FAITH_AND_COMPETING_MINORS',	'Sample',	'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL');
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
----------------------------------------------------------------------------------------------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,													RequirementSetType)
VALUES	('JFD_ORACLE_CHTONICS_LAGS_FAITH_AND_COMPETING_MINORS_REQ_SET',		'REQUIREMENTSET_TEST_ALL'),
		('JFD_ORACLE_CHTONICS_LEADS_FAITH_AND_COMPETING_MINORS_REQ_SET',	'REQUIREMENTSET_TEST_ALL');
----------------------------------------------------------------------------------------------------------------------------	
-- RequirementSetRequirements	
----------------------------------------------------------------------------------------------------------------------------	
INSERT INTO RequirementSetRequirements	
		(RequirementSetId,													RequirementId)
VALUES	('JFD_ORACLE_CHTONICS_LAGS_FAITH_AND_COMPETING_MINORS_REQ_SET',		'REQUIRES_MAJOR_CIV_OPPONENT'),
		('JFD_ORACLE_CHTONICS_LAGS_FAITH_AND_COMPETING_MINORS_REQ_SET',		'REQUIRES_MET_10_TURNS_AGO'),
		('JFD_ORACLE_CHTONICS_LAGS_FAITH_AND_COMPETING_MINORS_REQ_SET',		'REQUIRES_COMPETING_MINORS'),
		('JFD_ORACLE_CHTONICS_LAGS_FAITH_AND_COMPETING_MINORS_REQ_SET',		'REQUIRES_HAS_HIGH_FAITH'),
		('JFD_ORACLE_CHTONICS_LEADS_FAITH_AND_COMPETING_MINORS_REQ_SET',	'REQUIRES_MAJOR_CIV_OPPONENT'),
		('JFD_ORACLE_CHTONICS_LEADS_FAITH_AND_COMPETING_MINORS_REQ_SET',	'REQUIRES_MET_10_TURNS_AGO'),
		('JFD_ORACLE_CHTONICS_LEADS_FAITH_AND_COMPETING_MINORS_REQ_SET',	'REQUIRES_COMPETING_MINORS'),
		('JFD_ORACLE_CHTONICS_LEADS_FAITH_AND_COMPETING_MINORS_REQ_SET',	'REQUIRES_HAS_LOW_FAITH');	
--==========================================================================================================================
-- LEADER: AI
--==========================================================================================================================
--------------------------------------------------------------------------------------------------------------------------
-- AiListTypes
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO AiListTypes	
		(ListType)
VALUES	('JFD_Olympias_Buildings'),
		('JFD_Olympias_Districts'),
		('JFD_Olympias_PseudoYields'),
		('JFD_Olympias_Techs'),
		('JFD_Olympias_Units'),
		('JFD_Olympias_Yields');
--------------------------------------------------------------------------------------------------------------------------	
-- AiLists
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO AiLists	
		(ListType,						LeaderType,								System)
VALUES	('JFD_Olympias_Buildings',		'TRAIT_AGENDA_JFD_ORACLE_CHTONICS',		'Buildings'),
		('JFD_Olympias_Districts',		'TRAIT_AGENDA_JFD_ORACLE_CHTONICS',		'Districts'),
		('JFD_Olympias_PseudoYields',	'TRAIT_AGENDA_JFD_ORACLE_CHTONICS',		'PseudoYields'),
		('JFD_Olympias_Techs',			'TRAIT_AGENDA_JFD_ORACLE_CHTONICS',		'Technologies'),
		('JFD_Olympias_Units',			'TRAIT_AGENDA_JFD_ORACLE_CHTONICS',		'Yields'),
		('JFD_Olympias_Yields',			'TRAIT_AGENDA_JFD_ORACLE_CHTONICS',		'Units');
--------------------------------------------------------------------------------------------------------------------------	
-- AiFavoredItems
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO AiFavoredItems	
		(ListType,						Favored,	Value,	Item)
VALUES	('JFD_Olympias_Buildings',		1,			0,		'BUILDING_BASILIKOI_PAIDES'), 
		('JFD_Olympias_Districts',		1,			0,		'DISTRICT_HOLY_SITE'),
		('JFD_Olympias_PseudoYields',	1,			20,		'PSEUDOYIELD_INFLUENCE'),
		('JFD_Olympias_PseudoYields',	1,			20,		'PSEUDOYIELD_GPP_PROPHET'),
		('JFD_Olympias_Techs',			1,			0,		'TECH_BRONZE_WORKING'),
		('JFD_Olympias_Techs',			1,			0,		'TECH_ASTRONOMY'),
		('JFD_Olympias_Techs',			1,			0,		'TECH_IRON_WORKING'),
		('JFD_Olympias_Units',			1,			0,		'UNIT_MACEDONIAN_HYPASPIST'),	
		('JFD_Olympias_Yields',			1,			20,		'YIELD_FAITH');	
--==========================================================================================================================
-- LEADERS: LOADING INFO
--==========================================================================================================================
--------------------------------------------------------------------------------------------------------------------------
-- LoadingInfo
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO LoadingInfo	
		(LeaderType,			BackgroundImage,			ForegroundImage,				PlayDawnOfManAudio)
VALUES	('LEADER_JFD_OLYMPIAS',	'LEADER_GORGO_BACKGROUND',	'LEADER_JFD_OLYMPIAS_NEUTRAL',	0);	
--==========================================================================================================================
-- LEADERS: TRAITS
--==========================================================================================================================
--------------------------------------------------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO Types	
		(Type,										Kind)
VALUES	('TRAIT_LEADER_JFD_CABEIRI_MYSTERIES',		'KIND_TRAIT');	
--------------------------------------------------------------------------------------------------------------------------			
-- Traits			
--------------------------------------------------------------------------------------------------------------------------				
INSERT INTO Traits				
		(TraitType,									Name,												Description)
VALUES	('TRAIT_LEADER_JFD_CABEIRI_MYSTERIES',		'LOC_TRAIT_LEADER_JFD_CABEIRI_MYSTERIES_NAME',		'LOC_TRAIT_LEADER_JFD_CABEIRI_MYSTERIES_DESCRIPTION');	
--------------------------------------------------------------------------------------------------------------------------		
-- TraitModifiers		
--------------------------------------------------------------------------------------------------------------------------			
INSERT INTO TraitModifiers			
		(TraitType,									ModifierId)
VALUES	('TRAIT_LEADER_JFD_CABEIRI_MYSTERIES',		'JFD_CABEIRI_MYSTERIES_LEVY_DISCOUNT');
--------------------------------------------------------------------------------------------------------------------------
-- Modifiers
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO Modifiers	
		(ModifierId,								ModifierType,										Permanent,		SubjectRequirementSetId)
VALUES	('JFD_CABEIRI_MYSTERIES_LEVY_DISCOUNT',		'MODIFIER_PLAYER_ADJUST_LEVY_DISCOUNT_PERCENT',	 	0,				null);
--------------------------------------------------------------------------------------------------------------------------
-- ModifierArguments
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,								Name,			Value)
VALUES	('JFD_CABEIRI_MYSTERIES_LEVY_DISCOUNT',		'Percent',		50);
--==========================================================================================================================
-- CIVILIZATIONS
--==========================================================================================================================
--------------------------------------------------------------------------------------------------------------------------
-- CivilizationLeaders
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO CivilizationLeaders	
		(CivilizationType,			LeaderType,					CapitalName)
VALUES	('CIVILIZATION_MACEDON',	'LEADER_JFD_OLYMPIAS',		'LOC_CITY_NAME_AIGAI');	
--==========================================================================================================================
--==========================================================================================================================