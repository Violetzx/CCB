CREATE TABLE TPT_PlayerData (
	SteamID TEXT NOT NULL,
	Name TEXT,
	Type TEXT NOT NULL,
	Icon TEXT,
	Desc TEXT,
	ToolTipType TEXT,
	Start_Date DATE,
	End_Date DATE,
	PRIMARY KEY(SteamID)
);
------------------------------------------------------------------------  管理员  ------------------------------------------------------------------------
INSERT OR REPLACE INTO TPT_PlayerData
		(SteamID,					Name,					Type,				Icon,														Desc,						ToolTipType)
VALUES	
		("76561198147378701",		"号码菌",				"Admin",			"[Icon_Host][COLOR_LIGHTBLUE]管理员",						"[ENDCOLOR][size_16]      [ICON_LIFESPAN][NEWLINE][Size_38][NEWLINE][Size_0][ICON_ICON_TECH_LASERS][NEWLINE][Size_20][ICON_ICON_ETHNICITY_ASIAN_UNIT_GIANT_DEATH_ROBOT_PORTRAIT]",	"Bermuda_Triangle");

-----------------------------------------------------------------------  玩家标记  -----------------------------------------------------------------------
INSERT OR REPLACE INTO TPT_PlayerData
		(SteamID,					Name,					Type,				Icon,												ToolTipType)
VALUES	
		("76561199106342760",		"安德",					"Normal",			"[COLOR:ResGoldLabelCS][size_20]  安德神",			"AnDe_Desc"),
		("76561198106599147",		"花名",					"Normal",			"[Color:255,192,203][size_20]   花 名",				"HuaMing_Desc"),
		("76561198413532325",		"晴天",					"Normal",			"[Color:255,141,141]初见py",							"QingTian_Desc");

INSERT OR REPLACE INTO TPT_PlayerData
		(SteamID,					Name,								Type,				Icon,																		Desc)
