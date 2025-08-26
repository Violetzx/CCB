-- Icon Definitions
-- Author: Lime Again Tomorrow
-- DateCreated: 2/6/2020 10:13:06
--------------------------------------------------------------

INSERT INTO IconTextureAtlases	
		(Name,												IconSize,	Baseline,	IconsPerRow,	IconsPerColumn,		Filename)
VALUES  ('ICON_ATLAS_LEADER_LIME_TEO_OWL',					32,			0,			1,				1,					'Icon_LimeTeoSpearthrower32'),
		('ICON_ATLAS_LEADER_LIME_TEO_OWL',					45,			0,			1,				1,					'Icon_LimeTeoSpearthrower45'),
		('ICON_ATLAS_LEADER_LIME_TEO_OWL',					50,			0,			1,				1,					'Icon_LimeTeoSpearthrower50'),
		('ICON_ATLAS_LEADER_LIME_TEO_OWL',					55,			0,			1,				1,					'Icon_LimeTeoSpearthrower55'),
		('ICON_ATLAS_LEADER_LIME_TEO_OWL',					64,			0,			1,				1,					'Icon_LimeTeoSpearthrower64'),
		('ICON_ATLAS_LEADER_LIME_TEO_OWL',					80,			0,			1,				1,					'Icon_LimeTeoSpearthrower80'),
		('ICON_ATLAS_LEADER_LIME_TEO_OWL',					256,		0,			1,				1,					'Icon_LimeTeoSpearthrower256'),
		--
		('ICON_ATLAS_LIME_TEO_OWL_GOVERNORS', 				64, 		0,			1,				1,					'Lime_FireIsBorn_Governors64'),
		('ICON_ATLAS_LIME_TEO_OWL_GOVERNORS', 				32, 		0,			1,				1,					'Lime_FireIsBorn_Governors32'),

		('ICON_ATLAS_LIME_TEO_OWL_GOVERNORS_FILL', 			32, 		0,			1,				1,					'Lime_FireIsBorn_GovernorsCityBannerFill32'),
		('ICON_ATLAS_LIME_TEO_OWL_GOVERNORS_FILL', 			22, 		6,			1,				1,					'Lime_FireIsBorn_GovernorsCityBannerFill22'),

		('ICON_ATLAS_LIME_TEO_OWL_GOVERNORS_SLOT', 			32, 		0,			1,				1,					'Lime_FireIsBorn_GovernorsCityBannerSlot32'),
		('ICON_ATLAS_LIME_TEO_OWL_GOVERNORS_SLOT', 			22, 		6,			1,				1,					'Lime_FireIsBorn_GovernorsCityBannerSlot22'),

		('ICON_ATLAS_LIME_TEO_OWL_GOVERNOR_PROMOTIONS', 	32, 		0,			1,				1,					'Lime_FireIsBorn_GovernorPromotions24');

INSERT INTO IconDefinitions	
		(Name,												Atlas, 											'Index')
VALUES  ('ICON_LEADER_LIME_TEO_OWL',						'ICON_ATLAS_LEADER_LIME_TEO_OWL',				0),
		
		('ICON_GOVERNOR_LIME_TEO_OWL_EMISSARY', 			'ICON_ATLAS_LIME_TEO_OWL_GOVERNORS', 			0),
		('ICON_GOVERNOR_LIME_TEO_OWL_EMISSARY_FILL', 		'ICON_ATLAS_LIME_TEO_OWL_GOVERNORS_FILL', 		0),
		('ICON_GOVERNOR_LIME_TEO_OWL_EMISSARY_SLOT', 		'ICON_ATLAS_LIME_TEO_OWL_GOVERNORS_SLOT', 		0),

		('ICON_GOVERNOR_LIME_TEO_OWL_EMISSARY_PROMOTION', 	'ICON_ATLAS_LIME_TEO_OWL_GOVERNOR_PROMOTIONS', 	0);

INSERT INTO Icons 
		(Name)
VALUES	('GOVERNOR_LIME_TEO_OWL_EMISSARY_FILL'),
		('GOVERNOR_LIME_TEO_OWL_EMISSARY_SLOT');

INSERT INTO IconAliases 
		(Name,												OtherName)
VALUES	('GOVERNOR_LIME_TEO_OWL_EMISSARY_FILL',				'ICON_GOVERNOR_LIME_TEO_OWL_EMISSARY_FILL'),
		('GOVERNOR_LIME_TEO_OWL_EMISSARY_SLOT',				'ICON_GOVERNOR_LIME_TEO_OWL_EMISSARY_SLOT');