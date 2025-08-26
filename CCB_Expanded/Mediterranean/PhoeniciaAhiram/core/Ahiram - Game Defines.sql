--======================================================================================
--	  PORT LIME			================================================================
--	AHIRAM OF BYBLOS	================================================================
--======================================================================================
-- Date Created: 8/19/2019 06:36:31
----------------------------------------------------------------------------------------
-- --  LUA: Merchant Princes
--			Purchasing buildings with gold generates a burst of Great Merchant points. 
--			Unlock the Shaft Tomb unique building.
--
----------------------------------------------------------------------------------------
-- --  LUB: Shaft Tomb
--			Replaces the library. Generates as much gold equivalent to the district's 
--			adjacency. +1 science for each Great Merchant earnt by this civilization.
--
----------------------------------------------------------------------------------------
--  Agenda: Come Here and Be Humbled
--			Dislikes Warmongers, but likes those who send trade routes to him.
--
----------------------------------------------------------------------------------------
--  Notes:
--			this is really simple and I dig it
--			also don't ask why I'm up this early, idk either
--
--			Also, big credits to JFD and Leugi who helped me hammer out the design. 
--			
--			Great Merchant Points will be equal to cost*(gamespeed modifier)/2000
--			Now let's go gettum!
--
--======================================================================================

--======================================================================================
-- Types ===============================================================================
--======================================================================================
INSERT INTO Types
		(Type,												Kind)
VALUES	('LEADER_LIME_PHOE_AHIRAM',							'KIND_LEADER'),
		-----------------------------------------------
		('TRAIT_LEADER_LIME_PHOE_AHIRAM_MERCHANT_PRINCES',	'KIND_TRAIT'),
		-----------------------------------------------
		('TRAIT_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB',		'KIND_TRAIT'),
		('LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB',			'KIND_BUILDING'),
		-----------------------------------------------
		('TRAIT_AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED',		'KIND_TRAIT');		-- This always makes me think of 'Be Prepared' from the Lion King

--======================================================================================
-- Civilization Leaders and stuff ======================================================
--======================================================================================
-- Civilization Leaders
INSERT INTO CivilizationLeaders
		(CivilizationType,			LeaderType,						CapitalName)
VALUES	('CIVILIZATION_PHOENICIA',	'LEADER_LIME_PHOE_AHIRAM',		'LOC_CITY_NAME_BYBLOS');

-- Leaders
INSERT INTO Leaders
		(LeaderType,					Name,									InheritFrom,		SceneLayers)
VALUES	('LEADER_LIME_PHOE_AHIRAM',		'LOC_LEADER_LIME_PHOE_AHIRAM_NAME',		'LEADER_DEFAULT',	4);

-- Leader Quotes
INSERT INTO LeaderQuotes
		(LeaderType,					Quote)
VALUES	('LEADER_LIME_PHOE_AHIRAM',		'LOC_PEDIA_LEADERS_PAGE_LEADER_LIME_PHOE_AHIRAM_QUOTE');

-- Loading Info
INSERT INTO LoadingInfo
		(LeaderType,					BackgroundImage,			ForegroundImage,					PlayDawnOfManAudio)
VALUES	('LEADER_LIME_PHOE_AHIRAM',		'LEADER_DIDO_BACKGROUND',	'LEADER_LIME_PHOE_AHIRAM_NEUTRAL',	0);

INSERT INTO FavoredReligions
		(LeaderType,					ReligionType)
VALUES	('LEADER_LIME_PHOE_AHIRAM',		'RELIGION_JUDAISM');

UPDATE FavoredReligions
	SET ReligionType = 'RELIGION_CNAANISM'
	WHERE LeaderType = 'LEADER_LIME_PHOE_AHIRAM' 
	AND EXISTS (SELECT ReligionType FROM Religions WHERE ReligionType = 'RELIGION_CNAANISM');

CREATE TRIGGER Lime_Phoe_Ahiram_FavoredReligions 
	AFTER INSERT ON Religions WHEN 'RELIGION_CNAANISM' = NEW.ReligionType 	
	BEGIN 
		INSERT OR REPLACE INTO FavoredReligions 
			(LeaderType, 		 				ReligionType) 
			VALUES 	('LEADER_LIME_PHOE_AHIRAM',	'RELIGION_CNAANISM');
	END;


--======================================================================================
-- Leader Traits =======================================================================
--======================================================================================
-- It's all lua!
INSERT INTO LeaderTraits
		(LeaderType,					TraitType)