VALUES
--		("76561198985848546",		"超人强",							"Normal",			"[Icon_Host][COLOR_LIGHTBLUE]超人强",										"[size_40][COLOR_LIGHTBLUE]超人强"),
		("76561198933798292",		"Rookie",							"Normal",			"[COLOR:ResGoldLabelCS][size_20]   沙 皇",									"[COLOR:ResGoldLabelCS][size_40]   沙 皇"),
		("76561198419573008",		"小北风",							"Normal",			"[COLOR:ResGoldLabelCS]爱要自在漂浮",											"[size_40]小北风"),
		("76561198100489219",		"sTon1",							"Normal",			"[ICON_RESOURCE_STONE][Color:255,215,0]石头神",								"[size_24]sTon1"),
		("76561199128594416",		"海芙约忒",							"Normal",			"[color:122,205,245][size_20]  海芙约忒",									"[color:95,216,251]大雨还在下，凌虚寒烟，碧水惊秋，水神泡芙[ICON_ICON_ETHNICITY_AFRICAN_UNIT_GREAT_ADMIRAL_PORTRAIT]"),
		("76561198847264780",		"leaf",								"Normal",			"[color:252,237,50][size_20]  海绵宝宝",										"[size_24]godleaf"),
		("76561198315901472",		"枫屿",								"Normal",			"[color:35,142,35][size_20]送高祖  枫 屿",									"[color:112,219,219][size_29]前排梁马军阀，后排灯塔祠堂[NEWLINE][ICON_ICON_BUILDING_GREAT_LIGHTHOUSE_FOW][ICON_ICON_BUILDING_TERRACOTTA_ARMY_FOW]看我马桶三连"),
		("76561199218437534",		"顾及",								"Normal",			"[ICON_Pillaged]",															NULL),
		("76561198255804454",		"罗马使用者",							"Normal",			"[ICON_SCIENCELARGE][COLOR_LIGHTBLUE]罗马使用者",								"[size_40][COLOR_LIGHTBLUE]帝国の余晖"),
		("76561199247468302",		"墨香",								"Normal",			"[ICON_Reports][COLOR:Happiness][size_18]墨香书挽风*",						"[COLOR:ResCultureLabelCS][size_29]              [Icon_Icon_Leader_Jadwiga]✿水逆退散✿[Icon_Icon_Leader_Catherine_De_Medici][newline]饿了就去吃喜欢的美食(*´◒`*)[newline]看腻了的照片就删掉ʕ´•ᴥ•`ʔ[newline]不开心的时候就睡一觉Zz(´-ω-`)[newline]遇见喜欢的人就表白Σ(〃°ω°〃)♥[newline]人生那么短暂哪有时间让你去犹豫"),
		("76561198406366362",		"红茶拿铁",							"Normal",			"[color:30,185,255] [icon_Science]红茶拿铁",									"[color:30,185,255][ICON_ICON_BUILDING_RESEARCH_LAB]偷个化学先"),
		("76561198404479942",		"谨言",								"Normal",			"[COLOR:ResGoldLabelCS]谨言",												"谨言"),
		("76561198283381092",		"雨(89)",							"Normal",			"[Icon_Host][Color:153,204,255]夜雨灬清晨",									"[COLOR:Red][size_24]萌新雨"),
		("76561199028289282",		"小羊",								"Normal",			"[Color:0,255,255][size_20]   羊  神",										"顶尖捞鱼"),
		("76561199027415352",		"菜猪",								"Normal",			"[COLOR:ResGoldLabelCS]菜猪宝宝[ICON_CULTURELARGE]",							"[COLOR:ResGoldLabelCS][Size_32]菜猪宝宝[ICON_ICON_NOTIFICATION_FILL_CIVIC_SLOT]"),
		("76561199136071905",		"无言",								"Normal",			"[COLOR:ResGoldLabelCS]前排要死后排睡觉",										"六言[ICON_ICON_CIVILIZATION_KUMASI]"),
		("76561198175919665",		"小B将",								"Normal",			"[COLOR:ResGoldLabelCS]地球最善の蒙古[ICON_ICON_UNIT_MONGOLIAN_KESHIG]",		"小B将"),
		("76561199355567131",		"海绵宝宝",							"Normal",			"[Icon_CapitalLarge][COLOR:ResGoldLabelCS]玩家标记",							"[COLOR:ResGoldLabelCS]萌新DUCK[ICON_ICON_DISTRICT_COMMERCIAL_HUB]"),
		("76561199235632871",		"BOOMJ",							"Normal",			"[ICON_DISTRICT_ACROPOLIS][color:255,110,199]抽象杯冠军",						"[size_40]《最抽象的选手》"),
		("76561198911409618",		"依雪千城",							"Normal",			"[Icon_ProductionLarge][Color:255,215,0]百锤校长",							"[size_3]            [ICON_ICON_GENERIC_GREAT_PERSON_INDIVIDUAL_SCIENTIST][size_20][NewLine][color:255,125,64][size_26]炼金术会所"),
		("76561198807503948",		"柴犬",								"Normal",			"[Icon_GoldLarge][COLOR:ResGoldLabelCS]21点圣手",							"前方队友挨3家打，后排偷逼爽完21点");
		
INSERT OR REPLACE INTO TPT_PlayerData
		(SteamID,					Name,								Type,				Desc)
VALUES
		("76561199440457866",		"酌一杯南烛",							"Normal",			"一杯南烛酒"),
		("76561199089944797",		"苦力怕",							"Normal",			"[color:255,145,227]啊啊啊苦力怕你是一个香香软软的小蛋糕"),
		("76561198090033513",		"红隼",								"Normal",			"谋玛雅40t200锤的传说"),
		("76561199225618632",		"素月墨羽/八域巡天使",					"Normal",			"奉剑正中央！"),
		("76561199519934139",		"手提玉剑斥千军，昔日锦鲤化金龙",		"Normal",			"马踏祁连山河动，兵起玄黄奈何天"),
		("76561199120750841",		"千川白浪",							"Normal",			"文明VI MOD创作者"),
--		("76561199128594416",		"海芙约忒",							"Normal",			"[COLOR_LIGHTBLUE]大雨还在下，凌虚寒烟，碧水惊秋，水神泡芙"),
        ("76561199155440739",		"小情绪反反复复不婷",					"Normal",			"小情绪"),
        ("76561199061699058",		"奶龙",								"Normal",			"奶龙"),
		("76561199024266950",		"辉洛",								"Normal",			"白皮恶霸"),
		("76561199159430892",		"小鱼快变强",							"Normal",			"[D.T.P] Knight"),
		("76561199216035192",		"清羽",								"Normal",			"牛马萌新"),
		("76561199206377175",		"韬光养晦",							"Normal",			"韬光养晦"),
		("76561198816054351",		"果冻",								"Normal",			"果冻"),
		("76561199518143843",		"烟水",								"Normal",			"烟火车牛马"),
		("76561199226874133",		"才玩10小时",						"Normal",			"寒酥"),
		("76561198302318532",		"烤肉冠军7",							"Normal",			"烤肉冠军"),
		("76561198321978362",		"感悟心理学完颜慧德",					"Normal",			"感悟心理学治疗师"),
