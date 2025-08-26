--========================================================================================================================
-- LocalizedText
--========================================================================================================================
INSERT OR REPLACE INTO BaseGameText
		(Tag,					Text)
VALUES
--========================================================================================================================
-- Gaul
--========================================================================================================================
		("LOC_CIVILIZATION_SUK_GAUL_NAME",
		"Gaul"),
		("LOC_CIVILIZATION_SUK_GAUL_DESCRIPTION",
		"Gallic Empire"),
		("LOC_CIVILIZATION_SUK_GAUL_ADJECTIVE",
		"Gallic"),
		-- RWF
		("LOC_CIVILIZATION_SUK_GAUL_DESCRIPTION_JFD_CIVILIZATION",
		"Gallic Civilization"),
--------------------------------------------------------------------
-- UA
--------------------------------------------------------------------
		("LOC_TRAIT_CIVILIZATION_SUK_TORCS_AND_CARNYXES_NAME",
		"Torcs and Carnyxes"),
		("LOC_TRAIT_CIVILIZATION_SUK_TORCS_AND_CARNYXES_DESCRIPTION",
		"Cities founded on resources improved by a Mine provide that resource’s yield modifier to adjacent tiles. When adjacent to mineable resources, Encampments provide +2 [ICON_Production] Production, +1 [ICON_Housing] Housing, and Commercial Hubs provide +2 [ICON_Gold] Gold, +1 [ICON_Amenities] Amenity."),

		("LOC_TRAIT_CIVILIZATION_GAUL_DESCRIPTION_REWORK",
		"Cities founded on resources improved by a Mine provide that resource’s yield modifier to adjacent tiles. Mines provide a minor adjacency bonus for all districts, and a Culture Bomb of unowned territory. Specialty districts do not receive a minor adjacency for being adjacent to another district."),
--========================================================================================================================
-- Oathsworn
--========================================================================================================================
		("LOC_UNIT_SUK_OATHSWORN_NAME",
		"Oathsworn"	),
		("LOC_UNIT_SUK_OATHSWORN_DESCRIPTION",
		"Gallic unique Classical Era unit that replaces the Swordsman. +5 [ICON_Strength] Combat Strength in Hills and Woods. When an Oathsworn is killed in combat, all friendly adjacent land combat units heal for 40 [ICON_Damaged] Health."),
		("LOC_PEDIA_UNITS_PAGE_UNIT_SUK_OATHSWORN_CHAPTER_HISTORY_PARA_1",
		"The longsword was a weapon of high worth and status within the Celtic community. A warrior had to prove himself in battle many times before he was permitted to wield one. The two-handed longsword was first developed during the 8th century BC, but fell from favour before re-emerging around 450BC. It is possible that Celtic ironwork was significantly behind that of the Romans, as apparently their longswords bent very easily and had to be straightened against the ground. On the other hand, since Celtic ironworking was several centuries old, some believe that Roman accounts of this practice mistook this practise, and it was actually a ritual to ‘decommission’ defeated, dishonoured or damaged weapons."),
--========================================================================================================================
-- Gaesatae
--========================================================================================================================
		("LOC_UNIT_GAUL_GAESATAE_REWORK_DESCRIPTION",
		"Gallic unique Ancient era unit that replaces the Warrior. This unit has increased cost and receives +10 [ICON_Strength] Combat Strength when fighting units with a higher base Combat Strength. When an Gaesatae is killed in combat, all friendly adjacent land combat units heal for 30 [ICON_Damaged] Health."),

		("LOC_ABILITY_GAESATAE_REWORK_DESCRIPTION",
		"Receive +10 [ICON_Strength] Combat Strength against units with a higher base Combat Strength."),
