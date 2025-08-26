--==========================================================================================================================
-- DISTRICTS
--==========================================================================================================================
-- DEATH TO THE OPPIDUM
----------------------------------------------------------------------------------------------------------------------------
	-- Types
	-------------------------------------
		DELETE FROM Types
			WHERE Type IN ("TRAIT_CIVILIZATION_DISTRICT_OPPIDUM", "DISTRICT_OPPIDUM");
--==========================================================================================================================
-- TRAITS
--==========================================================================================================================
	-- Types
	-------------------------------------
		INSERT INTO Types
				(Type,													Kind)
		VALUES	('TRAIT_CIVILIZATION_IMPROVEMENT_SUK_DUNON',			'KIND_TRAIT');
	-------------------------------------
	-- Traits
	-------------------------------------
		INSERT INTO Traits
				(
					TraitType,
					Name,
					Description
				)
		VALUES
				(
					'TRAIT_CIVILIZATION_IMPROVEMENT_SUK_DUNON',
					'LOC_TRAIT_CIVILIZATION_IMPROVEMENT_SUK_DUNON_NAME',
					NULL
				);
	-------------------------------------
	-- CivilizationTraits
	-------------------------------------
		INSERT INTO CivilizationTraits
				(TraitType,												CivilizationType)
		VALUES	('TRAIT_CIVILIZATION_IMPROVEMENT_SUK_DUNON',			'CIVILIZATION_GAUL');
--==========================================================================================================================
-- IMPROVEMENTS
--==========================================================================================================================
	-- Types
	-------------------------------------
		INSERT INTO Types
				(Type,							Kind)
		VALUES	('IMPROVEMENT_SUK_DUNON',		'KIND_IMPROVEMENT');
	-------------------------------------
	-- Improvements
	-------------------------------------
		INSERT INTO Improvements
			(
				ImprovementType,
				Name,
				Description,
				Icon,

				TraitType,
				PrereqCivic,
				Buildable,

				OnePerCity,

				Housing,
				TilesRequired,

				PlunderType,
				PlunderAmount
			)
		VALUES
			(
				'IMPROVEMENT_SUK_DUNON',
				'LOC_IMPROVEMENT_SUK_DUNON_NAME',
				'LOC_IMPROVEMENT_SUK_DUNON_REWORK_DESCRIPTION',
				'ICON_IMPROVEMENT_SUK_DUNON',

				'TRAIT_CIVILIZATION_IMPROVEMENT_SUK_DUNON',
				'CIVIC_DEFENSIVE_TACTICS',
				1,

				1,

				2,
				2,

				'PLUNDER_HEAL',
				100
			);
	-------------------------------------
	-- Improvement_ValidBuildUnits
	-------------------------------------
		INSERT INTO Improvement_ValidBuildUnits
					(ImprovementType,							UnitType)
		VALUES 		('IMPROVEMENT_SUK_DUNON',					'UNIT_BUILDER');
	-------------------------------------
	-- Improvement_ValidResources
	-------------------------------------
		INSERT INTO Improvement_ValidResources
				(ImprovementType,				ResourceType,					MustRemoveFeature)
		SELECT	'IMPROVEMENT_SUK_DUNON',		ResourceType,					0
		FROM Improvement_ValidResources WHERE ImprovementType IN ('IMPROVEMENT_CAMP','IMPROVEMENT_PASTURE');
	-------------------------------------
	-- Improvement_YieldChanges
	-------------------------------------
		INSERT INTO Improvement_YieldChanges
				(ImprovementType,				YieldType,						YieldChange)
		VALUES	('IMPROVEMENT_SUK_DUNON',		'YIELD_FOOD',					1);
--==========================================================================================================================\
-- MomentIllustrations
--==========================================================================================================================
INSERT INTO MomentIllustrations
		(MomentIllustrationType, 					MomentDataType,				GameDataType,						Texture)
