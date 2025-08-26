-- Icon Definitions
-- Author: Live and Let Lime
-- DateCreated: 2/6/2020 10:11:54
--------------------------------------------------------------

INSERT INTO IconTextureAtlases	
		(Name,											IconSize,	IconsPerRow,	IconsPerColumn,		Filename)
VALUES  ('ICON_ATLAS_CIV_LIME_TEOTIHUACAN',				22,			1,				1,					'Icon_LimeTeo22'),
		('ICON_ATLAS_CIV_LIME_TEOTIHUACAN',				30,			1,				1,					'Icon_LimeTeo30'),
		('ICON_ATLAS_CIV_LIME_TEOTIHUACAN',				36,			1,				1,					'Icon_LimeTeo36'),
		('ICON_ATLAS_CIV_LIME_TEOTIHUACAN',				44,			1,				1,					'Icon_LimeTeo45'), -- ffs nobody's gonna notice the difference
		('ICON_ATLAS_CIV_LIME_TEOTIHUACAN',				45,			1,				1,					'Icon_LimeTeo45'), -- to all of you who do notice:
		('ICON_ATLAS_CIV_LIME_TEOTIHUACAN',				48,			1,				1,					'Icon_LimeTeo48'), --		snitches get stitches
		('ICON_ATLAS_CIV_LIME_TEOTIHUACAN',				50,			1,				1,					'Icon_LimeTeo50'), --		>:(
		('ICON_ATLAS_CIV_LIME_TEOTIHUACAN',				64,			1,				1,					'Icon_LimeTeo64'),
		('ICON_ATLAS_CIV_LIME_TEOTIHUACAN',				80,			1,				1,					'Icon_LimeTeo80'),
		('ICON_ATLAS_CIV_LIME_TEOTIHUACAN',				256,		1,				1,					'Icon_LimeTeo256'),

		('ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_FLAG',		22,			1,				1,					'Icon_LimeTeo_OwlWarriorFlag22'),
		('ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_FLAG',		32,			1,				1,					'Icon_LimeTeo_OwlWarriorFlag32'),
		('ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_FLAG',		38,			1,				1,					'Icon_LimeTeo_OwlWarriorFlag38'),
		('ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_FLAG',		50,			1,				1,					'Icon_LimeTeo_OwlWarriorFlag50'),
		('ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_FLAG',		80,			1,				1,					'Icon_LimeTeo_OwlWarriorFlag80'),
		('ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_FLAG',		256,		1,				1,					'Icon_LimeTeo_OwlWarriorFlag256'),

		('ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_PORTRAIT',	38,			1,				1,					'Icon_LimeTeoOwlWarriorPortrait38'),
		('ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_PORTRAIT',	50,			1,				1,					'Icon_LimeTeoOwlWarriorPortrait50'),
		('ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_PORTRAIT',	70,			1,				1,					'Icon_LimeTeoOwlWarriorPortrait70'),
		('ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_PORTRAIT',	95,			1,				1,					'Icon_LimeTeoOwlWarriorPortrait95'),
		('ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_PORTRAIT',	200,		1,				1,					'Icon_LimeTeoOwlWarriorPortrait200'),
		('ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_PORTRAIT',	256,		1,				1,					'Icon_LimeTeoOwlWarriorPortrait256'),

		('ICON_ATLAS_DISTRICT_LIME_TOLLAN',				32,			1,				1,					'Icon_LimeTeoPochteca32.dds'),
		('ICON_ATLAS_DISTRICT_LIME_TOLLAN',				38,			1,				1,					'Icon_LimeTeoPochteca38.dds'),
		('ICON_ATLAS_DISTRICT_LIME_TOLLAN',				50,			1,				1,					'Icon_LimeTeoPochteca50.dds'),
		('ICON_ATLAS_DISTRICT_LIME_TOLLAN',				80,			1,				1,					'Icon_LimeTeoPochteca80.dds'),
		('ICON_ATLAS_DISTRICT_LIME_TOLLAN',				128,		1,				1,					'Icon_LimeTeoPochteca128.dds'),
		('ICON_ATLAS_DISTRICT_LIME_TOLLAN',				256,		1,				1,					'Icon_LimeTeoPochteca256.dds');

INSERT INTO IconDefinitions	
		(Name,											Atlas, 											'Index')
VALUES  ('ICON_CIVILIZATION_LIME_TEOTIHUACAN',			'ICON_ATLAS_CIV_LIME_TEOTIHUACAN',				0),	
		('ICON_UNIT_LIME_TEO_OWL_WARRIOR',				'ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_FLAG',		0),
		('ICON_UNIT_LIME_TEO_OWL_WARRIOR_BLACK',		'ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_FLAG',		0),
		('ICON_UNIT_LIME_TEO_OWL_WARRIOR_WHITE',		'ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_FLAG',		0),
		('ICON_UNIT_LIME_TEO_OWL_WARRIOR_PORTRAIT',		'ICON_ATLAS_UNIT_LIME_OWL_WARRIOR_PORTRAIT',	0),
		('ICON_DISTRICT_LIME_TEO_TOLLAN',				'ICON_ATLAS_DISTRICT_LIME_TOLLAN',				0);