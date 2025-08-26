-- Port Lime - Te Kinich - Leader
-- Author: Te' L'ime
-- DateCreated: 5/31/2024 4:39:23 PM
---------------------------------------------------------------------------------------
--	Yajaw Te' K'inich II
--	Capital: Caracol
--	
--	LUA: Wrath of Venus:
--	Damaging enemy cities provides a burst of Science equal to twice the damage the city
--	received, and conquering an original capital grants you a random Eureka. Discovering 
--	a Technology while at war instantly heals all your military units by 50 and grants 
--	them +5 XP. 
--	
--	Agenda: Lord Water:
--	Will respect your civilization as long as it has more population than him, but will 
--	ruthlessly invade you otherwise.
----------------------------------------------------------------------------------------
-- Hooray for Lua!!!
--======================================================================================
-- Types ===============================================================================
--======================================================================================
INSERT INTO Types
		(Type,												Kind)
VALUES	('LEADER_LL_TEKINICH_II',						'KIND_LEADER'),
		('TRAIT_LEADER_LL_TEKINICH_II_WRATH_OF_VENUS',	'KIND_TRAIT'),
		('TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',		'KIND_TRAIT');

--======================================================================================
-- Civilization Leaders and stuff ======================================================
--======================================================================================
INSERT INTO Leaders
		(LeaderType,						Name,									InheritFrom,		SceneLayers)
VALUES	('LEADER_LL_TEKINICH_II',		'LOC_LEADER_LL_TEKINICH_II_NAME',	'LEADER_DEFAULT',	3);

INSERT INTO CivilizationLeaders
		(CivilizationType,					LeaderType,						CapitalName)
VALUES	('CIVILIZATION_MAYA',				'LEADER_LL_TEKINICH_II',	'LOC_CITY_NAME_LIME_TE_KINICH_CARACOL');

INSERT INTO LeaderQuotes
		(LeaderType,						Quote)
VALUES	('LEADER_LL_TEKINICH_II',		'LOC_PEDIA_LEADERS_PAGE_LEADER_LL_TEKINICH_II_QUOTE');

INSERT INTO LoadingInfo
		(LeaderType,						BackgroundImage,							ForegroundImage,						PlayDawnOfManAudio)
VALUES	('LEADER_LL_TEKINICH_II',		'LEADER_PEDRO_BACKGROUND',	'LEADER_LL_TEKINICH_II_NEUTRAL',	0);

INSERT INTO FavoredReligions
		(LeaderType,						ReligionType)
VALUES	('LEADER_LL_TEKINICH_II',		'RELIGION_CATHOLICISM');

UPDATE FavoredReligions
	SET ReligionType = 'RELIGION_TZOLKIN'
	WHERE LeaderType = 'LEADER_LL_TEKINICH_II' 
	AND EXISTS (SELECT ReligionType FROM Religions WHERE ReligionType = 'RELIGION_TZOLKIN');

CREATE TRIGGER Lime_MAYA_TE_KINICH_FavoredReligions 
	AFTER INSERT ON Religions WHEN 'RELIGION_TZOLKIN' = NEW.ReligionType 	
	BEGIN 
		INSERT OR REPLACE INTO FavoredReligions 
			(LeaderType, 		 	ReligionType) 
			VALUES 	('LEADER_LL_TEKINICH_II',	'RELIGION_TZOLKIN');
	END;

--======================================================================================
-- Leader Traits =======================================================================
--======================================================================================
INSERT INTO LeaderTraits
		(LeaderType,						TraitType)
VALUES	('LEADER_LL_TEKINICH_II',		'TRAIT_LEADER_LL_TEKINICH_II_WRATH_OF_VENUS');

INSERT INTO Traits
		(TraitType,											Name,														Description)
VALUES	('TRAIT_LEADER_LL_TEKINICH_II_WRATH_OF_VENUS',	'LOC_TRAIT_LEADER_LL_TEKINICH_II_WRATH_OF_VENUS_NAME',	'LOC_TRAIT_LEADER_LL_TEKINICH_II_WRATH_OF_VENUS_DESC');

