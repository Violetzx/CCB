--==========================================================================================================================
-- ICONS
--==========================================================================================================================
-- IconTextureAtlases
-------------------------------------    
INSERT INTO IconTextureAtlases    
        (Name,                    IconSize,    IconsPerRow,    IconsPerColumn,        Filename)
VALUES  ('ICON_ATLAS_BDI',        256,         4,                2,                    'UniqueDistrictAtlas256.dds'),
        ('ICON_ATLAS_BDI',        128,         4,                2,                    'UniqueDistrictAtlas128.dds'),
        ('ICON_ATLAS_BDI',        80,             4,                2,                    'UniqueDistrictAtlas80.dds'),
        ('ICON_ATLAS_BDI',        50,             4,                2,                    'UniqueDistrictAtlas50.dds'),
        ('ICON_ATLAS_BDI',        38,             4,                2,                    'UniqueDistrictAtlas38.dds'),
        ('ICON_ATLAS_BDI',        32,             4,                2,                    'UniqueDistrictAtlas32.dds'),
		
		('ICON_ATLAS_BDI_SAMBADROME',	256,	1,				1,						'Carnival_256.dds'),
		('ICON_ATLAS_BDI_SAMBADROME',	128,	1,				1,						'Carnival_128.dds'),
		('ICON_ATLAS_BDI_SAMBADROME',	80,		1,				1,						'Carnival_80.dds'),
		('ICON_ATLAS_BDI_SAMBADROME',	50,		1,				1,						'Carnival_50.dds'),
		('ICON_ATLAS_BDI_SAMBADROME',	38,		1,				1,						'Carnival_38.dds'),
		('ICON_ATLAS_BDI_SAMBADROME',	32,		1,				1,						'Carnival_32.dds');

-------------------------------------
-- IconDefinitions
-------------------------------------    
INSERT OR REPLACE INTO IconDefinitions    
        (Name,                                                            Atlas,                     'Index')
VALUES  ('ICON_DISTRICT_ACROPOLIS',                                        'ICON_ATLAS_BDI',        0),
        ('ICON_DISTRICT_BATH',                                            'ICON_ATLAS_BDI',        1),
        ('ICON_DISTRICT_STREET_CARNIVAL',                                'ICON_ATLAS_BDI_SAMBADROME',        0),
        ('ICON_DISTRICT_HANSA',                                            'ICON_ATLAS_BDI',        3),
        ('ICON_DISTRICT_LAVRA',                                            'ICON_ATLAS_BDI',        4),
        ('ICON_DISTRICT_MBANZA',                                        'ICON_ATLAS_BDI',        5),
        ('ICON_DISTRICT_ROYAL_NAVY_DOCKYARD',                            'ICON_ATLAS_BDI',        6);

--------------------------------------
--IconAliases
--------------------------------------


--==========================================================================================================================
--==========================================================================================================================