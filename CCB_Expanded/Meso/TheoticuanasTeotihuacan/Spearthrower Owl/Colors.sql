-- Colors
-- Author: Lime
-- DateCreated: 2/6/2020 10:11:15
--------------------------------------------------------------
--==========================================================================================================================
-- COLOURS
--==========================================================================================================================
-- Colors
-------------------------------------	
INSERT OR REPLACE INTO Colors
		(Type,										Color)
VALUES	('COLOR_PLAYER_LIME_TEO_PINK',				'255,195,195,255'),	--#FFC3C3
		('COLOR_PLAYER_LIME_TEO_PURPLE',			'25,7,35,255');	--#190723
-------------------------------------
-- PlayerColors
-------------------------------------	
INSERT INTO PlayerColors
		(Type,										Usage,
		PrimaryColor,								SecondaryColor,
		Alt1PrimaryColor,							Alt1SecondaryColor,
		Alt2PrimaryColor,							Alt2SecondaryColor,
		Alt3PrimaryColor,							Alt3SecondaryColor)
VALUES	('LEADER_LIME_TEO_OWL',						'Unique',
		'COLOR_STANDARD_RED_MD',					'COLOR_PLAYER_LIME_TEO_PINK',
		'COLOR_PLAYER_LIME_TEO_PURPLE',				'COLOR_STANDARD_GREEN_LT',
		'COLOR_PLAYER_LIME_TEO_PINK',				'COLOR_STANDARD_RED_MD',
		'COLOR_STANDARD_BLUE_DK',					'COLOR_STANDARD_AQUA_LT');
--==========================================================================================================================
--==========================================================================================================================
