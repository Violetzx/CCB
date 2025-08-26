-- Suk_SwahiliSwahili_Expansion1
-- Author: Sukrit
-- DateCreated: 2/13/2018 8:53:59 PM
--==========================================================================================================================
														-- UNITS --
--==========================================================================================================================
UPDATE Units
SET
	StrategicResource = (SELECT StrategicResource FROM Units WHERE UnitType = 'UNIT_SWORDSMAN')
WHERE UnitType = 'UNIT_SUK_OATHSWORN';

INSERT INTO Units_XP2	
		(UnitType,						ResourceCost)
SELECT	'UNIT_SUK_OATHSWORN',			ResourceCost/2
FROM Units_XP2 WHERE UnitType = 'UNIT_SWORDSMAN';
--==========================================================================================================================
-- CIVLIZATION_NAMED_PLACES
--==========================================================================================================================
-- NamedRivers
--------------------------------------------------------------------
INSERT INTO NamedRiverCivilizations
			(NamedRiverType,						CivilizationType)
SELECT		NamedRiverType,							'CIVILIZATION_SUK_GAUL'
FROM NamedRiverCivilizations WHERE CivilizationType = 'CIVILIZATION_FRANCE';
--------------------------------------------------------------------
-- NamedMountains
--------------------------------------------------------------------
INSERT INTO NamedMountainCivilizations
			(NamedMountainType,						CivilizationType)
SELECT		NamedMountainType,						'CIVILIZATION_SUK_GAUL'
FROM NamedMountainCivilizations WHERE CivilizationType = 'CIVILIZATION_FRANCE';
--------------------------------------------------------------------
-- NamedVolcanoes
--------------------------------------------------------------------
INSERT INTO NamedVolcanoCivilizations
			(NamedVolcanoType,						CivilizationType)
SELECT		NamedVolcanoType,						'CIVILIZATION_SUK_GAUL'
FROM NamedVolcanoCivilizations WHERE CivilizationType = 'CIVILIZATION_FRANCE';
--==========================================================================================================================
--==========================================================================================================================