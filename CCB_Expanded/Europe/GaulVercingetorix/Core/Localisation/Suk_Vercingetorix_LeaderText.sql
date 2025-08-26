--========================================================================================================================
-- LocalizedText
--========================================================================================================================
CREATE TEMP TABLE IF NOT EXISTS _Variables (Name TEXT PRIMARY KEY, Value TEXT);
INSERT OR REPLACE INTO _Variables
	(
		Name,
		Value
	)
VALUES
	(
		'SUK_VERCINGETORIX',
		(SELECT CASE
			WHEN EXISTS (SELECT * FROM LocalizedText WHERE Tag = 'LOC_CIVILIZATION_GAUL_NAME')
			THEN 'SUK_VERCINGETORIX_DLC'
			ELSE 'SUK_VERCINGETORIX'
			END Description
		)
	);

INSERT OR REPLACE INTO BaseGameText
		(Tag,					Text)
VALUES
--========================================================================================================================
-- Leader
--========================================================================================================================
		("LOC_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_NAME",
		"Vercingetorix"	),

		("LOC_LOADING_INFO_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX"),
		"Proud Vercingetorix, be ever vigilant of those who would threaten Gaul. Unite your disparate people and rally your loyal oathsworn. Fortify your cities and settlements and let your walls stand strong. Keep your people safe and prosperous, and your name will live on in legend."),
