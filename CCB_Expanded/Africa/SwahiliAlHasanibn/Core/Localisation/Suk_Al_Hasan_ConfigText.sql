--========================================================================================================================
-- LocalizedText
--========================================================================================================================
-- Swahili
--========================================================================================================================
	INSERT OR REPLACE INTO BaseGameText (Tag, Text, Gender, Plurality)	VALUES
		(
			"LOC_CIVILIZATION_SUK_SWAHILI_NAME",
			"Swahili",
			"Masculine:the",
			2
		);
		-----------------------------
	INSERT OR REPLACE INTO BaseGameText (Tag, Text)	VALUES
		("LOC_CIVILIZATION_SUK_SWAHILI_DESCRIPTION",
		"Swahili Empire"),
		("LOC_CIVILIZATION_SUK_SWAHILI_ADJECTIVE",
		"Swahili"),
		-- RWF
		("LOC_CIVILIZATION_SUK_SWAHILI_DESCRIPTION_JFD_CIVILIZATION",
		"Swahili Civilization"),
	--------------------------------------------------------------------
	-- UA
	--------------------------------------------------------------------
		("LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_NAME",
		"Coral Construction"	),
		("LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_DESCRIPTION",
		"Districts in coastal Cities receive a Major adjacency bonus from the City Center, and a standard bonus from being adjacent to a Harbor."),

		("LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_DESCRIPTION_XP1",
		"Districts in coastal Cities receive a Major adjacency bonus from the City Center, and a standard bonus from being adjacent to a Harbor. +2 [ICON_Production] Production from Reefs."),

		("LOC_SUK_CORAL_CONSTRUCTION_YIELD_GOLD_CITY_CENTER",
		"+{1_num} [ICON_Gold] Gold from the adjacent City Center district ({LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_NAME})."),
		("LOC_SUK_CORAL_CONSTRUCTION_YIELD_GOLD_HARBOR",
		"+{1_num} [ICON_Gold] Gold from the adjacent Harbor district ({LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_NAME})."),

		("LOC_SUK_CORAL_CONSTRUCTION_YIELD_PRODUCTION_CITY_CENTER",
		"+{1_num} [ICON_Production] Production from the adjacent City Center district ({LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_NAME})."),
		("LOC_SUK_CORAL_CONSTRUCTION_YIELD_PRODUCTION_HARBOR",
		"+{1_num} [ICON_Production] Production from the adjacent Harbor district ({LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_NAME})."),

		("LOC_SUK_CORAL_CONSTRUCTION_YIELD_CULTURE_CITY_CENTER",
		"+{1_num} [ICON_Culture] Culture from the adjacent City Center district ({LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_NAME})."),
		("LOC_SUK_CORAL_CONSTRUCTION_YIELD_CULTURE_HARBOR",
		"+{1_num} [ICON_Culture] Culture from the adjacent Harbor district ({LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_NAME})."),

		("LOC_SUK_CORAL_CONSTRUCTION_YIELD_SCIENCE_CITY_CENTER",
		"+{1_num} [ICON_Science] Science from the adjacent City Center district ({LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_NAME})."),
		("LOC_SUK_CORAL_CONSTRUCTION_YIELD_SCIENCE_HARBOR",
		"+{1_num} [ICON_Science] Science from the adjacent Harbor district ({LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_NAME})."),

		("LOC_SUK_CORAL_CONSTRUCTION_YIELD_FAITH_CITY_CENTER",
		"+{1_num} [ICON_Faith] Faith from the adjacent City Center district ({LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_NAME})."),
		("LOC_SUK_CORAL_CONSTRUCTION_YIELD_FAITH_HARBOR",
		"+{1_num} [ICON_Faith] Faith from the adjacent Harbor district ({LOC_TRAIT_CIVILIZATION_SUK_CORAL_CONSTRUCTION_NAME})."),
