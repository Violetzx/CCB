UPDATE "UnitOperations" SET "HotkeyId" = "ExtraHotkeysPillageOrRepair" WHERE "HotkeyId" IS NULL AND ("OperationType" = "UNITOPERATION_PILLAGE" OR "OperationType" = "UNITOPERATION_COASTAL_RAID" OR "OperationType" = "UNITOPERATION_REPAIR");
UPDATE "UnitCommands" SET "HotkeyId" = "ExtraHotkeysUpgrade" WHERE "HotkeyId" IS NULL AND "CommandType" = "UNITCOMMAND_UPGRADE";
UPDATE "UnitCommands" SET "HotkeyId" = "ExtraHotkeysPromote" WHERE "HotkeyId" IS NULL AND "CommandType" = "UNITCOMMAND_PROMOTE";
UPDATE "UnitCommands" SET "HotkeyId" = "ExtraHotkeysUnitCancel" WHERE "HotkeyId" IS NULL AND "CommandType" = "UNITCOMMAND_CANCEL";
