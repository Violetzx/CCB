--================================================================
-- Thule, the Third ==============================================
--================================================================
--	UA: Hunting of the Bowhead 
--			Workers can place a whales luxury resource at the cost 
--			of one population.
------------------------------------------------------------------
--	UU: Dogsled Raider
--			Skirmisher Replacement. Unlocked at Construction. Much 
--			cheaper. -5 Combat Strength when defending. +10 Combat 
--			Strength when attacking units at full health.
------------------------------------------------------------------
--	UI: Whalebone house 
--			Unlocked as Celestial navigation. Must be placed 
--			adjacent to 3 Coast tiles. Provides +1 Production, and 
--			+1 Food to each adjacent Fishing Boats improvement. +1 
--			Faith, +1 Culture and +1 Tourism from each adjacent 
--			Fishing Boats improvement. +1 Housing. +1 Faith from 
--			Solar Flares.

------------------------------------------------------------------
-- Types			
------------------------------------------------------------------
INSERT INTO Types
		(Type,															Kind)	
VALUES	('CIVILIZATION_LIME_THULE',										'KIND_CIVILIZATION'),
		-------------------------------------------------------------------------------------		
		('TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD',				'KIND_TRAIT'),
		('IMPROVEMENT_LIME_THULE_WHALESPERM',							'KIND_IMPROVEMENT'),
		('MODTYPE_LIME_THULE_CAN_BUILD_WHALES',							'KIND_MODIFIER'),
		-------------------------------------------------------------------------------------
		('TRAIT_CIVILIZATION_UNIT_LIME_THULE_DOGSLED',					'KIND_TRAIT'),
		('UNIT_LIME_THULE_DOGSLED',										'KIND_UNIT'),
		('ABIL_LIME_THULE_DOGSLED',										'KIND_ABILITY'),
		-------------------------------------------------------------------------------------
		('TRAIT_CIVILIZATION_IMPROVEMENT_LIME_THULE_WBH',				'KIND_TRAIT'),
		('IMPROVEMENT_LIME_THULE_WBH',									'KIND_IMPROVEMENT');			
------------------------------------------------------------------
-- Traits			
------------------------------------------------------------------
INSERT INTO Traits				
		(TraitType,														Name,														Description)
VALUES	('TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD',				'LOC_TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD_NAME',	'LOC_TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD_DESCRIPTION'),
		('TRAIT_CIVILIZATION_UNIT_LIME_THULE_DOGSLED',					'LOC_UNIT_LIME_THULE_DOGSLED_NAME',							NULL),
		('TRAIT_CIVILIZATION_IMPROVEMENT_LIME_THULE_WBH',				'LOC_IMPROVEMENT_LIME_THULE_WBH_NAME',						NULL);
------------------------------------------------------------------
-- Civilization Traits
------------------------------------------------------------------
INSERT INTO CivilizationTraits	
		(TraitType,														CivilizationType)
VALUES	('TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD',				'CIVILIZATION_LIME_THULE'),
		('TRAIT_CIVILIZATION_UNIT_LIME_THULE_DOGSLED',					'CIVILIZATION_LIME_THULE'),
		('TRAIT_CIVILIZATION_IMPROVEMENT_LIME_THULE_WBH',				'CIVILIZATION_LIME_THULE');

--================================================================
-- CIVILIZATION ==================================================
--================================================================
-- Civilization
------------------------------------------------------------------	
INSERT INTO Civilizations	
		(CivilizationType,			Name,								Description,								Adjective,									StartingCivilizationLevelType,	RandomCityNameDepth,	Ethnicity)
VALUES	('CIVILIZATION_LIME_THULE',	'LOC_CIVILIZATION_LIME_THULE_NAME',	'LOC_CIVILIZATION_LIME_THULE_DESCRIPTION',	'LOC_CIVILIZATION_LIME_THULE_ADJECTIVE',	'CIVILIZATION_LEVEL_FULL_CIV',	10,						'ETHNICITY_SOUTHAM');	
------------------------------------------------------------------		
-- CityNames			
------------------------------------------------------------------		
INSERT INTO CityNames	
		(CivilizationType,			CityName)	