--		("76561198175919665",		"小B将",								"Normal",			"炒鸡核弹"),
		("76561198415854005",		"30t败走堪培拉",						"Normal",			"在皇家海军船坞服刑的袋鼠"),
		("76561199384411130",		"大拳萌香",							"Normal",			"大拳"),
--		("76561198100489219",		"叫我石头哥",							"Normal",			"叫我石头哥"),
		("76561199390266898",		"温迪",								"Normal",			"好想要求求了"),
		("76561198290144463",		"天天",								"Normal",			"天天"),
		("76561198329823789",		"雨村玲玲子是绝世寡狗",				"Normal",			"你看这条人，他好像个狗哦~"),
		("76561198929307244",		"白月光",							"Normal",			"歪嘴龙王一本"),
		("76561198407086813",		"冬眠",								"Normal",			"冬眠"),
		("76561198837666138",		"441",								"Normal",			"[ICON_ICON_CIVIC_MOBILIZATION]"),
		("76561199181310844",		"是只猪不是蜘蛛",						"Normal",			"i本既不黑也不白"),
		("76561198811341582",		"我无法对和纱说谎",					"Normal",			"黄油仙人"),
		("76561198093064225",		"超凶,会咬人!",						"Normal",			"真的是假的!"),
		("76561198327128522",		"wanBiceps",						"Normal",			"wanBiceps"),
		("76561198929311502",		"Vida",								"Normal",			"Mi Vida"),
		("76561198354992117",		"摸鱼的老杨",							"Normal",			"就在这立法典"),
		("76561199018385951",		"维尼",								"Normal",			"TeamPVP新万神殿已上架创意工坊，欢迎大佬订阅"),
		("76561198822641984",		"火玄",								"Normal",			"[ENDCOLOR][size_16]      [ICON_ARMY][NEWLINE][Size_42][NEWLINE][Size_20][ICON_ICON_ETHNICITY_ASIAN_UNIT_GIANT_DEATH_ROBOT_PORTRAIT]"),
		("76561198403277407",		"焰小夜",							"Normal",			"焰小夜"),
--		("76561199072983831",		"gun god",							"Normal",			"枪神"),
		("76561198139826388",		"forlin1130",						"Normal",			"[ICON_ICON_RESOURCE_WHALES][size_24]爱林[ICON_ICON_RESOURCE_COSMETICS][ICON_ICON_RESOURCE_COSMETICS]"),
		("76561198309611074",		"Magical",							"Normal",			"概念神代言人"),
--		("76561199203400751",		"飞得起",							"Normal",			"飞神"),
		("76561198371554029",		"Imry02",							"Normal",			"Code:002"),
		("76561199213872953",		"小树林里的一夜",						"Normal",			"金牌厨师长"),
		("76561199141287462",		"此时之王非朕莫属",					"Normal",			"糕手古月"),
		("76561199433767421",		"不对小菊姐姐说谎",					"Normal",			"糕手萌新"),
		("76561198424583208",		"saber5211314",						"Normal",			"为什么要欺负可爱的苏苏"),
		("76561199288128084",		"针眼画师",							"Normal",			"小朱"),
--		("76561199093403856",		"9527",								"Normal",			"9神"),
--		("76561199218437534",		"Hepheastus",						"Normal",			"[ICON_Pillaged]"),
		("76561198400127376",		"游戏之迷",							"Normal",			"什么文明都可以发酵"),
--		("76561198419573008",		"爱要自在漂浮才美丽",					"Normal",			"白给"),
--		("76561198807503948",		"柴犬",								"Normal",			"柴犬"),
		("76561198809882660",		"Doubility",						"Normal",			" Σ(っ °Д °;)っ!!"),
		("76561199312702213",		"老超",								"Normal",			"[size_48][COLOR:ResGoldLabelCS]老超"),
		("76561199083867874",		"春日幻",							"Normal",			"发酵仔"),
		("76561198317296254",		"带你去看浪漫土耳其",					"Normal",			"手下留情有话好说"),
		("76561198352190550",		"唐浪尘丶Triumph",					"Normal",			"嘤嘤嘤"),
		("76561198988544628",		"SSS",								"Normal",			"极致发育"),
		("76561199057762168",		"雌小猫好想被哥哥带避孕套顶到喷水",		"Normal",			"文明交际花~"),		-- 猫妹