VALUES	('LEADER_LIME_PHOE_AHIRAM',		'TRAIT_LEADER_LIME_PHOE_AHIRAM_MERCHANT_PRINCES');

-- Traits
INSERT INTO Traits
		(TraitType,												Name,															Description)
VALUES	('TRAIT_LEADER_LIME_PHOE_AHIRAM_MERCHANT_PRINCES',		'LOC_TRAIT_LEADER_LIME_PHOE_AHIRAM_MERCHANT_PRINCES_NAME',		'LOC_TRAIT_LEADER_LIME_PHOE_AHIRAM_MERCHANT_PRINCES_DESCRIPTION');

/*-- Trait Modifiers
INSERT INTO TraitModifiers
		(TraitType,												ModifierId)
VALUES	('TRAIT_LEADER_LIME_PHOE_AHIRAM_MERCHANT_PRINCES',		'LIME_MOD_DOES_NOTHING');	-- hurr durr lime ur mod does nothing
																							-- that's bc it's shit
INSERT INTO Modifiers																		-- :larfingtibs:
		(ModifierId,											ModifierType)
VALUES	('LIME_MOD_DOES_NOTHING',								'MODIFIER_ALLIANCE_DO_NOTHING');*/

--======================================================================================
-- Leader Buildings ====================================================================
--======================================================================================
-- --  LUB: Royal Tomb
--			Replaces the library. Generates as much gold equivalent to the district's 
--			adjacency. +1 science for each Great Merchant earnt by this civilization.
--======================================================================================
INSERT INTO LeaderTraits
		(LeaderType,					TraitType)
VALUES	('LEADER_LIME_PHOE_AHIRAM',		'TRAIT_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB');

INSERT INTO TraitModifiers
		(TraitType,												ModifierId)
VALUES	('TRAIT_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB',			'MOD_LIME_ATTACH_TOMB_SCIENCE_BUFF');

INSERT INTO Traits
		(TraitType,												Name,															Description)
VALUES	('TRAIT_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB',			NULL,															NULL);

INSERT INTO Buildings
		(BuildingType,								Name,												PrereqTech,	PrereqCivic,	Cost,	MaxPlayerInstances,	MaxWorldInstances,	Capital,	PrereqDistrict,	AdjacentDistrict,	Description,												RequiresPlacement,	RequiresRiver,	OuterDefenseHitPoints,	Housing,	Entertainment,	AdjacentResource,	Coast,	EnabledByReligion,	AllowsHolyCity,	PurchaseYield,	MustPurchase,	Maintenance,	IsWonder,	TraitType,										OuterDefenseStrength,	CitizenSlots,	MustBeLake,	MustNotBeLake,	RegionalRange,	AdjacentToMountain,	ObsoleteEra,	RequiresReligion,	GrantFortification,	DefenseModifier,	InternalOnly,	RequiresAdjacentRiver,	Quote,	QuoteAudio,	MustBeAdjacentLand,	AdvisorType,	AdjacentCapital,	AdjacentImprovement,	CityAdjacentTerrain,	UnlocksGovernmentPolicy,	GovernmentTierRequirement)
SELECT	'LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB',	'LOC_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB_NAME',	PrereqTech,	PrereqCivic,	Cost,	MaxPlayerInstances,	MaxWorldInstances,	Capital,	PrereqDistrict,	AdjacentDistrict,	'LOC_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB_DESCRIPTION',	RequiresPlacement,	RequiresRiver,	OuterDefenseHitPoints,	Housing,	Entertainment,	AdjacentResource,	Coast,	EnabledByReligion,	AllowsHolyCity,	PurchaseYield,	MustPurchase,	Maintenance,	IsWonder,	'TRAIT_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB',	OuterDefenseStrength,	CitizenSlots,	MustBeLake,	MustNotBeLake,	RegionalRange,	AdjacentToMountain,	ObsoleteEra,	RequiresReligion,	GrantFortification,	DefenseModifier,	InternalOnly,	RequiresAdjacentRiver,	Quote,	QuoteAudio,	MustBeAdjacentLand,	AdvisorType,	AdjacentCapital,	AdjacentImprovement,	CityAdjacentTerrain,	UnlocksGovernmentPolicy,	GovernmentTierRequirement
FROM Buildings
	WHERE BuildingType = 'BUILDING_LIBRARY';

INSERT INTO Building_GreatPersonPoints
		(BuildingType,								GreatPersonClassType,	PointsPerTurn)
