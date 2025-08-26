--==========================================================================================================================
-- UNITS
--==========================================================================================================================
-- Types
--------------------------------------------------------------------------------------------------------------------------
	INSERT INTO Types
			(Type,							Kind)
	VALUES	('UNIT_SUK_JAHAZI',				'KIND_UNIT');
--------------------------------------------------------------------------------------------------------------------------
-- Units
--------------------------------------------------------------------------------------------------------------------------
	-- Units
	--------------------------------------------------------------------------
		INSERT INTO Units

				(
					UnitType,
					Name,
					Description,

					TraitType,
					PrereqTech,

					Cost,
					CostProgressionModel,
					CostProgressionParam1,
					Maintenance,
					PurchaseYield,

					BuildCharges,

					BaseMoves,
					BaseSightRange,
					ZoneOfControl,

					AdvisorType,

					Domain,
					FormationClass,
					PromotionClass
				)

		SELECT
					'UNIT_SUK_JAHAZI',
					'LOC_UNIT_SUK_JAHAZI_NAME',
					'LOC_UNIT_SUK_JAHAZI_DESCRIPTION',

					'TRAIT_CIVILIZATION_UNIT_SUK_JAHAZI',
					'TECH_SAILING',

					35,
					'COST_PROGRESSION_GAME_PROGRESS',
					400,
					1,
					'YIELD_GOLD',

					2,

					3,
					3,
					0,

					'ADVISOR_GENERIC',

					Domain,
					'FORMATION_CLASS_SUPPORT',
					'PROMOTION_CLASS_SUPPORT'

		FROM Units WHERE UnitType = 'UNIT_GALLEY';
	--------------------------------------------------------------------------
	-- UnitAiInfos
	--------------------------------------------------------------------------
		INSERT INTO UnitAiInfos
				(UnitType,						AiType)
		VALUES 	('UNIT_SUK_JAHAZI',				'UNITTYPE_NAVAL'),
				('UNIT_SUK_JAHAZI',				'UNITTYPE_CIVILIAN'),
				('UNIT_SUK_JAHAZI',				'UNITAI_BUILD');
	--------------------------------------------------------------------------
	-- TypeTags
	--------------------------------------------------------------------------
		INSERT OR REPLACE INTO TypeTags
				(Type,						Tag)
		VALUES	('UNIT_SUK_JAHAZI',			'CLASS_SUPPORT'),
				('UNIT_SUK_JAHAZI',			'CLASS_NAVAL_MELEE'),
				('UNIT_SUK_JAHAZI',			'CLASS_SUK_JAHAZI'),
				('ABILITY_SUK_JAHAZI',		'CLASS_SUK_JAHAZI');

		INSERT OR REPLACE INTO TypeTags
				(Type,										Tag)
		SELECT	'ABILITY_SUK_JAHAZI_EMBARKED_MOVEMENT',		Tag
		FROM TypeTags WHERE Type = 'ABILITY_GREAT_LIGHTHOUSE_EMBARKED_MOVEMENT';
	--------------------------------------------------------------------------
	-- Tags
	--------------------------------------------------------------------------
		INSERT INTO Tags
					(Tag,								Vocabulary)
		VALUES		('CLASS_SUK_JAHAZI',				'ABILITY_CLASS');
--==========================================================================================================================
-- Abilities
--==========================================================================================================================
	-- Types
	--------------------------------------------------------------------------
		INSERT INTO Types
				(Type,										Kind)
		VALUES	('ABILITY_SUK_JAHAZI',						'KIND_ABILITY'),
				('ABILITY_SUK_JAHAZI_EMBARKED_MOVEMENT',	'KIND_ABILITY');
	--------------------------------------------------------------------------
	-- UnitAbilities
	--------------------------------------------------------------------------
		INSERT INTO UnitAbilities
			(
				UnitAbilityType,
				Name,
				Description,

				Inactive,
				Permanent
			)
			VALUES
			(
				'ABILITY_SUK_JAHAZI',
				'LOC_ABILITY_SUK_JAHAZI_NAME',
				'LOC_ABILITY_SUK_JAHAZI_DESCRIPTION',

				0,
				1
			),
			(
				'ABILITY_SUK_JAHAZI_EMBARKED_MOVEMENT',
				'LOC_ABILITY_SUK_JAHAZI_EMBARKED_MOVEMENT_NAME',
				'LOC_ABILITY_SUK_JAHAZI_EMBARKED_MOVEMENT_DESCRIPTION',

				1,
				0
			);
