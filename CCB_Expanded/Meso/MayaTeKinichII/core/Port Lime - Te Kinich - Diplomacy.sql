-- Port Lime - Te Kinich - Diplomacy
-- Author: Limerator
-- DateCreated: 5/31/2024 4:39:37 PM
--------------------------------------------------------------
--------------------------------------------------------------------
-- Historical Agenda
--------------------------------------------------------------------
--	Agenda: Lord Water:
--	Will respect your civilization as long as it has more population than him, but will 
--	ruthlessly invade you otherwise.

INSERT OR REPLACE INTO LocalizedText
		(Language, Tag,	Text)
VALUES	("en_US", 
		"LOC_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER_NAME",					
		"Lord Water"),
		("en_US", 
		"LOC_AGENDA_LIME_MAYA_TE_KINICH_LORD_WATER_DESC",					
		"Will respect your civilization as long as it has more population than him, but will ruthlessly invade you otherwise."),
		
		-- Kudos
		("en_US", 
		"LOC_DIPLO_MODIFIER_LEADER_LL_TEKINICH_II_MOD_AGENDA_LIME_TE_KINICH_LIKES",					
		"Te' K'inich II sees your empire as large enough to deserve respect"),
		("en_US", 
		"LOC_DIPLO_KUDO_EXIT_LEADER_LL_TEKINICH_II_ANY",
		"Your kingdom has clearly been blessed with ample harvest and good omens. It would be foolish to act against you."),
		("en_US", 
		"LOC_DIPLO_MODIFIER_LEADER_LL_TEKINICH_II_ANY",
		"(You have a large population)"),
		-- Warnings
		("en_US", 
		"LOC_DIPLO_MODIFIER_LEADER_LL_TEKINICH_II_MOD_AGENDA_LIME_TE_KINICH_HATES",					
		"Te' K'inich II regards your empire as unpopulous, and therefore weak"),
		("en_US", 
		"LOC_DIPLO_WARNING_EXIT_LEADER_LL_TEKINICH_II_ANY",
		"My priests wonder why Oxhuitzá should acknowledge your whims. I see no reason for it."),
		("en_US", 
		"LOC_DIPLO_MODIFIER_LEADER_LL_TEKINICH_II_MOD_ANY",
		"(Your population is smaller than his)");

--------------------------------------------------------------------
-- Random Agendas
--------------------------------------------------------------------
INSERT OR REPLACE INTO LocalizedText
		(Language, Tag,	Text)
VALUES	--1. AGENDA_AIRPOWER: Tries to build up air power. Admires civilizations with greater air power. Dislikes civilizations with weaker air power.
		--TRAIT_AGENDA_PREFER_AIRPOWER
