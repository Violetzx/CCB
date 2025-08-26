--=============================================================================================================
-- RESOURCES
--=============================================================================================================
-- Types
-------------------------------------	
INSERT INTO Types	
		(Type,							Kind)
VALUES	('RESOURCE_P0K_PENGUINS',		'KIND_RESOURCE'),
		('RESOURCE_CVS_POMEGRANATES',	'KIND_RESOURCE'),
		('RESOURCE_P0K_PAPYRUS',		'KIND_RESOURCE'),
		('RESOURCE_P0K_MAPLE',			'KIND_RESOURCE'),
		('RESOURCE_P0K_OPAL',			'KIND_RESOURCE'),
		('RESOURCE_P0K_PLUMS',			'KIND_RESOURCE');
	--	('RESOURCE_P0K_FIGS',			'KIND_RESOURCE');
-------------------------------------
-- TypeTags
-------------------------------------
INSERT INTO TypeTags
			(Type,								Tag)
VALUES		('RESOURCE_P0K_PENGUINS',			'CLASS_GOLD'),
			('RESOURCE_P0K_PENGUINS',			'CLASS_SCIENCE'),
			('RESOURCE_CVS_POMEGRANATES',		'CLASS_GOLD'),
			('RESOURCE_CVS_POMEGRANATES',		'CLASS_FOOD'),
			('RESOURCE_CVS_POMEGRANATES',		'CLASS_ORAL_TRADITION'),
			('RESOURCE_P0K_PAPYRUS',			'CLASS_GOLD'),
			('RESOURCE_P0K_PAPYRUS',			'CLASS_SCIENCE'),
			('RESOURCE_P0K_PAPYRUS',			'CLASS_GODDESS_OF_FESTIVALS'),
			('RESOURCE_P0K_MAPLE',				'CLASS_GOLD'),
			('RESOURCE_P0K_MAPLE',				'CLASS_FOOD'),
			('RESOURCE_P0K_MAPLE',				'CLASS_GODDESS_OF_FESTIVALS'),
			('RESOURCE_P0K_OPAL',				'CLASS_GOLD'),
			('RESOURCE_P0K_OPAL',				'CLASS_PRODUCTION'),
			('RESOURCE_P0K_PLUMS',				'CLASS_GOLD'),	
			('RESOURCE_P0K_PLUMS',				'CLASS_FOOD'),
			('RESOURCE_P0K_PLUMS',				'CLASS_CULTURE'),
			('RESOURCE_P0K_PLUMS',				'CLASS_ORAL_TRADITION');
		--	('RESOURCE_P0K_FIGS',				'CLASS_GOLD'),	
		--	('RESOURCE_P0K_FIGS',				'CLASS_CULTURE'),				
		--	('RESOURCE_P0K_FIGS',				'CLASS_FOOD'),
		--	('RESOURCE_P0K_FIGS',				'CLASS_ORAL_TRADITION');
-------------------------------------
-- Resources
-------------------------------------					
INSERT INTO Resources			
		(ResourceType,					Name,									ResourceClassType,			NoRiver,	Happiness,		Frequency)
VALUES	('RESOURCE_P0K_PENGUINS',		'LOC_RESOURCE_P0K_PENGUINS_NAME',		'RESOURCECLASS_LUXURY',		0,			4,				2), 
		('RESOURCE_CVS_POMEGRANATES',	'LOC_RESOURCE_CVS_POMEGRANATES_NAME',	'RESOURCECLASS_LUXURY',		0,			4,				2),
		('RESOURCE_P0K_PAPYRUS',		'LOC_RESOURCE_P0K_PAPYRUS_NAME',		'RESOURCECLASS_LUXURY',		0,			4,				2), 
		('RESOURCE_P0K_MAPLE',			'LOC_RESOURCE_P0K_MAPLE_NAME',			'RESOURCECLASS_LUXURY',		0,			4,				2), 
		('RESOURCE_P0K_OPAL',			'LOC_RESOURCE_P0K_OPAL_NAME',			'RESOURCECLASS_LUXURY',		0,			4,				2), 
		('RESOURCE_P0K_PLUMS',			'LOC_RESOURCE_P0K_PLUMS_NAME',			'RESOURCECLASS_LUXURY',		0,			4,				2);
	--	('RESOURCE_P0K_FIGS',			'LOC_RESOURCE_P0K_FIGS_NAME',			'RESOURCECLASS_LUXURY',		0,			4,				2);
-------------------------------------
-- Resource_ValidTerrains
-------------------------------------	
INSERT INTO Resource_ValidTerrains
			(ResourceType,						TerrainType)
VALUES		('RESOURCE_P0K_PENGUINS',			'TERRAIN_GRASS'),
			('RESOURCE_P0K_PENGUINS',			'TERRAIN_GRASS_HILLS'),
			('RESOURCE_P0K_PENGUINS',			'TERRAIN_PLAINS'),
			('RESOURCE_P0K_PENGUINS',			'TERRAIN_PLAINS_HILLS'),
			('RESOURCE_P0K_PENGUINS',			'TERRAIN_TUNDRA'),
			('RESOURCE_P0K_PENGUINS',			'TERRAIN_TUNDRA_HILLS'),
			('RESOURCE_CVS_POMEGRANATES',		'TERRAIN_GRASS'),
			('RESOURCE_CVS_POMEGRANATES',		'TERRAIN_PLAINS'),
			('RESOURCE_CVS_POMEGRANATES',		'TERRAIN_PLAINS_HILLS'),
			('RESOURCE_P0K_MAPLE',				'TERRAIN_GRASS'),
			('RESOURCE_P0K_MAPLE',				'TERRAIN_GRASS_HILLS'),
			('RESOURCE_P0K_MAPLE',				'TERRAIN_PLAINS'),
			('RESOURCE_P0K_MAPLE',				'TERRAIN_PLAINS_HILLS'),
			('RESOURCE_P0K_OPAL',				'TERRAIN_PLAINS'),
			('RESOURCE_P0K_OPAL',				'TERRAIN_PLAINS_HILLS'),
			('RESOURCE_P0K_OPAL',				'TERRAIN_DESERT_HILLS'),
			('RESOURCE_P0K_OPAL',				'TERRAIN_TUNDRA_HILLS'),
			('RESOURCE_P0K_PLUMS',				'TERRAIN_GRASS'),
			('RESOURCE_P0K_PLUMS',				'TERRAIN_GRASS_HILLS'),
			('RESOURCE_P0K_PLUMS',				'TERRAIN_PLAINS');
		--	('RESOURCE_P0K_FIGS',				'TERRAIN_GRASS'),
		--	('RESOURCE_P0K_FIGS',				'TERRAIN_PLAINS'),
		--	('RESOURCE_P0K_FIGS',				'TERRAINS_PLAINS_HILLS');
