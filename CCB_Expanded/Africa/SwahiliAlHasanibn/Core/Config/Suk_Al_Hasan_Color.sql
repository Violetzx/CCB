--==========================================================================================================================
-- COLOURS
--==========================================================================================================================
-- Colors
-------------------------------------	
INSERT INTO Colors 
		(Type, 											Color)
VALUES	('COLOR_PLAYER_SUK_AL_HASAN_PRIMARY', 			'19,126,161,255'), -- #137EA1
		('COLOR_PLAYER_SUK_AL_HASAN_SECONDARY', 		'255,174,136,255'); -- #FFAE88
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
			'LEADER_SUK_AL_HASAN',
			'Unique',

			'COLOR_PLAYER_SUK_AL_HASAN_PRIMARY',
			'COLOR_PLAYER_SUK_AL_HASAN_SECONDARY',

			'COLOR_STANDARD_ORANGE_DK',
			'COLOR_STANDARD_AQUA_LT',

			'COLOR_STANDARD_AQUA_DK',
			'COLOR_STANDARD_ORANGE_MD',

			'COLOR_STANDARD_AQUA_DK',
			'COLOR_STANDARD_AQUA_LT'
		);
--==========================================================================================================================
--==========================================================================================================================