--		("en_US", 
--		"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_HIGH_AIRPOWER",
--		"There is an underworld, a land of watery creation. There is the earth, the land that is walked by mortals. And there is the sky, a land of gods... and now of men too."),
--		("en_US", 
--		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_LOW_AIRPOWER",
--		"The sky frowns, one can hear through the Yaxche. The heavens are displeased to be so shunned."),
		
		--2. AGENDA_CITY_STATE_ALLY: Likes civilizations that aren't competing for the same city-state allegiance. Dislikes civilizations that are directly competing for city-state allegiance.
		--TRAIT_AGENDA_CITY_STATE_ALLY
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_AGENDA_MODIFIER_NOT_COMPETING_MINORS",
		"You have not infringed upon my vassals. It is more than I can say for others."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_MODIFIER_COMPETING_MINORS",
		"Those city-states must serve the better overlord. It is plain to see who that is."),
		
		--3. AGENDA_CITY_STATE_PROTECTOR: Emphasizes protectorate wars. Admires civilizations that start protectorate wars. Dislikes civilizations that attack city-states.
		--TRAIT_AGENDA_PREFER_CITY_STATE_PROTECTOR
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_HIGH_PROTECT_CITY_STATES",
		"You may conduct your plans without my interference. I see that they have not interfered with mine."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_HIGH_ATTACK_CITY_STATES",
		"Your conquests reveal your schemes. They show an insecure, petty overlord unworthy of respect."),
		
		--4. AGENDA_CIVILIZED: Hates barbarians. Likes civilizations that clear out barbarian outposts. Does not like civilizations that ignore barbarian outposts.
		--TRAIT_AGENDA_PREFER_CLEAR_BANDIT_CAMPS
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_CLEARS_BARBARIAN_CAMPS",
	--	"Those who choose to live in squalor must be destroyed and rebirthed, as the world was. They will return from the waters. They will be better than before."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_IGNORES_BARBARIAN_CAMPS",
	--	"Association with the uncultured masses is to stoop to their level. It debases oneself. The world was not made by this."),
		
		--5. AGENDA_CULTURED: Tries to build up Culture, and likes civilizations that also focus on Culture.
		--TRAIT_AGENDA_PREFER_CULTURE
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_HIGH_CULTURE",
	--	"A culture is painted upon the earth as flowers are painted upon a mural. The murals are colorful. The divine approves."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_LOW_CULTURE",
	--	"The remnants of men are measured by the flowers that they have sown. They are judged by the art they have made. Those who have sown none shall be forgotten foreve."),
		
		--6. AGENDA_DARWINIST: Believes in survival of the fittest. Likes civilizations that are at war.
		--TRAIT_AGENDA_ENJOYS_WAR
	--	("en_US",  --?
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_DARWINIST",
	--	"It is the lot of teotl to be unordered. There is no order, no disorder. There is no chaos nor law. There is only conflict, the fruit and creator of teotl."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_DARWINIST",
	--	"To embrace peace is to shun war, and the cycle of life, death, and rebirth. The jaguar does not make peace with the iguana, nor the coatl and the quetzal."),
		
		--7. AGENDA_DEMAGOGUE: Wants to be the civilization earning the most Diplomatic Favor, dislikes those who compete in Diplomatic Favor.
		--TRAIT_AGENDA_PREFER_NOFAVOR
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_HIGH_FAVOR",
		"Your name may not be as revered as mine, but trust that your place and your service is valued."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_LOW_FAVOR",
		"Do not attempt to surpass me. Oxhuitzá shall not be denied!"),
		
		--8. AGENDA_DESTINATION_CIV: Wants to be the civilization with the most Tourism Tourism, dislikes those who compete in Tourism Tourism.
		--TRAIT_AGENDA_PREFER_NOTOURISM
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_HIGH_TOURISM",
	--	"At the end of the Fourth Sun and the dawn of the Fifth, Teotihuacan stood tall and proud. This is where the giver of life pulled a reborn mankind from the underworld, and shall be the subject of all pilgrimage."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_LOW_TOURISM",
	--	"The divine fire of Teotihuacan can never be matched, and shall never be slighted."),
		
		--9. AGENDA_DEVOUT: Tries to build up Faith, and likes civilizations that also focus on Faith.
		--TRAIT_AGENDA_PREFER_FAITH
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_HIGH_FAITH",
	--	"Teotl cannot be sundered, nor split, nor hampered, only mirrored. It creates itself. It is entangled with life, men, the giver of life, and the deeds of great monarchs."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_LOW_FAITH",
	--	"The Age of the Fourth Sun was ended because of the love of the mother was not requited by men. The Age of the Fifth Sun was reborn from this watery end, but can, too, be drowned."),
		
		--10. AGENDA_ENVIRONMENTALIST: Builds National Parks, doesn't clear features, plants forests. Likes civilizations that plant forests or found National Parks. Dislikes civilizations that clear features.
		--TRAIT_AGENDA_PREFER_ENVIRONMENT
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_ENVIRONMENT",
	--	"The land was created by the divine. It is to be maintained by men. This is fulfilled."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_ENVIRONMENT",
	--	"The land despoilt. A promise is broken. A gift from a mother is forsaken."),
		
		--11. AGENDA_EXPANSIONIST: Tries to include as much territory as possible in their empire. Does not like civilizations who control little territory.
		--TRAIT_AGENDA_EXPANSIONIST
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_EXPANSIONIST",
		"An empire as vast and strong as yours is clearly worthy of respect."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_EXPANSIONIST",
		"Oxhuitzá is an overlord city, and it requires underlings. Prove your strength, lest you become one."),
		
		--12. AGENDA_EXPLOITATIVE: Clears all features and improves all possible tiles. Likes civilizations with a high percentage of improved tiles. Dislikes civilizations with low percentage of improved tiles or that found National Parks.
		--TRAIT_AGENDA_PREFER_EXPLOITATION
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_EXPLOITATIVE",
	--	"A destiny was made to be seized. The land too, was made to be seized."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_EXPLOITATIVE",
	--	"The wonders of the Fifth Sun could not be made without the destruction of the Fourth."),
		
		--13. AGENDA_EXPLORER: Tries to explore the map, and likes civilizations that have explored less of the map than itself and dislikes civilizations that have explored more of the map than itself.
		--TRAIT_AGENDA_EXPLORATION_OBSESSED
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_LOW_EXPLORATION",
	--	"To venture is to show one's face. It is the matter of heroes to see the world."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_HIGH_EXPLORATION",
	--	"If one does not see the world, one cannot embrace it."),
		
		--14. AGENDA_FLAT_EARTHER: Wants to block humankind from circumnavigating the globe or going into space.
		--TRAIT_AGENDA_FLAT_EARTHER
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_FLAT_EARTHER",
	--	"The days are counted. The Fifth Sun lives on. A paradise is a gift. It is meant to lived in, and enjoyed."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_FLAT_EARTHER",
	--	"All the earth is a grave, and nought escapes it. The divine pays no heed to the ambition of men."),
		
		--15. AGENDA_FUN_LOVING: Tries to make the citizens in each city as happy as possible. Likes civilizations that also develop in this fashion.
		--TRAIT_AGENDA_PREFER_HAPPINESS
