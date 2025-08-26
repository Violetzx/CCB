--=============================================================================================================
-- INDUSTRIES
--=============================================================================================================
-- Improvement_ValidResources
-------------------------------------------------------
INSERT OR REPLACE INTO Improvement_ValidResources
		(ImprovementType,			ResourceType,					MustRemoveFeature)
VALUES	('IMPROVEMENT_INDUSTRY',	'RESOURCE_P0K_PENGUINS',		0),
		('IMPROVEMENT_INDUSTRY',	'RESOURCE_CVS_POMEGRANATES',	0),
		('IMPROVEMENT_INDUSTRY',	'RESOURCE_P0K_PAPYRUS',			0),
		('IMPROVEMENT_INDUSTRY',	'RESOURCE_P0K_MAPLE',			0),
		('IMPROVEMENT_INDUSTRY',	'RESOURCE_P0K_OPAL',			0),
		('IMPROVEMENT_INDUSTRY',	'RESOURCE_P0K_PLUMS',			0),	
		('IMPROVEMENT_CORPORATION',	'RESOURCE_P0K_PENGUINS',		0),
		('IMPROVEMENT_CORPORATION',	'RESOURCE_CVS_POMEGRANATES',	0),
		('IMPROVEMENT_CORPORATION',	'RESOURCE_P0K_PAPYRUS',			0),
		('IMPROVEMENT_CORPORATION',	'RESOURCE_P0K_MAPLE',			0),
		('IMPROVEMENT_CORPORATION',	'RESOURCE_P0K_OPAL',			0),
		('IMPROVEMENT_CORPORATION',	'RESOURCE_P0K_PLUMS',			0);
-------------------------------------------------------
-- ResourceIndustries
-------------------------------------------------------
INSERT INTO ResourceIndustries
		(ResourceType,					ResourceEffect,					ResourceEffectText)
VALUES	('RESOURCE_P0K_PENGUINS',		'INDUSTRY_SCIENCE_YIELD_BONUS',	'LOC_INDUSTRY_SCIENCE_YIELD_BONUS_DESCRIPTION'),
		('RESOURCE_CVS_POMEGRANATES',	'INDUSTRY_FAITH_YIELD_BONUS',	'LOC_INDUSTRY_FAITH_YIELD_BONUS_DESCRIPTION'),
		('RESOURCE_P0K_PAPYRUS',		'INDUSTRY_SCIENCE_YIELD_BONUS',	'LOC_INDUSTRY_SCIENCE_YIELD_BONUS_DESCRIPTION'),
		('RESOURCE_P0K_MAPLE',			'INDUSTRY_CITY_GROWTH',			'LOC_INDUSTRY_CITY_GROWTH_DISCOUNT_DESCRIPTION'),
		('RESOURCE_P0K_OPAL',			'INDUSTRY_GOLD_YIELD_BONUS',	'LOC_INDUSTRY_GOLD_YIELD_BONUS_DESCRIPTION'),
		('RESOURCE_P0K_PLUMS',			'INDUSTRY_CULTURE_YIELD_BONUS',	'LOC_INDUSTRY_CULTURE_YIELD_BONUS_DESCRIPTION');
-------------------------------------------------------
-- ResourceCorporations
-------------------------------------------------------
INSERT INTO ResourceCorporations
		(ResourceType,					ResourceEffect,							ResourceEffectText)
VALUES	('RESOURCE_P0K_PENGUINS',		'CORPORATION_SCIENCE_YIELD_BONUS',		'LOC_CORPORATION_SCIENCE_YIELD_BONUS_DESCRIPTION'),
		('RESOURCE_CVS_POMEGRANATES',	'CORPORATION_FAITH_YIELD_BONUS',		'LOC_CORPORATION_FAITH_YIELD_BONUS_DESCRIPTION'),
		('RESOURCE_P0K_PAPYRUS',		'CORPORATION_SCIENCE_YIELD_BONUS',		'LOC_CORPORATION_SCIENCE_YIELD_BONUS_DESCRIPTION'),
		('RESOURCE_P0K_MAPLE',			'CORPORATION_CITY_GROWTH',				'LOC_CORPORATION_CITY_GROWTH_DISCOUNT_DESCRIPTION'),
		('RESOURCE_P0K_OPAL',			'CORPORATION_GOLD_YIELD_BONUS',			'LOC_CORPORATION_GOLD_YIELD_BONUS_DESCRIPTION'),
		('RESOURCE_P0K_PLUMS',			'CORPORATION_CULTURE_YIELD_BONUS',		'LOC_CORPORATION_CULTURE_YIELD_BONUS_DESCRIPTION');
-------------------------------------------------------
-- RequirementArguments
-------------------------------------------------------
UPDATE RequirementArguments
SET Value = Value || ", RESOURCE_P0K_PENGUINS"
WHERE RequirementId = "REQUIREMENT_SCIENCE_BONUS_RESOURCE" AND Name = "ResourceType";

UPDATE RequirementArguments
SET Value = Value || ", RESOURCE_CVS_POMEGRANATES"
WHERE RequirementId = "REQUIREMENT_FAITH_BONUS_RESOURCE" AND Name = "ResourceType";

UPDATE RequirementArguments
SET Value = Value || ", RESOURCE_P0K_PAPYRUS"
WHERE RequirementId = "REQUIREMENT_SCIENCE_BONUS_RESOURCE" AND Name = "ResourceType";

UPDATE RequirementArguments
SET Value = Value || ", RESOURCE_P0K_MAPLE"
WHERE RequirementId = "REQUIREMENT_CITY_GROWTH_RESOURCE" AND Name = "ResourceType";

UPDATE RequirementArguments
SET Value = Value || ", RESOURCE_P0K_OPAL"
WHERE RequirementId = "REQUIREMENT_GOLD_BONUS_RESOURCE" AND Name = "ResourceType";

UPDATE RequirementArguments
SET Value = Value || ", RESOURCE_P0K_PLUMS"
WHERE RequirementId = "REQUIREMENT_CULTURE_BONUS_RESOURCE" AND Name = "ResourceType";
