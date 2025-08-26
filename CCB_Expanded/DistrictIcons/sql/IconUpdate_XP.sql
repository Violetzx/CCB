--==========================================================================================================================
-- ICONS
--==========================================================================================================================
-- IconTextureAtlases
-------------------------------------
INSERT INTO IconTextureAtlases
        (Name,                    			IconSize,    IconsPerRow,    IconsPerColumn,        Filename)
VALUES 	('ICON_ATLAS_BDI_PROMENADE',		256,		1,				1,						'Copacabana_256.dds'),
		('ICON_ATLAS_BDI_PROMENADE',		128,		1,				1,						'Copacabana_128.dds'),
		('ICON_ATLAS_BDI_PROMENADE',		80,			1,				1,						'Copacabana_80.dds'),
		('ICON_ATLAS_BDI_PROMENADE',		50,			1,				1,						'Copacabana_50.dds'),
		('ICON_ATLAS_BDI_PROMENADE',		38,			1,				1,						'Copacabana_38.dds'),
		('ICON_ATLAS_BDI_PROMENADE',		32,			1,				1,						'Copacabana_32.dds'),

		('ICON_ATLAS_BDI_IKANDA',			256,		1,				1,						'Ikanda_256.dds'),
		('ICON_ATLAS_BDI_IKANDA',			128,		1,				1,						'Ikanda_128.dds'),
		('ICON_ATLAS_BDI_IKANDA',			80,			1,				1,						'Ikanda_80.dds'),
		('ICON_ATLAS_BDI_IKANDA',			50,			1,				1,						'Ikanda_50.dds'),
		('ICON_ATLAS_BDI_IKANDA',			38,			1,				1,						'Ikanda_38.dds'),
		('ICON_ATLAS_BDI_IKANDA',			32,			1,				1,						'Ikanda_32.dds'),

		('ICON_ATLAS_BDI_SEOWON',			256,		1,				1,						'Seowon_256.dds'),
		('ICON_ATLAS_BDI_SEOWON',			128,		1,				1,						'Seowon_128.dds'),
		('ICON_ATLAS_BDI_SEOWON',			80,			1,				1,						'Seowon_80.dds'),
		('ICON_ATLAS_BDI_SEOWON',			50,			1,				1,						'Seowon_50.dds'),
		('ICON_ATLAS_BDI_SEOWON',			38,			1,				1,						'Seowon_38.dds'),
		('ICON_ATLAS_BDI_SEOWON',			32,			1,				1,						'Seowon_32.dds');
-------------------------------------
-- IconDefinitions
-------------------------------------
INSERT OR REPLACE INTO IconDefinitions	
		(Name,										Atlas, 						'Index')
VALUES  ('ICON_DISTRICT_SEOWON',					'ICON_ATLAS_BDI_SEOWON',	0),
		('ICON_DISTRICT_IKANDA',					'ICON_ATLAS_BDI_IKANDA',	0),
		('ICON_DISTRICT_WATER_STREET_CARNIVAL',		'ICON_ATLAS_BDI_PROMENADE',	0),
		('ICON_DISTRICT_LEU_PROMENADE',				'ICON_ATLAS_BDI_PROMENADE',	0);
--==========================================================================================================================
--==========================================================================================================================