-- Suk_Ingolfur_XP2
-- Author: Sukrit
-- DateCreated: 8/17/2018 4:51:38 AM
--==========================================================================================================================
														-- TRAITS --
--==========================================================================================================================
UPDATE Traits
SET Name = 'LOC_TRAIT_CIVILIZATION_SUK_DHARMA_KINGS_NAME_XP2', Description = 'LOC_TRAIT_CIVILIZATION_SUK_DHARMA_KINGS_DESCRIPTION_XP2'
WHERE TraitType = 'TRAIT_CIVILIZATION_SUK_DHARMA_KINGS';
--------------------------------------------------------------------
-- Delete Stuff
--------------------------------------------------------------------
-- When built next to a Mountain within your borders, Specialty Districts provide +2 of the appropriate yield
DELETE FROM Modifiers WHERE ModifierID LIKE 'SUK/_DHARMA/_KINGS/_DISTRICT%YIELD%' ESCAPE '/';
DELETE FROM TraitModifiers WHERE ModifierID LIKE 'SUK/_DHARMA/_KINGS/_DISTRICT%YIELD%' ESCAPE '/';
DELETE FROM ModifierArguments WHERE ModifierID LIKE 'SUK/_DHARMA/_KINGS/_DISTRICT%YIELD%' ESCAPE '/';

-- Adjacent to Mountain within Player Borders Requirement.
DELETE FROM RequirementSets WHERE RequirementSetId IN ('SUK_DHARMA_KINGS_MOUNTAIN_PLOT_ADJACENT_DISTRICT_REQUIREMENTS', 'SUK_DHARMA_KINGS_PLOT_IS_MOUNTAIN_REQUIREMENTS');
DELETE FROM RequirementSetRequirements WHERE RequirementSetId IN ('SUK_DHARMA_KINGS_MOUNTAIN_PLOT_ADJACENT_DISTRICT_REQUIREMENTS', 'SUK_DHARMA_KINGS_PLOT_IS_MOUNTAIN_REQUIREMENTS');

DELETE FROM Requirements WHERE RequirementId LIKE 'SUK/_DHARMA/_KINGS/_PLOT/_IS%' ESCAPE '/';
DELETE FROM Requirements WHERE RequirementId IN ('SUK_DHARMA_KINGS_MOUNTAINS_ADJACENT', 'SUK_DHARMA_KINGS_ADJACENT_TO_OWNER');
DELETE FROM RequirementSetRequirements WHERE RequirementId IN ('SUK_DHARMA_KINGS_MOUNTAINS_ADJACENT', 'SUK_DHARMA_KINGS_ADJACENT_TO_OWNER');
DELETE FROM RequirementSetRequirements WHERE RequirementId LIKE 'SUK/_DHARMA/_KINGS/_PLOT/_IS%' ESCAPE '/';
DELETE FROM RequirementArguments WHERE RequirementId IN ('SUK_DHARMA_KINGS_MOUNTAINS_ADJACENT', 'SUK_DHARMA_KINGS_ADJACENT_TO_OWNER');
DELETE FROM RequirementArguments WHERE RequirementId LIKE 'SUK/_DHARMA/_KINGS/_PLOT/_IS%' ESCAPE '/';
----------------------------------------------------------------------------------------------------------------------------
-- Increase Dzong Requirement
----------------------------------------------------------------------------------------------------------------------------
UPDATE Districts
SET Description = 'LOC_DISTRICT_SUK_DZONG_DESCRIPTION_XP2'
WHERE DistrictType = 'DISTRICT_SUK_DZONG';
----------------------------------------------------------------------------------------------------------------------------
-- Adjacent to Mountain Requirement.
----------------------------------------------------------------------------------------------------------------------------
-- REQUIREMENTS
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,															RequirementSetType)
VALUES	('SUK_DHARMA_KINGS_ADJACENT_MOUNTAIN_REQUIREMENTS',							'REQUIREMENTSET_TEST_ANY');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------
INSERT INTO RequirementSetRequirements
		(RequirementSetId,															RequirementId)