SELECT	'LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB',	GreatPersonClassType,	PointsPerTurn
FROM Building_GreatPersonPoints
	WHERE BuildingType = 'BUILDING_LIBRARY';

INSERT INTO Building_YieldChanges
		(BuildingType,								YieldType,	YieldChange)
SELECT	'LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB',	YieldType,	YieldChange
FROM Building_YieldChanges
	WHERE BuildingType = 'BUILDING_LIBRARY';

INSERT INTO BuildingReplaces
		(CivUniqueBuildingType,						ReplacesBuildingType)
VALUES	('LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB',	'BUILDING_LIBRARY');

INSERT INTO Building_YieldDistrictCopies
		(BuildingType,								OldYieldType,		NewYieldtype)
VALUES	('LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB',	'YIELD_SCIENCE',	'YIELD_GOLD');

------- AND THIS IS WHERE THE MAGIC HAPPENS

INSERT INTO Modifiers
		(ModifierId,							ModifierType,											RunOnce,	Permanent,	SubjectRequirementSetId)
VALUES	('MOD_LIME_ATTACH_TOMB_SCIENCE_BUFF',	'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',				0,			0,			'REQSET_LIME_AHIRAM_UNIT_IS_MERCHANT'),
		('MOD_LIME_TOMB_SCIENCE_BUFF',			'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE',	1,			1,			NULL);

INSERT INTO ModifierArguments
		(ModifierId,							Name,			Value)
VALUES	('MOD_LIME_ATTACH_TOMB_SCIENCE_BUFF',	'ModifierId',	'MOD_LIME_TOMB_SCIENCE_BUFF'),
		('MOD_LIME_TOMB_SCIENCE_BUFF',			'BuildingType',	'LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB'),
		('MOD_LIME_TOMB_SCIENCE_BUFF',			'YieldType',	'YIELD_SCIENCE'),
		('MOD_LIME_TOMB_SCIENCE_BUFF',			'Amount',		1);

INSERT INTO RequirementSets
		(RequirementSetId,							RequirementSetType)
