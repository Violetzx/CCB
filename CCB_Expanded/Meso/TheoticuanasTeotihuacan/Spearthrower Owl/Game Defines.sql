--======================================================================================
--	   PORT  LIME		================================================================
--	SPEARTHROWER OWL	================================================================
--======================================================================================
-- Author: Spearthrower Lime
-- DateCreated: 2/6/2020 10:12:49
----------------------------------------------------------------------------------------
-- The Owl That Will Strike
----------------------------------------------------------------------------------------
--	LUA: LORD OF THE WEST
--		Has access to the Emissary Unique Governor, Fire Is Born. The Capital gains +1
--		Population when a City-State is Conquered.
--
----------------------------------------------------------------------------------------
--	LUG: FIRE IS BORN, the Emissary
--        
--		P0: ARRIVAL OF STRANGERS
--			May be assigned to a City-State. Friendly Units defending this city gain +5
--			combat strength.
--
--		L1: WAKA OUTPOST
--			While established in a City-State, provides a copy of its Luxury resources.
--
--		R1: PETÉN EXPEDITION
--			City States within 9 tiles lose Walls Strength, while this city gains Walls 
--			Strength.
--    
--		L2: FALL OF JAGUAR PAW
--			Friendly Spies in this city act as if 3 levels more experienced when 
--          Siphoning Funds or Fabricating Scandals, and complete these missions 25%
--			faster. Friendly Spies take no time to be established in this city.
--        
--		R2: OVERSEER OF KINGS
--			Conquered Cities within 9 tiles gain +25% production City Center Buildings,
--			Commercial Hubs, and Commercial Hub Buildings.
--
--		P3: HEGEMONY OF SACRED FIRE
--			Vassal City-States within 9 tiles generate +1 Diplomatic Favor. Conquered 
--			Cities within 9 tiles permanently generate +1 Diplomatic Favor. 
--			
----------------------------------------------------------------------------------------
--	AGENDA: SHADOW EMPIRE
--		Will vigourously attack and compete for city-states. Respects warmongers and 
--		those with large armies, but dislikes those who conquer, protect, or subjugate 
--		city-states. Will attack those in Dark Ages. 
--
----------------------------------------------------------------------------------------
--	Notes:
--		Gotta figure out some way for Owl Warriors to easily take on free cities
--
--======================================================================================
-- Types ===============================================================================
--======================================================================================
INSERT INTO Types
		(Type,												Kind)
VALUES	('LEADER_LIME_TEO_OWL',								'KIND_LEADER'),
		('TRAIT_LEADER_LIME_TEO_OWL_FIRE_IS_BORN',			'KIND_TRAIT'),
		('GOVERNOR_LIME_TEO_OWL_EMISSARY',					'KIND_GOVERNOR'),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_ARRIVAL',			'KIND_GOVERNOR_PROMOTION'),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_OUTPOST',			'KIND_GOVERNOR_PROMOTION'),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_EXPEDITION',		'KIND_GOVERNOR_PROMOTION'),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL',			'KIND_GOVERNOR_PROMOTION'),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_OVERSEER',		'KIND_GOVERNOR_PROMOTION'),
		('MODTYPE_LIME_EMISSARY_INCREASE_SINGLE_DISTRICT_BUILDINGS',	'KIND_MODIFIER'),
		('MODTYPE_LIME_EMISSARY_ALL_PLAYERS_ADJUST_FAVOR_PER_TURN',		'KIND_MODIFIER'),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_HEGEMONY',		'KIND_GOVERNOR_PROMOTION'),					
		('TRAIT_AGENDA_LIME_TEO_OWL_LORD_OF_WEST',			'KIND_TRAIT');

--======================================================================================
-- Civilization Leaders and stuff ======================================================
--======================================================================================
INSERT INTO Leaders
		(LeaderType,						Name,								InheritFrom,		SceneLayers)
VALUES	('LEADER_LIME_TEO_OWL',				'LOC_LEADER_LIME_TEO_OWL_NAME',		'LEADER_DEFAULT',	4);

INSERT INTO CivilizationLeaders
		(CivilizationType,					LeaderType,					CapitalName)
VALUES	('CIVILIZATION_LIME_TEOTIHUACAN',	'LEADER_LIME_TEO_OWL',		'LOC_CITY_NAME_TEOTIHUACAN');

INSERT INTO LeaderQuotes
		(LeaderType,						Quote)
VALUES	('LEADER_LIME_TEO_OWL',				'LOC_PEDIA_LEADERS_PAGE_LEADER_LIME_TEO_OWL_QUOTE');

INSERT INTO LoadingInfo
		(LeaderType,						BackgroundImage,				ForegroundImage,				PlayDawnOfManAudio)
VALUES	('LEADER_LIME_TEO_OWL',				'LEADER_MONTEZUMA_BACKGROUND',	'LEADER_LIME_TEO_OWL_NEUTRAL',	0);

INSERT INTO FavoredReligions
		(LeaderType,						ReligionType)
VALUES	('LEADER_LIME_TEO_OWL',				'RELIGION_CATHOLICISM');

UPDATE FavoredReligions
	SET ReligionType = 'RELIGION_TLATEOMATILIZTLI'
	WHERE LeaderType = 'LEADER_LIME_TEO_OWL' 
	AND EXISTS (SELECT ReligionType FROM Religions WHERE ReligionType = 'RELIGION_TLATEOMATILIZTLI');

CREATE TRIGGER Lime_Teo_Owl_FavoredReligions 
	AFTER INSERT ON Religions WHEN 'RELIGION_TLATEOMATILIZTLI' = NEW.ReligionType 	
	BEGIN 
		INSERT OR REPLACE INTO FavoredReligions 
			(LeaderType, 		 	ReligionType) 
			VALUES 	('LEADER_LIME_TEO_OWL',	'RELIGION_TLATEOMATILIZTLI');
	END;

--======================================================================================
-- Leader Traits =======================================================================
--======================================================================================
--	LUA: LORD OF THE WEST
--		Has access to the Emissary Unique Governor, Fire Is Born. Conquered City-States
--		generate +1 Population for the Capital.
--
INSERT INTO LeaderTraits
		(LeaderType,										TraitType)
VALUES	('LEADER_LIME_TEO_OWL',								'TRAIT_LEADER_LIME_TEO_OWL_FIRE_IS_BORN');

INSERT INTO Traits
		(TraitType,											Name,													Description)
VALUES	('TRAIT_LEADER_LIME_TEO_OWL_FIRE_IS_BORN',			'LOC_TRAIT_LEADER_LIME_TEO_OWL_FIRE_IS_BORN_NAME',		'LOC_TRAIT_LEADER_LIME_TEO_OWL_FIRE_IS_BORN_DESC');