SELECT	'SUK_DHARMA_KINGS_ADJACENT_MOUNTAIN_REQUIREMENTS',							'SUK_DHARMA_KINGS_ADJACENT_' || Terrains.TerrainType
FROM Terrains WHERE Terrains.TerrainType LIKE '%MOUNTAIN';
-------------------------------------
-- Requirements
-------------------------------------
INSERT INTO Requirements
		(RequirementId, 											RequirementType)
VALUES	('SUK_DHARMA_KINGS_ADJACENT_MOUNTAIN',						'REQUIREMENT_REQUIREMENTSET_IS_MET');

INSERT INTO Requirements
		(RequirementId, 											RequirementType)
SELECT	'SUK_DHARMA_KINGS_ADJACENT_' || Terrains.TerrainType,		'REQUIREMENT_PLOT_ADJACENT_TERRAIN_TYPE_MATCHES'
FROM Terrains WHERE Terrains.TerrainType LIKE '%MOUNTAIN';
-------------------------------------
-- RequirementArguments
-------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 								Name,						Value)
VALUES	('SUK_DHARMA_KINGS_ADJACENT_MOUNTAIN', 			'RequirementSetId',			'SUK_DHARMA_KINGS_ADJACENT_MOUNTAIN_REQUIREMENTS');

INSERT INTO RequirementArguments
		(RequirementId, 												Name,						Value)
SELECT	'SUK_DHARMA_KINGS_ADJACENT_' || Terrains.TerrainType,			'TerrainType',				TerrainType
FROM Terrains WHERE Terrains.TerrainType LIKE '%MOUNTAIN';
----------------------------------------------------------------------------------------------------------------------------
-- Restore Adjacent  Mountain Requirement to Specialty Distrit Requirement Sets.
----------------------------------------------------------------------------------------------------------------------------
INSERT INTO RequirementSetRequirements
		(RequirementSetId,							RequirementId)
SELECT	RequirementSetId,							'SUK_DHARMA_KINGS_ADJACENT_MOUNTAIN'
FROM RequirementSetRequirements WHERE RequirementSetId LIKE 'SUK/_DHARMA/_KINGS/_DISTRICT%REQUIREMENTS' ESCAPE '/';
--==========================================================================================================================
-- BEGIN PREPARATION
--==========================================================================================================================
-- Preparation for all the "Citizens may work Mountain tiles" stuff
----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS SukDharmaKingsData;
CREATE TEMPORARY TABLE "SukDharmaKingsData"(
	"DistrictType" 			TEXT,
	"RequirementId" 		TEXT,
	"YieldType" 			TEXT,
	"Amount" 				INTEGER,
	"CustomRequirementId"	BOOLEAN
);

INSERT INTO SukDharmaKingsData			
	(
		DistrictType,
		YieldType,
		Amount,
		RequirementId,
		CustomRequirementId
	)
SELECT DISTINCT
	Districts.DistrictType,
	Adjacency_YieldChanges.YieldType,
	1,
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
INNER JOIN District_Adjacencies ON District_Adjacencies.DistrictType = Districts.DistrictType
INNER JOIN Adjacency_YieldChanges ON District_Adjacencies.YieldChangeId = Adjacency_YieldChanges.ID
INNER JOIN Requirements ON REPLACE(Districts.DistrictType, 'DISTRICT', 'REQUIRES_DISTRICT_IS') = Requirements.RequirementId
WHERE Districts.RequiresPopulation = 1 AND Districts.DistrictType NOT IN (SELECT CivUniqueDistrictType FROM DistrictReplaces);

INSERT INTO SukDharmaKingsData
		(DistrictType,				YieldType,				Amount,		RequirementId,							CustomRequirementId)
