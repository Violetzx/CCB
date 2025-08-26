--========================================================================================================================
-- LocalizedText
--========================================================================================================================
INSERT OR REPLACE INTO BaseGameText
		(Tag,					Text)
VALUES
--========================================================================================================================
-- Leader
--========================================================================================================================
		("LOC_LOADING_INFO_LEADER_SUK_AL_HASAN",
		"Sultan al-Hassan ibn Sulaiman, yours is an empire of humble fishermen and proud merchants, and through their efforts, your coasts will teem with bustling ports and prosperous cities. Guide them to great things from your palace of Husuni Kubwa, and soon the greatest men of the age shall come to gaze upon the gleaming coral cities of the Swahili, and pay tribute to you; their magnificent sultan."),
--========================================================================================================================
-- Diplo
--========================================================================================================================
-- First Meet
-------------------------------------
		("LOC_DIPLO_FIRST_MEET_LEADER_SUK_AL_HASAN_ANY",
		"I bid you welcome to Kilwa weary traveler. I am their Sultan al-Hasan, Father of Gifts. Have you come for a gift too?"),
		("LOC_DIPLO_FIRST_MEET_VISIT_RECIPIENT_LEADER_SUK_AL_HASAN_ANY",
		"Join me for Friday prayers, I should like to get to show you our Great Mosque."),
		("LOC_DIPLO_FIRST_MEET_NEAR_INITIATOR_POSITIVE_LEADER_SUK_AL_HASAN_ANY",
		"May God bless you for your hospitality."),
		("LOC_DIPLO_FIRST_MEET_NO_MANS_INFO_EXCHANGE_LEADER_SUK_AL_HASAN_ANY",
		"Kilwa has a splendid palace and a wonderful mosque, all built with coral and decorated with porcelain. Does your capital compare?"),
-------------------------------------
-- Agenda Diplo
-------------------------------------
		("LOC_DIPLO_KUDO_EXIT_LEADER_SUK_AL_HASAN_ANY",
		"Word has reached me from the great men of the world that your cities rival those of mine. Truly impressive."),
		("LOC_DIPLO_WARNING_EXIT_LEADER_SUK_AL_HASAN_ANY",
		"You think to house the greatest minds the world has seen in such pitiable conditions? Do you not think of their comfort?"),
-------------------------------------
-- War and Peace
-------------------------------------
	-- Human Declares War
		("LOC_DIPLO_DECLARE_WAR_FROM_HUMAN_LEADER_SUK_AL_HASAN_ANY",
		"A tyrant cannot be bargained with! Very well, swords will suffice for words."),
	-- AI Declares War
		("LOC_DIPLO_DECLARE_WAR_FROM_AI_LEADER_SUK_AL_HASAN_ANY",
		"War is a regrettable disruption to trade, but in this case, it seems necessary."),
	-- Making Peace
		("LOC_DIPLO_MAKE_PEACE_AI_ACCEPT_DEAL_LEADER_SUK_AL_HASAN_ANY",
		"Excellent, we can get back to more important matters. Commerce, for instance."),
		("LOC_DIPLO_MAKE_PEACE_AI_REFUSE_DEAL_LEADER_SUK_AL_HASAN_ANY",
		"No. This bargain is one I cannot yet accept."),
		("LOC_DIPLO_MAKE_PEACE_FROM_AI_LEADER_SUK_AL_HASAN_ANY",
		"War is such an unpleasant business, isn't it? Perhaps it is time to pursue peace?"),
	-- Defeat
		("LOC_DIPLO_DEFEAT_FROM_AI_LEADER_SUK_AL_HASAN_ANY",
		"May God grant that my people not suffer. Be kinder to them than you were to me."),
