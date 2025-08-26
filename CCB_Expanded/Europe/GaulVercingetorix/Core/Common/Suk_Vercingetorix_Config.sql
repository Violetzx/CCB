--==========================================================================================================================
-- CONFIG DATA: BASE
--==========================================================================================================================
	-- Players
	-------------------------------------
		INSERT INTO Players
			(
				Portrait,
				PortraitBackground,

				LeaderType,
				LeaderName,
				LeaderIcon,

				LeaderAbilityName,
				LeaderAbilityDescription,
				LeaderAbilityIcon,

				CivilizationType,
				CivilizationName,
				CivilizationIcon,

				CivilizationAbilityName,
				CivilizationAbilityDescription,
				CivilizationAbilityIcon,

				Domain
			)
		SELECT

				'LEADER_SUK_VERCINGETORIX_NEUTRAL',
				'LEADER_SUK_VERCINGETORIX_BACKGROUND',

				'LEADER_SUK_VERCINGETORIX',
				'LOC_LEADER_SUK_VERCINGETORIX_NAME',
				'ICON_LEADER_SUK_VERCINGETORIX',

				'LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME',
				'LOC_TRAIT_LEADER_SUK_GALLIC_WAR_DESCRIPTION',
				'ICON_LEADER_SUK_VERCINGETORIX',

				'CIVILIZATION_SUK_GAUL',
				'LOC_CIVILIZATION_SUK_GAUL_NAME',
				'ICON_CIVILIZATION_SUK_GAUL',

				'LOC_TRAIT_CIVILIZATION_SUK_TORCS_AND_CARNYXES_NAME',
				'LOC_TRAIT_CIVILIZATION_SUK_TORCS_AND_CARNYXES_DESCRIPTION',
				'ICON_CIVILIZATION_SUK_GAUL',

				Domain

		FROM RulesetDomainOverrides WHERE
			Domain != 'Players:StandardPlayers'
			AND ParameterId = 'PlayerLeader'
			AND Ruleset IN (SELECT RuleSetType FROM RuleSets WHERE IsScenario = 0)
			AND NOT EXISTS (SELECT * FROM Players WHERE CivilizationType = 'CIVILIZATION_GAUL' AND LeaderType = 'LEADER_AMBIORIX');
	--------------------------------------------------------------------------
	-- PlayerItems
	--------------------------------------------------------------------------
		WITH CTE(Type, Icon, Name, Description) AS
			(
				SELECT * FROM (VALUES
					('UNIT_SUK_OATHSWORN',		'ICON_UNIT_SUK_OATHSWORN',		'LOC_UNIT_SUK_OATHSWORN_NAME',		'LOC_UNIT_SUK_OATHSWORN_DESCRIPTION'),
					('IMPROVEMENT_SUK_DUNON',	'ICON_IMPROVEMENT_SUK_DUNON',	'LOC_IMPROVEMENT_SUK_DUNON_NAME',	'LOC_IMPROVEMENT_SUK_DUNON_DESCRIPTION')
				)
			)
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
				CivilizationType,
				LeaderType,

				Type,
				Icon,
				Name,
				Description,

				10,
				Domain
		FROM Players, CTE WHERE CivilizationType = 'CIVILIZATION_SUK_GAUL';
--==========================================================================================================================
-- CONFIG DATA: DLC
--==========================================================================================================================
	-- Players
	--------------------------------------------------------------------------
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

				'CIVILIZATION_GAUL',
				'LEADER_SUK_VERCINGETORIX_NEUTRAL',
				'LEADER_SUK_VERCINGETORIX_BACKGROUND',

				'LEADER_SUK_VERCINGETORIX_DLC',
				'LOC_LEADER_SUK_VERCINGETORIX_NAME',
				'ICON_LEADER_SUK_VERCINGETORIX_DLC',
				'LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME',
				'LOC_TRAIT_LEADER_SUK_GALLIC_WAR_DESCRIPTION_DLC',
				'ICON_LEADER_SUK_VERCINGETORIX_DLC',

				CivilizationName,
				CivilizationIcon,
				CivilizationAbilityName,
				CivilizationAbilityDescription,
				CivilizationAbilityIcon,

				Domain

		FROM Players WHERE
			Domain != 'Players:StandardPlayers'
			AND CivilizationType = 'CIVILIZATION_GAUL'
			AND LeaderType = 'LEADER_AMBIORIX';
	--------------------------------------------------------------------------
	-- PlayerItems
	-- Add Dunon to all players, to be hidden via game mode.
	--------------------------------------------------------------------------
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
					'CIVILIZATION_GAUL',
					LeaderType,

					'IMPROVEMENT_SUK_DUNON',
					'ICON_IMPROVEMENT_SUK_DUNON',
					'LOC_IMPROVEMENT_SUK_DUNON_NAME',
					'LOC_IMPROVEMENT_SUK_DUNON_REWORK_DESCRIPTION',

					20,
					Domain
		FROM Players WHERE
			CivilizationType = 'CIVILIZATION_GAUL'
			AND LeaderType = 'LEADER_AMBIORIX';
	--------------------------------------------------------------------------
	-- PlayerItems
	--------------------------------------------------------------------------
		INSERT INTO PlayerItems
				(CivilizationType,			LeaderType,							Type, Icon, Name, Description, SortIndex, Domain)
		SELECT	'CIVILIZATION_GAUL',		'LEADER_SUK_VERCINGETORIX_DLC',		Type, Icon, Name, Description, SortIndex, Domain
		FROM PlayerItems WHERE
			CivilizationType = 'CIVILIZATION_GAUL'
			AND LeaderType = 'LEADER_AMBIORIX'
			AND Domain IN (SELECT Domain FROM Players WHERE LeaderType = 'LEADER_SUK_VERCINGETORIX_DLC');
