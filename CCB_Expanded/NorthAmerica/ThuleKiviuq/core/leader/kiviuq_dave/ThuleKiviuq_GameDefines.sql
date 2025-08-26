--================================================================
-- Design ========================================================
--================================================================
-- LUA: Heart Not Yet Made of Stone
--			Every promotion a reconnaissance unit has increases
--			faith production by 5%. Reconnaissance units have +10 
--			combat strength on snow or tundra tiles and gain +1 
--			move when starting on those tiles. 
------------------------------------------------------------------
-- Agenda: Always Long to be Roaming
--			Likes civilizations who explore. 
--			Dislikes civilizations who don't.
------------------------------------------------------------------
-- Notes:
--		

--================================================================
-- TYPES =========================================================
--================================================================	
INSERT INTO Types	
		(Type,														Kind)
VALUES	('TRAIT_AGENDA_LIME_THULE_DAVE_ALWAYS_ROAMING',				'KIND_TRAIT'),
		('TRAIT_LEADER_LIME_THULE_DAVE_HEART_NOT_STONE',			'KIND_TRAIT'),
		('LEADER_LIME_THULE_DAVE',									'KIND_LEADER'),
		('ABIL_LIME_THULE_DAVE_BOREAL_RUGGEDNESS',					'KIND_ABILITY')/*,
		('ABIL_LIME_THULE_DAVE_ARCTIC_LORE',						'KIND_ABILITY')*/;
--================================================================
-- CIVILIZATIONS =================================================
--================================================================
-- CivilizationLeaders
------------------------------------------------------------------	
INSERT INTO CivilizationLeaders	
		(CivilizationType,			LeaderType,					CapitalName)
VALUES	('CIVILIZATION_LIME_THULE',	'LEADER_LIME_THULE_DAVE',	'LOC_CITY_NAME_LIME_THULE_DAVE_QILAKITSOQ');

--================================================================
-- LEADERS =======================================================
--================================================================
-- Leaders
------------------------------------------------------------------	
INSERT INTO Leaders	
		(LeaderType,				Name,								InheritFrom,		SceneLayers)
VALUES	('LEADER_LIME_THULE_DAVE',	'LOC_LEADER_LIME_THULE_DAVE_NAME',	'LEADER_DEFAULT',	4);	
------------------------------------------------------------------
-- LeaderQuotes
------------------------------------------------------------------	
INSERT INTO LeaderQuotes	
		(LeaderType,				Quote)
VALUES	('LEADER_LIME_THULE_DAVE',	'LOC_PEDIA_LEADERS_PAGE_LEADER_LIME_THULE_DAVE_QUOTE');	
------------------------------------------------------------------
-- HistoricalAgendas
------------------------------------------------------------------	
INSERT INTO HistoricalAgendas	
		(LeaderType,				AgendaType)
VALUES	('LEADER_LIME_THULE_DAVE',	'AGENDA_LIME_THULE_DAVE_ALWAYS_ROAMING'); -- @ Chimp | Changed from "LEADER_LEADER_LIME_THULE_DAVE"
------------------------------------------------------------------
-- AgendaPreferredLeaders
------------------------------------------------------------------	
INSERT INTO AgendaPreferredLeaders	
		(LeaderType,				AgendaType,				PercentageChance)
