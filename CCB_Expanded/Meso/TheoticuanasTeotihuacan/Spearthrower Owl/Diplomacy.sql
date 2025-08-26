-- Diplomacy
-- Author: Better Lime than Never!
-- DateCreated: 1/21/2022 15:07:54
--------------------------------------------------------------
INSERT OR REPLACE INTO LocalizedText
		(Language, Tag,	Text)
VALUES
--------------------------------------------------------------------
-- Historical Agenda
--------------------------------------------------------------------
		-- Agenda
		("en_US", 
		"LOC_AGENDA_LIME_TEO_OWL_LORD_OF_WEST_NAME",					
		"Hegemony of Sacred Fire"),
		("en_US", 
		"LOC_AGENDA_LIME_TEO_OWL_LORD_OF_WEST_DESC",					
		"Will vigourously attack and compete for city-states. Respects warmongers and those with large armies, but dislikes those who conquer, protect, or subjugate city-states."),
		
		-- Kudos
		("en_US", 
		"LOC_DIPLO_MODIFIER_LEADER_LIME_TEO_OWL_WARRIOR_KING_POS",					
		"Spearthrower Owl respects powerful rulers"),
		("en_US", 
		"LOC_DIPLO_KUDO_EXIT_LEADER_LIME_TEO_OWL_ANY",
		"Appropriate."),
		("en_US", 
		"LOC_DIPLO_MODIFIER_LEADER_LIME_TEO_OWL_ANY",
		"(You have power and are willing to use it)"),
		
		-- Warnings
		("en_US", 
		"LOC_DIPLO_MODIFIER_LEADER_LIME_TEO_OWL_CS_ATTACK_OR_COMPETE_NEG",					
		"Spearthrower Owl hates those who interfere with City-States."),
		("en_US", 
		"LOC_DIPLO_WARNING_EXIT_LEADER_LIME_TEO_OWL_ANY",
		"..."),
		("en_US", 
		"LOC_DIPLO_MODIFIER_LEADER_LIME_TEO_OWL_ANY",
		"(You have interfered with his City-States)"),