--		("en_US", 
--		"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_FUN_LOVING",
--		""),
--		("en_US", 
--		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_FUN_LOVING",
--		""),
		
		--16. AGENDA_GOSSIP: Wants to know everything about everyone.
		--TRAIT_AGENDA_GOSSIP
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_GOSSIP_POSITIVE",
		"Rulers need to be careful, lest their plans be seen by you. If I had them, I would need to work hard to conceal them from you."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_GOSSIP_NEGATIVE",
		"Your blindness is legendary. You would not know you've been betrayed until your heart has already been torn from you chest."),
		
		--17. AGENDA_GREAT_PERSON_ADVOCATE: Likes civilizations who are not competing for Great People, and will recruit Great People whenever possible. Dislikes losing a Great Person to another civilization.
		--TRAIT_AGENDA_GREAT_PERSON_ADVOCATE
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_MODIFIER_GREAT_PERSON_ADVOCATE_LAG",
	--	"The wonders of Teotihuacan grow taller evermore. The arts of Teotihuacan grow greater evermore. The legacy of Teotihuacan grows stronger evermore."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_MODIFIER_GREAT_PERSON_ADVOCATE_LEAD",
	--	"The greatest of men are meant for Teotihuacan. This is the only paradise lofty enough to befit them. To keep them from Teotihuacan is to curse them."),
		
		--18. AGENDA_GREAT_WHITE_FLEET: Builds a strong navy and respects civilizations who follow their lead. Does not like civilizations with a weak navy.
		--TRAIT_AGENDA_GREAT_WHITE_FLEET
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_GREAT_WHITE_FLEET",
	--	"Drown all dreams so mercilessly, and lead their souls to me..."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_GREAT_WHITE_FLEET",
	--	"There is an underworld kingdom dedicated to the drowned dead. The universe was pulled from a cosmic ocean. To deny the sea is to deny creation."),

		--19. AGENDA_IDEOLOGUE: Favors civilizations with the same type of government, dislikes civilizations that have different governments, and really dislikes civilizations with different governments of the same era as its own.
		--TRAIT_AGENDA_PREFER_SAME_GOVERNMENT
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_SAME_GOVERNMENT",
	--	"Righteous kingship is often unthanked. The goddess thanks the correct practitioners of this rule. She thanks them with a whisper through the tree of life."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_DIFFERENT_GOVERNMENT",
	--	"The rulers of this land must comply with the rulers of the heavens, and the rulers of the underworld. It is dangerous to defy this."),
		
		--20. AGENDA_INDUSTRIALIST: Tries to build up industry, and likes civilizations that also focus on Production.
		--TRAIT_AGENDA_PREFER_INDUSTRY
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_HIGH_INDUSTRY",
	--	"Miracles are made every day. A king has their people in perfect harmony."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_LOW_INDUSTRY",
	--	"No wonders can be borne without a disciplined people."),
		
		--21. AGENDA_INTOLERANT: Likes civilizations who follow the same Religion, and wants their cities to all follow the same Religion. Hates anyone trying to spread their Religion into their empire.
		--TRAIT_AGENDA_INTOLERANT
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_INTOLERANT_SAME_RELIGION",
	--	"The gods are embraced, as is the universe. They are happy. The land is happy."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_INTOLERANT_ENCROACHING_RELIGIONT",
		"The gods demand offerings, and my priests have suggested your head. I agree with them."),
		
		--22. AGENDA_LIBERTARIAN: Dislikes any civilization who makes a strong attempt to win a Diplomatic Victory.
		--TRAIT_AGENDA_PREFER_NODIPLOVP
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_HIGH_DIPLOVP",
		"I respect your independence just as you respect mine."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_LOW_DIPLOVP",
		"I will accept no overlord. Do not presume yourself mine."),
		
		--23. AGENDA_MONEY_GRUBBER: Tries to have the highest possible Gold per turn income. Respects other high income civilizations.
		--TRAIT_AGENDA_PREFER_INCOME
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_MONEY_GRUBBER",
	--	"The wealth of nations is heaped upon the worthy."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_MONEY_GRUBBER",
	--	"The most destitute of monarchs have only themselves to blame. They were given every opportunity to beseech the divine for mercy."),
		
		--24. AGENDA_NUKE_LOVER: Has no hesitation to use nuclear weapons. Respects other civilizations that project strength with nuclear weapons.
		--TRAIT_AGENDA_PREFER_NUKES
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_HIGH_NUKE_LOVE",
	--	"The heavens thunder. The rain god has sheathed his axe. Now, the power of the divine is granted to the hands of man."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_LOW_NUKE_LOVE",
	--	"Those who forsook the spearthrower found the spear thrown into them. A weapon whose power borders on the divine is no different. The fates of those who forsake it will be no different."),
		
		--25. AGENDA_PARANOID: Likes civilizations who pose no threat. Dislikes civilizations with strong militaries or ones with nearby cities.
		--TRAIT_AGENDA_PARANOID
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_PARANOID",
	--	"A military that can be housed in a city is of the proper size."), -- idfk anymore dude, this is hard
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_PARANOID",
	--	"The lengths that one goes to to amass might reflect only the greed they have for their neighbors."),
	--	
		--26. AGENDA_PILLAGER: Tries to pillage as many tiles as possible. Respects other civilizations who pillage.
		--TRAIT_AGENDA_PREFER_PILLAGE
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_HIGH_PILLAGE",
	--	"The fires burn on, for this world was built from fire and water. Glorious, glorious fire."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_LOW_PILLAGE",
	--	"The world must be scourged, so that it may be rebuilt. There were five suns, not one."),
		
		--27. AGENDA_POPULOUS: Tries to have the highest overall population. Respects other high population civilizations.
		--TRAIT_AGENDA_PREFER_POPULATION