VALUES	('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_2'),		-- This is a poem for Ed:
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_3'),	
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_4'),		-- Ed.
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_5'),	
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_6'),		-- England is red
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_7'),		-- And Khmer is yellow
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_8'),		-- you're a jackass
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_9'),		-- And not a nice fellow
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_10'),	
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_11'),		-- Your hard code is bad
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_12'),		-- And your damn game is too
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_13'),		-- Why did you do this
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_14'),		-- Also, America is blue
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_15'),	
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_16'),		-- If Thule only worked
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_17'),		-- I'd be happier than most
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_18'),		-- But thanks to your bullshit
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_19'),		-- It's inhabited by ghosts.
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_20'),	
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_21'),		-- So fuck off, dear Ed Bleach
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_22'),		-- firaxis, I cast on you a curse
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_23'),		-- If this damn thing don't work
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_24'),		-- You're officially the worst.
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_25'),	
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_26'),		-- update 2019: it ended up working
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_27'),		-- but I hate this mod
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_28'),		-- it's buggy as all hell
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_29'),		-- i fuckin swear to god
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_30'),	
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_31'),		-- update 2020: it's weird as all fuck
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_32'),		-- but at the end of the day
		('CIVILIZATION_LIME_THULE',	'LOC_CITY_NAME_LIME_THULE_33');		-- it's just my damn luck
-------------------------------------------------------------------		-- the apocalypse is underway
-- CivilizationCitizenNames
-------------------------------------------------------------------	
INSERT INTO CivilizationCitizenNames	
		(CivilizationType,			CitizenName,								Female,	Modern)
VALUES	('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MALE_1',			0,		0),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MALE_2',			0,		0),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MALE_3',			0,		0),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MALE_4',			0,		0),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MALE_5',			0,		0),	
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MALE_6',			0,		0),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MALE_7',			0,		0),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MALE_8',			0,		0),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MALE_9',			0,		0),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MALE_10',			0,		0),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_FEMALE_1',			1,		0),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_FEMALE_2',			1,		0), -- work it harder
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_FEMALE_3',			1,		0), -- make it better
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_FEMALE_4',			1,		0), -- do it faster
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_FEMALE_5',			1,		0), -- makes us stronger
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_FEMALE_6',			1,		0), -- more than ever
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_FEMALE_7',			1,		0), -- hour after
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_FEMALE_8',			1,		0), -- our work is never over
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_FEMALE_9',			1,		0),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_FEMALE_10',			1,		0),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_MALE_1',		0,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_MALE_2',		0,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_MALE_3',		0,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_MALE_4',		0,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_MALE_5',		0,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_MALE_6',		0,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_MALE_7',		0,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_MALE_8',		0,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_MALE_9',		0,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_MALE_10',	0,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_FEMALE_1',	1,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_FEMALE_2',	1,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_FEMALE_3',	1,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_FEMALE_4',	1,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_FEMALE_5',	1,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_FEMALE_6',	1,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_FEMALE_7',	1,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_FEMALE_8',	1,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_FEMALE_9',	1,		1),
		('CIVILIZATION_LIME_THULE',	'LOC_CITIZEN_LIME_THULE_MODERN_FEMALE_10',	1,		1);	
-------------------------------------------------------------------			
-- CivilizationInfo			
-------------------------------------------------------------------		
INSERT INTO CivilizationInfo	
		(CivilizationType,			Header,						Caption,								SortIndex)	
VALUES	('CIVILIZATION_LIME_THULE',	'LOC_CIVINFO_LOCATION',		'LOC_CIVINFO_LIME_THULE_LOCATION',		10),	
		('CIVILIZATION_LIME_THULE',	'LOC_CIVINFO_SIZE',			'LOC_CIVINFO_LIME_THULE_SIZE',			20),	
		('CIVILIZATION_LIME_THULE',	'LOC_CIVINFO_POPULATION',	'LOC_CIVINFO_LIME_THULE_POPULATION',	30),	
		('CIVILIZATION_LIME_THULE',	'LOC_CIVINFO_CAPITAL', 		'LOC_CIVINFO_LIME_THULE_CAPITAL',		40);
-----------------------------------------------
-- Dynamic Modifiers
-----------------------------------------------
INSERT INTO DynamicModifiers
		(ModifierType,												CollectionType,						EffectType)
