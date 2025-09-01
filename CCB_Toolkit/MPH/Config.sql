-- 修改创建房间时的默认设置
UPDATE Parameters SET DefaultValue = "0" WHERE ParameterId = "GameMode_Monopolies";
UPDATE Parameters SET DefaultValue = "0" WHERE ParameterId = "GameMode_SecretSocieties";
UPDATE Parameters SET DefaultValue = "0" WHERE ParameterId = "TOOLS_COMMAND";
UPDATE Parameters SET DefaultValue = "SETTINGS_DIPLOMACYRIBBON_PUBLIC" WHERE ParameterId = "SETTINGS_DIPLOMACYRIBBON_TPT";