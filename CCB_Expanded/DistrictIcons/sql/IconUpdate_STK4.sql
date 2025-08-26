--==========================================================================================================================
-- ICONS
--==========================================================================================================================
-- IconTextureAtlases
-------------------------------------    
INSERT INTO IconTextureAtlases    
        (Name,								IconSize,    IconsPerRow,    IconsPerColumn,        Filename)
VALUES 	('ICON_ATLAS_BDI_THANH',				256,		2,				1,			'Thanh_256.dds'),
		('ICON_ATLAS_BDI_THANH',				128,		2,				1,			'Thanh_128.dds'),
		('ICON_ATLAS_BDI_THANH',				80,			2,				1,			'Thanh_80.dds'),
		('ICON_ATLAS_BDI_THANH',				50,			2,				1,			'Thanh_50.dds'),
		('ICON_ATLAS_BDI_THANH',				38,			2,				1,			'Thanh_38.dds'),
		('ICON_ATLAS_BDI_THANH',				32,			2,				1,			'Thanh_32.dds');    

--DELETE FROM IconAliases
--WHERE Name = 'ICON_DISTRICT_OBSERVATORY';

-------------------------------------
-- IconDefinitions
-------------------------------------    
INSERT OR REPLACE INTO IconDefinitions    
        (Name,                                   Atlas,                'Index')
VALUES  ('ICON_DISTRICT_THANH',					'ICON_ATLAS_BDI_THANH',	0);

--------------------------------------
--IconAliases
--------------------------------------


--==========================================================================================================================
--==========================================================================================================================