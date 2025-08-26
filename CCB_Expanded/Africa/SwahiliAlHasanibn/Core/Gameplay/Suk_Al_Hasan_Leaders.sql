--==========================================================================================================================
-- LOADING INFO
--==========================================================================================================================
	-- LoadingInfo
	-------------------------------------
		INSERT INTO LoadingInfo
				(LeaderType,					ForegroundImage,					BackgroundImage,						PlayDawnOfManAudio)
		VALUES	('LEADER_SUK_AL_HASAN',			'LEADER_SUK_AL_HASAN_NEUTRAL',		'LEADER_SUK_AL_HASAN_BACKGROUND',		0);
--==========================================================================================================================
-- LEADERS
--==========================================================================================================================
	-- Types
	-------------------------------------
		INSERT INTO Types
				(Type,						Kind)
		VALUES	('LEADER_SUK_AL_HASAN',		'KIND_LEADER');
	-------------------------------------
	-- Leaders
	-------------------------------------
		INSERT INTO Leaders
				(LeaderType,					Name,								InheritFrom,		SceneLayers)
		VALUES	('LEADER_SUK_AL_HASAN',			'LOC_LEADER_SUK_AL_HASAN_NAME',		'LEADER_DEFAULT',	4);
	-------------------------------------
	-- LeaderQuotes
	-------------------------------------
		INSERT INTO LeaderQuotes
				(LeaderType,					Quote)
		VALUES	('LEADER_SUK_AL_HASAN',			'LOC_PEDIA_LEADERS_PAGE_SUK_AL_HASAN_QUOTE');
	-------------------------------------
	-- LeaderTraits
	-------------------------------------
		INSERT INTO LeaderTraits
				(LeaderType,					TraitType)
		VALUES	('LEADER_SUK_AL_HASAN',			'TRAIT_LEADER_SUK_HUSUNI_KUBWA');
	-- -------------------------------------
	-- -- FavoredReligions
	-- -------------------------------------
		INSERT OR REPLACE INTO FavoredReligions
				(LeaderType,					ReligionType)
		VALUES	('LEADER_SUK_AL_HASAN',			'RELIGION_ISLAM');
--==========================================================================================================================
-- TRAITS
--==========================================================================================================================
	-- Types
	-------------------------------------
		INSERT OR REPLACE INTO Types
				(Type,									Kind)
		VALUES	('TRAIT_LEADER_SUK_HUSUNI_KUBWA',		'KIND_TRAIT');
	-------------------------------------
	-- Traits
	-------------------------------------
		INSERT INTO Traits
			(
				TraitType,
				Name,
				Description
			)
		SELECT
				'TRAIT_LEADER_SUK_HUSUNI_KUBWA',
				'LOC_TRAIT_LEADER_SUK_HUSUNI_KUBWA_NAME',
				CASE WHEN EXISTS (SELECT * FROM GameEffects WHERE Type = 'EFFECT_ADJUST_CITY_YIELD_PER_FLOOD') THEN
					'LOC_TRAIT_LEADER_SUK_HUSUNI_KUBWA_XP2_DESCRIPTION'
				ELSE
					'LOC_TRAIT_LEADER_SUK_HUSUNI_KUBWA_DESCRIPTION'
				END AS Description;
