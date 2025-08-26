-- Ahiram - Colours
-- Author: El Limertador
-- DateCreated: 8/21/2019 13:01:14
--------------------------------------------------------------
--==========================================================================================================================
-- COLOURS
--==========================================================================================================================
-- Colors
-------------------------------------	
INSERT OR REPLACE INTO Colors
		(Type,											Color)
VALUES	('COLOR_STANDARD_IMPERIAL_DK',					'141,0,51,255'),	--#8D0033
		('COLOR_PLAYER_LIME_PHOE_AHIRAM_PRIMARY',		'40,5,31,255'),		--#28051F
		('COLOR_PLAYER_LIME_PHOE_AHIRAM_SECONDARY',		'179,172,237,255'),	--#B3ACED
		('COLOR_STANDARD_INDIGO_DK',					'0,60,86,255');		--#003C56
-------------------------------------
-- PlayerColors
-------------------------------------	
INSERT INTO PlayerColors
		(Type,											Usage,
		PrimaryColor,									SecondaryColor,
		Alt1PrimaryColor,								Alt1SecondaryColor,
		Alt2PrimaryColor,								Alt2SecondaryColor,
		Alt3PrimaryColor,								Alt3SecondaryColor)
VALUES	('LEADER_LIME_PHOE_AHIRAM',						'Unique',
		'COLOR_STANDARD_IMPERIAL_DK',					'COLOR_STANDARD_YELLOW_LT',
		'COLOR_PLAYER_LIME_PHOE_AHIRAM_PRIMARY',		'COLOR_PLAYER_LIME_PHOE_AHIRAM_SECONDARY',
		'COLOR_PLAYER_LIME_PHOE_AHIRAM_SECONDARY',		'COLOR_PLAYER_LIME_PHOE_AHIRAM_PRIMARY',
		'COLOR_STANDARD_INDIGO_DK',						'COLOR_STANDARD_WHITE_LT');
--==========================================================================================================================
--==========================================================================================================================
--==========================================================================================================================
--==========================================================================================================================
