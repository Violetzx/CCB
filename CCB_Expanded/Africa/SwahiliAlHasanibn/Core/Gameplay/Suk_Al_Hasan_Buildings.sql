--==========================================================================================================================
-- BUILDINGS
--==========================================================================================================================
	-- Types
	----------------------
		INSERT INTO Types
				(Type,								Kind)
		VALUES	('BUILDING_SUK_PILLAR_TOMB',		'KIND_BUILDING');
	----------------------
	-- Buildings
	----------------------
		INSERT INTO Buildings
			(
				BuildingType,
				Name,
				Description,

				TraitType,
				PrereqDistrict,

				PurchaseYield,
				Cost,
				Maintenance,

				AdvisorType
			)
		SELECT
				'BUILDING_SUK_PILLAR_TOMB',
				'LOC_BUILDING_SUK_PILLAR_TOMB_NAME',
				CASE WHEN EXISTS (
					SELECT * FROM BuildingModifiers
						WHERE BuildingType = 'BUILDING_MONUMENT'
						AND ModifierId = 'MONUMENT_LOYALTY'
				) THEN
					'LOC_BUILDING_SUK_PILLAR_TOMB_XP1_DESCRIPTION'
				ELSE
					'LOC_BUILDING_SUK_PILLAR_TOMB_DESCRIPTION'
				END AS Description,

				'TRAIT_CIVILIZATION_BUILDING_SUK_PILLAR_TOMB',
				PrereqDistrict,

				PurchaseYield,
				ROUND(Cost*0.66),
				Maintenance,

				AdvisorType
		FROM Buildings WHERE BuildingType = 'BUILDING_MONUMENT';
	----------------------
	-- BuildingReplaces
	----------------------
		INSERT INTO BuildingReplaces
					(CivUniqueBuildingType,					ReplacesBuildingType)
		VALUES		('BUILDING_SUK_PILLAR_TOMB',			'BUILDING_MONUMENT');
	----------------------
	-- Building_YieldChanges
	----------------------
		INSERT INTO Building_YieldChanges
				(BuildingType,					YieldType,		YieldChange)
		SELECT	'BUILDING_SUK_PILLAR_TOMB',		YieldType, 		YieldChange
		FROM Building_YieldChanges WHERE BuildingType = 'BUILDING_MONUMENT';
--==========================================================================================================================
-- +1 Loyalty.
--==========================================================================================================================
	-- BuildingModifiers
	--------------------------------------------------------------------
		INSERT INTO BuildingModifiers
						(BuildingType,							ModifierId)
		SELECT DISTINCT	'BUILDING_SUK_PILLAR_TOMB',				ModifierId
		FROM BuildingModifiers
			WHERE BuildingType = 'BUILDING_MONUMENT'
			AND ModifierId = 'MONUMENT_LOYALTY';
