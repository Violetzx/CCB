-- ModSupport
-- Author: Limer, quite a bit later
-- DateCreated: 11/13/2022 7:38:30 PM
--------------------------------------------------------------

CREATE TABLE IF NOT EXISTS SG_Civ_Assignments (
		SG_CivilizationType		text,
		SG_LeaderCategory		text,
		PRIMARY KEY (SG_CivilizationType)
		);

INSERT OR REPLACE INTO SG_Civ_Assignments
		(SG_CivilizationType,				SG_LeaderCategory)
VALUES	('CIVILIZATION_LIME_TEOTIHUACAN',	'SG_LEADER_MESOAMERICAN');


INSERT INTO StartBiasResources
		(CivilizationType,					ResourceType,	Tier)
SELECT	'CIVILIZATION_LIME_TEOTIHUACAN',	ResourceType,	2
FROM Resources
	WHERE ResourceType = 'RESOURCE_SUK_OBSIDIAN';