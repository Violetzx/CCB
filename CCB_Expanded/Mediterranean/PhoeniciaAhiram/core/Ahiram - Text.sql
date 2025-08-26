-- Ahiram - Text
-- Author: Lime
-- DateCreated: 8/21/2019 14:09:32
--------------------------------------------------------------
INSERT OR REPLACE INTO LocalizedText
		(Language, Tag,					Text)
VALUES

--============================================================
-- Ahiram Base stuff
--============================================================
		("en_US", "LOC_LEADER_LIME_PHOE_AHIRAM_NAME",  
		"Ahiram"),
		("en_US", "LOC_LOADING_INFO_LEADER_LIME_PHOE_AHIRAM",  
		"Melqart grants you prosperity, Ahiram, as few are as wealthy as you. Use your dominance over the seas in order to bolster your own wealth, but do not simply hoard it. Order lavish constructions across all your holdings, and inspire merchantry and business to thrive in your colonies, for riches beget riches. In a world of beggars, use the gold and silver of Byblos and beyond to build great cities - and yes, a civilization - that will stand the test of time."),
--------------------------------------------------------------------
-- LUA
--------------------------------------------------------------------
		("en_US", "LOC_TRAIT_LEADER_LIME_PHOE_AHIRAM_MERCHANT_PRINCES_NAME",  
		"Merchant Princes"),
		("en_US", "LOC_TRAIT_LEADER_LIME_PHOE_AHIRAM_MERCHANT_PRINCES_DESCRIPTION",
		"Purchasing buildings generates a burst of [ICON_GreatMerchant] Great Merchant points. Unlock the Royal Tomb unique building."),
--------------------------------------------------------------------
-- Agenda
--------------------------------------------------------------------
		("en_US", "LOC_AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED_NAME",  
		"Here and Be Humbled"),
		("en_US", "LOC_AGENDA_LIME_PHOE_AHIRAM_BE_HUMBLED_DESCRIPTION",  
		"Dislikes Warmongers, but likes those who send trade routes to him."),

		("en_US", "LOC_DIPLO_KUDO_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED_REASON_ANY",  
		"(You're a warmonger, but at least you trade with him)"),
		("en_US", "LOC_DIPLO_MODIFIER_LEADER_LIME_PHOE_AHIRAM_BE_HUMBLED_KUDO",  
		"Ahiram is happy to have an individual of your strengths on his payroll"),