--------------------------------------------------------------------
-- Random Agendas
--------------------------------------------------------------------
		--1. AGENDA_AIRPOWER: Tries to build up air power. Admires civilizations with greater air power. Dislikes civilizations with weaker air power.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_AIRPOWER",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_AIRPOWER",
		"..."),
		
		/*--2. AGENDA_CITY_STATE_ALLY: Likes civilizations that aren't competing for the same city-state allegiance. Dislikes civilizations that are directly competing for city-state allegiance.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_AGENDA_CITY_STATE_ALLY",
		""),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_CITY_STATE_ALLY",
		""),*/
		
		/*--3. AGENDA_CITY_STATE_PROTECTOR: Emphasizes protectorate wars. Admires civilizations that start protectorate wars. Dislikes civilizations that attack city-states.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_CITY_STATE_PROTECTOR",
		""),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_CITY_STATE_PROTECTOR",
		""),*/
		
		--4. AGENDA_CIVILIZED: Hates barbarians. Likes civilizations that clear out barbarian outposts. Does not like civilizations that ignore barbarian outposts.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_CIVILIZED",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_CIVILIZED",
		"..."),
		
		--5. AGENDA_CULTURED: Tries to build up Culture, and likes civilizations that also focus on Culture.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_CULTURED",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_CULTURED",
		"Filth."),
		
		--6. AGENDA_DARWINIST: Believes in survival of the fittest. Likes civilizations that are at war.
		/*("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_DARWINIST",
		""),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_DARWINIST",
		""),*/
		
		--7. AGENDA_DEMAGOGUE: Wants to be the civilization earning the most Diplomatic Favor, dislikes those who compete in Diplomatic Favor.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_DEMAGOGUE",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_DEMAGOGUE",
		"..."),
		
		--8. AGENDA_DESTINATION_CIV: Wants to be the civilization with the most Tourism Tourism, dislikes those who compete in Tourism Tourism.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_DESTINATION_CIV",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_DESTINATION_CIV",
		"..."),
		
		--9. AGENDA_DEVOUT: Tries to build up Faith, and likes civilizations that also focus on Faith.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_DEVOUT",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_DEVOUT",
		"..."),
		
		--10. AGENDA_ENVIRONMENTALIST: Builds National Parks, doesn't clear features, plants forests. Likes civilizations that plant forests or found National Parks. Dislikes civilizations that clear features.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_ENVIRONMENTALIST",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_ENVIRONMENTALIST",
		"..."),
		
		--11. AGENDA_EXPANSIONIST: Tries to include as much territory as possible in their empire. Does not like civilizations who control little territory.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_EXPANSIONIST",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_EXPANSIONIST",
		"..."),
		
		--12. AGENDA_EXPLOITATIVE: Clears all features and improves all possible tiles. Likes civilizations with a high percentage of improved tiles. Dislikes civilizations with low percentage of improved tiles or that found National Parks.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_EXPLOITATIVE",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_EXPLOITATIVE",
		"Parasite."),
		
		--13. AGENDA_EXPLORER: Tries to explore the map, and likes civilizations that have explored less of the map than itself and dislikes civilizations that have explored more of the map than itself.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_EXPLORER",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_EXPLORER",
		"..."),
		
		--14. AGENDA_FLAT_EARTHER: Wants to block humankind from circumnavigating the globe or going into space.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_FLAT_EARTHER",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_FLAT_EARTHER",
		"..."),
		
		--15. AGENDA_FUN_LOVING: Tries to make the citizens in each city as happy as possible. Likes civilizations that also develop in this fashion.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_FUN_LOVING",
		"Pleasing."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_FUN_LOVING",
		"..."),
		
		--16. AGENDA_GOSSIP: Wants to know everything about everyone.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_GOSSIP",
		"You see."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_GOSSIP",
		"Fool."),
		
		--17. AGENDA_GREAT_PERSON_ADVOCATE: Likes civilizations who are not competing for Great People, and will recruit Great People whenever possible. Dislikes losing a Great Person to another civilization.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_GREAT_PERSON_ADVOCATE",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_GREAT_PERSON_ADVOCATE",
		"..."),
		
		--18. AGENDA_GREAT_WHITE_FLEET: Builds a strong navy and respects civilizations who follow their lead. Does not like civilizations with a weak navy.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_GREAT_WHITE_FLEET",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_GREAT_WHITE_FLEET",
		"..."),

		--19. AGENDA_IDEOLOGUE: Favors civilizations with the same type of government, dislikes civilizations that have different governments, and really dislikes civilizations with different governments of the same era as its own.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_IDEOLOGUE",
		"Adhere."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_IDEOLOGUE",
		"..."),
		
		--20. AGENDA_INDUSTRIALIST: Tries to build up industry, and likes civilizations that also focus on Production.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_INDUSTRIALIST",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_INDUSTRIALIST",
		"..."),
		
		--21. AGENDA_INTOLERANT: Likes civilizations who follow the same Religion, and wants their cities to all follow the same Religion. Hates anyone trying to spread their Religion into their empire.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_INTOLERANT",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_INTOLERANT",
		"Infidel."),
		
		--22. AGENDA_LIBERTARIAN: Dislikes any civilization who makes a strong attempt to win a Diplomatic Victory.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_LIBERTARIAN",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_LIBERTARIAN",
		"Abase."),
		
		--23. AGENDA_MONEY_GRUBBER: Tries to have the highest possible Gold per turn income. Respects other high income civilizations.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_MONEY_GRUBBER",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_AGENDA_MONEY_GRUBBER",
		"Penurious."),
		
		--24. AGENDA_NUKE_LOVER: Has no hesitation to use nuclear weapons. Respects other civilizations that project strength with nuclear weapons.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_NUKE_LOVER",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_NUKE_LOVER",
		"Ant."),
		
		/*--25. AGENDA_PARANOID: Likes civilizations who pose no threat. Dislikes civilizations with strong militaries or ones with nearby cities.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_PARANOID",
		""),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_PARANOID",
		"I see you."),*/
		
		--26. AGENDA_PILLAGER: Tries to pillage as many tiles as possible. Respects other civilizations who pillage.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_PILLAGER",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_PILLAGER",
		"Burn."),
		
		--27. AGENDA_POPULOUS: Tries to have the highest overall population. Respects other high population civilizations.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_POPULOUS",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_POPULOUS",
		"Weak."),
		
		--28. AGENDA_STANDING_ARMY: Always tries to keep a large standing army. Respects other civilizations with large armies.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_STANDING_ARMY",
		"Vigorous."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_STANDING_ARMY",
		"Feeble."),
		
		--29. AGENDA_SYCOPHANT: Impressed by any civilization that earns a Golden Age.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_SYCOPHANT",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_SYCOPHANT",
		"..."),
		
		--30. AGENDA_SYMPATHIZER: Likes civilizations who pose no threat. Dislikes civilizations with strong militaries or ones with nearby cities.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_SYMPATHIZER",
		"Endure."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_SYMPATHIZER",
		"Vainglorious."),
		
		--31. AGENDA_TECHNOPHILE: Favors Science development. Dislikes civs who are behind technologically.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_TECHNOPHILE",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_TECHNOPHILE",
		"Dim."),

		--32. AGENDA_TURTLER: Wants to stay safe from conquest. Dislike those who have conquered other players' original capitals.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_TURTLER",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_TURTLER",
		"Foe."),

		--33. AGENDA_WONDER_ADVOCATE: Likes civilizations not competing for wonders, and builds wonders whenever possible. Dislikes losing a wonder to another civilization.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_WONDER_ADVOCATE",
		"..."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_WONDER_ADVOCATE",
		"..."),

		--34. AGENDA_ZEALOT: Tries to gain a Religious Victory. Likes those civs who have already adopted their religion.
		("en_US", 
		"LOC_DIPLO_KUDO_LEADER_LIME_TEO_OWL_REASON_AGENDA_ZEALOT",
		"Sanct."),
		("en_US", 
		"LOC_DIPLO_WARNING_LEADER_LIME_TEO_OWL_REASON_AGENDA_ZEALOT",
		"..."),