/*INSERT INTO TraitModifiers
		(TraitType,											ModifierId)
VALUES	('TRAIT_LEADER_LIME_TEO_OWL_FIRE_IS_BORN',			'MOD_LIME_TEO_OWL_GRANT_CONQUEST_POP');

INSERT INTO DynamicModifiers
		(ModifierType,										CollectionType,											EffectType)
VALUES	('DYNMOD_LIME_TEO_OWL_GRANT_CAP_POP',				'COLLECTION_PLAYER_CAPITAL_CITY',						'EFFECT_ADJUST_CITY_POPULATION');

INSERT INTO Modifiers
		(ModifierId,										ModifierType,											SubjectRequirementSetId)	
VALUES	('MOD_LIME_TEO_OWL_GRANT_CONQUEST_POP',				'MODIFIER_PLAYER_CAPTURED_CITY_ATTACH_MODIFIER',		'REQUIRES_PLAYER_IS_MINOR'),
		('MOD_LIME_TEO_OWL_GRANT_POP',						'MOD_LIME_TEO_OWL_GRANT_CONQUEST_POP',					NULL);
		
INSERT INTO ModifierArguments
		(ModifierId,										Name,				Value)
VALUES	('MOD_LIME_TEO_OWL_GRANT_CONQUEST_POP',				'ModifierId',		'MOD_LIME_TEO_OWL_GRANT_POP'),
		('MOD_LIME_TEO_OWL_GRANT_POP',						'Amount',			1);
 -- I'll just do it with lua */
--======================================================================================
-- Unique Governor =====================================================================
--======================================================================================
--	LUG: FIRE IS BORN, the Emissary
--        
--		P0: ARRIVAL OF STRANGERS
--			May be assigned to a City-State. Friendly Units defending this city gain +5
--			combat strength.
--
--		L1: WAKA OUTPOST
--			While established in a City-State, provides a copy of its Luxury resources.
--
--		R1: PETÉN EXPEDITION
--			City States within 9 tiles lose Walls Strength, while this city gains Walls 
--			Strength.
--    
--		L2: FALL OF JAGUAR PAW
--			Friendly Spies in this city act as if 3 levels more experienced when 
--          Siphoning Funds or Fabricating Scandals, and complete these missions 25%
--			faster. Friendly Spies take no time to be established in this city.
--        
--		R2: OVERSEER OF KINGS
--			Conquered Cities within 9 tiles gain +25% production City Center Buildings,
--			Commercial Hubs, and Commercial Hub Buildings.
--
--		P3: HEGEMONY OF SACRED FIRE
--			Vassal City-States within 9 tiles generate +1 Diplomatic Favor. Conquered 
--			Cities within 9 tiles permanently generate +1 Diplomatic Favor. 
--	
----------------------------------------------------------------------------------------
INSERT INTO Governors
		(GovernorType,						Name,										Description,								IdentityPressure,	Title,										ShortTitle,											TransitionStrength,	AssignCityState,	Image,								PortraitImage,					PortraitImageSelected,				TraitType)
VALUES	('GOVERNOR_LIME_TEO_OWL_EMISSARY',	'LOC_GOVERNOR_LIME_TEO_OWL_EMISSARY_NAME',	'LOC_GOVERNOR_LIME_TEO_OWL_EMISSARY_DESC',	8,					'LOC_GOVERNOR_LIME_TEO_OWL_EMISSARY_TITLE',	'LOC_GOVERNOR_LIME_TEO_OWL_EMISSARY_SHORT_TITLE',	150,				1,					'GOVERNOR_LIME_TEO_OWL_EMISSARY',	'GovernorNormal_LimeEmissary',	'GovernorSelected_LimeEmissary',	'TRAIT_LEADER_LIME_TEO_OWL_FIRE_IS_BORN');

INSERT INTO MomentIllustrations
		(MomentIllustrationType,			MomentDataType,				GameDataType,						Texture)
VALUES	('MOMENT_ILLUSTRATION_GOVERNOR',	'MOMENT_DATA_GOVERNOR',		'GOVERNOR_LIME_TEO_OWL_EMISSARY',	'Moment_PromoteGovernor_Lime_Emissary.dds');

INSERT INTO GovernorPromotionSets
		(GovernorType,						GovernorPromotion)
VALUES	('GOVERNOR_LIME_TEO_OWL_EMISSARY',	'GOV_PROMO_LIME_TEO_OWL_EMISSARY_ARRIVAL'),			
		('GOVERNOR_LIME_TEO_OWL_EMISSARY',	'GOV_PROMO_LIME_TEO_OWL_EMISSARY_OUTPOST'),			
		('GOVERNOR_LIME_TEO_OWL_EMISSARY',	'GOV_PROMO_LIME_TEO_OWL_EMISSARY_EXPEDITION'),		
		('GOVERNOR_LIME_TEO_OWL_EMISSARY',	'GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL'),			
		('GOVERNOR_LIME_TEO_OWL_EMISSARY',	'GOV_PROMO_LIME_TEO_OWL_EMISSARY_OVERSEER'),		
		('GOVERNOR_LIME_TEO_OWL_EMISSARY',	'GOV_PROMO_LIME_TEO_OWL_EMISSARY_HEGEMONY');		
		
INSERT INTO GovernorPromotions
		(GovernorPromotionType,							Name,													Description,											Level,	Column,	BaseAbility)
VALUES	('GOV_PROMO_LIME_TEO_OWL_EMISSARY_ARRIVAL',		'LOC_GOV_PROMO_LIME_TEO_OWL_EMISSARY_ARRIVAL_NAME',		'LOC_GOV_PROMO_LIME_TEO_OWL_EMISSARY_ARRIVAL_DESC',		0,		1,		1),	
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_OUTPOST',		'LOC_GOV_PROMO_LIME_TEO_OWL_EMISSARY_OUTPOST_NAME',		'LOC_GOV_PROMO_LIME_TEO_OWL_EMISSARY_OUTPOST_DESC',		1,		0,		0),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_EXPEDITION',	'LOC_GOV_PROMO_LIME_TEO_OWL_EMISSARY_EXPEDITION_NAME',	'LOC_GOV_PROMO_LIME_TEO_OWL_EMISSARY_EXPEDITION_DESC',	1,		2,		0),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL',		'LOC_GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL_NAME',		'LOC_GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL_DESC',		2,		0,		0),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_OVERSEER',	'LOC_GOV_PROMO_LIME_TEO_OWL_EMISSARY_OVERSEER_NAME',	'LOC_GOV_PROMO_LIME_TEO_OWL_EMISSARY_OVERSEER_DESC',	2,		2,		0),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_HEGEMONY',	'LOC_GOV_PROMO_LIME_TEO_OWL_EMISSARY_HEGEMONY_NAME',	'LOC_GOV_PROMO_LIME_TEO_OWL_EMISSARY_HEGEMONY_DESC',	3,		1,		0);

INSERT INTO GovernorPromotionPrereqs
		(GovernorPromotionType,							PrereqGovernorPromotion)
VALUES	('GOV_PROMO_LIME_TEO_OWL_EMISSARY_OUTPOST',		'GOV_PROMO_LIME_TEO_OWL_EMISSARY_ARRIVAL'),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_EXPEDITION',	'GOV_PROMO_LIME_TEO_OWL_EMISSARY_ARRIVAL'),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL',		'GOV_PROMO_LIME_TEO_OWL_EMISSARY_OUTPOST'),		
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_OVERSEER',	'GOV_PROMO_LIME_TEO_OWL_EMISSARY_EXPEDITION'),	
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_HEGEMONY',	'GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL'),		
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_HEGEMONY',	'GOV_PROMO_LIME_TEO_OWL_EMISSARY_OVERSEER');	

INSERT INTO GovernorPromotionModifiers
		(GovernorPromotionType,							ModifierId)