INSERT INTO Modifiers -- stolen from me who stole it from suk
			(
				ModifierId,
				ModifierType,
				RunOnce,
				Permanent
			)
		VALUES
			(
				'MOD_LIME_TE_KINICH_GRANT_EUREKA',
				'MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY_BOOST_GOODY_HUT',
				1,
				1
			);
	-------------------------------------
	-- ModifierArguments
	-------------------------------------
		INSERT INTO ModifierArguments
				(ModifierId,									Name,		Value)
		VALUES	('MOD_LIME_TE_KINICH_GRANT_EUREKA',				'Amount',	1);
--======================================================================================
-- Leader Agenda =======================================================================
--======================================================================================
INSERT INTO HistoricalAgendas
		(LeaderType,						AgendaType)
VALUES	('LEADER_LL_TEKINICH_II',		'AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER');

INSERT INTO Agendas
		(AgendaType,								Name,												Description)
VALUES	('AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',	'LOC_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER_NAME',	'LOC_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER_DESC');

INSERT INTO AgendaTraits
		(AgendaType,								TraitType)
VALUES	('AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',	'TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER');

INSERT INTO ExclusiveAgendas -- check
		(AgendaOne,											AgendaTwo)
VALUES	('AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',			'AGENDA_POPULOUS');

INSERT INTO Traits -- check
		(TraitType,											Name,					Description)
VALUES	('TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',		'LOC_PLACEHOLDER',		'LOC_PLACEHOLDER');

INSERT INTO TraitModifiers -- check
		(TraitType,											ModifierId)
VALUES	('TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',		'MOD_AGENDA_LIME_TE_KINICH_LIKES'),
		('TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',		'MOD_AGENDA_LIME_TE_KINICH_HATES');

INSERT INTO Modifiers
		(ModifierId,							ModifierType,										SubjectRequirementSetId)
VALUES	('MOD_AGENDA_LIME_TE_KINICH_LIKES',		'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',		'REQSET_LIME_TE_KINICH_LIKES_POP'),
		('MOD_AGENDA_LIME_TE_KINICH_HATES',		'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',		'REQSET_LIME_TE_KINICH_HATES_NOT_POP');

INSERT INTO ModifierArguments
		(ModifierId,							Name,							Value)
VALUES	('MOD_AGENDA_LIME_TE_KINICH_LIKES',		'InitialValue',					8),
		('MOD_AGENDA_LIME_TE_KINICH_LIKES',		'MessageThrottle',				20),
		('MOD_AGENDA_LIME_TE_KINICH_LIKES',		'StatementKey',					'LOC_DIPLO_KUDO_EXIT_LEADER_LL_TEKINICH_II_REASON_MOD_AGENDA_LIME_TE_KINICH_LIKES'),
		('MOD_AGENDA_LIME_TE_KINICH_LIKES',		'SimpleModifierDescription',	'LOC_DIPLO_MODIFIER_LEADER_LL_TEKINICH_II_MOD_AGENDA_LIME_TE_KINICH_LIKES'),

		('MOD_AGENDA_LIME_TE_KINICH_HATES',		'InitialValue',					-8),
		('MOD_AGENDA_LIME_TE_KINICH_HATES',		'MessageThrottle',				20),
		('MOD_AGENDA_LIME_TE_KINICH_HATES',		'StatementKey',					'LOC_DIPLO_WARNING_EXIT_LEADER_LL_TEKINICH_II_REASON_MOD_AGENDA_LIME_TE_KINICH_HATES'),
		('MOD_AGENDA_LIME_TE_KINICH_HATES',		'SimpleModifierDescription',	'LOC_DIPLO_MODIFIER_LEADER_LL_TEKINICH_II_MOD_AGENDA_LIME_TE_KINICH_HATES');

INSERT INTO ModifierStrings
		(ModifierId,							Context,	Text)
VALUES	('MOD_AGENDA_LIME_TE_KINICH_LIKES',		'Sample',	'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL'),
		('MOD_AGENDA_LIME_TE_KINICH_HATES',		'Sample',	'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL');

INSERT INTO RequirementSets
		(RequirementSetId,						RequirementSetType)