-------------------------------------
-- Resource_ValidFeatures
-------------------------------------
INSERT INTO Resource_ValidFeatures
		(ResourceType,							FeatureType)
VALUES	('RESOURCE_P0K_PAPYRUS',				'FEATURE_FLOODPLAINS'),
		('RESOURCE_P0K_PAPYRUS',				'FEATURE_MARSH');

INSERT INTO Resource_ValidFeatures
		(ResourceType,							FeatureType)
SELECT	'RESOURCE_P0K_PAPYRUS',					'FEATURE_FLOODPLAINS_GRASSLAND' FROM Features WHERE FeatureType='FEATURE_FLOODPLAINS_GRASSLAND';

INSERT INTO Resource_ValidFeatures
		(ResourceType,							FeatureType)
SELECT	'RESOURCE_P0K_PAPYRUS',					'FEATURE_FLOODPLAINS_PLAINS' FROM Features WHERE FeatureType='FEATURE_FLOODPLAINS_PLAINS';

INSERT INTO Resource_ValidFeatures
		(ResourceType,							FeatureType)
SELECT	'RESOURCE_CVS_POMEGRANATES',			'FEATURE_FLOODPLAINS_GRASSLAND' FROM Features WHERE FeatureType='FEATURE_FLOODPLAINS_GRASSLAND';

INSERT INTO Resource_ValidFeatures
		(ResourceType,							FeatureType)
SELECT	'RESOURCE_CVS_POMEGRANATES',			'FEATURE_FLOODPLAINS_PLAINS' FROM Features WHERE FeatureType='FEATURE_FLOODPLAINS_PLAINS';

--INSERT INTO Resource_ValidFeatures
--		(ResourceType,							FeatureType)
--SELECT	'RESOURCE_P0K_FIGS',					'FEATURE_FLOODPLAINS_GRASSLAND' FROM Features WHERE FeatureType='FEATURE_FLOODPLAINS_GRASSLAND';

--INSERT INTO Resource_ValidFeatures
--		(ResourceType,							FeatureType)
--SELECT	'RESOURCE_P0K_FIGS',					'FEATURE_FLOODPLAINS_PLAINS' FROM Features WHERE FeatureType='FEATURE_FLOODPLAINS_PLAINS';
-------------------------------------
-- Resource_YieldChanges
-------------------------------------	
INSERT INTO Resource_YieldChanges	
		(ResourceType,							YieldType,						YieldChange)
VALUES	('RESOURCE_P0K_PENGUINS',				'YIELD_SCIENCE',				1),
		('RESOURCE_CVS_POMEGRANATES',			'YIELD_FAITH',					1),
		('RESOURCE_CVS_POMEGRANATES',			'YIELD_FOOD',					1),
		('RESOURCE_P0K_PAPYRUS',				'YIELD_SCIENCE',				1),
		('RESOURCE_P0K_MAPLE',					'YIELD_FOOD',					1),
		('RESOURCE_P0K_MAPLE',					'YIELD_GOLD',					1),
		('RESOURCE_P0K_OPAL',					'YIELD_GOLD',					3),
		('RESOURCE_P0K_PLUMS',					'YIELD_CULTURE',				1),
		('RESOURCE_P0K_PLUMS',					'YIELD_FOOD',					1);
	--	('RESOURCE_P0K_FIGS',					'YIELD_CULTURE',				1),
	--	('RESOURCE_P0K_FIGS',					'YIELD_FOOD',					1);
-------------------------------------
-- Improvement_ValidResources
-------------------------------------	
INSERT INTO Improvement_ValidResources	
		(ImprovementType,				ResourceType,						MustRemoveFeature)
VALUES	('IMPROVEMENT_CAMP',			'RESOURCE_P0K_PENGUINS',			0),
		('IMPROVEMENT_PLANTATION',		'RESOURCE_CVS_POMEGRANATES',		0),
		('IMPROVEMENT_PLANTATION',		'RESOURCE_P0K_PAPYRUS',				0),
		('IMPROVEMENT_PLANTATION',		'RESOURCE_P0K_MAPLE',				0),
		('IMPROVEMENT_MINE',			'RESOURCE_P0K_OPAL',				0),
		('IMPROVEMENT_PLANTATION',		'RESOURCE_P0K_PLUMS',				0);
	--	('IMPROVEMENT_PLANTATION',		'RESOURCE_P0K_FIGS',				0);

--Let Resourceful maple override this one
DELETE FROM Resources
WHERE ResourceType = 'RESOURCE_P0K_MAPLE' AND
EXISTS (SELECT * FROM Resources WHERE ResourceType='RESOURCE_MAPLE');