--==========================================================================================================================
-- GAME MODES
--==========================================================================================================================
	-- Create Game Mode
	-- There is a base rework mode, and an option for a more complete reowork.
	------------------------------------------------------------------------------------------------------------------------
		-- Parameters
		--------------------------------------------------------------------------
			-- Base Rework
			--------------------------------------------------------------------------
				INSERT INTO Parameters
					(
						ParameterId,
						Name,
						Description,
						Domain,
						DefaultValue,
						ConfigurationGroup,
						ConfigurationId,
						GroupId
					)
				SELECT
						'GameMode_Suk_GaulRework',
						'LOC_GAMEMODE_SUK_GAULREWORK_NAME',
						'LOC_GAMEMODE_SUK_GAULREWORK_DESCRIPTION',
						'bool',
						0,
						'Game',
						'GAMEMODE_SUK_GAULREWORK',
						'GameModes'
				WHERE EXISTS (SELECT * FROM Players WHERE CivilizationType = 'CIVILIZATION_GAUL');
			--------------------------------------------------------------------------
			-- Rework++
			--------------------------------------------------------------------------
				INSERT INTO Parameters
					(
						ParameterId,
						Name,
						Description,
						Domain,
						DefaultValue,
						ConfigurationGroup,
						ConfigurationId,
						GroupId,
						SortIndex
					)
				SELECT
						'GameMode_Suk_GaulReworkPlus',
						'LOC_GAMEMODE_SUK_GAULREWORKPLUS_NAME',
						'LOC_GAMEMODE_SUK_GAULREWORKPLUS_DESCRIPTION',
						'bool',
						0,
						'Game',
						'GAMEMODE_SUK_GAULREWORKPLUS',
						'AdvancedOptions',
						2020
				WHERE EXISTS (SELECT * FROM Players WHERE CivilizationType = 'CIVILIZATION_GAUL');
		--------------------------------------------------------------------------
		-- ParameterDependencies
		-- Rework Plus requires the base rework.
		--------------------------------------------------------------------------
			INSERT INTO ParameterDependencies
				(
					ParameterId,

					ConfigurationGroup,
					ConfigurationId,

					Operator,
					ConfigurationValue
				)
			SELECT
					'GameMode_Suk_GaulReworkPlus',

					'Game',
					'GAMEMODE_SUK_GAULREWORK',

					'Equals',
					1
			WHERE EXISTS (SELECT * FROM Players WHERE CivilizationType = 'CIVILIZATION_GAUL');
		--------------------------------------------------------------------------
		-- GameModeItems
		-- Front End Game Mode info for the placard
		--------------------------------------------------------------------------
			INSERT INTO GameModeItems
				(
					GameModeType,
					Name,

					Icon,
					Portrait,
					Background,

					SortIndex
				)
			SELECT * FROM (VALUES
				(
					'GAMEMODE_SUK_GAULREWORK',
					'LOC_GAMEMODE_SUK_GAULREWORK_NAME',

					'ICON_GAMEMODE_SUK_GAULREWORK',
					'GAMEMODE_SUK_GAUL_NEUTRAL',
					'GAMEMODE_SUK_GAUL_BACKGROUND',

					10
				)
			)
			WHERE EXISTS (SELECT * FROM Players WHERE CivilizationType = 'CIVILIZATION_GAUL');
	------------------------------------------------------------------------------------------------------------------------
	-- Replace Items
	------------------------------------------------------------------------------------------------------------------------
		-- Queries
		--------------------------------------------------------------------------
			INSERT INTO Queries
					(QueryId,						SQL)
			VALUES	('Suk_GaulRework_Info',			"SELECT * FROM GameModePlayerInfoOverrides WHERE GameModeType = 'GAMEMODE_SUK_GAULREWORK'"),
					('Suk_GaulRework_Item',			"SELECT * FROM GameModePlayerItemOverrides WHERE GameModeType = 'GAMEMODE_SUK_GAULREWORK'"),
					('Suk_GaulReworkPlus_Item',		"SELECT * FROM GameModePlayerItemOverrides WHERE GameModeType = 'GAMEMODE_SUK_GAULREWORKPLUS'"),
					('Suk_GaulReworkOff_Item',		"SELECT * FROM GameModePlayerItemOverrides WHERE GameModeType = 'GAMEMODE_SUK_GAULREWORKOFF'"),
					('Suk_GaulReworkPlusOff_Item',	"SELECT * FROM GameModePlayerItemOverrides WHERE GameModeType = 'GAMEMODE_SUK_GAULREWORKOFF'");
		--------------------------------------------------------------------------
		-- QueryCriteria
		--------------------------------------------------------------------------
			INSERT INTO QueryCriteria
					(QueryId,						ConfigurationGroup,		ConfigurationId,				Operator,	ConfigurationValue)
			VALUES	('Suk_GaulRework_Info',			'Game',					'GAMEMODE_SUK_GAULREWORK',		'Equals',	'1'),

					('Suk_GaulRework_Item',			'Game',					'GAMEMODE_SUK_GAULREWORK',		'Equals',	'1'),
					('Suk_GaulRework_Item',			'Game',					'GAMEMODE_SUK_GAULREWORKPLUS',	'Equals',	'0'),

					('Suk_GaulReworkPlus_Item',		'Game',					'GAMEMODE_SUK_GAULREWORK',		'Equals',	'1'),
					('Suk_GaulReworkPlus_Item',		'Game',					'GAMEMODE_SUK_GAULREWORKPLUS',	'Equals',	'1'),

					('Suk_GaulReworkOff_Item',		'Game',					'GAMEMODE_SUK_GAULREWORK',		'Equals',	'0'),
					('Suk_GaulReworkPlusOff_Item',	'Game',					'GAMEMODE_SUK_GAULREWORKPLUS',	'Equals',	'0');
		--------------------------------------------------------------------------
		-- PlayerInfoOverrideQueries/PlayerItemOverrideQueries
		--------------------------------------------------------------------------
			INSERT INTO PlayerInfoOverrideQueries
					(QueryId)
			VALUES	('Suk_GaulRework_Info');

			INSERT INTO PlayerItemOverrideQueries
					(QueryId)
			VALUES	('Suk_GaulRework_Item'),
					('Suk_GaulReworkPlus_Item'),
					('Suk_GaulReworkOff_Item'),
					('Suk_GaulReworkPlusOff_Item');
		--------------------------------------------------------------------------
		-- GameModePlayerInfoOverrides
		--------------------------------------------------------------------------
			INSERT INTO GameModePlayerInfoOverrides
				(
					GameModeType,

					CivilizationType,
					LeaderType,
					Domain,

					CivilizationAbilityDescription,

					Priority
				)
			SELECT
					'GAMEMODE_SUK_GAULREWORK',

					CivilizationType,
					LeaderType,
					Domain,

					'LOC_TRAIT_CIVILIZATION_GAUL_DESCRIPTION_REWORK',

					10
			FROM Players WHERE CivilizationType = 'CIVILIZATION_GAUL';
		--------------------------------------------------------------------------
		-- GameModePlayerItemOverrides
		-- Base Rework
		--------------------------------------------------------------------------
			INSERT INTO GameModePlayerItemOverrides
				(
					GameModeType,

					CivilizationType,
					LeaderType,
					Domain,

					Type,
					Description,

					Priority
				)
			SELECT
					'GAMEMODE_SUK_GAULREWORK',

					CivilizationType,
					LeaderType,
					Domain,

					'DISTRICT_OPPIDUM',
					'LOC_DISTRICT_OPPIDUM_REWORK_DESCRIPTION',

					10
			FROM Players WHERE CivilizationType = 'CIVILIZATION_GAUL';
		--------------------------------------------------------------------------
		-- GameModePlayerItemOverrides
		-- Rework Plus
		--------------------------------------------------------------------------
			WITH CTE(GameModeType, Type, Description, ShouldRemove) AS
			(
				SELECT * FROM (VALUES
					('GAMEMODE_SUK_GAULREWORKOFF',	'IMPROVEMENT_SUK_DUNON',	NULL, 1),
					('GAMEMODE_SUK_GAULREWORKPLUS',	'DISTRICT_OPPIDUM',			NULL, 1),
					('GAMEMODE_SUK_GAULREWORKPLUS',	'UNIT_GAUL_GAESATAE',		'LOC_UNIT_GAUL_GAESATAE_REWORK_DESCRIPTION', 0)
				)
			)
			INSERT INTO GameModePlayerItemOverrides
				(
					GameModeType,

					CivilizationType,
					LeaderType,
					Domain,

					Type,
					Description,
					ShouldRemove,

					Priority
				)
			SELECT
					GameModeType,

					CivilizationType,
					LeaderType,
					Domain,

					Type,
					Description,
					ShouldRemove,

					10
			FROM Players, CTE WHERE CivilizationType = 'CIVILIZATION_GAUL';
--==========================================================================================================================
--==========================================================================================================================