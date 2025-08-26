--========================================================================================================================
-- Automated Stuff
-- Some of this can be automated...
-- Your really just need to populate this table below
-- and provide 5 resource names. Everything else will be done for you!
-- (stolen from Sukritact)
--========================================================================================================================
	-- PREPARATION
	--------------------------------------------------------------------
		CREATE TEMPORARY TABLE "p0kResources"(
			"ResourceType" 					TEXT,
			"ResourceTypeShort" 			TEXT,
			"ResourceEffectDescription" 	TEXT,
			"SingularResourceName"			TEXT
		);

		INSERT INTO p0kResources
				(ResourceType,					ResourceTypeShort,			ResourceEffectDescription,		SingularResourceName)
		VALUES	("RESOURCE_P0K_PENGUINS",		"P0K_PENGUINS",				'SCIENCE_YIELD_BONUS',			'Penguin'),
				("RESOURCE_CVS_POMEGRANATES",	"CVS_POMEGRANATES",			'FAITH_YIELD_BONUS',			'Pomegranates'),
				("RESOURCE_P0K_PAPYRUS",		"P0K_PAPYRUS",				'SCIENCE_YIELD_BONUS',			'Papyrus'),
				("RESOURCE_P0K_MAPLE",			"P0K_MAPLE",				'CITY_GROWTH_DISCOUNT',			'Maple'),
				("RESOURCE_P0K_OPAL",			"P0K_OPAL",					'GOLD_YIELD_BONUS',				'Opal'),
				("RESOURCE_P0K_PLUMS",			"P0K_PLUMS",				'CULTURE_YIELD_BONUS',			'Plums');
	--------------------------------------------------------------------
	-- PRODUCT
	--------------------------------------------------------------------
		-- Name
		-------------------------------------
			INSERT OR REPLACE INTO BaseGameText
					(
						Tag,
						Text
					)
			SELECT
				"LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||ResourceTypeShort||"_NAME",
				"[ICON_"||ResourceType||"] "||SingularResourceName||" Corporation: Create New Product"
			FROM p0kResources;
		-------------------------------------
		-- Short Name
		-------------------------------------
			INSERT OR REPLACE INTO BaseGameText
					(
						Tag,
						Text
					)
			SELECT
				"LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||ResourceTypeShort||"_SHORT_NAME",
				"[ICON_"||ResourceType||"] Create New "||SingularResourceName||" Product"
			FROM p0kResources;
		-------------------------------------
		-- Description
		-------------------------------------
			INSERT OR REPLACE INTO BaseGameText
					(
						Tag,
						Text
					)
			SELECT
				"LOC_PROJECT_CREATE_CORPORATION_PRODUCT_"||ResourceTypeShort||"_DESCRIPTION",
				"Create a new product for the world based on the [ICON_"||ResourceType||"] "||SingularResourceName||" resource. {LOC_INDUSTRY_"||ResourceEffectDescription||"_DESCRIPTION}"
			FROM p0kResources;
		-------------------------------------
		-- Pedia Blurb
		-------------------------------------
			INSERT OR REPLACE INTO BaseGameText
					(
						Tag,
						Text
					)
			SELECT
				"LOC_PEDIA_CONCEPTS_"||ResourceTypeShort,
				"[NEWLINE][ICON_BULLET] {LOC_"||ResourceType||"_NAME}: {LOC_P0K_RESOURCE_"||ResourceEffectDescription||"_DESCRIPTION}"
			FROM p0kResources;
--========================================================================================================================
-- Civilopedia Entry
--========================================================================================================================
UPDATE LocalizedText
	SET Text = Text || "[NEWLINE][NEWLINE]CIVITAS Resources:"||(SELECT GROUP_CONCAT("{LOC_PEDIA_CONCEPTS_"||ResourceTypeShort||"}","") FROM p0kResources)
	WHERE Tag = "LOC_PEDIA_CONCEPTS_PAGE_MONOPOLIES_CHAPTER_INDUSTRIES_PARA_2";
--========================================================================================================================
-- Product Effects
--========================================================================================================================
INSERT OR REPLACE INTO BaseGameText
		(Tag,					Text)