--==========================================================================================================================
-- International Trade Routes from this city generate +1 Gold, +1 Culture for each district adjacent to the City Centre.
-- BBG Change, +2 gold +1 science every 2 district adjacent
--==========================================================================================================================
	-- PREPARATION
	--------------------------------------------------------------------
		CREATE TEMPORARY TABLE "Suk_PillarTomb"(
			"YieldType"		TEXT,
			"MinReq" 		INT,
			"Amount"		INT
		);

		INSERT INTO Suk_PillarTomb
				(YieldType,		Amount, 	MinReq) VALUES
				('YIELD_GOLD',	2,			2),		('YIELD_SCIENCE',	1,	2),
				('YIELD_GOLD',	2,			4),		('YIELD_SCIENCE',	1,	4),
				('YIELD_GOLD',	2,			6),		('YIELD_SCIENCE',	1,	6);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- BuildingModifiers
		----------------------
			INSERT INTO BuildingModifiers
							(BuildingType,					ModifierId)
			SELECT DISTINCT	'BUILDING_SUK_PILLAR_TOMB',		'SUK_PILLAR_TOMB_'||MinReq||'_'||YieldType
			FROM Suk_PillarTomb;
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
				(
					ModifierId,
					ModifierType,
					SubjectRequirementSetId
				)
			SELECT DISTINCT
					'SUK_PILLAR_TOMB_'||MinReq||'_'||YieldType,
					'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',
					'SUK_PILLAR_TOMB_'||MinReq||'_REQUREMENTS'
			FROM Suk_PillarTomb;
		----------------------
		-- ModifierArguments
		----------------------
			WITH CTE(Name) AS
				(
					SELECT * FROM (VALUES
						('YieldType'),
						('Amount')
					)
				)
			INSERT INTO ModifierArguments
				(
					ModifierId,
					Name,
					Value
				)
			SELECT DISTINCT
					'SUK_PILLAR_TOMB_'||MinReq||'_'||YieldType,
					Name,
					CASE WHEN (Name = 'YieldType')
						THEN YieldType
						ELSE Amount
					END AS Value
			FROM Suk_PillarTomb CROSS JOIN CTE;
	----------------------------------------------------------
	-- REQUIREMENTS
	----------------------------------------------------------
		-- RequirementSets
		-------------------------------------
			INSERT INTO RequirementSets
					(RequirementSetId,							RequirementSetType)
			VALUES	('SUK_PILLAR_TOMB_ADJACENT_DISTRICT',		'REQUIREMENTSET_TEST_ALL');

			INSERT INTO RequirementSets
				(
					RequirementSetId,
					RequirementSetType
				)
			SELECT DISTINCT
					'SUK_PILLAR_TOMB_'||MinReq||'_REQUREMENTS',
					'REQUIREMENTSET_TEST_ALL'
			FROM Suk_PillarTomb;
		-------------------------------------
		-- RequirementSetRequirements
		-------------------------------------
			INSERT INTO RequirementSetRequirements
					(RequirementSetId,							RequirementId)
			VALUES	('SUK_PILLAR_TOMB_ADJACENT_DISTRICT',		'REQUIRES_SUK_DISTRICT_IS_NOT_WONDER'),
					('SUK_PILLAR_TOMB_ADJACENT_DISTRICT',		'REQUIRES_SUK_ADJACENT_TO_PILLAR_TOMB');

			INSERT INTO RequirementSetRequirements
				(
					RequirementSetId,
					RequirementId
				)
			SELECT DISTINCT
					'SUK_PILLAR_TOMB_'||MinReq||'_REQUREMENTS',
					'REQUIRES_SUK_PILLAR_TOMB_'||MinReq
			FROM Suk_PillarTomb;
		-------------------------------------
		-- Requirements
		-------------------------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 							RequirementType,						Inverse)
			VALUES	('REQUIRES_SUK_DISTRICT_IS_NOT_WONDER',		'REQUIREMENT_DISTRICT_TYPE_MATCHES',	1),
					('REQUIRES_SUK_ADJACENT_TO_PILLAR_TOMB',	'REQUIREMENT_PLOT_ADJACENT_TO_OWNER',	0);

			INSERT INTO Requirements
				(
					RequirementId,
					RequirementType
				)
			SELECT DISTINCT
					'REQUIRES_SUK_PILLAR_TOMB_'||MinReq,
					'REQUIREMENT_COLLECTION_COUNT_ATLEAST'
			FROM Suk_PillarTomb;
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
					(RequirementId, 							Name,				Value)
			VALUES	('REQUIRES_SUK_DISTRICT_IS_NOT_WONDER', 	'DistrictType',		'DISTRICT_WONDER'),
					('REQUIRES_SUK_ADJACENT_TO_PILLAR_TOMB', 	'MinDistance',		1),
					('REQUIRES_SUK_ADJACENT_TO_PILLAR_TOMB', 	'MaxDistance',		2);

			WITH CTE(Name, Value) AS
				(
					SELECT * FROM (VALUES
						('CollectionType',			'COLLECTION_PLAYER_DISTRICTS'),
						('RequirementSetId',		'SUK_PILLAR_TOMB_ADJACENT_DISTRICT'),
						('Count',					NULL)
					)
				)
			INSERT INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			SELECT DISTINCT
					'REQUIRES_SUK_PILLAR_TOMB_'||MinReq,
					CTE.Name,
					CASE WHEN (CTE.Value IS NULL) THEN
						MinReq
					ELSE
						CTE.Value
					END AS Value
			FROM Suk_PillarTomb CROSS JOIN CTE;
--==========================================================================================================================
--==========================================================================================================================