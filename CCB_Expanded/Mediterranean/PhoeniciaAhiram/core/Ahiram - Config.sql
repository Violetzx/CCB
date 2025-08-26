-- Ahiram - Config
-- Author: Lime
-- DateCreated: 9/7/2019 14:29:46
--------------------------------------------------------------

INSERT INTO Players	
		(CivilizationType,			Domain,	Portrait,							PortraitBackground,			LeaderType,					LeaderName,							LeaderIcon,						LeaderAbilityName,											LeaderAbilityDescription,											LeaderAbilityIcon,				CivilizationName,	CivilizationIcon,	CivilizationAbilityName,	CivilizationAbilityDescription, CivilizationAbilityIcon)
SELECT	'CIVILIZATION_PHOENICIA',	Domain,	'LEADER_LIME_PHOE_AHIRAM_NEUTRAL',	'LEADER_DIDO_BACKGROUND',	'LEADER_LIME_PHOE_AHIRAM',	'LOC_LEADER_LIME_PHOE_AHIRAM_NAME',	'ICON_LEADER_LIME_PHOE_AHIRAM',	'LOC_TRAIT_LEADER_LIME_PHOE_AHIRAM_MERCHANT_PRINCES_NAME',	'LOC_TRAIT_LEADER_LIME_PHOE_AHIRAM_MERCHANT_PRINCES_DESCRIPTION',	'ICON_LEADER_LIME_PHOE_AHIRAM',	CivilizationName,	CivilizationIcon,	CivilizationAbilityName,	CivilizationAbilityDescription,	CivilizationAbilityIcon
FROM Players WHERE CivilizationType = 'CIVILIZATION_PHOENICIA' AND LeaderType = 'LEADER_DIDO'; 
----------------------------------------------------------------
INSERT INTO PlayerItems
		(Domain,	CivilizationType,			LeaderType,					Type,	Name,	Description,	Icon,	SortIndex)
SELECT	Domain,		'CIVILIZATION_PHOENICIA',	'LEADER_LIME_PHOE_AHIRAM',	Type,	Name,	Description,	Icon,	SortIndex
FROM PlayerItems WHERE CivilizationType =		'CIVILIZATION_PHOENICIA' AND LeaderType= 'LEADER_DIDO' AND SortIndex IN (10, 20);

-- Humbaraci
INSERT INTO PlayerItems
		(Domain,							CivilizationType,			LeaderType,					Type,										Name,												Description,												Icon,											SortIndex)
VALUES	('Players:Expansion2_Players',		'CIVILIZATION_PHOENICIA',	'LEADER_LIME_PHOE_AHIRAM',	'LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB',	'LOC_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB_NAME',	'LOC_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB_DESCRIPTION',	'ICON_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB',	30);