--========================================================================================================================
-- Jahazi
--========================================================================================================================
		("LOC_UNIT_SUK_JAHAZI_NAME",
		"Jahazi"	),
		("LOC_UNIT_SUK_JAHAZI_DESCRIPTION",
		"Naval support unit, unique to the Swahili. Embarked units within 2 tiles ignore terrain costs and receive +1 [ICON_Movement] Movement. Has 2 [ICON_Charges] charges to build Fishing Boats. Fishing Boats built by a Jahazi yield +1 [ICON_Production] Production, +2 [ICON_Gold] Gold."),
		("LOC_PEDIA_UNITS_PAGE_UNIT_SUK_JAHAZI_CHAPTER_HISTORY_PARA_1",
		"The largest traditional sailing vessel in wide use off the coast of East Africa is the jahazi, which measures up to 20m long and whose large billowing sails are a characteristic sight off Zanzibar and other traditional ports. With a capacity of about a hundred passengers, the jahazi is mainly used for transporting cargo and passengers over relatively long distances or in open water, for instance between Dar es Salaam and Zanzibar. Minor modifications in the Portuguese and Omani eras notwithstanding, the design of the modern jahazi is pretty much identical to that of similar seafaring vessels used in medieval times and before. The name jahazi is generally applied to boats with cutaway bows and square sterns built on Zanzibar and nearby parts of the mainland."),

		("LOC_ABILITY_SUK_JAHAZI_NAME",
		"Juya Nets"),
		("LOC_ABILITY_SUK_JAHAZI_DESCRIPTION",
		"Embarked units within 2 tiles ignore terrain costs and receive +1 [ICON_Movement] Movement.[NEWLINE][ICON_BULLET] Fishing Boats built by this unit yield +1 [ICON_Production] Production, +2 [ICON_Gold] Gold."),

		("LOC_ABILITY_SUK_JAHAZI_EMBARKED_MOVEMENT_NAME",
		"{LOC_UNIT_SUK_JAHAZI_NAME} Movement Bonus"	),
		("LOC_ABILITY_SUK_JAHAZI_EMBARKED_MOVEMENT_DESCRIPTION",
		"Ignores terrain costs and receives +1 [ICON_Movement] Movement. ({LOC_UNIT_SUK_JAHAZI_NAME})"),
--========================================================================================================================
-- Pillar Tomb (UD)
--========================================================================================================================
		("LOC_BUILDING_SUK_PILLAR_TOMB_NAME",
		"Pillar Tomb"	),
		("LOC_BUILDING_SUK_PILLAR_TOMB_DESCRIPTION",
		"A building unique to the Swahili. It is cheaper than the Monument which it replaces. +2 [ICON_Culture] Culture. International [ICON_TradeRoute] Trade Routes from this city generate +1 [ICON_Gold] Gold, +1 [ICON_Culture] Culture for each of this city’s districts that are within 2 tiles of the City Centre."),
		("LOC_BUILDING_SUK_PILLAR_TOMB_XP1_DESCRIPTION",
		"A building unique to the Swahili. It is cheaper than the Monument which it replaces. +1 [ICON_Culture] Culture, +1 Loyalty. International [ICON_TradeRoute] Trade Routes from this city generate +1 [ICON_Gold] Gold, +1 [ICON_Culture] Culture for each of this city’s districts that are within 2 tiles of the City Centre."),
		("LOC_PEDIA_BUILDINGS_PAGE_BUILDING_SUK_PILLAR_TOMB_CHAPTER_HISTORY_PARA_1",
		"One of the most distinctive and enigmatic architectural forms associated with the Swahili were the structures associated with burials. The remains of monumental tomb structures still litter the coastal regions and mark many of the long-vanished centers of Swahili life. The simplest tomb structures were rectangular enclosures, bounded by four low walls, varying in size and scale. The most distinctive and unusual feature of many Swahili medieval tombs was the addition of a tall column-like structure, forming a characteristic building type along the East African coast referred to as pillar tombs. These pillars come in many sizes and shapes, from rounded, square, multisided or fluted and rose to various heights. These pillars, and sometimes parts of the surrounding enclosure walls, were often decorated with inset porcelain or other glazed ceramic bowls imported from southern Arabia, Persia and even as far as China, adding a dash of color to contrast with the brilliant white plaster surfaces, forming a distinctive decorative tradition unique to the medieval East African coast."),
--========================================================================================================================
-- Al-Hasan ibn Sulaiman
--========================================================================================================================
	("LOC_LEADER_SUK_AL_HASAN_NAME",
	"Al-Hasan ibn Sulaiman"	),
	--------------------------------------------------------------------
	-- ULA
	--------------------------------------------------------------------
		("LOC_TRAIT_LEADER_SUK_HUSUNI_KUBWA_NAME",
		"Palace of Husuni Kubwa"	),
		("LOC_TRAIT_LEADER_SUK_HUSUNI_KUBWA_DESCRIPTION",
		"Harbours adjacent to a City Centre provide +3 [ICON_Housing] Housing. Harbours adjacent to a Wonder provide +1 [ICON_TradeRoute] Trade Route Capacity. Patronage of Great People costs 20% less [ICON_Gold] Gold."),
		("LOC_TRAIT_LEADER_SUK_HUSUNI_KUBWA_XP2_DESCRIPTION",
		"Harbours adjacent to a Wonder provide +1 [ICON_TradeRoute] Trade Route Capacity. Patronage of Great People costs 20% less [ICON_Gold] Gold."),
	--------------------------------------------------------------------
	-- Agenda
	--------------------------------------------------------------------
		("LOC_AGENDA_SUK_FATHER_OF_GIFTS_NAME",
		"Father of Gifts"	),
		("LOC_AGENDA_SUK_FATHER_OF_GIFTS_DESCRIPTION",
		"Dislikes civilizations who are competing for Great People if they do not develop their cities. Admires civilizations that maintain the maximum number of districts in most cities and is home to many Great People."	),

		("LOC_DIPLO_KUDO_LEADER_SUK_AL_HASAN_REASON_ANY",
		"(You have well developed cities with many Great People.)"	),
		("LOC_DIPLO_MODIFIER_SUK_FATHER_OF_GIFTS_KUDO",
		"Al Hasan is annoyed you are cramming your great people into underdeveloped cities"	),

		("LOC_DIPLO_WARNING_LEADER_SUK_AL_HASAN_REASON_ANY",
		"(You are competing for Great People, but have ignored city development.)"	),
		("LOC_DIPLO_MODIFIER_SUK_FATHER_OF_GIFTS_WARNING",
		"Al Hasan admires your developed cities and great people"	);