VALUES	('LEADER_LIME_THULE_DAVE',	'AGENDA_EXPLOITATIVE',	40), -- @ Chimp | Changed from 'AGENDA_PREFER_EXPLOITATION' (This is a trait type that doesn't exist in Agendas tables)
		('LEADER_LIME_THULE_DAVE',	'AGENDA_DEVOUT',		50); -- @ Chimp | Changed from 'AGENDA_PREFER_FAITH' (This is a trait type that doesn't exist in Agendas tables)
------------------------------------------------------------------
-- FavoredReligions
------------------------------------------------------------------	
INSERT OR REPLACE INTO FavoredReligions	
		(LeaderType,				ReligionType)
VALUES	('LEADER_LIME_THULE_DAVE',	'RELIGION_CATHOLICISM');

UPDATE FavoredReligions
	SET ReligionType = 'RELIGION_AGAKKUNNGURNIQ'
	WHERE LeaderType = 'LEADER_LIME_THULE_DAVE' 
	AND EXISTS (SELECT ReligionType FROM Religions WHERE ReligionType = 'RELIGION_AGAKKUNNGURNIQ');

CREATE TRIGGER Lime_Thule_Dave_FavoredReligions 
	AFTER INSERT ON Religions WHEN 'RELIGION_AGAKKUNNGURNIQ' = NEW.ReligionType 	
	BEGIN 
		INSERT OR REPLACE INTO FavoredReligions 
			(LeaderType, 		 	ReligionType) 
			VALUES 	('LEADER_LIME_THULE_DAVE',	'RELIGION_AGAKKUNNGURNIQ');
	END;

------------------------------------------------------------------
-- LoadingInfo
------------------------------------------------------------------	
INSERT INTO LoadingInfo	
		(LeaderType,				BackgroundImage, 				ForegroundImage,					PlayDawnOfManAudio)
VALUES	('LEADER_LIME_THULE_DAVE',	'LEADER_MONTEZUMA_BACKGROUND',	'LEADER_LIME_THULEDAVE_NEUTRAL',	0);	

-- Changed ForegroundImage from "LEADER_LIME_THULE_DAVE_NEUTRAL" as the texture in UILeaders.xlp does not have the underscore between THULE and DAVE ~ Chimp

--================================================================
-- LEADERS: AGENDAS ==============================================
--================================================================
-- Agendas			
------------------------------------------------------------------				
INSERT INTO Agendas				
		(AgendaType,								Name,												Description)
VALUES	('AGENDA_LIME_THULE_DAVE_ALWAYS_ROAMING',	'LOC_AGENDA_LIME_THULE_DAVE_ALWAYS_ROAMING_NAME',	'LOC_AGENDA_LIME_THULE_DAVE_ALWAYS_ROAMING_DESCRIPTION');	
------------------------------------------------------------------			
-- Traits			
------------------------------------------------------------------				
INSERT INTO Traits				
		(TraitType,										Name,												Description)
VALUES	('TRAIT_AGENDA_LIME_THULE_DAVE_ALWAYS_ROAMING',	'LOC_AGENDA_LIME_THULE_DAVE_ALWAYS_ROAMING_NAME',	'LOC_AGENDA_LIME_THULE_DAVE_ALWAYS_ROAMING_DESCRIPTION');	
------------------------------------------------------------------			
-- AgendaTraits			
------------------------------------------------------------------				
INSERT INTO AgendaTraits				
		(AgendaType,								TraitType)
VALUES	('AGENDA_LIME_THULE_DAVE_ALWAYS_ROAMING',	'TRAIT_AGENDA_LIME_THULE_DAVE_ALWAYS_ROAMING');	
------------------------------------------------------------------		
-- ExclusiveAgendas			
------------------------------------------------------------------			
INSERT INTO ExclusiveAgendas				
		(AgendaOne,									AgendaTwo)
VALUES	('AGENDA_LIME_THULE_DAVE_ALWAYS_ROAMING',	'AGENDA_EXPLORER');	-- @ Chimp | Changed from 'AGENDA_EXPLORATION_OBSESSED' (This is a trait type that doesn't exist in Agendas tables) 
------------------------------------------------------------------			
-- TraitModifiers						
------------------------------------------------------------------				
INSERT INTO TraitModifiers							
		(TraitType,										ModifierId)
VALUES	('TRAIT_AGENDA_LIME_THULE_DAVE_ALWAYS_ROAMING',	'LIME_THULE_DAVE_ALWAYS_ROAMING_EXPLORERPHILE_POSITIVE'),
		('TRAIT_AGENDA_LIME_THULE_DAVE_ALWAYS_ROAMING',	'LIME_THULE_DAVE_ALWAYS_ROAMING_EXPLORERPHILE_NEGATIVE');
------------------------------------------------------------------
-- Modifiers
------------------------------------------------------------------
INSERT INTO Modifiers	
		(ModifierId,												ModifierType,									SubjectRequirementSetId)
VALUES	('LIME_THULE_DAVE_ALWAYS_ROAMING_EXPLORERPHILE_POSITIVE',	'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',	'LIME_ALWAYS_ROAMING_LIKES_REQ_SET'),
		('LIME_THULE_DAVE_ALWAYS_ROAMING_EXPLORERPHILE_NEGATIVE',	'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',	'LIME_ALWAYS_ROAMING_DISLIKES_REQ_SET');
------------------------------------------------------------------
-- ModifierArguments
------------------------------------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,												Name,							Value,																				Type)
VALUES	('LIME_THULE_DAVE_ALWAYS_ROAMING_EXPLORERPHILE_POSITIVE',	'InitialValue',					10,																					'ARGTYPE_IDENTITY'),
		('LIME_THULE_DAVE_ALWAYS_ROAMING_EXPLORERPHILE_POSITIVE',	'StatementKey',					'LOC_DIPLO_KUDOS_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING_EXPLORERPHILE_POSITIVE',		'ARGTYPE_IDENTITY'),
		('LIME_THULE_DAVE_ALWAYS_ROAMING_EXPLORERPHILE_POSITIVE',	'SimpleModifierDescription',	'LOC_DIPLO_MODIFIER_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING_EXPLORERPHILE_POSITIVE',	'ARGTYPE_IDENTITY'),
		('LIME_THULE_DAVE_ALWAYS_ROAMING_EXPLORERPHILE_NEGATIVE',	'InitialValue',					-10,																				'ARGTYPE_IDENTITY'),
		('LIME_THULE_DAVE_ALWAYS_ROAMING_EXPLORERPHILE_NEGATIVE',	'StatementKey',					'LOC_DIPLO_WARNING_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING_EXPLORERPHILE_NEGATIVE',	'ARGTYPE_IDENTITY'),
		('LIME_THULE_DAVE_ALWAYS_ROAMING_EXPLORERPHILE_NEGATIVE',	'SimpleModifierDescription',	'LOC_DIPLO_MODIFIER_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING_EXPLORERPHILE_NEGATIVE',	'ARGTYPE_IDENTITY');
------------------------------------------------------------------
-- Requirements
------------------------------------------------------------------   
INSERT INTO Requirements             
    	(RequirementId,                      	RequirementType,						Inverse)
VALUES  ('LIME_ALWAYS_ROAMING_LIKES_REQ',		'REQUIREMENT_PLAYER_EXPLORATION_LEAD',	0),
		('LIME_ALWAYS_ROAMING_DISLIKES_REQ',	'REQUIREMENT_PLAYER_EXPLORATION_LEAD',	1);
------------------------------------------------------------------
-- RequirementSets
------------------------------------------------------------------
INSERT INTO RequirementSets
	  	(RequirementSetId,                    		RequirementSetType)
VALUES  ('LIME_ALWAYS_ROAMING_LIKES_REQ_SET',		'REQUIREMENTSET_TEST_ANY'),
		('LIME_ALWAYS_ROAMING_DISLIKES_REQ_SET',	'REQUIREMENTSET_TEST_ANY');
------------------------------------------------------------------
-- RequirementSetRequirements
------------------------------------------------------------------
INSERT INTO RequirementSetRequirements
		(RequirementSetId,                    		RequirementId)
VALUES  ('LIME_ALWAYS_ROAMING_LIKES_REQ_SET',		'LIME_ALWAYS_ROAMING_LIKES_REQ'),
		('LIME_ALWAYS_ROAMING_DISLIKES_REQ_SET',	'LIME_ALWAYS_ROAMING_DISLIKES_REQ');

--================================================================
-- LEADERS: TRAITS ===============================================
--================================================================
INSERT INTO LeaderTraits
		(LeaderType,										TraitType)
VALUES	('LEADER_LIME_THULE_DAVE',							'TRAIT_LEADER_LIME_THULE_DAVE_HEART_NOT_STONE');
-----------------------------------------------
-- Traits
-----------------------------------------------
INSERT INTO Traits				
		(TraitType,											Name,														Description)
VALUES	('TRAIT_LEADER_LIME_THULE_DAVE_HEART_NOT_STONE',	'LOC_TRAIT_LEADER_LIME_THULE_DAVE_HEART_NOT_STONE_NAME',	'LOC_TRAIT_LEADER_LIME_THULE_DAVE_HEART_NOT_STONE_DESCRIPTION');
-----------------------------------------------
-- Trait Modifiers
-----------------------------------------------
INSERT INTO TraitModifiers
		(TraitType,											ModifierId)
VALUES	('TRAIT_LEADER_LIME_THULE_DAVE_HEART_NOT_STONE',	'LIME_THULE_DAVE_RECON_BUFF_ABIL')/*,
		('TRAIT_LEADER_LIME_THULE_DAVE_HEART_NOT_STONE',	'LIME_THULE_DAVE_RECON_FAITH_ABIL')*/;
-----------------------------------------------		
-- Modifiers
-----------------------------------------------
INSERT INTO Modifiers
		(ModifierId,										ModifierType,											SubjectRequirementSetId,							OwnerRequirementSetId)
VALUES	('LIME_THULE_DAVE_RECON_BUFF_ABIL',					'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',					NULL,												NULL)/*,
		('LIME_THULE_DAVE_RECON_FAITH_ABIL',				'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',					NULL,												NULL)*/;
-----------------------------------------------		
-- Modifier Arguments
-----------------------------------------------
INSERT INTO ModifierArguments -- Ability
		(ModifierId,										Name,													Value)
VALUES	('LIME_THULE_DAVE_RECON_BUFF_ABIL',					'AbilityType',											'ABIL_LIME_THULE_DAVE_BOREAL_RUGGEDNESS')/*,
		('LIME_THULE_DAVE_RECON_FAITH_ABIL',				'AbilityType',											'ABIL_LIME_THULE_DAVE_ARCTIC_LORE')*/;
--/*
INSERT INTO TypeTags
		(Type,												Tag)
VALUES	('ABIL_LIME_THULE_DAVE_BOREAL_RUGGEDNESS',			'CLASS_RECON')/*,
		('ABIL_LIME_THULE_DAVE_ARCTIC_LORE',				'CLASS_RECON')*/;
--*/

INSERT INTO UnitAbilities
		(UnitAbilityType,									Name,													Description,										Inactive)
VALUES	('ABIL_LIME_THULE_DAVE_BOREAL_RUGGEDNESS',			'LOC_ABIL_LIME_THULE_DAVE_BOREAL_RUGGEDNESS_NAME',		'LOC_ABIL_LIME_THULE_DAVE_BOREAL_RUGGEDNESS_DESC',	1)/*,
		('ABIL_LIME_THULE_DAVE_ARCTIC_LORE',				NULL,													NULL,												0)*/;

INSERT INTO UnitAbilityModifiers
		(UnitAbilityType,									ModifierId)
VALUES	('ABIL_LIME_THULE_DAVE_BOREAL_RUGGEDNESS',			'LIME_RECON_STRONG'),
		('ABIL_LIME_THULE_DAVE_BOREAL_RUGGEDNESS',			'LIME_RECON_FAST')/*,
		('ABIL_LIME_THULE_DAVE_ARCTIC_LORE',				'LIME_RECON_FAITH_BOOST')*/;

INSERT INTO Modifiers
		(ModifierId,										ModifierType,											SubjectRequirementSetId,							OwnerRequirementSetId)
VALUES	('LIME_RECON_STRONG',								'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',					'REQSET_LIME_THULE_DAVE_UNIT_IS_COLD',				NULL),
		('LIME_RECON_FAST',									'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',					'REQSET_LIME_THULE_DAVE_UNIT_IS_COLD',				NULL)/*,
		('LIME_RECON_FAITH_BOOST',							'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	NULL,												'REQSET_LIME_THULE_DAVE_UNIT_IS_PROMOTED')*/;

INSERT INTO ModifierArguments
		(ModifierId,										Name,													Value)
VALUES	('LIME_RECON_STRONG',								'Amount',												10),
		('LIME_RECON_FAST',									'Amount',												1)/*,
		('LIME_RECON_FAITH_BOOST',							'YieldType',											'YIELD_FAITH'),
		('LIME_RECON_FAITH_BOOST',							'Amount',												100)*/;
-----------------------------------------------		
-- Modifier Strings
-----------------------------------------------
INSERT INTO ModifierStrings
		(ModifierId,										Context,												Text)
VALUES	('LIME_RECON_STRONG',								'Preview',												'LOC_ABILITY_LIME_HEART_NOT_STONE_BONUS');		
-----------------------------------------------		
-- Requirement Sets
-----------------------------------------------
INSERT INTO RequirementSets -- Trait
		(RequirementSetId,									RequirementSetType)
VALUES	('REQSET_LIME_THULE_DAVE_UNIT_IS_COLD',				'REQUIREMENTSET_TEST_ANY')/*,
		('REQSET_LIME_THULE_DAVE_UNIT_IS_PROMOTED',			'REQUIREMENTSET_TEST_ANY')*/;
-----------------------------------------------
-- Requirement Set Requirements
-----------------------------------------------
INSERT INTO RequirementSetRequirements -- Trait
		(RequirementSetId,									RequirementId)
VALUES	('REQSET_LIME_THULE_DAVE_UNIT_IS_COLD',				'REQ_LIME_THULE_DAVE_TUNDRA'),
		('REQSET_LIME_THULE_DAVE_UNIT_IS_COLD',				'REQ_LIME_THULE_DAVE_TUNDRA_HILLS'),
		('REQSET_LIME_THULE_DAVE_UNIT_IS_COLD',				'REQ_LIME_THULE_DAVE_SNOW'),
		('REQSET_LIME_THULE_DAVE_UNIT_IS_COLD',				'REQ_LIME_THULE_DAVE_SNOW_HILLS')/*,

		('REQSET_LIME_THULE_DAVE_UNIT_IS_PROMOTED',			'REQ_LIME_THULE_DAVE_UNIT_HAS_ALPINE'),
		('REQSET_LIME_THULE_DAVE_UNIT_IS_PROMOTED',			'REQ_LIME_THULE_DAVE_UNIT_HAS_RANGER')*/;
-----------------------------------------------
-- Requirements
-----------------------------------------------
INSERT INTO Requirements -- Trait
		(RequirementId,										RequirementType,										Inverse)
VALUES	('REQ_LIME_THULE_DAVE_TUNDRA',						'REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES',				0),
		('REQ_LIME_THULE_DAVE_TUNDRA_HILLS',				'REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES',				0),
		('REQ_LIME_THULE_DAVE_SNOW',						'REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES',				0),
		('REQ_LIME_THULE_DAVE_SNOW_HILLS',					'REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES',				0)/*,
	
		('REQ_LIME_THULE_DAVE_UNIT_HAS_ALPINE',				'REQUIREMENT_UNIT_HAS_PROMOTION',						0),
		('REQ_LIME_THULE_DAVE_UNIT_HAS_RANGER',				'REQUIREMENT_UNIT_HAS_PROMOTION',						0)*/;
-----------------------------------------------
-- Requirement Arguments
-----------------------------------------------
INSERT INTO RequirementArguments -- Trait
		(RequirementId,										Name,													Value)
VALUES	('REQ_LIME_THULE_DAVE_TUNDRA',						'TerrainType',											'TERRAIN_TUNDRA'),
		('REQ_LIME_THULE_DAVE_TUNDRA_HILLS',				'TerrainType',											'TERRAIN_TUNDRA_HILLS'),
		('REQ_LIME_THULE_DAVE_SNOW',						'TerrainType',											'TERRAIN_SNOW'),
		('REQ_LIME_THULE_DAVE_SNOW_HILLS',					'TerrainType',											'TERRAIN_SNOW_HILLS');

----------------TO BE DELETED ONCE REQUIREMENT-UNIT_HAS_PROMOTION IS WORKING
-----------------------------------------------
-- Unit Promotion Modifiers
-----------------------------------------------
INSERT INTO UnitPromotionModifiers
		(UnitPromotionType,								ModifierId)
VALUES	('PROMOTION_ALPINE',							'LIME_RECON_FAITH'),
		('PROMOTION_RANGER',							'LIME_RECON_FAITH');
-----------------------------------------------		
-- Modifiers
-----------------------------------------------
INSERT INTO Modifiers	
		(ModifierId,									ModifierType,											SubjectRequirementSetId)
VALUES	('LIME_RECON_FAITH',							'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	'REQSET_LIME_THULE_LEADER_IS_KIVIUQ');
-----------------------------------------------		
-- Modifier Arguments
-----------------------------------------------
INSERT INTO ModifierArguments -- Ability
		(ModifierId,									Name,						Value)
VALUES	('LIME_RECON_FAITH',							'YieldType',				'YIELD_FAITH'),
		('LIME_RECON_FAITH',							'Amount',					10);

INSERT INTO RequirementSets -- Trait
		(RequirementSetId,								RequirementSetType)
VALUES	('REQSET_LIME_THULE_LEADER_IS_KIVIUQ',			'REQUIREMENTSET_TEST_ANY');

INSERT INTO RequirementSetRequirements -- Trait
		(RequirementSetId,								RequirementId)
VALUES	('REQSET_LIME_THULE_LEADER_IS_KIVIUQ',			'REQ_LIME_LEADER_IS_DAVE');

INSERT INTO Requirements -- Trait
		(RequirementId,									RequirementType,							Inverse)
VALUES	('REQ_LIME_LEADER_IS_DAVE',						'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES',	0);

INSERT INTO RequirementArguments -- Trait
		(RequirementId,									Name,						Value)
VALUES	('REQ_LIME_LEADER_IS_DAVE',						'LeaderType',				'LEADER_LIME_THULE_DAVE');
------------------------FUCK U FIRAXIS

--================================================================
-- AI shit =======================================================
--================================================================
-- Forced Traits:
-------------------
INSERT INTO LeaderTraits
		(LeaderType,					TraitType)
VALUES	('LEADER_LIME_THULE_DAVE',		'TRAIT_LEADER_RELIGIOUS_MAJOR_CIV'),
		('LEADER_LIME_THULE_DAVE',		'TRAIT_LEADER_CULTURAL_MAJOR_CIV');
-------------------------------------
-- AiListTypes
-------------------------------------
INSERT INTO AiListTypes	
		(ListType)
VALUES	('LEADER_LIME_THULE_DAVE_Victories'),			
		('LEADER_LIME_THULE_DAVE_Scouting'),
		('LEADER_LIME_THULE_DAVE_Tactics'),						
		('LEADER_LIME_THULE_DAVE_BuildSpecializations'),	
		('LEADER_LIME_THULE_DAVE_Colonization'),			
		('LEADER_LIME_THULE_DAVE_Diplo'),				
		('LEADER_LIME_THULE_DAVE_PseudoYields'),			
		('LEADER_LIME_THULE_DAVE_Yields'),				
		('LEADER_LIME_THULE_DAVE_Alliances'),		
		('LEADER_LIME_THULE_DAVE_Discussions'),		
		('LEADER_LIME_THULE_DAVE_Resolutions'),			
		('LEADER_LIME_THULE_DAVE_Wonders'),	
		('LEADER_LIME_THULE_DAVE_UnitPromoClasses');

INSERT INTO AiLists	
		(ListType,											LeaderType,												System)
VALUES	('LEADER_LIME_THULE_DAVE_Victories',				'TRAIT_AGENDA_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING',	'Strategies'),
		('LEADER_LIME_THULE_DAVE_Scouting',					'TRAIT_AGENDA_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING',	'AiScoutUses'),
		('LEADER_LIME_THULE_DAVE_Tactics',					'TRAIT_AGENDA_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING',	'Tactics'),
		('LEADER_LIME_THULE_DAVE_BuildSpecializations',		'TRAIT_AGENDA_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING',	'AiBuildSpecializations'),
		('LEADER_LIME_THULE_DAVE_Colonization',				'TRAIT_AGENDA_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING',	'PlotEvaluations'),
		('LEADER_LIME_THULE_DAVE_Diplo',					'TRAIT_AGENDA_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING',	'DiplomaticActions'),
		('LEADER_LIME_THULE_DAVE_PseudoYields',				'TRAIT_AGENDA_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING',	'PseudoYields'),
		('LEADER_LIME_THULE_DAVE_Yields',					'TRAIT_AGENDA_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING',	'Yields'),
		('LEADER_LIME_THULE_DAVE_Alliances',				'TRAIT_AGENDA_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING',	'Alliances'),
		('LEADER_LIME_THULE_DAVE_Discussions',				'TRAIT_AGENDA_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING',	'Discussions'),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'TRAIT_AGENDA_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING',	'Resolutions'),
		('LEADER_LIME_THULE_DAVE_Wonders',					'TRAIT_AGENDA_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING',	'Wonders'),
		('LEADER_LIME_THULE_DAVE_UnitPromoClasses',			'TRAIT_AGENDA_LEADER_LIME_THULE_DAVE_ALWAYS_ROAMING',	'UnitPromotionClasses');

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
		(ListType,											Item,									StringVal,					Favored,	Value)
		-- Preferred Victories
VALUES	('LEADER_LIME_THULE_DAVE_Victories',				'VICTORY_STRATEGY_RELIGIOUS_VICTORY',	null,						1,			-1),
		('LEADER_LIME_THULE_DAVE_Victories',				'VICTORY_STRATEGY_CULTURAL_VICTORY',	null,						1,			-2),
		('LEADER_LIME_THULE_DAVE_Victories',				'VICTORY_STRATEGY_SCIENCE_VICTORY',		null,						1,			-1),
		('LEADER_LIME_THULE_DAVE_Victories',				'VICTORY_STRATEGY_MILITARY_VICTORY',	null,						1,			3),
		('LEADER_LIME_THULE_DAVE_Victories',				'VICTORY_STRATEGY_DIPLOMATIC_VICTORY',	null,						1,			1),

		-- scouting, special for Dave																
		('LEADER_LIME_THULE_DAVE_Scouting',					'DEFAULT_LAND_SCOUTS',					null,						1,			300),
		('LEADER_LIME_THULE_DAVE_Scouting',					'LAND_SCOUTS_PER_PRIMARY_REGION',		null,						1,			200),
		('LEADER_LIME_THULE_DAVE_Scouting',					'LAND_SCOUTS_PER_SECONDARY_REGION',		null,						1,			200),
		('LEADER_LIME_THULE_DAVE_Scouting',					'NAVAL_SCOUTS_FOR_WORLD_EXPLORATION',	null,						1,			500),
		('LEADER_LIME_THULE_DAVE_Tactics',					'Wander',								null,						1,			1000),

		-- Build Specs
		('LEADER_LIME_THULE_DAVE_BuildSpecializations',		'BUILD_FOR_FOOD',						null,						1,			33),
		('LEADER_LIME_THULE_DAVE_BuildSpecializations',		'BUILD_FOR_PRODUCTION',					null,						1,			33),
		('LEADER_LIME_THULE_DAVE_BuildSpecializations',		'BUILD_FOR_FAITH',						null,						1,			50),
		('LEADER_LIME_THULE_DAVE_BuildSpecializations',		'BUILD_FOR_CULTURE',					null,						1,			66),
		('LEADER_LIME_THULE_DAVE_BuildSpecializations',		'BUILD_FOR_SCIENCE',					null,						1,			44),
		('LEADER_LIME_THULE_DAVE_BuildSpecializations',		'BUILD_FOR_GOLD',						null,						1,			0),
		('LEADER_LIME_THULE_DAVE_BuildSpecializations',		'BUILD_CITY_DEFENSES',					null,						1,			0),
		('LEADER_LIME_THULE_DAVE_BuildSpecializations',		'BUILD_MILITARY_UNITS',					null,						1,			0),
		('LEADER_LIME_THULE_DAVE_BuildSpecializations',		'BUILD_TRADE_UNITS',					null,						1,			0),
		
		-- Preferred Settling
		('LEADER_LIME_THULE_DAVE_Colonization',				'Coastal',								null,						1,			100),
		('LEADER_LIME_THULE_DAVE_Colonization',				'Specific Feature',						'FEATURE_ICE',				1,			50),
		
		-- Preferred Diplomatic Actions
		('LEADER_LIME_THULE_DAVE_Diplo',					'DIPLOACTION_OPEN_BORDERS',				null,						1,			300),
		('LEADER_LIME_THULE_DAVE_Diplo',					'DIPLOACTION_DECLARE_JOINT_WAR',		null,						1,			50),
		('LEADER_LIME_THULE_DAVE_Diplo',					'DIPLOACTION_PROPOSE_PEACE_DEAL',		null,						1,			33),
		('LEADER_LIME_THULE_DAVE_Diplo',					'DIPLOACTION_KEEP_PROMISE_DONT_SETTLE_TOO_NEAR',		null,		1,			-100),
		('LEADER_LIME_THULE_DAVE_Diplo',					'DIPLOACTION_LIBERATE_CITY',			null,						1,			100),

		-- Preferred Pseudoyields
		('LEADER_LIME_THULE_DAVE_PseudoYields',				'PSEUDOYIELD_UNIT_EXPLORER',			null,						1,			300),
		('LEADER_LIME_THULE_DAVE_PseudoYields',				'PSEUDOYIELD_TOURISM',					null,						1,			200),
		('LEADER_LIME_THULE_DAVE_PseudoYields',				'PSEUDOYIELD_GREATWORK_RELIC',			null,						1,			100),
		('LEADER_LIME_THULE_DAVE_PseudoYields',				'PSEUDOYIELD_SPACE_RACE',				null,						1,			300),

		-- Preferred Alliances
		('LEADER_LIME_THULE_DAVE_Alliances',				'ALLIANCE_CULTURAL',					null,						1,			50),
		('LEADER_LIME_THULE_DAVE_Alliances',				'ALLIANCE_MILITARY',					null,						1,			50),
		('LEADER_LIME_THULE_DAVE_Alliances',				'ALLIANCE_RELIGIOUS',					null,						1,			50),

		-- Preferred Discussions (Emergencies and Competitions... In this case I prefer putting a preference/dislike to all)
		('LEADER_LIME_THULE_DAVE_Discussions',				'WC_EMERGENCY_MILITARY',				null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Discussions',				'WC_EMERGENCY_CITY_STATE',				null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Discussions',				'WC_EMERGENCY_RELIGIOUS',				null,						1,			20),
		('LEADER_LIME_THULE_DAVE_Discussions',				'WC_EMERGENCY_NUCLEAR',					null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Discussions',				'WC_EMERGENCY_BACKSTAB',				null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Discussions',				'WC_EMERGENCY_REQUEST_AID',				null,						1,			20),
		('LEADER_LIME_THULE_DAVE_Discussions',				'WC_EMERGENCY_NOBEL_PRIZE_LITERATURE',	null,						1,			20),
		('LEADER_LIME_THULE_DAVE_Discussions',				'WC_EMERGENCY_NOBEL_PRIZE_PEACE',		null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Discussions',				'WC_EMERGENCY_NOBEL_PRIZE_PHYSICS',		null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Discussions',				'WC_EMERGENCY_CLIMATE_ACCORDS',			null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Discussions',				'WC_EMERGENCY_WORLD_GAMES',				null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Discussions',				'WC_EMERGENCY_SPACE_STATION',			null,						1,			50),
		('LEADER_LIME_THULE_DAVE_Discussions',				'WC_EMERGENCY_WORLD_FAIR',				null,						1,			0),

		-- Preferred Resolutions (In this case I also prefer putting a preference/dislike to all)
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_ARMS_CONTROL',					null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_BORDER_CONTROL',				null,						0,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_DEFORESTATION_TREATY',			null,						0,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_DIPLOVICTORY',					null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_GLOBAL_ENERGY_TREATY',			null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_GOVERNANCE_DOCTRINE',			null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_HERITAGE_ORG',					null,						0,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_LUXURY',						null,						1,			500),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_MERCENARY_COMPANIES',			null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_MIGRATION_TREATY',				null,						0,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_PATRONAGE',						null,						0,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_POLICY_TREATY',					null,						0,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_PUBLIC_WORKS',					null,						0,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_SOVEREIGNTY',					null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_TRADE_TREATY',					null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_TREATY_ORGANIZATION',			null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_URBAN_DEVELOPMENT',				null,						1,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_WORLD_IDEOLOGY',				null,						0,			0),
		('LEADER_LIME_THULE_DAVE_Resolutions',				'WC_RES_WORLD_RELIGION',				null,						1,			0),

		-- Wonders (I'm gonna hardcode this bc I want him to really go for these wonders)
		('LEADER_LIME_THULE_DAVE_Wonders',					'BUILDING_AMUNDSEN_SCOTT_RESEARCH_STATION',			null,			1,			300),
		('LEADER_LIME_THULE_DAVE_Wonders',					'BUILDING_GOLDEN_GATE_BRIDGE',			null,						1,			500),
		('LEADER_LIME_THULE_DAVE_Wonders',					'BUILDING_HALICARNASSUS_MAUSOLEUM',		null,						1,			500),
		('LEADER_LIME_THULE_DAVE_Wonders',					'BUILDING_ST_BASILS_CATHEDRAL',			null,						1,			500),
		('LEADER_LIME_THULE_DAVE_Wonders',					'BUILDING_MONT_ST_MICHEL',				null,						1,			300),

		-- Preferred Unit Promotion Classes
		('LEADER_LIME_THULE_DAVE_UnitPromoClasses',			'PROMOTION_CLASS_RECON',				null,						1,			9999999);


INSERT INTO AiFavoredItems		
		(ListType,										Item,					StringVal,					Favored,	Value)
SELECT	'LEADER_LIME_THULE_DAVE_Colonization',			'Specific Resource',	ResourceType,				1,			50
FROM Resource_ValidTerrains
	WHERE TerrainType = 'TERRAIN_COAST';

UPDATE AiFavoredItems
SET Value = 9999999
WHERE ListType = 'LEADER_LIME_THULE_DAVE_Colonization' AND StringVal = 'RESOURCE_WHALES';