--==========================================================================================================================
-- Has 2 charges to build Fishing Boats.
-- Fishing Boats built by a Jahazi yield +1 Gold, +1 Culture.
--==========================================================================================================================
	-- Improvement_ValidBuildUnits
	--------------------------------------------------------------------
		INSERT INTO Improvement_ValidBuildUnits
					(ImprovementType,							UnitType)
		VALUES 		('IMPROVEMENT_FISHING_BOATS',				'UNIT_SUK_JAHAZI');
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- TraitModifiers
		----------------------
			INSERT INTO TraitModifiers
					(TraitType,									ModifierId)
			VALUES	('TRAIT_CIVILIZATION_UNIT_SUK_JAHAZI',		'SUK_JAHAZI_YIELD_BONUS');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(ModifierId,						ModifierType,								SubjectRequirementSetId)
			VALUES	('SUK_JAHAZI_YIELD_BONUS',			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',		'SUK_JAHAZI_PLOT_PROPERTY');
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,					Name,				Value)
			VALUES	('SUK_JAHAZI_YIELD_BONUS',		'YieldType',		'YIELD_PRODUCTION,YIELD_GOLD'),
					('SUK_JAHAZI_YIELD_BONUS',		'Amount',			'1,2');
	--------------------------------------------------------------------
	-- REQUIREMENTS
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT INTO RequirementSets
					(RequirementSetId,					RequirementSetType)
			VALUES	('SUK_JAHAZI_PLOT_PROPERTY',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT INTO RequirementSetRequirements
					(RequirementSetId,					RequirementId)
			VALUES	('SUK_JAHAZI_PLOT_PROPERTY',		'REQUIRES_SUK_JAHAZI_PLOT_PROPERTY'),
					('SUK_JAHAZI_PLOT_PROPERTY',		'REQUIRES_PLOT_HAS_FISHINGBOATS');
		----------------------
		-- Requirements
		----------------------
			INSERT INTO Requirements
					(RequirementId, 						RequirementType)
			VALUES	('REQUIRES_SUK_JAHAZI_PLOT_PROPERTY',	'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		----------------------
		-- RequirementArguments
		----------------------
			INSERT INTO RequirementArguments
					(RequirementId, 						Name,				Value)
			VALUES	('REQUIRES_SUK_JAHAZI_PLOT_PROPERTY', 	'PropertyName',		'SUK_JAHAZI'),
					('REQUIRES_SUK_JAHAZI_PLOT_PROPERTY', 	'PropertyMinimum',	1);
--==========================================================================================================================
-- Grants Movement Ability to Embarked units within 2 tiles
--==========================================================================================================================
	-- Modifiers
	--------------------------------------------------------------------
		-- UnitAbilityModifiers
		-------------------------------------
			INSERT INTO UnitAbilityModifiers
					(UnitAbilityType,							ModifierId)
			VALUES	('ABILITY_SUK_JAHAZI',						'SUK_JAHAZI_GRANT_UNIT_ABILITY'),
					('ABILITY_SUK_JAHAZI',						'SUK_JAHAZI_IGNORE_TERRAIN'),

					('ABILITY_SUK_JAHAZI_EMBARKED_MOVEMENT',	'SUK_JAHAZI_MOVEMENT_SPEED'),
					('ABILITY_SUK_JAHAZI_EMBARKED_MOVEMENT',	'SUK_JAHAZI_IGNORE_TERRAIN');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(ModifierId,							ModifierType,										SubjectRequirementSetId)
			VALUES	('SUK_JAHAZI_GRANT_UNIT_ABILITY',		'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',				'SUK_JAHAZI_AOE'),

					('SUK_JAHAZI_MOVEMENT_SPEED',			'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',				NULL),
					('SUK_JAHAZI_IGNORE_TERRAIN',			'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_TERRAIN_COST',	NULL);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,							Name,				Value)
			VALUES	('SUK_JAHAZI_GRANT_UNIT_ABILITY',		'AbilityType',		'ABILITY_SUK_JAHAZI_EMBARKED_MOVEMENT'),

					('SUK_JAHAZI_MOVEMENT_SPEED',			'Amount',			1),
					('SUK_JAHAZI_IGNORE_TERRAIN',			'Ignore',			1),
					('SUK_JAHAZI_IGNORE_TERRAIN',			'Type',				'ALL');
	--------------------------------------------------------------------
	-- REQUIREMENTS
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT INTO RequirementSets
					(RequirementSetId,		RequirementSetType)
			VALUES	('SUK_JAHAZI_AOE',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT INTO RequirementSetRequirements
					(RequirementSetId,		RequirementId)
			VALUES	('SUK_JAHAZI_AOE',		'AOE_REQUIRES_OWNER_ADJACENCY'),
					('SUK_JAHAZI_AOE',		'REQUIRES_SUK_JAHAZI_PLOT_IS_WATER');

			UPDATE RequirementSetRequirements
			SET RequirementId = 'REQUIRES_UNIT_IS_EMBARKED'
			WHERE
				RequirementId = 'REQUIRES_SUK_JAHAZI_PLOT_IS_WATER'
				AND RequirementSetId = 'SUK_JAHAZI_AOE'
				AND EXISTS (SELECT * FROM Requirements WHERE RequirementId = 'REQUIRES_UNIT_IS_EMBARKED');
		----------------------
		-- Requirements
		----------------------
			INSERT INTO Requirements
					(RequirementId, 						RequirementType)
			VALUES	('REQUIRES_SUK_JAHAZI_PLOT_IS_WATER',	'REQUIREMENT_PLOT_TERRAIN_CLASS_MATCHES');
		----------------------
		-- RequirementArguments
		----------------------
			INSERT INTO RequirementArguments
					(RequirementId, 						Name,				Value)
			VALUES	('REQUIRES_SUK_JAHAZI_PLOT_IS_WATER', 	'TerrainClass',		'TERRAIN_CLASS_WATER');
--==========================================================================================================================
-- Add the Jahazi to the production bonuses for:
	-- Maritime Industries
	-- Press Gangs
	-- International Waters
--==========================================================================================================================
	-- Modifiers
	--------------------------------------------------------------------
		-- PolicyModifiers
		-------------------------------------
			INSERT INTO PolicyModifiers
				(
					PolicyType,
					ModifierId
				)
			SELECT DISTINCT
					PolicyType,
					'POLICY_SUK_JAHAZI_PRODUCTION'
			FROM PolicyModifiers WHERE ModifierId LIKE '%/_ANCIENT/_NAVAL/_MELEE/_PRODUCTION' ESCAPE  '/';
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(ModifierId,							ModifierType)
			VALUES	('POLICY_SUK_JAHAZI_PRODUCTION',		'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_PRODUCTION');
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,							Name,			Value)
			VALUES	('POLICY_SUK_JAHAZI_PRODUCTION',		'UnitType',		'UNIT_SUK_JAHAZI'),
					('POLICY_SUK_JAHAZI_PRODUCTION',		'Amount',		100);
--==========================================================================================================================
-- AI
--==========================================================================================================================
	-- AiListTypes
	-------------------------------------
		INSERT INTO AiListTypes
				(ListType)
		VALUES	('Suk_Swahili_Jahazi');
	-------------------------------------
	-- AiLists
	-------------------------------------
		INSERT INTO AiLists
				(ListType,							LeaderType,										System)
		VALUES	('Suk_Swahili_Jahazi',				'TRAIT_CIVILIZATION_UNIT_SUK_JAHAZI',			'Units');
	-------------------------------------
	-- AiFavoredItems
	-------------------------------------
		INSERT INTO AiFavoredItems
				(
					ListType,
					Item,
					Favored,
					Value
				)
		VALUES	('Suk_Swahili_Jahazi',	'UNIT_SUK_JAHAZI',		1,		1);
--==========================================================================================================================
--==========================================================================================================================