--		("en_US", 
--		"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_POPULOUS",
--		""),
--		("en_US", 
--		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_POPULOUS",
--		""),
		
		--28. AGENDA_STANDING_ARMY: Always tries to keep a large standing army. Respects other civilizations with large armies.
		--TRAIT_AGENDA_PREFER_STANDING_ARMY
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_HIGH_STANDING_ARMY",
	--	"War is a sacred ritual, an art, a science, and a prayer. A warriors' creed is a priesthood, and to cultivate it is divine."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_LOW_STANDING_ARMY",
	--	"To embrace peace is to shun war, and the cycle of life, death, and rebirth. The jaguar does not keep peace with the iguana, nor the coatl and the quetzal."),
		
		--29. AGENDA_SYCOPHANT: Impressed by any civilization that earns a Golden Age.
		--TRAIT_AGENDA_SYCOPHANT
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_SYCOPHANT_GOLDEN_AGE",
		"The stars shine bright on your empire. Your vassals must be very loyal."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_SYCOPHANT_DARK_AGE",
		"Your servants pray for a worthier master. An overlord like Oxhuitzá would be welcomed by them."),
		
		--30. AGENDA_SYMPATHIZER: Likes civilizations who pose no threat. Dislikes civilizations with strong militaries or ones with nearby cities.
		--TRAIT_AGENDA_SYMPATHIZER
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_SYMPATHIZER_DARK_AGE",
		"The stars shine brightest in the dark. Prepare yourself. Our opportunity is nearly at hand."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_SYMPATHIZER_GOLDEN_AGE",
		"Your arrogance is only rivaled by Tikal's, and you are destined for the same fate."),
		
		--31. AGENDA_TECHNOPHILE: Favors Science development. Dislikes civs who are behind technologically.
		--TRAIT_AGENDA_PREFER_SCIENCE
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_HIGH_SCIENCE",
		"Your priests know as much as mine, and for it your land prospers. Clearly, the gods favor you."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_TECHNOPHILE",
		"Your stupidity and backwardness does not offend me. On the contrary, you have gifted me an opportunity!"),

		--32. AGENDA_TURTLER: Wants to stay safe from conquest. Dislike those who have conquered other players' original capitals.
		--TRAIT_AGENDA_TURTLER
	--	("en_US", 
	--	"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_TURTLER",
	--	"The rulership of monarchs is respected. It is as it is meant to be."),
	--	("en_US", 
	--	"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_TURTLER",
	--	"War and peace are perfect mirrors. To embrace only war is to be consumed by it. To lose balance is to invite disaster."),

		--33. AGENDA_WONDER_ADVOCATE: Likes civilizations not competing for wonders, and builds wonders whenever possible. Dislikes losing a wonder to another civilization.
		--TRAIT_AGENDA_WONDER_ADVOCATE
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_WONDER_ADVOCATE",
		"The monuments of Oxhuitzá show it's great prestige. You have not attempted to make your name outshine mine."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_WONDER_ADVOCATE",
		"Oxhuitzá is clearly favored. Your paltry efforts merely make it look greater by comparison.");

		--34. AGENDA_ZEALOT: Tries to gain a Religious Victory. Likes those civs who have already adopted their religion.
		--TRAIT_AGENDA_ZEALOT
