--==========================================================================================================================
-- YNAEMP
--==========================================================================================================================
CREATE TABLE IF NOT EXISTS StartPosition
	(MapName TEXT,
	Civilization TEXT,
	Leader TEXT,
	X INT default 0,
	Y INT default 0);
------------------------------------------------------------
-- StartPosition 
------------------------------------------------------------	
INSERT OR REPLACE INTO StartPosition
		(Civilization,						Leader,							MapName,				X,		Y)
VALUES	('CIVILIZATION_SUK_SWAHILI',		'LEADER_SUK_AL_HASAN',			'GiantEarth',			33,		24),
		('CIVILIZATION_SUK_SWAHILI',		'LEADER_SUK_AL_HASAN',			'GreatestEarthMap',		64,		14),
		('CIVILIZATION_SUK_SWAHILI',		'LEADER_SUK_AL_HASAN',			'LargestEarth',			43,		31);

		-- ('CIVILIZATION_ZANZIBAR',							NULL,			'GiantEarth',			91,		33),
		-- ('CIVILIZATION_ZANZIBAR',							NULL,			'GreatestEarthMap',		95,		29),
		-- ('CIVILIZATION_ZANZIBAR',							NULL,			'LargestEarth',			121,	41);
--==========================================================================================================================
-- JFD RULE WITH FAITH
--==========================================================================================================================
-- Leader_Titles 
------------------------------------------------------------	
CREATE TABLE IF NOT EXISTS 
	Leader_Titles (
	LeaderType  											text 		 											default null,
	GovernmentType											text 													default null,
	LeaderTitle												text													default null,
	PolicyType  											text 		 											default null,
	UseFeminine												boolean													default 0,
	TitleIsFullName											boolean													default 0);	
	
INSERT INTO Leader_Titles
		(LeaderType, 			GovernmentType, LeaderTitle, PolicyType)
SELECT	'LEADER_SUK_AL_HASAN', 	GovernmentType, LeaderTitle, PolicyType
FROM Leader_Titles WHERE LeaderType = 'LEADER_SALADIN';

DELETE FROM Leader_Titles 
WHERE LeaderType = 'LEADER_SUK_AL_HASAN' AND GovernmentType IS NOT null
AND GovernmentType NOT IN (SELECT GovernmentType FROM Governments);

DELETE FROM Leader_Titles 
WHERE LeaderType = 'LEADER_SUK_AL_HASAN' AND PolicyType IS NOT null
AND PolicyType NOT IN (SELECT PolicyType FROM Policies);
--==========================================================================================================================
--==========================================================================================================================