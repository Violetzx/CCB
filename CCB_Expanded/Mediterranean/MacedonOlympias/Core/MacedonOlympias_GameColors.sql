--==========================================================================================================================
-- LEADERS: COLOURS
--==========================================================================================================================
----------------------------------------------------------------------------------------------------------------------------
-- PlayerColors
----------------------------------------------------------------------------------------------------------------------------	
INSERT INTO PlayerColors	
		(Type,					Usage,		PrimaryColor, 									SecondaryColor,									Alt1PrimaryColor, Alt1SecondaryColor, Alt2PrimaryColor, Alt2SecondaryColor, Alt3PrimaryColor, Alt3SecondaryColor)
SELECT	'LEADER_JFD_OLYMPIAS',	'Unique',	'COLOR_PLAYER_JFD_MACEDON_OLYMPIAS_PRIMARY',	'COLOR_PLAYER_JFD_MACEDON_OLYMPIAS_SECONDARY',	Alt1PrimaryColor, Alt1SecondaryColor, Alt2PrimaryColor, Alt2SecondaryColor, Alt3PrimaryColor, Alt3SecondaryColor
FROM PlayerColors WHERE Type = 'LEADER_ALEXANDER';
----------------------------------------------------------------------------------------------------------------------------		
-- Colors		
----------------------------------------------------------------------------------------------------------------------------	
INSERT INTO Colors 
		(Type, 												Color)
VALUES	('COLOR_PLAYER_JFD_MACEDON_OLYMPIAS_PRIMARY', 		'207,91,105,255'),
		('COLOR_PLAYER_JFD_MACEDON_OLYMPIAS_SECONDARY', 	'244,194,56,255');
--==========================================================================================================================
--==========================================================================================================================