-- Leader Configs
-- Author: LIMER IS DONE WITH THIS SHIT
-- DateCreated: 2/6/2020 10:12:06
--------------------------------------------------------------

INSERT OR REPLACE INTO Players
		(Domain,						CivilizationType,					LeaderType,					LeaderName,							LeaderIcon,								CivilizationName,						CivilizationIcon,						LeaderAbilityName,										LeaderAbilityDescription,								LeaderAbilityIcon,				CivilizationAbilityName,									CivilizationAbilityDescription,								CivilizationAbilityIcon,				Portrait,							PortraitBackground)
VALUES	('Players:Expansion2_Players',	'CIVILIZATION_LIME_TEOTIHUACAN',	'LEADER_LIME_TEO_OWL',		'LOC_LEADER_LIME_TEO_OWL_NAME',		'ICON_LEADER_LIME_TEO_OWL',				'LOC_CITY_NAME_TEOTIHUACAN',			'ICON_CIVILIZATION_LIME_TEOTIHUACAN',	'LOC_TRAIT_LEADER_LIME_TEO_OWL_FIRE_IS_BORN_NAME',		'LOC_TRAIT_LEADER_LIME_TEO_OWL_FIRE_IS_BORN_DESC',		'ICON_LEADER_LIME_TEO_OWL',		'LOC_TRAIT_CIVILIZATION_LIME_TEO_MEN_BECOME_GODS_NAME',		'LOC_TRAIT_CIVILIZATION_LIME_TEO_MEN_BECOME_GODS_DESC',		'ICON_CIVILIZATION_LIME_TEOTIHUACAN',	'LEADER_LIME_TEO_OWL_NEUTRAL',		'LEADER_MONTEZUMA_BACKGROUND');

INSERT OR REPLACE INTO PlayerItems
		(CivilizationType,					Domain,							LeaderType,					Type,								Icon,									Name,									Description,									SortIndex)
VALUES	('CIVILIZATION_LIME_TEOTIHUACAN',	'Players:Expansion2_Players',	'LEADER_LIME_TEO_OWL',		'UNIT_LIME_TEO_OWL_WARRIOR',		'ICON_UNIT_LIME_TEO_OWL_WARRIOR',		'LOC_UNIT_LIME_TEO_OWL_WARRIOR_NAME',	'LOC_UNIT_LIME_TEO_OWL_WARRIOR_DESC',			10),
		('CIVILIZATION_LIME_TEOTIHUACAN',	'Players:Expansion2_Players',	'LEADER_LIME_TEO_OWL',		'DISTRICT_LIME_TEO_TOLLAN',			'ICON_DISTRICT_LIME_TEO_TOLLAN',		'LOC_DISTRICT_LIME_TEO_TOLLAN_NAME',	'LOC_DISTRICT_LIME_TEO_TOLLAN_DESC',			20);