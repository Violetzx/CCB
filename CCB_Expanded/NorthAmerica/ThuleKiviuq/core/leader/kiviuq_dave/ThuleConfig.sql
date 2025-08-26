-- ThuleConfig
-- Author: Lime
-- DateCreated: 3/20/2018 17:31:21
--------------------------------------------------------------

INSERT OR REPLACE INTO Players
		(Domain,						CivilizationType,			LeaderType,					LeaderName,							LeaderIcon,							CivilizationName,						CivilizationIcon,					LeaderAbilityName,											LeaderAbilityDescription,											LeaderAbilityIcon,				CivilizationAbilityName,									CivilizationAbilityDescription,										CivilizationAbilityIcon,			Portrait,							PortraitBackground)
VALUES	('Players:Expansion2_Players',	'CIVILIZATION_LIME_THULE',	'LEADER_LIME_THULE_DAVE',	'LOC_LEADER_LIME_THULE_DAVE_NAME',	'ICON_LEADER_LIME_THULE_DAVE',		'LOC_CIVILIZATION_LIME_THULE_NAME',		'ICON_CIVILIZATION_LIME_THULE',		'LOC_TRAIT_LEADER_LIME_THULE_DAVE_HEART_NOT_STONE_NAME',	'LOC_TRAIT_LEADER_LIME_THULE_DAVE_HEART_NOT_STONE_DESCRIPTION',		'ICON_LEADER_LIME_THULE_DAVE',	'LOC_TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD_NAME',	'LOC_TRAIT_CIVILIZATION_LIME_THULE_HUNTING_BOWHEAD_DESCRIPTION',	'ICON_CIVILIZATION_LIME_THULE',		'LEADER_LIME_THULEDAVE_NEUTRAL',	'LEADER_MONTEZUMA_BACKGROUND');
		

INSERT OR REPLACE INTO PlayerItems
		(CivilizationType,				Domain,							LeaderType,					Type,							Icon,								Name,									Description,									SortIndex)
VALUES	('CIVILIZATION_LIME_THULE',		'Players:Expansion2_Players',	'LEADER_LIME_THULE_DAVE',	'UNIT_LIME_THULE_DOGSLED',		'ICON_UNIT_LIME_THULE_DOGSLED',		'LOC_UNIT_LIME_THULE_DOGSLED_NAME',		'LOC_UNIT_LIME_THULE_DOGSLED_DESCRIPTION',		10),
		('CIVILIZATION_LIME_THULE',		'Players:Expansion2_Players',	'LEADER_LIME_THULE_DAVE',	'IMPROVEMENT_LIME_THULE_WBH',	'ICON_IMPROVEMENT_LIME_THULE_WBH',	'LOC_IMPROVEMENT_LIME_THULE_WBH_NAME',	'LOC_IMPROVEMENT_LIME_THULE_WBH_DESCRIPTION',	20);