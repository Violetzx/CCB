--==========================================================================================================================
-- ICONS
--==========================================================================================================================
-- IconTextureAtlases
-------------------------------------    
INSERT INTO IconTextureAtlases    
        (Name,								IconSize,    IconsPerRow,    IconsPerColumn,        Filename)
VALUES 	('ICON_ATLAS_BDI_STK3',				256,		2,				1,			'STK3_256.dds'),
		('ICON_ATLAS_BDI_STK3',				128,		2,				1,			'STK3_128.dds'),
		('ICON_ATLAS_BDI_STK3',				80,			2,				1,			'STK3_80.dds'),
		('ICON_ATLAS_BDI_STK3',				50,			2,				1,			'STK3_50.dds'),
		('ICON_ATLAS_BDI_STK3',				38,			2,				1,			'STK3_38.dds'),
		('ICON_ATLAS_BDI_STK3',				32,			2,				1,			'STK3_32.dds');    

--DELETE FROM IconAliases
--WHERE Name = 'ICON_DISTRICT_OBSERVATORY';

-------------------------------------
-- IconDefinitions
-------------------------------------    
INSERT OR REPLACE INTO IconDefinitions    
        (Name,                                   Atlas,                'Index')
VALUES  ('ICON_DISTRICT_HIPPODROME',			'ICON_ATLAS_BDI_STK3',	0),
		('ICON_DISTRICT_OPPIDUM',			'ICON_ATLAS_BDI_STK3',	1);

--------------------------------------
--IconAliases
--------------------------------------


--==========================================================================================================================
--==========================================================================================================================