--========================================================================================================================
-- Unit Abilities
--========================================================================================================================
		("LOC_ABILITY_OATHSWORN_COMBAT_BONUS_NAME",
		"Oathsworn Combat Strength"),
		("LOC_ABILITY_OATHSWORN_COMBAT_BONUS_DESCRIPTION",
		"Receive +5 [ICON_Strength] Combat Strength in Hills and Woods."),
		("LOC_ABILITY_OATHSWORN_COMBAT_BONUS_COMBAT_PREVIEW",
		"+{1_Amount} [ICON_Strength] Combat Strength bonus in Hills and Woods."),

		("LOC_ABILITY_OATHSWORN_HEALING_NAME",
		"Oathsworn Healing"),
		("LOC_ABILITY_OATHSWORN_HEALING_DESCRIPTION",
		"When killed in combat, all friendly adjacent land combat units heal for 40 [ICON_Damaged] Health."),

		("LOC_ABILITY_SUK_GAUL_GAESATAE_HEALING_NAME",
		"Oathsworn"),
		("LOC_ABILITY_SUK_GAUL_GAESATAE_HEALING_DESCRIPTION",
		"When killed in combat, all friendly adjacent land combat units heal for 30 [ICON_Damaged] Health."),
--========================================================================================================================
-- Dūnon (UTI)
--========================================================================================================================
		("LOC_IMPROVEMENT_SUK_DUNON_NAME",
		"Dūnon"	),
		("LOC_IMPROVEMENT_SUK_DUNON_DESCRIPTION",
		"Unlocks the Builder ability to construct a Dūnon, unique to Gaul.[NEWLINE][NEWLINE]+1 [ICON_Food] Food, +1 [ICON_Housing] Housing. +1 [ICON_Production] Production if built on a Hill. Occupying unit receives +4 [ICON_Strength] Defense Strength, and automatically gains 2 turns of fortification.[NEWLINE][NEWLINE]The Dūnon must be built on a Camp or Pasture resource and provides that resource’s yield modifier to adjacent tiles. One per City. Tiles with Dūnons cannot be swapped."),
		("LOC_IMPROVEMENT_SUK_DUNON_REWORK_DESCRIPTION",
		"Unlocks the Builder ability to construct a Dūnon, unique to Gaul.[NEWLINE][NEWLINE]+1 [ICON_Food] Food, +1 [ICON_Housing] Housing. +1 [ICON_Production] Production if built on a Hill. Friendly units within 1 tile of a Dūnon receive +5 [ICON_Strength] Combat Strength.[NEWLINE][NEWLINE]The Dūnon must be built on a Camp or Pasture resource and provides that resource’s yield modifier to adjacent tiles. One per City. Tiles with Dūnons cannot be swapped."),
		("LOC_PEDIA_IMPROVEMENTS_PAGE_IMPROVEMENT_SUK_DUNON_CHAPTER_HISTORY_PARA_1",
		"An oppidum, or a dūnon is a large fortified Iron Age settlement. Most were built on fresh sites, usually on an elevated position. Such a location would have allowed the settlement to dominate nearby trade routes and may also have been important as a symbol of control of the area. While some dūnons grew from hill forts, by no means all of them had significant defensive functions. The development of dūnons was a milestone in the urbanisation of the continent as they were the first large settlements north of the Alps that could genuinely be described as towns. continued in use until the Romans began conquering Iron Age Europe. Even in the lands north of the River Danube that remained unconquered by the Romans, dūnons were abandoned by the late 1st century AD. In conquered lands, the Romans used the infrastructure of the dūnons to administer the empire, and many became full Roman towns. This often involved a change of location from the hilltop into the plain."),

		("LOC_IMPROVEMENT_SUK_DUNON_COMBAT_BONUS_PREVIEW",
		"+{1_Amount} Combat Strength bonus from the adjacent Dūnon."),