--------------------------------------------------------------------
-- Early Meetings
--------------------------------------------------------------------
		-- First AI Line
		("en_US", 
		"LOC_DIPLO_FIRST_MEET_LEADER_LIME_TEO_OWL_ANY",					
		"I know who you are."),
		
		-- AI invitation to visit nearby City
		("en_US", 
		"LOC_DIPLO_FIRST_MEET_VISIT_RECIPIENT_LEADER_LIME_TEO_OWL_ANY",					
		"Attend."),
		
		-- AI accepts Human invitation
		("en_US", 
		"LOC_DIPLO_FIRST_MEET_NEAR_INITIATOR_POSITIVE_LEADER_LIME_TEO_OWL_ANY",					
		"..."),
		
		-- AI invitation to exchange Capital Information
		("en_US", 
		"LOC_DIPLO_FIRST_MEET_NO_MANS_INFO_EXCHANGE_LEADER_LIME_TEO_OWL_ANY",					
		"Present yourself."),
		
		-- AI sends a Delegation
		("en_US", 
		"LOC_DIPLO_DELEGATION_FROM_AI_LEADER_LIME_TEO_OWL_ANY",					
		"Warriors sent."),
		
		-- AI accepts the Player's Delegation
		("en_US", 
		"LOC_DIPLO_ACCEPT_DELEGATION_FROM_HUMAN_LEADER_LIME_TEO_OWL_ANY",					
		"..."),
		
		-- AI rejects the Player's Delegation
		("en_US", 
		"LOC_DIPLO_REJECT_DELEGATION_FROM_HUMAN_LEADER_LIME_TEO_OWL_ANY",					
		"..."),

--------------------------------------------------------------------
-- Open Borders
--------------------------------------------------------------------
		-- AI Proposes Open Borders
		("en_US", 
		"LOC_DIPLO_OPEN_BORDERS_FROM_AI_LEADER_LIME_TEO_OWL_ANY",					
		"..."),
		-- AI Accepts Open Borders
		("en_US", 
		"LOC_DIPLO_ACCEPT_OPEN_BORDERS_FROM_HUMAN_LEADER_LIME_TEO_OWL_ANY",					
		"..."),
		-- AI Rejects Open Borders
		("en_US", 
		"LOC_DIPLO_REJECT_OPEN_BORDERS_FROM_HUMAN_LEADER_LIME_TEO_OWL_ANY",					
		"..."),