--==========================================================================================================================
-- Harbours adjacent to a City Centre provide +3 Housing.
-- Harbours adjacent to a Wonder provide +1 Trade Route Capacity.
--==========================================================================================================================
	-- MODIFIERS
	------------------------------------------------------------------------------------------------------------------------
		-- TraitModifiers
		-------------------------------------
			INSERT INTO TraitModifiers
					(TraitType,							ModifierId)
			VALUES	('TRAIT_LEADER_SUK_HUSUNI_KUBWA', 	'SUK_HUSUNI_KUBWA_HARBOR_HOUSING'),
					('TRAIT_LEADER_SUK_HUSUNI_KUBWA', 	'SUK_HUSUNI_KUBWA_HARBOR_TRADE_SLOT');

			DELETE FROM TraitModifiers
				WHERE ModifierId = 'SUK_HUSUNI_KUBWA_HARBOR_HOUSING'
				AND EXISTS (SELECT * FROM GameEffects WHERE Type = 'EFFECT_ADJUST_CITY_YIELD_PER_FLOOD');
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
					'SUK_HUSUNI_KUBWA_HARBOR_HOUSING',
					'MODIFIER_PLAYER_DISTRICTS_ADJUST_HOUSING',
					'SUK_SWAHILI_DISTRICT_HARBOR_ADJACENT_TO_CITY_CENTER'
				),
				(
					'SUK_HUSUNI_KUBWA_HARBOR_TRADE_SLOT',
					'MODIFIER_PLAYER_DISTRICTS_ADJUST_TRADE_ROUTE_CAPACITY',
					'SUK_SWAHILI_DISTRICT_HARBOR_ADJACENT_TO_WONDER'
				);
		-------------------------------------
		-- ModifierArguments
		-------------------------------------
			INSERT INTO ModifierArguments
					(ModifierId,								Name,				Value)
			VALUES	('SUK_HUSUNI_KUBWA_HARBOR_HOUSING',			'Amount',			3),
					('SUK_HUSUNI_KUBWA_HARBOR_TRADE_SLOT',		'Amount',			1);
	------------------------------------------------------------------------------------------------------------------------
	-- REQUIREMENTS
	------------------------------------------------------------------------------------------------------------------------
		-- RequirementSets
		--------------------------------------------------------------------------
			INSERT INTO RequirementSets
					(RequirementSetId,										RequirementSetType)
			VALUES	('SUK_SWAHILI_DISTRICT_HARBOR_ADJACENT_TO_WONDER',		'REQUIREMENTSET_TEST_ALL');
		--------------------------------------------------------------------------
		-- RequirementSetRequirements
		--------------------------------------------------------------------------
			INSERT INTO RequirementSetRequirements
					(RequirementSetId,										RequirementId)
			VALUES	('SUK_SWAHILI_DISTRICT_HARBOR_ADJACENT_TO_WONDER',		'REQUIRES_DISTRICT_IS_HARBOR'),
					('SUK_SWAHILI_DISTRICT_HARBOR_ADJACENT_TO_WONDER',		'REQUIRES_PLOT_ADJACENT_TO_WONDER');
--==========================================================================================================================
-- Patronage of Great People costs 20% less Gold.
--==========================================================================================================================
	-- MODIFIERS
	------------------------------------------------------------------------------------------------------------------------
		-- TraitModifiers
		-------------------------------------
			INSERT INTO TraitModifiers
					(TraitType,										ModifierId)
			VALUES	('TRAIT_LEADER_SUK_HUSUNI_KUBWA', 				'SUK_HUSUNI_KUBWA_PATRONAGE_DISCOUNT');
		-------------------------------------
		-- Modifiers
		-------------------------------------
		INSERT INTO Modifiers
			(
				ModifierId,
				ModifierType
			)
		VALUES
			(
				'SUK_HUSUNI_KUBWA_PATRONAGE_DISCOUNT',
				'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_PATRONAGE_DISCOUNT_PERCENT'
			);
		-------------------------------------
		-- ModifierArguments
		-------------------------------------
			INSERT INTO ModifierArguments
					(ModifierId,									Name,				Value)
			VALUES	('SUK_HUSUNI_KUBWA_PATRONAGE_DISCOUNT',			'YieldType',		'YIELD_GOLD'),
					('SUK_HUSUNI_KUBWA_PATRONAGE_DISCOUNT',			'Amount',			20);
