--==========================================================================================================================
-- ICONS
--==========================================================================================================================
-- IconTextureAtlases
-------------------------------------    
INSERT INTO IconTextureAtlases    
        (Name,                    IconSize,    IconsPerRow,    IconsPerColumn,        Filename)
VALUES 	('ICON_ATLAS_BDI_COTHON',		256,		1,				1,			'Cothon_256.dds'),
		('ICON_ATLAS_BDI_COTHON',		128,		1,				1,			'Cothon_128.dds'),
		('ICON_ATLAS_BDI_COTHON',		80,			1,				1,			'Cothon_80.dds'),
		('ICON_ATLAS_BDI_COTHON',		50,			1,				1,			'Cothon_50.dds'),
		('ICON_ATLAS_BDI_COTHON',		38,			1,				1,			'Cothon_38.dds'),
		('ICON_ATLAS_BDI_COTHON',		32,			1,				1,			'Cothon_32.dds'),

		('ICON_ATLAS_BDI_SUGUBA',	256,	1,				1,						'Suguba_256.dds'),
		('ICON_ATLAS_BDI_SUGUBA',	128,	1,				1,						'Suguba_128.dds'),
		('ICON_ATLAS_BDI_SUGUBA',	80,		1,				1,						'Suguba_80.dds'),
		('ICON_ATLAS_BDI_SUGUBA',	50,		1,				1,						'Suguba_50.dds'),
		('ICON_ATLAS_BDI_SUGUBA',	38,		1,				1,						'Suguba_38.dds'),
		('ICON_ATLAS_BDI_SUGUBA',	32,		1,				1,						'Suguba_32.dds');    

DELETE FROM IconAliases
WHERE Name = 'ICON_DISTRICT_COTHON';

-------------------------------------
-- IconDefinitions
-------------------------------------    
INSERT OR REPLACE INTO IconDefinitions    
        (Name,                                                            Atlas,                     'Index')
VALUES  ('ICON_DISTRICT_SUGUBA',										'ICON_ATLAS_BDI_SUGUBA',	0),
		('ICON_DISTRICT_COTHON',										'ICON_ATLAS_BDI_COTHON',	0);

--------------------------------------
--IconAliases
--------------------------------------


--==========================================================================================================================
--==========================================================================================================================