VALUES	('DISTRICT_CITY_CENTER',	'YIELD_FOOD',			2,			'REQUIRES_DISTRICT_IS_CITY_CENTER',		0);
		--('DISTRICT_CITY_CENTER',	'YIELD_FAITH',			1,			'REQUIRES_DISTRICT_IS_CITY_CENTER',		0);
--==========================================================================================================================
-- Citizens may work Mountain tiles
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,											ModifierId)
VALUES	('TRAIT_CIVILIZATION_SUK_DHARMA_KINGS', 			'TRAIT_WORK_GRASS_MOUNTAIN'),
		('TRAIT_CIVILIZATION_SUK_DHARMA_KINGS', 			'TRAIT_WORK_PLAINS_MOUNTAIN'),
		('TRAIT_CIVILIZATION_SUK_DHARMA_KINGS', 			'TRAIT_WORK_DESERT_MOUNTAIN'),
		('TRAIT_CIVILIZATION_SUK_DHARMA_KINGS', 			'TRAIT_WORK_TUNDRA_MOUNTAIN'),
		('TRAIT_CIVILIZATION_SUK_DHARMA_KINGS', 			'TRAIT_WORK_SNOW_MOUNTAIN');
--==========================================================================================================================
-- Mountain tiles receive yields from districts within 2 tiles:
	-- +1 [ICON_Food], +1 [ICON_Production] from City Centres,
	-- and +1 of the appropriate yield from other districts.
----------------------------------------------------------------------------------------------------------------------------
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,																		Kind)
VALUES	('MODIFIER_SUK_DHARMA_KINGS_PLAYER_DISTRICTS_ATTACH_MODIFIER',				'KIND_MODIFIER');
-------------------------------------
-- DynamicModifiers
-------------------------------------					
INSERT INTO DynamicModifiers			
		(ModifierType,																CollectionType,						EffectType)
VALUES	('MODIFIER_SUK_DHARMA_KINGS_PLAYER_DISTRICTS_ATTACH_MODIFIER',				'COLLECTION_PLAYER_DISTRICTS',		'EFFECT_ATTACH_MODIFIER');
----------------------------------------------------------------------------------------------------------------------------
-- MODIFIERS
----------------------------------------------------------------------------------------------------------------------------
-- TraitModifiers
-------------------------------------
INSERT INTO TraitModifiers			
		(TraitType,										ModifierId)
SELECT 	'TRAIT_CIVILIZATION_SUK_DHARMA_KINGS',			'SUK_DHARMA_KINGS_' || DistrictType || '_' || YieldType
FROM SukDharmaKingsData;
-------------------------------------
-- Modifiers
-------------------------------------
INSERT INTO Modifiers	
		(ModifierId,														ModifierType,														SubjectRequirementSetId)
SELECT	'SUK_DHARMA_KINGS_' || DistrictType || '_' || YieldType,			'MODIFIER_SUK_DHARMA_KINGS_PLAYER_DISTRICTS_ATTACH_MODIFIER',		'SUK_DHARMA_KINGS_DISTRICT_IS_' || DistrictType || '_REQUIREMENTS'
FROM SukDharmaKingsData;

INSERT INTO Modifiers	
		(ModifierId,																	ModifierType,								SubjectRequirementSetId)
SELECT	'SUK_DHARMA_KINGS_' || DistrictType || '_' || YieldType || '_MODIFIER',			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',		'SUK_DHARMA_KINGS_MOUNTAIN_NEAR_DISTRICT_REQUIREMENTS'
FROM SukDharmaKingsData;
-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT INTO ModifierArguments
		(ModifierId,														Name,					Value)
SELECT	'SUK_DHARMA_KINGS_' || DistrictType || '_' || YieldType,			'ModifierId',			'SUK_DHARMA_KINGS_' || DistrictType || '_' || YieldType || '_MODIFIER'
FROM SukDharmaKingsData;

INSERT INTO ModifierArguments
		(ModifierId,																	Name,						Value)
