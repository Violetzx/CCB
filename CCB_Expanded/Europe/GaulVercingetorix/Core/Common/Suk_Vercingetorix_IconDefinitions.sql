--==========================================================================================================================
-- ICONS
--==========================================================================================================================
-- IconTextureAtlases
-------------------------------------	
INSERT INTO IconTextureAtlases	
		(Name,										IconSize,	IconsPerRow,	IconsPerColumn,		Filename)
VALUES  ('ICON_ATLAS_SUK_GAUL',						256,	 	5,				1,					'Suk_Gaul_Atlas_256.dds'),
		('ICON_ATLAS_SUK_GAUL',						200,	 	5,				1,					'Suk_Gaul_Atlas_200.dds'),
		('ICON_ATLAS_SUK_GAUL',						128,	 	5,				1,					'Suk_Gaul_Atlas_128.dds'),
		('ICON_ATLAS_SUK_GAUL',						95,	 		5,				1,					'Suk_Gaul_Atlas_95.dds'),
		('ICON_ATLAS_SUK_GAUL',						80,	 		5,				1,					'Suk_Gaul_Atlas_80.dds'),
		('ICON_ATLAS_SUK_GAUL',						70,	 		5,				1,					'Suk_Gaul_Atlas_70.dds'),
		('ICON_ATLAS_SUK_GAUL',						64,	 		5,				1,					'Suk_Gaul_Atlas_64.dds'),
		('ICON_ATLAS_SUK_GAUL',						55,	 		5,				1,					'Suk_Gaul_Atlas_55.dds'),
		('ICON_ATLAS_SUK_GAUL',						50,	 		5,				1,					'Suk_Gaul_Atlas_50.dds'),
		('ICON_ATLAS_SUK_GAUL',						48,	 		5,				1,					'Suk_Gaul_Atlas_48.dds'),
		('ICON_ATLAS_SUK_GAUL',						45,	 		5,				1,					'Suk_Gaul_Atlas_45.dds'),
		('ICON_ATLAS_SUK_GAUL',						44,	 		5,				1,					'Suk_Gaul_Atlas_45.dds'),
		('ICON_ATLAS_SUK_GAUL',						40,	 		5,				1,					'Suk_Gaul_Atlas_40.dds'),
		('ICON_ATLAS_SUK_GAUL',						38,	 		5,				1,					'Suk_Gaul_Atlas_38.dds'),
		('ICON_ATLAS_SUK_GAUL',						36,	 		5,				1,					'Suk_Gaul_Atlas_36.dds'),
		('ICON_ATLAS_SUK_GAUL',						32,	 		5,				1,					'Suk_Gaul_Atlas_32.dds'),
		('ICON_ATLAS_SUK_GAUL',						30,	 		5,				1,					'Suk_Gaul_Atlas_30.dds'),
		('ICON_ATLAS_SUK_GAUL',						22,	 		5,				1,					'Suk_Gaul_Atlas_22.dds');
-------------------------------------
-- IconDefinitions
-------------------------------------	
INSERT INTO IconDefinitions	
		(Name,														Atlas, 									'Index')
VALUES  ('ICON_CIVILIZATION_SUK_GAUL',								'ICON_ATLAS_SUK_GAUL',				0),
		('ICON_GAMEMODE_SUK_GAULREWORK',							'ICON_ATLAS_SUK_GAUL',				0),
		
		('ICON_LEADER_SUK_VERCINGETORIX',							'ICON_ATLAS_SUK_GAUL',				1),
		('ICON_LEADER_SUK_VERCINGETORIX_DLC',						'ICON_ATLAS_SUK_GAUL',				1),
		
		('ICON_IMPROVEMENT_SUK_DUNON',								'ICON_ATLAS_SUK_GAUL',				2),
		('ICON_UNIT_SUK_OATHSWORN',									'ICON_ATLAS_SUK_GAUL',				4),

		('ICON_UNIT_SUK_OATHSWORN_PORTRAIT',						'ICON_ATLAS_SUK_GAUL',			3),
		('ICON_ETHNICITY_AFRICAN_UNIT_SUK_OATHSWORN_PORTRAIT',		'ICON_ATLAS_SUK_GAUL',			3),
		('ICON_ETHNICITY_SOUTHAM_UNIT_SUK_OATHSWORN_PORTRAIT',		'ICON_ATLAS_SUK_GAUL',			3),
		('ICON_ETHNICITY_MEDIT_UNIT_SUK_OATHSWORN_PORTRAIT',		'ICON_ATLAS_SUK_GAUL',			3),
		('ICON_ETHNICITY_ASIAN_UNIT_SUK_OATHSWORN_PORTRAIT',		'ICON_ATLAS_SUK_GAUL',			3);
--=============================================================================================	============================
--==========================================================================================================================