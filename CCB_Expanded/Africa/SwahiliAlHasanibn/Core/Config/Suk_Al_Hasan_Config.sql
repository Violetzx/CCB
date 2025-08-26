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
				'CIVILIZATION_SUK_SWAHILI',

				'LEADER_SUK_AL_HASAN_NEUTRAL',
				'LEADER_SUK_AL_HASAN_BACKGROUND',

				'LEADER_SUK_AL_HASAN',
				'LOC_LEADER_SUK_AL_HASAN_NAME',
				'ICON_LEADER_SUK_AL_HASAN',

				'LOC_TRAIT_LEADER_SUK_HUSUNI_KUBWA_NAME',
				'LOC_TRAIT_LEADER_SUK_HUSUNI_KUBWA_DESCRIPTION',
				'ICON_LEADER_SUK_AL_HASAN',

				'LOC_CIVILIZATION_SUK_SWAHILI_NAME',
				'ICON_CIVILIZATION_SUK_SWAHILI',

				'LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_NAME',
				'LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_DESCRIPTION',
				'ICON_CIVILIZATION_SUK_SWAHILI'
			);
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

					SortIndex
				)
		VALUES	(
					'CIVILIZATION_SUK_SWAHILI',
					'LEADER_SUK_AL_HASAN',

					'BUILDING_SUK_PILLAR_TOMB',
					'ICON_BUILDING_SUK_PILLAR_TOMB',
					'LOC_BUILDING_SUK_PILLAR_TOMB_NAME',
					'LOC_BUILDING_SUK_PILLAR_TOMB_DESCRIPTION',

					20
				),
				(
					'CIVILIZATION_SUK_SWAHILI',
					'LEADER_SUK_AL_HASAN',

					'UNIT_SUK_JAHAZI',
					'ICON_UNIT_SUK_JAHAZI',
					'LOC_UNIT_SUK_JAHAZI_NAME',
					'LOC_UNIT_SUK_JAHAZI_DESCRIPTION',

					10
				);
--==========================================================================================================================
-- Rise and Fall
--==========================================================================================================================
	-- Players
	--------------------------------------------------------------------
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
			Players.CivilizationType = 'CIVILIZATION_SUK_SWAHILI' AND Players.LeaderType = 'LEADER_SUK_AL_HASAN' AND Players.Domain = 'Players:StandardPlayers'
			AND RulesetDomainOverrides.ParameterId = 'PlayerLeader' AND RulesetDomainOverrides.Ruleset IN (SELECT RuleSetType FROM RuleSets WHERE IsScenario = 0);
	--------------------------------------------------------------------
	-- Players (UPDATE)
	--------------------------------------------------------------------
		UPDATE Players
		SET CivilizationAbilityDescription = 'LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_DESCRIPTION_XP1'
		WHERE CivilizationType = 'CIVILIZATION_SUK_SWAHILI' AND Domain != 'Players:StandardPlayers';

		UPDATE Players
		SET LeaderAbilityDescription = 'LOC_TRAIT_LEADER_SUK_HUSUNI_KUBWA_XP2_DESCRIPTION'
		WHERE CivilizationType = 'CIVILIZATION_SUK_SWAHILI' AND Domain = 'Players:Expansion2_Players';
	--------------------------------------------------------------------
	-- PlayerItems
	--------------------------------------------------------------------
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
			PlayerItems.CivilizationType = 'CIVILIZATION_SUK_SWAHILI' AND PlayerItems.LeaderType = 'LEADER_SUK_AL_HASAN' AND PlayerItems.Domain = 'Players:StandardPlayers'
			AND RulesetDomainOverrides.ParameterId = 'PlayerLeader' AND RulesetDomainOverrides.Ruleset IN (SELECT RuleSetType FROM RuleSets WHERE IsScenario = 0);
	--------------------------------------------------------------------
	-- PlayerItems (UPDATE)
	--------------------------------------------------------------------
		UPDATE PlayerItems
		SET Description = 'LOC_BUILDING_SUK_PILLAR_TOMB_XP1_DESCRIPTION'
		WHERE Type = 'BUILDING_SUK_PILLAR_TOMB' AND Domain != 'Players:StandardPlayers';
--==========================================================================================================================
-- TSL
--==========================================================================================================================
	INSERT INTO MapLeaders
			(LeaderType,					Map)
	VALUES	('LEADER_SUK_AL_HASAN',			'../../Assets/Maps/EarthMaps/TSLEarthStandard.Civ6Map'),
			('LEADER_SUK_AL_HASAN',			'{4873eb62-8ccc-4574-b784-dda455e74e68}Maps/EarthMaps/TSLEarthStandard_XP2.Civ6Map');

	INSERT INTO MapStartPositions
			(Type,			Value,							Plot,		Map)
	VALUES	('NONE',		NULL,							1812,		'../../Assets/Maps/EarthMaps/TSLEarthStandard.Civ6Map'),
			('NONE',		NULL,							1812,		'{4873eb62-8ccc-4574-b784-dda455e74e68}Maps/EarthMaps/TSLEarthStandard_XP2.Civ6Map'),

			('LEADER',		'LEADER_SUK_AL_HASAN',			1728,		'../../Assets/Maps/EarthMaps/TSLEarthStandard.Civ6Map'),
			('LEADER',		'LEADER_SUK_AL_HASAN',			1728,		'{4873eb62-8ccc-4574-b784-dda455e74e68}Maps/EarthMaps/TSLEarthStandard_XP2.Civ6Map');

			-- ('LEADER',		'LEADER_MINOR_CIV_ZANZIBAR',	2252,		'../../Assets/Maps/EarthMaps/TSLEarthStandard.Civ6Map'),
			-- ('LEADER',		'LEADER_MINOR_CIV_ZANZIBAR',	2252,		'{4873eb62-8ccc-4574-b784-dda455e74e68}Maps/EarthMaps/TSLEarthStandard_XP2.Civ6Map');
--==========================================================================================================================
--==========================================================================================================================