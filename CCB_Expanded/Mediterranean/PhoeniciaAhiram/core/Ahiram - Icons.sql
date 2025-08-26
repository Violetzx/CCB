-- Ahiram - Icons
-- Author: lime
-- DateCreated: 8/21/2019 13:11:05
--------------------------------------------------------------

INSERT INTO IconTextureAtlases	
		(Name,										IconSize,	IconsPerRow,	IconsPerColumn,		Filename)
VALUES  ('ICON_ATLAS_LEADER_LIME_PHOE_AHIRAM',		32,			1,				1,					'Icon_LimePhoeAhiram32'),
		('ICON_ATLAS_LEADER_LIME_PHOE_AHIRAM',		45,			1,				1,					'Icon_LimePhoeAhiram45'),
		('ICON_ATLAS_LEADER_LIME_PHOE_AHIRAM',		50,			1,				1,					'Icon_LimePhoeAhiram50'),
		('ICON_ATLAS_LEADER_LIME_PHOE_AHIRAM',		55,			1,				1,					'Icon_LimePhoeAhiram55'),
		('ICON_ATLAS_LEADER_LIME_PHOE_AHIRAM',		64,			1,				1,					'Icon_LimePhoeAhiram64'),
		('ICON_ATLAS_LEADER_LIME_PHOE_AHIRAM',		80,			1,				1,					'Icon_LimePhoeAhiram80'),
		('ICON_ATLAS_LEADER_LIME_PHOE_AHIRAM',		256,		1,				1,					'Icon_LimePhoeAhiram256'),

		('ICON_ATLAS_BUILDING_LIME_AHIRAM_TOMB',	32,			1,				1,					'Icon_LimePhoeAhiram_RoyalTomb32'),
		('ICON_ATLAS_BUILDING_LIME_AHIRAM_TOMB',	38,			1,				1,					'Icon_LimePhoeAhiram_RoyalTomb38'),
		('ICON_ATLAS_BUILDING_LIME_AHIRAM_TOMB',	50,			1,				1,					'Icon_LimePhoeAhiram_RoyalTomb50'),
		('ICON_ATLAS_BUILDING_LIME_AHIRAM_TOMB',	70,			1,				1,					'Icon_LimePhoeAhiram_RoyalTomb70'),
		('ICON_ATLAS_BUILDING_LIME_AHIRAM_TOMB',	80,			1,				1,					'Icon_LimePhoeAhiram_RoyalTomb80'),
		('ICON_ATLAS_BUILDING_LIME_AHIRAM_TOMB',	128,		1,				1,					'Icon_LimePhoeAhiram_RoyalTomb128'),
		('ICON_ATLAS_BUILDING_LIME_AHIRAM_TOMB',	256,		1,				1,					'Icon_LimePhoeAhiram_RoyalTomb256');

INSERT INTO IconDefinitions	
		(Name,																	Atlas, 											'Index')
VALUES  ('ICON_LEADER_LIME_PHOE_AHIRAM',										'ICON_ATLAS_LEADER_LIME_PHOE_AHIRAM',			0),	
		('ICON_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB',							'ICON_ATLAS_BUILDING_LIME_AHIRAM_TOMB',			0);