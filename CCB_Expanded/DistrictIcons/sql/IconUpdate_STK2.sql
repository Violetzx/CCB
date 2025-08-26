--==========================================================================================================================
-- ICONS
--==========================================================================================================================
-- IconTextureAtlases
-------------------------------------    
INSERT INTO IconTextureAtlases    
        (Name,                    IconSize,    IconsPerRow,    IconsPerColumn,        Filename)
VALUES 	('ICON_ATLAS_BDI_DIPLOMATIC_QUARTER',		256,		1,				1,			'ConsulatesDistricts256.dds'),
		('ICON_ATLAS_BDI_DIPLOMATIC_QUARTER',		128,		1,				1,			'ConsulatesDistricts128.dds'),
		('ICON_ATLAS_BDI_DIPLOMATIC_QUARTER',		80,			1,				1,			'ConsulatesDistricts80.dds'),
		('ICON_ATLAS_BDI_DIPLOMATIC_QUARTER',		50,			1,				1,			'ConsulatesDistricts50.dds'),
		('ICON_ATLAS_BDI_DIPLOMATIC_QUARTER',		38,			1,				1,			'ConsulatesDistricts38.dds'),
		('ICON_ATLAS_BDI_DIPLOMATIC_QUARTER',		32,			1,				1,			'ConsulatesDistricts32.dds');    

DELETE FROM IconAliases
WHERE Name = 'ICON_DISTRICT_DIPLOMATIC_QUARTER';

-------------------------------------
-- IconDefinitions
-------------------------------------    
INSERT OR REPLACE INTO IconDefinitions    
        (Name,                                                            Atlas,                     'Index')
VALUES  ('ICON_DISTRICT_DIPLOMATIC_QUARTER',										'ICON_ATLAS_BDI_DIPLOMATIC_QUARTER',	0);

--------------------------------------
--IconAliases
--------------------------------------


--==========================================================================================================================
--==========================================================================================================================