VALUES	('REQSET_LIME_AHIRAM_UNIT_IS_MERCHANT',		'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
		(RequirementSetId,							RequirementId)
VALUES	('REQSET_LIME_AHIRAM_UNIT_IS_MERCHANT',		'REQ_LIME_AHIRAM_UNIT_IS_MERCHANT');

INSERT INTO Requirements
		(RequirementId,								RequirementType)
VALUES	('REQ_LIME_AHIRAM_UNIT_IS_MERCHANT',		'REQUIREMENT_GREAT_PERSON_TYPE_MATCHES');

INSERT INTO RequirementArguments
		(RequirementId,								Name,					Value)
VALUES	('REQ_LIME_AHIRAM_UNIT_IS_MERCHANT',		'GreatPersonClassType',	'GREAT_PERSON_CLASS_MERCHANT');

	-- Fixed with the help of cheating off p0khiel

INSERT INTO MomentIllustrations
		(MomentIllustrationType,				MomentDataType,			GameDataType,								Texture)
VALUES	('MOMENT_ILLUSTRATION_UNIQUE_BUILDING',	'MOMENT_DATA_BUILDING',	'LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB',	'HM_LimeAhiram_Tomb.dds');

--================================================================
-- LEADERS: AGENDAS ==============================================
--================================================================
-- Agendas			
------------------------------------------------------------------				
INSERT INTO Agendas				
		(AgendaType,									Name,											Description)
VALUES	('AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED',			'LOC_AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED',		'LOC_AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED');
------------------------------------------------------------------			
-- Traits			
------------------------------------------------------------------				
INSERT INTO Traits				
		(TraitType,										Name,												Description)
VALUES	('TRAIT_AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED',	'LOC_AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED_NAME',		'LOC_AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED_DESCRIPTION');
------------------------------------------------------------------			
-- AgendaTraits			
------------------------------------------------------------------				
INSERT INTO AgendaTraits				
		(AgendaType,									TraitType)
VALUES	('AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED',			'TRAIT_AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED');
------------------------------------------------------------------		
-- ExclusiveAgendas			
------------------------------------------------------------------			
INSERT INTO ExclusiveAgendas				
		(AgendaOne,										AgendaTwo)
VALUES	('AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED',			'AGENDA_TURTLER'),		-- No Double Jeopardy
		('AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED',			'AGENDA_PARANOID'),
		('AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED',			'AGENDA_DARWINIST');	-- Selfexplanatory
------------------------------------------------------------------
-- Agenda Preferred Leaders
------------------------------------------------------------------
INSERT INTO AgendaPreferredLeaders
		(AgendaType,									LeaderType,					PercentageChance)
VALUES	('AGENDA_MONEY_GRUBBER',						'LEADER_LIME_PHOE_AHIRAM',	20);
------------------------------------------------------------------			
-- TraitModifiers						
------------------------------------------------------------------				
INSERT INTO TraitModifiers							
		(TraitType,										ModifierId)
VALUES	('TRAIT_AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED',	'MOD_LIME_PHOE_AHIRAM_AGENDA_BE_HUMBLED'); -- okay this is getting funky
------------------------------------------------------------------
-- Modifiers
------------------------------------------------------------------
INSERT INTO Modifiers	
		(ModifierId,									ModifierType,									SubjectRequirementSetId)
VALUES	('MOD_LIME_PHOE_AHIRAM_AGENDA_BE_HUMBLED',		'MODIFIER_PLAYER_DIPLOMACY_TRADE_RELATIONS',	'PLAYER_IS_WARMONGER_SUBJECT');
------------------------------------------------------------------
-- ModifierArguments
------------------------------------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,									Name,							Value,															Type)
VALUES	('MOD_LIME_PHOE_AHIRAM_AGENDA_BE_HUMBLED',		'TradeBonus',					7,																'ARGTYPE_IDENTITY'),
		('MOD_LIME_PHOE_AHIRAM_AGENDA_BE_HUMBLED',		'NoTradePenalty',				-7,																'ARGTYPE_IDENTITY'),
		('MOD_LIME_PHOE_AHIRAM_AGENDA_BE_HUMBLED',		'BonusPerRoute',				2,																'ARGTYPE_IDENTITY'),
		('MOD_LIME_PHOE_AHIRAM_AGENDA_BE_HUMBLED',		'OnlyInboundTrade',				1,																'ARGTYPE_IDENTITY'),
		('MOD_LIME_PHOE_AHIRAM_AGENDA_BE_HUMBLED',		'StatementKey',					'LOC_DIPLO_KUDO_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED_REASON_ANY',	'ARGTYPE_IDENTITY'),
		('MOD_LIME_PHOE_AHIRAM_AGENDA_BE_HUMBLED',		'SimpleModifierDescription',	'LOC_DIPLO_MODIFIER_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED_KUDO',	'ARGTYPE_IDENTITY');

--================================================================
-- AI shit =======================================================
--================================================================
-- Forced Traits:
-------------------
INSERT INTO LeaderTraits
		(LeaderType,					TraitType)
VALUES	('LEADER_LIME_PHOE_AHIRAM',		'TRAIT_LEADER_LOW_RELIGIOUS_PREFERENCE');
-------------------------------------
-- AiListTypes
-------------------------------------
INSERT INTO AiListTypes	
		(ListType)
VALUES	('LEADER_LIME_PHOE_AHIRAM_Victories'),
		('LEADER_LIME_PHOE_AHIRAM_Colonization'),
		('LEADER_LIME_PHOE_AHIRAM_Diplo'),
		('LEADER_LIME_PHOE_AHIRAM_PseudoYields'),
		('LEADER_LIME_PHOE_AHIRAM_Alliances'),
		('LEADER_LIME_PHOE_AHIRAM_Discussions'),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions'),
		('LEADER_LIME_PHOE_AHIRAM_Wonders'),
		('LEADER_LIME_PHOE_AHIRAM_UnitPromoClasses'),
		('LEADER_LIME_PHOE_AHIRAM_BuildSpecializations'),
		('LEADER_LIME_PHOE_AHIRAM_Yields');

INSERT INTO AiLists	
		(ListType,											LeaderType,												System)