--==========================================================================================================================
-- AGENDAS
-- Father of Gifts
--==========================================================================================================================
	-- -- HistoricalAgendas
	-- -------------------------------------
	INSERT INTO HistoricalAgendas
			(LeaderType,					AgendaType)
	VALUES	('LEADER_SUK_AL_HASAN',			'AGENDA_SUK_FATHER_OF_GIFTS');
	-------------------------------------
	-- Agendas
	-------------------------------------
	INSERT INTO Agendas
			(AgendaType,							Name,											Description)
	VALUES	('AGENDA_SUK_FATHER_OF_GIFTS',			'LOC_AGENDA_SUK_FATHER_OF_GIFTS_NAME',			'LOC_AGENDA_SUK_FATHER_OF_GIFTS_DESCRIPTION');
	-------------------------------------
	-- AgendaTraits
	-------------------------------------
	INSERT INTO AgendaTraits
			(AgendaType,							TraitType)
	VALUES	('AGENDA_SUK_FATHER_OF_GIFTS',			'TRAIT_AGENDA_SUK_FATHER_OF_GIFTS');
	-------------------------------------
	-- Types
	-------------------------------------
	INSERT INTO Types
			(Type,										Kind)
	VALUES	('TRAIT_AGENDA_SUK_FATHER_OF_GIFTS',		'KIND_TRAIT');
	-------------------------------------
	-- Traits
	-------------------------------------
	INSERT INTO Traits
			(TraitType,										Name,											Description)
	VALUES	('TRAIT_AGENDA_SUK_FATHER_OF_GIFTS',			'LOC_AGENDA_SUK_FATHER_OF_GIFTS_NAME',			'LOC_AGENDA_SUK_FATHER_OF_GIFTS_DESCRIPTION');
	-------------------------------------
	-- TraitModifiers
	-------------------------------------
	INSERT INTO TraitModifiers
			(TraitType,														ModifierId)
	VALUES	('TRAIT_AGENDA_SUK_FATHER_OF_GIFTS', 							'AGENDA_SUK_FATHER_OF_GIFTS_KUDOS'),
			('TRAIT_AGENDA_SUK_FATHER_OF_GIFTS', 							'AGENDA_SUK_FATHER_OF_GIFTS_WARNING');
	----------------------------------------------------------------------------------------------------------------------------
	-- MODIFIERS
	----------------------------------------------------------------------------------------------------------------------------
	-- Modifiers
	-------------------------------------
	INSERT INTO Modifiers
			(ModifierId,												ModifierType,											SubjectRequirementSetId)
	VALUES	('AGENDA_SUK_FATHER_OF_GIFTS_KUDOS',						'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',			'SUK_FATHER_OF_GIFTS_KUDOS'),
			('AGENDA_SUK_FATHER_OF_GIFTS_WARNING',						'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER',			'SUK_FATHER_OF_GIFTS_WARNING');
	-------------------------------------
	-- ModifierArguments
	-------------------------------------
	INSERT INTO ModifierArguments
			(ModifierId,												Name,					Value)
	VALUES	('AGENDA_SUK_FATHER_OF_GIFTS_KUDOS',				'InitialValue',					8),
			('AGENDA_SUK_FATHER_OF_GIFTS_KUDOS',				'StatementKey',					'LOC_DIPLO_KUDO_LEADER_SUK_AL_HASAN_REASON_ANY'),
			('AGENDA_SUK_FATHER_OF_GIFTS_KUDOS',				'SimpleModifierDescription',	'LOC_DIPLO_MODIFIER_SUK_FATHER_OF_GIFTS_KUDO'),

			('AGENDA_SUK_FATHER_OF_GIFTS_WARNING',				'InitialValue',					-12),
			('AGENDA_SUK_FATHER_OF_GIFTS_WARNING',				'StatementKey',					'LOC_DIPLO_WARNING_LEADER_SUK_AL_HASAN_REASON_ANY'),
			('AGENDA_SUK_FATHER_OF_GIFTS_WARNING',				'SimpleModifierDescription',	'LOC_DIPLO_MODIFIER_SUK_FATHER_OF_GIFTS_WARNING');
	-------------------------------------
	-- ModifierStrings
	-------------------------------------
	INSERT INTO ModifierStrings
			(ModifierId,										Context,                        Text)
	VALUES	('AGENDA_SUK_FATHER_OF_GIFTS_KUDOS',				'Sample',						'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL'),
			('AGENDA_SUK_FATHER_OF_GIFTS_WARNING',				'Sample',						'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL');
	----------------------------------------------------------------------------------------------------------------------------
	-- REQUIREMENTS
	----------------------------------------------------------------------------------------------------------------------------
	-- RequirementSets
	-------------------------------------
	INSERT INTO RequirementSets
			(RequirementSetId,											RequirementSetType)
	VALUES	('SUK_FATHER_OF_GIFTS_KUDOS',								'REQUIREMENTSET_TEST_ALL'),
			('SUK_FATHER_OF_GIFTS_WARNING',								'REQUIREMENTSET_TEST_ALL');
	-------------------------------------
	-- RequirementSetRequirements
	-------------------------------------
	INSERT INTO RequirementSetRequirements
			(RequirementSetId,									RequirementId)
	VALUES	('SUK_FATHER_OF_GIFTS_KUDOS',						'REQUIRES_FATHER_OF_GIFTS_HAS_DISTRICTS'),
			('SUK_FATHER_OF_GIFTS_KUDOS',						'REQUIRES_FATHER_OF_GIFTS_HAS_GREAT_PEOPLE'),
			('SUK_FATHER_OF_GIFTS_KUDOS',						'REQUIRES_MAJOR_CIV_OPPONENT'),
			('SUK_FATHER_OF_GIFTS_KUDOS',						'REQUIRES_MET_10_TURNS_AGO'),

			('SUK_FATHER_OF_GIFTS_WARNING',						'REQUIRES_FATHER_OF_GIFTS_LACKS_DISTRICTS'),
			('SUK_FATHER_OF_GIFTS_WARNING',						'REQUIRES_FATHER_OF_GIFTS_HAS_GREAT_PEOPLE'),
			('SUK_FATHER_OF_GIFTS_WARNING',						'REQUIRES_MAJOR_CIV_OPPONENT'),
			('SUK_FATHER_OF_GIFTS_WARNING',						'REQUIRES_MET_10_TURNS_AGO');
	-- -------------------------------------
	-- -- Requirements
	-- -------------------------------------
	INSERT INTO Requirements
			(RequirementId, 													RequirementType)
	VALUES	('REQUIRES_FATHER_OF_GIFTS_HAS_DISTRICTS',							'REQUIREMENT_PLAYER_DISTRICT_THRESHOLD'),
			('REQUIRES_FATHER_OF_GIFTS_LACKS_DISTRICTS',						'REQUIREMENT_PLAYER_DISTRICT_THRESHOLD'),
			('REQUIRES_FATHER_OF_GIFTS_HAS_GREAT_PEOPLE',						'REQUIREMENT_PLAYER_GOT_GREAT_PERSON');
	-- -------------------------------------
	-- -- RequirementArguments
	-- -------------------------------------
	INSERT INTO RequirementArguments
			(RequirementId, 												Name,							Value)
	VALUES	('REQUIRES_FATHER_OF_GIFTS_HAS_DISTRICTS',						'DistrictPercentThreshold',		60),
			('REQUIRES_FATHER_OF_GIFTS_HAS_DISTRICTS',						'MinDistrictsNeeded',			3),
			('REQUIRES_FATHER_OF_GIFTS_HAS_DISTRICTS',						'AboveThreshold',				1),

			('REQUIRES_FATHER_OF_GIFTS_LACKS_DISTRICTS',					'DistrictPercentThreshold',		60),
			('REQUIRES_FATHER_OF_GIFTS_LACKS_DISTRICTS',					'MinDistrictsNeeded',			3),
			('REQUIRES_FATHER_OF_GIFTS_LACKS_DISTRICTS',					'AboveThreshold',				0),

			('REQUIRES_FATHER_OF_GIFTS_HAS_GREAT_PEOPLE',					'GreatPersonRatio',				0.8),
			('REQUIRES_FATHER_OF_GIFTS_HAS_GREAT_PEOPLE',					'MinimumDelta',					2);
