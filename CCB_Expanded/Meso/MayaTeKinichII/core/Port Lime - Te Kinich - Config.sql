-- Port Lime - Te Kinich - Config
-- Author: Yet (not) another lime joke
-- DateCreated: 5/31/2024 4:40:33 PM
--------------------------------------------------------------
INSERT OR REPLACE INTO Players
		(Domain,							CivilizationType,		LeaderType,					LeaderName,							LeaderIcon,							CivilizationName,				CivilizationIcon,			LeaderAbilityName,										LeaderAbilityDescription,								LeaderAbilityIcon,				CivilizationAbilityName,				CivilizationAbilityDescription,				CivilizationAbilityIcon,	Portrait,						PortraitBackground)
VALUES	('Players:Expansion2_Players',		'CIVILIZATION_MAYA',	'LEADER_LL_TEKINICH_II',	'LOC_LEADER_LL_TEKINICH_II_NAME',	'ICON_LEADER_LL_TEKINICH_II',		'LOC_CIVILIZATION_MAYA_NAME',	'ICON_CIVILIZATION_MAYA',	'LOC_TRAIT_LEADER_LL_TEKINICH_II_WRATH_OF_VENUS_NAME',	'LOC_TRAIT_LEADER_LL_TEKINICH_II_WRATH_OF_VENUS_DESC',	'ICON_LEADER_LL_TEKINICH_II',	'LOC_TRAIT_CIVILIZATION_MAYAB_NAME',	'LOC_TRAIT_CIVILIZATION_MAYAB_DESCRIPTION',	'ICON_CIVILIZATION_MAYA',	'LEADER_LL_TEKINICH_II_CONFIG',	'LEADER_PEDRO_BACKGROUND');

INSERT OR REPLACE INTO PlayerItems
		(CivilizationType,		Domain,								LeaderType,						Type,					Icon,							Name,								Description,								SortIndex)
VALUES	('CIVILIZATION_MAYA',	'Players:Expansion2_Players',		'LEADER_LL_TEKINICH_II',	'UNIT_MAYAN_HULCHE',	'ICON_UNIT_MAYAN_HULCHE',		'LOC_UNIT_MAYAN_HULCHE_NAME',		'LOC_UNIT_MAYAN_HULCHE_DESCRIPTION',	10),
		('CIVILIZATION_MAYA',	'Players:Expansion2_Players',		'LEADER_LL_TEKINICH_II',	'DISTRICT_OBSERVATORY',	'ICON_DISTRICT_OBSERVATORY',	'LOC_DISTRICT_OBSERVATORY_NAME',	'LOC_DISTRICT_OBSERVATORY_DESCRIPTION',		20);