--------------------------------------------------------------------
-- Friendship
--------------------------------------------------------------------
		-- AI Proposes Friendship
		("en_US", 
		"LOC_DIPLO_DECLARE_FRIEND_FROM_AI_LEADER_LIME_TEO_OWL_ANY",					
		"Comply."),
		-- AI Accepts Friendship
		("en_US", 
		"LOC_DIPLO_ACCEPT_DECLARE_FRIEND_FROM_HUMAN_LEADER_LIME_TEO_OWL_ANY",					
		"..."),
		-- AI Rejects Friendship
		("en_US", 
		"LOC_DIPLO_REJECT_DECLARE_FRIEND_FROM_HUMAN_LEADER_LIME_TEO_OWL_ANY",					
		"..."),

--------------------------------------------------------------------
-- Denounce
--------------------------------------------------------------------
		-- AI Denounced by Human
		("en_US", 
		"LOC_DIPLO_DENOUNCE_FROM_HUMAN_LEADER_LIME_TEO_OWL_ANY",					
		"..."),
		-- AI Denounces
		("en_US", 
		"LOC_DIPLO_DENOUNCE_FROM_AI_LEADER_LIME_TEO_OWL_ANY",					
		"Prepare yourself. (Denounces You)"),
		
--------------------------------------------------------------------
-- Trade Agreement with England
--------------------------------------------------------------------
		-- AI Accepts Deal
		("en_US", 
		"LOC_DIPLO_ACCEPT_MAKE_DEAL_FROM_AI_LEADER_LIME_TEO_OWL_ANY",					
		"..."),
		-- AI Rejects Deal
		("en_US", 
		"LOC_DIPLO_REJECT_MAKE_DEAL_FROM_AI_LEADER_LIME_TEO_OWL_ANY",					
		"..."),

--------------------------------------------------------------------
-- Other Diplo
--------------------------------------------------------------------
		-- AI Proposes Alliance
		("en_US", 
		"LOC_DIPLO_MAKE_ALLIANCE_FROM_AI_LEADER_LIME_TEO_OWL_ANY",					
		"Accede."),
		
		-- AI warns player for border troops
		("en_US", 
		"LOC_DIPLO_WARNING_TOO_MANY_TROOPS_NEAR_ME_LEADER_LIME_TEO_OWL_ANY",					
		"I see you."),

--------------------------------------------------------------------
-- War and Peace
--------------------------------------------------------------------
		-- Human declares war to the AI
		("en_US", 
		"LOC_DIPLO_DECLARE_WAR_FROM_HUMAN_LEADER_LIME_TEO_OWL_ANY",					
		"Amusing."),
		
		-- AI declares war to Human
		("en_US", 
		"LOC_DIPLO_DECLARE_WAR_FROM_AI_LEADER_LIME_TEO_OWL_ANY",					
		"Perish."),
		
		-- AI accepts peace from Human
		("en_US", 
		"LOC_DIPLO_MAKE_PEACE_AI_ACCEPT_DEAL_LEADER_LIME_TEO_OWL_ANY",					
		"..."),
		-- AI rejects peace from Human
		("en_US", 
		"LOC_DIPLO_MAKE_PEACE_AI_ACCEPT_DEAL_LEADER_LIME_TEO_OWL_ANY",					
		"..."),
		-- AI asks for peace
		("en_US", 
		"LOC_DIPLO_MAKE_PEACE_FROM_AI_LEADER_LIME_TEO_OWL_ANY",					
		"Negotiate."),
		
		-- AI defeats human (hotseat)
		("en_US", 
		"LOC_DIPLO_DEFEAT_FROM_HUMAN_LEADER_LIME_TEO_OWL_ANY",					
		"Disappointing."),
		
		-- AI is defeated
		("en_US", 
		"LOC_DIPLO_DEFEAT_FROM_AI_LEADER_LIME_TEO_OWL_ANY",					
		"You may have won. For now.");