-------------------------------------
-- DoF
-------------------------------------
		("LOC_DIPLO_DECLARE_FRIEND_FROM_AI_LEADER_SUK_AL_HASAN_ANY",
		"A friendship between our nations will only bring harmony and prosperity. What say you?"),
	-- AI requested friendship
		("LOC_DIPLO_ACCEPT_DECLARE_FRIEND_FROM_AI_LEADER_SUK_AL_HASAN_ANY",
		"Good. I do believe this should be quite conducive to trade."),
		("LOC_DIPLO_REJECT_DECLARE_FRIEND_FROM_AI_LEADER_SUK_AL_HASAN_ANY",
		"A pity."),
	-- On human requests friendship
		("LOC_DIPLO_ACCEPT_DECLARE_FRIEND_FROM_HUMAN_LEADER_SUK_AL_HASAN_ANY",
		"You are a friend to Kilwa, and Kilwa is a friend to you."),
		("LOC_DIPLO_REJECT_DECLARE_FRIEND_FROM_HUMAN_LEADER_SUK_AL_HASAN_ANY",
		"It is too early for me to make such a decision."),
-------------------------------------
-- Delegation
-------------------------------------
		("LOC_DIPLO_DELEGATION_FROM_AI_LEADER_SUK_AL_HASAN_ANY",
		"I am the Father of Gifts, and I must live up to that reputation. I have sent envoys with halwa for you."),
		("LOC_DIPLO_ACCEPT_DELEGATION_FROM_HUMAN_LEADER_SUK_AL_HASAN_ANY",
		"They stay in my palace as royal guests. I must say, it is nice to be on the receiving end of a gift for once."),
		("LOC_DIPLO_REJECT_DELEGATION_FROM_HUMAN_LEADER_SUK_AL_HASAN_ANY",
		"I, unfortunately, cannot entertain guests at the moment, perhaps another time?"),
-------------------------------------
-- Denounce
-------------------------------------
		("LOC_DIPLO_DENOUNCE_FROM_HUMAN_LEADER_SUK_AL_HASAN_ANY",
		"You would insult me? I promise you will regret these words."),
		("LOC_DIPLO_DENOUNCE_FROM_AI_LEADER_SUK_AL_HASAN_ANY",
		"What does it say that even I cannot stand you? (Denounces You)."),
-------------------------------------
-- Alliance
-------------------------------------
		("LOC_DIPLO_MAKE_ALLIANCE_FROM_AI_LEADER_SUK_AL_HASAN_ANY",
		"An alliance between us should be sure to guarantee our mutual prosperity!"),
-------------------------------------
-- Misc Standard Lines
-------------------------------------
		("LOC_DIPLO_GREETING_LEADER_SUK_AL_HASAN_ANY",
		"Greetings."),
		("LOC_DIPLO_REJECT_MAKE_DEAL_FROM_AI_LEADER_SUK_AL_HASAN_ANY",
		"I don’t think I can agree to this."),
		("LOC_DIPLO_ACCEPT_MAKE_DEAL_FROM_AI_LEADER_SUK_AL_HASAN_ANY",
		"You drive a hard bargain! I accept!"),
		("LOC_DIPLO_OPEN_BORDERS_FROM_AI_LEADER_SUK_AL_HASAN_ANY",
		"Will you allow our units to cross through your territory?"),
		("LOC_DIPLO_ACCEPT_OPEN_BORDERS_FROM_HUMAN_LEADER_SUK_AL_HASAN_ANY",
		"Yes, you may pass through our lands, provided they remain our lands. I will always accept this bargain over warfare."),
		("LOC_DIPLO_REJECT_OPEN_BORDERS_FROM_HUMAN_LEADER_SUK_AL_HASAN_ANY",
		"I cannot trust your men to keep the peace, thus I must refuse."),
		("LOC_DIPLO_WARNING_TOO_MANY_TROOPS_NEAR_ME_LEADER_SUK_AL_HASAN_ANY",
		"I hope your soldiers are enjoying the sights. Unless you have more nefarious intentions?"),