--		("en_US", 
--		"LOC_DIPLO_KUDO_LEADER_LL_TEKINICH_II_REASON_AGENDA_ZEALOT",
--		"The land is made harmonious. As below, so above. Thus, the heavens are made harmonious."),
--		("en_US", 
--		"LOC_DIPLO_WARNING_LEADER_LL_TEKINICH_II_REASON_AGENDA_ZEALOT",
--		"To forsake the divine is to attempt to split the unsplittable. It is not good to forsake the divine, for they will forsake the earth.");
--*/
--------------------------------------------------------------------
-- Early Meetings
--------------------------------------------------------------------
INSERT OR REPLACE INTO LocalizedText
		(Language, Tag,	Text)
VALUES	-- First AI Line
		("en_US", 
		"LOC_DIPLO_FIRST_MEET_LEADER_LL_TEKINICH_II_ANY",					
		"A newcomer. Your arrival was not portended. I am the Lord of Oxhuitzá, and I am curious as to what you bring."),
		
		-- AI invitation to visit nearby City
		("en_US", 
		"LOC_DIPLO_FIRST_MEET_VISIT_RECIPIENT_LEADER_LL_TEKINICH_II_ANY",					
		"A loyal vassal of mine is not far - we may use it to meet."), -- he wants you to know he controls area near you.
		
		-- AI accepts Human invitation
		("en_US", 
		"LOC_DIPLO_FIRST_MEET_NEAR_INITIATOR_POSITIVE_LEADER_LL_TEKINICH_II_ANY",					
		"I will join, with stargazers with clear eyes and warriors with strong arms."),
		
		-- AI invitation to exchange Capital Information
		("en_US", 
		"LOC_DIPLO_FIRST_MEET_NO_MANS_INFO_EXCHANGE_LEADER_LL_TEKINICH_II_ANY",					
		"You have not yet told me of your city. I wish to know what great monuments have been built in your name, and what stars you see."),
		
		-- AI sends a Delegation
		("en_US", 
		"LOC_DIPLO_DELEGATION_FROM_AI_LEADER_LL_TEKINICH_II_ANY",					
		"I have sent an ambassador to your city. House him as his prestige demands, but there is no need to give him servants - he is bringing his own."),
		
		-- AI accepts the Player's Delegation
		("en_US", 
		"LOC_DIPLO_ACCEPT_DELEGATION_FROM_HUMAN_LEADER_LL_TEKINICH_II_ANY",					
		"Your delegate will be granted a new complex, and will be gifted servants and guards that I have chosen myself. It is an honor."),
		
		-- AI rejects the Player's Delegation
		("en_US", 
		"LOC_DIPLO_REJECT_DELEGATION_FROM_HUMAN_LEADER_LL_TEKINICH_II_ANY",					
		"We have not yet built the household suitable for your delegate. Perhaps later."),