--		("76561198967066917",		"倒反天罡",							"Normal",			"倒反天罡"),
		("76561198365253715",		"诺咿",								"Normal",			"[size_48]bilibili 诺咿a"),
		("76561199037457125",		"白色星空",							"Normal",			"[ICON_ICON_LEADER_LUDWIG]"),
		("76561199249204091",		"很可拷的小伙",						"Normal",			"我爱[icon_amenities]"),
--		("76561198406366362",		"红茶拿铁",							"Normal",			"红茶拿铁"),
--		("76561198967070938",		"硬邦邦",							"Normal",			"伟大的硬邦邦国王"),
		("76561199096403971",		"被窝秋裤",							"Normal",			"萌新导师"),
		("76561199435806376",		"天才美少女kkz",						"Normal",			"努努"),
		("76561199369391459",		"苝之梦",							"Normal",			"活不过一乔的梦梦"),
--		("76561199028289282",		"[icon_GoldLarge]小羊",				"Normal",			"萌新小羊"),
--		("76561198198644173",		"彻底死去",							"Normal",			"神童"),
		("76561199114267670",		"honor",							"Normal",			"吸血鬼"),
		("76561198861778674",		"123丶kza",							"Normal",			"123丶kza"),
		("76561198231107016",		"诗槐远",							"Normal",			"槐南一梦"),
		("76561198308807554",		"抚泓 猎",							"Normal",			"[ICON_ICON_GREAT_PERSON_CLASS_PROPHET][NEWLINE][size_24]   猎门!"),
		("76561198333214466",		"Don't eat cute cats",				"Normal",			"[ICON_ICON_LEADER_ELEANOR_FRANCE]"),
--		("76561198077371164",		"乐理乐不请",							"Normal",			"乐神标记!"),
--		("76561198166670204",		"来福小二",							"Normal",			"二神!"),
--		("76561199247468302",		"墨香",								"Normal",			"[COLOR:Happiness]墨[icon_Host]香"),
		("76561198972883036",		"铃铛",								"Normal",			"铃铛是个大笨蛋!"),
		("76561198385536824",		"Pyun",								"Normal",			"[ICON_ICON_LEADER_BARBAROSSA]"),
		("76561198113873022",		"贾文和真乱舞",						"Normal",			"[size_36]糕受!"),
--		("76561199097083341",		"萌新鱼鱼",							"Normal",			"[Icon_RESOURCE_FISH]"),
--		("76561198106404582",		"星空下的璀璨",						"Normal",			"[Icon_Icon_LEADER_AMBIORIX]"),
		("76561198365905771",		"福西蛇喷手",							"Normal",			"2[ICON_Food]3[ICON_Production]5[ICON_Culture]"),
--		("76561198809367750",		"闪光皮皮",							"Normal",			"[Icon_barbarian][COLOR:ResMilitaryLabelCS]蛮族标记[Icon_barbarian]"),
--		("76561198091154674",		"啦啦啦",							"Normal",			"[ICON_ICON_LEADER_alexander]2[ICON_Food]3[ICON_Production]5[ICON_Culture]"),
--		("76561198918071348",		"小熊猫",							"Normal",			"[Icon_Army]小熊猫"),
--		("76561199137958210",		"禁止学院开",							"Normal",			"[size_36]PG"),
		("76561198866141956",		"小丑皮",							"Normal",			"[Icon_RESOURCE_CATTLE]指点大王[Icon_RESOURCE_HORSES]"),