VALUES	('MODTYPE_LIME_THULE_CAN_BUILD_WHALES',						'COLLECTION_PLAYER_CITIES',			'EFFECT_ADJUST_CITY_ALLOWED_IMPROVEMENT');
-------------------------------------------------------------------		
-- TraitModifiers		
-------------------------------------------------------------------			
INSERT INTO TraitModifiers			
		(TraitType,													ModifierId)
VALUES	('TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD',			'MODIFIER_LIME_THULE_CAN_BUILD_WHALES');
-------------------------------------------------------------------
-- Modifiers
-------------------------------------------------------------------
INSERT INTO Modifiers
		(ModifierID,												ModifierType,							Permanent,	SubjectRequirementSetId)
VALUES	('MODIFIER_LIME_THULE_CAN_BUILD_WHALES',					'MODTYPE_LIME_THULE_CAN_BUILD_WHALES',	0,			'LIME_PLAYER_HAS_SAILING_AND_CITY_HAS_TWO_POP_REQSET');
-------------------------------------------------------------------
-- ModifierArguments
-------------------------------------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,												Name,					Value)
VALUES	('MODIFIER_LIME_THULE_CAN_BUILD_WHALES',					'ImprovementType',		'IMPROVEMENT_LIME_THULE_WHALESPERM');
-------------------------------------------------------------------
-- Requirement Sets
-------------------------------------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,											RequirementSetType)
VALUES	('LIME_PLAYER_HAS_SAILING_AND_CITY_HAS_TWO_POP_REQSET',		'REQUIREMENTSET_TEST_ALL');
-------------------------------------------------------------------
-- Requirement Set Requirements
-------------------------------------------------------------------
INSERT INTO RequirementSetRequirements
		(RequirementSetId,											RequirementId)
VALUES	('LIME_PLAYER_HAS_SAILING_AND_CITY_HAS_TWO_POP_REQSET',		'LIME_PLAYER_HAS_SAILING_REQ'),
		('LIME_PLAYER_HAS_SAILING_AND_CITY_HAS_TWO_POP_REQSET',		'LIME_CITY_HAS_TWO_POP_REQ');
-------------------------------------------------------------------
-- Requirements
-------------------------------------------------------------------
INSERT INTO Requirements
		(RequirementId,									RequirementType)
VALUES	('LIME_PLAYER_HAS_SAILING_REQ',					'REQUIREMENT_PLAYER_HAS_TECHNOLOGY'),
		('LIME_CITY_HAS_TWO_POP_REQ',					'REQUIREMENT_CITY_HAS_X_POPULATION');
-------------------------------------------------------------------
-- Requirement Arguments
-------------------------------------------------------------------
INSERT INTO RequirementArguments
		(RequirementId,						Name,				Value)
VALUES	('LIME_PLAYER_HAS_SAILING_REQ',		'TechnologyType',	'TECH_SAILING'),
		('LIME_CITY_HAS_TWO_POP_REQ',		'Amount',			2);
-------------------------------------------------------------------	
-- StartBiasTerrains
-------------------------------------------------------------------	
INSERT INTO StartBiasTerrains	
		(CivilizationType,				TerrainType,				Tier)
VALUES	('CIVILIZATION_LIME_THULE',		'TERRAIN_TUNDRA',			1),
		('CIVILIZATION_LIME_THULE',		'TERRAIN_TUNDRA_HILLS',		1),
		('CIVILIZATION_LIME_THULE',		'TERRAIN_SNOW', 			1),
		('CIVILIZATION_LIME_THULE',		'TERRAIN_SNOW_HILLS',		1),
		('CIVILIZATION_LIME_THULE',		'TERRAIN_COAST',			2);
-------------------------------------------------------------------	
-- StartBiasResources
-------------------------------------------------------------------	
INSERT INTO StartBiasResources	
		(CivilizationType,				ResourceType,				Tier)
VALUES	('CIVILIZATION_LIME_THULE',		'RESOURCE_WHALES',			1);

--=================================================================
-- UNITS ==========================================================
--=================================================================
-- Units
-------------------------------------------------------------------	
INSERT INTO Units	
		(UnitType,					BaseMoves,	Cost,		BaseSightRange, 	ZoneOfControl,	Domain,		FormationClass, Name,								Description,									PurchaseYield,	MustPurchase,	PromotionClass, Maintenance,	Combat,		PrereqTech,				TraitType,										PrereqPopulation,	PopulationCost, BuildCharges,	CanCapture, CostProgressionModel,	CostProgressionParam1,	RangedCombat,	Range)
