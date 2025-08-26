-- IconTextureAtlases
-------------------------------------	
INSERT INTO IconTextureAtlases	
		(Name,										IconSize,	IconsPerRow,	IconsPerColumn,		Filename)
VALUES  ('ICON_ATLAS_P0K_RESOURCES',				256,	 	8,				8,					'p0k_Resources_Atlas_256.dds'),
		('ICON_ATLAS_P0K_RESOURCES_FOW',			256,		8,				8,					'p0k_Resources_Atlas_256_FOW.dds'),
		('ICON_ATLAS_P0K_RESOURCES',				64,	 		8,				8,					'p0k_Resources_Atlas_64.dds'),
	--	('ICON_ATLAS_P0K_RESOURCES_FOW',			64,	 		8,				8,					'p0k_Resources_Atlas_FOW.dds'),
		('ICON_ATLAS_P0K_RESOURCES',				50,	 		8,				8,					'p0k_Resources_Atlas_50.dds'),
		('ICON_ATLAS_P0K_RESOURCES',				38,	 		8,				8,					'p0k_Resources_Atlas_38.dds');

INSERT INTO IconTextureAtlases	
		(Name,										Baseline,	IconSize,	IconsPerRow,	IconsPerColumn,		Filename)
VALUES  ('ICON_ATLAS_P0K_RESOURCES',				6,			22,	 		8,				8,					'p0k_Resources_Atlas_22.dds');
-------------------------------------
-- IconDefinitions
-------------------------------------	
INSERT INTO IconDefinitions	
		(Name,												Atlas, 									'Index')
VALUES  ('ICON_RESOURCE_P0K_PENGUINS',						'ICON_ATLAS_P0K_RESOURCES',				0),
		('RESOURCE_P0K_PENGUINS',							'ICON_ATLAS_P0K_RESOURCES',				0),
		('ICON_RESOURCE_P0K_PENGUINS_FOW',					'ICON_ATLAS_P0K_RESOURCES_FOW',			0),
		('ICON_RESOURCE_CVS_POMEGRANATES',					'ICON_ATLAS_P0K_RESOURCES',				1), 
		('RESOURCE_CVS_POMEGRANATES',						'ICON_ATLAS_P0K_RESOURCES',				1),
		('ICON_RESOURCE_CVS_POMEGRANATES_FOW',				'ICON_ATLAS_P0K_RESOURCES_FOW',			1),
		('ICON_RESOURCE_P0K_PLUMS',							'ICON_ATLAS_P0K_RESOURCES',				2),
		('RESOURCE_P0K_PLUMS',								'ICON_ATLAS_P0K_RESOURCES',				2),
		('ICON_RESOURCE_P0K_PLUMS_FOW',						'ICON_ATLAS_P0K_RESOURCES_FOW',			2),
		('ICON_RESOURCE_P0K_PAPYRUS',						'ICON_ATLAS_P0K_RESOURCES',				3),
		('RESOURCE_P0K_PAPYRUS',							'ICON_ATLAS_P0K_RESOURCES',				3),
		('ICON_RESOURCE_P0K_PAPYRUS_FOW',					'ICON_ATLAS_P0K_RESOURCES_FOW',			3),
		('ICON_RESOURCE_P0K_OPAL',							'ICON_ATLAS_P0K_RESOURCES',				4),
		('RESOURCE_P0K_OPAL',								'ICON_ATLAS_P0K_RESOURCES',				4),
		('ICON_RESOURCE_P0K_OPAL_FOW',						'ICON_ATLAS_P0K_RESOURCES_FOW',			4),
		('ICON_RESOURCE_P0K_MAPLE',							'ICON_ATLAS_P0K_RESOURCES',				5),
		('RESOURCE_P0K_MAPLE',								'ICON_ATLAS_P0K_RESOURCES',				5),
		('ICON_RESOURCE_P0K_MAPLE_FOW',						'ICON_ATLAS_P0K_RESOURCES_FOW',			5);