--==========================================================================================================================
-- ICONS
--==========================================================================================================================
-- IconTextureAtlases
-------------------------------------	
INSERT INTO IconTextureAtlases
    (Name, IconSize, IconsPerRow, IconsPerColumn, Filename)
VALUES ('ICON_ATLAS_SUK_TIBET', 256, 5, 1, 'Suk_Tibet_Atlas_256.dds'),
       ('ICON_ATLAS_SUK_TIBET', 200, 5, 1, 'Suk_Tibet_Atlas_200.dds'),
       ('ICON_ATLAS_SUK_TIBET', 128, 5, 1, 'Suk_Tibet_Atlas_128.dds'),
       ('ICON_ATLAS_SUK_TIBET', 95, 5, 1, 'Suk_Tibet_Atlas_95.dds'),
       ('ICON_ATLAS_SUK_TIBET', 80, 5, 1, 'Suk_Tibet_Atlas_80.dds'),
       ('ICON_ATLAS_SUK_TIBET', 70, 5, 1, 'Suk_Tibet_Atlas_70.dds'),
       ('ICON_ATLAS_SUK_TIBET', 64, 5, 1, 'Suk_Tibet_Atlas_64.dds'),
       ('ICON_ATLAS_SUK_TIBET', 55, 5, 1, 'Suk_Tibet_Atlas_55.dds'),
       ('ICON_ATLAS_SUK_TIBET', 50, 5, 1, 'Suk_Tibet_Atlas_50.dds'),
       ('ICON_ATLAS_SUK_TIBET', 48, 5, 1, 'Suk_Tibet_Atlas_48.dds'),
       ('ICON_ATLAS_SUK_TIBET', 45, 5, 1, 'Suk_Tibet_Atlas_45.dds'),
       ('ICON_ATLAS_SUK_TIBET', 40, 5, 1, 'Suk_Tibet_Atlas_40.dds'),
       ('ICON_ATLAS_SUK_TIBET', 38, 5, 1, 'Suk_Tibet_Atlas_38.dds'),
       ('ICON_ATLAS_SUK_TIBET', 36, 5, 1, 'Suk_Tibet_Atlas_36.dds'),
       ('ICON_ATLAS_SUK_TIBET', 32, 5, 1, 'Suk_Tibet_Atlas_32.dds'),
       ('ICON_ATLAS_SUK_TIBET', 30, 5, 1, 'Suk_Tibet_Atlas_30.dds'),
       ('ICON_ATLAS_SUK_TIBET', 22, 5, 1, 'Suk_Tibet_Atlas_22.dds');
-------------------------------------
-- IconDefinitions
-------------------------------------	
INSERT INTO IconDefinitions
    (Name, Atlas, 'Index')
VALUES ('ICON_CIVILIZATION_SUK_TIBET', 'ICON_ATLAS_SUK_TIBET', 0),
       ('ICON_LEADER_SUK_TRISONG_DETSEN', 'ICON_ATLAS_SUK_TIBET', 1),
       ('ICON_DISTRICT_SUK_DZONG', 'ICON_ATLAS_SUK_TIBET', 2),
--       ('ICON_UNIT_SUK_TIBET_RTA_PA', 'ICON_ATLAS_SUK_TIBET', 4),

--       ('ICON_UNIT_SUK_TIBET_RTA_PA_PORTRAIT', 'ICON_ATLAS_SUK_TIBET', 3),
       ('ICON_ETHNICITY_AFRICAN_UNIT_SUK_TIBET_RTA_PA_PORTRAIT', 'ICON_ATLAS_SUK_TIBET', 3),
       ('ICON_ETHNICITY_SOUTHAM_UNIT_SUK_TIBET_RTA_PA_PORTRAIT', 'ICON_ATLAS_SUK_TIBET', 3),
       ('ICON_ETHNICITY_MEDIT_UNIT_SUK_TIBET_RTA_PA_PORTRAIT', 'ICON_ATLAS_SUK_TIBET', 3),
       ('ICON_ETHNICITY_ASIAN_UNIT_SUK_TIBET_RTA_PA_PORTRAIT', 'ICON_ATLAS_SUK_TIBET', 3);
--==========================================================================================================================
--==========================================================================================================================
-- INSERT INTO IconAliases(Name,OtherName)VALUES
-- ('ICON_UNIT_SUK_TIBET_RTA_PA','ICON_UNIT_PERSIAN_IMMORTAL'),
-- ('ICON_UNIT_SUK_TIBET_RTA_PA_PORTRAIT','ICON_UNIT_PERSIAN_IMMORTAL_PORTRAIT');