SELECT	'UNIT_LIME_THULE_DOGSLED',	BaseMoves,	Cost*0.75,	BaseSightRange,		ZoneOfControl,	Domain,		FormationClass,	'LOC_UNIT_LIME_THULE_DOGSLED_NAME',	'LOC_UNIT_LIME_THULE_DOGSLED_DESCRIPTION',		PurchaseYield,	MustPurchase,	PromotionClass,	Maintenance-1,	Combat,		'TECH_CONSTRUCTION',	'TRAIT_CIVILIZATION_UNIT_LIME_THULE_DOGSLED',	PrereqPopulation,	PopulationCost,	BuildCharges,	CanCapture,	CostProgressionModel,	CostProgressionParam1,	RangedCombat,	Range
FROM Units
	WHERE UnitType = 'UNIT_SKIRMISHER';
-------------------------------------------------------------------
-- UnitAIInfos
-------------------------------------------------------------------
INSERT INTO UnitAIInfos	
		(UnitType,							AiType)
SELECT	'UNIT_LIME_THULE_DOGSLED',			AiType
From UnitAIInfos
	WHERE UnitType = 'UNIT_SKIRMISHER';
-------------------------------------------------------------------
-- Tags
-------------------------------------------------------------------	
INSERT INTO Tags	
		(Tag,								Vocabulary)
VALUES	('CLASS_LIME_THULE_DOGSLED',		'ABILITY_CLASS');
-------------------------------------------------------------------
-- TypeTags
-------------------------------------------------------------------	
INSERT INTO TypeTags
		(Type,								Tag)
VALUES	('UNIT_LIME_THULE_DOGSLED',			'CLASS_LIME_THULE_DOGSLED'),
		('ABIL_LIME_THULE_DOGSLED',			'CLASS_LIME_THULE_DOGSLED'),
		('UNIT_LIME_THULE_DOGSLED',			'CLASS_RECON');
-------------------------------------------------------------------
INSERT INTO UnitReplaces
		(CivUniqueUnitType,					ReplacesUnitType)
VALUES	('UNIT_LIME_THULE_DOGSLED',			'UNIT_SKIRMISHER');
-------------------------------------------------------------------
INSERT INTO UnitUpgrades
		(Unit,								UpgradeUnit)
SELECT	'UNIT_LIME_THULE_DOGSLED',			UpgradeUnit
FROM UnitUpgrades
	WHERE Unit = 'UNIT_SKIRMISHER';

INSERT INTO UnitAbilities
		(UnitAbilityType,					Name,								Description)
VALUES	('ABIL_LIME_THULE_DOGSLED',			'LOC_ABIL_LIME_THULE_DOGSLED_NAME',	'LOC_ABIL_LIME_THULE_DOGSLED_DESC');

INSERT INTO UnitAbilityModifiers
		(UnitAbilityType,					ModifierId)
VALUES	('ABIL_LIME_THULE_DOGSLED',			'LIME_THULE_DOGSLED_SNEAK_ATTACK'),
		('ABIL_LIME_THULE_DOGSLED',			'LIME_THULE_DOGSLED_DEFEND_WEAK');

INSERT INTO Modifiers
		(ModifierId,						ModifierType,									SubjectRequirementSetId)
VALUES	('LIME_THULE_DOGSLED_SNEAK_ATTACK',	'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',			'REQSET_LIME_THULE_DOGSLED_OPPONENT_NOT_INJURED'),
		('LIME_THULE_DOGSLED_DEFEND_WEAK',	'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',			'UNIT_WEAK_WHEN_DEFENDING_REQUIREMENTS');

INSERT INTO ModifierArguments
		(ModifierId,						Name,		Value)
VALUES	('LIME_THULE_DOGSLED_SNEAK_ATTACK',	'Amount',	10),
		('LIME_THULE_DOGSLED_DEFEND_WEAK',	'Amount',	-5);

INSERT INTO ModifierStrings
		(ModifierId,						Context,	Text)