VALUES	('MOMENT_ILLUSTRATION_UNIQUE_IMPROVEMENT', 	'MOMENT_DATA_IMPROVEMENT',	'IMPROVEMENT_SUK_DUNON',			'Moment_UniqueInfrastructure_Suk_Gaul.dds');
--==========================================================================================================================
--==========================================================================================================================
--==========================================================================================================================
-- +1 [ICON_Production] Production if built on a Hill
----------------------------------------------------------------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- ImprovementModifiers
		-------------------------------------
			INSERT INTO ImprovementModifiers
					(ImprovementType,						ModifierId)
			VALUES	('IMPROVEMENT_SUK_DUNON', 				'SUK_DUNON_HILL_PRODUCTION');
		-------------------------------------
		-- Modifiers
		-------------------------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId)
			VALUES	(
						'SUK_DUNON_HILL_PRODUCTION',
						'MODIFIER_SINGLE_PLOT_ADJUST_PLOT_YIELDS',
						'SUK_DUNON_ON_HILL'
					);
		-------------------------------------
		-- ModifierArguments
		-------------------------------------
			INSERT INTO ModifierArguments
					(ModifierId,						Name,				Value)
			VALUES	('SUK_DUNON_HILL_PRODUCTION',		'YieldType',		'YIELD_PRODUCTION'),
					('SUK_DUNON_HILL_PRODUCTION',		'Amount',			1);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		-------------------------------------
			INSERT INTO RequirementSets
					(RequirementSetId,					RequirementSetType)
			VALUES	('SUK_DUNON_ON_HILL',				'REQUIREMENTSET_TEST_ALL');
		-------------------------------------
		-- RequirementSetRequirements
		-------------------------------------
			INSERT INTO RequirementSetRequirements
					(RequirementSetId,					RequirementId)
			VALUES	('SUK_DUNON_ON_HILL',				'PLOT_IS_HILLS_REQUIREMENT');
--==========================================================================================================================
-- Friendly units within 1 tile of a Dūnon receive +5 Combat Strength.
----------------------------------------------------------------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- ImprovementModifiers
		-------------------------------------
			INSERT INTO ImprovementModifiers
					(ImprovementType,						ModifierId)
			VALUES	('IMPROVEMENT_SUK_DUNON', 				'SUK_DUNON_COMBAT_BONUS');
		-------------------------------------
		-- Modifiers
		-------------------------------------
			INSERT INTO Modifiers
				(
					ModifierId,
					ModifierType,
					SubjectRequirementSetId
				)
			VALUES
				(
					'SUK_DUNON_COMBAT_BONUS',
					'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER',
					'SUK_DUNON_UNIT_IS_ON_OR_ADJACENT'
				),
				(
					'SUK_DUNON_COMBAT_BONUS_MODIFIER',
					'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',
					NULL
				);
		-------------------------------------
		-- ModifierArguments
		-------------------------------------
			INSERT INTO ModifierArguments
					(ModifierId,							Name,			Value)
			VALUES	('SUK_DUNON_COMBAT_BONUS',				'ModifierId',	'SUK_DUNON_COMBAT_BONUS_MODIFIER'),
					('SUK_DUNON_COMBAT_BONUS_MODIFIER',		'Amount',		5);
		-------------------------------------
		-- ModifierStrings
		-------------------------------------
			INSERT INTO ModifierStrings
					(ModifierId,							Context,			'Text')
			VALUES	('SUK_DUNON_COMBAT_BONUS_MODIFIER',		'Preview',			'LOC_IMPROVEMENT_SUK_DUNON_COMBAT_BONUS_PREVIEW');
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		-------------------------------------
			INSERT INTO RequirementSets
					(RequirementSetId,						RequirementSetType)
			VALUES	('SUK_DUNON_UNIT_IS_ON_OR_ADJACENT',	'REQUIREMENTSET_TEST_ALL');
		-------------------------------------
		-- RequirementSetRequirements
		-------------------------------------
			INSERT INTO RequirementSetRequirements
					(RequirementSetId,						RequirementId)
			VALUES	('SUK_DUNON_UNIT_IS_ON_OR_ADJACENT',	'REQUIRES_SUK_DUNON_UNIT_IS_ON_OR_ADJACENT');
		-------------------------------------
		-- Requirements
		-------------------------------------
			INSERT INTO Requirements
					(RequirementId, 								RequirementType)
			VALUES	('REQUIRES_SUK_DUNON_UNIT_IS_ON_OR_ADJACENT',	'REQUIREMENT_PLOT_ADJACENT_TO_OWNER');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT INTO RequirementArguments
					(RequirementId, 								Name,						Value)
			VALUES	('REQUIRES_SUK_DUNON_UNIT_IS_ON_OR_ADJACENT', 	'MinDistance',				0),
					('REQUIRES_SUK_DUNON_UNIT_IS_ON_OR_ADJACENT', 	'MaxDistance',				1);