VALUES	('GOV_PROMO_LIME_TEO_OWL_EMISSARY_ARRIVAL',		'MOD_LIME_TEO_OWL_EMISSARY_ARRIVAL_FORTIFY_UNITS'),				--Friendly Units defending this city gain +5 combat strength.
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_OUTPOST',		'MOD_LIME_TEO_OWL_EMISSARY_OUTPOST_CLONE_LUXES'),				--While established in a City-State, provides a copy of its Luxury resources.
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_EXPEDITION',	'MOD_LIME_TEO_OWL_EMISSARY_EXPEDITION_SAP_WALLS_ATTACH'),		--City-States within 6 tiles lose -10 Walls Strength (not this one)
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_EXPEDITION',	'MOD_LIME_TEO_OWL_EMISSARY_EXPEDITION_BUFF_WALLS'),				--This city gains +10 Wall Strength
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL',		'MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SCANDAL_ATTACH'),			--Friendly Spies in this City act as if 3 levels more experienced when Siphoning Funds or Fabricating Scandals. Spies take not time to be established in this city.
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL',		'MOD_LIME_TEO_OWL_EMISSARY_FALL_SPEEDY_SCANDAL_ATTACH'),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL',		'MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SIPHON_ATTACH'),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL',		'MOD_LIME_TEO_OWL_EMISSARY_FALL_SPEEDY_SIPHON_ATTACH'),
		--('GOV_PROMO_LIME_TEO_OWL_EMISSARY_FALL',		'MOD_LIME_TEO_OWL_EMISSARY_FALL_INSTANT_ESTABLISH_ATTACH'),		
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_OVERSEER',	'MOD_LIME_TEO_OWL_EMISSARY_OVERSEER_REBUILD_CITY_BUILDINGS'),	--Conquered Cities within 6 tiles gain +25% Production towards Buildings in City Centers
		--('GOV_PROMO_LIME_TEO_OWL_EMISSARY_OVERSEER',	'MOD_LIME_TEO_OWL_EMISSARY_OVERSEER_REBUILD_MARKET'),			--Conquered Cities within 6 tiles gain +25% Production towards Buildings in Commercial Hubs
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_OVERSEER',	'MOD_LIME_TEO_OWL_EMISSARY_OVERSEER_REBUILD_MARKET_BUILDINGS'),
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_HEGEMONY',	'MOD_LIME_TEO_OWL_EMISSARY_VASSAL_CS_FAVOR_ATTACH'),			--Vassal City-States within 6 tiles provide +1 Diplomatic Favour
		('GOV_PROMO_LIME_TEO_OWL_EMISSARY_HEGEMONY',	'MOD_LIME_TEO_OWL_EMISSARY_CONQUERED_FAVOR_ATTACH');			--Conquered Cities within 6 tiles permanently provide +1 Diplomatic Favor

INSERT INTO DynamicModifiers
		(ModifierType,													CollectionType,							EffectType)
VALUES	--('MODTYPE_LIME_EMISSARY_INCREASE_SINGLE_DISTRICT_PRODUCTION',	'COLLECTION_PLAYER_CAPTURED_CITIES',	'EFFECT_ADJUST_DISTRICT_PRODUCTION'),
		('MODTYPE_LIME_EMISSARY_INCREASE_SINGLE_DISTRICT_BUILDINGS',	'COLLECTION_PLAYER_CAPTURED_CITIES',	'EFFECT_ADJUST_BUILDING_PRODUCTION'),
		('MODTYPE_LIME_EMISSARY_ALL_PLAYERS_ADJUST_FAVOR_PER_TURN',		'COLLECTION_ALL_PLAYERS',				'EFFECT_ADJUST_PLAYER_EXTRA_FAVOR_PER_TURN');

INSERT INTO Modifiers
		(ModifierId,													ModifierType,													SubjectRequirementSetId,										SubjectStackLimit,	Permanent)
VALUES	('MOD_LIME_TEO_OWL_EMISSARY_ARRIVAL_FORTIFY_UNITS',				'MODIFIER_CITY_ADJUST_CITY_COMBAT_BONUS',						NULL,															NULL,				0),	--GARRISON_COMMANDER_ADJUST_CITY_COMBAT_BONUS
		
		('MOD_LIME_TEO_OWL_EMISSARY_OUTPOST_CLONE_LUXES',				'MODIFIER_GOVERNOR_ADJUST_CITY_COPY_LUXURIES_FOR_IMPORT',		NULL,															NULL,				0),	--AFFLUENCE_COPY_LUXURIES_FOR_IMPORT
		
		('MOD_LIME_TEO_OWL_EMISSARY_EXPEDITION_SAP_WALLS_ATTACH',		'MODIFIER_ALL_CITIES_ATTACH_MODIFIER',							'REQSET_LIME_TEO_OWL_EMISSARY_CITYSTATE_WITHIN_6_NONINCLUSIVE',	NULL,				0),	--DEFENDER_ADJUST_CITY_DEFENSE_STRENGTH
			('MOD_LIME_TEO_OWL_EMISSARY_EXPEDITION_SAP_WALLS',			'MODIFIER_PLAYER_CITIES_ADJUST_INNER_DEFENSE_STRENGTH',			NULL,															NULL,				0),
		('MOD_LIME_TEO_OWL_EMISSARY_EXPEDITION_BUFF_WALLS',				'MODIFIER_PLAYER_CITIES_ADJUST_INNER_DEFENSE',					NULL,															NULL,				0),	--DEFENDER_ADJUST_CITY_DEFENSE_STRENGTH
		
		('MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SCANDAL_ATTACH',			'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',						'REQSET_LIME_TEO_OWL_EMISSARY_UNIT_WITHIN_3',					NULL,				0),	
			('MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SCANDAL',				'MODIFIER_PLAYER_UNIT_ADJUST_SPY_OPERATION_CHANCE',				NULL,															NULL,				0),	--Smear Campaign
		('MOD_LIME_TEO_OWL_EMISSARY_FALL_SPEEDY_SCANDAL_ATTACH',		'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',						'REQSET_LIME_TEO_OWL_EMISSARY_UNIT_WITHIN_3',					NULL,				0),	
			('MOD_LIME_TEO_OWL_EMISSARY_FALL_SPEEDY_SCANDAL',			'MODIFIER_PLAYER_UNIT_ADJUST_SPY_OPERATION_TIME',				NULL,															NULL,				0), --SPY_LINGUIST_HEISTTIME
		('MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SIPHON_ATTACH',			'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',						'REQSET_LIME_TEO_OWL_EMISSARY_UNIT_WITHIN_3',					NULL,				0),	
			('MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SIPHON',				'MODIFIER_PLAYER_UNIT_ADJUST_SPY_OPERATION_CHANCE',				NULL,															NULL,				0),	--Con Artist
		('MOD_LIME_TEO_OWL_EMISSARY_FALL_SPEEDY_SIPHON_ATTACH',			'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',						'REQSET_LIME_TEO_OWL_EMISSARY_UNIT_WITHIN_3',					NULL,				0),	
			('MOD_LIME_TEO_OWL_EMISSARY_FALL_SPEEDY_SIPHON',			'MODIFIER_PLAYER_UNIT_ADJUST_SPY_OPERATION_TIME',				NULL,															NULL,				0),
	--	('MOD_LIME_TEO_OWL_EMISSARY_FALL_INSTANT_ESTABLISH_ATTACH',		'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',						'REQSET_LIME_TEO_OWL_EMISSARY_UNIT_WITHIN_3',					NULL,				0),	
	--		('MOD_LIME_TEO_OWL_EMISSARY_FALL_INSTANT_ESTABLISH',		'MODIFIER_PLAYER_UNIT_ADJUST_SPY_ESTABLISH_TIME',				NULL,															NULL,				0),	--Disguise

		('MOD_LIME_TEO_OWL_EMISSARY_OVERSEER_REBUILD_CITY_BUILDINGS',	'MODTYPE_LIME_EMISSARY_INCREASE_SINGLE_DISTRICT_BUILDINGS',		'REQSET_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6',					NULL,				0), --VETERANCY_ENCAMPMENT_BUILDINGS_PRODUCTION
	--	('MOD_LIME_TEO_OWL_EMISSARY_OVERSEER_REBUILD_MARKET',			'MODTYPE_LIME_EMISSARY_INCREASE_SINGLE_DISTRICT_PRODUCTION',	'REQSET_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6',					NULL,				0),	--VETERANCY_ENCAMPMENT_PRODUCTION
		('MOD_LIME_TEO_OWL_EMISSARY_OVERSEER_REBUILD_MARKET_BUILDINGS',	'MODTYPE_LIME_EMISSARY_INCREASE_SINGLE_DISTRICT_BUILDINGS',		'REQSET_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6',					NULL,				0), 

		('MOD_LIME_TEO_OWL_EMISSARY_HEGEMONY_VASSAL_CS_FAVOR_ATTACH',	'MODIFIER_ALL_CITIES_ATTACH_MODIFIER',							'REQSET_LIME_TEO_OWL_EMISSARY_CITYSTATE_WITHIN_6',				NULL,				0),	-- Attach a modifier
			('MOD_LIME_TEO_OWL_EMISSARY_HEGEMONY_VASSAL_FAVOR',			'MODTYPE_LIME_EMISSARY_ALL_PLAYERS_ADJUST_FAVOR_PER_TURN',		'PLAYER_IS_SUZERAIN',											NULL,				0),
		('MOD_LIME_TEO_OWL_EMISSARY_HEGEMONY_CONQUERED_FAVOR_ATTACH',	'MODIFIER_PLAYER_CAPTURED_CITY_ATTACH_MODIFIER',				'REQSET_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6',					NULL,				1),	-- Attach a PERMANENT modifier
			('MOD_LIME_TEO_OWL_EMISSARY_HEGEMONY_CONQUERED_FAVOR',		'MODIFIER_PLAYER_ADJUST_EXTRA_FAVOR_PER_TURN',					NULL,															1,					0);	--PAGODA_ADJUST_FAVOR