VALUES	('LIME_THULE_DOGSLED_SNEAK_ATTACK',	'Preview',	'LOC_ABIL_LIME_THULE_SNEAK_ATTACK_DESC'),
		('LIME_THULE_DOGSLED_DEFEND_WEAK',	'Preview',	'LOC_ABIL_LIME_THULE_DEFEND_WEAK_DESC');

-------------------------------------------------------------------
-- Requirement Sets
-------------------------------------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,									RequirementSetType)
VALUES	('REQSET_LIME_THULE_DOGSLED_OPPONENT_NOT_INJURED',	'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
		(RequirementSetId,									RequirementId)
VALUES	('REQSET_LIME_THULE_DOGSLED_OPPONENT_NOT_INJURED',	'REQ_LIME_THULE_DOGSLED_OPPONENT_NOT_INJURED');

INSERT INTO Requirements
		(RequirementId,										RequirementType,						Inverse,		Reverse)
VALUES	('REQ_LIME_THULE_DOGSLED_OPPONENT_NOT_INJURED',		'REQUIREMENT_REQUIREMENTSET_IS_MET',	1,				0);

INSERT INTO RequirementArguments
		(RequirementId,										Name,				Value)
VALUES	('REQ_LIME_THULE_DOGSLED_OPPONENT_NOT_INJURED',		'RequirementSetId',	'REQUIREMENTS_OPPONENT_IS_WOUNDED');

-------------------------------------------------------------------
-- Historic Moments
-------------------------------------------------------------------	
INSERT INTO MomentIllustrations
		(MomentIllustrationType,			MomentDataType,		GameDataType,				Texture)
VALUES	('MOMENT_ILLUSTRATION_UNIQUE_UNIT',	'MOMENT_DATA_UNIT',	'UNIT_LIME_THULE_DOGSLED',	'Moment_UniqueUnit_Lime_Thule_Dogsled.dds');

--=================================================================
-- IMPROVEMENTS ===================================================
--=================================================================
-- Improvement
-------------------------------------------------------------------	
----	UI: Whalebone house 
--			Unlocked as Celestial navigation. Must be placed 
--			adjacent to 3 sea tiles. Provides +1 production, and 
--			+1 food to each adjacent fishing boats. +1 Faith, +1 
--			culture and +1 Tourism from each adjacent Sea Resource. 
--			+1 Housing. +2 Faith and +2 Tourism from Solar Flares.

INSERT INTO Improvements	
		(ImprovementType,							SameAdjacentValid,	PlunderType,		PlunderAmount,	Housing,	Icon,									Name,									Description,									Buildable,		Domain,			PrereqTech,						TraitType,											ValidAdjacentTerrainAmount,			MinimumAppeal)
VALUES	('IMPROVEMENT_LIME_THULE_WHALESPERM',		1,					'NO_PLUNDER',		0,				0,			'ICON_IMPROVEMENT_LIME_THULE_WHALES',	'LOC_RESOURCE_WHALES_NAME',				'LOC_RESOURCE_WHALES_DESCRIPTION',				1,				'DOMAIN_SEA',	NULL,							'TRAIT_CIVILIZATION_NO_PLAYER',						0,									Null),
		('IMPROVEMENT_LIME_THULE_WBH',				1,					'PLUNDER_HEAL',		50,				1,			'ICON_IMPROVEMENT_LIME_THULE_WBH',		'LOC_IMPROVEMENT_LIME_THULE_WBH_NAME',	'LOC_IMPROVEMENT_LIME_THULE_WBH_DESCRIPTION',	1,				'DOMAIN_LAND',	'TECH_CELESTIAL_NAVIGATION',	'TRAIT_CIVILIZATION_IMPROVEMENT_LIME_THULE_WBH',	3,									Null);
--------------------------------------------------------------------
-- Improvement Valid Terrains
--------------------------------------------------------------------
INSERT INTO Improvement_ValidTerrains
		(ImprovementType,							TerrainType)
VALUES	('IMPROVEMENT_LIME_THULE_WHALESPERM',		'TERRAIN_COAST'),
		('IMPROVEMENT_LIME_THULE_WHALESPERM',		'TERRAIN_OCEAN'),

		('IMPROVEMENT_LIME_THULE_WBH',				'TERRAIN_TUNDRA'),
		('IMPROVEMENT_LIME_THULE_WBH',				'TERRAIN_TUNDRA_HILLS'),
		('IMPROVEMENT_LIME_THULE_WBH',				'TERRAIN_SNOW'),
		('IMPROVEMENT_LIME_THULE_WBH',				'TERRAIN_SNOW_HILLS'),
		('IMPROVEMENT_LIME_THULE_WBH',				'TERRAIN_GRASS'),
		('IMPROVEMENT_LIME_THULE_WBH',				'TERRAIN_GRASS_HILLS'),
		('IMPROVEMENT_LIME_THULE_WBH',				'TERRAIN_PLAINS'),
		('IMPROVEMENT_LIME_THULE_WBH',				'TERRAIN_PLAINS_HILLS'),
		('IMPROVEMENT_LIME_THULE_WBH',				'TERRAIN_DESERT'),
		('IMPROVEMENT_LIME_THULE_WBH',				'TERRAIN_DESERT_HILLS');
---------------------------------------------------------------------
-- Improvement Valid Adjacent Terrains
---------------------------------------------------------------------
INSERT INTO Improvement_ValidAdjacentTerrains
		(ImprovementType,							TerrainType)
VALUES	('IMPROVEMENT_LIME_THULE_WBH',				'TERRAIN_COAST'),
		('IMPROVEMENT_LIME_THULE_WBH',				'TERRAIN_OCEAN');
---------------------------------------------------------------------
-- Improvement Valid Build Units
---------------------------------------------------------------------
INSERT INTO Improvement_ValidBuildUnits
		(ImprovementType,							UnitType)
VALUES	('IMPROVEMENT_LIME_THULE_WHALESPERM',		'UNIT_BUILDER'),
		('IMPROVEMENT_LIME_THULE_WBH',				'UNIT_BUILDER');
---------------------------------------------------------------------
-- Improvement_YieldChanges
---------------------------------------------------------------------
INSERT INTO Improvement_YieldChanges
		(ImprovementType,							YieldType,			YieldChange)
VALUES	('IMPROVEMENT_LIME_THULE_WHALESPERM',		'YIELD_FOOD',		2),
		('IMPROVEMENT_LIME_THULE_WHALESPERM',		'YIELD_GOLD',		2),
		('IMPROVEMENT_LIME_THULE_WHALESPERM',		'YIELD_PRODUCTION',	1),
		('IMPROVEMENT_LIME_THULE_WBH',				'YIELD_FAITH',		0),
		('IMPROVEMENT_LIME_THULE_WBH',				'YIELD_CULTURE',	0);

INSERT INTO Improvement_Adjacencies
		(ImprovementType,							YieldChangeId)
VALUES	('IMPROVEMENT_LIME_THULE_WBH',				'Lime_WBH_Faith'),
		('IMPROVEMENT_LIME_THULE_WBH',				'Lime_WBH_Culture'),
		('IMPROVEMENT_FISHING_BOATS',				'Lime_WBH_FishingBoats_Food'),
		('IMPROVEMENT_FISHING_BOATS',				'Lime_WBH_FishingBoats_Production');

INSERT INTO Adjacency_YieldChanges
		(ID,										Description,	YieldType,			YieldChange,	TilesRequired,	AdjacentSeaResource,	AdjacentImprovement)
VALUES	('Lime_WBH_Faith',							'Placeholder',	'YIELD_FAITH',		1,				1,				1,						NULL),
		('Lime_WBH_Culture',						'Placeholder',	'YIELD_CULTURE',	1,				1,				1,						NULL),
		('Lime_WBH_FishingBoats_Food',				'Placeholder',	'YIELD_FOOD',		1,				1,				0,						'IMPROVEMENT_LIME_THULE_WBH'),
		('Lime_WBH_FishingBoats_Production',		'Placeholder',	'YIELD_PRODUCTION',	1,				1,				0,						'IMPROVEMENT_LIME_THULE_WBH');
-------------------------------------------------------------------------
-- Improvement Tourism
-------------------------------------------------------------------------
INSERT INTO Improvement_Tourism
		(ImprovementType,							TourismSource)
VALUES	('IMPROVEMENT_LIME_THULE_WBH',				'TOURISMSOURCE_FAITH');
-------------------------------------------------------------------
-- Historic Moments
-------------------------------------------------------------------	
INSERT INTO MomentIllustrations
		(MomentIllustrationType,					MomentDataType,				GameDataType,					Texture)
VALUES	('MOMENT_ILLUSTRATION_UNIQUE_IMPROVEMENT',	'MOMENT_DATA_IMPROVEMENT',	'IMPROVEMENT_LIME_THULE_WBH',	'Moment_Infrastructure_Lime_Thule_WBH.dds');

--===================================================================
-- Other stuff I tacked in at the very end ==========================
--===================================================================
-- IMPROVEMENT_LIME_THULE_WHALESPERM
INSERT INTO CivilopediaPageExcludes 
		(SectionId,			PageId)
VALUES	('IMPROVEMENTS',	'IMPROVEMENT_LIME_THULE_WHALESPERM');

--==================================================================================================
--	Stuff to do with map names idk
--==================================================================================================
INSERT INTO NamedMountainCivilizations
		(NamedMountainType,						CivilizationType)
VALUES	('NAMED_MOUNTAIN_AUYUITTUQ_PEAKS',		'CIVILIZATION_LIME_THULE'),
		('NAMED_MOUNTAIN_INNUITIAN_MOUNTAINS',	'CIVILIZATION_LIME_THULE'),
		('NAMED_MOUNTAIN_TORNGAT_MOUNTAINS',	'CIVILIZATION_LIME_THULE'),
		('NAMED_MOUNTAIN_ALANGUP_QAQAI',		'CIVILIZATION_LIME_THULE'),
		('NAMED_MOUNTAIN_LEMON_RANGE',			'CIVILIZATION_LIME_THULE');

INSERT INTO NamedMountains
		(NamedMountainType,						Name)
VALUES	('NAMED_MOUNTAIN_AUYUITTUQ_PEAKS',		'LOC_NAMED_MOUNTAIN_AUYUITTUQ_PEAKS_NAME'),
		('NAMED_MOUNTAIN_INNUITIAN_MOUNTAINS',	'LOC_NAMED_MOUNTAIN_INNUITIAN_MOUNTAINS_NAME'),
		('NAMED_MOUNTAIN_TORNGAT_MOUNTAINS',	'LOC_NAMED_MOUNTAIN_TORNGAT_MOUNTAINS_NAME'),
		('NAMED_MOUNTAIN_ALANGUP_QAQAI',		'LOC_NAMED_MOUNTAIN_ALANGUP_QAQAI_NAME'),
		('NAMED_MOUNTAIN_LEMON_RANGE',			'LOC_NAMED_MOUNTAIN_LEMON_RANGE_NAME');

INSERT INTO NamedRiverCivilizations
		(NamedRiverType,						CivilizationType)
VALUES	('NAMED_RIVER_KITLINERMIUT_RIVER',		'CIVILIZATION_LIME_THULE'),
		('NAMED_RIVER_MELIADINE_RIVER',			'CIVILIZATION_LIME_THULE'),
		('NAMED_RIVER_KUUKPAK_RIVER',			'CIVILIZATION_LIME_THULE'),
		('NAMED_RIVER_AKULIARUSIARSUUP_KUUA',	'CIVILIZATION_LIME_THULE'),
		('NAMED_RIVER_QINNGUATA_KUUSSUA',		'CIVILIZATION_LIME_THULE');

INSERT INTO NamedRivers
		(NamedRiverType,						Name)
VALUES	('NAMED_RIVER_KITLINERMIUT_RIVER',		'LOC_NAMED_RIVER_KITLINERMIUT_RIVER_NAME'),
		('NAMED_RIVER_MELIADINE_RIVER',			'LOC_NAMED_RIVER_MELIADINE_RIVER_NAME'),
		('NAMED_RIVER_KUUKPAK_RIVER',			'LOC_NAMED_RIVER_KUUKPAK_RIVER_NAME'),
		('NAMED_RIVER_AKULIARUSIARSUUP_KUUA',	'LOC_NAMED_RIVER_AKULIARUSIARSUUP_KUUA_NAME'),
		('NAMED_RIVER_QINNGUATA_KUUSSUA',		'LOC_NAMED_RIVER_QINNGUATA_KUUSSUA_NAME');

INSERT INTO NamedVolcanoCivilizations
		(NamedVolcanoType,						CivilizationType)
VALUES	('NAMED_VOLCANO_TSEAX_CONE',			'CIVILIZATION_LIME_THULE');