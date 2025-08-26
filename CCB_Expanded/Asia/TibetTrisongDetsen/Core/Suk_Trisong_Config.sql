--==========================================================================================================================
-- CONFIG DATA
--==========================================================================================================================
-- Players
-------------------------------------	
INSERT INTO Players	
		(
			CivilizationType,
			Portrait,
			PortraitBackground,

			LeaderType,
			LeaderName,
			LeaderIcon,
			
			LeaderAbilityName,
			LeaderAbilityDescription,
			LeaderAbilityIcon,

			CivilizationName,
			CivilizationIcon,
			CivilizationAbilityName,
			CivilizationAbilityDescription,
			CivilizationAbilityIcon
		)
VALUES
		(
			'CIVILIZATION_SUK_TIBET',
			'LEADER_SUK_TRISONG_DETSEN_NEUTRAL',
			'LEADER_SUK_TRISONG_DETSEN_BACKGROUND',

			'LEADER_SUK_TRISONG_DETSEN',
			'LOC_LEADER_SUK_TRISONG_DETSEN_NAME',
			'ICON_LEADER_SUK_TRISONG_DETSEN',

			'LOC_TRAIT_LEADER_SUK_CAPTURE_OF_CHANGAN_NAME',
			'LOC_TRAIT_LEADER_SUK_CAPTURE_OF_CHANGAN_DESCRIPTION',
			'ICON_LEADER_SUK_TRISONG_DETSEN',

			'LOC_CIVILIZATION_SUK_TIBET_NAME',
			'ICON_CIVILIZATION_SUK_TIBET',
			'LOC_TRAIT_CIVILIZATION_SUK_DHARMA_KINGS_NAME',
			'LOC_TRAIT_CIVILIZATION_SUK_DHARMA_KINGS_DESCRIPTION',
			'ICON_CIVILIZATION_SUK_TIBET'
		);
-------------------------------------
-- PlayerItems
-------------------------------------	
INSERT INTO PlayerItems	
		(CivilizationType,				LeaderType,						Type,							Icon,							Name,								 Description,									SortIndex)
VALUES	('CIVILIZATION_SUK_TIBET',		'LEADER_SUK_TRISONG_DETSEN',	'DISTRICT_SUK_DZONG',			'ICON_DISTRICT_SUK_DZONG',		'LOC_DISTRICT_SUK_DZONG_NAME',		'LOC_DISTRICT_SUK_DZONG_DESCRIPTION',			20),
		('CIVILIZATION_SUK_TIBET',		'LEADER_SUK_TRISONG_DETSEN',	'UNIT_SUK_TIBET_RTA_PA',		'ICON_UNIT_SUK_TIBET_RTA_PA',	'LOC_UNIT_SUK_TIBET_RTA_PA_NAME',	'LOC_UNIT_SUK_TIBET_RTA_PA_DESCRIPTION',		10);
--==========================================================================================================================
-- Rise and Fall
--==========================================================================================================================
-- Players
-------------------------------------
INSERT INTO Players	
		(
			CivilizationType,					
			Portrait,								
			PortraitBackground,				

			LeaderType,						
			LeaderName,							
			LeaderIcon,						
			LeaderAbilityName,									
			LeaderAbilityDescription,								
			LeaderAbilityIcon,				

			CivilizationName,						
			CivilizationIcon,						
			CivilizationAbilityName,								
			CivilizationAbilityDescription,								
			CivilizationAbilityIcon,

			Domain
		)
SELECT	
			Players.CivilizationType,					
			Players.Portrait,								
			Players.PortraitBackground,				

			Players.LeaderType,						
			Players.LeaderName,							
			Players.LeaderIcon,						
			Players.LeaderAbilityName,									
			Players.LeaderAbilityDescription,								
			Players.LeaderAbilityIcon,				

			Players.CivilizationName,						
			Players.CivilizationIcon,						
			Players.CivilizationAbilityName,								
			Players.CivilizationAbilityDescription,								
			Players.CivilizationAbilityIcon,

			RulesetDomainOverrides.Domain
FROM Players, RulesetDomainOverrides WHERE 
	Players.CivilizationType = 'CIVILIZATION_SUK_TIBET' AND Players.LeaderType = 'LEADER_SUK_TRISONG_DETSEN' AND Players.Domain = 'Players:StandardPlayers'
	AND RulesetDomainOverrides.ParameterId = 'PlayerLeader' AND RulesetDomainOverrides.Ruleset IN (SELECT RuleSetType FROM RuleSets WHERE IsScenario = 0);

UPDATE Players
SET CivilizationAbilityName = 'LOC_TRAIT_CIVILIZATION_SUK_DHARMA_KINGS_NAME_XP2', CivilizationAbilityDescription = 'LOC_TRAIT_CIVILIZATION_SUK_DHARMA_KINGS_DESCRIPTION_XP2'
WHERE CivilizationType = 'CIVILIZATION_SUK_TIBET' AND Domain NOT IN ('Players:Expansion1_Players', 'Players:StandardPlayers');
-------------------------------------
-- PlayerItems
-------------------------------------	
INSERT INTO PlayerItems
		(
			CivilizationType,
			LeaderType,
			Type,
			Icon,
			Name,	
			Description,
			SortIndex,

			Domain
		)
SELECT	
			PlayerItems.CivilizationType,
			PlayerItems.LeaderType,
			PlayerItems.Type,
			PlayerItems.Icon,
			PlayerItems.Name,	
			PlayerItems.Description,
			PlayerItems.SortIndex,

			RulesetDomainOverrides.Domain
FROM PlayerItems, RulesetDomainOverrides WHERE
	PlayerItems.CivilizationType = 'CIVILIZATION_SUK_TIBET' AND PlayerItems.LeaderType = 'LEADER_SUK_TRISONG_DETSEN' AND PlayerItems.Domain = 'Players:StandardPlayers'
	AND RulesetDomainOverrides.ParameterId = 'PlayerLeader' AND RulesetDomainOverrides.Ruleset IN (SELECT RuleSetType FROM RuleSets WHERE IsScenario = 0);

UPDATE PlayerItems
SET Description = 'LOC_DISTRICT_SUK_DZONG_DESCRIPTION_XP2'
WHERE Type = 'DISTRICT_SUK_DZONG' AND Domain == 'Players:Expansion2_Players';
--==========================================================================================================================
--==========================================================================================================================