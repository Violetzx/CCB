-- Port Lime - Te Kinich - Colours
-- Author: Li Me
-- DateCreated: 5/31/2024 4:41:47 PM
--------------------------------------------------------------
--======================================================================
--	COLORS
--======================================================================
--	Colors
-------------------------------------
INSERT OR REPLACE INTO Colors
		(Type,									Color)
VALUES
		("COLOR_PLAYER_LL_TEKINICH_II_1",		"206,168,62,255"),	--#CEA83E
		("COLOR_PLAYER_LL_TEKINICH_II_2",		"39,32,10,255"),	--#27200A
		("COLOR_PLAYER_LL_TEKINICH_II_3",		"24,137,82,255"),	--#188952
		("COLOR_PLAYER_LL_TEKINICH_II_4",		"61,17,47,255"),	--#3D112F
		("COLOR_PLAYER_LL_TEKINICH_II_5",		"84,17,17,255"),	--#541111
		("COLOR_PLAYER_LL_TEKINICH_II_6",		"244,71,72,255"),	--#F44748
		("COLOR_PLAYER_LL_TEKINICH_II_7",		"96,12,101,255"),	--#600C65
		("COLOR_PLAYER_LL_TEKINICH_II_8",		"26,211,122,255");	--#1AD37A
-------------------------------------
--	PlayerColors
-------------------------------------
INSERT OR REPLACE INTO PlayerColors
		(
			Type,
			Usage,

			PrimaryColor,
			SecondaryColor,

			Alt1PrimaryColor,
			Alt1SecondaryColor,

			Alt2PrimaryColor,
			Alt2SecondaryColor,

			Alt3PrimaryColor,
			Alt3SecondaryColor
		)
VALUES
		(
			"LEADER_LL_TEKINICH_II",
			"Unique",

			"COLOR_PLAYER_LL_TEKINICH_II_7",
			"COLOR_PLAYER_LL_TEKINICH_II_8",

			"COLOR_PLAYER_LL_TEKINICH_II_5",
			"COLOR_PLAYER_LL_TEKINICH_II_6",

			"COLOR_PLAYER_LL_TEKINICH_II_3",
			"COLOR_PLAYER_LL_TEKINICH_II_4",

			"COLOR_PLAYER_LL_TEKINICH_II_1",
			"COLOR_PLAYER_LL_TEKINICH_II_2"
		);
--======================================================================
--======================================================================