--============================================================
-- Ahiram Diplo
--============================================================
		-- FORST BOOK
		("en_US", "LOC_DIPLO_FIRST_MEET_LEADER_LIME_PHOE_AHIRAM_ANY",						 -- First AI Line                             
        "Greetings, and what will your pleasure be? Speak clearly - I shall have a scribe record this day!"),
        ("en_US", "LOC_DIPLO_FIRST_MEET_VISIT_RECIPIENT_LEADER_LIME_PHOE_AHIRAM_ANY",		 -- AI invite to visit nearby city                                 
        "Would you be interested in a preliminary trade agreement? Perhaps you could come view a draft at a city of mine nearby."),
        ("en_US", "LOC_DIPLO_FIRST_MEET_NEAR_INITIATOR_POSITIVE_LEADER_LIME_PHOE_AHIRAM_ANY", -- AI Accepts Human Invite
        "My merchants will be there at once."),
        ("en_US", "LOC_DIPLO_FIRST_MEET_NO_MANS_INFO_EXCHANGE_LEADER_LIME_PHOE_AHIRAM_ANY",	 -- AI invite to exchange Capital Info                                     
        "Come, see the majesty of Byblos! Remember to bring something to barter, for there are many merchants to meet!"),
		
		-- GREETING
		("en_US", "LOC_DIPLO_GREETING_LEADER_LIME_PHOE_AHIRAM_ANY",                                     
        "Can I help you?"),

		-- DELEGATION
		("en_US", "LOC_DIPLO_DELEGATION_FROM_AI_LEADER_LIME_PHOE_AHIRAM_ANY",				 -- AI Requests                               
        "I've had some samples of our many riches delivered to you. How about some gold and rubies? A cup of wine, or two, or three?"),
        ("en_US", "LOC_DIPLO_REJECT_DELEGATION_FROM_HUMAN_LEADER_LIME_PHOE_AHIRAM_ANY",       -- AI Rejects                 
        "Your delegation will not be allowed, but perhaps I could interest you in some trinkets? For affordable costs?"),
        ("en_US", "LOC_DIPLO_ACCEPT_DELEGATION_FROM_HUMAN_LEADER_LIME_PHOE_AHIRAM_ANY",       -- AI Accepts                
        "Your delegates will be treated well and with esteem, I assure you."),

		-- DEAL
		("en_US", "LOC_DIPLO_REJECT_MAKE_DEAL_FROM_AI_LEADER_LIME_PHOE_AHIRAM_ANY",           -- AI Rejects deal                  
        "I believe we shall need to do some revising."),
        ("en_US", "LOC_DIPLO_ACCEPT_MAKE_DEAL_FROM_AI_LEADER_LIME_PHOE_AHIRAM_ANY",           -- AI Accepts deal        
        "Excellent! I shall have it drafted at once."),

		--WARNING + EXIT
		("en_US", "LOC_DIPLO_WARNING_EXIT_LEADER_LIME_PHOE_AHIRAM_ANY",                       -- AI Warning
        "War is not good for profits. Unless, of course, it is against the warmongers."),
        ("en_US", "LOC_DIPLO_KUDO_EXIT_LEADER_LIME_PHOE_AHIRAM_ANY",                          -- AI Kudos
        "I never let good morals get in the way of good business. And by Astarte, we do have good business."),

		-- FRIENDSHIP
		("en_US", "LOC_DIPLO_REJECT_DECLARE_FRIEND_FROM_AI_LEADER_LIME_PHOE_AHIRAM_ANY",      -- Human Rejects, AI Responds                 
        "Perhaps not."),
        ("en_US", "LOC_DIPLO_ACCEPT_DECLARE_FRIEND_FROM_AI_LEADER_LIME_PHOE_AHIRAM_ANY",      -- Human accepts, AI Responds   
        "Marvelous!"),
        ("en_US", "LOC_DIPLO_DECLARE_FRIEND_FROM_AI_LEADER_LIME_PHOE_AHIRAM_ANY",             -- AI Requests
        "Perhaps I could tempt you with a written declaration of friendship?"),
        ("en_US", "LOC_DIPLO_REJECT_DECLARE_FRIEND_FROM_HUMAN_LEADER_LIME_PHOE_AHIRAM_ANY",   -- AI Rejects                    
        "This does not seem a... mutually beneficial venture."),
        ("en_US", "LOC_DIPLO_ACCEPT_DECLARE_FRIEND_FROM_HUMAN_LEADER_LIME_PHOE_AHIRAM_ANY",   -- AI Accepts                     
        "Consider it settled!"),

		-- ALLIANCE
		("en_US", "LOC_DIPLO_MAKE_ALLIANCE_FROM_AI_LEADER_LIME_PHOE_AHIRAM_ANY",              -- AI Requests an alliance           
        "The time has come to expand our partnership! It has been quite profitable for me, at least."),

		-- OPEN BORDERS
		("en_US", "LOC_DIPLO_ACCEPT_OPEN_BORDERS_FROM_HUMAN_LEADER_LIME_PHOE_AHIRAM_ANY",     -- AI Accepts from Human                
        "Agreed! I cannot wait to hear of the fabulous riches of your lands."),
        ("en_US", "LOC_DIPLO_REJECT_OPEN_BORDERS_FROM_HUMAN_LEADER_LIME_PHOE_AHIRAM_ANY",     -- AI Rejects from Human        
        "No, I don't think we shall."),
        ("en_US", "LOC_DIPLO_OPEN_BORDERS_FROM_AI_LEADER_LIME_PHOE_AHIRAM_ANY",               -- AI Requests
        "I have a proposal that I believe will generate opportunities between us?"),
        ("en_US", "LOC_DIPLO_WARNING_TOO_MANY_TROOPS_NEAR_ME_LEADER_LIME_PHOE_AHIRAM_ANY",    -- Fuck off sneaky player                       
        "I have read reports of forces amassing near my border, bearing your flag. Do you have anything to say? Perhaps a plea for mercy?"),

		-- DENOUNCE
		("en_US", "LOC_DIPLO_DENOUNCE_FROM_AI_LEADER_LIME_PHOE_AHIRAM_ANY",                   -- From AI
        "Never have I done business with one so awful as you - even your coins are tainted!"),
        ("en_US", "LOC_DIPLO_DENOUNCE_FROM_HUMAN_LEADER_LIME_PHOE_AHIRAM_ANY",                -- from Human                   
        "Madness does always spring from the minds of the greedy."),

		-- WAR
        ("en_US", "LOC_DIPLO_DECLARE_WAR_FROM_AI_LEADER_LIME_PHOE_AHIRAM_ANY",                -- AI Declares war            
        "The price of peace has become far too great. It is time to bring Ba'al's storm down upon you!"), 
        ("en_US", "LOC_DIPLO_DECLARE_WAR_FROM_HUMAN_LEADER_LIME_PHOE_AHIRAM_ANY",             -- Human Declares War      
        "Then you too shall be humbled before the walls of Byblos!"), 
		("en_US", "LOC_DIPLO_MAKE_PEACE_AI_ACCEPT_DEAL_LEADER_LIME_PHOE_AHIRAM_ANY",          -- Accept peace       
        "I believe that settles it, then."),
        ("en_US", "LOC_DIPLO_MAKE_PEACE_AI_REFUSE_DEAL_LEADER_LIME_PHOE_AHIRAM_ANY",          -- Reject peace             
        "I am unwilling to pay such a ludicrous price for a worthless peace."),
        ("en_US", "LOC_DIPLO_MAKE_PEACE_FROM_AI_LEADER_LIME_PHOE_AHIRAM_ANY",                 -- AI requests peace     
        "Perhaps it is time we reconsidered our circumstances. Surely, there's something I could offer you?"),

		-- DEATH
        ("en_US", "LOC_DIPLO_DEFEAT_FROM_HUMAN_LEADER_LIME_PHOE_AHIRAM_ANY",                  -- AI Defeated             
        "A thousand curses upon you and your sons - may you never know peace as long as you reign, and may Resheph spill his fires upon you!"),
        ("en_US", "LOC_DIPLO_DEFEAT_FROM_AI_LEADER_LIME_PHOE_AHIRAM_ANY",                     -- Human defeated
        "Our business is concluded. I do hope you have no complaints, but in all honesty I don't particularly care."),