--		("76561198847264780",		"叶子",								"Normal",			"[size_24]godleaf"),
--		("76561198283381092",		"雨(89)",							"Normal",			"[COLOR:Red][size_24]萌新雨"),
		("76561198095083789",		"小裨将",							"Normal",			"[ICON_ICON_LEADER_VICTORIA_ALT]海底捞"),
		("76561199485108991",		"一周骗她久次",						"Normal",			"[size_24]下饭"),
		("76561198870892682",		"喵喵",								"Normal",			"子非鱼"),
		("76561198408502756",		"地烂就去睡觉了",						"Normal",			"长城YYDS"),
		("76561198799623036",		"苏小白",							"Normal",			"苏小白"),
		("76561198317624505",		"牛奶",								"Normal",			"[Icon_resource_cattle]"),
		("76561199074490787",		"入夜雪",							"Normal",			"入夜雪"),
		("76561199094524422",		"脑花花",							"Normal",			"[size_24][COLOR:ResGoldLabelCS]脑花花"),
		("76561198328986084",		"琥珀",								"Normal",			"世界第一可爱萌新"	),
		("76561199426397928",		"红早",								"Normal",			"[ICON_ICON_GREAT_PERSON_CLASS_ARTIST][newline][size_24]大艺术家"),
		("76561199172305820",		"孤雏饮红茶",							"Normal",			"乐理车毕业生"),
--		("76561199212568162",		"speechless",						"Normal",			"[size_24]无言"),
		("76561198821529734",		"Wilgose",							"Normal",			"[ICON_ICON_UNIT_SCOUT_FOW][size_24]尾狗"),
		("76561198141029065",		"小零",								"Normal",			"笨蛋小零TAT"),
		("76561198127666611",		"Big Boss",							"Normal",			"总指挥“解放者”"),
		("76561198409730393",		"worfdog",							"Normal",			"保护我方最好的怯战蜥蜴"),
		("76561198330599085",		"我家的猫会后空翻哦",					"Normal",			"乐吃乐不饱"),
		("76561198980069344",		"炼铜术士mir",						"Normal",			"可爱の术士喵");

----------------------------------------------------------------------  荣誉标记  ----------------------------------------------------------------------		
INSERT OR REPLACE INTO TPT_PlayerData
		(SteamID,					Name,					Type,				Icon,														Desc)
VALUES
		("76561198334532538",		"Emrys",				"Honor",			"[COLOR:ResGoldLabelCS]巴巴里杯s1冠军",						"i龟 龟鸡铁粉"),
		("76561198077371164",		"乐理乐不清",				"Honor",			"[COLOR:ResGoldLabelCS]巴巴里杯s1冠军",						"团队之光"),
		("76561198988981542",		"Solarian",				"Honor",			"[COLOR:ResGoldLabelCS]巴巴里杯s1冠军",						"龟鸡神粉丝，i龟集合！"),		
		("76561198972616242",		"若影",					"Honor",			"[COLOR:ResGoldLabelCS]巴巴里杯s1冠军",						"i龟 顶着伟大龟鸡神名字上场龟族族长龟面"),
--		("76561198314354229",		"Carson",				"Honor",			"[COLOR:ResGoldLabelCS]巴巴里杯s1冠军",						"我是笨蛋");

		("76561198894543602",		"轨迹",					"Honor",			"[COLOR:ResGoldLabelCS]巴巴里杯s2冠军",						"[ICON_ICON_BUILDING_STATUE_OF_ZEUS_FOW]"),
		("76561198099893319",		"Lych4",				"Honor",			"[COLOR:ResGoldLabelCS]巴巴里杯s2冠军",						"[ICON_ICON_BUILDING_GRANARY] [ICON_ICON_UNIT_GREAT_PROPHET_PORTRAIT]"),
		("76561198366422842",		"大师兄",				"Honor",			"[COLOR:ResGoldLabelCS]巴巴里杯s2冠军",						"某不知名摸鱼练习生"),
		("76561198334532538",		"emrys",				"Honor",			"[COLOR:ResGoldLabelCS]巴巴里杯s2冠军",						"[ICON_ICON_GENERIC_GREAT_PERSON_INDIVIDUAL_GENERAL][newline][size_24]奢侈猎人"),
		("76561198123728330",		"long",					"Honor",			"[COLOR:ResGoldLabelCS]巴巴里杯s2冠军",						"[ICON_ICON_ETHNICITY_ASIAN_UNIT_SCOUT_PORTRAIT][newline]吸条狗");


INSERT OR REPLACE INTO TPT_PlayerData
		(SteamID,					Name,					Type,				Icon,														ToolTipType)