VALUES
		(
			"LOC_P0K_RESOURCE_CITY_GROWTH_DISCOUNT_DESCRIPTION",
			"+20% Growth and +3 [ICON_Housing] Housing."
		),
		(
			"LOC_P0K_RESOURCE_MILITARY_UNIT_DISCOUNT_DESCRIPTION",
			"+30% [ICON_Production] Production toward military units."
		),
		(
			"LOC_P0K_RESOURCE_CIVILIAN_UNIT_DISCOUNT_DESCRIPTION",
			"+30% [ICON_Production] Production toward civilian units."
		),
		(
			"LOC_P0K_RESOURCE_BUILDING_DISCOUNT_DESCRIPTION",
			"+30% [ICON_Production] Production toward buildings."
		),
		(
			"LOC_P0K_RESOURCE_GOLD_YIELD_BONUS_DESCRIPTION",
			"+25% [ICON_Gold] Gold yield."
		),
		(
			"LOC_P0K_RESOURCE_FAITH_YIELD_BONUS_DESCRIPTION",
			"+25% [ICON_Faith] Faith yield."
		),
		(
			"LOC_P0K_RESOURCE_SCIENCE_YIELD_BONUS_DESCRIPTION",
			"+15% [ICON_Science] Science yield."
		),
		(
			"LOC_P0K_RESOURCE_CULTURE_YIELD_BONUS_DESCRIPTION",
			"+20% [ICON_Culture] Culture yield."
		);
--========================================================================================================================
-- Product Names
--========================================================================================================================
INSERT OR REPLACE INTO BaseGameText
		(Tag,					Text)
VALUES
	--------------------------------------------------------------------
	-- Penguins
	--------------------------------------------------------------------
		(
			"LOC_GREATWORK_PRODUCT_P0K_PENGUINS_1_NAME",
			"Flightless Bird Photo Book"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_PENGUINS_2_NAME",
			"Build-a-Pengu Plushy"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_PENGUINS_3_NAME",
			"Webbers the Penguin Books for Kids"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_PENGUINS_4_NAME",
			"A Study of Penguin Social Behaviour"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_PENGUINS_5_NAME",
			"Penguin-Shaped Gummy Treats"
		),
	--------------------------------------------------------------------
	-- Pomegranates
	--------------------------------------------------------------------
		(
			"LOC_GREATWORK_PRODUCT_CVS_POMEGRANATES_1_NAME",
			"Tree-Fresh Pomegranate Juice"
		),
		(
			"LOC_GREATWORK_PRODUCT_CVS_POMEGRANATES_2_NAME",
			"Chocolate Pom-Pom"
		),
		(
			"LOC_GREATWORK_PRODUCT_CVS_POMEGRANATES_3_NAME",
			"Winter Supplements"
		),
		(
			"LOC_GREATWORK_PRODUCT_CVS_POMEGRANATES_4_NAME",
			"A Treatise on Fruit Cultivation"
		),
		(
			"LOC_GREATWORK_PRODUCT_CVS_POMEGRANATES_5_NAME",
			"All-Natural Red Dye"
		),
	--------------------------------------------------------------------
	-- Papyrus
	--------------------------------------------------------------------
		(
			"LOC_GREATWORK_PRODUCT_P0K_PAPYRUS_1_NAME",
			"Ancient Egyptian Scroll"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_PAPYRUS_2_NAME",
			"History Museum Gift Shop Scroll"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_PAPYRUS_3_NAME",
			"Thutmose's  Papyrus Love Letters"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_PAPYRUS_4_NAME",
			"A Beginner's Guide to Hieroglyphics"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_PAPYRUS_5_NAME",
			"Potted Paper Reed"
		),

	--------------------------------------------------------------------
	-- Maple
	--------------------------------------------------------------------
		(
			"LOC_GREATWORK_PRODUCT_P0K_MAPLE_1_NAME",
			"Genuine Canadian Maple Syrup"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_MAPLE_2_NAME",
			"SuperFoods Maple Brittle"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_MAPLE_3_NAME",
			"Red Maple Seeds"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_MAPLE_4_NAME",
			"Autumn Moon Maple Painting"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_MAPLE_5_NAME",
			"Maple Wood Dresser"
		),
	--------------------------------------------------------------------
	-- Opal
	--------------------------------------------------------------------
		(
			"LOC_GREATWORK_PRODUCT_P0K_OPAL_1_NAME",
			"Opal Engagement Ring"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_OPAL_2_NAME",
			"Opal Necklace"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_OPAL_3_NAME",
			"Opal Earrings"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_OPAL_4_NAME",
			"Opal Meteoerite Men's Ring"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_OPAL_5_NAME",
			"Black Opal Geode"
		),
	--------------------------------------------------------------------
	-- Plums
	--------------------------------------------------------------------
		(
			"LOC_GREATWORK_PRODUCT_P0K_PLUMS_1_NAME",
			"Perry Plum and the Magic Seeds"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_PLUMS_2_NAME",
			"Ornamental Plum Bonsai Tree"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_PLUMS_3_NAME",
			"Plum Seed Slingshot Set"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_PLUMS_4_NAME",
			"Dried Plums"
		),
		(
			"LOC_GREATWORK_PRODUCT_P0K_PLUMS_5_NAME",
			"Plum Tired: A Guide To Improving Sleep Habits"
		);