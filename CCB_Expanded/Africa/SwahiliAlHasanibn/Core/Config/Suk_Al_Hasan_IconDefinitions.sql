--==========================================================================================================================
-- ICONS
--==========================================================================================================================
-- IconTextureAtlases
-------------------------------------
INSERT INTO IconTextureAtlases
		(Name,							IconSize,	IconsPerRow,	IconsPerColumn,		Filename)
VALUES  ('ICON_ATLAS_SUK_SWAHILI',		256,		5,				1,					'Suk_Swahili_Atlas_256'),
		('ICON_ATLAS_SUK_SWAHILI',		200,		5,				1,					'Suk_Swahili_Atlas_200'),
		('ICON_ATLAS_SUK_SWAHILI',		128,		5,				1,					'Suk_Swahili_Atlas_128'),
		('ICON_ATLAS_SUK_SWAHILI',		95,			5,				1,					'Suk_Swahili_Atlas_95'),
		('ICON_ATLAS_SUK_SWAHILI',		80,			5,				1,					'Suk_Swahili_Atlas_80'),
		('ICON_ATLAS_SUK_SWAHILI',		70,			5,				1,					'Suk_Swahili_Atlas_70'),
		('ICON_ATLAS_SUK_SWAHILI',		64,			5,				1,					'Suk_Swahili_Atlas_64'),
		('ICON_ATLAS_SUK_SWAHILI',		55,			5,				1,					'Suk_Swahili_Atlas_55'),
		('ICON_ATLAS_SUK_SWAHILI',		50,			5,				1,					'Suk_Swahili_Atlas_50'),
		('ICON_ATLAS_SUK_SWAHILI',		48,			5,				1,					'Suk_Swahili_Atlas_48'),
		('ICON_ATLAS_SUK_SWAHILI',		45,			5,				1,					'Suk_Swahili_Atlas_45'),
		('ICON_ATLAS_SUK_SWAHILI',		44,			5,				1,					'Suk_Swahili_Atlas_44'),
		('ICON_ATLAS_SUK_SWAHILI',		40,			5,				1,					'Suk_Swahili_Atlas_40'),
		('ICON_ATLAS_SUK_SWAHILI',		38,			5,				1,					'Suk_Swahili_Atlas_38'),
		('ICON_ATLAS_SUK_SWAHILI',		36,			5,				1,					'Suk_Swahili_Atlas_36'),
		('ICON_ATLAS_SUK_SWAHILI',		32,			5,				1,					'Suk_Swahili_Atlas_32'),
		('ICON_ATLAS_SUK_SWAHILI',		30,			5,				1,					'Suk_Swahili_Atlas_30'),
		('ICON_ATLAS_SUK_SWAHILI',		22,			5,				1,					'Suk_Swahili_Atlas_22');

INSERT INTO IconTextureAtlases
		(Name,										IconSize,	IconsPerRow,	IconsPerColumn,		Filename)
VALUES  ('ICON_ATLAS_SUK_TERNATE',					256,	 	1,				1,					'Suk_Ternate_Atlas_256.dds'),
		('ICON_ATLAS_SUK_TERNATE',					80,	 		1,				1,					'Suk_Ternate_Atlas_80.dds'),
		('ICON_ATLAS_SUK_TERNATE',					64,	 		1,				1,					'Suk_Ternate_Atlas_64.dds'),
		('ICON_ATLAS_SUK_TERNATE',					50,	 		1,				1,					'Suk_Ternate_Atlas_50.dds'),
		('ICON_ATLAS_SUK_TERNATE',					48,	 		1,				1,					'Suk_Ternate_Atlas_48.dds'),
		('ICON_ATLAS_SUK_TERNATE',					45,	 		1,				1,					'Suk_Ternate_Atlas_45.dds'),
		('ICON_ATLAS_SUK_TERNATE',					44,	 		1,				1,					'Suk_Ternate_Atlas_44.dds'),
		('ICON_ATLAS_SUK_TERNATE',					36,	 		1,				1,					'Suk_Ternate_Atlas_36.dds'),
		('ICON_ATLAS_SUK_TERNATE',					30,	 		1,				1,					'Suk_Ternate_Atlas_30.dds'),
		('ICON_ATLAS_SUK_TERNATE',					22,	 		1,				1,					'Suk_Ternate_Atlas_22.dds');
-------------------------------------
-- IconDefinitions
-------------------------------------
INSERT OR REPLACE INTO IconDefinitions
		(Name,												Atlas, 									'Index')
VALUES  ('ICON_CIVILIZATION_SUK_SWAHILI',					'ICON_ATLAS_SUK_SWAHILI',				0),
		('ICON_LEADER_SUK_AL_HASAN',						'ICON_ATLAS_SUK_SWAHILI',				1),
		('ICON_BUILDING_SUK_PILLAR_TOMB',					'ICON_ATLAS_SUK_SWAHILI',				2),
		('ICON_UNIT_SUK_JAHAZI',							'ICON_ATLAS_SUK_SWAHILI',				4),

		('ICON_UNIT_SUK_JAHAZI_PORTRAIT',						'ICON_ATLAS_SUK_SWAHILI',			3),
		('ICON_ETHNICITY_AFRICAN_UNIT_SUK_JAHAZI_PORTRAIT',		'ICON_ATLAS_SUK_SWAHILI',			3),
		('ICON_ETHNICITY_SOUTHAM_UNIT_SUK_JAHAZI_PORTRAIT',		'ICON_ATLAS_SUK_SWAHILI',			3),
		('ICON_ETHNICITY_MEDIT_UNIT_SUK_JAHAZI_PORTRAIT',		'ICON_ATLAS_SUK_SWAHILI',			3),
		('ICON_ETHNICITY_ASIAN_UNIT_SUK_JAHAZI_PORTRAIT',		'ICON_ATLAS_SUK_SWAHILI',			3);

		-- ('ICON_CIVILIZATION_ZANZIBAR',						'ICON_ATLAS_SUK_TERNATE',				0);
--==========================================================================================================================
--==========================================================================================================================