INSERT INTO ModifierArguments
		(ModifierId,													Name,					Value) --MODIFIER_CITY_INCREASE_DISTRICT_PRODUCTION_RATE
VALUES	('MOD_LIME_TEO_OWL_EMISSARY_ARRIVAL_FORTIFY_UNITS',				'Amount',				5),

		--('MOD_LIME_TEO_OWL_EMISSARY_OUTPOST_CLONE_LUXES',	NO ARGUMENTS	

		('MOD_LIME_TEO_OWL_EMISSARY_EXPEDITION_SAP_WALLS_ATTACH',		'ModifierId',			'MOD_LIME_TEO_OWL_EMISSARY_EXPEDITION_SAP_WALLS'),
			('MOD_LIME_TEO_OWL_EMISSARY_EXPEDITION_SAP_WALLS',			'Amount',				-5),
		('MOD_LIME_TEO_OWL_EMISSARY_EXPEDITION_BUFF_WALLS',				'Amount',				5),
		
		('MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SCANDAL_ATTACH',			'ModifierId',			'MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SCANDAL'),
			('MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SCANDAL',				'OperationType',		'UNITOPERATION_SPY_FABRICATE_SCANDAL'),
			('MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SCANDAL',				'Offensive',			1),
			('MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SCANDAL',				'Amount',				3),
		('MOD_LIME_TEO_OWL_EMISSARY_FALL_SPEEDY_SCANDAL_ATTACH',		'ModifierId',			'MOD_LIME_TEO_OWL_EMISSARY_FALL_SPEEDY_SCANDAL'),
			('MOD_LIME_TEO_OWL_EMISSARY_FALL_SPEEDY_SCANDAL',			'OperationType',		'UNITOPERATION_SPY_FABRICATE_SCANDAL'),
			('MOD_LIME_TEO_OWL_EMISSARY_FALL_SPEEDY_SCANDAL',			'ReductionPercent',		25),
		('MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SIPHON_ATTACH',			'ModifierId',			'MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SIPHON'),
			('MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SIPHON',				'OperationType',		'UNITOPERATION_SPY_SIPHON_FUNDS'),
			('MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SIPHON',				'Offensive',			1),
			('MOD_LIME_TEO_OWL_EMISSARY_FALL_BUFF_SIPHON',				'Amount',				3),
		('MOD_LIME_TEO_OWL_EMISSARY_FALL_SPEEDY_SIPHON_ATTACH',			'ModifierId',			'MOD_LIME_TEO_OWL_EMISSARY_FALL_SPEEDY_SIPHON'),
			('MOD_LIME_TEO_OWL_EMISSARY_FALL_SPEEDY_SIPHON',			'OperationType',		'UNITOPERATION_SPY_SIPHON_FUNDS'),
			('MOD_LIME_TEO_OWL_EMISSARY_FALL_SPEEDY_SIPHON',			'ReductionPercent',		25),
	--	('MOD_LIME_TEO_OWL_EMISSARY_FALL_INSTANT_ESTABLISH_ATTACH',		'ModifierId',			'MOD_LIME_TEO_OWL_EMISSARY_FALL_INSTANT_ESTABLISH'),
	--		('MOD_LIME_TEO_OWL_EMISSARY_FALL_INSTANT_ESTABLISH',		'ReductionPercent',		100),

		('MOD_LIME_TEO_OWL_EMISSARY_OVERSEER_REBUILD_CITY_BUILDINGS',	'DistrictType',			'DISTRICT_CITY_CENTER'),
		('MOD_LIME_TEO_OWL_EMISSARY_OVERSEER_REBUILD_CITY_BUILDINGS',	'Amount',				25),
		--('MOD_LIME_TEO_OWL_EMISSARY_OVERSEER_REBUILD_MARKET',			'DistrictType',			'DISTRICT_COMMERCIAL_HUB'),
		--('MOD_LIME_TEO_OWL_EMISSARY_OVERSEER_REBUILD_MARKET',			'Amount',				25),
		('MOD_LIME_TEO_OWL_EMISSARY_OVERSEER_REBUILD_MARKET_BUILDINGS',	'DistrictType',			'DISTRICT_COMMERCIAL_HUB'),
		('MOD_LIME_TEO_OWL_EMISSARY_OVERSEER_REBUILD_MARKET_BUILDINGS',	'Amount',				25),

		('MOD_LIME_TEO_OWL_EMISSARY_HEGEMONY_VASSAL_CS_FAVOR_ATTACH',	'ModifierId',			'MOD_LIME_TEO_OWL_EMISSARY_HEGEMONY_VASSAL_FAVOR'),
			('MOD_LIME_TEO_OWL_EMISSARY_HEGEMONY_VASSAL_FAVOR',			'Amount',				1),
		('MOD_LIME_TEO_OWL_EMISSARY_HEGEMONY_CONQUERED_FAVOR_ATTACH',	'ModifierId',			'MOD_LIME_TEO_OWL_EMISSARY_HEGEMONY_CONQUERED_FAVOR'),
			('MOD_LIME_TEO_OWL_EMISSARY_HEGEMONY_CONQUERED_FAVOR',		'Amount',				1);

INSERT INTO RequirementSets
		(RequirementSetId,													RequirementSetType)
VALUES	('REQSET_LIME_TEO_OWL_EMISSARY_CITYSTATE_WITHIN_6_NONINCLUSIVE',	'REQUIREMENTSET_TEST_ALL'),
		('REQSET_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6',						'REQUIREMENTSET_TEST_ALL'),
		('REQSET_LIME_TEO_OWL_EMISSARY_UNIT_WITHIN_3',						'REQUIREMENTSET_TEST_ALL'),
		('REQSET_LIME_TEO_OWL_EMISSARY_CITYSTATE_WITHIN_6',					'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
		(RequirementSetId,													RequirementId)
VALUES	('REQSET_LIME_TEO_OWL_EMISSARY_CITYSTATE_WITHIN_6_NONINCLUSIVE',	'REQ_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6_NONINCLUSIVE'),
		('REQSET_LIME_TEO_OWL_EMISSARY_CITYSTATE_WITHIN_6_NONINCLUSIVE',	'REQUIRES_PLAYER_IS_MINOR'),
		('REQSET_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6',						'REQ_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6'),
		('REQSET_LIME_TEO_OWL_EMISSARY_UNIT_WITHIN_3',						'REQ_LIME_TEO_OWL_EMISSARY_UNIT_WITHIN_3'),
		('REQSET_LIME_TEO_OWL_EMISSARY_CITYSTATE_WITHIN_6',					'REQ_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6'),
		('REQSET_LIME_TEO_OWL_EMISSARY_CITYSTATE_WITHIN_6',					'REQUIRES_PLAYER_IS_MINOR');

INSERT INTO Requirements
		(RequirementId,														RequirementType)
VALUES	('REQ_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6_NONINCLUSIVE',			'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
		('REQ_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6',							'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'),
		('REQ_LIME_TEO_OWL_EMISSARY_UNIT_WITHIN_3',							'REQUIREMENT_PLOT_ADJACENT_TO_OWNER');

INSERT INTO RequirementArguments
		(RequirementId,														Name,						Value)
VALUES	('REQ_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6_NONINCLUSIVE',			'MinDistance',				2),
		('REQ_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6',							'MinDistance',				0),
		('REQ_LIME_TEO_OWL_EMISSARY_UNIT_WITHIN_3',							'MinDistance',				0),
		('REQ_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6_NONINCLUSIVE',			'MaxDistance',				6),
		('REQ_LIME_TEO_OWL_EMISSARY_CITY_WITHIN_6',							'MaxDistance',				6),
		('REQ_LIME_TEO_OWL_EMISSARY_UNIT_WITHIN_3',							'MaxDistance',				3);

--======================================================================================
-- Leader Agenda =======================================================================
--======================================================================================
--	AGENDA: SHADOW EMPIRE
--		Will vigourously attack and compete for city-states. Respects warmongers and 
--		those with large armies, but dislikes those who conquer, protect, or subjugate 
--		city-states. 
--
INSERT INTO HistoricalAgendas
		(LeaderType,										AgendaType)
VALUES	('LEADER_LIME_TEO_OWL',								'AGENDA_LIME_TEO_OWL_LORD_OF_WEST'); -- Etruscan Boar fixed this for me

INSERT INTO Agendas
		(AgendaType,										Name,											Description)
VALUES	('AGENDA_LIME_TEO_OWL_LORD_OF_WEST',				'LOC_AGENDA_LIME_TEO_OWL_LORD_OF_WEST_NAME',	'LOC_AGENDA_LIME_TEO_OWL_LORD_OF_WEST_DESC');

INSERT INTO Traits
		(TraitType,											Name,											Description)
VALUES	('TRAIT_AGENDA_LIME_TEO_OWL_LORD_OF_WEST',			'LOC_AGENDA_LIME_TEO_OWL_LORD_OF_WEST_NAME',	'LOC_AGENDA_LIME_TEO_OWL_LORD_OF_WEST_DESC');

INSERT INTO AgendaTraits
		(AgendaType,										TraitType)
VALUES	('AGENDA_LIME_TEO_OWL_LORD_OF_WEST',				'TRAIT_AGENDA_LIME_TEO_OWL_LORD_OF_WEST');

INSERT INTO ExclusiveAgendas
		(AgendaOne,											AgendaTwo)
VALUES	('AGENDA_LIME_TEO_OWL_LORD_OF_WEST',				'AGENDA_CITY_STATE_PROTECTOR'),
		('AGENDA_LIME_TEO_OWL_LORD_OF_WEST',				'AGENDA_CITY_STATE_ALLY'),
		('AGENDA_LIME_TEO_OWL_LORD_OF_WEST',				'AGENDA_DARWINIST'),
		('AGENDA_LIME_TEO_OWL_LORD_OF_WEST',				'AGENDA_PARANOID');

INSERT INTO TraitModifiers
		(TraitType,											ModifierId)
VALUES	-- These are the actual agenda traits
		('TRAIT_AGENDA_LIME_TEO_OWL_LORD_OF_WEST',			'MOD_LIME_TEO_OWL_AGENDA_WARRIOR_KING'),
		('TRAIT_AGENDA_LIME_TEO_OWL_LORD_OF_WEST',			'MOD_LIME_TEO_OWL_AGENDA_CS_ATTACK_OR_COMPETE'),

		-- Here are the "personality traits"
		('TRAIT_AGENDA_LIME_TEO_OWL_LORD_OF_WEST',			'AGENDA_MODIFIER_WARMONGER');

INSERT INTO Modifiers
		(ModifierId,										ModifierType,										SubjectRequirementSetId)
VALUES	('MOD_LIME_TEO_OWL_AGENDA_WARRIOR_KING',			'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',		'REQSET_LIME_TEO_OWL_PLAYER_IS_WARRIOR_KING'),
		('MOD_LIME_TEO_OWL_AGENDA_CS_ATTACK_OR_COMPETE',	'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',		'REQSET_LIME_TEO_OWL_PLAYER_INTERFERES_WITH_CS');

INSERT INTO ModifierArguments
		(ModifierId,										Name,							Value)
VALUES	('MOD_LIME_TEO_OWL_AGENDA_WARRIOR_KING',			'InitialValue',					16),
		('MOD_LIME_TEO_OWL_AGENDA_WARRIOR_KING',			'ReductionTurns',				4),
		('MOD_LIME_TEO_OWL_AGENDA_WARRIOR_KING',			'ReductionValue',				-4),
		('MOD_LIME_TEO_OWL_AGENDA_WARRIOR_KING',			'MessageThrottle',				20),
		('MOD_LIME_TEO_OWL_AGENDA_WARRIOR_KING',			'StatementKey',					'LOC_DIPLO_KUDOS_EXIT_LEADER_LIME_TEO_OWL_WARRIOR_KING_POS'),
		('MOD_LIME_TEO_OWL_AGENDA_WARRIOR_KING',			'SimpleModifierDescription',	'LOC_DIPLO_MODIFIER_EXIT_LEADER_LIME_TEO_OWL_WARRIOR_KING_POS'),

		('MOD_LIME_TEO_OWL_AGENDA_CS_ATTACK_OR_COMPETE',	'InitialValue',					-16),
		('MOD_LIME_TEO_OWL_AGENDA_CS_ATTACK_OR_COMPETE',	'MessageThrottle',				20),
		('MOD_LIME_TEO_OWL_AGENDA_CS_ATTACK_OR_COMPETE',	'StatementKey',					'LOC_DIPLO_WARNING_EXIT_LEADER_LIME_TEO_OWL_CS_ATTACK_OR_COMPETE_NEG'),
		('MOD_LIME_TEO_OWL_AGENDA_CS_ATTACK_OR_COMPETE',	'SimpleModifierDescription',	'LOC_DIPLO_MODIFIER_EXIT_LEADER_LIME_TEO_OWL_CS_ATTACK_OR_COMPETE_NEG');

INSERT INTO RequirementSets
		(RequirementSetId,									RequirementSetType)
VALUES	('REQSET_LIME_TEO_OWL_PLAYER_IS_WARRIOR_KING',		'REQUIREMENTSET_TEST_ALL'),
			('REQSET_LIME_TEO_OWL_PLAYER_IS_WARRIOR',			'REQUIREMENTSET_TEST_ANY'),
		('REQSET_LIME_TEO_OWL_PLAYER_INTERFERES_WITH_CS',	'REQUIREMENTSET_TEST_ALL'),
			('REQSET_LIME_TEO_OWL_PLAYER_DOES_MEDDLE',			'REQUIREMENTSET_TEST_ANY'),
		('REQSET_LIME_TEO_OWL_AGENDA_COOLDOWNS',			'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
		(RequirementSetId,									RequirementId)
VALUES	('REQSET_LIME_TEO_OWL_PLAYER_IS_WARRIOR_KING',		'REQ_LIME_TEO_OWL_PLAYER_IS_WARRIOR'),		-- High standing army OR Warmonger!
			('REQSET_LIME_TEO_OWL_PLAYER_IS_WARRIOR',			'REQUIRES_HAS_HIGH_STANDING_ARMY'),
			('REQSET_LIME_TEO_OWL_PLAYER_IS_WARRIOR',			'REQ_LIME_TEO_OWL_PLAYER_WARMONGER_TRIGGERS'),
		('REQSET_LIME_TEO_OWL_PLAYER_IS_WARRIOR_KING',		'REQ_LIME_TEO_OWL_PLAYER_DOES_NOT_MEDDLE'),	-- To Supercede the above effect
		('REQSET_LIME_TEO_OWL_PLAYER_IS_WARRIOR_KING',		'REQ_LIME_TEO_OWL_AGENDA_COOLDOWNS'),		-- To make sure he isn't a bitch

		('REQSET_LIME_TEO_OWL_PLAYER_INTERFERES_WITH_CS',	'REQ_LIME_TEO_OWL_PLAYER_DOES_MEDDLE'),
			('REQSET_LIME_TEO_OWL_PLAYER_DOES_MEDDLE',			'REQUIRES_COMPETING_MINORS'),
			('REQSET_LIME_TEO_OWL_PLAYER_DOES_MEDDLE',			'REQUIRES_CONQUERING_ALLYING_MINORS'),
			('REQSET_LIME_TEO_OWL_PLAYER_DOES_MEDDLE',			'REQUIRES_MED_CITY_STATE_AGGRESSION'),
			('REQSET_LIME_TEO_OWL_PLAYER_DOES_MEDDLE',			'REQUIRES_MED_CITY_STATE_PROTECTION'),
		('REQSET_LIME_TEO_OWL_PLAYER_INTERFERES_WITH_CS',	'REQ_LIME_TEO_OWL_AGENDA_COOLDOWNS'),
		
		('REQSET_LIME_TEO_OWL_AGENDA_COOLDOWNS',			'REQUIRES_MAJOR_CIV_OPPONENT'),
		('REQSET_LIME_TEO_OWL_AGENDA_COOLDOWNS',			'REQUIRES_MET_10_TURNS_AGO');

INSERT INTO Requirements
		(RequirementId,										RequirementType,						Inverse)
VALUES	('REQ_LIME_TEO_OWL_PLAYER_IS_WARRIOR',				'REQUIREMENT_REQUIREMENTSET_IS_MET',	0),
		('REQ_LIME_TEO_OWL_PLAYER_WARMONGER_TRIGGERS',		'REQUIREMENT_REQUIREMENTSET_IS_MET',	0),
		('REQ_LIME_TEO_OWL_PLAYER_DOES_NOT_MEDDLE',			'REQUIREMENT_REQUIREMENTSET_IS_MET',	1),
		('REQ_LIME_TEO_OWL_PLAYER_DOES_MEDDLE',				'REQUIREMENT_REQUIREMENTSET_IS_MET',	0),
		('REQ_LIME_TEO_OWL_AGENDA_COOLDOWNS',				'REQUIREMENT_REQUIREMENTSET_IS_MET',	0);

INSERT INTO RequirementArguments
		(RequirementId,										Name,					Value)
VALUES	('REQ_LIME_TEO_OWL_PLAYER_IS_WARRIOR',				'RequirementSetId',		'REQSET_LIME_TEO_OWL_PLAYER_IS_WARRIOR'),
		('REQ_LIME_TEO_OWL_PLAYER_WARMONGER_TRIGGERS',		'RequirementSetId',		'WARMONGER_TRIGGERS'),
		('REQ_LIME_TEO_OWL_PLAYER_DOES_NOT_MEDDLE',			'RequirementSetId',		'REQSET_LIME_TEO_OWL_PLAYER_DOES_MEDDLE'),
		('REQ_LIME_TEO_OWL_PLAYER_DOES_MEDDLE',				'RequirementSetId',		'REQSET_LIME_TEO_OWL_PLAYER_DOES_MEDDLE'),
		('REQ_LIME_TEO_OWL_AGENDA_COOLDOWNS',				'RequirementSetId',		'REQSET_LIME_TEO_OWL_AGENDA_COOLDOWNS');

--============================================================
-- AI - this is easily the worst part
--============================================================
-------------------------------------
-- AiListTypes
-------------------------------------
INSERT INTO AiListTypes	
		(ListType)
VALUES	('LEADER_LIME_TEO_OWL_Victories'),
		('LEADER_LIME_TEO_OWL_Alliances'),
		('LEADER_LIME_TEO_OWL_Diplo'),
		('LEADER_LIME_TEO_OWL_CBs'),
		('LEADER_LIME_TEO_OWL_Discussions'),
		('LEADER_LIME_TEO_OWL_Resolutions'),
		('LEADER_LIME_TEO_OWL_BuildSpecializations'),
		('LEADER_LIME_TEO_OWL_PseudoYields'),
		('LEADER_LIME_TEO_OWL_Yields'),
		('LEADER_LIME_TEO_OWL_Wonders'),
		('LEADER_LIME_TEO_OWL_UnitPromoClasses');

INSERT INTO AiLists	
		(ListType,										AgendaType,											System)
VALUES	('LEADER_LIME_TEO_OWL_Victories',				'TRAIT_AGENDA_LEADER_LIME_TEO_OWL_LORD_OF_WEST',		'Strategies'),
		('LEADER_LIME_TEO_OWL_Alliances',				'TRAIT_AGENDA_LEADER_LIME_TEO_OWL_LORD_OF_WEST',		'Alliances'),
		('LEADER_LIME_TEO_OWL_Diplo',					'TRAIT_AGENDA_LEADER_LIME_TEO_OWL_LORD_OF_WEST',		'DiplomaticActions'),
		('LEADER_LIME_TEO_OWL_CBs',						'TRAIT_AGENDA_LEADER_LIME_TEO_OWL_LORD_OF_WEST',		'DiplomaticActions'),
		('LEADER_LIME_TEO_OWL_Discussions',				'TRAIT_AGENDA_LEADER_LIME_TEO_OWL_LORD_OF_WEST',		'Discussions'),
		('LEADER_LIME_TEO_OWL_Resolutions',				'TRAIT_AGENDA_LEADER_LIME_TEO_OWL_LORD_OF_WEST',		'Resolutions'),
		('LEADER_LIME_TEO_OWL_BuildSpecializations',	'TRAIT_AGENDA_LEADER_LIME_TEO_OWL_LORD_OF_WEST',		'AiBuildSpecializations'),
		('LEADER_LIME_TEO_OWL_PseudoYields',			'TRAIT_AGENDA_LEADER_LIME_TEO_OWL_LORD_OF_WEST',		'PseudoYields'),
		('LEADER_LIME_TEO_OWL_Yields',					'TRAIT_AGENDA_LEADER_LIME_TEO_OWL_LORD_OF_WEST',		'Yields'),
		('LEADER_LIME_TEO_OWL_Wonders',					'TRAIT_AGENDA_LEADER_LIME_TEO_OWL_LORD_OF_WEST',		'Buildings'),
		('LEADER_LIME_TEO_OWL_UnitPromoClasses',		'TRAIT_AGENDA_LEADER_LIME_TEO_OWL_LORD_OF_WEST',		'UnitPromotionClasses');

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
		(ListType,										Item,												StringVal,					Favored,	Value)
		-- Preferred Victories
VALUES	('LEADER_LIME_TEO_OWL_Victories',				'VICTORY_STRATEGY_MILITARY_VICTORY',				null,						1,			-2),
		('LEADER_LIME_TEO_OWL_Victories',				'VICTORY_STRATEGY_SCIENCE_VICTORY',					null,						1,			0),
		('LEADER_LIME_TEO_OWL_Victories',				'VICTORY_STRATEGY_RELIGIOUS_VICTORY',				null,						1,			-1),
		('LEADER_LIME_TEO_OWL_Victories',				'VICTORY_STRATEGY_DIPLOMATIC_VICTORY',				null,						1,			-2),
		('LEADER_LIME_TEO_OWL_Victories',				'VICTORY_STRATEGY_CULTURAL_VICTORY',				null,						1,			0),

		-- Preferred Alliances
		('LEADER_LIME_TEO_OWL_Alliances',				'ALLIANCE_CULTURAL',								null,						1,			-25),
		('LEADER_LIME_TEO_OWL_Alliances',				'ALLIANCE_ECONOMIC',								null,						1,			0),
		('LEADER_LIME_TEO_OWL_Alliances',				'ALLIANCE_MILITARY',								null,						1,			-25),
		('LEADER_LIME_TEO_OWL_Alliances',				'ALLIANCE_RELIGIOUS',								null,						1,			-25),
		('LEADER_LIME_TEO_OWL_Alliances',				'ALLIANCE_RESEARCH',								null,						1,			-25),

		-- Preferred Diplomatic Actions
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_ALLIANCE',								null,						1,			-50),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_ALLIANCE_CULTURAL',					null,						1,			-50),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_ALLIANCE_ECONOMIC',					null,						1,			-25),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_ALLIANCE_MILITARY',					null,						1,			-50),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_ALLIANCE_MILITARY_EMERGENCY',			null,						1,			-100),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_ALLIANCE_RELIGIOUS',					null,						1,			-50),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_ALLIANCE_RESEARCH',					null,						1,			-50),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_ALLIANCE_TEAMUP',						null,						1,			-200), -- He doesn't like teaming up with people
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_ALLIANCE_ECONOMIC',					null,						1,			-20),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_ALLIANCE_RELIGIOUS',					null,						1,			-50),
		
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_DEMAND_TRIBUTE',						null,						1,			50),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_DENOUNCE',								null,						1,			30),
		
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_KEEP_PROMISE_DONT_CONVERT',			null,						1,			-50),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_KEEP_PROMISE_DONT_DIG_ARTIFACTS',		null,						1,			-50),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_KEEP_PROMISE_DONT_SETTLE_TOO_NEAR',	null,						1,			-50),	--This guy is generally unfriendly
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_KEEP_PROMISE_DONT_SPY',				null,						1,			-50),
		
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_DIPLOMATIC_DELEGATION',				null,						1,			10),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_RESIDENT_EMBASSY',						null,						1,			10),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_RENEW_ALLIANCE',						null,						1,			20),	-- He warms up to you though
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_DECLARE_FRIENDSHIP',					null,						1,			-100),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_OPEN_BORDERS',							null,						1,			30),
		
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_LIBERATE_CITY',						null,						1,			-500),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_MILITARY_REQUEST',						null,						1,			-250),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_REQUEST_ASSISTANCE',					null,						1,			-250),	

		-- War Stuff
		('LEADER_LIME_TEO_OWL_CBs',						'DIPLOACTION_DECLARE_COLONIAL_WAR',					null,						1,			500),
		('LEADER_LIME_TEO_OWL_CBs',						'DIPLOACTION_DECLARE_FORMAL_WAR',					null,						1,			300),
		('LEADER_LIME_TEO_OWL_CBs',						'DIPLOACTION_DECLARE_GOLDEN_AGE_WAR',				null,						1,			500),
		('LEADER_LIME_TEO_OWL_CBs',						'DIPLOACTION_DECLARE_HOLY_WAR',						null,						1,			500),
		('LEADER_LIME_TEO_OWL_CBs',						'DIPLOACTION_DECLARE_IDEOLOGICAL_WAR',				null,						1,			200),
		('LEADER_LIME_TEO_OWL_CBs',						'DIPLOACTION_DECLARE_LIBERATION_WAR',				null,						1,			-300),
		('LEADER_LIME_TEO_OWL_CBs',						'DIPLOACTION_DECLARE_PROTECTORATE_WAR',				null,						1,			500),
		('LEADER_LIME_TEO_OWL_CBs',						'DIPLOACTION_DECLARE_RECONQUEST_WAR',				null,						1,			500),
		('LEADER_LIME_TEO_OWL_CBs',						'DIPLOACTION_DECLARE_SURPRISE_WAR',					null,						1,			500),
		('LEADER_LIME_TEO_OWL_CBs',						'DIPLOACTION_DECLARE_TERRITORIAL_WAR',				null,						1,			400),
		('LEADER_LIME_TEO_OWL_CBs',						'DIPLOACTION_DECLARE_WAR_MINOR_CIV',				null,						1,			500),
		('LEADER_LIME_TEO_OWL_CBs',						'DIPLOACTION_DECLARE_WAR_OF_RETRIBUTION',			null,						1,			500),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_PROPOSE_PEACE_DEAL',					null,						1,			-50),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_JOINT_WAR',							null,						1,			500),
		('LEADER_LIME_TEO_OWL_Diplo',					'DIPLOACTION_USE_NUCLEAR_WEAPON',					null,						1,			500),

		-- Preferred Discussions (Emergencies and Competitions... In this case I prefer putting a prefer		ence/dislike to all)
		('LEADER_LIME_TEO_OWL_Discussions',				'WC_EMERGENCY_MILITARY',							null,						1,			-30),
		('LEADER_LIME_TEO_OWL_Discussions',				'WC_EMERGENCY_CITY_STATE',							null,						1,			-30),
		('LEADER_LIME_TEO_OWL_Discussions',				'WC_EMERGENCY_RELIGIOUS',							null,						1,			-30),
		('LEADER_LIME_TEO_OWL_Discussions',				'WC_EMERGENCY_NUCLEAR',								null,						0,			-30),
		('LEADER_LIME_TEO_OWL_Discussions',				'WC_EMERGENCY_BACKSTAB',							null,						0,			-30),
		('LEADER_LIME_TEO_OWL_Discussions',				'WC_EMERGENCY_REQUEST_AID',							null,						0,			-30),
		('LEADER_LIME_TEO_OWL_Discussions',				'WC_EMERGENCY_NOBEL_PRIZE_LITERATURE',				null,						1,			-30),
		('LEADER_LIME_TEO_OWL_Discussions',				'WC_EMERGENCY_NOBEL_PRIZE_PEACE',					null,						0,			-30),
		('LEADER_LIME_TEO_OWL_Discussions',				'WC_EMERGENCY_NOBEL_PRIZE_PHYSICS',					null,						1,			-30),
		('LEADER_LIME_TEO_OWL_Discussions',				'WC_EMERGENCY_CLIMATE_ACCORDS',						null,						0,			-30),
		('LEADER_LIME_TEO_OWL_Discussions',				'WC_EMERGENCY_WORLD_GAMES',							null,						1,			-30),
		('LEADER_LIME_TEO_OWL_Discussions',				'WC_EMERGENCY_SPACE_STATION',						null,						1,			-30),
		('LEADER_LIME_TEO_OWL_Discussions',				'WC_EMERGENCY_WORLD_FAIR',							null,						1,			-30),

		-- Preferred Resolutions (In this case I also prefer putting a preference/dislike to all)
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_ARMS_CONTROL',								null,						1,			-100),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_BORDER_CONTROL',							null,						1,			-100),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_DEFORESTATION_TREATY',						null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_DIPLOVICTORY',								null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_ESPIONAGE_PACT',							null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_GLOBAL_ENERGY_TREATY',						null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_GOVERNANCE_DOCTRINE',						null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_HERITAGE_ORG',								null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_LUXURY',									null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_MERCENARY_COMPANIES',						null,						1,			100),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_MIGRATION_TREATY',							null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_MILITARY_ADVISORY',							null,						1,			100),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_PATRONAGE',									null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_POLICY_TREATY',								null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_PUBLIC_WORKS',								null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_SOVEREIGNTY',								null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_TRADE_TREATY',								null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_TREATY_ORGANIZATION',						null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_URBAN_DEVELOPMENT',							null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_WORLD_IDEOLOGY',							null,						1,			0),
		('LEADER_LIME_TEO_OWL_Resolutions',				'WC_RES_WORLD_RELIGION',							null,						1,			0),
		
		-- Build Specs
		('LEADER_LIME_TEO_OWL_BuildSpecializations',	'BUILD_CITY_DEFENSES',								null,						1,			300),
		('LEADER_LIME_TEO_OWL_BuildSpecializations',	'BUILD_FOR_CULTURE',								null,						1,			0),
		('LEADER_LIME_TEO_OWL_BuildSpecializations',	'BUILD_FOR_FAITH',									null,						1,			0),
		('LEADER_LIME_TEO_OWL_BuildSpecializations',	'BUILD_FOR_FOOD',									null,						1,			400),
		('LEADER_LIME_TEO_OWL_BuildSpecializations',	'BUILD_FOR_GOLD',									null,						1,			0),
		('LEADER_LIME_TEO_OWL_BuildSpecializations',	'BUILD_FOR_PRODUCTION',								null,						1,			400),
		('LEADER_LIME_TEO_OWL_BuildSpecializations',	'BUILD_FOR_SCIENCE',								null,						1,			0),
		('LEADER_LIME_TEO_OWL_BuildSpecializations',	'BUILD_MILITARY_UNITS',								null,						1,			500),
		('LEADER_LIME_TEO_OWL_BuildSpecializations',	'BUILD_TRADE_UNITS',								null,						1,			500),

		-- Preferred Pseudoyields
		('LEADER_LIME_TEO_OWL_PseudoYields',			'PSEUDOYIELD_GPP_GENERAL',							null,						1,			500),
		('LEADER_LIME_TEO_OWL_PseudoYields',			'PSEUDOYIELD_CITY_DEFENDING_UNITS',					null,						1,			200),
		('LEADER_LIME_TEO_OWL_PseudoYields',			'PSEUDOYIELD_GPP_PROPHET',							null,						1,			300),
		('LEADER_LIME_TEO_OWL_PseudoYields',			'PSEUDOYIELD_STANDING_ARMY_VALUE',					null,						1,			300),
		('LEADER_LIME_TEO_OWL_PseudoYields',			'PSEUDOYIELD_UNIT_COMBAT',							null,						1,			500),
		
		-- Preferred Yields
		('LEADER_LIME_TEO_OWL_Yields',					'YIELD_CULTURE',									null,						1,			300),
		('LEADER_LIME_TEO_OWL_Yields',					'YIELD_FAITH',										null,						1,			100),
		('LEADER_LIME_TEO_OWL_Yields',					'YIELD_FOOD',										null,						1,			400),
		('LEADER_LIME_TEO_OWL_Yields',					'YIELD_GOLD',										null,						1,			0),
		('LEADER_LIME_TEO_OWL_Yields',					'YIELD_PRODUCTION',									null,						1,			500),
		('LEADER_LIME_TEO_OWL_Yields',					'YIELD_SCIENCE',									null,						1,			200),

		-- Wonders (I'm gonna hardcode this bc I want him to really go for these wonders)
		('LEADER_LIME_TEO_OWL_Wonders',					'BUILDING_CHICHEN_ITZA',							null,						1,			100),

		-- Preferred Unit Promotion Classes
		('LEADER_LIME_TEO_OWL_UnitPromoClasses',		'PROMOTION_CLASS_MELEE',							null,						1,			0),
		('LEADER_LIME_TEO_OWL_UnitPromoClasses',		'PROMOTION_CLASS_RANGED',							null,						1,			0);

INSERT INTO LeaderTraits	-- Separated out so I can control specific leader biases
		(LeaderType,									TraitType)
VALUES	('LEADER_LIME_TEO_OWL',							'TRAIT_LEADER_AGGRESSIVE_MILITARY'),
		('LEADER_LIME_TEO_OWL',							'TRAIT_LEADER_EXPANSIONIST'),
		('LEADER_LIME_TEO_OWL',							'TRAIT_LEADER_RELIGIOUS_MAJOR_CIV');