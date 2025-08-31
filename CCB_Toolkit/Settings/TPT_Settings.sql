CREATE TABLE TPT_Settings (
	ParameterId TEXT NOT NULL,
	String TEXT NOT NULL,
	ToolTip TEXT,
	DefaultValue BOOLEAN DEFAULT 0,
	PRIMARY KEY(ParameterId)
);

INSERT OR REPLACE INTO TPT_Settings
		(ParameterId,										String,																ToolTip,																DefaultValue)
VALUES
		("DiplomacyRibbon_PlayerInfo_PlayerName",			"LOC_TPT_SETTINGS_UI_DPR_PLAYERINFO_PLAYERNAME_NAME",				"LOC_TPT_SETTINGS_UI_DPR_PLAYERINFO_PLAYERNAME_TT",						0),
		("DiplomacyRibbon_PlayerInfo_CiviName",				"LOC_TPT_SETTINGS_UI_DPR_PLAYERINFO_CIVINAME_NAME",					"LOC_TPT_SETTINGS_UI_DPR_PLAYERINFO_CIVINAME_TT",						0),
		("NotificationPanel_QuickClear",					"LOC_TPT_SETTINGS_UI_NOC_DISABLE_NAME",								"LOC_TPT_SETTINGS_UI_NOC_DISABLE_TT",									0),	
		("NotificationPanel_DealRemind",					"LOC_TPT_NDR_SOUND_NAME",											"LOC_TPT_NDR_SOUND_TT",													1),
		("CityStrikeButton_Back",							"LOC_TPT_SETTINGS_UI_CSB_DISABLE_NAME",								"LOC_TPT_SETTINGS_UI_CSB_DISABLE_TT",									0),
		("ForcedEndButton_Show",							"LOC_SHOW_FEB_NAME",												"LOC_SHOW_FEB_TT",														0),
		("GreatGeneralEraReminder_Show",					"LOC_SHOW_BER_NAME",												"LOC_SHOW_BER_TT",														1);