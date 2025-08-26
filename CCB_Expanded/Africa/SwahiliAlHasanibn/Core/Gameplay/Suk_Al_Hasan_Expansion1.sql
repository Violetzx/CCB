-- Suk_SwahiliSwahili_Expansion1
-- Author: Sukrit
-- DateCreated: 2/13/2018 8:53:59 PM
--==========================================================================================================================
UPDATE Buildings
SET Description = 'LOC_BUILDING_SUK_PILLAR_TOMB_XP1_DESCRIPTION'
WHERE BuildingType = 'BUILDING_SUK_PILLAR_TOMB';
--==========================================================================================================================\
-- MomentIllustrations
--==========================================================================================================================
INSERT INTO MomentIllustrations
		(MomentIllustrationType, 					MomentDataType,				GameDataType,						Texture)
VALUES	('MOMENT_ILLUSTRATION_UNIQUE_UNIT', 		'MOMENT_DATA_UNIT',			'UNIT_SUK_JAHAZI',					'Moment_UniqueUnit_Suk_Swahili.dds'),
		('MOMENT_ILLUSTRATION_UNIQUE_BUILDING', 	'MOMENT_DATA_BUILDING',		'BUILDING_SUK_PILLAR_TOMB',			'Moment_Infrastructure_Suk_Swahili.dds');
--==========================================================================================================================
--==========================================================================================================================