--========================================================================================================================
-- Ternate
--========================================================================================================================
		-- ("LOC_CIVILIZATION_ZANZIBAR_DESCRIPTION",
		-- "Ternate city-state"	),
		-- ("LOC_CIVILIZATION_ZANZIBAR_ADJECTIVE",
		-- "Ternaten"	),
		-- ("LOC_LEADER_TRAIT_ZANZIBAR_NAME",
		-- "Ternate Suzerain Bonus"	),
		-- ("LOC_CIVILIZATION_ZANZIBAR_NAME",
		-- "Ternate"	),

		-- ("LOC_CITY_NAME_ZANZIBAR_1",
		-- "Ternate"	),
		-- ("LOC_CITY_NAME_ZANZIBAR",
		-- "Ternate"	),

		-- ("LOC_PEDIA_CITYSTATES_PAGE_CIVILIZATION_ZANZIBAR_CHAPTER_HISTORY_PARA_1",
		-- "The sultanate was originally named the Kingdom of Gapi, but later changed the name to be based off its capital, Ternate. Ternate and neighbouring Tidore were the world's single major producer of cloves, upon which their rulers became among the wealthiest and most powerful sultans in the Indonesian region. Much of their wealth, however, was wasted fighting each other. Up until the Dutch completed the colonisation of Maluku in the 19th century, the Sultans of Ternate ruled empires that claimed at least nominal influence as far as Ambon, Sulawesi and Papua."	),
		-- ("LOC_PEDIA_CITYSTATES_PAGE_CIVILIZATION_ZANZIBAR_CHAPTER_HISTORY_PARA_2",
		-- "In part as a result of its trade-dependent culture, Ternate was one of the earliest places in the region to which Islam spread, probably coming from Java in the late 15th century. Initially, the faith was restricted to Ternate's small ruling family, and spread only slowly to the rest of the population."	),
		-- ("LOC_PEDIA_CITYSTATES_PAGE_CIVILIZATION_ZANZIBAR_CHAPTER_HISTORY_PARA_3",
		-- "From the 16th century onwards, the Ternate sultanate fell under the sway of the European colonial powers, first the Portuguese were permitted to build a fort on the island, but relations between the Ternateans and Portuguese were strained from the start, due to the generally poor behaviour of the Portuguese, combined with feeble attempts at Christianisation. The Ternateans expelled the Portuguese in 1575 after a five-year siege."	),
		-- ("LOC_PEDIA_CITYSTATES_PAGE_CIVILIZATION_ZANZIBAR_CHAPTER_HISTORY_PARA_4",
		-- "Spanish forces captured the former Portuguese fort from the Ternatese in 1606, deporting the Ternate Sultan and his entourage to Manila. In 1607 the Dutch came back to Ternate, where with the help of Ternateans they built a fort in Malayo. The island was divided between the two powers: the Spaniards were allied with Tidore and the Dutch with their Ternaten allies. Desiring to restore Ternate to its former glory and expel the western power, Sultan Sibori of Ternate (1675–1691) declared war to the Dutch, but the power of Ternate had greatly reduced over the years, he lost and was forced to concede more of his lands to the Dutch by an unjust treaty in 1683. By this treaty, Ternate had lost its equal position with the Dutch and became a vassal. However, the Sultans of Ternate and its people were never fully under Dutch control."	),
		-- ("LOC_PEDIA_CITYSTATES_PAGE_CIVILIZATION_ZANZIBAR_CHAPTER_HISTORY_PARA_5",
		-- "Sultan Haji Muhammad Usman (1896–1914) made a last attempt to drive out the Dutch by instigating revolts in the region; he failed and was dethroned, his wealth being confiscated, and he was exiled to Bandung, where he lived his remaining years until 1927. The throne of Ternate was left vacant from 1914 to 1927, until the board of ministers under the blessing of the Dutch created Crown Prince Iskandar Muhammad Jabir the next Sultan. The dynasty founded by Baab Mashur Malamo continues to the present, as does the Sultanate itself, although it no longer holds any political power."),
--========================================================================================================================
-- Husuni Kubwa (XP1 Wonder)
--========================================================================================================================
		-- ("LOC_BUILDING_KILWA_KISIWANI_NAME",
		-- "Husuni Kubwa"	);
--========================================================================================================================
--========================================================================================================================