--============================================================
-- Ahiram pEDIAS
--============================================================
		("en_US", "LOC_PEDIA_LEADERS_PAGE_LEADER_LIME_PHOE_AHIRAM_QUOTE",  
		"If any King, or Governor, of Commander come against this city, then let his judicial scepter be broken, let his royal throne be overthrown, and let all peace and quiet flee Byblos."),
		("en_US", "LOC_PEDIA_LEADERS_PAGE_LIME_PHOE_AHIRAM_TITLE",
		"Ahiram"),
		("en_US", "LOC_PEDIA_LEADERS_PAGE_LIME_PHOE_AHIRAM_SUBTITLE",
		"King of Byblos"),
		("en_US", "LOC_PEDIA_LEADERS_PAGE_LEADER_LIME_PHOE_AHIRAM_CHAPTER_CAPSULE_BODY",
		"Ahiram specializes in building up early cities for cheap, and using those purchases to generate Great Merchants. Use those far-flung cities to purchase many new buildings off the economy that base Phoenicia has built. Better yet, purchase Royal Tombs to generate lots of science, and secure a very rich scientific victory."),
		("en_US", "LOC_PEDIA_LEADERS_PAGE_LEADER_LIME_PHOE_AHIRAM_CHAPTER_DETAILED_BODY",
		"Phoenicia inherently stilts towards a very economic and wide coastal game, with many smaller cities spread across vast amounts of coastline, generating gold through a large network of trade routes sprouting from Cothons. Ahiram uses this wealth to build up many Great Merchant points, which have a large variety of uses. Ahiram also offers the Royal Tomb unique building, which is designed to generate even more gold from all those Great Merchants, but also to push towards building and purchasing scientific buildings. Using the Financier governor will similarly help Phoenicia, though district purchases will not generate Great Merchant points."),
		("en_US", "LOC_PEDIA_LEADERS_PAGE_LEADER_LIME_PHOE_AHIRAM_CHAPTER_HISTORY_PARA_1",
		"Little is known about Ahiram of Byblos – even the period of his reign is unknown, with the current estimate being around the year 1000 BC. It’s also not truly known if he was a king, though Historians suspect that he was, or at least of a bloodline worthy of kingship. What is known is that his son, Ithobaal (not the one on Wikipedia, I\’m pretty sure that redirects to a different Ithobaal? But I’m honestly not sure, it\’s all really confusing) certainly was a King of Byblos, and that Ahiram was without a doubt incredibly wealthy. Wealthy enough to be interred in a grave fitting of kings: a sarcophagus in a Royal Shaft tomb."),
		("en_US", "LOC_PEDIA_LEADERS_PAGE_LEADER_LIME_PHOE_AHIRAM_CHAPTER_HISTORY_PARA_2",
		"What can be extrapolated from this is that Ahiram was likely a very wealthy merchant and or king at a very convenient time: the end of the world. By the year 1000BC, the Late Bronze Age Collapse had come and gone. Babylon, Mycanae, and Ugarit lay in smouldering ashes, and the great empires of the day and age – Assyria, Elam, and almighty Egypt – were either dead or dying. Literacy was all but eradicated, and the general chaos had disrupted basically the entire trade route network that the Near East was built on. In short, things weren\’t great."),
		("en_US", "LOC_PEDIA_LEADERS_PAGE_LEADER_LIME_PHOE_AHIRAM_CHAPTER_HISTORY_PARA_3",
		"As it happens, the apocalypse is great for business. Ahiram became an important individual in the ancient city of Byblos – once a colony of Egypt, but Egypt wasn\’t really capable of things such as territorial integrity at this point. Byblos became the foremost city of Phoenicia, which emerged after the bronze age collapse as a powerful and influential coalition of mercantile city-states. Due to the fact that all of the other major powers were still in varying degrees of hell, Phoenician power was virtually unopposed, giving it free reign to trade across the Mediterranean and Europe in a post-apocalyptic and barely-literate world. Even better, Byblos was located nearby huge forests of cedar, and wood was a resource that Egypt - being, indeed, a desert - is notably lacking in. In effect, Ahiram had many factors going for him to ensure there was literally no way he could not become insanely wealthy."),
		("en_US", "LOC_PEDIA_LEADERS_PAGE_LEADER_LIME_PHOE_AHIRAM_CHAPTER_HISTORY_PARA_4",
		"A nice byproduct of getting intensely rich – as Possibly-King Ahiram would have been wont to do – was that the alphabet used by the Phoenicians spread across the resurging civilizations. This alphabet was far simpler to learn than the previous options of cuneiform and hieroglyphics, which made it quite popular with states that no longer had the ability nor interest to support the needs of a bunch of scribes. This popular new alphabet would form the basis of the modern Latin Alphabet, with the first true example being on none other than a curse inscribed on Ahiram\’s Sarcophagus. "),
		("en_US", "LOC_PEDIA_LEADERS_PAGE_LEADER_LIME_PHOE_AHIRAM_CHAPTER_HISTORY_PARA_5",
		"Ahiram likely used his incredible wealth to bankroll construction within the city. His wealth is probably also the reason why his son, Ithobaal, was later made the King of Byblos. It also likely afforded him a good position on the council of Elders within Byblos, should he have not been the King of Byblos himself. "),

		("en_US", "LOC_LIME_PHOE_AHIRAM_GMERCHANT_DROPTEXT",
		"+{1_Num} Great Merchant Points"),