VALUES	('REQSET_LIME_TE_KINICH_LIKES_POP',		'REQUIREMENTSET_TEST_ALL'),
		('REQSET_LIME_TE_KINICH_HATES_NOT_POP',	'REQUIREMENTSET_TEST_ALL'),
		('REQSET_LIME_TE_KINICH_COOLDOWNS',		'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
		(RequirementSetId,						RequirementId)
VALUES	('REQSET_LIME_TE_KINICH_LIKES_POP',		'REQUIRES_HAS_HIGH_POPULATION'),
		('REQSET_LIME_TE_KINICH_LIKES_POP',		'REQ_LIME_TE_KINICH_COOLDOWNS'),
		
		('REQSET_LIME_TE_KINICH_HATES_NOT_POP',	'REQUIRES_HAS_LOW_POPULATION'),
		('REQSET_LIME_TE_KINICH_HATES_NOT_POP',	'REQ_LIME_TE_KINICH_COOLDOWNS'),
		
		('REQSET_LIME_TE_KINICH_COOLDOWNS',		'REQUIRES_MAJOR_CIV_OPPONENT'),
		('REQSET_LIME_TE_KINICH_COOLDOWNS',		'REQUIRES_MET_10_TURNS_AGO');

INSERT INTO Requirements
		(RequirementId,						RequirementType)
VALUES	('REQ_LIME_TE_KINICH_COOLDOWNS',	'REQUIREMENT_REQUIREMENTSET_IS_MET');

INSERT INTO RequirementArguments
		(RequirementId,						Name,				Value)
VALUES	('REQ_LIME_TE_KINICH_COOLDOWNS',	'RequirementSetId',	'REQSET_LIME_TE_KINICH_COOLDOWNS');

--============================================================
-- AI - this is easily the worst part
--============================================================
-------------------------------------
-- AiListTypes
-------------------------------------
INSERT INTO AiListTypes	
		(ListType)
VALUES	('LEADER_LL_TEKINICH_II_Victories'),
		('LEADER_LL_TEKINICH_II_Alliances'),
		('LEADER_LL_TEKINICH_II_Diplo'),
		('LEADER_LL_TEKINICH_II_CBs'),
		('LEADER_LL_TEKINICH_II_Discussions'),
		('LEADER_LL_TEKINICH_II_Resolutions'),
		('LEADER_LL_TEKINICH_II_BuildSpecializations'),
		('LEADER_LL_TEKINICH_II_PseudoYields'),
		('LEADER_LL_TEKINICH_II_Yields'),
		('LEADER_LL_TEKINICH_II_Wonders'),
		('LEADER_LL_TEKINICH_II_UnitPromoClasses');

INSERT INTO AiLists	
		(ListType,											AgendaType,											System)
VALUES	('LEADER_LL_TEKINICH_II_Victories',			'TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',		'Strategies'),
		('LEADER_LL_TEKINICH_II_Alliances',			'TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',		'Alliances'),
		('LEADER_LL_TEKINICH_II_Diplo',				'TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',		'DiplomaticActions'),
		('LEADER_LL_TEKINICH_II_CBs',					'TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',		'DiplomaticActions'),
		('LEADER_LL_TEKINICH_II_Discussions',			'TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',		'Discussions'),
		('LEADER_LL_TEKINICH_II_Resolutions',			'TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',		'Resolutions'),
		('LEADER_LL_TEKINICH_II_BuildSpecializations',	'TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',		'AiBuildSpecializations'),
		('LEADER_LL_TEKINICH_II_PseudoYields',			'TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',		'PseudoYields'),
		('LEADER_LL_TEKINICH_II_Yields',				'TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',		'Yields'),
		('LEADER_LL_TEKINICH_II_Wonders',				'TRAIT_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER',		'Buildings');

-------------------------------------
-- AiFavoredItems courtesy of Leugi
-- So from what I can see: 
---- Favored 1, Value -200 means the leader completely hates the thing
---- Favored 1, Value -100 means the leader hates the thing
---- Favored 0, Value 0 means the leader doesn't like the thing
---- Favored 1, Value 0 means the leader likes the thing
---- Favored 1, Value 20 means the leader really likes the thing
---- Favored 1, Value 50 means the leader loves the thing
--
---- On Victory Strategies it's all backwards:
------- Favored 1, Value -2 Means the Victory is Preferred
------- Favored 1, Value 5 Means the Victory is Forbidden
-------------------------------------
	
INSERT INTO AiFavoredItems		
		(ListType,											Item,												StringVal,					Favored,	Value)
		-- Preferred Victories
VALUES	('LEADER_LL_TEKINICH_II_Victories',			'VICTORY_STRATEGY_MILITARY_VICTORY',				null,						1,			-1),
		('LEADER_LL_TEKINICH_II_Victories',			'VICTORY_STRATEGY_SCIENCE_VICTORY',					null,						1,			0),
		('LEADER_LL_TEKINICH_II_Victories',			'VICTORY_STRATEGY_RELIGIOUS_VICTORY',				null,						1,			0),
		('LEADER_LL_TEKINICH_II_Victories',			'VICTORY_STRATEGY_DIPLOMATIC_VICTORY',				null,						1,			-1),
		('LEADER_LL_TEKINICH_II_Victories',			'VICTORY_STRATEGY_CULTURAL_VICTORY',				null,						1,			0),

		-- Preferred Alliances
		('LEADER_LL_TEKINICH_II_Alliances',			'ALLIANCE_CULTURAL',								null,						0,			0),
		('LEADER_LL_TEKINICH_II_Alliances',			'ALLIANCE_ECONOMIC',								null,						0,			0),
		('LEADER_LL_TEKINICH_II_Alliances',			'ALLIANCE_MILITARY',								null,						1,			10),
		('LEADER_LL_TEKINICH_II_Alliances',			'ALLIANCE_RELIGIOUS',								null,						0,			0),
		('LEADER_LL_TEKINICH_II_Alliances',			'ALLIANCE_RESEARCH',								null,						0,			0),

		-- Preferred Diplomatic Actions
		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_ALLIANCE',								null,						1,			0),
		--('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_ALLIANCE_CULTURAL',					null,						1,			0),
		--('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_ALLIANCE_ECONOMIC',					null,						1,			0),
		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_ALLIANCE_MILITARY',					null,						1,			0),
		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_ALLIANCE_MILITARY_EMERGENCY',			null,						1,			0),
		--('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_ALLIANCE_RELIGIOUS',					null,						1,			-1),
		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_ALLIANCE_RESEARCH',					null,						1,			-50),
		--('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_ALLIANCE_TEAMUP',						null,						1,			-1),
		--('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_ALLIANCE_ECONOMIC',					null,						1,			-1),
		--('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_ALLIANCE_RELIGIOUS',					null,						1,			-1),
		
--		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_DEMAND_TRIBUTE',						null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_DENOUNCE',								null,						1,			0),
		