--========================================================================================================================
-- Dūnon (UD)
--========================================================================================================================
		("LOC_DISTRICT_OPPIDUM_REWORK_DESCRIPTION",
		"A district unique to Gaul that is cheaper and available earlier than the district it replaces, the Industrial Zone. The {LOC_DISTRICT_OPPIDUM_NAME} is defensible with a ranged attack.[NEWLINE][NEWLINE]+1 [ICON_Food] Food for each adjacent Camp or Pasture. +2 [ICON_Production] Production for each adjacent Quarry or Strategic Resource. Cannot be built adjacent to a City Center."),

		("LOC_DISTRICT_OPPIDUM_PASTUREFOOD",
		"+{1_num} [ICON_Food] Food from the adjacent {1_Num : plural 1?Pasture; other?Pastures;}."),
		("LOC_DISTRICT_OPPIDUM_CAMPFOOD",
		"+{1_num} [ICON_Food] Food from the adjacent {1_Num : plural 1?Camp; other?Camps;}."),
--========================================================================================================================
-- Vercingetorix
--========================================================================================================================
		("LOC_LEADER_SUK_VERCINGETORIX_NAME",
		"Vercingetorix"	),
--------------------------------------------------------------------
-- ULA
--------------------------------------------------------------------
		("LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME",
		"Gallic Confederation"),
		("LOC_TRAIT_LEADER_SUK_GALLIC_WAR_DESCRIPTION",
		"Your units receive +1 [ICON_Strength] Combat Strength for each type of City-State you are Suzerain of. Receive a free [ICON_Envoy] Envoy whenever you recruit a [ICON_GreatGeneral] Great General. When an Encampment or Dūnon is built, receive Ancient Walls in that City."	),
		("LOC_TRAIT_LEADER_SUK_GALLIC_WAR_DESCRIPTION_DLC",
		"Your units receive +1 [ICON_Strength] Combat Strength for each type of City-State you are Suzerain of. Receive a free [ICON_Envoy] Envoy whenever you recruit a [ICON_GreatGeneral] Great General. When an Encampment or {LOC_DISTRICT_OPPIDUM_NAME} is built, receive Ancient Walls in that City."	),

		("LOC_ABILITY_SUK_GALLIC_WAR_COMBAT_DESCRIPTION",
		"+1 [ICON_Strength] Combat Strength for each type of City-State you are Suzerain of (Gallic Confederation)"	),

		("LOC_ABILITY_SUK_GALLIC_WAR_COMBAT_STRENGTH_LEADER_MINOR_CIV_TRADE_DESCRIPTION",
		"+{1_Amount} [ICON_Strength] ({LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME} - {LOC_CITY_STATES_TYPE_TRADE})"),
		("LOC_ABILITY_SUK_GALLIC_WAR_COMBAT_STRENGTH_LEADER_MINOR_CIV_SCIENTIFIC_DESCRIPTION",
		"+{1_Amount} [ICON_Strength] ({LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME} - {LOC_CITY_STATES_TYPE_SCIENTIFIC})"),
		("LOC_ABILITY_SUK_GALLIC_WAR_COMBAT_STRENGTH_LEADER_MINOR_CIV_RELIGIOUS_DESCRIPTION",
		"+{1_Amount} [ICON_Strength] ({LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME} - {LOC_CITY_STATES_TYPE_RELIGIOUS})"),
		("LOC_ABILITY_SUK_GALLIC_WAR_COMBAT_STRENGTH_LEADER_MINOR_CIV_MILITARISTIC_DESCRIPTION",
		"+{1_Amount} [ICON_Strength] ({LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME} - {LOC_CITY_STATES_TYPE_MILITARISTIC})"),
		("LOC_ABILITY_SUK_GALLIC_WAR_COMBAT_STRENGTH_LEADER_MINOR_CIV_INDUSTRIAL_DESCRIPTION",
		"+{1_Amount} [ICON_Strength] ({LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME} - {LOC_CITY_STATES_TYPE_INDUSTRIAL})"),
		("LOC_ABILITY_SUK_GALLIC_WAR_COMBAT_STRENGTH_LEADER_MINOR_CIV_CULTURAL_DESCRIPTION",
		"+{1_Amount} [ICON_Strength] ({LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME} - {LOC_CITY_STATES_TYPE_CULTURAL})"),
		("LOC_ABILITY_SUK_GALLIC_WAR_COMBAT_STRENGTH_LEADER_MINOR_CIV_CSE_AGRICULTURAL_DESCRIPTION",
		"+{1_Amount} [ICON_Strength] ({LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME} - {LOC_CITY_STATES_TYPE_CSE_AGRICULTURAL})"),
		("LOC_ABILITY_SUK_GALLIC_WAR_COMBAT_STRENGTH_LEADER_MINOR_CIV_CSE_CONSULAR_DESCRIPTION",
		"+{1_Amount} [ICON_Strength] ({LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME} - {LOC_CITY_STATES_TYPE_CSE_CONSULAR})"),
		("LOC_ABILITY_SUK_GALLIC_WAR_COMBAT_STRENGTH_LEADER_MINOR_CIV_CSE_ENTERTAINMENT_DESCRIPTION",
		"+{1_Amount} [ICON_Strength] ({LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME} - {LOC_CITY_STATES_TYPE_CSE_ENTERTAINMENT})"),
		("LOC_ABILITY_SUK_GALLIC_WAR_COMBAT_STRENGTH_LEADER_MINOR_CIV_CSE_MARITIME_DESCRIPTION",
		"+{1_Amount} [ICON_Strength] ({LOC_TRAIT_LEADER_SUK_GALLIC_WAR_NAME} - {LOC_CITY_STATES_TYPE_CSE_MARITIME})"),