--------------------------------------------------------------------
-- Open Borders
--------------------------------------------------------------------
		-- AI Proposes Open Borders
		("en_US", 
		"LOC_DIPLO_OPEN_BORDERS_FROM_AI_LEADER_LL_TEKINICH_II_ANY",					
		"I ask for free movement through your borders. It would aid in eliminating threats, and I will make the necessary offerings."),
		-- AI Accepts Open Borders
		("en_US", 
		"LOC_DIPLO_ACCEPT_OPEN_BORDERS_FROM_HUMAN_LEADER_LL_TEKINICH_II_ANY",					
		"Your soldiers are allowed, and will be guided by ceremonial warriors. As befits their station."), -- I hate writing lines like this. How many ways can someone say "yes"?
		-- AI Rejects Open Borders
		("en_US", 
		"LOC_DIPLO_REJECT_OPEN_BORDERS_FROM_HUMAN_LEADER_LL_TEKINICH_II_ANY",					
		"I have not received the customary offerings. The border will remain shut."),

--------------------------------------------------------------------
-- Friendship
--------------------------------------------------------------------
		-- AI Proposes Friendship
		("en_US", 
		"LOC_DIPLO_DECLARE_FRIEND_FROM_AI_LEADER_LL_TEKINICH_II_ANY",					
		"My priests agree that the stars are right. Oxhuitzá asks for your friendship."),
		-- AI Accepts Friendship
		("en_US", 
		"LOC_DIPLO_ACCEPT_DECLARE_FRIEND_FROM_HUMAN_LEADER_LL_TEKINICH_II_ANY",					
		"I see no reason to deny."),
		-- AI Rejects Friendship
		("en_US", 
		"LOC_DIPLO_REJECT_DECLARE_FRIEND_FROM_HUMAN_LEADER_LL_TEKINICH_II_ANY",					
		"The Great Star is out of alignment. Any friendship sworn this day would be ill-fated."),