--		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_KEEP_PROMISE_DONT_CONVERT',			null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_KEEP_PROMISE_DONT_DIG_ARTIFACTS',		null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_KEEP_PROMISE_DONT_SETTLE_TOO_NEAR',	null,						1,			0),	
--		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_KEEP_PROMISE_DONT_SPY',				null,						1,			0),
		
--		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_DIPLOMATIC_DELEGATION',				null,						1,			0),
		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_RESIDENT_EMBASSY',						null,						1,			0),
		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_RENEW_ALLIANCE',						null,						1,			0),
		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_DECLARE_FRIENDSHIP',					null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_OPEN_BORDERS',							null,						1,			0),
		
		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_LIBERATE_CITY',						null,						0,			0),
		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_MILITARY_REQUEST',						null,						1,			0),
		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_REQUEST_ASSISTANCE',					null,						1,			0),	

		-- War Stuff
		('LEADER_LL_TEKINICH_II_CBs',					'DIPLOACTION_DECLARE_COLONIAL_WAR',					null,						1,			0),
		('LEADER_LL_TEKINICH_II_CBs',					'DIPLOACTION_DECLARE_FORMAL_WAR',					null,						1,			0),
		('LEADER_LL_TEKINICH_II_CBs',					'DIPLOACTION_DECLARE_GOLDEN_AGE_WAR',				null,						1,			5),
		('LEADER_LL_TEKINICH_II_CBs',					'DIPLOACTION_DECLARE_HOLY_WAR',						null,						1,			5),
		('LEADER_LL_TEKINICH_II_CBs',					'DIPLOACTION_DECLARE_IDEOLOGICAL_WAR',				null,						1,			0),
		('LEADER_LL_TEKINICH_II_CBs',					'DIPLOACTION_DECLARE_LIBERATION_WAR',				null,						1,			0),
		('LEADER_LL_TEKINICH_II_CBs',					'DIPLOACTION_DECLARE_PROTECTORATE_WAR',				null,						1,			5),
		('LEADER_LL_TEKINICH_II_CBs',					'DIPLOACTION_DECLARE_RECONQUEST_WAR',				null,						1,			0),
		('LEADER_LL_TEKINICH_II_CBs',					'DIPLOACTION_DECLARE_SURPRISE_WAR',					null,						1,			-1),
		('LEADER_LL_TEKINICH_II_CBs',					'DIPLOACTION_DECLARE_TERRITORIAL_WAR',				null,						1,			0),
		('LEADER_LL_TEKINICH_II_CBs',					'DIPLOACTION_DECLARE_WAR_MINOR_CIV',				null,						1,			5),
		('LEADER_LL_TEKINICH_II_CBs',					'DIPLOACTION_DECLARE_WAR_OF_RETRIBUTION',			null,						1,			0),
		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_PROPOSE_PEACE_DEAL',					null,						1,			1),
		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_JOINT_WAR',							null,						1,			0),
		('LEADER_LL_TEKINICH_II_Diplo',				'DIPLOACTION_USE_NUCLEAR_WEAPON',					null,						1,			0),

		-- Preferred Discussions (Emergencies and Competitions... In this case I prefer putting a prefer		ence/dislike to all)