--------------------------------------------------------------------
-- Agenda
--------------------------------------------------------------------
		("LOC_AGENDA_SUK_KING_OVER_WARRIORS_NAME",
		"King Over Warriors"),
		("LOC_AGENDA_SUK_KING_OVER_WARRIORS_DESCRIPTION",
		"Likes civilizations with strong armies, but only if they don’t own any captured cities."),

		("LOC_DIPLO_MODIFIER_SUK_KING_OVER_WARRIORS_KUDO",
		"Vercingetorix admires your strong armies"),

		("LOC_DIPLO_MODIFIER_SUK_KING_OVER_WARRIORS_WARNING",
		"Vercingetorix thinks your army is a threat to his civilization"),
--========================================================================================================================
-- Game Modes
--========================================================================================================================
		('LOC_GAMEMODE_SUK_GAULREWORK_NAME',
		'Sukritact’s Gaul Rework'),
		('LOC_GAMEMODE_SUK_GAULREWORK_DESCRIPTION',
		'This game mode adjusts the Gallic Civilization added by the New Frontier Pass to better match Sukritact’s Gaul Mod.[NEWLINE][NEWLINE]Gaul’s unique ability is modified to bring back bonuses from founding cities on minable resources. To compensate they will no longer receive [ICON_Culture] Culture from Mines. In order to allow them to make proper use of Harbors and the Diplomatic Quarter, the restriction against placing specialty districts adjacent to the City Center is removed. However, they still do not receive the minor adjacency bonus from adjacent districts.[NEWLINE][NEWLINE]The {LOC_DISTRICT_OPPIDUM_NAME} now receives +1 [ICON_Food] Food for each adjacent Camp or Pasture, and constructing it no longer unlocks Apprenticeship. It still cannot be build adjacent to the City Center.[NEWLINE][NEWLINE]A more extensive rework option may be found under Advanced Setup while this Game Mode is enabled.'),

		('LOC_GAMEMODE_SUK_GAULREWORKPLUS_NAME',
		'Sukritact’s Gaul Rework++'),
		('LOC_GAMEMODE_SUK_GAULREWORKPLUS_DESCRIPTION',
		'Further adjusts Firaxis’s Gallic Civilization. The {LOC_DISTRICT_OPPIDUM_NAME} Unique District is removed and replaced by the {LOC_IMPROVEMENT_SUK_DUNON_NAME} Unique Tile Improvement from the mod. The {LOC_UNIT_GAUL_GAESATAE_NAME} is altered to better match the {LOC_UNIT_SUK_OATHSWORN_NAME}—healing adjacent units as they perish.');
--========================================================================================================================
--========================================================================================================================