VALUES	('LEADER_LIME_PHOE_AHIRAM_Victories',				'TRAIT_AGENDA_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED',		'Strategies'),
		('LEADER_LIME_PHOE_AHIRAM_BuildSpecializations',	'TRAIT_AGENDA_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED',		'AiBuildSpecializations'),
		('LEADER_LIME_PHOE_AHIRAM_Colonization',			'TRAIT_AGENDA_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED',		'PlotEvaluations'),
		('LEADER_LIME_PHOE_AHIRAM_Diplo',					'TRAIT_AGENDA_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED',		'DiplomaticActions'),
		('LEADER_LIME_PHOE_AHIRAM_PseudoYields',			'TRAIT_AGENDA_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED',		'PseudoYields'),
		('LEADER_LIME_PHOE_AHIRAM_Yields',					'TRAIT_AGENDA_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED',		'Yields'),
		('LEADER_LIME_PHOE_AHIRAM_Alliances',				'TRAIT_AGENDA_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED',		'Alliances'),
		('LEADER_LIME_PHOE_AHIRAM_Discussions',				'TRAIT_AGENDA_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED',		'Discussions'),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',				'TRAIT_AGENDA_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED',		'Resolutions'),
		('LEADER_LIME_PHOE_AHIRAM_Wonders',					'TRAIT_AGENDA_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED',		'Wonders'),
		('LEADER_LIME_PHOE_AHIRAM_UnitPromoClasses',		'TRAIT_AGENDA_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED',		'UnitPromotionClasses');

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
		(ListType,										Item,									StringVal,					Favored,	Value)
		-- Preferred Victories