VALUES

		("111",						"xxx",					"Honor",			"[COLOR:ResGoldLabelCS]炼金杯S2届冠军",						"LianJingCup_PlayerHonor_S2"),
		("222",						"xxx",					"Honor",			"[COLOR:ResGoldLabelCS]炼金杯S2届冠军",						"LianJingCup_PlayerHonor_S2"),
		("333",						"xxx",					"Honor",			"[COLOR:ResGoldLabelCS]炼金杯S2届冠军",						"LianJingCup_PlayerHonor_S2"),
		("444",						"xxx",					"Honor",			"[COLOR:ResGoldLabelCS]炼金杯S2届冠军",						"LianJingCup_PlayerHonor_S2"),
		("555",						"xxx",					"Honor",			"[COLOR:ResGoldLabelCS]炼金杯S2届冠军",						"LianJingCup_PlayerHonor_S2"),
		("666",						"xxx",					"Honor",			"[COLOR:ResGoldLabelCS]炼金杯S2届冠军",						"LianJingCup_PlayerHonor_S2");


-----------------------------------------------------------------------  黑名单  -----------------------------------------------------------------------
INSERT OR REPLACE INTO TPT_PlayerData
		(SteamID,					Name,					Type,				End_Date,					Icon,											Desc)
VALUES
		("76561198377320002",		"兔兔酱吖",				"Ban",				"2034-05-11",				"[Icon_Exclamation][COLOR:Red]警告：作弊开挂",	"兔兔酱吖:[NEWLINE]多次在多人联机中开挂作弊，使用恶意伪装的模组，增强自己所选文明，用恶意UI界面侵害其他玩家电脑。请拒绝与此玩家进行联机游戏，不要自动下载可疑模组。[NEWLINE][NEWLINE]作弊案例1:使用同名的魔女基础mod修改数据，使武僧价格变成40信仰。[NEWLINE][NEWLINE]作弊案例2:使用同名的工人劳动力助手模组，修改德国、加拿大、德川家康的能力，建造区域和建筑加速5倍，搓兵加速50倍，出生绑定资源。"),
		("76561198883038713",		"兔兔酱吖",				"Ban",				"2034-05-11",				"[Icon_Exclamation][COLOR:Red]警告：作弊开挂",	"兔兔酱吖:[NEWLINE]多次在多人联机中开挂作弊，使用恶意伪装的模组，增强自己所选文明，用恶意UI界面侵害其他玩家电脑。请拒绝与此玩家进行联机游戏，不要自动下载可疑模组。[NEWLINE][NEWLINE]作弊案例1:使用同名的魔女基础mod修改数据，使武僧价格变成40信仰。[NEWLINE][NEWLINE]作弊案例2:使用同名的工人劳动力助手模组，修改德国、加拿大、德川家康的能力，建造区域和建筑加速5倍，搓兵加速50倍，出生绑定资源。"),
		("76561199200291870",		"读书才有[icon_culture]","Ban",				"2024-02-16",				"[Icon_Exclamation]恶意跳车",					"吸对面奢侈炸车"),
		("76561198809941718",		"600小时恐怖如斯",		"Ban",				"2024-02-12",				"[Icon_Exclamation]跳车拔线",					"遇到克里拔线跳车，多次恶意跳车"),
		("76561199012655779",		"一只蒋大仙",				"Ban",				"2024-01-22",				"[Icon_Exclamation]不良记录",					"被踩1牧场后跳车"),
		("76561198356858546",		"?????",				"Ban",				"2024-01-11",				"[Icon_Exclamation]恶意跳车",					"规划坐自己队友4环，然后拔线跳车"),
		("76561199199495715",		"火烧云美如你",			"Ban",				"2023-12-29",				"[Icon_Exclamation]跳车小子",					"恶意跳车");

-----------------------------------------------------------------------  默认图标  -----------------------------------------------------------------------
UPDATE TPT_PlayerData
SET Icon = "[Icon_Host][COLOR_LIGHTBLUE]管理员"
WHERE Type = "Admin" AND Icon IS NULL;

UPDATE TPT_PlayerData
SET Icon = "[Icon_CapitalLarge][COLOR:ResGoldLabelCS]玩家标记"
WHERE Type = "Normal" AND Icon IS NULL;

UPDATE TPT_PlayerData
SET Icon = "[Icon_Army][COLOR:ResGoldLabelCS]荣誉标记"
WHERE Type = "Honor" AND Icon IS NULL;

UPDATE TPT_PlayerData
SET Icon = "[Icon_Exclamation]不良记录"
WHERE Type = "Ban" AND Icon IS NULL;