--==========================================================================================================================
-- ICONS
--==========================================================================================================================
-- IconTextureAtlases
-------------------------------------    
INSERT INTO IconTextureAtlases    
        (Name,                    IconSize,    IconsPerRow,    IconsPerColumn,        Filename)
VALUES 	('ICON_ATLAS_BDI_OBSERVATORY',		256,		1,				1,			'Observatory_256.dds'),
		('ICON_ATLAS_BDI_OBSERVATORY',		128,		1,				1,			'Observatory_128.dds'),
		('ICON_ATLAS_BDI_OBSERVATORY',		80,			1,				1,			'Observatory_80.dds'),
		('ICON_ATLAS_BDI_OBSERVATORY',		50,			1,				1,			'Observatory_50.dds'),
		('ICON_ATLAS_BDI_OBSERVATORY',		38,			1,				1,			'Observatory_38.dds'),
		('ICON_ATLAS_BDI_OBSERVATORY',		32,			1,				1,			'Observatory_32.dds');    

DELETE FROM IconAliases
WHERE Name = 'ICON_DISTRICT_OBSERVATORY';

-------------------------------------
-- IconDefinitions
-------------------------------------    
INSERT OR REPLACE INTO IconDefinitions    
        (Name,                                                            Atlas,                     'Index')
VALUES  ('ICON_DISTRICT_OBSERVATORY',										'ICON_ATLAS_BDI_OBSERVATORY',	0);

--------------------------------------
--IconAliases
--------------------------------------


--==========================================================================================================================
--==========================================================================================================================