--		('LEADER_LL_TEKINICH_II_Discussions',			'WC_EMERGENCY_MILITARY',							null,						1,			10),
--		('LEADER_LL_TEKINICH_II_Discussions',			'WC_EMERGENCY_CITY_STATE',							null,						1,			10),
--		('LEADER_LL_TEKINICH_II_Discussions',			'WC_EMERGENCY_RELIGIOUS',							null,						1,			10),
--		('LEADER_LL_TEKINICH_II_Discussions',			'WC_EMERGENCY_NUCLEAR',								null,						1,			10),
--		('LEADER_LL_TEKINICH_II_Discussions',			'WC_EMERGENCY_BACKSTAB',							null,						1,			10),
--		('LEADER_LL_TEKINICH_II_Discussions',			'WC_EMERGENCY_REQUEST_AID',							null,						1,			10),
--		('LEADER_LL_TEKINICH_II_Discussions',			'WC_EMERGENCY_NOBEL_PRIZE_LITERATURE',				null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Discussions',			'WC_EMERGENCY_NOBEL_PRIZE_PEACE',					null,						1,			0),
		('LEADER_LL_TEKINICH_II_Discussions',			'WC_EMERGENCY_NOBEL_PRIZE_PHYSICS',					null,						1,			0),
		('LEADER_LL_TEKINICH_II_Discussions',			'WC_EMERGENCY_CLIMATE_ACCORDS',						null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Discussions',			'WC_EMERGENCY_WORLD_GAMES',							null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Discussions',			'WC_EMERGENCY_SPACE_STATION',						null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Discussions',			'WC_EMERGENCY_WORLD_FAIR',							null,						1,			0),

		-- Preferred Resolutions (In this case I also prefer putting a preference/dislike to all)
--		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_ARMS_CONTROL',								null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_BORDER_CONTROL',							null,						1,			0),
		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_DEFORESTATION_TREATY',						null,						1,			0),
		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_DIPLOVICTORY',								null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_ESPIONAGE_PACT',							null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_GLOBAL_ENERGY_TREATY',						null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_GOVERNANCE_DOCTRINE',						null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_HERITAGE_ORG',								null,						1,			10),
--		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_LUXURY',									null,						1,			10),
		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_MERCENARY_COMPANIES',						null,						1,			0),
		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_MIGRATION_TREATY',							null,						1,			0),
		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_MILITARY_ADVISORY',							null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_PATRONAGE',									null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_POLICY_TREATY',								null,						1,			0),
		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_PUBLIC_WORKS',								null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_SOVEREIGNTY',								null,						1,			50),
--		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_TRADE_TREATY',								null,						1,			0),
		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_TREATY_ORGANIZATION',						null,						1,			0),
		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_URBAN_DEVELOPMENT',							null,						1,			0),
		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_WORLD_IDEOLOGY',							null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Resolutions',			'WC_RES_WORLD_RELIGION',							null,						1,			1),
		
		-- Build Specs
		('LEADER_LL_TEKINICH_II_BuildSpecializations',	'BUILD_CITY_DEFENSES',								null,						1,			0),
--		('LEADER_LL_TEKINICH_II_BuildSpecializations',	'BUILD_FOR_CULTURE',								null,						1,			0),
--		('LEADER_LL_TEKINICH_II_BuildSpecializations',	'BUILD_FOR_FAITH',									null,						1,			0),
		('LEADER_LL_TEKINICH_II_BuildSpecializations',	'BUILD_FOR_FOOD',									null,						1,			0),