--============================================================
-- Shaft Tomb Shit
--============================================================
		("en_US", "LOC_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB_NAME",
		"Royal Tomb"),
		("en_US", "LOC_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB_DESCRIPTION",
		"Replaces the Library. Provides bonus [ICON_Gold] Gold equal to the adjacency [ICON_Science] Science bonus of its district. +1 [ICON_Science] Science for each [ICON_GreatMerchant] Great Merchant earnt by this civilization."),
		("en_US", "LOC_PEDIA_BUILDINGS_PAGE_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB_CHAPTER_HISTORY_PARA_1",
		"Very little remains of Phoenician architecture. Even less remains of this civilopedia."),
		("en_US", "LOC_PEDIA_BUILDINGS_PAGE_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB_CHAPTER_HISTORY_PARA_2",
		"..."),
		("en_US", "LOC_PEDIA_BUILDINGS_PAGE_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB_CHAPTER_HISTORY_PARA_3",
		"Okay, fine. Phoenician burial practices varied from city to city, as Phoenicia is more of a catch-all term for a bunch of maritime cities that worshiped the same-ish gods and had similar trading and government structures anyways. One type of grave that is commonly seen across Phoenician colonies is the Shaft Tomb, frequently used for Royals. Most of the tomb is underground, with a sarcophagus laid in a subterranean gallery. Then, this tomb is sealed with some coverstone, until some wayward archaeologist millennia later uncovers it. Ahiram's tomb, along with four other very important sarcophagi, were uncovered in a mudslide in modern Byblos, which lead to severe damage on his sarcophagus. Ahiram\’s sarcophagus in particular was inscribed with a curse meant to protect Byblos, though evidently it did not protect his tomb from being ransacked and robbed blind by graverobbers. "),
		("en_US", "LOC_PEDIA_BUILDINGS_PAGE_LEADER_BUILDING_LIME_PHOE_AHIRAM_TOMB_CHAPTER_HISTORY_PARA_4",
		"It’s suspected that perhaps the Phoenicians, being originally colonies of Egypt, developed these styles of burial as the more economical version of the Pharaonic burial in Egypt (because who can really afford to build gigantic pyramids everywhere?). It seems that the Phoenicians influenced the Egyptians in their own right, as later Egyptian tombs also featured shafts and underground graves.");

-- don't youuuuuu forget about meeeeeeeeeeee