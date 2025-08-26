--==========================================================================================================================
-- TYPES
--==========================================================================================================================
INSERT OR REPLACE INTO Types
			(Type,								Kind)
--------------------------------------------------------------------
-- NamedRivers
--------------------------------------------------------------------
VALUES		('NAMED_RIVER_RUVUMA',				'KIND_NAMED_RIVER'),
			('NAMED_RIVER_RUFIJI',				'KIND_NAMED_RIVER'),
			('NAMED_RIVER_TANA',				'KIND_NAMED_RIVER'),
			('NAMED_RIVER_PANGANI',				'KIND_NAMED_RIVER'),
			('NAMED_RIVER_SHEBELLE',			'KIND_NAMED_RIVER'),
--------------------------------------------------------------------
-- NamedMountains
--------------------------------------------------------------------
			('NAMED_MOUNTAIN_USAMBARA',			'KIND_NAMED_MOUNTAIN'),
			('NAMED_MOUNTAIN_NGURU',			'KIND_NAMED_MOUNTAIN'),
			('NAMED_MOUNTAIN_ULUGURU',			'KIND_NAMED_MOUNTAIN'),
--------------------------------------------------------------------
-- NamedVolcanoes
--------------------------------------------------------------------
			('NAMED_VOLCANO_KARTHALA',			'KIND_NAMED_VOLCANO'),
--------------------------------------------------------------------
-- NamedLakes
--------------------------------------------------------------------
			("NAMED_LAKE_MALAWI",				"KIND_NAMED_LAKE"),
--------------------------------------------------------------------
-- NamedSeas
--------------------------------------------------------------------
			("NAMED_SEA_SOMALI",				"KIND_NAMED_SEA"),
			("NAMED_SEA_OF_ZANJ",				"KIND_NAMED_SEA"),
			("NAMED_SEA_MENAI_BAY",				"KIND_NAMED_SEA"),
			("NAMED_SEA_CHAKE_CHAKE_BAY",		"KIND_NAMED_SEA"),
			("NAMED_SEA_CHWAKA_BAY",			"KIND_NAMED_SEA"),
			("NAMED_SEA_MANZA_BAY",				"KIND_NAMED_SEA"),
			("NAMED_SEA_WINAM_GULF",			"KIND_NAMED_SEA");
--==========================================================================================================================
-- NAMED_PLACES
--==========================================================================================================================
--------------------------------------------------------------------
-- NamedRivers
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedRivers
			(NamedRiverType,										Name)
VALUES		('NAMED_RIVER_RUVUMA',									'LOC_NAMED_RIVER_RUVUMA_NAME'),
			('NAMED_RIVER_RUFIJI',									'LOC_NAMED_RIVER_RUFIJI_NAME'),
			('NAMED_RIVER_TANA',									'LOC_NAMED_RIVER_TANA_NAME'),
			('NAMED_RIVER_PANGANI',									'LOC_NAMED_RIVER_PANGANI_NAME'),
			('NAMED_RIVER_SHEBELLE',								'LOC_NAMED_RIVER_SHEBELLE_NAME');
--------------------------------------------------------------------
-- NamedMountains
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedMountains
			(NamedMountainType,										Name)
VALUES		('NAMED_MOUNTAIN_USAMBARA',								'LOC_NAMED_MOUNTAIN_USAMBARA_NAME'),
			('NAMED_MOUNTAIN_NGURU',								'LOC_NAMED_MOUNTAIN_NGURU_NAME'),
			('NAMED_MOUNTAIN_ULUGURU',								'LOC_NAMED_MOUNTAIN_ULUGURU_NAME');
--------------------------------------------------------------------
-- NamedVolcanoes
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedVolcanoes
			(NamedVolcanoType,										Name)
VALUES		('NAMED_VOLCANO_KARTHALA',								'LOC_NAMED_VOLCANO_KARTHALA_NAME');
--------------------------------------------------------------------
-- NamedLakes
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedLakes
		(NamedLakeType,				Name)
VALUES	("NAMED_LAKE_MALAWI",		"LOC_NAMED_LAKE_MALAWI_NAME");
--------------------------------------------------------------------
-- NamedSeas
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedSeas
		(NamedSeaType,						Name)
