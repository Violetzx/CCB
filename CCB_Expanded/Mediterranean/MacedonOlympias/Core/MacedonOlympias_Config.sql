--==========================================================================================================================
-- CONFIG DATA
--==========================================================================================================================
-- Players
--------------------------------------------------------------------------------------------------------------------------	
INSERT OR REPLACE INTO Players	
		(CivilizationType,			Domain,	Portrait,							 PortraitBackground,		 LeaderType,			LeaderName,						 LeaderIcon,				  LeaderAbilityName,							 LeaderAbilityDescription,								LeaderAbilityIcon,			CivilizationName,	CivilizationIcon,	CivilizationAbilityName, CivilizationAbilityDescription, CivilizationAbilityIcon)
SELECT	'CIVILIZATION_MACEDON',		Domain,	'LEADER_JFD_OLYMPIAS_NEUTRAL.dds',	 'LEADER_GORGO_BACKGROUND',	 'LEADER_JFD_OLYMPIAS',	'LOC_LEADER_JFD_OLYMPIAS_NAME',  'ICON_LEADER_JFD_OLYMPIAS',  'LOC_TRAIT_LEADER_JFD_CABEIRI_MYSTERIES_NAME', 'LOC_TRAIT_LEADER_JFD_CABEIRI_MYSTERIES_DESCRIPTION',  'ICON_LEADER_JFD_OLYMPIAS',	CivilizationName,	CivilizationIcon,	CivilizationAbilityName, CivilizationAbilityDescription, CivilizationAbilityIcon
FROM Players WHERE CivilizationType = 'CIVILIZATION_MACEDON' AND LeaderType = 'LEADER_ALEXANDER';	
--------------------------------------------------------------------------------------------------------------------------
-- PlayerItems
--------------------------------------------------------------------------------------------------------------------------	
INSERT OR REPLACE INTO PlayerItems	
		(CivilizationType,			Domain,	LeaderType,				Type, Icon, Name, Description, SortIndex)
SELECT	'CIVILIZATION_MACEDON',		Domain,	'LEADER_JFD_OLYMPIAS',	Type, Icon, Name, Description, SortIndex   
FROM PlayerItems WHERE CivilizationType = 'CIVILIZATION_MACEDON' AND LeaderType = 'LEADER_ALEXANDER' AND NOT Type IN ('UNIT_MACEDONIAN_HETAIROI');	
--==========================================================================================================================
--==========================================================================================================================