--------------------------------------------------------------------
-- Quote and Pedia
--------------------------------------------------------------------
		("LOC_PEDIA_LEADERS_PAGE_SUK_AL_HASAN_QUOTE",
		"When I was established, I revenged my father upon the people of Mafia, fought and overcame them."),
		("LOC_PEDIA_LEADERS_PAGE_SUK_AL_HASAN_TITLE",
		"Al-Hasan ibn Sulaiman"),
		("LOC_PEDIA_LEADERS_PAGE_SUK_AL_HASAN_SUBTITLE",
		"Sultan of Kilwa"),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_SUK_AL_HASAN_CHAPTER_CAPSULE_BODY",
		"Though perhaps not masters of naval warfare, the Swahili excel at thriving on the coast. Al-Hasan's abilities buffs the Swahili's most important district: the Harbor."),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_SUK_AL_HASAN_CHAPTER_DETAILED_BODY",
		"Unlike England, Norway, and Spain, the Swahili have almost no bonuses to enhance their naval might. What they do have is the potential for a strong and versatile economic base that those other naval civs would envy. Build your cities on the coast and keep them compact to maximise the benefit you get from your unique ability and the Pillar Tomb. Under al-Hasan, you won't have to worry about fresh water either: your Harbors can act as an excellent substitute, and give culture to boot! If you're ever short on [ICON_Production] Production in your coastal cities, train or buy some Jahazis and send them where they're needed. The most important thing to remember is to not neglect your navy, or your cities may fall prey to the likes of Norway."),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_SUK_AL_HASAN_CHAPTER_HISTORY_PARA_1",
		"Sultan al-Hasan ibn Sulaiman, often referred to as “Abu’l-Mawahib” (“father of gifts”), was the ruler of the city-state of Kilwa, from 1310 until 1333. Much of what we know about al-Hasan and about Kilwa itself comes to us through the writings of Ibn Battuta, an extremely well travelled Muslim scholar."),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_SUK_AL_HASAN_CHAPTER_HISTORY_PARA_2",
		"Ibn Battuta recorded his visit to the city around 1331, and commented favorably on the humility and religion of al-Hasan. Sultan al-Hasan ibn Sulaiman is reported to have have been a generous and intelligent man. He passed several years studying the sciences (ilm) at Mecca, where he became, “erudite and learned.” Ibn Battuata was extemely impressed by the sultan’s generosity, noting that he would sit and dine with beggars, and was very liberal with distributing gifts to all (including Ibn Batutta himself) who came to see him. It is because of this generosity that al-Hasan earned the epithet “Father of Gifts.”"),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_SUK_AL_HASAN_CHAPTER_HISTORY_PARA_3",
		"Ibn Battuta was also particularly impressed by the planning of the city and believed that it was the reason for Kilwa’s success along the coast. During al-Hasan’s reign, Kilwa saw the construction of the Palace of Husuni Kubwa. The site, built of jagged blocks of coral called coral rag, is now only accessible from a worn staircase carved out of the cliff leading up from the water. Its ruin includes traditional Swahili elements, such as a stepped greeting court bordered by guest rooms for visiting merchants, and elements borrowed from other Islamic palaces, such as an octagonal swimming pool, grand audience court, and a residence with some 100 rooms. But the sultan had overreached in his ambition: The palace was occupied for only a short time before it was abandoned, unfinished."),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_SUK_AL_HASAN_CHAPTER_HISTORY_PARA_4",
		"Also during his reign, the sultan made a significant extension to the Great Mosque of Kilwa, which was made of coral stones—the largest mosque of its kind. He built an extension from the east wall of the northern prayer hall, which wrapped around forming a large open court. A very narrow barrel vaulted corridor, consisting of 30 bays complete with dressed coral panels and supported by coral columns ran directly southward. This extension juts out slightly to the east, creating a wing that deviates from the otherwise orthogonal plan. Within the space where the wall splays, two small irregular rooms were preceded by a small porch containing a tank filled with smooth quartz pebbles, a sandstone foot-rubber and a bench. Behind this small assembly of rooms is a somewhat larger plainly vaulted room. This long room leads into a square room four meters across which carries the great dome. This dome, noted in the Kilwa Chronicle, is thought to be the first true dome on Africa’s east coast. It was supported on squinches and decorated with dressed coral panels. After his visit in 1331, Ibn Battuta remarked on the splendor of the dome, which was, until the nineteenth century, the largest dome on the East African coast.");
 --========================================================================================================================
--========================================================================================================================