VALUES	("NAMED_SEA_SOMALI",				"LOC_NAMED_SEA_SOMALI_NAME"),
		("NAMED_SEA_OF_ZANJ",				"LOC_NAMED_SEA_OF_ZANJ_NAME"),
		("NAMED_SEA_MENAI_BAY",				"LOC_NAMED_SEA_MENAI_BAY_NAME"),
		("NAMED_SEA_CHAKE_CHAKE_BAY",		"LOC_NAMED_SEA_CHAKE_CHAKE_BAY_NAME"),
		("NAMED_SEA_CHWAKA_BAY",			"LOC_NAMED_SEA_CHWAKA_BAY_NAME"),
		("NAMED_SEA_MANZA_BAY",				"LOC_NAMED_SEA_MANZA_BAY_NAME"),
		("NAMED_SEA_WINAM_GULF",			"LOC_NAMED_SEA_WINAM_GULF_NAME");
--==========================================================================================================================
-- CIVLIZATION_NAMED_PLACES
--==========================================================================================================================
--------------------------------------------------------------------
-- NamedRivers
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedRiverCivilizations
			(NamedRiverType,								CivilizationType)
VALUES		('NAMED_RIVER_RUVUMA',							'CIVILIZATION_SUK_SWAHILI'),
			('NAMED_RIVER_RUFIJI',							'CIVILIZATION_SUK_SWAHILI'),
			('NAMED_RIVER_TANA',							'CIVILIZATION_SUK_SWAHILI'),
			('NAMED_RIVER_PANGANI',							'CIVILIZATION_SUK_SWAHILI'),
			('NAMED_RIVER_SHEBELLE',						'CIVILIZATION_SUK_SWAHILI'),
			('NAMED_RIVER_ZAMBEZI',							'CIVILIZATION_SUK_SWAHILI');
--------------------------------------------------------------------
-- NamedMountains
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedMountainCivilizations
			(NamedMountainType,								CivilizationType)
VALUES		('NAMED_MOUNTAIN_USAMBARA',						'CIVILIZATION_SUK_SWAHILI'),
			('NAMED_MOUNTAIN_NGURU',						'CIVILIZATION_SUK_SWAHILI'),
			('NAMED_MOUNTAIN_ULUGURU',						'CIVILIZATION_SUK_SWAHILI');
--------------------------------------------------------------------
-- NamedVolcanoes
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedVolcanoCivilizations
			(NamedVolcanoType,								CivilizationType)
VALUES		('NAMED_VOLCANO_KARTHALA',						'CIVILIZATION_SUK_SWAHILI');
--------------------------------------------------------------------
-- NamedLakeCivilizations
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedLakeCivilizations
		(NamedLakeType,						CivilizationType)
VALUES	("NAMED_LAKE_LAKE_TURKANA",			"CIVILIZATION_SUK_SWAHILI"),
		("NAMED_LAKE_LAKE_TANGANYIKA",		"CIVILIZATION_SUK_SWAHILI"),
		("NAMED_LAKE_LAKE_VICTORIA",		"CIVILIZATION_SUK_SWAHILI"),
		("NAMED_LAKE_MALAWI",				"CIVILIZATION_SUK_SWAHILI");
--------------------------------------------------------------------
-- NamedSeaCivilizations
--------------------------------------------------------------------
INSERT OR REPLACE INTO NamedSeaCivilizations
		(NamedSeaType,						CivilizationType)
VALUES	("NAMED_SEA_SOMALI",				"CIVILIZATION_SUK_SWAHILI"),
		("NAMED_SEA_OF_ZANJ",				"CIVILIZATION_SUK_SWAHILI"),
		("NAMED_SEA_MENAI_BAY",				"CIVILIZATION_SUK_SWAHILI"),
		("NAMED_SEA_CHAKE_CHAKE_BAY",		"CIVILIZATION_SUK_SWAHILI"),
		("NAMED_SEA_CHWAKA_BAY",			"CIVILIZATION_SUK_SWAHILI"),
		("NAMED_SEA_MANZA_BAY",				"CIVILIZATION_SUK_SWAHILI"),
		("NAMED_SEA_WINAM_GULF",			"CIVILIZATION_SUK_SWAHILI");
--==========================================================================================================================
--==========================================================================================================================