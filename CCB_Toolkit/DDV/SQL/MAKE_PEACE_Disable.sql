UPDATE GlobalParameters SET Value='9000' WHERE Name='DIPLOMACY_WAR_MIN_TURNS';		-- 不可和解？

DELETE from DiplomaticActions 		WHERE DiplomaticActionType='DIPLOACTION_PROPOSE_PEACE_DEAL';		-- 删除和解选项
DELETE from DiplomaticStateActions 	WHERE DiplomaticActionType='DIPLOACTION_PROPOSE_PEACE_DEAL';
DELETE from AiFavoredItems 			WHERE Item='DIPLOACTION_PROPOSE_PEACE_DEAL';