SELECT	'SUK_DHARMA_KINGS_' || DistrictType || '_' || YieldType || '_MODIFIER',			'YieldType',				YieldType
FROM SukDharmaKingsData;

INSERT INTO ModifierArguments
		(ModifierId,																	Name,						Value)
SELECT	'SUK_DHARMA_KINGS_' || DistrictType || '_' || YieldType || '_MODIFIER',			'Amount',					Amount
FROM SukDharmaKingsData;
----------------------------------------------------------------------------------------------------------------------------
-- REQUIREMENTS
----------------------------------------------------------------------------------------------------------------------------
-- RequirementSets
-------------------------------------
INSERT INTO RequirementSets
		(RequirementSetId,											RequirementSetType)
VALUES	('SUK_DHARMA_KINGS_MOUNTAIN_NEAR_DISTRICT_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSets
				(RequirementSetId,																RequirementSetType)
SELECT DISTINCT	'SUK_DHARMA_KINGS_DISTRICT_IS_' || DistrictType || '_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'
FROM SukDharmaKingsData;
-------------------------------------
-- RequirementSetRequirements
-------------------------------------
INSERT INTO RequirementSetRequirements
		(RequirementSetId,											RequirementId)
VALUES	('SUK_DHARMA_KINGS_MOUNTAIN_NEAR_DISTRICT_REQUIREMENTS',	'SUK_DHARMA_KINGS_PLOT_NEAR_DISTRICT'),
		('SUK_DHARMA_KINGS_MOUNTAIN_NEAR_DISTRICT_REQUIREMENTS',	'PLOT_IS_MOUNTAIN');

INSERT INTO RequirementSetRequirements
				(RequirementSetId,															RequirementId)
SELECT DISTINCT	'SUK_DHARMA_KINGS_DISTRICT_IS_' || DistrictType || '_REQUIREMENTS',			RequirementId
FROM SukDharmaKingsData;
-------------------------------------
-- Requirements
-------------------------------------
INSERT INTO Requirements
		(RequirementId, 								RequirementType)
VALUES	('SUK_DHARMA_KINGS_PLOT_NEAR_DISTRICT',			'REQUIREMENT_PLOT_ADJACENT_TO_OWNER');
-------------------------------------
-- RequirementArguments
-------------------------------------
INSERT INTO RequirementArguments
		(RequirementId, 								Name,					Value)
VALUES	('SUK_DHARMA_KINGS_PLOT_NEAR_DISTRICT', 		'MinDistance',			1),
		('SUK_DHARMA_KINGS_PLOT_NEAR_DISTRICT', 		'MaxDistance',			2);
--==========================================================================================================================
														-- UNITS --
--==========================================================================================================================
INSERT INTO Units_XP2	
		(UnitType,							ResourceCost)
SELECT	'UNIT_SUK_TIBET_RTA_PA',			ResourceCost
FROM Units_XP2 WHERE UnitType = 'UNIT_HUNGARY_BLACK_ARMY';
--==========================================================================================================================
											-- NAMED PLACES --
--==========================================================================================================================
-- Types
--------------------------------------------------------------------
INSERT OR REPLACE INTO Types
		(Type,											Kind)
VALUES	("NAMED_RIVER_YARLUNG_TSANGPO",					"KIND_NAMED_RIVER"),
		("NAMED_RIVER_PARLUNG_TSANGPO",					"KIND_NAMED_RIVER"),
		("NAMED_RIVER_LHASA",							"KIND_NAMED_RIVER"),
		("NAMED_RIVER_NYANG",							"KIND_NAMED_RIVER"),
		("NAMED_MOUNTAIN_DANGLA",						"KIND_NAMED_MOUNTAIN"),
		("NAMED_MOUNTAIN_TANIANTAWENG",					"KIND_NAMED_MOUNTAIN"),
		("NAMED_MOUNTAIN_NYENCHEN_TANGLHA",				"KIND_NAMED_MOUNTAIN"),
		("NAMED_MOUNTAIN_NALAKANKAR_HIMAL",				"KIND_NAMED_MOUNTAIN"),
		("NAMED_MOUNTAIN_ROLWALING_HIMAL",				"KIND_NAMED_MOUNTAIN"),
		("NAMED_MOUNTAIN_GANESH_HIMAL",					"KIND_NAMED_MOUNTAIN"),
		("NAMED_MOUNTAIN_NAMCHA_BARWA_HIMAL",			"KIND_NAMED_MOUNTAIN"),
		("NAMED_MOUNTAIN_MAHALANGUR_HIMAL",				"KIND_NAMED_MOUNTAIN"),
		("NAMED_MOUNTAIN_KANGRI_GARPO",					"KIND_NAMED_MOUNTAIN"),
		("NAMED_VOLCANO_ASHIKULE_VOLCANIC_FIELD",		"KIND_NAMED_VOLCANO"),
		("NAMED_VOLCANO_BAMAOQIONGZONG",				"KIND_NAMED_VOLCANO"),
		("NAMED_VOLCANO_YONGBOHU",						"KIND_NAMED_VOLCANO"),
		("NAMED_VOLCANO_QIANGBAQIAN",					"KIND_NAMED_VOLCANO");
--------------------------------------------------------------------
-- NamedRivers
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedRivers
		(NamedRiverType,					Name)
VALUES	("NAMED_RIVER_YARLUNG_TSANGPO",		"LOC_NAMED_RIVER_YARLUNG_TSANGPO_NAME"),
		("NAMED_RIVER_PARLUNG_TSANGPO",		"LOC_NAMED_RIVER_PARLUNG_TSANGPO_NAME"),
		("NAMED_RIVER_LHASA",				"LOC_NAMED_RIVER_LHASA_NAME"),
		("NAMED_RIVER_NYANG",				"LOC_NAMED_RIVER_NYANG_NAME");
--------------------------------------------------------------------
-- NamedMountains
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedMountains
		(NamedMountainType,							Name)
VALUES	("NAMED_MOUNTAIN_DANGLA",					"LOC_NAMED_MOUNTAIN_DANGLA_NAME"),
		("NAMED_MOUNTAIN_TANIANTAWENG",				"LOC_NAMED_MOUNTAIN_TANIANTAWENG_NAME"),
		("NAMED_MOUNTAIN_NYENCHEN_TANGLHA",			"LOC_NAMED_MOUNTAIN_NYENCHEN_TANGLHA_NAME"),
		("NAMED_MOUNTAIN_NALAKANKAR_HIMAL",			"LOC_NAMED_MOUNTAIN_NALAKANKAR_HIMAL_NAME"),
		("NAMED_MOUNTAIN_ROLWALING_HIMAL",			"LOC_NAMED_MOUNTAIN_ROLWALING_HIMAL_NAME"),
		("NAMED_MOUNTAIN_GANESH_HIMAL",				"LOC_NAMED_MOUNTAIN_GANESH_HIMAL_NAME"),
		("NAMED_MOUNTAIN_NAMCHA_BARWA_HIMAL",		"LOC_NAMED_MOUNTAIN_NAMCHA_BARWA_HIMAL_NAME"),
		("NAMED_MOUNTAIN_MAHALANGUR_HIMAL",			"LOC_NAMED_MOUNTAIN_MAHALANGUR_HIMAL_NAME"),
		("NAMED_MOUNTAIN_KANGRI_GARPO",				"LOC_NAMED_MOUNTAIN_KANGRI_GARPO_NAME");
--------------------------------------------------------------------
-- NamedVolcanoes
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedVolcanoes
		(NamedVolcanoType,								Name)
VALUES	("NAMED_VOLCANO_ASHIKULE_VOLCANIC_FIELD",		"LOC_NAMED_VOLCANO_ASHIKULE_VOLCANIC_FIELD_NAME"),
		("NAMED_VOLCANO_BAMAOQIONGZONG",				"LOC_NAMED_VOLCANO_BAMAOQIONGZONG_NAME"),
		("NAMED_VOLCANO_YONGBOHU",						"LOC_NAMED_VOLCANO_YONGBOHU_NAME"),
		("NAMED_VOLCANO_QIANGBAQIAN",					"LOC_NAMED_VOLCANO_QIANGBAQIAN_NAME");
--------------------------------------------------------------------
-- NamedRiverCivilizations
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedRiverCivilizations
		(NamedRiverType,					CivilizationType)
VALUES	("NAMED_RIVER_YARLUNG_TSANGPO",		"CIVILIZATION_SUK_TIBET"),
		("NAMED_RIVER_PARLUNG_TSANGPO",		"CIVILIZATION_SUK_TIBET"),
		("NAMED_RIVER_LHASA",				"CIVILIZATION_SUK_TIBET"),
		("NAMED_RIVER_NYANG",				"CIVILIZATION_SUK_TIBET"),
		("NAMED_RIVER_YELLOW",				"CIVILIZATION_SUK_TIBET"),
		("NAMED_RIVER_MEKONG",				"CIVILIZATION_SUK_TIBET"),
		("NAMED_RIVER_SALWEEN",				"CIVILIZATION_SUK_TIBET"),
		("NAMED_RIVER_TARIM",				"CIVILIZATION_SUK_TIBET");
--------------------------------------------------------------------
-- NamedMountainCivilizations
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedMountainCivilizations
		(NamedMountainType,							CivilizationType)
VALUES	("NAMED_MOUNTAIN_DANGLA",					"CIVILIZATION_SUK_TIBET"),
		("NAMED_MOUNTAIN_TANIANTAWENG",				"CIVILIZATION_SUK_TIBET"),
		("NAMED_MOUNTAIN_NYENCHEN_TANGLHA",			"CIVILIZATION_SUK_TIBET"),
		("NAMED_MOUNTAIN_NALAKANKAR_HIMAL",			"CIVILIZATION_SUK_TIBET"),
		("NAMED_MOUNTAIN_ROLWALING_HIMAL",			"CIVILIZATION_SUK_TIBET"),
		("NAMED_MOUNTAIN_GANESH_HIMAL",				"CIVILIZATION_SUK_TIBET"),
		("NAMED_MOUNTAIN_NAMCHA_BARWA_HIMAL",		"CIVILIZATION_SUK_TIBET"),
		("NAMED_MOUNTAIN_MAHALANGUR_HIMAL",			"CIVILIZATION_SUK_TIBET"),
		("NAMED_MOUNTAIN_KANGRI_GARPO",				"CIVILIZATION_SUK_TIBET"),
		("NAMED_MOUNTAIN_HIMALAYAS",				"CIVILIZATION_SUK_TIBET"),
		("NAMED_MOUNTAIN_KUNLUN",					"CIVILIZATION_SUK_TIBET");
--------------------------------------------------------------------
-- NamedVolcanoCivilizations
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedVolcanoCivilizations
		(NamedVolcanoType,								CivilizationType)
VALUES	("NAMED_VOLCANO_ASHIKULE_VOLCANIC_FIELD",		"CIVILIZATION_SUK_TIBET"),
		("NAMED_VOLCANO_BAMAOQIONGZONG",				"CIVILIZATION_SUK_TIBET"),
		("NAMED_VOLCANO_YONGBOHU",						"CIVILIZATION_SUK_TIBET"),
		("NAMED_VOLCANO_QIANGBAQIAN",					"CIVILIZATION_SUK_TIBET");
--------------------------------------------------------------------
-- NamedDesertCivilizations
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedDesertCivilizations
		(NamedDesertType,				CivilizationType)
VALUES	("NAMED_DESERT_TAKLAMAKAN",		"CIVILIZATION_SUK_TIBET");
--==========================================================================================================================
--==========================================================================================================================