--------------------------------------------------------------------
-- Denounce
--------------------------------------------------------------------
		-- AI Denounced by Human
		("en_US", 
		"LOC_DIPLO_DENOUNCE_FROM_HUMAN_LEADER_LL_TEKINICH_II_ANY",					
		"A poor gambit, and a poor-timed one. You have gained nothing."),
		-- AI Denounces
		("en_US", 
		"LOC_DIPLO_DENOUNCE_FROM_AI_LEADER_LL_TEKINICH_II_ANY",					
		"It is plain for any to see your worthlessness and lack of respect. And yet I feel I must tell the world again. (Denounces You)"),
		
--------------------------------------------------------------------
-- Trade Agreement with England
--------------------------------------------------------------------
		-- AI Accepts Deal
		("en_US", 
		"LOC_DIPLO_ACCEPT_MAKE_DEAL_FROM_AI_LEADER_LL_TEKINICH_II_ANY",					
		"I accept."),
		-- AI Rejects Deal
		("en_US", 
		"LOC_DIPLO_REJECT_MAKE_DEAL_FROM_AI_LEADER_LL_TEKINICH_II_ANY",					
		"This is not right."),

--------------------------------------------------------------------
-- Other Diplo
--------------------------------------------------------------------
		-- AI Proposes Alliance
		("en_US", 
		"LOC_DIPLO_MAKE_ALLIANCE_FROM_AI_LEADER_LL_TEKINICH_II_ANY",					
		"We would be stronger together than apart. The stars and the politics are right for an alliance."),
		
		-- AI warns player for border troops
		("en_US", 
		"LOC_DIPLO_WARNING_TOO_MANY_TROOPS_NEAR_ME_LEADER_LL_TEKINICH_II_ANY",					
		"Your schemes are as foolish as they are transparent. You have no advantage. Turn back."),

--------------------------------------------------------------------
-- War and Peace
--------------------------------------------------------------------
		-- Human declares war to the AI
		("en_US", 
		"LOC_DIPLO_DECLARE_WAR_FROM_HUMAN_LEADER_LL_TEKINICH_II_ANY",					
		"The Red Star is out of your favor, and the Great Star does not pour water. This will not take long."),
		
		-- AI declares war to Human
		("en_US", 
		"LOC_DIPLO_DECLARE_WAR_FROM_AI_LEADER_LL_TEKINICH_II_ANY",					
		"You are a blind ruler. You could not see the stars, nor my armies, nor my plots come into place. Now, the Great Star calls for war!"),
		
		-- AI accepts peace from Human
		("en_US", 
		"LOC_DIPLO_MAKE_PEACE_AI_ACCEPT_DEAL_LEADER_LL_TEKINICH_II_ANY",					
		"This war is over. We shall see how this peace fares."),
		-- AI rejects peace from Human
		("en_US", 
		"LOC_DIPLO_MAKE_PEACE_AI_ACCEPT_DEAL_LEADER_LL_TEKINICH_II_ANY",					
		"The Great Star demands blood. I am bound to accept nothing less."),
		-- AI asks for peace
		("en_US", 
		"LOC_DIPLO_MAKE_PEACE_FROM_AI_LEADER_LL_TEKINICH_II_ANY",					
		"The season of war is at its end. It is the proper time for a treaty."),
		
		-- AI defeats human (hotseat)
		("en_US", 
		"LOC_DIPLO_DEFEAT_FROM_HUMAN_LEADER_LL_TEKINICH_II_ANY",					
		"This outcome was clear to see. For anyone with eyes, that is."),
		
		-- AI is defeated
		("en_US", 
		"LOC_DIPLO_DEFEAT_FROM_AI_LEADER_LL_TEKINICH_II_ANY",					
		"It seems I've misjudged the stars and misjudged you. This is simply the cost.");