--==========================================================================================================================
-- AI
--==========================================================================================================================
	-- AiListTypes
	-------------------------------------
		INSERT INTO AiListTypes
				(ListType)
		VALUES	('Suk_Al_Hasan_CoastalSettlements'),
				('Suk_Al_Hasan_Wonders'),
				('Suk_Al_Hasan_DistrictBuilds'),
				('Suk_Al_Hasan_Techs');
	-------------------------------------
	-- AiLists
	-------------------------------------
		INSERT INTO AiLists
				(ListType,							AgendaType,										System)
		VALUES	('Suk_Al_Hasan_CoastalSettlements',	'TRAIT_AGENDA_SUK_FATHER_OF_GIFTS',				'PlotEvaluations'),
				('Suk_Al_Hasan_Wonders',			'TRAIT_AGENDA_SUK_FATHER_OF_GIFTS',				'Buildings'),
				('Suk_Al_Hasan_DistrictBuilds',		'TRAIT_AGENDA_SUK_FATHER_OF_GIFTS',				'Districts'),
				('Suk_Al_Hasan_Techs',				'TRAIT_AGENDA_SUK_FATHER_OF_GIFTS',				'Technologies');
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
		VALUES	('Suk_Al_Hasan_CoastalSettlements',	'Coastal',						0,		35),

				('Suk_Al_Hasan_Wonders',			'BUILDING_GREAT_LIGHTHOUSE',	1,		0),
				('Suk_Al_Hasan_Wonders',			'BUILDING_COLOSSUS',			1,		0),
				('Suk_Al_Hasan_Wonders',			'BUILDING_VENETIAN_ARSENAL',	1,		0),
				('Suk_Al_Hasan_Wonders',			'BUILDING_KILWA_KISIWANI',		1,		0),

				('Suk_Al_Hasan_DistrictBuilds',		'DISTRICT_HARBOR',				1,		0),

				('Suk_Al_Hasan_Techs',				'TECH_SAILING',					1,		0),
				('Suk_Al_Hasan_Techs',				'TECH_SHIPBUILDING',			1,		0),
				('Suk_Al_Hasan_Techs',				'TECH_SHIPBUILDING',			1,		0),
				('Suk_Al_Hasan_Techs',				'TECH_APPRENTICESHIP',			1,		0);
--==========================================================================================================================
-- CivilizationLeaders
--==========================================================================================================================
	INSERT INTO CivilizationLeaders
			(LeaderType, 				CivilizationType,				CapitalName)
	VALUES  ('LEADER_SUK_AL_HASAN',		'CIVILIZATION_SUK_SWAHILI',		'LOC_CITY_NAME_SUK_SWAHILI_KILWA_KISIWANI');

	-- UPDATE CivilizationLeaders
	-- SET CapitalName = 'LOC_CITY_NAME_TERNATE'
	-- WHERE LeaderType = 'LEADER_MINOR_CIV_ZANZIBAR'
	-- AND EXISTS (SELECT * FROM CityNames WHERE CityName = 'LOC_CITY_NAME_TERNATE');
--==========================================================================================================================
--==========================================================================================================================