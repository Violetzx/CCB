--==========================================================================================================================
-- ICONS
--==========================================================================================================================
-- IconTextureAtlases
-------------------------------------    
INSERT INTO IconTextureAtlases    
        (Name,												IconSize,		IconsPerRow,    IconsPerColumn,        Filename)
VALUES 	('ICON_ATLAS_BDI_NEWPRESERVE',						256,			1,				1,						'LeuPreserve_256.dds'),
		('ICON_ATLAS_BDI_NEWPRESERVE',						128,			1,				1,						'LeuPreserve_128.dds'),
		('ICON_ATLAS_BDI_NEWPRESERVE',						80,				1,				1,						'LeuPreserve_80.dds'),
		('ICON_ATLAS_BDI_NEWPRESERVE',						50,				1,				1,						'LeuPreserve_50.dds'),
		('ICON_ATLAS_BDI_NEWPRESERVE',						38,				1,				1,						'LeuPreserve_38.dds'),
		('ICON_ATLAS_BDI_NEWPRESERVE',						32,				1,				1,						'LeuPreserve_32.dds');

INSERT INTO IconTextureAtlases	
		(Name,								Baseline,	IconSize,	IconsPerRow,	IconsPerColumn,		Filename)
VALUES  ('ICON_ATLAS_BDI_NEWPRESERVE',				6,			22,	 		1,				1,					'LeuPreserve_22');		
-------------------------------------
-- IconDefinitions
-------------------------------------    
INSERT OR REPLACE INTO IconDefinitions    
        (Name,										Atlas,											'Index')
VALUES  ('ICON_DISTRICT_PRESERVE',					'ICON_ATLAS_BDI_NEWPRESERVE',							0),
		('DISTRICT_PRESERVE',						'ICON_ATLAS_BDI_NEWPRESERVE',							0);	

--==========================================================================================================================
--==========================================================================================================================