--==========================================================================================================================
-- The Dunon must be built on a Camp or Pasture resource
-- and provides that resource's yield modifier to adjacent tiles.
----------------------------------------------------------------------------------------------------------------------------
	-- Preparation
	--------------------------------------------------------------------
		CREATE TEMPORARY TABLE "Suk_Dunon_Temp" (
			"ResourceType"		TEXT,
			"YieldType"			TEXT,
			"YieldChange"		INT
		);

		INSERT INTO Suk_Dunon_Temp
					(ResourceType,	YieldType,	YieldChange)
			SELECT	ResourceType,	YieldType,	YieldChange
			FROM Resource_YieldChanges WHERE ResourceType IN
				(SELECT ResourceType FROM Improvement_ValidResources
					WHERE ImprovementType IN ('IMPROVEMENT_CAMP','IMPROVEMENT_PASTURE'));
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- ImprovementModifiers
		-------------------------------------
			INSERT INTO ImprovementModifiers
					(ImprovementType,			ModifierId)
			SELECT	'IMPROVEMENT_SUK_DUNON',	'IMPROVEMENT_SUK_DUNON_' || ResourceType || '_' || YieldType
			FROM Suk_Dunon_Temp;
		-------------------------------------
		-- Modifiers
		-------------------------------------
			INSERT INTO Modifiers
				(
					ModifierId,
					ModifierType,
					OwnerRequirementSetId,
					SubjectRequirementSetId
				)
				SELECT
					'IMPROVEMENT_SUK_DUNON_' || ResourceType || '_' || YieldType,
					'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',
					'SUK_DUNON_' || ResourceType,
					'SUK_TORCS_AND_CARNYXES_IS_ADJACENT'
				FROM Suk_Dunon_Temp;
		-------------------------------------
		-- ModifierArguments
		-------------------------------------
			INSERT INTO ModifierArguments
				(
					ModifierId,
					Name,
					Value
				)
				SELECT
					'IMPROVEMENT_SUK_DUNON_' || ResourceType || '_' || YieldType,
					'YieldType',
					Suk_Dunon_Temp.YieldType
				FROM Suk_Dunon_Temp;

			INSERT INTO ModifierArguments
					(
						ModifierId,
						Name,
						Value
					)
				SELECT
						'IMPROVEMENT_SUK_DUNON_' || ResourceType || '_' || YieldType,
						'Amount',
						Suk_Dunon_Temp.YieldChange
				FROM Suk_Dunon_Temp;
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		-------------------------------------
			INSERT INTO RequirementSets
							(RequirementSetId,				RequirementSetType)
			SELECT DISTINCT	'SUK_DUNON_' || ResourceType,	'REQUIREMENTSET_TEST_ALL'
			FROM Suk_Dunon_Temp;
		-------------------------------------
		-- RequirementSetRequirements
		-------------------------------------
			INSERT INTO RequirementSetRequirements
							(RequirementSetId,				RequirementId)
			SELECT DISTINCT	'SUK_DUNON_' || ResourceType,	'REQUIRES_SUK_DUNON_' || ResourceType
			FROM Suk_Dunon_Temp;

			INSERT INTO RequirementSetRequirements
							(RequirementSetId,					RequirementId)
			SELECT DISTINCT	'SUK_DUNON_' || ResourceType,	'REQUIRES_PLOT_HAS_VISIBLE_RESOURCE'
			FROM Suk_Dunon_Temp;
		-------------------------------------
		-- Requirements
		-------------------------------------
			INSERT INTO Requirements
							(RequirementId, 							RequirementType)
			SELECT DISTINCT	'REQUIRES_SUK_DUNON_' || ResourceType,	'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES'
			FROM Suk_Dunon_Temp;
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT INTO RequirementArguments
							(RequirementId, 							Name,					Value)
			SELECT DISTINCT	'REQUIRES_SUK_DUNON_' || ResourceType,	'ResourceType',			ResourceType
			FROM Suk_Dunon_Temp;
--==========================================================================================================================
--==========================================================================================================================