--========================================================================================================================
-- Diplo
--========================================================================================================================
-- First Meet
-------------------------------------
		("LOC_DIPLO_FIRST_MEET_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Hail! I am Vercingetorix. I was chosen to lead the Gallic people and defend them against their foes."),
		("LOC_DIPLO_FIRST_MEET_VISIT_RECIPIENT_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Come and see our proud settlements. Know how well they are protected!"),
		("LOC_DIPLO_FIRST_MEET_NEAR_INITIATOR_POSITIVE_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"On behalf of my chieftains, yes!"),
		("LOC_DIPLO_FIRST_MEET_NO_MANS_INFO_EXCHANGE_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Tell me of your capital, and I will tell you of mine."),
-------------------------------------
-- Agenda Diplo
-------------------------------------
		("LOC_DIPLO_KUDO_EXIT_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"A strong army and a strong peoples. It appears we see eye to eye when it comes to leadership."),
		("LOC_DIPLO_WARNING_EXIT_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Will you turn that sword of yours against the Gallic people too? Tyrants such as you are not to be trusted."),
-------------------------------------
-- War and Peace
-------------------------------------
	-- Human Declares War
		("LOC_DIPLO_DECLARE_WAR_FROM_HUMAN_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Do you think we fear you? Every man and woman shall fight to their last"),
	-- AI Declares War
		("LOC_DIPLO_DECLARE_WAR_FROM_AI_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"You are a threat to all of Gaul. For the sake of our freedom, you must be stopped! Prepare to meet your end!"),
	-- Making Peace
		("LOC_DIPLO_MAKE_PEACE_AI_ACCEPT_DEAL_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Agreed. This futile war has gone on long enough."),
		("LOC_DIPLO_MAKE_PEACE_AI_REFUSE_DEAL_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"This war must continue. My people demand it!"),
		("LOC_DIPLO_MAKE_PEACE_FROM_AI_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"I grow weary of this war. Let us seek peace."),
	-- Defeat
		("LOC_DIPLO_DEFEAT_FROM_AI_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"We fought to our last—and lost. I surrender my arms to you and await your judgement."),
-------------------------------------
-- DoF
-------------------------------------
		("LOC_DIPLO_DECLARE_FRIEND_FROM_AI_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Let us announce our mutual friendship. Together we will give the tyrants of the world pause!"),
	-- AI requested friendship
		("LOC_DIPLO_ACCEPT_DECLARE_FRIEND_FROM_AI_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Excellent! This will give our enemies something to think about!"),
		("LOC_DIPLO_REJECT_DECLARE_FRIEND_FROM_AI_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"I am disappointed. Perhaps next time?"),
	-- On human requests friendship
		("LOC_DIPLO_ACCEPT_DECLARE_FRIEND_FROM_HUMAN_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Your honor us. Thank you."),
		("LOC_DIPLO_REJECT_DECLARE_FRIEND_FROM_HUMAN_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Gaul does not recognise a friendship with you."),
-------------------------------------
-- Delegation
-------------------------------------
		("LOC_DIPLO_DELEGATION_FROM_AI_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"I am sending you a gift that befits your station as a leader and a warrior—a golden torc weighing 100 libra."),
		("LOC_DIPLO_ACCEPT_DELEGATION_FROM_HUMAN_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Your delegation and the gifts they bear, are welcome. Thank you."),
		("LOC_DIPLO_REJECT_DELEGATION_FROM_HUMAN_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Unfortunately, I am currently occupied with a dispute amongst my chieftains and have no time to entertain a delegation."),
-------------------------------------
-- Denounce
-------------------------------------
		("LOC_DIPLO_DENOUNCE_FROM_HUMAN_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"My friends and fellow Gauls will rally to my defense. Who do you have to back your foul words?"),
		("LOC_DIPLO_DENOUNCE_FROM_AI_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"You are nothing but a tyrant who would see the world in chains!"),
-------------------------------------
-- Alliance
-------------------------------------
		("LOC_DIPLO_MAKE_ALLIANCE_FROM_AI_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"My people seek an alliance against the dangers of this world. Will you join us?"),
-------------------------------------
-- Misc Standard Lines
-------------------------------------
		("LOC_DIPLO_GREETING_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Hail!"),
		("LOC_DIPLO_REJECT_MAKE_DEAL_FROM_AI_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"This is not acceptable."),
		("LOC_DIPLO_ACCEPT_MAKE_DEAL_FROM_AI_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"A fine proposal. Agreed!"),
		("LOC_DIPLO_OPEN_BORDERS_FROM_AI_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"My chieftains suggest that open borders will improve relations between us."),
		("LOC_DIPLO_ACCEPT_OPEN_BORDERS_FROM_HUMAN_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Very well. I don't imagine we have much to fear from you."),
		("LOC_DIPLO_REJECT_OPEN_BORDERS_FROM_HUMAN_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"No, I will not have enemy soldiers meandering across Gallic lands."),
		("LOC_DIPLO_WARNING_TOO_MANY_TROOPS_NEAR_ME_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_ANY",
		"Our dūnons are well defend from any threats, as your soldiers can see. Are you satisfied with your army’s scouting?"),
--------------------------------------------------------------------
-- Quote and Pedia
--------------------------------------------------------------------
		("LOC_PEDIA_LEADERS_PAGE_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_QUOTE",
		"You want to fight? You want to live forever? Then I will lead you."  	), -- Yes, I know this is from a movie, but I can't even find a Gallic proverb to use so *shrugs*
		("LOC_PEDIA_LEADERS_PAGE_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_TITLE",
		"Vercingetorix"),
		("LOC_PEDIA_LEADERS_PAGE_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_SUBTITLE",
		"Verrix of the Gauls"),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_CHAPTER_CAPSULE_BODY",
		"Gaul's main strength lies in their unique interaction with the resources nature provides them. With the aid of the Oathsworn, the Dunon, and Vercingetorix's leadership, Gaulish lands will be unconquerable—as long as the people stay loyal."),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_CHAPTER_DETAILED_BODY",
		"Gaul's main question is one of where to settle. The bulk of their unique ability relies on settling on mineable resources, but this may mean you will have to settle a tile to two away from a river or a more advantageous spot. This is further complicated by the Dunon, which is likewise powerful but has similarly stringent requirements. Finding spots where you can take full advantage of both of these abilities will be key to a successful game. Vercingetorix's abilities help keep your empire safe: allowing you to quickly erect walls wherever they are needed, and providing a significant combat boost while everyone stays loyal."),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_CHAPTER_HISTORY_PARA_1",
		"Revered in France as its first national hero, Vercingetorix managed to unite several sovereign Celtic tribes to do battle against the aggressive Romans. Vercingetorix was an Arverni, one of the many Celtic tribes who ruled over what is France today, northern Germany, the Benelux countries, and the British Isles."),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_CHAPTER_HISTORY_PARA_2",
		"The Celtic world into which Vercingetorix was born in about 75 BC had evolved into a complex society which made military success and economic stability dependent on peasant agricultural labour, and vice versa. This system was the precursor of feudalism, a noble-peasant economic dependency that would dominate Europe for much of the Middle Ages. Vercingetorix hailed from a noble ruling family likely situated in what is now the town of Auvergny-a name reflecting its Celtic Arverni origins-in south-central Gaul, as France was then called. He inherited the chieftainship of the Arverni from his father, Celtillus, who had attempted to ascend to a kingship over several other Celtic tribes during a time of political uncertainty in central France. As a result, Celtillus was likely slain by a conspiracy of nobles and chiefs in opposition to him. Ironically, his son would advance to the position of leader of several Celtic tribes, but only when the necessity of an alliance became apparent, when a determined Roman army threatened."),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_CHAPTER_HISTORY_PARA_3",
		"As befitting the son of a Celtic noble and member of the warrior class, Vercingetorix was likely provided with military training from an early age. He was probably schooled in Druid beliefs and rites as well. During his lifetime, the Druids had become a powerful force in Celtic civilization, and were an adamantly conservative element very much opposed to Roman encroachment. Other Celtic tribes, such as the Boii, were more receptive to the economic promise and infrastructure development that Roman conquest offered. In southern Italy, the Roman republic was evolving, through a series of wars, conquests, and personal betrayals, into an empire. Julius Caesar was a popular democratic leader, one of the men of the first Triumvirate who ruled around 60 BC, but departed from the comforts of the urbanized and highly developed capital to conquer Gaul. This decade-long military campaign is chronicled in his De Bello Gallico (“The Gallic Wars”), from which the story survives as an account of Vercingetorix and his times."),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_CHAPTER_HISTORY_PARA_4",
		"Varying tribes of Celts had been long threatened by the menace of Germanic peoples like the Suevi. The Germans periodically emerged from what was a vast and, to the Romans, mysterious forest that spread across Central Europe. At first Caesar helped the Celts of central Gaul repel German encroachments, and also acted as arbitrator between Celtic tribes and their enemy, but began attacking central Gaul's tribes such as the Arverni. Because of the harsh treatment Romans sometimes unleashed on those they conquered, Celtic uprisings in northern Gaul began in 54 BC and continued through the following year. During the winter of 53-52 BC, Caesar returned to Rome, but left a garrison of soldiers stationed in central Gaul.An uprising of Celts, led by the Carnutes, slaughtered several Roman officials and traders at Cenabum (now Orleans, France) that winter. According to Caesar's chronicle, the news of the victory was shouted from Celtic settlement to settlement, and reached the borders of Vercingetorix's Arverni lands by the morning light. In his early twenties at that time, Vercingetorix wished to command a legion of Arverni and join with the Celts of central Gaul; his uncle, Gobannito, and several other elders thought this unwise, and so Vercingetorix was cast out of his capital, Gergovia, near what is today Clermont, France."),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_CHAPTER_HISTORY_PARA_5",
		"Caesar wrote respectfully of his Celtic foe in The Gallic Wars, noting that the exiled but determined Vercingetorix then gathered a militia of beggars and outcasts, and began convincing Arverni nobles to listen to his plan. Eventually he staged a coup in Gergovia and cast out those leaders who had rejected an offensive attack on the well-equipped, well-organized Romans.Vercingetorix then sent out emissaries to secure an allegiance, via the enforced handover of hostages, with several other Celtic tribes who ruled over sections of Gaul. These included the Senones, Parisii, Pictones, Cadurci, Turoni, Aulerci, Lemovice, and Andi, among others. He was named commander-in-chief. That winter, with Caesar still in Rome, Vercingetorix and Celtic armies began battling Roman garrisons in northern France. Caesar returned immediately upon learning of the attacks, though crossing over the Alps with an army, horses, and supplies was no easy task during the winter months. Roman legions began attacking Celtic settlements in vulnerable southern Gaul, many of whose men and arms had been sent north with Vercingetorix. Meanwhile, Vercingetorix had launched an assault on Gorgorbina, a town of Celtic Boii already loyal to Rome.Vercingetorix and his army were defeated at Vallaunodunum (modern Montargis), and then Caesar re-took Cenabum from the Celts, and burnt it to the ground. Caesar was in the process of taking the town of Noviodunum, whose Celtic Bituriges were handing over tribute and men, when the army of Vercingetorix was spotted in the distance. The Bituriges quickly shut their gates on the Romans, and a battle with Roman cavalry followed. Noviodunum then fell to the Romans, who planned to take the city of Avaricum (Bourges) next."),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_CHAPTER_HISTORY_PARA_6",
		"As a result of these setbacks, Vercingetorix called a summit at Bibracte, the stronghold of the Aedui, another great Celtic tribe who ruled over the lands to the north and east of the Arverni. The Aedui, according to the classical historian Plutarch in Lives of the Noble Grecians and Romans, 'had styled themselves brethren to the Romans, and had been much honoured by them.' This last great alliance in effect made Vercingetorix the first-and last-leader of a unified Celtic nation.Vercingetorix and his followers decided to burn their own settlements along the way, making it impossible for the Romans to obtain food in hostile territory. Twenty cities across the land of the Bituriges were set afire, and some in other areas as well. They decided not to burn Avaricum and defend it instead. But the Romans laid siege to Avaricum for several months, and eventually defeated the Celts in a bloody battle.Next on the Roman agenda was Gergovia. Vercingetorix recovered sufficiently from the setback of Avaricum to defend his hometown with renewed troops and determination. When the situation degenerated into a stalemate, Caesar's armies began marching toward Lutetia (Paris), burning everything Celtic they encountered along the way. Vercingetorix was forced to move against this, suffered an attack by the Roman cavalry, and had to retreat to Alesia. The walled center of the Celtic Mandubi tribe, Alesia was set on a hill and was theoretically easy to defend. The Romans built a massive fortification around it, however, with their usual marvels of defensive engineering constructed-towers, battering rams, screens on wheels-on the side facing the hill. They also constructed walls at the rear to protect it from Celts arriving as reinforcements, for Vercingetorix had sent out emissaries in the middle of the night back to their own home states for additional men, arms, and horses. Caesar wrote that a quarter-million Celts arrived to do battle at Alesia. Plutarch places this number at 300,000, and notes that inside Alesia's walls was already a Celtic force of about 170,000."),
		("LOC_PEDIA_LEADERS_PAGE_LEADER_"||(SELECT Value FROM _Variables WHERE Name = "SUK_VERCINGETORIX")||"_CHAPTER_HISTORY_PARA_7",
		"But the Romans, who also had dug deep trenches, simply waited for Vercingetorix and the Celtic army to run out of provisions. Vercingetorix sent out sorties to battle the Roman soldiers, but poor communication and coordination of efforts plagued the poorly-organized Celts, and they suffered numerous reverses. Vercingetorix's cousin, Vercassivellaunus, battled from the rear in one coordinated attack, but failed to break the Roman line. The Celtic troops facing the Romans from outside saw the futility of the effort, and abandoned Alesia.When Alesia surrendered, Caesar demanded not just all arms of the Celts but their leader as well. Vercingetorix told his colleagues that they could either deliver him dead or alive to the Romans, according to their wishes. Alive, it was decreed. According to Plutarch, Vercingetorix prepared by “putting his best armour on, and adorning his horse, [then] rode out of the gates, and made a turn about Caesar as he was sitting, then quitting his horse, threw off his armour, and remained quietly sitting at Caesar's feet until he was led away to be reserved for the triumph.” It was his last act as a free man as he was then taken into custody and returned with Caesar to Rome, where a 20-day public thanksgiving was called for the not-insignificant conquest of Gaul. Vercingetorix was allegedly dragged behind Caesar's chariot in the official victory parade. He died in Rome about 46 BC.");
--========================================================================================================================
--========================================================================================================================
 DROP TABLE _Variables;
 --========================================================================================================================
--========================================================================================================================