VALUES	('LEADER_LIME_PHOE_AHIRAM_Victories',			'VICTORY_STRATEGY_MILITARY_VICTORY',	null,						1,			3),
		('LEADER_LIME_PHOE_AHIRAM_Victories',			'VICTORY_STRATEGY_SCIENCE_VICTORY',		null,						1,			-1),

		-- Build Specs
		('LEADER_LIME_PHOE_AHIRAM_BuildSpecializations',	'BUILD_FOR_GOLD',					null,						1,			100),
		('LEADER_LIME_PHOE_AHIRAM_BuildSpecializations',	'BUILD_FOR_SCIENCE',				null,						1,			20),
		('LEADER_LIME_PHOE_AHIRAM_BuildSpecializations',	'BUILD_TRADE_UNITS',				null,						1,			100),

		-- Preferred Settling
		('LEADER_LIME_PHOE_AHIRAM_Colonization',		'Foreign Continent',					null,						1,			50),
		('LEADER_LIME_PHOE_AHIRAM_Colonization',		'Coastal',								null,						1,			100),
		('LEADER_LIME_PHOE_AHIRAM_Colonization',		'Specific Feature',						'FEATURE_REEF',				1,			100),
		
		-- Preferred Diplomatic Actions
		('LEADER_LIME_PHOE_AHIRAM_Diplo',				'DIPLOACTION_DIPLOMATIC_DELEGATION',	null,						1,			20),
		('LEADER_LIME_PHOE_AHIRAM_Diplo',				'DIPLOACTION_PROPOSE_TRADE',			null,						1,			40),
		('LEADER_LIME_PHOE_AHIRAM_Diplo',				'DIPLOACTION_PROPOSE_PEACE_DEAL',		null,						1,			50),

		-- Preferred Pseudoyields
		('LEADER_LIME_PHOE_AHIRAM_PseudoYields',		'PSEUDOYIELD_GPP_MERCHANT',				null,						1,			100),
		('LEADER_LIME_PHOE_AHIRAM_PseudoYields',		'PSEUDOYIELD_UNIT_NAVAL_COMBAT',		null,						1,			10),
		('LEADER_LIME_PHOE_AHIRAM_PseudoYields',		'PSEUDOYIELD_UNIT_COMBAT',				null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_PseudoYields',		'PSEUDOYIELD_UNIT_EXPLORER',			null,						1,			1),
		('LEADER_LIME_PHOE_AHIRAM_PseudoYields',		'PSEUDOYIELD_UNIT_SETTLER',				null,						1,			25),
		('LEADER_LIME_PHOE_AHIRAM_PseudoYields',		'PSEUDOYIELD_UNIT_TRADE',				null,						1,			100),

		-- Preferred Yields
		('LEADER_LIME_PHOE_AHIRAM_Yields',				'YIELD_GOLD',							null,						1,			100),
		('LEADER_LIME_PHOE_AHIRAM_Yields',				'YIELD_SCIENCE',						null,						1,			20),

		-- Preferred Alliances
		('LEADER_LIME_PHOE_AHIRAM_Alliances',			'ALLIANCE_ECONOMIC',					null,						1,			100),
		('LEADER_LIME_PHOE_AHIRAM_Alliances',			'ALLIANCE_MILITARY',					null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_Alliances',			'ALLIANCE_RESEARCH',					null,						1,			10),

		-- Preferred Discussions (Emergencies and Competitions... In this case I prefer putting a preference/dislike to all)
		('LEADER_LIME_PHOE_AHIRAM_Discussions',		'WC_EMERGENCY_MILITARY',				null,						1,			0),
		('LEADER_LIME_PHOE_AHIRAM_Discussions',		'WC_EMERGENCY_CITY_STATE',				null,						1,			30),
		('LEADER_LIME_PHOE_AHIRAM_Discussions',		'WC_EMERGENCY_RELIGIOUS',				null,						1,			0),
		('LEADER_LIME_PHOE_AHIRAM_Discussions',		'WC_EMERGENCY_NUCLEAR',					null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_Discussions',		'WC_EMERGENCY_BACKSTAB',				null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_Discussions',		'WC_EMERGENCY_REQUEST_AID',				null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_Discussions',		'WC_EMERGENCY_NOBEL_PRIZE_LITERATURE',	null,						1,			10),
		('LEADER_LIME_PHOE_AHIRAM_Discussions',		'WC_EMERGENCY_NOBEL_PRIZE_PEACE',		null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_Discussions',		'WC_EMERGENCY_NOBEL_PRIZE_PHYSICS',		null,						1,			10),
		('LEADER_LIME_PHOE_AHIRAM_Discussions',		'WC_EMERGENCY_CLIMATE_ACCORDS',			null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_Discussions',		'WC_EMERGENCY_WORLD_GAMES',				null,						1,			0),
		('LEADER_LIME_PHOE_AHIRAM_Discussions',		'WC_EMERGENCY_SPACE_STATION',			null,						1,			20),
		('LEADER_LIME_PHOE_AHIRAM_Discussions',		'WC_EMERGENCY_WORLD_FAIR',				null,						1,			0),

		-- Preferred Resolutions (In this case I also prefer putting a preference/dislike to all)
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_ARMS_CONTROL',					null,						1,			20),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_BORDER_CONTROL',				null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_DEFORESTATION_TREATY',			null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_DIPLOVICTORY',					null,						1,			0),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_GLOBAL_ENERGY_TREATY',			null,						1,			0),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_GOVERNANCE_DOCTRINE',			null,						1,			0),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_HERITAGE_ORG',					null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_LUXURY',						null,						1,			10),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_MERCENARY_COMPANIES',			null,						1,			0),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_MIGRATION_TREATY',				null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_PATRONAGE',						null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_POLICY_TREATY',					null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_PUBLIC_WORKS',					null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_SOVEREIGNTY',					null,						1,			30),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_TRADE_TREATY',					null,						1,			100),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_TREATY_ORGANIZATION',			null,						1,			0),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_URBAN_DEVELOPMENT',				null,						1,			0),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_WORLD_IDEOLOGY',				null,						0,			0),
		('LEADER_LIME_PHOE_AHIRAM_Resolutions',		'WC_RES_WORLD_RELIGION',				null,						1,			0),

		-- Wonders (I'm gonna hardcode this bc I want him to really go for these wonders)
		('LEADER_LIME_PHOE_AHIRAM_Wonders',				'BUILDING_COLOSSUS',				null,						1,			75),
		('LEADER_LIME_PHOE_AHIRAM_Wonders',				'BUILDING_GREAT_LIGHTHOUSE',		null,						1,			25),
		('LEADER_LIME_PHOE_AHIRAM_Wonders',				'BUILDING_ORACLE',					null,						1,			25),
		('LEADER_LIME_PHOE_AHIRAM_Wonders',				'BUILDING_UNIVERSITY_SANKORE',		null,						1,			62),

		-- Preferred Unit Promotion Classes
		('LEADER_LIME_PHOE_AHIRAM_UnitPromoClasses',	'PROMOTION_CLASS_NAVAL_MELEE',			null,						1,			20),
		('LEADER_LIME_PHOE_AHIRAM_UnitPromoClasses',	'PROMOTION_CLASS_NAVAL_RANGED',			null,						1,			30),
		('LEADER_LIME_PHOE_AHIRAM_UnitPromoClasses',	'PROMOTION_CLASS_NAVAL_RAIDER',			null,						1,			20);


INSERT INTO AiFavoredItems		
		(ListType,										Item,					StringVal,					Favored,	Value)
SELECT	'LEADER_LIME_PHOE_AHIRAM_Colonization',			'Specific Resource',	ResourceType,				1,			30
FROM Resource_ValidTerrains
	WHERE TerrainType = 'TERRAIN_COAST';