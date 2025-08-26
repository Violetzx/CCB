--==========================================================================================================================
-- GEDEMON YNAEMP
--==========================================================================================================================
-- StartPosition 
--------------------------------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS StartPosition (MapName TEXT, Civilization TEXT, Leader TEXT, X INT default 0, Y INT default 0);
INSERT INTO StartPosition
		(MapName,				Civilization,				X,		Y)
VALUES	('GiantEarth',			'CIVILIZATION_LIME_THULE',	162,	88),
		('GreatestEarthMap',	'CIVILIZATION_LIME_THULE',	27,		62),
		('LargestEarth',		'CIVILIZATION_LIME_THULE',	218,	108),
		('CordiformEarth',		'CIVILIZATION_LIME_THULE',	26,		42);
--==========================================================================================================================
-- JFD RULE WITH FAITH
--==========================================================================================================================
-- Civilization_Titles
--------------------------------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS
    Civilization_Titles (
    CivilizationType        text default null,
    GovernmentType          text default null,
    LeaderTitle				text default null,
    PolicyType              text default null); 
   
INSERT INTO Civilization_Titles
        (CivilizationType,          GovernmentType,                             PolicyType,             LeaderTitle)
VALUES  ('CIVILIZATION_LIME_THULE', 'GOVERNMENT_CHIEFDOM',                      null,                   'LOC_GOVERNMENT_JFD_CHIEFDOM_LEADER_TITLE_LIME_THULE_DAVE'),                --Chiefdom
        ('CIVILIZATION_LIME_THULE', 'GOVERNMENT_AUTOCRACY',                     null,                   'LOC_GOVERNMENT_JFD_AUTOCRACY_LEADER_TITLE_LIME_THULE_DAVE'),               --Autocracy
        ('CIVILIZATION_LIME_THULE', 'GOVERNMENT_OLIGARCHY',                     null,                   'LOC_GOVERNMENT_JFD_OLIGARCHY_LEADER_TITLE_LIME_THULE_DAVE'),               --Oligarchy
        ('CIVILIZATION_LIME_THULE', 'GOVERNMENT_MONARCHY',                      null,                   'LOC_GOVERNMENT_JFD_MONARCHY_LEADER_TITLE_LIME_THULE_DAVE'),                --Feudal Monarchy
        ('CIVILIZATION_LIME_THULE', 'GOVERNMENT_CLASSICAL_REPUBLIC',            null,                   'LOC_GOVERNMENT_JFD_CLASSICAL_DEMOCRACY_LEADER_TITLE_LIME_THULE_DAVE'),     --Classical Democracy
        ('CIVILIZATION_LIME_THULE', 'GOVERNMENT_MERCHANT_REPUBLIC',             null,                   'LOC_GOVERNMENT_JFD_MERCHANT_REPUBLIC_LEADER_TITLE_LIME_THULE_DAVE'),       --Merchant Republic
        ('CIVILIZATION_LIME_THULE', 'GOVERNMENT_JFD_ABSOLUTE_MONARCHY',         null,                   'LOC_GOVERNMENT_JFD_MONARCHY_LEADER_TITLE_LIME_THULE_DAVE'),                --Absolute Monarchy
        ('CIVILIZATION_LIME_THULE', 'GOVERNMENT_JFD_CONSTITUTIONAL_MONARCHY',   null,                   'LOC_GOVERNMENT_JFD_MONARCHY_LEADER_TITLE_LIME_THULE_DAVE'),                --Constitutional Monarchy
        ('CIVILIZATION_LIME_THULE', 'GOVERNMENT_JFD_NOBLE_REPUBLIC',            null,                   'LOC_GOVERNMENT_JFD_NOBLE_REPUBLIC_LEADER_TITLE_LIME_THULE_DAVE'),          --Noble Republic
        ('CIVILIZATION_LIME_THULE', 'GOVERNMENT_DEMOCRACY',                     null,                   'LOC_GOVERNMENT_JFD_LIBERAL_DEMOCRACY_LEADER_TITLE_LIME_THULE_DAVE'),       --Liberal Democracy
        ('CIVILIZATION_LIME_THULE', 'GOVERNMENT_COMMUNISM',                     null,                   'LOC_GOVERNMENT_JFD_PEOPLES_REPUBLIC_LEADER_TITLE_LIME_THULE_DAVE'),        --People's Republic
        ('CIVILIZATION_LIME_THULE', 'GOVERNMENT_FASCISM',                       null,                   'LOC_GOVERNMENT_JFD_MILITARY_GUARDIANSHIP_LEADER_TITLE_LIME_THULE_DAVE'),   --Military Guardianship
        ('CIVILIZATION_LIME_THULE', null,                                       'POLICY_JFD_EMPIRE',    'LOC_GOVERNMENT_JFD_EMPIRE_LEADER_TITLE_LIME_THULE_DAVE'),                  --Empire
        ('CIVILIZATION_LIME_THULE', 'GOVERNMENT_JFD_POLIS',                     null,                   'LOC_GOVERNMENT_JFD_POLIS_LEADER_TITLE_LIME_THULE_DAVE'),                   --Polis
        ('CIVILIZATION_LIME_THULE', 'GOVERNMENT_JFD_HORDE',                     null,                   'LOC_GOVERNMENT_JFD_HORDE_LEADER_TITLE_LIME_THULE_DAVE');                   --Horde
 
DELETE FROM Civilization_Titles WHERE CivilizationType = 'LEADER_LIME_THULE_DAVE' AND GovernmentType IS NOT null AND GovernmentType NOT IN (SELECT GovernmentType FROM Governments);
DELETE FROM Civilization_Titles WHERE CivilizationType = 'LEADER_LIME_THULE_DAVE' AND PolicyType IS NOT null AND PolicyType NOT IN (SELECT PolicyType FROM Policies);
--==========================================================================================================================
--==========================================================================================================================