--		('LEADER_LL_TEKINICH_II_BuildSpecializations',	'BUILD_FOR_GOLD',									null,						1,			0),
--		('LEADER_LL_TEKINICH_II_BuildSpecializations',	'BUILD_FOR_PRODUCTION',								null,						1,			0),
		('LEADER_LL_TEKINICH_II_BuildSpecializations',	'BUILD_FOR_SCIENCE',								null,						1,			0),
		('LEADER_LL_TEKINICH_II_BuildSpecializations',	'BUILD_MILITARY_UNITS',								null,						1,			0),
--		('LEADER_LL_TEKINICH_II_BuildSpecializations',	'BUILD_TRADE_UNITS',								null,						1,			0),

		-- Preferred Pseudoyields
--		('LEADER_LL_TEKINICH_II_PseudoYields',			'PSEUDOYIELD_GPP_GENERAL',							null,						1,			0),
--		('LEADER_LL_TEKINICH_II_PseudoYields',			'PSEUDOYIELD_CITY_DEFENDING_UNITS',					null,						1,			0),
--		('LEADER_LL_TEKINICH_II_PseudoYields',			'PSEUDOYIELD_GPP_PROPHET',							null,						1,			0),
--		('LEADER_LL_TEKINICH_II_PseudoYields',			'PSEUDOYIELD_INFLUENCE',							null,						1,			0),
--		('LEADER_LL_TEKINICH_II_PseudoYields',			'PSEUDOYIELD_WONDER',								null,						1,			50),
--		('LEADER_LL_TEKINICH_II_PseudoYields',			'PSEUDOYIELD_DISTRICT',								null,						1,			50),
--		('LEADER_LL_TEKINICH_II_PseudoYields',			'PSEUDOYIELD_GREATWORK_RELIC',						null,						1,			50),
--		('LEADER_LL_TEKINICH_II_PseudoYields',			'PSEUDOYIELD_GREATWORK_WRITING',					null,						1,			-50), -- writing is for hookers and poor people, not for art
--		('LEADER_LL_TEKINICH_II_PseudoYields',			'PSEUDOYIELD_CITY_POPULATION',						null,						1,			20),
--		('LEADER_LL_TEKINICH_II_PseudoYields',			'PSEUDOYIELD_HAPPINESS',							null,						1,			20),
		
		-- Preferred Yields
--		('LEADER_LL_TEKINICH_II_Yields',				'YIELD_CULTURE',									null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Yields',				'YIELD_FAITH',										null,						1,			0),
		('LEADER_LL_TEKINICH_II_Yields',				'YIELD_FOOD',										null,						1,			10),
--		('LEADER_LL_TEKINICH_II_Yields',				'YIELD_GOLD',										null,						1,			0),
--		('LEADER_LL_TEKINICH_II_Yields',				'YIELD_PRODUCTION',									null,						1,			10),
		('LEADER_LL_TEKINICH_II_Yields',				'YIELD_SCIENCE',									null,						1,			0);

		-- Wonders (I'm gonna hardcode this bc I want him to really go for these wonders)
--		('LEADER_LL_TEKINICH_II_Wonders',				'BUILDING_CHICHEN_ITZA',							null,						1,			10),
--		('LEADER_LL_TEKINICH_II_Wonders',				'BUILDING_GREAT_ZIMBABWE',							null,						1,			7),
--		('LEADER_LL_TEKINICH_II_Wonders',				'BUILDING_PETRA',									null,						1,			7),
--		('LEADER_LL_TEKINICH_II_Wonders',				'BUILDING_ORSZAGHAZ',								null,						1,			7),
--		('LEADER_LL_TEKINICH_II_Wonders',				'BUILDING_ETEMENANKI',								null,						1,			5),
--		('LEADER_LL_TEKINICH_II_Wonders',				'BUILDING_HUEY_TEOCALLI',							null,						1,			5),
--		('LEADER_LL_TEKINICH_II_Wonders',				'BUILDING_PYRAMIDS',								null,						1,			5);

INSERT INTO LeaderTraits	-- Separated out so I can control specific leader biases
		(LeaderType,									TraitType)
VALUES	('LEADER_LL_TEKINICH_II',					'TRAIT_LEADER_EXPANSIONIST'),
		('LEADER_LL_TEKINICH_II',					'TRAIT_LEADER_PURSUE_DIPLOMATIC_VICTORY');