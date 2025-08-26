--==========================================================================================================================
-- COLOURS
--==========================================================================================================================
-- Colors
-------------------------------------	
INSERT INTO Colors 
		(Type, 													Color)
VALUES	('COLOR_PLAYER_SUK_TRISONG_DETSEN_SECONDARY', 			'14,117,85,255'); -- #0E7555
-------------------------------------
-- PlayerColors
-------------------------------------	
INSERT INTO PlayerColors
		(
			Type,
			Usage,

			PrimaryColor,
			SecondaryColor,

			Alt1PrimaryColor,
			Alt1SecondaryColor,

			Alt2PrimaryColor,
			Alt2SecondaryColor,

			Alt3PrimaryColor,
			Alt3SecondaryColor
		)
VALUES
		(
			'LEADER_SUK_TRISONG_DETSEN',
			'Unique',

			'COLOR_STANDARD_WHITE_LT',
			'COLOR_PLAYER_SUK_TRISONG_DETSEN_SECONDARY',

			'COLOR_PLAYER_SUK_TRISONG_DETSEN_SECONDARY',
			'COLOR_STANDARD_WHITE_LT',

			'COLOR_STANDARD_RED_DK',
			'COLOR_STANDARD_ORANGE_LT',

			'COLOR_STANDARD_ORANGE_LT',
			'COLOR_STANDARD_RED_DK'
		);
--==========================================================================================================================
--==========================================================================================================================