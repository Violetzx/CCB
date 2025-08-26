include "BBM_MapUtils";
---------------------------------------
-- SpawnBalancing
-- Score and balancing major civ spawns
---------------------------------------
SpawnBalancing = {}

-- Sort of enum
local TerraformType = {};
TerraformType[99] = "Clean";
TerraformType[1] = "Terrain";
TerraformType[2] = "Feature";
TerraformType[3] = "Resource";
TerraformType[4] = "To4Yields";
TerraformType[5] = "Desert";
TerraformType[6] = "Add1Food";
TerraformType[7] = "Remove1Food";
TerraformType[8] = "Add1Prod";
TerraformType[9] = "Remove1Prod";
TerraformType[10] = "MountainToHills";
TerraformType[11] = "AddLux";
TerraformType[12] = "ToStdHighFoodYield";
TerraformType[13] = "StdTohighYield";
TerraformType[14] = "ToHills";
TerraformType[15] = "ToFlat";
TerraformType[16] = "To22Tile";

function SpawnBalancing.new(hex, hexMap, civ)
    local instance = {};
    setmetatable(instance, {__index = SpawnBalancing});
    instance.Hex = hex;
    instance.HexMap = hexMap;
    instance.Civ = civ;
    instance.RingTables = {};
    instance.MaxRing = 6;
    instance.CoastalScore = 0;
    instance.AimedCoastalScore = 0;
    instance:FillTablesRings();
    instance.TerraformedTiles = {};
    instance.InnerRingLuxCount = 0;
    instance.OuterRingLuxCount = 0;
    instance.MinLuxInnerRingThreshold = 2;
    instance.MaxLuxInnerRingThreshold = 3;
    instance.MinLuxOuterRingThreshold = 0;--undefined/not needed
    instance.MaxLuxOuterRingThreshold = 7;
    instance.MinHighYieldInnerRingThreshold = 0;
    instance.MaxHighYieldInnerRingThreshold = 1;
    instance.Min22TilesInRing2 = 3;
    instance.IsBCYActivated = isBCYActivated()
    _Debug("Init SpawnBalancing")

    _Debug("Spawn hill score = ", hex.TerrainsScore[g_HILLS])
    _Debug("Spawn land score = ", hex.TerrainsScore[g_PASSABLE_LAND])
    _Debug("Land to hills ratio ", hex.TerrainsScore[g_HILLS] / hex.TerrainsScore[g_PASSABLE_LAND])
    return instance;
end

function isBCYActivated()
    local bcySetting = GameConfiguration.GetValue("BBCC_SETTING");
    local bcySettingYield = GameConfiguration.GetValue("BBCC_SETTING_YIELD");
    return bcySetting == 1 and bcySettingYield == 0;
end

--------------------
-- Temporary data tables used to find where to apply minimal tiles before balancing
--------------------
function SpawnBalancing:FillTablesRings()
    _Debug("SpawnBalancing FillTablesRings - "..self.Civ.CivilizationLeader)
    for i = 1, self.MaxRing do
        self:FillTableRing(i);

        _Debug(self.Hex:PrintXY().." - MOUNTAINS "..tostring(i).. " = "..tostring(#self.RingTables[i].MOUNTAINS))
        _Debug(self.Hex:PrintXY().." - EMPTY_TILES "..tostring(i).. " = "..tostring(#self.RingTables[i].EMPTY_TILES))
        _Debug(self.Hex:PrintXY().." - LOW_YIELD_TILES "..tostring(i).. " = "..tostring(#self.RingTables[i].LOW_YIELD_TILES))
        _Debug(self.Hex:PrintXY().." - STANDARD_YIELD_TILES "..tostring(i).. " = "..tostring(#self.RingTables[i].STANDARD_YIELD_TILES))
        _Debug(self.Hex:PrintXY().." - HIGH_YIELD_TILES "..tostring(i).. " = "..tostring(#self.RingTables[i].HIGH_YIELD_TILES))
        _Debug(self.Hex:PrintXY().." - HIGH_EXTRA_YIELDS "..tostring(i).. " = "..tostring(#self.RingTables[i].HIGH_EXTRA_YIELDS))
        _Debug(self.Hex:PrintXY().." - WORKABLE "..tostring(i).. " = "..tostring(#self.RingTables[i].WORKABLE))
    end
end

function SpawnBalancing:FillTableRing(i)
    self.RingTables[i] = {};
    self.RingTables[i].HexRings = self.Hex.AllRing6Map[i];
    self.RingTables[i].WATER = {};
    self.RingTables[i].WATER_EMPTY = {};
    self.RingTables[i].WATER_RF = {}; -- water with resource or reef
    self.RingTables[i].WATER_FISH_OR_LUX = {}; -- water with fish or lux
    self.RingTables[i].MOUNTAINS = {};  --mountain or water
    self.RingTables[i].DESERT = {};
    self.RingTables[i].EMPTY_TILES = {}; -- grasslands or plains without feature or resource
    self.RingTables[i].LOW_YIELD_TILES = {}; --yields < 2 food or < 2 prod with feature or resource
    self.RingTables[i].STANDARD_YIELD_TILES = {}; -- 4 yields tiles
    self.RingTables[i].HIGH_YIELD_TILES = {}; -- food+prod > 4
    self.RingTables[i].HIGH_EXTRA_YIELDS = {}; -- food+prod >= 4 and has extra yield science/culture/faith, also included in the others table
    self.RingTables[i].WORKABLE = {}; -- food+prod >=3
    self.RingTables[i].RELOCATING_TILES = {}; -- Used during process to relocate existing tiles
    for _, h in pairs(self.RingTables[i].HexRings) do
        self:UpdateTableDataRing(h, i);
    end
end

local CoastalScoring = {}
CoastalScoring.CRABS_R2 = 30
CoastalScoring.CRABS_R3 = 10
CoastalScoring.FISH_R2 = 70
CoastalScoring.FISH_R3 = 40
CoastalScoring.FISH_REEF_R2 = 120
CoastalScoring.FISH_REEF_R3 = 95
CoastalScoring.PEARLS_R2 = 70
CoastalScoring.PEARLS_R3 = 40
CoastalScoring.AMBER_R2 = 55
CoastalScoring.AMBER_R3 = 30
CoastalScoring.WHALES_R2 = 80
CoastalScoring.WHALES_R3 = 50
CoastalScoring.TURTLES_R2 = 120
CoastalScoring.TURTLES_R3 = 95
CoastalScoring.REEF_R2 = 20
CoastalScoring.REEF_R3 = 10
CoastalScoring.BASE_COASTAL_SCORE = 190 --210
CoastalScoring.COASTAL_MARGIN = 20 --30


function SpawnBalancing:CleanSpawnTile()
    -- Hills start for Menelik
    if self.Civ.CivilizationLeader == "LEADER_MENELIK" then
        self.HexMap:TerraformToHill(self.Hex, true);
    end
    -- If spawn on a resource, try relocate it on ring 3
    if self.Hex.ResourceType ~= g_RESOURCE_NONE then
        local hexData = { TerrainId = self.Hex.TerrainType,  FeatureId = self.Hex.FeatureType, ResourceId = self.Hex.ResourceType, Relocated = false}
        _Debug("Spawned on a resource, relocating "..tostring(self.Hex.ResourceType))
        table.insert(self.RingTables[3].RELOCATING_TILES, hexData);
        self:TerraformHex(self.Hex, 0, TerraformType[3], g_RESOURCE_NONE, false, false)
    end
    self:PlaceRelocatedHexOnRing(3);

    -- 4 food settle (ring 1) on fresh is forbidden
    for _, h in pairs(self.RingTables[1].HexRings) do
        if h.Food >= 4 and h.IsFreshWater then
            _Debug("CleanSpawnTile - Found a 4+ food tile on fresh ring 1 "..h:PrintXY())
            self:RelocateHex(1, 3, h);
        end
        if g_RESOURCES_STRATEGICS[h.ResourceType] and h.ResourceType ~= g_RESOURCE_HORSES and h.ResourceType ~= g_RESOURCE_IRON then
            _Debug("CleanSpawnTile - deleted a late strat resource in ring 1, will be replaced ring 4 or 5 ", h.ResourceType)
            self:TerraformHex(h, 0, TerraformType[3], g_RESOURCE_NONE, false, false);
        end
    end

    for _, h in pairs(self.RingTables[2].HexRings) do
        if g_RESOURCES_STRATEGICS[h.ResourceType] and h.ResourceType ~= g_RESOURCE_HORSES and h.ResourceType ~= g_RESOURCE_IRON then
            _Debug("CleanSpawnTile - deleted a late strat resource in ring 2, will be replaced ring 4 or 5 ", h.ResourceType)
            self:TerraformHex(h, 0, TerraformType[3], g_RESOURCE_NONE, false, false);
        end
    end

    -- Get a valid harbor tile if coastal
    local validHarborTile = false;
    local fishRing2OK = 0;
    local harborHex;
    local waterR1 = self.RingTables[1].WATER_EMPTY;
    _Debug("Number of water tiles R1 = "..tostring(#waterR1))
    if #waterR1 > 0 then
        validHarborTile = true;
        waterR1 = GetShuffledCopyOfTable(waterR1);
        harborHex = waterR1[1]
        harborHex:SetTaggedAsMinimum(true);
        _Debug("Harbor tile already found and tagged ", harborHex:PrintXY());
    end
    if validHarborTile == false and #self.RingTables[1].WATER_RF > 0 then
        _Debug("No harbor tile found, try relocate")
        local relocatedHex = self:RelocateRandomHexToNextRing(self.RingTables[1].WATER_RF, 1, 2);
        if relocatedHex ~= nil and relocatedHex.FeatureType == g_FEATURE_NONE and relocatedHex.ResourceType == g_RESOURCE_NONE then
            relocatedHex:SetTaggedAsMinimum(true);
            _Debug("Recheck harbor tile : ", relocatedHex:PrintXY());
        else
            _Debug("ApplyMinimalCoastalTilesERROR - Failed to garantee a harbor tile")
        end
        self:PlaceRelocatedHexOnRing(3);
    end

    -- Prevent spawning on fissure 
    if self.Hex.FeatureType == g_FEATURE_GEOTHERMAL_FISSURE then
        _Debug("CleanSpawnTile - Cleaned geothermal fissure on spawn")
        self:TerraformHex(self.Hex, 0, TerraformType[2], g_FEATURE_NONE, false, false);
    end
    -- Every fissure ring 1 and 2 are set to hills to avoid settling on it turn 1
    for _, h in pairs(self.RingTables[1].HexRings) do
        if h.FeatureType == g_FEATURE_GEOTHERMAL_FISSURE then
            _Debug("CleanSpawnTile - Geothermal fissure Ring 1 to hills", h:PrintXY())
            self:TerraformHex(h, 1, TerraformType[14], 0, false, false);
        end
    end
    for _, h in pairs(self.RingTables[2].HexRings) do
        if h.FeatureType == g_FEATURE_GEOTHERMAL_FISSURE then
            _Debug("CleanSpawnTile - Geothermal fissure Ring 2 to hills", h:PrintXY())
            self:TerraformHex(h, 2, TerraformType[14], 0, false, false);
        end
    end

end

function SpawnBalancing:RemoveRing1MountainsOnRiver()
    for _, h in pairs(self.RingTables[1].HexRings) do
        if (h.IsOnRiver or h.IsCoastal) and h:IsMountain() and h.FeatureType ~= g_FEATURE_VOLCANO then
            _Debug(self.Hex:PrintXY().." - Removed a mountain on river ring 1 "..h:PrintXY())
            self.HexMap:TerraformMountainToHill(h);
            self:UpdateTableDataRing(h, 1, self.RingTables[1].MOUNTAINS);
            _Debug(self.Hex:PrintXY().." - MOUNTAINS "..tostring(1).. " = "..tostring(#self.RingTables[1].MOUNTAINS))
            _Debug(self.Hex:PrintXY().." - EMPTY_TILES "..tostring(1).. " = "..tostring(#self.RingTables[1].EMPTY_TILES))
        end
    end
end


function SpawnBalancing:TerraformRing6Deserts()
    if self.Civ.IsDesertBias then
        _Debug("Desert bias check fresh water");
        -- 1-tile river will be added on coast
        if self.Hex:IsNextToOasis() then
            for _, h in pairs(self.RingTables[1].DESERT) do
                if h.FeatureType == g_FEATURE_OASIS then
                    _Debug("Oasis is already present and tagged as guaranteed");
                    h:SetTaggedAsMinimum(true);
                end
            end
        elseif self.Hex.IsOnRiver == false and self.Hex:IsNextToOasis() == false and self.Hex.IsCoastal == false then
            _Debug("Desert bias need to add oasis");
            for _, h in pairs(self.RingTables[1].DESERT) do
                if self:TerraformHex(h, 1, TerraformType[1], g_TERRAIN_TYPE_DESERT, true, false) then
                    self:TerraformHex(h, 1, TerraformType[2], g_FEATURE_OASIS, true, false)
                    self:TerraformHex(h, 1, TerraformType[3], g_RESOURCE_NONE, true, false)
                    h:SetTaggedAsMinimum(true);
                    _Debug("Added minimum oasis at "..h:PrintXY())
                    break;
                end
            end
        else
            _Debug("Desert bias is on fresh tile");
        end
    else
        local i = 1;
        _Debug("TerraformRing6Deserts");
        self:TerraformHex(self.Hex, i, TerraformType[5], 0, false, false);
        while (i < 7) do
            _Debug(self.Hex:PrintXY().." - DESERT BEFORE "..tostring(i).. " = "..tostring(#self.RingTables[i].DESERT))
            for _, h in pairs(self.RingTables[i].HexRings) do
                if h:IsDesertLand() then
                    if h:IsFloodplains(true) or h:IsMountain() or h.FeatureType == g_FEATURE_OASIS then
                        if self:TerraformHex(h, i, TerraformType[5], 0, false, false) then
                            _Debug("Terraformed a floodplain or mountain desert tile : ", h:PrintXY())
                        end
                    else
                        local rng = TerrainBuilder.GetRandomNumber(100, "Desert terraform");
                        if i <= 2 or rng <= 90 then
                            if self:TerraformHex(h, i, TerraformType[5], 0, false, false) then
                                _Debug("Terraformed a desert tile : ", h:PrintXY())
                            end
                        end
                    end
                end
            end
            _Debug("TerraformRing6Deserts - Ring "..tostring(i).." after update")
            _Debug(self.Hex:PrintXY().." - DESERT AFTER "..tostring(i).. " = "..tostring(#self.RingTables[i].DESERT))
            i = i + 1;

        end

    end
end



-- Starting from empty tile to low yields tiles, try to convert lower tiles to the desired amount of on every ring 1 to 3 2/2 or 3/1
-- Rules : 2 standards yields tiles (food+prod=4) in ring 1, 3 in ring 2, 4 in ring 3
-- If a resource or feature prevents terraforming, it is removed and relocated to the next ring if possible
-- Standard yields balance (avoiding only 1/3 spawns for example) is in BalanceAllCivYields
function SpawnBalancing:ApplyMinimalLandTiles(iMin, iMax)
    -- Apply minimum yields tiles
    for i, _ in pairs(self.RingTables) do
        if i == iMax + 1 then
            return;
        end
        if i >= iMin then
            _Debug("ApplyMinimalLandTiles Start Ring ", i);
            -- Apply relocated resources from previous ring
            self:PlaceRelocatedHexOnRing(i);
            -- Formula used to count the number of standard yields tiles needed in a given ring around the spawning hex
            local minimumStandardTiles = i;
            if i ~= 2 then
                minimumStandardTiles = i + 1;
            end
            local minimumNb2f2p = 0;
            if i <= 2 then
                minimumNb2f2p = i;
            end
           
            local tileToUp = minimumStandardTiles - #self.RingTables[i].STANDARD_YIELD_TILES - #self.RingTables[i].HIGH_YIELD_TILES - #self.RingTables[i].HIGH_EXTRA_YIELDS;
            _Debug("MinimalTileV2 Ring ", i, " : tileToUp = ", tileToUp);
            _Debug("MinimalTileV2 Ring ", i, " : Empty = ", #self.RingTables[i].EMPTY_TILES);
            _Debug("MinimalTileV2 Ring ", i, " : Low = ",#self.RingTables[i].LOW_YIELD_TILES);
              -- Try to apply randomly desired number of standard yield tiles in ring i
            while tileToUp > 0 do
                local nb22inRing = #self:Find22TilesInRing(i);
                -- Have 1 2/2 tile in ring 1 and 2
                local garanteed22 = nb22inRing < i and i <= 2;
                _Debug("Garanteed 2/2 in ring : ", i, nb22inRing, garanteed22, minimumStandardTiles);
                local terraformedHex = self:TerraformRandomInRing(i, TerraformType[4], 0, false, false, garanteed22);
                if terraformedHex ~= nil then
                    _Debug("Added 4yields tile : ", terraformedHex:PrintXY());
                    tileToUp = tileToUp - 1;
                    -- Fixed the 4tiles in ring 1 and 2/2 in ring 2 
                    if garanteed22 then
                        _Debug("Garanteed 2/2 : ", terraformedHex:PrintXY());
                        terraformedHex:SetTaggedAsMinimum(true);
                    end
                else
                    _Debug("Could not terraform tile to up in ring ", i);
                    break;
                end
            end

            -- If there is enough standard tiles but there is 2/2 missing, terraform 4y to 2/2 or add one
            local nb22LeftToUp = math.max(0, minimumNb2f2p - #self:Find22TilesInRing(i));
            -- On ring 2, check if there is at least 3 2/2 on ring 1 and 2 combined
            if i == 2 then
                local total22R1R2 = #self:Find22TilesInRing(1) + #self:Find22TilesInRing(2);
                _Debug("R 2 total22R1R2 : ", total22R1R2)
                nb22LeftToUp = math.max(0, self.Min22TilesInRing2 - total22R1R2);
            end
            _Debug("nb22LeftToUp : ", nb22LeftToUp)
            while nb22LeftToUp > 0 do
                local stdTilesNon22 = GetShuffledCopyOfTable(self:FindNon22Tiles4YInRing(i)) 
                _Debug("stdTilesNon22 : ", #stdTilesNon22)
                local hexFound = false;
                for _, hex in pairs(stdTilesNon22) do
                    if self:TerraformHex(hex, i, TerraformType[16], 0, false, true) then
                        _Debug("nb22LeftToUp found a non 22 to change to : ", hex:PrintXY())
                        hex:SetTaggedAsMinimum(true);
                        hexFound = true;
                        break;
                    else 
                        _Debug("hex is non available to change : ", hex:PrintXY())
                    end
                end
                -- Can not change existing standard tiles then add a 2/2 (use case : there is 3 standard tiles ring 2, turtle+food+2/2 all tagged, one 2/2 missing)
                if hexFound == false then
                    local terraformedHex = self:TerraformRandomInRing(i, TerraformType[4], 0, false, false, true);
                    if terraformedHex ~= nil then
                        _Debug("Added additional 2/2 tile : ", terraformedHex:PrintXY());
                        terraformedHex:SetTaggedAsMinimum(true);
                        nb22LeftToUp = math.max(0, minimumNb2f2p - #self:Find22TilesInRing(i));
                    else 
                        print("ApplyMinimalLandTiles - Impossible to terraform to meet 22 minimum threshold", i, self.Civ.CivilizationLeader);
                        nb22LeftToUp = 0;
                    end
                end
                _Debug("nb22LeftToUp update : ", nb22LeftToUp)
            end
            

            -- If left to update, it means there were obstacle to the terraformation (existing resources or features) if possible, relocate them in next ring
            while tileToUp > 0 and i < self.MaxRing do
                _Debug("MinimalTileV2 Ring ", i, " : leftToUp = ", tileToUp);
                local nextIndex = i + 1;
                local relocatedHex = self:RelocateRandomHexToNextRing(self.RingTables[i].LOW_YIELD_TILES, i, nextIndex)
                if relocatedHex ~= nil and self:TerraformHex(relocatedHex, i, TerraformType[4], 0, false, false) then
                    tileToUp = tileToUp - 1;
                else
                    _Debug("Can't relocate to meet requirements") --desert/tundra civ, see how to deal
                    -- Check if we can terraform mountains to meet requirements (mostly because of floodplains that we do not terraform)
                    if #self.RingTables[i].MOUNTAINS > 0 then
                        local listMountains = self.RingTables[i].MOUNTAINS;
                        if #listMountains > 1 then
                            listMountains = GetShuffledCopyOfTable(listMountains);
                        end
                        local mountainHex = listMountains[1];
                        if mountainHex ~= nil and self:TerraformHex(mountainHex, i, TerraformType[10], 0, false, false) then
                            _Debug("Mountain hex to terraform to hill : ", mountainHex:PrintXY())
                            local terraformedHex = self:TerraformRandomInRing(i, TerraformType[4], 0, false, false, false)
                            if terraformedHex ~= nil then
                                _Debug("Successful mountain terraform into 22")
                                tileToUp = tileToUp - 1;
                            else
                                _Debug("ApplyMinimalLandTiles ERROR - Unable to meet minimal land tiles requirements")
                                tileToUp = 0;
                                break;
                            end
                        end
                    else
                        -- Other case where we need to terraform something to meet minimal (lakes ?)
                        break;
                    end
                end
            end
            -- Tag one 2/2 tiles on each ring 1 and 2 as minimaltiles to avoid further terraforming
            if i <= 2 then
                local found22tiles = self:Find22TilesInRing(i);
                local nbTagged22 = 0;
                found22tiles = GetShuffledCopyOfTable(found22tiles);
                for _, h in ipairs(found22tiles) do
                    if nbTagged22 < 1 then
                        h:SetTaggedAsMinimum(true);
                        nbTagged22 = nbTagged22 + 1;
                    else
                        break
                    end
                end
                -- On ring 1 only, tag a second 4yields  
                if i == 1 then
                    local stdTilesR1 = {};
                    AddToTable(stdTilesR1, self.RingTables[1].STANDARD_YIELD_TILES);
                    AddToTable(stdTilesR1, self.RingTables[1].HIGH_YIELD_TILES);
                    AddToTable(stdTilesR1, self.RingTables[1].HIGH_EXTRA_YIELDS);
                    stdTilesR1 = GetShuffledCopyOfTable(stdTilesR1);
                    -- Verify if there is already 2x 4+ yields tagged as minimum (from lux or high food tile)
                    local nbTagged4yields = 0
                    local untaggedStdTiles = {};
                    for _, h in ipairs(stdTilesR1) do
                        if h.IsTaggedAsMinimum == false then
                            table.insert(untaggedStdTiles, h);
                        else 
                            nbTagged4yields = nbTagged4yields + 1;
                        end
                    end
                    -- One 2/2 should have been already tagged before
                    if nbTagged4yields < 2 then
                        for _, h in ipairs(untaggedStdTiles) do
                            _Debug("Extra 4yields guaranteed : ", h:PrintXY());
                            h:SetTaggedAsMinimum(true);
                            break;
                        end
                    end
                end
            end
        end
    end
    _Debug("ApplyMinimalLandTiles DONE")
end

function SpawnBalancing:Find22TilesInRing(i)
    local list22 = {};
    local listStdPlusTiles = {};
    AddToTable(listStdPlusTiles, self.RingTables[i].STANDARD_YIELD_TILES);
    AddToTable(listStdPlusTiles, self.RingTables[i].HIGH_YIELD_TILES);
    AddToTable(listStdPlusTiles, self.RingTables[i].HIGH_EXTRA_YIELDS);
    for _, h in ipairs(listStdPlusTiles) do
        if IsTundraLand(self.Hex.TerrainType) then
            if self:GetHexBaseFood(h) >= 2 and self:GetHexBaseProd(h) >= 2
                    and (i > 1 or (i == 1 and h.ResourceType == g_RESOURCE_DEER)) then
                table.insert(list22, h);
            end
        elseif self:GetHexBaseFood(h) >= 2 and self:GetHexBaseProd(h) >= 2 then
            table.insert(list22, h);
        end
    end
    return list22;
end

-- Opposite of Find22TilesInRing, look for non 2/2 4yields standard tiles in ring
function SpawnBalancing:FindNon22Tiles4YInRing(i)
    local listNon22 = {};
    local listStdPlusTiles = {};
    AddToTable(listStdPlusTiles, self.RingTables[i].STANDARD_YIELD_TILES);
    AddToTable(listStdPlusTiles, self.RingTables[i].HIGH_YIELD_TILES);
    AddToTable(listStdPlusTiles, self.RingTables[i].HIGH_EXTRA_YIELDS);
    for _, h in ipairs(listStdPlusTiles) do
        if self:GetHexBaseFood(h) < 2 or self:GetHexBaseProd(h) < 2 then
            table.insert(listNon22, h);
        end
    end
    return listNon22;
end

function SpawnBalancing:AddHighYieldFromStandard()
    _Debug("AddHighYieldFromStandard enter");
    local innerRing = {}
    AddToTable(innerRing, self.RingTables[1].HIGH_YIELD_TILES);
    AddToTable(innerRing, self.RingTables[2].HIGH_YIELD_TILES);
    AddToTable(innerRing, self.RingTables[1].HIGH_EXTRA_YIELDS);
    AddToTable(innerRing, self.RingTables[2].HIGH_EXTRA_YIELDS);
    if #innerRing >= self.MaxHighYieldInnerRingThreshold then
        _Debug("AddHighYieldFromStandard already is at max high yields threshold");
        return nil;
    end
    local innerRingStandard = {}
    AddToTable(innerRingStandard, self.RingTables[1].STANDARD_YIELD_TILES);
    AddToTable(innerRingStandard, self.RingTables[2].STANDARD_YIELD_TILES);
    innerRingStandard = GetShuffledCopyOfTable(innerRingStandard);
    for _, hex in ipairs(innerRingStandard) do
        local ringHex = 2;
        if Contains(self.RingTables[1].HexRings, hex) then
            ringHex = 1;
        end
        -- Temp change hex not tagged as minimum
        local wasTagged = false;
        if hex.IsTaggedAsMinimum then
            hex:SetTaggedAsMinimum(false);
            wasTagged = true;
        end
        local canAddLux = false
        if self.InnerRingLuxCount < self.MaxLuxInnerRingThreshold then
            canAddLux = true;
        end    
        -- Try to terraform a standard tagged tile
        if self:TerraformHex(hex, ringHex, TerraformType[13], true, canAddLux) then
            _Debug("AddHighYieldFromStandard added high yield on ", hex:PrintXY());
            if wasTagged then
                hex:SetTaggedAsMinimum(true);
            end
            return hex;
        elseif wasTagged then
            hex:SetTaggedAsMinimum(true);            
        end
    end
    return nil;
end

function SpawnBalancing:GaranteedStandardHighFoodInnerRing()
    _Debug("GaranteedStandardHighFoodInnerRing");
    local innerRing = {}
    AddToTable(innerRing, self.RingTables[1].STANDARD_YIELD_TILES);
    AddToTable(innerRing, self.RingTables[2].STANDARD_YIELD_TILES);
    AddToTable(innerRing, self.RingTables[1].HIGH_EXTRA_YIELDS);
    AddToTable(innerRing, self.RingTables[2].HIGH_EXTRA_YIELDS);
    AddToTable(innerRing, self.RingTables[1].HIGH_YIELD_TILES);
    AddToTable(innerRing, self.RingTables[2].HIGH_YIELD_TILES);
    AddToTable(innerRing, self.RingTables[1].WATER_FISH_OR_LUX);
    AddToTable(innerRing, self.RingTables[2].WATER_FISH_OR_LUX);
    if #innerRing > 1 then
        for _, h in ipairs(innerRing) do
            -- Always use GetHexBaseFood to consider tundra tiles correctly
            if (self:GetHexBaseFood(h) == 3 and self:GetHexBaseProd(h) >= 1) or (self:GetHexBaseFood(h) == 4) then
                _Debug("GaranteedStandardHighFoodInnerRing Already found");
                h:SetTaggedAsMinimum(true);
                return true;
            end
        end
    end
    -- Not found - try create one on ring 2 on low tile
    local ring2 = {}
    AddToTable(ring2, self.RingTables[2].EMPTY_TILES);
    AddToTable(ring2, self.RingTables[2].LOW_YIELD_TILES);
    ring2 = GetShuffledCopyOfTable(ring2);
    for _, h in ipairs(ring2) do
        if self:TerraformHex(h, 2, TerraformType[12], 0, false, false) then
            _Debug("GaranteedStandardHighFoodInnerRing Added in ring 2");
            h:SetTaggedAsMinimum(true);
            return true;
        end
    end
    local ring1 = {}
    AddToTable(ring1, self.RingTables[1].EMPTY_TILES);
    AddToTable(ring1, self.RingTables[1].LOW_YIELD_TILES);
    ring1 = GetShuffledCopyOfTable(ring1);
    for _, h in ipairs(innerRing) do
        if self:TerraformHex(h, 1, TerraformType[12], 0, false, false) then
            _Debug("GaranteedStandardHighFoodInnerRing Added in ring 1");
            h:SetTaggedAsMinimum(true);
            return true;
        end
    end
    _Debug("GaranteedStandardHighFoodInnerRingERROR - Could not add 31 or 4f tile  ring 1");
    return false;
end

-- Rules : Check if harbor tile, add a fish ring 2 if none
function SpawnBalancing:ApplyMinimalCoastalTiles()
    -- Check if harbor tile, else clean and relocate
    if self.Hex.IsCoastal == false then
        -- Check if one tile off coast 
        if self.HexMap:IsHexRing2FromCoast(self.Hex) then
            -- Check number of resources in ring 2+3
            local nbSeaResources = 0;
            for _, h in pairs(self.RingTables[2].WATER_RF) do
                if g_RESOURCES_FISHINGBOAT_LIST[h.ResourceType] and h.ResourceType ~= g_RESOURCE_CRABS then
                    nbSeaResources = nbSeaResources + 1;     
                end
            end
            for _, h in pairs(self.RingTables[3].WATER_RF) do
                if g_RESOURCES_FISHINGBOAT_LIST[h.ResourceType] and h.ResourceType ~= g_RESOURCE_CRABS then
                    nbSeaResources = nbSeaResources + 1;
                    
                end
            end
            -- Add a fish on ring 3 on empty coast tile
            while #self.RingTables[3].WATER_EMPTY > 0 and nbSeaResources < 2 do 
                local newfish = self:TerraformRandomInRing(3, TerraformType[3], g_RESOURCE_FISH, false, false, false);
                nbSeaResources = nbSeaResources + 1;
                print("IsHexRing2FromCoast New fish ring 3 = ", self.Civ.CivilizationLeader, nbSeaResources);
                _Debug(self.Civ.CivilizationLeader, newfish:PrintXY(), nbSeaResources)
            end
        end

        return;
    end

    _Debug("Coastal start "..self.Civ.CivilizationLeader)
    local resourceRing3OK = 0;
    -- 2) Adding river
    if self.Civ.IsSaltyBias == false then
        self.HexMap:AddCoastalRiver(self.Hex)
    end

    -- 3) Changing ocean to coast in all round 2 tiles 
    _Debug("Number of water tiles R2 = "..tostring(#self.RingTables[2].WATER))
    for _, h in pairs(self.RingTables[2].WATER) do
        if h.TerrainType == g_TERRAIN_TYPE_OCEAN then
            self:TerraformHex(h, 2, TerraformType[1], g_TERRAIN_TYPE_COAST, false, false)
        end
        if h.FeatureType == g_FEATURE_ICE then
            self:TerraformHex(h, 2, TerraformType[2], g_FEATURE_NONE, true, false)
        end
    end
    for _, h in pairs(self.RingTables[1].WATER) do
        if h.FeatureType == g_FEATURE_ICE then
            self:TerraformHex(h, 1, TerraformType[2], g_FEATURE_NONE, true, false)
        end
    end
    -- Clean ice up to ring 4
    for _, h in pairs(self.RingTables[3].WATER) do
        if h.FeatureType == g_FEATURE_ICE then
            self:TerraformHex(h, 3, TerraformType[2], g_FEATURE_NONE, true, false)
        end
    end
    for _, h in pairs(self.RingTables[4].WATER) do
        if h.FeatureType == g_FEATURE_ICE then
            self:TerraformHex(h, 4, TerraformType[2], g_FEATURE_NONE, true, false)
        end
    end

    -- 4) At least one fish reef or turtle ring 2
    local foundFishR2 = false;
    if #self.RingTables[2].WATER_RF > 0 then
        for _, h in pairs(self.RingTables[2].WATER_RF) do
            if h.FeatureType == g_FEATURE_REEF and (h.ResourceType == g_RESOURCE_FISH or h.ResourceType == g_RESOURCE_TURTLES) then
                _Debug("Found a fishreef or turtles in ring 2 for "..self.Civ.CivilizationLeader)
                foundFishR2 = true;
                h:SetTaggedAsMinimum(true);
            end
        end
    end

    if foundFishR2 == false then
        local listWater = {};
        local hex;
        if #self.RingTables[2].WATER_EMPTY > 0 then
            listWater = self.RingTables[2].WATER_EMPTY;
            print("Number of empty water tiles r2 = ", #listWater, self.Civ.CivilizationLeader)
        elseif #self.RingTables[2].WATER_RF > 0 then
            listWater = self.RingTables[2].WATER_RF;
            _Debug("Number of res or feat water tiles r2 = ", #listWater)
            -- replace a random ring, do we need to relocate or adjust later anyway ?
            hex = self:RelocateRandomHexToNextRing(self.RingTables[2].WATER_RF, 2, 3)
            if hex ~= nil then
                _Debug("Need to add a fish in "..hex:PrintXY().." in ring 2 for "..self.Civ.CivilizationLeader)
                self:TerraformHex(hex, 2, TerraformType[3], g_RESOURCE_FISH, false, false);
            end
        end
        if #listWater > 1 then
            listWater = GetShuffledCopyOfTable(listWater);
        end
        -- New condition : always have a empty water ring 2
        if #self.RingTables[2].WATER_EMPTY > 0 then
            local listWater = self.RingTables[2].WATER_EMPTY;
            if #listWater > 1 then
                listWater = GetShuffledCopyOfTable(listWater);
            end
        else
            print("WATER_EMPTY r2 NO", self.Civ.CivilizationLeader)
        end

        hex = hex or listWater[1]; -- take previously selected hex if relocated, else just take random empty
        _Debug("Try to add ", tostring(TerraformType[2]), " id = ", tostring(g_FEATURE_REEF), " to ", hex)
        self:TerraformHex(hex, 2, TerraformType[2], g_FEATURE_REEF, true, false);
        local rng = TerrainBuilder.GetRandomNumber(100, "Ring2 Turtle or Fish");
        local isTurtlesOnMap = Contains(self.HexMap.LuxTable[-1], g_RESOURCE_TURTLES);
        _Debug("Detected turtles available = ", isTurtlesOnMap, rng);
        if isTurtlesOnMap and rng <= 50 and self.InnerRingLuxCount < self.MaxLuxInnerRingThreshold then
            _Debug("Added turtle reef to ", hex:PrintXY())
            self:TerraformHex(hex, 2, TerraformType[3], g_RESOURCE_TURTLES, true, false);
        else
            _Debug("Added fish reef to ", hex:PrintXY())
            self:TerraformHex(hex, 2, TerraformType[3], g_RESOURCE_FISH, true, false);
        end
        hex:SetTaggedAsMinimum(true);
    end
    -- 5) 50% to change ocean to coast on ring 3
    for _, h in pairs(self.RingTables[3].WATER) do
        if h.TerrainType == g_TERRAIN_TYPE_OCEAN then
            local rng = TerrainBuilder.GetRandomNumber(100, "Ring3 Ocean to coast");
            if rng <= 50 then
                self:TerraformHex(h, 3, TerraformType[1], g_TERRAIN_TYPE_COAST, false, false);
            end
        end
        if g_RESOURCES_FISHINGBOAT_LIST[h.ResourceType] then
            resourceRing3OK = resourceRing3OK + 1;
        end
    end
    if fishRing2OK == 1 and resourceRing3OK == 0 then
        if self:TerraformInRingsOrder(2, 3, TerraformType[3], g_RESOURCE_FISH, false, true, false) then
            _Debug("Added a fish ring 2 or 3 ")
        end
    end

    self:GetCoastalScoreHex();
    _Debug("ApplyMinimalCoastalTiles DONE")
end

function SpawnBalancing:CanAddToCoastalScore(testScore)
    if self.AimedCoastalScore > 0 then
        if testScore > 0 then
            return self.CoastalScore + testScore < self.AimedCoastalScore + CoastalScoring.COASTAL_MARGIN
        elseif testScore < 0 then
            return self.CoastalScore + testScore > self.AimedCoastalScore - CoastalScoring.COASTAL_MARGIN;
        end
    end
    return false;
end

-- For balancing, we consider tundra tiles as grassland so we add +1 food on tundra bias
function SpawnBalancing:GetHexBaseFood(hex)
    local bonusFood = 0;
    if hex:IsTundraLand() or hex:IsDesertLand() then
        bonusFood = 1;
    end
    return hex.Food + bonusFood;
end

function SpawnBalancing:GetHexBaseProd(hex)
    local bonusProd = 0;
    --if hex:IsDesertLand() then
    --    bonusProd = 1;
    --end
    -- See if needed
    return hex.Prod + bonusProd;
end

function SpawnBalancing:GetSpawnBaseFood(hex)
    local baseFood = 2;
    local bonusFood = 0;
    return baseFood + bonusFood;
end

function SpawnBalancing:GetSpawnBaseProd(hex)
    local baseProd = 1;
    local bonusProd = 0;
    local isBonusFoodSettle = (hex.Food == 3 and hex.TerrainType == g_TERRAIN_TYPE_GRASS and hex.Feature == g_FEATURE_NONE)
            or (hex.Food == 4  and hex.TerrainType == g_TERRAIN_TYPE_GRASS and hex.Feature ~= g_FEATURE_NONE);
    if hex.TerrainType == g_TERRAIN_TYPE_PLAINS_HILLS or (self.IsBCYActivated and isBonusFoodSettle == false) then
        bonusProd = 1;
    end
    return baseProd + bonusProd;
end

function SpawnBalancing:GetFoodDiff(hex1, hex2)
    return self:GetHexBaseFood(hex1) + self:GetHexBaseFood(hex2) + self:GetSpawnBaseFood(self.Hex) - 6;
end

function SpawnBalancing:GetProdDiff(hex1, hex2)
    return self:GetHexBaseProd(hex1) + self:GetHexBaseProd(hex2) + self:GetSpawnBaseProd(self.Hex) - 5;
end


-- Rules : Minimum of 4+ yield tiles to work in ring 1 + a minimum of 4food + 4prod on 2 tiles ring 1
function SpawnBalancing:CheckMinimumWorkable()
    _Debug("Enter CheckMinimumWorkable")
    local combinaisonList = {}
    for _, mainHex in pairs(self.RingTables[1].WORKABLE) do
        -- Take standard and high yields
        if self:GetHexBaseFood(mainHex) + self:GetHexBaseProd(mainHex) >= 4 then
            for _, secondHex in pairs(self.RingTables[1].HexRings) do
                if mainHex ~= secondHex and secondHex:IsImpassable() == false and secondHex.Food > 0 then
                    local combinaisonTable = {};
                    combinaisonTable.FoodDiff = self:GetFoodDiff(mainHex, secondHex);
                    combinaisonTable.ProdDiff = self:GetProdDiff(mainHex, secondHex);
                    combinaisonTable.Hex1 = mainHex;
                    combinaisonTable.Hex2 = secondHex;
                    table.insert(combinaisonList, combinaisonTable);
                    _Debug("CheckMinimumWorkable - test "..mainHex:PrintXY().." + "..secondHex:PrintXY().." - Diff food/prod = "..tostring(combinaisonTable.FoodDiff).." "..tostring(combinaisonTable.ProdDiff))
                    -- Total valid == 4 food and f prod OR 5 food 3 prod (3/1 + 2/2)
                    local isValid1 = combinaisonTable.FoodDiff >= 0 and combinaisonTable.ProdDiff >= 0 and combinaisonTable.FoodDiff + combinaisonTable.ProdDiff >= 0;
                    local isValid2 = combinaisonTable.FoodDiff == 1 and combinaisonTable.ProdDiff == -1 and combinaisonTable.FoodDiff + combinaisonTable.ProdDiff >= 0;
                    if isValid1 or isValid2 then
                        _Debug("CheckMinimumWorkable - requirement checked")
                        return true;
                    end
                end
            end
        end
    end
    if #combinaisonList == 0 then
        _Debug("No combinaison of workable tiles")
        return
    end
    -- No good combinaison => terraform needed
    table.sort(combinaisonList,
        function(a, b)
            -- Avoid bug where a or b is nil for unknown reasons
            if a == nil then
                return false
            elseif b == nil then
                return true
            else
                local aDiff = a.FoodDiff + a.ProdDiff
                local bDiff = b.FoodDiff + b.ProdDiff
                return aDiff > bDiff
            end
        end
    )
    local minimumFoodCheckOK = false;
    local minimumProdCheckOK = false;
    -- Avoid 1/3 + 3/0 scenario where it can be changed to 3/0 + 1/4 - not optimal
    for _, comb in pairs(combinaisonList) do
        _Debug("Selected combinaison : "..comb.Hex1:PrintXY().." + "..comb.Hex2:PrintXY());
        if (comb.Hex2.ResourceType == g_RESOURCE_NONE and comb.Hex2.FeatureType == g_FEATURE_NONE) or (comb.Hex2.Prod == 0 and comb.Hex2.Food < 4 and g_RESOURCES_STRATEGICS_EARLY[comb.Hex2.ResourceType] == nil) then
            _Debug("Need to update empty tile to 22, trying to relocate")
            if self:RelocateHex(1, 3, comb.Hex2) and self:TerraformHex(comb.Hex2, 1, TerraformType[4], 0, false, false) then
                _Debug("Updated ", comb.Hex2:PrintXY(), " trying to relocate on ring 3 initial tile")
                self:PlaceRelocatedHexOnRing(3);
                comb.FoodDiff = self:GetFoodDiff(comb.Hex1, comb.Hex2);
                comb.ProdDiff = self:GetProdDiff(comb.Hex1, comb.Hex2);
                _Debug("After 22 test ",comb.FoodDiff, " ", comb.ProdDiff, " CanRemoveProd = ", canRemoveProd, comb.Hex1:PrintXY(), comb.Hex2:PrintXY())
            end
        end
        local maxLoopTest = 10;
        local loop = 0
        if math.abs(comb.FoodDiff + comb.ProdDiff) >= 2 then
            if g_RESOURCES_BONUS_LIST[comb.Hex2.ResourceType] then
                self:TerraformHex(comb.Hex2, 1, TerraformType[99], 0, false, false);
                self:TerraformHex(comb.Hex2, 1, TerraformType[4], 0, false, false);
            else
                _Debug("Combinaison ERROR Failed to add 22 on empty tile")
            end
        end
        while comb.FoodDiff < 0 and loop <= maxLoopTest do
            local canRemoveProd = comb.ProdDiff >= 1
            _Debug("Combinaison test ",comb.FoodDiff, " ", comb.ProdDiff, " CanRemoveProd = ", canRemoveProd, comb.Hex1:PrintXY(), comb.Hex2:PrintXY())
            local rng = TerrainBuilder.GetRandomNumber(100, "Random");
            -- Little rng to check the highest tile first
            if rng <= 20 then
                if self:TerraformHex(comb.Hex1, 1, TerraformType[6], 0, canRemoveProd) then
                    comb.FoodDiff = self:GetFoodDiff(comb.Hex1, comb.Hex2);
                    comb.ProdDiff = self:GetProdDiff(comb.Hex1, comb.Hex2);
                    _Debug("Added 1 food in Hex1 "..tostring(comb.FoodDiff).." "..tostring(comb.ProdDiff))
                elseif self:TerraformHex(comb.Hex2, 1, TerraformType[6], 0, canRemoveProd) then
                    comb.FoodDiff = self:GetFoodDiff(comb.Hex1, comb.Hex2);
                    comb.ProdDiff = self:GetProdDiff(comb.Hex1, comb.Hex2);
                    _Debug("Added 1 food in Hex2 "..tostring(comb.FoodDiff).." "..tostring(comb.ProdDiff))
                end
            else
                if self:TerraformHex(comb.Hex2, 1, TerraformType[6], 0, canRemoveProd) then
                    comb.FoodDiff = self:GetFoodDiff(comb.Hex1, comb.Hex2);
                    comb.ProdDiff = self:GetProdDiff(comb.Hex1, comb.Hex2);
                    _Debug("Added 1 food in Hex2 "..tostring(comb.FoodDiff).." "..tostring(comb.ProdDiff))
                elseif self:TerraformHex(comb.Hex1, 1, TerraformType[6], 0, canRemoveProd) then
                    comb.FoodDiff = self:GetFoodDiff(comb.Hex1, comb.Hex2);
                    comb.ProdDiff = self:GetProdDiff(comb.Hex1, comb.Hex2);
                    _Debug("Added 1 food in Hex1 "..tostring(comb.FoodDiff).." "..tostring(comb.ProdDiff))
                end
            end
            loop = loop + 1;
        end
        if comb.FoodDiff >= 0 then
            minimumFoodCheckOK = true;
        end
        loop = 0;
        while comb.ProdDiff < 0 and loop <= maxLoopTest do
            local canRemoveFood = comb.FoodDiff >= 1
            _Debug("Combinaison test ",comb.FoodDiff, " ", comb.ProdDiff, " canRemoveFood = ", canRemoveFood, comb.Hex1:PrintXY(), comb.Hex2:PrintXY())
            local rng = TerrainBuilder.GetRandomNumber(100, "Random");
            -- Little rng to check the highest tile first
            if rng <= 20 then
                if self:TerraformHex(comb.Hex1, 1, TerraformType[8], 0, canRemoveFood, false) then
                    comb.FoodDiff = self:GetFoodDiff(comb.Hex1, comb.Hex2);
                    comb.ProdDiff = self:GetProdDiff(comb.Hex1, comb.Hex2);
                    _Debug("Added 1 prod in Hex1 "..tostring(comb.FoodDiff).." "..tostring(comb.ProdDiff))
                elseif self:TerraformHex(comb.Hex2, 1, TerraformType[8], 0, canRemoveFood, false) then
                    comb.FoodDiff = self:GetFoodDiff(comb.Hex1, comb.Hex2);
                    comb.ProdDiff = self:GetProdDiff(comb.Hex1, comb.Hex2);
                    _Debug("Added 1 prod in Hex2 "..tostring(comb.FoodDiff).." "..tostring(comb.ProdDiff))
                end
            else
                if self:TerraformHex(comb.Hex2, 1, TerraformType[8], 0, canRemoveFood, false) then
                    comb.FoodDiff = self:GetFoodDiff(comb.Hex1, comb.Hex2);
                    comb.ProdDiff = self:GetProdDiff(comb.Hex1, comb.Hex2);
                    _Debug("Added 1 prod in Hex2 "..tostring(comb.FoodDiff).." "..tostring(comb.ProdDiff))
                elseif self:TerraformHex(comb.Hex1, 1, TerraformType[8], 0, canRemoveFood, false) then
                    comb.FoodDiff = self:GetFoodDiff(comb.Hex1, comb.Hex2);
                    comb.ProdDiff = self:GetProdDiff(comb.Hex1, comb.Hex2);
                    _Debug("Added 1 prod in Hex1 "..tostring(comb.FoodDiff).." "..tostring(comb.ProdDiff))
                end
            end
            loop = loop + 1;
        end
        if comb.ProdDiff >= 0 then
            minimumProdCheckOK = true;
        end
        if minimumFoodCheckOK and minimumProdCheckOK then
            _Debug("CheckMinimumWorkable DONE")
            return true;
        end
    end
    _Debug("CheckMinimumWorkableERROR - Unable to make terraform, check tiles in ring 1")
    return false;
end

function SpawnBalancing:HillsMinimumCheck()
    _Debug("HillsMinimumCheck enter ", self.Civ.CivilizationLeader)
    local globalHillPercent = self.HexMap:GetGlobalHillPercent();
    local passableLand, passableLandCount, hillsTiles, hillsCount, hillPercentRing6 = self.HexMap:GetHillPercentInRange(self.Hex, 6);
    local hillsGoal = math.floor(globalHillPercent * passableLandCount);
    
    _Debug("HillsMinimumCheck - globalHillPercent = ", globalHillPercent, " hillPercentRing6= ", hillPercentRing6, " hillsCount= ",  hillsCount, " hillsGoal= ", hillsGoal)
    local hillsToAdd = math.max(0, hillsGoal - hillsCount)
    local ring6ValidTiles = {};
    if hillsToAdd == 0 then
        _Debug("HillsMinimumCheck - Nothing to add ", hillsToAdd)
        return;
    end
    _Debug("HillsMinimumCheck - To add :", hillsToAdd)
    for _, h in pairs(self.HexMap:GetAllHexInRing(self.Hex, 6)) do
        if h:IsImpassable() == false and IsFlat(h.TerrainType) and h.ResourceType == g_RESOURCE_NONE 
            and (h.FeatureType == g_FEATURE_NONE or h.FeatureType == g_FEATURE_FOREST or h.FeatureType == g_FEATURE_JUNGLE) then
             table.insert(ring6ValidTiles, h);
        end
    end
    ring6ValidTiles = GetShuffledCopyOfTable(ring6ValidTiles);
    _Debug("HillsMinimumCheck nb of tiles with possible hills : ", #ring6ValidTiles)
    for _ , h in pairs(ring6ValidTiles) do
        if hillsToAdd > 0 and self:Terraform(h, TerraformType[14], 0, false, false) then
            _Debug("HillsMinimumCheck Added hills on : ", h:PrintXY())
            hillsToAdd = hillsToAdd - 1;
        end
    end
end



function SpawnBalancing:CheckLuxThreshold()
    self.InnerRingLuxCount = 0;
    self.OuterRingLuxCount = 0;
    local i = 1;
    print("CheckLuxThreshold START", self.Civ.CivilizationLeader)
    while i <= 6 do
        for _,h in pairs(self.RingTables[i].HexRings) do
            if h:HasLux()  then
                print("CheckLuxThreshold found a lux on ", h:PrintXY(), i);
                if i <= 3 then
                    self.InnerRingLuxCount = self.InnerRingLuxCount + 1;
                    if (self.InnerRingLuxCount > self.MaxLuxInnerRingThreshold) and h.IsTaggedAsMinimum == false then
                        self:TerraformHex(h, i, TerraformType[3], g_RESOURCE_NONE, false, false);
                        print("CheckLuxThreshold deleted a lux on ", h:PrintXY(), " Ring = ", i)
                    else
                        h:SetTaggedAsMinimum(true);
                    end
                else
                    self.OuterRingLuxCount = self.OuterRingLuxCount + 1;
                    if self.OuterRingLuxCount > self.MaxLuxOuterRingThreshold then
                        self:TerraformHex(h, i, TerraformType[3], g_RESOURCE_NONE, false, false);
                        print("CheckLuxThreshold deleted a lux on ", h:PrintXY(), " Ring = ", i)
                    end
                end
            end
        end
        i = i + 1;
    end
    print("CheckLuxThreshold innerRing = ", self.InnerRingLuxCount, " outerRing = ", self.OuterRingLuxCount, " Threshold = ", self.InnerRingLuxCount < self.MaxLuxInnerRingThreshold)
    while self.InnerRingLuxCount < self.MinLuxInnerRingThreshold do
        local randomHexLux = self:TerraformInRingsRandomOrder(2, 3, TerraformType[11], 0, false, false, false);
        if randomHexLux ~= nil then
            print("CheckLuxThreshold - Added lux ");
            self.InnerRingLuxCount = self.InnerRingLuxCount + 1;
            randomHexLux:SetTaggedAsMinimum(true);
        else
            print("CheckLuxThresholdERROR - Could not add lux in ring 1-3 for ", self.Civ.CivilizationLeader)
            local randomHexLuxForced = self:TerraformInRingsRandomOrder(2, 3, TerraformType[11], 0, false, true, false);
            if randomHexLuxForced ~= nil then
                print("CheckLuxThresholdERROR - Forced success ", self.Civ.CivilizationLeader)
                self.InnerRingLuxCount = self.InnerRingLuxCount + 1;
                randomHexLuxForced:SetTaggedAsMinimum(true);
            else
                print("CheckLuxThresholdERROR - Forced failed ", self.Civ.CivilizationLeader)
                self.InnerRingLuxCount = self.MinLuxInnerRingThreshold;
            end
        end
    end
    while self.OuterRingLuxCount < self.MinLuxOuterRingThreshold do
        local randomHexLux = self:TerraformInRingsRandomOrder(4, 6, TerraformType[11], 0, false, false, false);
        if randomHexLux ~= nil then
            print("CheckLuxThreshold - Added lux ");
            self.OuterRingLuxCount = self.OuterRingLuxCount + 1;
            randomHexLux:SetTaggedAsMinimum(true);
        else
            print("CheckLuxThresholdERROR - Could not add lux in ring 4-6 for ", self.Civ.CivilizationLeader)
            self.OuterRingLuxCount = self.MinLuxOuterRingThreshold;
        end
    end
    print("CheckLuxThreshold DONE", self.Civ.CivilizationLeader)
end


function SpawnBalancing:CheckInnerRingHighYieldsThreshold()
    _Debug("CheckInnerRingHighYieldsThreshold enter");
    local ring1HighYields = {};
    local ring2HighYields = {};
    local ringModifiedTiles = {};
    AddToTable(ring1HighYields, self.RingTables[1].HIGH_YIELD_TILES);
    AddToTable(ring1HighYields, self.RingTables[1].HIGH_EXTRA_YIELDS);
    AddToTable(ring2HighYields, self.RingTables[2].HIGH_YIELD_TILES);
    AddToTable(ring2HighYields, self.RingTables[2].HIGH_EXTRA_YIELDS);
    local highYieldsCount = #ring1HighYields + #ring2HighYields;
    _Debug("CheckInnerRingHighYieldsThreshold highYieldsCount = ", highYieldsCount);
    if highYieldsCount >= self.MinHighYieldInnerRingThreshold and highYieldsCount <= self.MaxHighYieldInnerRingThreshold then
        _Debug("CheckInnerRingHighYieldsThreshold OK : highYieldsCount = ", highYieldsCount, self.MaxHighYieldInnerRingThreshold);
        return true;
    end
    ring1HighYields = GetShuffledCopyOfTable(ring1HighYields);
    for _, h in ipairs(ring1HighYields) do
        if highYieldsCount > self.MaxHighYieldInnerRingThreshold and h.IsTaggedAsMinimum == false then
            self:TerraformHex(h, 1, TerraformType[3], g_RESOURCE_NONE, false, false);
            highYieldsCount = highYieldsCount - 1;
            table.insert(ringModifiedTiles, h);
            _Debug("CheckInnerRingHighYieldsThreshold deleted a high yields on ", h:PrintXY(), " Ring 1")
        end
    end
    ring2HighYields = GetShuffledCopyOfTable(ring2HighYields);
    for _, h in ipairs(ring2HighYields) do
        if highYieldsCount > self.MaxHighYieldInnerRingThreshold and h.IsTaggedAsMinimum == false then
            self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_NONE, false, false);
            highYieldsCount = highYieldsCount - 1;
            table.insert(ringModifiedTiles, h);
            _Debug("CheckInnerRingHighYieldsThreshold deleted a high yields on ", h:PrintXY(), " Ring 2")
        end
    end
    -- If still over maximum, it means the lux or guaranteed 2/2+ were tagged as minimum
    -- Try relocating a lux on ring 3 then replace by a standard 2/2
    -- First relocate ring 3 then further if needed     
    if highYieldsCount > self.MaxHighYieldInnerRingThreshold then
        _Debug("CheckInnerRingHighYieldsThreshold : over maximum of highyields")
        local relocateLeft = highYieldsCount - self.MaxHighYieldInnerRingThreshold;
        _Debug("CheckInnerRingHighYieldsThreshold relocateLeft = ", relocateLeft);
        for _, h1 in ipairs(ring1HighYields) do
            if relocateLeft > 0 and Contains(ringModifiedTiles, h1) == false then
                local wasTagged = false;
                if h1.IsTaggedAsMinimum then
                    wasTagged = true;
                    h1:SetTaggedAsMinimum(false);
                end
                if self:TerraformHex(h1, 1, TerraformType[15], 0, false, false) then
                    _Debug("CheckInnerRingHighYieldsThreshold : ring 1 flattened ", h1:PrintXY())
                    relocateLeft = relocateLeft - 1;
                    table.insert(ringModifiedTiles, h1);
                    if wasTagged then
                        h1:SetTaggedAsMinimum(true);
                    end
                end                
            end
        end
        _Debug("CheckInnerRingHighYieldsThreshold relocateLeft after r1 = ", relocateLeft);
        for _, h2 in ipairs(ring2HighYields) do
            if relocateLeft > 0 and Contains(ringModifiedTiles, h2) == false then
                local wasTagged = false;
                if h2.IsTaggedAsMinimum then
                    wasTagged = true;
                    h2:SetTaggedAsMinimum(false);
                end
                if self:TerraformHex(h2, 2, TerraformType[15], 0, false, false) then
                    _Debug("CheckInnerRingHighYieldsThreshold : ring 2 flattened ", h2:PrintXY())
                    relocateLeft = relocateLeft - 1;
                    table.insert(ringModifiedTiles, h2);
                    if wasTagged then
                        h2:SetTaggedAsMinimum(true);
                    end
                end  
            end
        end  
    end 

    -- Added needed for minimum
    while highYieldsCount < self.MinHighYieldInnerRingThreshold do
        if self:TerraformInRingsRandomOrder(1, 3, TerraformType[13], 0, false, false, false) then
            highYieldsCount = highYieldsCount + 1;
            _Debug("CheckHighYieldsThreshold added a high yields on ", h:PrintXY())
        else
            _Debug("CheckHighYieldsThreshold - Could not add lux in ring 1-3 for ", self.Civ.CivilizationLeader)
            self.InnerRingLuxCount = self.MinLuxInnerRingThreshold;
        end
    end
end



function SpawnBalancing:GetCoastalScoreHex()
    local coastalScore = 0;
    for i, _ in pairs(self.RingTables) do
        for _, hex in pairs(self.RingTables[i].WATER_RF) do
            if i == 1 or i == 2 then
                --if hex.ResourceType == g_RESOURCE_NONE and hex.FeatureType == g_FEATURE_REEF then
                --    coastalScore = coastalScore + CoastalScoring.REEF_R2
                if hex.ResourceType == g_RESOURCE_FISH then
                    if hex.FeatureType == g_FEATURE_REEF then
                        coastalScore = coastalScore + CoastalScoring.FISH_REEF_R2
                        _Debug("FISH_REEF_R2 "..tostring(CoastalScoring.FISH_REEF_R2))
                    else
                        coastalScore = coastalScore + CoastalScoring.FISH_R2
                        _Debug("FISH_R2 "..tostring(CoastalScoring.FISH_R2))
                    end
                elseif hex.ResourceType == g_RESOURCE_TURTLES then
                    coastalScore = coastalScore + CoastalScoring.TURTLES_R2
                    _Debug("FISH_R2 "..tostring(CoastalScoring.FISH_R2))
                elseif hex.ResourceType == g_RESOURCE_WHALES then
                    coastalScore = coastalScore + CoastalScoring.WHALES_R2
                    _Debug("WHALES_R2 "..tostring(CoastalScoring.WHALES_R2))
                elseif hex.ResourceType == g_RESOURCE_PEARLS or hex.ResourceType == g_RESOURCE_PENGUINS then
                    coastalScore = coastalScore + CoastalScoring.PEARLS_R2
                    _Debug("PEARLS_R2 "..tostring(CoastalScoring.PEARLS_R2))
                elseif hex.ResourceType == g_RESOURCE_AMBER then
                    coastalScore = coastalScore + CoastalScoring.AMBER_R2
                    _Debug("AMBER_R2 "..tostring(CoastalScoring.AMBER_R2))
                elseif hex.ResourceType == g_RESOURCE_CRABS then
                    coastalScore = coastalScore + CoastalScoring.CRABS_R2
                    _Debug("CRABS_R2 "..tostring(CoastalScoring.CRABS_R2))
                end
            elseif i == 3 then
                --if hex.ResourceType == g_RESOURCE_NONE and hex.FeatureType == g_FEATURE_REEF then
                --    coastalScore = coastalScore + CoastalScoring.REEF_R3
                if hex.ResourceType == g_RESOURCE_FISH then
                    if hex.FeatureType == g_FEATURE_REEF then
                        coastalScore = coastalScore + CoastalScoring.FISH_REEF_R3
                        _Debug("FISH_REEF_R3 "..tostring(CoastalScoring.FISH_REEF_R3))
                    else
                        coastalScore = coastalScore + CoastalScoring.FISH_R3
                        _Debug("FISH_R3 "..tostring(CoastalScoring.FISH_R3))
                    end
                elseif hex.ResourceType == g_RESOURCE_TURTLES then
                    coastalScore = coastalScore + CoastalScoring.TURTLES_R3
                    _Debug("TURTLES_R3 "..tostring(CoastalScoring.TURTLES_R3))
                elseif hex.ResourceType == g_RESOURCE_WHALES then
                    coastalScore = coastalScore + CoastalScoring.WHALES_R3
                    _Debug("WHALES_R3 "..tostring(CoastalScoring.WHALES_R3))
                elseif hex.ResourceType == g_RESOURCE_PEARLS or hex.ResourceType == g_RESOURCE_PENGUINS then
                    coastalScore = coastalScore + CoastalScoring.PEARLS_R3
                    _Debug("PEARLS_R3 "..tostring(CoastalScoring.PEARLS_R3))
                elseif hex.ResourceType == g_RESOURCE_AMBER then
                    coastalScore = coastalScore + CoastalScoring.AMBER_R3
                    _Debug("AMBER_R3 "..tostring(CoastalScoring.AMBER_R3))
                elseif hex.ResourceType == g_RESOURCE_CRABS then
                    coastalScore = coastalScore + CoastalScoring.CRABS_R3
                    _Debug("CRABS_R3 "..tostring(CoastalScoring.CRABS_R3))
                end
            end
        end
    end
    _Debug("Coastal Score for civ "..self.Civ.CivilizationLeader.." = "..tostring(coastalScore));
    self.CoastalScore = coastalScore;
end

-- From a selected table of hex datas, take a random hex and prepare to relocating in the next ring
-- replaced when method PlaceRelocatedHexOnRing is called with the right ring index
function SpawnBalancing:RelocateRandomHexToNextRing(tableToRelocateFrom, ringTableIndex, destinationRingIndex)
    tableToRelocateFrom = GetShuffledCopyOfTable(tableToRelocateFrom);
    for _, hex in pairs(tableToRelocateFrom) do
        -- Do not relocate floodplains, desert and tundra
        _Debug("Try relocate : ", hex:PrintXY(), hex.TerrainType, hex.FeatureType, hex.ResourceType, " from low yields tiles")
        if hex:IsFloodplains(true) == false and hex:IsDesertLand() == false and hex:IsTundraLand() == false and hex:IsSnowLand() == false
            and self:RelocateHex(ringTableIndex, destinationRingIndex, hex) then
            return hex;
        end
    end
    _Debug("RelocateRandomHexToNextRingERROR - No hex to relocate", #tableToRelocateFrom)
    return nil;
end

function SpawnBalancing:RelocateHex(ringTableIndex, destinationRingIndex, hex)
    local hexData = { TerrainId = hex.TerrainType,  FeatureId = hex.FeatureType, ResourceId = hex.ResourceType, Relocated = false }
    _Debug("Relocating "..hex:PrintXY().." : "..tostring(hex.TerrainType).." "..tostring(hex.FeatureType).." "..tostring(hex.ResourceType))
    if self:CanRelocateStrategics(hex.ResourceType, destinationRingIndex) == false or hex.IsTaggedAsMinimum then
        _Debug("Cannot relocate strategics beyond or tagged tiles")
        return false;
    end
    if hex.FeatureType ~= g_FEATURE_NONE or hex.ResourceType ~= g_RESOURCE_NONE then
        table.insert(self.RingTables[destinationRingIndex].RELOCATING_TILES, hexData);
    end
    -- if/else not grouped in same condition because TerraformHex actually clean the tile, do not clean feature if not possible
    if self:TerraformHex(hex, ringTableIndex, TerraformType[99], 0, false, false) then
        return true;
    end
    return false;
end


-- To call after using a method that can fill the relocating table, will try to add it to the ring in index
function SpawnBalancing:PlaceRelocatedHexOnRing(i)
    local totalRelocating = #self.RingTables[i].RELOCATING_TILES
    _Debug("PlaceRelocatedHexOnRing entry = ", totalRelocating)
    if totalRelocating > 0 then
        for _, hexData in ipairs(self.RingTables[i].RELOCATING_TILES) do
            _Debug("PlaceRelocatedHexOnRing Try = ", hexData.TerrainId, hexData.FeatureId, hexData.ResourceId)
            local isRelocated = false;
            if #self.RingTables[i].WATER_EMPTY > 0 and hexData.TerrainId == g_TERRAIN_TYPE_COAST then
                local listWater = self.RingTables[i].WATER_EMPTY;
                if #listWater > 1 then
                    listWater = GetShuffledCopyOfTable(listWater);
                end
                for _, hex in pairs(listWater) do
                    local canFeat = self.HexMap:TerraformSetFeatureRequirements(hex, hexData.FeatureId, false);
                    local canRes = self.HexMap:TerraformSetResourceRequirements(hex, hexData.ResourceId);
                    if canFeat and canRes then
                        self:TerraformHex(hex, i, TerraformType[2], hexData.FeatureId, true, false);
                        if self:TerraformHex(hex, i, TerraformType[3], hexData.ResourceId, true, false) then
                            _Debug("PlaceRelocatedHexOnRing "..tostring(i).." "..hex:PrintXY())
                            totalRelocating = totalRelocating - 1;
                            isRelocated = true;
                        end
                    end
                    if isRelocated then break end
                end
            end
            if #self.RingTables[i].EMPTY_TILES > 0 then
                local randomEmptyYields = GetShuffledCopyOfTable(self.RingTables[i].EMPTY_TILES);
                for _, hex in ipairs(randomEmptyYields) do
                    if isRelocated or hex.IsTaggedAsMinimum then break end
                    local canFeat = self.HexMap:TerraformSetFeatureRequirements(hex, hexData.FeatureId, false);
                    local canRes = self.HexMap:TerraformSetResourceRequirements(hex, hexData.ResourceId);
                    local canTerr = hex:IsSameTerrainCategory(hexData.TerrainId);
                    _Debug("Try relocating on ", hex:PrintXY(), " canFeat ", canFeat, " canRes ", canRes)
                    if canTerr and canFeat and canRes then
                        self:TerraformHex(hex, i, TerraformType[1], hexData.TerrainId, false, false);
                        self:TerraformHex(hex, i, TerraformType[2], hexData.FeatureId, false, false);
                        if self:TerraformHex(hex, i, TerraformType[3], hexData.ResourceId, false, false) then
                            _Debug("Relocated feat = "..tostring(hexData.FeatureId).." res = "..tostring(hexData.ResourceId).." on "..hex:PrintXY())
                            isRelocated = true;
                        end
                    end
                    if isRelocated then
                        totalRelocating = totalRelocating - 1;
                        _Debug("Relocated feat = "..tostring(hexData.FeatureId).." res = "..tostring(hexData.ResourceId).." on "..hex:PrintXY())
                    else
                        _Debug("Cant terraform relocating")
                    end
                end
            end
            if isRelocated == false and #self.RingTables[i].LOW_YIELD_TILES > 0 then
                local randomLowYields = GetShuffledCopyOfTable(self.RingTables[i].LOW_YIELD_TILES);
                for _, hex in pairs(randomLowYields) do
                    if isRelocated or hex.IsTaggedAsMinimum then break end;
                    local canFeat = self.HexMap:TerraformSetFeatureRequirements(hex, hexData.FeatureId, false);
                    local canRes = self.HexMap:TerraformSetResourceRequirements(hex, hexData.ResourceId);
                    local canTerr = hex:IsSameTerrainCategory(hexData.TerrainId);
                    if canTerr and canFeat and canRes then
                        self:TerraformHex(hex, i, TerraformType[1], hexData.TerrainId, false, false);
                        self:TerraformHex(hex, i, TerraformType[2], hexData.FeatureId, false, false);
                        if self:TerraformHex(hex, i, TerraformType[3], hexData.ResourceId, false, false) then
                            _Debug("Relocated feat = "..tostring(hexData.FeatureId).." res = "..tostring(hexData.ResourceId).." on "..hex:PrintXY())
                            totalRelocating = totalRelocating - 1;
                            isRelocated = true;
                        end
                    end
                end
            end
        end
    end
    if totalRelocating > 0 then
        _Debug("PlaceRelocatedHexOnRingERROR - Could not relocate all hex")

    end
    -- TODO Relocating fail behaviour => to something else like try next ring or not needed ?
    self.RingTables[i].RELOCATING_TILES = {}
end

-- Method used to terraform a random tile around the main tile starting from empty or low yields tiles
-- on the last selected ring, we may force a last resort terraformation if needed
-- iMin and iMax are the respectively starting ring (most desired) to last possible ring
-- terraformType is TerraformType[n] => sort of enum to choose terrain/feature/resource with its id
-- @param needToBeWalkableTo means the ring selected have no impassable obstacle between them
function SpawnBalancing:TerraformInRingsOrder(iMin, iMax, terraformType, id, needToBeWalkableTo, forcedLastRing, boolParam)
    for i, _ in pairs(self.RingTables) do
        if i >= iMin and i < iMax + 1 then
            -- forced is applied only in the last ring
            local forced = false;
            if i == iMax and forcedLastRing then
                forced = true
            end
            local terraformedHex = self:TerraformRandomInRing(i, terraformType, id, needToBeWalkableTo, forced, boolParam);
            if terraformedHex ~= nil then
                _Debug("TerraformInRingsOrderOK terraform "..terraformType.." "..tostring(id));
                return terraformedHex;
            end
        end
    end
    _Debug("TerraformInRingsOrderERROR Could not terraform "..terraformType.." "..tostring(id).." from "..self.Hex:PrintXY());
    return nil;
end

-- Used the TerraformInRingsOrder but do a shuffle before
function SpawnBalancing:TerraformInRingsRandomOrder(iMin, iMax, terraformType, id, needToBeWalkableTo, forcedLastRing, boolParam)
    local order = {}
    local forced = false;
    for i = iMin, iMax do
        table.insert(order, i)
    end
    order = GetShuffledCopyOfTable(order)
    for _, iRing in pairs(order) do
        if iRing == iMax and forcedLastRing then
            forced = true
        end
        local terraformedHex = self:TerraformRandomInRing(iRing, terraformType, id, needToBeWalkableTo, forced, boolParam);
        if terraformedHex ~= nil then
            return terraformedHex;
        end
    end
    return nil;
end


-- Add a terraformation given in parameter in the given ring, for empty or low yields tiles
function SpawnBalancing:TerraformRandomInRing(i, terraformType, id, needToBeWalkableTo, forced, boolParam)
    _Debug("TerraformRandomInRing "..tostring(i));
    -- For water/coastal works, limited to fishing resources (WARNING amber in fishing and mining)
    if (terraformType == TerraformType[3] and g_RESOURCES_FISHINGBOAT_LIST[id])
            or (terraformType == TerraformType[2] and id == g_FEATURE_REEF) then
        _Debug("Trying to add "..tostring(terraformType).." id "..tostring(id).." to ring "..tostring(i))
        if #self.RingTables[i].WATER_EMPTY > 0 then
            local listWater = self.RingTables[i].WATER_EMPTY;
            if #listWater > 1 then
                listWater = GetShuffledCopyOfTable(listWater);
            end
            for _, hex in pairs(listWater) do
                if self:TerraformHex(hex, i, terraformType, id, true, boolParam) then
                    _Debug("Added "..tostring(terraformType).." id "..tostring(id).." to "..hex:PrintXY())
                    return hex;
                else
                    _Debug("Couldnt add on water")
                end
            end
        end
    end
    -- Try to terraform empty tiles first
    if #self.RingTables[i].EMPTY_TILES > 0 then
        local listEmpty = self.RingTables[i].EMPTY_TILES;
        if #listEmpty > 1 then
            listEmpty = GetShuffledCopyOfTable(listEmpty);
        end
        for _, hex in pairs(listEmpty) do
            if needToBeWalkableTo == false or (needToBeWalkableTo and self.Hex:IsWalkableInRange(hex, i)) then
                if self:TerraformHex(hex, i, terraformType, id, true, boolParam) then
                    _Debug("Found a empty tile "..hex:PrintXY().." to add "..tostring(terraformType).." "..tostring(id))
                    return hex;
                end
            end
        end
    end
    -- If no empty tiles available, try on low yields (with resource or feature)
    if #self.RingTables[i].LOW_YIELD_TILES > 0 then
        local listLowYieldsTiles = self.RingTables[i].LOW_YIELD_TILES;
        if #listLowYieldsTiles > 1 then
            listLowYieldsTiles = GetShuffledCopyOfTable(listLowYieldsTiles);
        end
        for _, hex in pairs(listLowYieldsTiles) do
            if needToBeWalkableTo == false or (needToBeWalkableTo and self.Hex:IsWalkableInRange(hex, i)) then
                if self:TerraformHex(hex, i, terraformType, id, false, boolParam) then
                    _Debug("Found a low yield tile "..hex:PrintXY().." to add "..tostring(terraformType).." "..tostring(id))
                    return hex;
                end
            end
        end
        -- if unable to place on low yield tile force if asked in parameter
        if #listLowYieldsTiles > 0 and forced then
            -- Already shuffled from before, just take the first hex and force desired terraform on it
            _Debug("Try to force on ring "..tostring(i));
            -- Try to add on Feature, exclude flood and geo
            for _, hex in pairs(listLowYieldsTiles) do
                if hex.IsTaggedAsMinimum == false and needToBeWalkableTo == false or (needToBeWalkableTo and self.Hex:IsWalkableInRange(hex, i)) and hex:IsFloodplains(true) == false then
                    if hex.ResourceType == g_RESOURCE_NONE and hex.FeatureType ~= g_FEATURE_GEOTHERMAL_FISSURE then
                        if self:TerraformHex(hex, i, terraformType, id, true, boolParam) then
                            _Debug("Terraformed a "..tostring(hex.FeatureType).." feature "..hex:PrintXY());
                            return hex;
                        end
                    end
                    -- Try to add on Resource (feature or not), relocate only bonus
                    if g_RESOURCES_BONUS_LIST[hex.ResourceType] or g_RESOURCES_LUX_LIST[hex.ResourceType] then
                        self:TerraformHex(hex, i, TerraformType[3], g_RESOURCE_NONE, false, true)
                        if self:TerraformHex(hex, i, terraformType, id, true, boolParam) then
                            _Debug("Terraformed a "..tostring(hex.ResourceType).." resource "..hex:PrintXY());
                            return hex;
                        end
                    end
                end
            end
        end
    end
    return nil;
end


function SpawnBalancing:CanRelocateStrategics(resId, i)
    local maxRingAllowedForHorses = 2
    local maxRingAllowedForIron = 3
    -- In garanteed strategics settings
    if MapConfiguration.GetValue("BBSStratRes") == 3  and (resId == RESOURCE_HORSES and i > maxRingAllowedForHorses) or (resId == RESOURCE_IRON and i > maxRingAllowedForIron) then
        return false;
    end
    return true;
end

function SpawnBalancing:ApplyGaranteedStrategics()
    -- Horse and iron in ring 1-3, other strats in ring 1-5
    local ring1To2 = {};
    AddToTable(ring1To2, self.Hex.AllRing6Map[1]);
    AddToTable(ring1To2, self.Hex.WalkableHexInRing[2]);
    local horsesOK = false;
    local ironOK = false;
    for _, h in pairs(ring1To2) do
        if h.ResourceType == g_RESOURCE_HORSES then
            _Debug("Already found horses");
            h:SetTaggedAsMinimum(true);
            horsesOK = true;
        end
        if h.ResourceType == g_RESOURCE_IRON then
            _Debug("Already found iron");
            h:SetTaggedAsMinimum(true);
            ironOK = true;
        end
    end
    if horsesOK == false then
        _Debug("Adding horses 1-2")
        local horsesHex = self:TerraformInRingsRandomOrder(1, 2, TerraformType[3], g_RESOURCE_HORSES, true, true, false);
        if horsesHex ~= nil then
            _Debug("Tagged horses ", horsesHex:PrintXY());
            horsesHex:SetTaggedAsMinimum(true);
        else
            _Debug("Failed to place horses on ring 2, try on ring 3 ");
            horsesHex = self:TerraformRandomInRing(3, TerraformType[3], g_RESOURCE_HORSES, true, true, false);
            if horsesHex ~= nil then
                _Debug("Tagged horsesHex in ring 3 ", horsesHex:PrintXY());
                horsesHex:SetTaggedAsMinimum(true);
            else
                _Debug("ApplyGaranteedStrategicsERROR Failed to place iron on ring 3 ");
            end
        end
    end
    if ironOK == false then
        _Debug("Adding iron 1-2")
        local ironHex = self:TerraformInRingsRandomOrder(1, 2, TerraformType[3], g_RESOURCE_IRON, true, true, false);
        if ironHex ~= nil then
            _Debug("Tagged iron ", ironHex:PrintXY());
            ironHex:SetTaggedAsMinimum(true);
        else
            _Debug("Failed to place iron on ring 2, try on ring 3 ");
            ironHex = self:TerraformRandomInRing(3, TerraformType[3], g_RESOURCE_IRON, true, true, false);
            if ironHex ~= nil then
                _Debug("Tagged iron in ring 3 ", ironHex:PrintXY());
                ironHex:SetTaggedAsMinimum(true);
            else
                _Debug("ApplyGaranteedStrategicsERROR Failed to place iron on ring 3 ");
            end
        end
    end

    local ring1To5, _ = self.HexMap:GetAllHexInRing(self.Hex, 5);
    table.insert(ring1To5, self.Hex)
    local niterOK = false;
    local coalOK = false;
    local oilOK = false;
    local uraniumOK = false;
    local aluOK = false;
    for _, h in pairs(ring1To5) do
        if h.ResourceType == g_RESOURCE_NITER and niterOK == false then
            _Debug("Already found niter");
            niterOK = true;
        end
        if h.ResourceType == g_RESOURCE_COAL and coalOK == false then
            _Debug("Already found coal");
            coalOK = true;
        end
        if h.ResourceType == g_RESOURCE_OIL and oilOK == false then
            _Debug("Already found oil");
            oilOK = true;
        end
        if h.ResourceType == g_RESOURCE_ALUMINUM and aluOK == false then
            _Debug("Already found aluminium");
            aluOK = true;
        end
        if h.ResourceType == g_RESOURCE_URANIUM and uraniumOK == false then
            _Debug("Already found uranium");
            uraniumOK = true;
        end
    end
    if niterOK == false then
        self:TerraformInRingsOrder(4, 5, TerraformType[3], g_RESOURCE_NITER, false, true);
    end
    if coalOK == false then
        self:TerraformInRingsOrder(4, 5, TerraformType[3], g_RESOURCE_COAL, false, true);
    end
    if oilOK == false then
        self:TerraformInRingsOrder(4, 5, TerraformType[3], g_RESOURCE_OIL, false, true);
    end
    if aluOK == false then
        self:TerraformInRingsOrder(4, 5, TerraformType[3], g_RESOURCE_ALUMINUM, false, true);
    end
    if uraniumOK == false then
        self:TerraformInRingsOrder(4, 5, TerraformType[3], g_RESOURCE_URANIUM, false, true);
    end
end

-- Generic terraforming method for a selected hex with selected paramters
-- @param previousTable is the table category the hex is in (EMPTY_TILES, LOW_YIELD_TILES etc...),
--  its used as we need to remove it from this table and update to the new category after terraforming
-- @param ring is the ring the hex is in compared to spawning tile, as the previous param, it is used to update tables
-- @param hex is the hex to terraform
-- @param terraformType is the "enum" type for the terraform to apply
-- @param id is the corresponding resource/feature/terrain to apply (some terraformType do not use this)
-- @param forced is a boolean to change the tile even if it do not meet all conditions (some terraformType do not use this)
function SpawnBalancing:TerraformHex(hex, ring, terraformType, id, forced, boolParam)
    if hex.IsNaturalWonder == false and hex.IsTaggedAsMinimum == false and self:Terraform(hex, terraformType, id, forced, boolParam) then
        self:FillTableRing(ring)
        --self:UpdateTableDataRing(hex, ring);
        table.insert(self.TerraformedTiles, hex);
        return hex;
    end
    return nil;
end


function SpawnBalancing:RemoveFromDataTables(hex, i)
    RemoveFromTable(self.RingTables[i].WATER, hex);
    RemoveFromTable(self.RingTables[i].WATER_EMPTY, hex);
    RemoveFromTable(self.RingTables[i].WATER_RF, hex);
    RemoveFromTable(self.RingTables[i].WATER_FISH_OR_LUX, hex);
    RemoveFromTable(self.RingTables[i].MOUNTAINS, hex);
    RemoveFromTable(self.RingTables[i].DESERT, hex);
    RemoveFromTable(self.RingTables[i].EMPTY_TILES, hex);
    RemoveFromTable(self.RingTables[i].LOW_YIELD_TILES, hex);
    RemoveFromTable(self.RingTables[i].STANDARD_YIELD_TILES, hex);
    RemoveFromTable(self.RingTables[i].HIGH_YIELD_TILES, hex);
    RemoveFromTable(self.RingTables[i].HIGH_EXTRA_YIELDS, hex);
    RemoveFromTable(self.RingTables[i].WORKABLE, hex);
end


-- Data for each ring around the designed spawn
function SpawnBalancing:UpdateTableDataRing(h, i)
    if i == 0 then
        return
    end
    h:UpdateYields();
    self:RemoveFromDataTables(h, i);
    if h:IsWater() then
        table.insert(self.RingTables[i].WATER, h) -- not used ?
        -- Directly separate empty water tiles and with resources for easier management
        if h.TerrainType == g_TERRAIN_TYPE_COAST and h.Plot:IsLake() == false then
            if h.FeatureType == g_FEATURE_NONE and h.ResourceType == g_RESOURCE_NONE then
                table.insert(self.RingTables[i].WATER_EMPTY, h)
            else
                table.insert(self.RingTables[i].WATER_RF, h)
            end
        end
        if h.TerrainType == g_TERRAIN_TYPE_COAST and h.ResourceType == g_RESOURCE_FISH or g_RESOURCES_LUX_LIST[h.ResourceType] then
            table.insert(self.RingTables[i].WATER_FISH_OR_LUX, h)
        end
    elseif h:IsMountain() then
        table.insert(self.RingTables[i].MOUNTAINS, h)
    elseif h:IsDesertLand() then
        table.insert(self.RingTables[i].DESERT, h)
    end
    if IsTundraLand(h.TerrainType) then
        return self:UpdateTableDataRingTundra(h, i);
    end

    if h:IsImpassable() then
        return
    end

    if  h.ResourceType == g_RESOURCE_NONE and h.FeatureType == g_FEATURE_NONE then
        table.insert(self.RingTables[i].EMPTY_TILES, h)
    elseif h.Food + h.Prod < 4 then
        table.insert(self.RingTables[i].LOW_YIELD_TILES, h)
    elseif h.Food + h.Prod >= 4 and h.ExtraYield then
        table.insert(self.RingTables[i].HIGH_EXTRA_YIELDS, h)
    elseif h.Food + h.Prod == 4 then
        table.insert(self.RingTables[i].STANDARD_YIELD_TILES, h)
    elseif h.Food + h.Prod > 4 then
        table.insert(self.RingTables[i].HIGH_YIELD_TILES, h)
    end
    -- Workable are minimum 3 yields tiles
    if h.Food + h.Prod >= 3 then
        table.insert(self.RingTables[i].WORKABLE, h)
    end
end

function SpawnBalancing:UpdateTableDataRingTundra(h, i)
    if h:IsImpassable() then
        return
    end
    if h.ResourceType == g_RESOURCE_NONE and h.FeatureType == g_FEATURE_NONE and h.TerrainType == g_TERRAIN_TYPE_TUNDRA then
        table.insert(self.RingTables[i].EMPTY_TILES, h)
    elseif h.Food + h.Prod < 3 then
        table.insert(self.RingTables[i].LOW_YIELD_TILES, h)
    elseif h.Food + h.Prod >= 3 and h.ExtraYield then
        table.insert(self.RingTables[i].HIGH_EXTRA_YIELDS, h)
    elseif h.Food + h.Prod == 3 and h.Prod > 0 then
        table.insert(self.RingTables[i].STANDARD_YIELD_TILES, h)
    elseif h.Food + h.Prod > 3 or h.Food == 4 then
        table.insert(self.RingTables[i].HIGH_YIELD_TILES, h)
    end
    if h.Food + h.Prod >= 2 then
        table.insert(self.RingTables[i].WORKABLE, h)
    end
end


function SpawnBalancing:UpdateCoastalScore(score)
    self.CoastalScore = self.CoastalScore + score
    _Debug("New Coastal Score for "..self.Civ.CivilizationLeader.." = "..tostring(self.CoastalScore))
end

local MeansBalancing = {}
MeansBalancing.MeanInnerRingFood = 0;
MeansBalancing.MeanInnerRingProd = 0;
MeansBalancing.MeanInnerRingUnworkable = 0;
MeansBalancing.MeanInnerRingWorkable = 0;
MeansBalancing.MeanInnerStandardYields = 0;
MeansBalancing.MeanInnerRingHighYields = 0;
MeansBalancing.MeanInnerRingUnworkable = 0;


-- List of "SpawnBalancing" object for each major civ
function BalanceAllCivYields(spawns)
    local aimedCoastalScore = CoastalScoring.BASE_COASTAL_SCORE;
    local meanCoastalScore = 0;
    local nbCoastal = 0;

    local meanInnerRingFood = 0;
    local meanInnerRingProd = 0;
    local meanOuterRingFood = 0;
    local meanOuterRingProd = 0;
    local meanInnerStandardYields = 0;
    local meanOuterStandardYields = 0;
    local meanInnerRingHighYields = 0;
    local meanOuterRingHighYields = 0;
    local meanInnerRingWorkable = 0;
    local meanOuterRingWorkable = 0;
    local meanInnerRingUnworkable = 0;
    local meanOuterRingUnworkable = 0;
    local nbCivExtraYieldRing3 = 0;

    for _, spawn in pairs(spawns) do
        -- Calculate coastal mean 
        if spawn.CoastalScore > 0 then
            meanCoastalScore = meanCoastalScore + spawn.CoastalScore
            nbCoastal = nbCoastal + 1
        end
    end

    ----------------------------
    -- Step 1 : Balancing coastal resources on coastal civ
    ----------------------------
    if nbCoastal > 0 then
        aimedCoastalScore = math.max((meanCoastalScore / nbCoastal), CoastalScoring.BASE_COASTAL_SCORE);
        _Debug("BalanceAllCivYields - "..tostring(aimedCoastalScore));
        for _, spawn in pairs(spawns) do
            spawn.AimedCoastalScore = aimedCoastalScore
            _Debug(spawn.Civ.CivilizationLeader.." - Initial coastal score = "..tostring(spawn.CoastalScore))
            if spawn.CoastalScore < spawn.AimedCoastalScore then
                spawn:ImproveCoastal()
            elseif spawn.CoastalScore > spawn.AimedCoastalScore then
                spawn:NerfCoastal()
            end
        end
    end
    
    -- APPLY BALANCING AND CALCS AFTER COASTAL WORK
    ----------------------------
    -- Step 2a : Calculate means for next step
    ----------------------------
    _Debug("Start BalanceAllCivYields balancing ", os.date("%c"));
    for _, spawn in pairs(spawns) do
        -- Init workables
        spawn:GetInnerRingWorkable();
        spawn:GetOuterRingWorkable();

        local includingExtraYields = 0;
        meanInnerRingUnworkable = meanInnerRingUnworkable + #spawn.InnerRingUnworkable;
        meanInnerRingWorkable = meanInnerRingWorkable + #spawn.InnerRingWorkable;
        meanInnerStandardYields = meanInnerStandardYields + #spawn.InnerRingStd;
        meanInnerRingHighYields = meanInnerRingHighYields + #spawn.InnerRingHigh;
        meanInnerRingFood = meanInnerRingFood + spawn.InnerRingFood;
        meanInnerRingProd = meanInnerRingProd + spawn.InnerRingProd;

        meanOuterRingUnworkable = meanOuterRingUnworkable + #spawn.OuterRingUnworkable;
        meanOuterRingWorkable = meanOuterRingWorkable + #spawn.OuterRingWorkable;
        meanOuterStandardYields = meanOuterStandardYields + #spawn.OuterRingStd;
        meanOuterRingHighYields = meanOuterRingHighYields + #spawn.OuterRingHigh;
        meanOuterRingFood = meanOuterRingFood + spawn.OuterRingFood;
        meanOuterRingProd = meanOuterRingProd + spawn.OuterRingProd;
        for i, _ in pairs(spawn.RingTables) do
            if i < 4 then
                includingExtraYields = includingExtraYields + #spawn.RingTables[i].HIGH_EXTRA_YIELDS
                --print("Found extra yield in ring "..tostring(i).." = "..tostring(#spawn.RingTables[i].HIGH_EXTRA_YIELDS))
            end

        end
        if includingExtraYields > 0 then
            nbCivExtraYieldRing3 = nbCivExtraYieldRing3 + 1;
        end
        _Debug(spawn.Civ.CivilizationLeader.." innerRingFood = "..tostring(spawn.InnerRingFood).." - outerRingFood = "..tostring(spawn.OuterRingFood));
        _Debug(spawn.Civ.CivilizationLeader.." innerRingProd = "..tostring(spawn.InnerRingProd).." - outerRingProd = "..tostring(spawn.OuterRingProd));
        _Debug(spawn.Civ.CivilizationLeader.." includingExtraYields = "..tostring(includingExtraYields));
    end

    -- Calculate yields means
    MeansBalancing.MeanInnerRingFood = math.floor((meanInnerRingFood / #spawns) + 0.5);
    --.MeanInnerRingProd = math.floor((meanInnerRingProd / #spawns) + 0.5);
    -- One prod per tile in ring 1 + 2 = 18, should not go below that threshold (TO TEST)
    MeansBalancing.MeanInnerRingProd = math.max(19, math.floor((meanInnerRingProd / #spawns) + 0.5));
    _Debug("MeanInnerRingProd = ", MeansBalancing.MeanInnerRingProd)
    local maxProdGoal = math.max(0, 26 - MeansBalancing.MeanInnerRingProd);
    local rngMeanProd = TerrainBuilder.GetRandomNumber(maxProdGoal, "maxProdGoal");
    _Debug("rngMeanProd = ", rngMeanProd, " maxProdGoal = ", maxProdGoal)
    MeansBalancing.MeanInnerRingProd = MeansBalancing.MeanInnerRingProd + rngMeanProd
    MeansBalancing.MeanInnerRingUnworkable = math.floor((meanInnerRingUnworkable / #spawns) + 0.5);
    MeansBalancing.MeanInnerRingWorkable =math.floor((meanInnerRingWorkable / #spawns) + 0.5);
    --MeansBalancing.MeanInnerStandardYields = math.floor((meanInnerStandardYields / #spawns) + 0.5);
    MeansBalancing.MeanInnerStandardYields = math.min(5, math.floor((meanInnerStandardYields / #spawns) + 0.5));
    _Debug("MeanInnerStandardYields = ", MeansBalancing.MeanInnerStandardYields)
    local maxStdGoal = math.max(0, 7 - MeansBalancing.MeanInnerStandardYields);
    local rngMeanStd = TerrainBuilder.GetRandomNumber(maxStdGoal, "maxStdGoal");
    _Debug("rngMeanStd = ", rngMeanStd, " maxStdGoal = ", maxStdGoal)
    MeansBalancing.MeanInnerStandardYields = MeansBalancing.MeanInnerStandardYields + rngMeanStd;
    if MeansBalancing.MeanInnerRingProd >= 24 then
        MeansBalancing.MeanInnerStandardYields = MeansBalancing.MeanInnerStandardYields + 1;
    end
    MeansBalancing.MeanInnerRingHighYields =  math.floor((meanInnerRingHighYields / #spawns) + 0.5);
    MeansBalancing.MeanOuterRingFood = math.floor((meanOuterRingFood / #spawns) + 0.5);
    MeansBalancing.MeanOuterRingProd = math.floor((meanOuterRingProd / #spawns) + 0.5);
    MeansBalancing.MeanOuterRingUnworkable = math.floor((meanOuterRingUnworkable / #spawns) + 0.5);
    MeansBalancing.MeanOuterRingWorkable = math.floor((meanOuterRingWorkable / #spawns) + 0.5);
    MeansBalancing.MeanOuterStandardYields = math.floor((meanOuterStandardYields / #spawns) + 0.5);
    MeansBalancing.MeanOuterRingHighYields = math.floor((meanOuterRingHighYields / #spawns) + 0.5);
    _Debug("meanInnerRingFood = "..tostring( MeansBalancing.MeanInnerRingFood));
    _Debug("meanInnerRingProd = "..tostring(MeansBalancing.MeanInnerRingProd));
    _Debug("meanInnerRingUnworkable = "..tostring(MeansBalancing.MeanInnerRingUnworkable));
    _Debug("meanInnerRingWorkable = "..tostring(MeansBalancing.MeanInnerRingWorkable));
    _Debug("meanInnerRingStandard = "..tostring( MeansBalancing.MeanInnerStandardYields));
    _Debug("meanInnerRingHighYields = "..tostring(MeansBalancing.MeanInnerRingHighYields));
    _Debug("meanOuterRingFood = "..tostring(MeansBalancing.MeanOuterRingFood));
    _Debug("meanOuterRingProd = "..tostring(MeansBalancing.MeanOuterRingProd));
    _Debug("meanOuterRingUnworkable = "..tostring(MeansBalancing.MeanOuterRingUnworkable));
    _Debug("meanOuterRingWorkable = "..tostring(MeansBalancing.MeanOuterRingWorkable));
    _Debug("meanOuterStandardYields = "..tostring(MeansBalancing.MeanOuterStandardYields));
    _Debug("meanOuterRingHighYields = "..tostring(MeansBalancing.MeanOuterRingHighYields));
    _Debug("nbCivExtraYieldRing3 = "..tostring(nbCivExtraYieldRing3));
    
    ----------------------------
    -- Step 2b : Balancing yields ring 1+2 for each civ
    ----------------------------
    local recapBalance = {};
    for _, spawn in pairs(spawns) do
        _Debug("Start SpawnBalancing - BalanceToMean ", spawn.Civ.CivilizationLeader)
        local yieldMargin = 2;
        local standardMargin = 1;
        local unworkableYieldMargin = 2;
        local allowedChanges = 0;
        local tries = 0;
        while allowedChanges < 20 and tries < 10 do
            if spawn:BalanceToMean(yieldMargin, standardMargin, unworkableYieldMargin) then
                allowedChanges = allowedChanges + 1;
                _Debug("BalanceToMean - Changes made : ", allowedChanges)
            else
                _Debug("BalanceToMean - Fail on this try, go to next")
                tries = tries + 1;
            end
        end
        -- Last calculations post balance
        spawn:GetInnerRingWorkable();
        spawn.StandardDiff = #spawn.InnerRingStd + #spawn.InnerRingHigh - MeansBalancing.MeanInnerStandardYields;
        local innerUnworkableDiff = math.max(0, #spawn.InnerRingUnworkable - MeansBalancing.MeanInnerRingUnworkable);
        local unworkableDiff = innerUnworkableDiff * unworkableYieldMargin;
        if spawn.Civ.IsTundraBias then
            -- Since tundra we can only add food by adding sheeps that the civs do not desire, considere we do not need to balance food
            spawn.InnerRingFood = MeansBalancing.MeanInnerRingFood
        elseif spawn.Civ.IsDesertBias then
            -- Desert bias untouched, only gets added minimum guaranteed tiles
            spawn.InnerRingFood = MeansBalancing.MeanInnerRingFood
            spawn.InnerRingProd = MeansBalancing.MeanInnerRingProd
        end
        spawn.InnerFoodDiff = spawn.InnerRingFood - MeansBalancing.MeanInnerRingFood + unworkableDiff;
        spawn.InnerProdDiff = spawn.InnerRingProd - MeansBalancing.MeanInnerRingProd + unworkableDiff;
        _Debug("BalanceToMean - Done ", allowedChanges, " changes for : ", spawn.Civ.CivilizationLeader)
        local recap = { StdDiff = spawn.StandardDiff, InnerFoodDiff = spawn.InnerFoodDiff, InnerProdDiff = spawn.InnerProdDiff, Changes = allowedChanges };
        recapBalance[spawn] = recap;
    end

    ----------------------------
    -- Step 3 (Teamer) - High yields between teams
    ----------------------------
    if (Is1v1OrTeamerConfig()) then
        HighYieldsTeamerBalancing(spawns);
    end

    ----------------------------
    -- Debug final print recap
    ----------------------------
    _Debug("Final balance recap :")
    _Debug("meanInnerRingStandard = "..tostring( MeansBalancing.MeanInnerStandardYields));
    _Debug("meanInnerRingFood = "..tostring( MeansBalancing.MeanInnerRingFood));
    _Debug("meanInnerRingProd = "..tostring(MeansBalancing.MeanInnerRingProd));
    for _, spawn in pairs(spawns) do
        local recap = recapBalance[spawn];
        _Debug("Civ : ", spawn.Civ.CivilizationLeader, " StdDiff : ", recap.StdDiff, " InnerFoodDiff : ", recap.InnerFoodDiff, " InnerProdDiff : ", recap.InnerProdDiff, " Changes : ", recap.Changes )
    end

    _Debug("End BalanceAllCivYields balancing ", os.date("%c"));
end

-- Get the same number of high yields tiles in ring 1-2 for each team
function HighYieldsTeamerBalancing(spawns)
    local team1HighYields = 0;
    local team2HighYields = 0;
    local team1Civ = {};
    local team2Civ = {};
    local firstTeamIndex = spawns[1].Civ.CivilizationTeam;
    spawns = GetShuffledCopyOfTable(spawns);
    for _, spawn in pairs(spawns) do
        spawn:GetInnerRingWorkable();
        local team = spawn.Civ.CivilizationTeam;
        _Debug("HighYieldsTeamerBalancing team", team, #spawn.InnerRingHigh)
        if team == firstTeamIndex then
            team1HighYields = team1HighYields + #spawn.InnerRingHigh
            table.insert(team1Civ, spawn)
        else
            team2HighYields = team2HighYields + #spawn.InnerRingHigh
            table.insert(team2Civ, spawn)
        end
    end
    
    _Debug("HighYieldsTeamerBalancing Team 1 team1HighYields = ", team1HighYields, " team2HighYields = ", team2HighYields);
    local highYieldsMargin = 0;
    local upgradeDone = 0;
    local triesCount = 0;
    if team1HighYields < team2HighYields - highYieldsMargin then
        local team1HighYieldToUp = team2HighYields - highYieldsMargin - team1HighYields;
        while upgradeDone < team1HighYieldToUp and triesCount <= 3 do
            _Debug("HighYieldsTeamerBalancing team1HighYieldToUp : ", team1HighYieldToUp, " upgradeDone ", upgradeDone);
            team1Civ = GetShuffledCopyOfTable(team1Civ);
            local terraformedHex = team1Civ[1]:AddHighYieldFromStandard();
            if terraformedHex ~= nil then
                upgradeDone = upgradeDone + 1;
                team1HighYields = team1HighYields + 1;
                _Debug("HighYieldsTeamerBalancing : Added HighYield to ", team1Civ[1].Civ.CivilizationLeader, " on ", terraformedHex:PrintXY());
            else
                _Debug("HighYieldsTeamerBalancing - Failed to add highyield");
                triesCount = triesCount + 1;
            end
        end
    elseif team2HighYields < team1HighYields - highYieldsMargin  then
        local team2HighYieldToUp = team1HighYields - highYieldsMargin - team2HighYields;
        _Debug("HighYieldsTeamerBalancing team2HighYieldToUp : ", team2HighYieldToUp);
        while upgradeDone < team2HighYieldToUp and triesCount <= 3 do
            team2Civ = GetShuffledCopyOfTable(team2Civ);
            local terraformedHex = team2Civ[1]:AddHighYieldFromStandard();
            if terraformedHex ~= nil then
                upgradeDone = upgradeDone + 1;
                team2HighYields = team2HighYields + 1;
                _Debug("HighYieldsTeamerBalancing : Added HighYield to ", team2Civ[1].Civ.CivilizationLeader, " on ", terraformedHex:PrintXY());
            else
                _Debug("HighYieldsTeamerBalancing - Failed to add highyield");
                triesCount = triesCount + 1;
            end
        end
    end    
end
 


-- TODO Please refacto after finish
function SpawnBalancing:BalanceToMean(yieldMargin, standardMargin, unworkableYieldMargin)
    self:GetInnerRingWorkable();
    self.StandardDiff = #self.InnerRingStd + #self.InnerRingHigh - MeansBalancing.MeanInnerStandardYields;
    -- Only affected if we have more unworkable tiles than others
    local innerUnworkableDiff = math.max(0, #self.InnerRingUnworkable - MeansBalancing.MeanInnerRingUnworkable);
    _Debug("Unworkable diff = ", innerUnworkableDiff);
    local unworkableDiff = innerUnworkableDiff * unworkableYieldMargin;
    if self.Civ.IsTundraBias then
        -- Since tundra we can only add food by adding sheeps that the civs do not desire, considere we do not need to balance food
        self.InnerRingFood = MeansBalancing.MeanInnerRingFood
    end
    self.InnerFoodDiff = self.InnerRingFood - MeansBalancing.MeanInnerRingFood + unworkableDiff;
    self.InnerProdDiff = self.InnerRingProd - MeansBalancing.MeanInnerRingProd + unworkableDiff;
    local canAddFood = self.InnerFoodDiff + 1 <= yieldMargin;
    local canRemoveFood = self.InnerFoodDiff - 1 >= -yieldMargin;
    local canAddProd = self.InnerProdDiff + 1 <= yieldMargin;
    local canRemoveProd = self.InnerProdDiff - 1 >= -yieldMargin;
    local canAddStandard = self.StandardDiff + 1 <= standardMargin;
    local canRemoveStandard = self.StandardDiff - 1 >= 0;
    -- Determine what 
    local firstTryRingList;
    local secondTryRingList;
    local firstTryRing;
    local secondTryRing;
    local rngRing = TerrainBuilder.GetRandomNumber(100, "Ring tried");
    -- ADD STANDARD tiles - deficit of either food or prod
    _Debug("BalanceToMean status : self.StandardDiff = ", self.StandardDiff, " self.InnerFoodDiff = ", self.InnerFoodDiff, " self.InnerProdDiff = ", self.InnerProdDiff);
    --if self.StandardDiff + standardMargin < 0 then
    if self.StandardDiff < 0 then
        _Debug("BalanceToMean - Lack of standard tiles")
        -- check priority stat
        if canAddFood == false and canAddProd == false then
            _Debug("BalanceToMean - But can not add food or prod when needing standard");
            --return nil; --will be tune down elsewhere later
        end
        local listLowR1 = self:GetAllOtherWorkableTiles(self.RingTables[1].HexRings);
        local listLowR2 = self:GetAllOtherWorkableTiles(self.RingTables[2].HexRings);
        if rngRing <= 50 then
            firstTryRingList = listLowR1;
            firstTryRing = 1;
            secondTryRingList = listLowR2;
            secondTryRing = 2;
        else
            firstTryRingList = listLowR2;
            firstTryRing = 2;
            secondTryRingList = listLowR1;
            secondTryRing = 1;
        end 

        firstTryRingList = GetShuffledCopyOfTable(firstTryRingList);
        for _, h in ipairs(firstTryRingList) do
            _Debug("Try on r1 ", h:PrintXY());
            if h.ResourceType == g_RESOURCE_NONE and self:TerraformHex(h, firstTryRing, TerraformType[4], 0, false, false, false) then
                _Debug("BalanceToMean - Changed standard added 22 in ring 1");
                return true;
            end
        end
        secondTryRingList = GetShuffledCopyOfTable(secondTryRingList);
        for _, h in ipairs(secondTryRingList) do
            _Debug("Try on r2 ", h:PrintXY());
            if h.ResourceType == g_RESOURCE_NONE and self:TerraformHex(h, secondTryRing, TerraformType[4], 0, false, false, false) then
                _Debug("BalanceToMean - Changed standard added 22 in ring 2");
                return true;
            end
        end
        -- Second try but replacing bonus resources if needed
        firstTryRingList = GetShuffledCopyOfTable(firstTryRingList);
        for _, h in ipairs(firstTryRingList) do
            _Debug("Try on r1 ", h:PrintXY());
            if g_RESOURCES_BONUS_LIST[h.ResourceType] and self:TerraformHex(h, firstTryRing, TerraformType[4], 0, false, true, false) then
                _Debug("BalanceToMean - Changed bonus resource to standard 22 in ring 1");
                return true;
            end
        end
        secondTryRingList = GetShuffledCopyOfTable(secondTryRingList);
        for _, h in ipairs(secondTryRingList) do
            _Debug("Try on r2 ", h:PrintXY());
            if g_RESOURCES_BONUS_LIST[h.ResourceType] and self:TerraformHex(h, secondTryRing, TerraformType[4], 0, false, true, false) then
                _Debug("BalanceToMean - Changed bonus resource to standard 22 in ring 2");
                return true;
            end
        end
        _Debug("BalanceToMean - Could not add standard on empty or bonus resource");

    -- TOO MANY STANDARDS (more than standardMargin)
    elseif self.StandardDiff > standardMargin then
        if canRemoveFood == false and canRemoveProd == false then
            _Debug("BalanceToMean - Too many standard But can not remove food or prod");
            --return false; -- remove on other tiles
        end
        _Debug("BalanceToMean - Too many standard tiles", canRemoveFood, canRemoveProd);

        local listStdR1 = self:GetAllStandardTiles(self.RingTables[1].HexRings);
        local listStdR2 = self:GetAllStandardTiles(self.RingTables[2].HexRings);
        local listHighR1 = self:GetAllHighYieldsTiles(self.RingTables[1].HexRings);
        local listHighR2 = self:GetAllHighYieldsTiles(self.RingTables[2].HexRings);
        AddToTable(listStdR1, listHighR1);
        AddToTable(listStdR2, listHighR2);
        if rngRing <= 33 then
            firstTryRingList = listStdR1;
            firstTryRing = 1;
            secondTryRingList = listStdR2;
            secondTryRing = 2;
        else
            firstTryRingList = listStdR2;
            firstTryRing = 2;
            secondTryRingList = listStdR1;
            secondTryRing = 1;
        end
        -- FOOD CAN BE REMOVED
        if self.InnerFoodDiff >= self.InnerProdDiff and canRemoveFood then
            _Debug("BalanceToMean - Try remove food with add prod = ", canAddProd);
            firstTryRingList = GetShuffledCopyOfTable(firstTryRingList)
            for _, h in ipairs(firstTryRingList) do
                if self:TerraformHex(h, firstTryRing, TerraformType[7], 0, false, false) then
                    _Debug("BalanceToMean - Nerfed standard tile ring 2 to remove food ", h:PrintXY());
                    return true;
                end
            end
            secondTryRingList = GetShuffledCopyOfTable(secondTryRingList)
            for _, h in ipairs(secondTryRingList) do
                if self:TerraformHex(h, secondTryRing, TerraformType[7], 0, false, false) then
                    _Debug("BalanceToMean - Nerfed standard tile ring 1 to remove food ", h:PrintXY());
                    return true;
                end
            end
        -- PROD CAN BE REMOVED
        elseif self.InnerProdDiff >= self.InnerFoodDiff and canRemoveProd then
            _Debug("BalanceToMean - Try remove prod with add food = ", canAddFood);
            firstTryRingList = GetShuffledCopyOfTable(firstTryRingList)
            for _, h in ipairs(firstTryRingList) do
                if self:TerraformHex(h, firstTryRing, TerraformType[9], 0, false, false) then
                    _Debug("BalanceToMean - Nerfed standard tile ring 2 to remove prod ", h:PrintXY());
                    return true;
                end
            end
            secondTryRingList = GetShuffledCopyOfTable(secondTryRingList)
            for _, h in ipairs(secondTryRingList) do
                if self:TerraformHex(h, secondTryRing, TerraformType[9], 0, false, false) then
                    _Debug("BalanceToMean - Nerfed standard tile ring 1 to remove prod ", h:PrintXY());
                    return true;
                end
            end
        end
    end
    -- STANDARD TILE CLOSE TO MEAN + FOOD DIFFERENCE DETECTED
    -- Change yields in existing standards or add in empty
    if math.abs(self.InnerProdDiff) > yieldMargin and math.abs(self.InnerProdDiff) >= math.abs(self.InnerFoodDiff) then
        -- ADD PROD
        local rng = TerrainBuilder.GetRandomNumber(100, "Category");
        local listWorkR1 = self:GetAllOtherWorkableTiles(self.RingTables[1].HexRings);
        local listWorkR2 = self:GetAllOtherWorkableTiles(self.RingTables[2].HexRings);
        if rngRing <= 50 then
            firstTryRingList = listWorkR1;
            firstTryRing = 1;
            secondTryRingList = listWorkR2;
            secondTryRing = 2;
        else
            firstTryRingList = listWorkR2;
            firstTryRing = 2;
            secondTryRingList = listWorkR1;
            secondTryRing = 1;
        end
        if self.InnerProdDiff < -yieldMargin then
            _Debug("BalanceToMean - Try to add prod with remove food = ", canRemoveFood, canAddStandard, rng);            
            -- First, try to add prod to make standard if possible
            if canAddStandard and canRemoveFood == false then
                firstTryRingList = GetShuffledCopyOfTable(firstTryRingList);
                for _, h in ipairs(firstTryRingList) do
                    if self:GetHexBaseFood(h) + self:GetHexBaseProd(h) == 3 and self:TerraformHex(h, firstTryRing, TerraformType[8], 0, canRemoveFood, false) then
                        _Debug("BalanceToMean - Added prod on flat tile with canRemoveFood ", canRemoveFood);
                        return true;
                    end
                end
                secondTryRingList = GetShuffledCopyOfTable(secondTryRingList);
                for _, h in ipairs(secondTryRingList) do
                    if self:GetHexBaseFood(h) + self:GetHexBaseProd(h) == 3 and self:TerraformHex(h, secondTryRing, TerraformType[8], 0, canRemoveFood, false) then
                        _Debug("BalanceToMean - Added prod on flat tile with canRemoveFood ", canRemoveFood);
                        return true;
                    end
                end
                -- If can not add standard, change workables
                for _, h in ipairs(firstTryRingList) do
                    if self:TerraformHex(h, firstTryRing, TerraformType[8], 0, canRemoveFood, false) then
                        _Debug("BalanceToMean - Added prod on workable tile with canRemoveProd ", canRemoveProd);
                        return true;
                    end
                end
                for _, h in ipairs(secondTryRingList) do
                    if self:TerraformHex(h, secondTryRing, TerraformType[8], 0, canRemoveFood, false) then
                        _Debug("BalanceToMean - Added prod on workable tile with canRemoveProd ", canRemoveProd);
                        return true;
                    end
                end
            -- Randomly try either change any workable tile or 
            elseif canRemoveFood then
                firstTryRingList = GetShuffledCopyOfTable(firstTryRingList);
                for _, h in ipairs(firstTryRingList) do
                    if self:TerraformHex(h, firstTryRing, TerraformType[8], 0, canRemoveFood, false) then
                        _Debug("BalanceToMean - Added prod on flat tile with canRemoveFood ", canRemoveFood);
                        return true;
                    end
                end
                secondTryRingList = GetShuffledCopyOfTable(secondTryRingList);
                for _, h in ipairs(secondTryRingList) do
                    if self:TerraformHex(h, secondTryRing, TerraformType[8], 0, canRemoveFood, false) then
                        _Debug("BalanceToMean - Added prod on flat tile with canRemoveFood ", canRemoveFood);
                        return true;
                    end
                end
                -- Change existing standard tiles if not possible on any workable
                local listStdR1 = self:GetAllStandardTiles(self.RingTables[1].HexRings);
                local listStdR2 = self:GetAllStandardTiles(self.RingTables[2].HexRings);
                if rngRing <= 50 then
                    firstTryRingList = listStdR1;
                    firstTryRing = 1;
                    secondTryRingList = listStdR2;
                    secondTryRing = 2;
                else
                    firstTryRingList = listStdR2;
                    firstTryRing = 2;
                    secondTryRingList = listStdR1;
                    secondTryRing = 1;
                end
                firstTryRingList = GetShuffledCopyOfTable(firstTryRingList);
                for _, h in ipairs(firstTryRingList) do
                    if self:TerraformHex(h, firstTryRing, TerraformType[8], 0, canRemoveFood, false) then
                        _Debug("BalanceToMean - Changed standard ring 2 added prod with canRemoveFood ", canRemoveFood);
                        return true;
                    end
                end
                secondTryRingList = GetShuffledCopyOfTable(secondTryRingList);
                for _, h in ipairs(secondTryRingList) do
                    if self:TerraformHex(h, secondTryRing, TerraformType[8], 0, canRemoveFood, false) then
                        _Debug("BalanceToMean - Changed standard ring 1 added prod with canRemoveFood ", canRemoveFood);
                        return true;
                    end
                end
            -- can not remove food or add standard so try top add on low yield tile that can not become standard 
            else
                firstTryRingList = GetShuffledCopyOfTable(firstTryRingList);
                for _, h in ipairs(firstTryRingList) do
                    if self:GetHexBaseFood(h) + self:GetHexBaseProd(h) < 3 and self:TerraformHex(h, firstTryRing, TerraformType[8], 0, canRemoveFood, false) then
                        _Debug("BalanceToMean - Added prod on flat tile with canRemoveFood ", canRemoveFood);
                        return true;
                    end
                end
                secondTryRingList = GetShuffledCopyOfTable(secondTryRingList);
                for _, h in ipairs(secondTryRingList) do
                    if self:GetHexBaseFood(h) + self:GetHexBaseProd(h) < 3 and self:TerraformHex(h, secondTryRing, TerraformType[8], 0, canRemoveFood, false) then
                        _Debug("BalanceToMean - Added prod on flat tile with canRemoveFood ", canRemoveFood);
                        return true;
                    end
                end
            end 
        elseif self.InnerProdDiff > yieldMargin then
            -- REMOVE PROD
            -- RNG 1 : Try to remove prod on a flat tile
            _Debug("BalanceToMean Std ok - Try to remove prod, canAddFood ", canAddFood, rng);
            if canRemoveStandard then
                local listStdR1 = self:GetAllStandardTiles(self.RingTables[1].HexRings);
                local listStdR2 = self:GetAllStandardTiles(self.RingTables[2].HexRings);
                local listHighR1 = self:GetAllHighYieldsTiles(self.RingTables[1].HexRings);
                local listHighR2 = self:GetAllHighYieldsTiles(self.RingTables[2].HexRings);
                AddToTable(listStdR1, listHighR1);
                AddToTable(listStdR2, listHighR2);
                if rngRing <= 50 then
                    firstTryRingList = listStdR1;
                    firstTryRing = 1;
                    secondTryRingList = listStdR2;
                    secondTryRing = 2;
                else
                    firstTryRingList = listStdR2;
                    firstTryRing = 2;
                    secondTryRingList = listStdR1;
                    secondTryRing = 1;
                end
                firstTryRingList = GetShuffledCopyOfTable(firstTryRingList);
                for _, h in ipairs(firstTryRingList) do
                    if self:TerraformHex(h, firstTryRing, TerraformType[9], 0, canAddFood, false) then
                        _Debug("BalanceToMean - Changed standard ring 2 removed prod with canAddFood ", canAddFood);
                        return true;
                    end
                end
                secondTryRingList = GetShuffledCopyOfTable(secondTryRingList);
                for _, h in ipairs(secondTryRingList) do
                    if self:TerraformHex(h, secondTryRing, TerraformType[9], 0, canAddFood, false) then
                        _Debug("BalanceToMean - Changed standard ring 1 removed prod with canAddFood ", canAddFood);
                        return true;
                    end
                end
            end
            if rngRing <= 33 then
                firstTryRingList = listWorkR1;
                firstTryRing = 1;
                secondTryRingList = listWorkR2;
                secondTryRing = 2;
            else
                firstTryRingList = listWorkR2;
                firstTryRing = 2;
                secondTryRingList = listWorkR1;
                secondTryRing = 1;
            end
            firstTryRingList = GetShuffledCopyOfTable(firstTryRingList);
            for _, h in ipairs(firstTryRingList) do
                local terraformedHex = self:TerraformHex(h, firstTryRing, TerraformType[9], 0, canAddFood, false);
                if terraformedHex ~= nil then
                    _Debug("BalanceToMean - Removed prod on ring 2 tile with canAddFood ", canAddFood);
                    return true;
                end
            end
            secondTryRingList = GetShuffledCopyOfTable(secondTryRingList);
            for _, h in ipairs(secondTryRingList) do
                local terraformedHex = self:TerraformHex(h, secondTryRing, TerraformType[9], 0, canAddFood, false);
                if terraformedHex ~= nil then
                    _Debug("BalanceToMean - Removed prod on ring 1 tile with canAddFood ", canAddFood);
                    return true;
                end
            end
        end
        -- Change yields in existing standards or add in empty
    elseif math.abs(self.InnerFoodDiff) > yieldMargin and math.abs(self.InnerFoodDiff) >= math.abs(self.InnerProdDiff) then
        local rng = TerrainBuilder.GetRandomNumber(100, "Category");
        local listWorkR1 = self:GetAllOtherWorkableTiles(self.RingTables[1].HexRings);
        local listWorkR2 = self:GetAllOtherWorkableTiles(self.RingTables[2].HexRings);
        if rngRing <= 50 then
            firstTryRingList = listWorkR1;
            firstTryRing = 1;
            secondTryRingList = listWorkR2;
            secondTryRing = 2;
        else
            firstTryRingList = listWorkR2;
            firstTryRing = 2;
            secondTryRingList = listWorkR1;
            secondTryRing = 1;
        end
        -- ADD FOOD
        if self.InnerFoodDiff < -yieldMargin then
            _Debug("BalanceToMean - Try to add food with remove prod = ", canRemoveProd, rng);
            -- First, try to add prod to make standard if possible
            if canAddStandard and canRemoveProd == false then
                -- Try any tiles even if can become standard
                firstTryRingList = GetShuffledCopyOfTable(firstTryRingList);
                for _, h in ipairs(firstTryRingList) do
                    if self:GetHexBaseFood(h) + self:GetHexBaseProd(h) == 3 and self:TerraformHex(h, firstTryRing, TerraformType[6], 0, canRemoveProd, false) then
                        _Debug("BalanceToMean - Added food on 3yields with canRemoveProd ", canRemoveProd);
                        return true;
                    end
                end
                secondTryRingList = GetShuffledCopyOfTable(secondTryRingList);
                for _, h in ipairs(secondTryRingList) do
                    if self:GetHexBaseFood(h) + self:GetHexBaseProd(h) == 3 and self:TerraformHex(h, secondTryRing, TerraformType[6], 0, canRemoveProd, false) then
                        _Debug("BalanceToMean - Added food on 3yields tile with canRemoveProd ", canRemoveProd);
                        return true;
                    end
                end
                -- If can not add standard, change workables
                for _, h in ipairs(firstTryRingList) do
                    if self:TerraformHex(h, firstTryRing, TerraformType[6], 0, canRemoveProd, false) then
                        _Debug("BalanceToMean - Added food on workable tile with canRemoveProd ", canRemoveProd);
                        return true;
                    end
                end
                for _, h in ipairs(secondTryRingList) do
                    if self:TerraformHex(h, secondTryRing, TerraformType[6], 0, canRemoveProd, false) then
                        _Debug("BalanceToMean - Added food on workable tile with canRemoveProd ", canRemoveProd);
                        return true;
                    end
                end
            -- Try to buff any workable tiles and then change standard
            elseif canRemoveProd then
                firstTryRingList = GetShuffledCopyOfTable(firstTryRingList);
                for _, h in ipairs(firstTryRingList) do
                    if self:TerraformHex(h, firstTryRing, TerraformType[6], 0, canRemoveProd, false) then
                        _Debug("BalanceToMean - Added prod on flat tile with canRemoveProd ", canRemoveProd);
                        return true;
                    end
                end
                secondTryRingList = GetShuffledCopyOfTable(secondTryRingList);
                for _, h in ipairs(secondTryRingList) do
                    if self:TerraformHex(h, secondTryRing, TerraformType[6], 0, canRemoveProd, false) then
                        _Debug("BalanceToMean - Added prod on flat tile with canRemoveProd ", canRemoveProd);
                        return true;
                    end
                end
                -- Change existing standard tiles
                local listStdR1 = self:GetAllStandardTiles(self.RingTables[1].HexRings);
                local listStdR2 = self:GetAllStandardTiles(self.RingTables[2].HexRings);
                if rngRing <= 50 then
                    firstTryRingList = listStdR1;
                    firstTryRing = 1;
                    secondTryRingList = listStdR2;
                    secondTryRing = 2;
                else
                    firstTryRingList = listStdR2;
                    firstTryRing = 2;
                    secondTryRingList = listStdR1;
                    secondTryRing = 1;
                end
                firstTryRingList = GetShuffledCopyOfTable(firstTryRingList);
                for _, h in ipairs(firstTryRingList) do
                    if self:TerraformHex(h, firstTryRing, TerraformType[6], 0, canRemoveProd, false) then
                        _Debug("BalanceToMean - Changed standard ring 2 added prod with canRemoveProd ", canRemoveProd);
                        return true;
                    end
                end
                secondTryRingList = GetShuffledCopyOfTable(secondTryRingList);
                for _, h in ipairs(secondTryRingList) do
                    if self:TerraformHex(h, secondTryRing, TerraformType[6], 0, canRemoveProd, false) then
                        _Debug("BalanceToMean - Changed standard ring 1 added prod with canRemoveProd ", canRemoveProd);
                        return true;
                    end
                end
            else
                firstTryRingList = GetShuffledCopyOfTable(firstTryRingList);
                for _, h in ipairs(firstTryRingList) do
                    if self:GetHexBaseFood(h) + self:GetHexBaseProd(h) < 3 and self:TerraformHex(h, firstTryRing, TerraformType[6], 0, canRemoveProd, false) then
                        _Debug("BalanceToMean - Added food on < 3y tile with canRemoveProd ", canRemoveProd);
                        return true;
                    end
                end
                secondTryRingList = GetShuffledCopyOfTable(secondTryRingList);
                for _, h in ipairs(secondTryRingList) do
                    if self:GetHexBaseFood(h) + self:GetHexBaseProd(h) < 3 and self:TerraformHex(h, secondTryRing, TerraformType[6], 0, canRemoveProd, false) then
                        _Debug("BalanceToMean - Added food on < 3y tile with canRemoveProd ", canRemoveProd);
                        return true;
                    end
                end                
            end 
        -- REMOVE FOOD
        elseif self.InnerFoodDiff > yieldMargin then
            _Debug("BalanceToMean Std ok - Try to remove food, canAddProd ", canAddProd, rng, canRemoveStandard);
            _Debug("BalanceToMean number of workable r2 ", #listWorkR2);
            _Debug("BalanceToMean number of workable r1 ", #listWorkR1);
            -- CAN NERF A STANDARD
            if canRemoveStandard then
                _Debug("BalanceToMean Std ok - Try to nerf standard, canAddProd ", canAddProd, rng, canRemoveStandard);
                local listStdR1 = self:GetAllStandardTiles(self.RingTables[1].HexRings);
                local listStdR2 = self:GetAllStandardTiles(self.RingTables[2].HexRings);
                local listHighR1 = self:GetAllHighYieldsTiles(self.RingTables[1].HexRings);
                local listHighR2 = self:GetAllHighYieldsTiles(self.RingTables[2].HexRings);
                AddToTable(listStdR1, listHighR1);
                AddToTable(listStdR2, listHighR2);
                if rngRing <= 33 then
                    firstTryRingList = listStdR1;
                    firstTryRing = 1;
                    secondTryRingList = listStdR2;
                    secondTryRing = 2;
                else
                    firstTryRingList = listStdR2;
                    firstTryRing = 2;
                    secondTryRingList = listStdR1;
                    secondTryRing = 1;
                end
                firstTryRingList = GetShuffledCopyOfTable(firstTryRingList);
                for _, h in ipairs(firstTryRingList) do
                    if self:TerraformHex(h, firstTryRing, TerraformType[7], 0, canAddProd, false) then
                        _Debug("BalanceToMean - Changed standard ring 2 removed food with addProd ", canAddProd);
                        return true;
                    end
                end
                secondTryRingList = GetShuffledCopyOfTable(secondTryRingList);
                for _, h in ipairs(secondTryRingList) do
                    if self:TerraformHex(h, secondTryRing, TerraformType[7], 0, canAddProd, false) then
                        _Debug("BalanceToMean - Changed standard ring 1 removed food with addProd ", canAddProd);
                        return true;
                    end
                end
            end
            if rngRing <= 50 then
                firstTryRingList = listWorkR1;
                firstTryRing = 1;
                secondTryRingList = listWorkR2;
                secondTryRing = 2;
            else
                firstTryRingList = listWorkR2;
                firstTryRing = 2;
                secondTryRingList = listWorkR1;
                secondTryRing = 1;
            end
            -- After trying to nerf standard if allowed, try to nerf any workable
            _Debug("BalanceToMean - Try to nerf food on workable, canAddProd ", canAddProd, rng, canRemoveStandard);
            firstTryRingList = GetShuffledCopyOfTable(firstTryRingList);
            for _, h in ipairs(firstTryRingList) do
                local terraformedHex = self:TerraformHex(h, firstTryRing, TerraformType[7], 0, canAddProd, false);
                if terraformedHex ~= nil then
                    _Debug("BalanceToMean - Removed food on ring 2 tile with canAddProd ", canAddProd, terraformedHex:PrintXY());
                    return true;
                end
            end
            secondTryRingList = GetShuffledCopyOfTable(secondTryRingList);
            for _, h in ipairs(secondTryRingList) do
                local terraformedHex = self:TerraformHex(h, secondTryRing, TerraformType[7], 0, canAddProd, false);
                if terraformedHex ~= nil then
                    _Debug("BalanceToMean - Removed food on ring 1 tile with canAddProd ", canAddProd, terraformedHex:PrintXY());
                    return true;
                end
            end
        end
    end
    _Debug("BalanceToMean - Updated nothing");
    return false;
end

function SpawnBalancing:InnerRingBalanceStep(listHexR1, listHexR2, terraformType, bool1)
    local rng = TerrainBuilder.GetRandomNumber(100, "Random ring selection");
    -- Ring 1 before 2
    if rng <= 50 then
        if self:TryTerraformMeanStep(listHexR1, 1, terraformType, bool1) ~= nil then
            return true;
        end
        if self:TryTerraformMeanStep(listHexR2, 2, terraformType, bool1) ~= nil then
            return true;
        end
    -- Ring 2 before 1    
    else 
        if self:TryTerraformMeanStep(listHexR2, 2, terraformType, bool1) ~= nil then
            return true;
        end
        if self:TryTerraformMeanStep(listHexR1, 1, terraformType, bool1) ~= nil then
            return true;
        end
    end
    return false;
end 

function SpawnBalancing:TryTerraformMeanStep(listHex, ring, terraformType, bool1)
    listHex = GetShuffledCopyOfTable(listHex);
    for _, h in ipairs(listHex) do
        local terraformedHex = self:TerraformHex(h, ring, terraformType, 0, bool1, false);
        if terraformedHex ~= nil then
            return terraformedHex;
        end
    end
    return nil;
end


function SpawnBalancing:GetInnerRingWorkable()
    _Debug("GetInnerRingWorkable ", self.Civ.CivilizationLeader, self.Hex:PrintXY())
    local innerRingWorkable = {};
    AddToTable(innerRingWorkable, self:GetAllOtherWorkableTiles(self.RingTables[1].HexRings));
    AddToTable(innerRingWorkable, self:GetAllOtherWorkableTiles(self.RingTables[2].HexRings));
    local innerRingStd = {};
    AddToTable(innerRingStd, self:GetAllStandardTiles(self.RingTables[1].HexRings));
    AddToTable(innerRingStd, self:GetAllStandardTiles(self.RingTables[2].HexRings));
    local innerRingHigh = {};
    AddToTable(innerRingHigh, self:GetAllHighYieldsTiles(self.RingTables[1].HexRings));
    AddToTable(innerRingHigh, self:GetAllHighYieldsTiles(self.RingTables[2].HexRings));
    local innerRingUnworkable = {};
    AddToTable(innerRingUnworkable, self:GetAllUnworkableTiles(self.RingTables[1].HexRings));
    AddToTable(innerRingUnworkable, self:GetAllUnworkableTiles(self.RingTables[2].HexRings));
    local innerRingFood = self:GetTotalFood(self.RingTables[1].HexRings) + self:GetTotalFood(self.RingTables[2].HexRings);
    local innerRingProd = self:GetTotalProd(self.RingTables[1].HexRings) + self:GetTotalProd(self.RingTables[2].HexRings);
    local totalInnerTiles = 18 - #innerRingUnworkable;

    _Debug("GetInnerRingWorkable : Total unworkable/total = ", #innerRingUnworkable, totalInnerTiles, " Total workable = ", #innerRingWorkable, " Total standard = ", #innerRingStd, " Total high yields = ", #innerRingHigh);
    _Debug("GetInnerRingWorkable : Total food = ", innerRingFood, " Total prod = ", innerRingProd);

    self.InnerRingUnworkable = innerRingUnworkable;
    self.InnerRingWorkable = innerRingWorkable;
    self.InnerRingStd = innerRingStd;
    self.InnerRingHigh = innerRingHigh;
    self.InnerRingFood = innerRingFood;
    self.InnerRingProd = innerRingProd;

end


function SpawnBalancing:GetOuterRingWorkable()
    _Debug("GetOuterRingWorkable ", self.Civ.CivilizationLeader, self.Hex:PrintXY())
    local outerRingUnworkable = {};
    AddToTable(outerRingUnworkable, self:GetAllUnworkableTiles(self.RingTables[3].HexRings));
    AddToTable(outerRingUnworkable, self:GetAllUnworkableTiles(self.RingTables[4].HexRings));
    AddToTable(outerRingUnworkable, self:GetAllUnworkableTiles(self.RingTables[5].HexRings));
    AddToTable(outerRingUnworkable, self:GetAllUnworkableTiles(self.RingTables[6].HexRings));
    local outerRingWorkable = {};
    AddToTable(outerRingWorkable, self:GetAllOtherWorkableTiles(self.RingTables[3].HexRings));
    AddToTable(outerRingWorkable, self:GetAllOtherWorkableTiles(self.RingTables[4].HexRings));
    AddToTable(outerRingWorkable, self:GetAllOtherWorkableTiles(self.RingTables[5].HexRings));
    AddToTable(outerRingWorkable, self:GetAllOtherWorkableTiles(self.RingTables[6].HexRings));
    local outerRingStd = {};
    AddToTable(outerRingStd, self:GetAllStandardTiles(self.RingTables[3].HexRings));
    AddToTable(outerRingStd, self:GetAllStandardTiles(self.RingTables[4].HexRings));
    AddToTable(outerRingStd, self:GetAllStandardTiles(self.RingTables[5].HexRings));
    AddToTable(outerRingStd, self:GetAllStandardTiles(self.RingTables[6].HexRings));
    local outerRingHigh = {};
    AddToTable(outerRingHigh, self:GetAllHighYieldsTiles(self.RingTables[3].HexRings));
    AddToTable(outerRingHigh, self:GetAllHighYieldsTiles(self.RingTables[4].HexRings));
    AddToTable(outerRingHigh, self:GetAllHighYieldsTiles(self.RingTables[5].HexRings));
    AddToTable(outerRingHigh, self:GetAllHighYieldsTiles(self.RingTables[6].HexRings));

    local outerRingFood = self:GetTotalFood(self.RingTables[3].HexRings) + self:GetTotalFood(self.RingTables[4].HexRings) + self:GetTotalFood(self.RingTables[5].HexRings) + self:GetTotalFood(self.RingTables[6].HexRings);
    local outerRingProd = self:GetTotalProd(self.RingTables[3].HexRings) + self:GetTotalProd(self.RingTables[4].HexRings) + self:GetTotalProd(self.RingTables[5].HexRings) + self:GetTotalProd(self.RingTables[6].HexRings);
    local totalOuterTiles = 108 - #outerRingUnworkable;

    _Debug("GetOuterRingWorkable : Total unworkable/total = ", #outerRingUnworkable,  totalOuterTiles, " Total workable = ", #outerRingWorkable, " Total standard = ", #outerRingStd, " Total high yields = ", #outerRingHigh)
    _Debug("GetOuterRingWorkable : Total food = ", outerRingFood, " Total prod = ", outerRingProd)

    self.OuterRingUnworkable = outerRingUnworkable;
    self.OuterRingWorkable = outerRingWorkable;
    self.OuterRingStd = outerRingStd;
    self.OuterRingHigh = outerRingHigh;
    self.OuterRingFood = outerRingFood;
    self.OuterRingProd = outerRingProd;
end



function SpawnBalancing:GetAllUnworkableTiles(listHex)
    local unworkableList = {}
    for i = 1, #listHex do
        local hex = listHex[i];
        -- TODO is reef ok ?
        if hex:IsMountain() or (hex:IsWater() and hex.FeatureType == g_FEATURE_NONE and hex.ResourceType == g_RESOURCE_NONE) then
            --_Debug("Unworkable found ", hex:PrintXY(), hex.TerrainType, hex.FeatureType, hex.ResourceType)
            table.insert(unworkableList, hex);
        end
    end
    return unworkableList;
end

-- Get any <= 3 yields (with or without extra yields), include empty or feature tiles or lux <= 4yields
function SpawnBalancing:GetAllOtherWorkableTiles(listHex)
    local workableList = {}
    for i = 1, #listHex do
        local hex = listHex[i];
        -- Other workable <3 yields by default, from empty flat tiles to any feature or resource in water
        if self:GetHexBaseFood(hex) + self:GetHexBaseProd(hex) <= 3 and hex:IsMountain() == false
                and (hex:IsWater() == false or (hex:IsWater() and hex.ResourceType ~= g_RESOURCE_NONE)) then
            --_Debug("Workable found ", hex:PrintXY(), hex.TerrainType, hex.FeatureType, hex.ResourceType)
            table.insert(workableList, hex);
        end
    end
    return workableList;
end

function SpawnBalancing:GetAllStandardTiles(listHex)
    local standardsList = {}
    for i = 1, #listHex do
        local hex = listHex[i];
        -- 4yields or fishreef or turtles
        local isReefFishOrTurtle = (hex.ResourceType == g_RESOURCE_FISH or hex.ResourceType == g_RESOURCE_TURTLES) and hex.FeatureType == g_FEATURE_REEF;
        if isReefFishOrTurtle or ((self:GetHexBaseFood(hex) + self:GetHexBaseProd(hex) == 4) and hex.ExtraYield == false) then
            --_Debug("Standard yield found ", hex:PrintXY(), hex.TerrainType, hex.FeatureType, hex.ResourceType)
            table.insert(standardsList, hex);
        end
    end
    return standardsList;
end

function SpawnBalancing:GetAllHighYieldsTiles(listHex)
    local highYieldsList = {}
    for i = 1, #listHex do
        local hex = listHex[i];
        -- 4+ yields, 4yields+extra, 4food, fish reef or turtles
        if self:GetHexBaseFood(hex) + self:GetHexBaseProd(hex) > 4
                or (self:GetHexBaseFood(hex) + self:GetHexBaseProd(hex) >= 4 and hex.ExtraYield) then
            --_Debug("High yield found ", hex:PrintXY(), hex.TerrainType, hex.FeatureType, hex.ResourceType, hex.ExtraYield)
            table.insert(highYieldsList, hex);
        end
    end
    return highYieldsList;
end

function SpawnBalancing:GetTotalFood(listHex)
    local totalFood = 0;
    for i = 1, #listHex do
        local hex = listHex[i];
        if hex:IsWater() == false or (hex:IsWater() and hex.ResourceType ~= g_RESOURCE_NONE) then
            totalFood = totalFood + self:GetHexBaseFood(hex)
        end
    end
    return totalFood;
end

function SpawnBalancing:GetTotalProd(listHex)
    local totalProd = 0;
    for i = 1, #listHex do
        local hex = listHex[i];
        if hex:IsWater() == false or (hex:IsWater() and hex.ResourceType ~= g_RESOURCE_NONE) then
            totalProd = totalProd + self:GetHexBaseProd(hex)
        end
    end
    _Debug("GetTotalProd for size ", #listHex, totalProd)
    return totalProd;
end

-- Increase the coastal score based on difference between aimed coastal score and current score
function SpawnBalancing:ImproveCoastal()
    if self.AimedCoastalScore == 0 or self.CoastalScore == 0 then
        return
    end
    _Debug("ImproveCoastal diff score = "..tostring(self.AimedCoastalScore - self.CoastalScore).." for "..tostring(self.Civ.CivilizationLeader))
    while math.abs(self.AimedCoastalScore - self.CoastalScore) > CoastalScoring.COASTAL_MARGIN do
        -- stepDone used as a break to loop over while
        local stepDone = false;
        -- Test highest score first ?
        local waterRFRing2 = GetShuffledCopyOfTable(self.RingTables[2].WATER_RF);
        for _, h in pairs(waterRFRing2) do
            if h.ResourceType == g_RESOURCE_FISH and h.FeatureType == g_FEATURE_NONE
                and self:CanAddToCoastalScore(CoastalScoring.FISH_REEF_R2 - CoastalScoring.FISH_R2) then
                self:TerraformHex(h, 2, TerraformType[2], g_FEATURE_REEF, true, false);
                self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_FISH, true, false);
                self:UpdateCoastalScore(CoastalScoring.FISH_REEF_R2 - CoastalScoring.FISH_R2)
                stepDone = true;
                _Debug(h:PrintXY().." ImproveCoastal - Fish to FishReef R2")
            elseif h.ResourceType == g_RESOURCE_NONE and h.FeatureType == g_FEATURE_REEF
                and self:CanAddToCoastalScore(CoastalScoring.FISH_REEF_R2 - CoastalScoring.REEF_R2) then
                self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_FISH, true, false);
                self:UpdateCoastalScore(CoastalScoring.FISH_REEF_R2 - CoastalScoring.REEF_R2)
                stepDone = true;
                _Debug(h:PrintXY().." ImproveCoastal - Reef to FishReef R2")
            elseif h.ResourceType == g_RESOURCE_CRABS then
                if self:CanAddToCoastalScore(CoastalScoring.FISH_REEF_R2 - CoastalScoring.CRABS_R2) then
                    self:TerraformHex(h, 2, TerraformType[2], g_FEATURE_REEF, true, false);
                    self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_FISH, true, false);
                    self:UpdateCoastalScore(CoastalScoring.FISH_REEF_R2 - CoastalScoring.CRABS_R2)
                    stepDone = true;
                    _Debug(h:PrintXY().." ImproveCoastal - Crab to FishReef R2")
                elseif self:CanAddToCoastalScore(CoastalScoring.FISH_R2 - CoastalScoring.CRABS_R2) then
                    self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_FISH, true, false);
                    self:UpdateCoastalScore(CoastalScoring.FISH_R2 - CoastalScoring.CRABS_R2)
                    stepDone = true;
                    _Debug(h:PrintXY().." ImproveCoastal - Crab to Fish R2")
                end
            end
        end

        if stepDone == false then
            local waterRFRing3 = GetShuffledCopyOfTable(self.RingTables[3].WATER_RF);
            for _, h in pairs(waterRFRing3) do
                if h.ResourceType == g_RESOURCE_FISH and h.FeatureType == g_FEATURE_NONE
                    and self:CanAddToCoastalScore(CoastalScoring.FISH_REEF_R3 - CoastalScoring.FISH_R3) then
                    -- TODO add calculations costal score
                    self:TerraformHex(h, 3, TerraformType[2], g_FEATURE_REEF, true, false);
                    self:TerraformHex(h, 3, TerraformType[3], g_RESOURCE_FISH, true, false);
                    self:UpdateCoastalScore(CoastalScoring.FISH_REEF_R3 - CoastalScoring.FISH_R3)
                    stepDone = true;
                    _Debug(h:PrintXY().." ImproveCoastal - Fish to FishReef R3")
                elseif h.ResourceType == g_RESOURCE_NONE and h.FeatureType == g_FEATURE_REEF
                    and self:CanAddToCoastalScore(CoastalScoring.FISH_REEF_R3 - CoastalScoring.REEF_R3) then
                    self:TerraformHex(h, 3, TerraformType[3], g_RESOURCE_FISH, true, false);
                    self:UpdateCoastalScore(CoastalScoring.FISH_REEF_R3 - CoastalScoring.REEF_R3)
                    stepDone = true;
                    _Debug(h:PrintXY().." ImproveCoastal - Reef to FishReef R3")
                elseif h.ResourceType == g_RESOURCE_CRABS then
                    if self:CanAddToCoastalScore(CoastalScoring.FISH_REEF_R3 - CoastalScoring.CRABS_R3) then
                        self:TerraformHex(h, 3, TerraformType[2], g_FEATURE_REEF, true, false);
                        self:TerraformHex(h, 3, TerraformType[3], g_RESOURCE_FISH, true, false);
                        self:UpdateCoastalScore(CoastalScoring.FISH_REEF_R3 - CoastalScoring.CRABS_R3)
                        stepDone = true;
                        _Debug(h:PrintXY().." ImproveCoastal - Crab to FishReef R3")
                    elseif self:CanAddToCoastalScore(CoastalScoring.FISH_R3 - CoastalScoring.CRABS_R3) then
                        self:TerraformHex(h, 3, TerraformType[3], g_RESOURCE_FISH, true, false);
                        self:UpdateCoastalScore(CoastalScoring.FISH_R3 - CoastalScoring.CRABS_R3)
                        stepDone = true;
                        _Debug(h:PrintXY().." ImproveCoastal - Crab to Fish R3")
                    end
                end
            end
        end

        if stepDone == false then
            local waterEmptyRing2 = GetShuffledCopyOfTable(self.RingTables[2].WATER_EMPTY);
            for _, h in pairs(waterEmptyRing2) do
                -- Fish reef test -- TODO if reef is near coast ?
                if self:CanAddToCoastalScore(CoastalScoring.FISH_REEF_R2) then
                    self:TerraformHex(h, 2, TerraformType[2], g_FEATURE_REEF, true, false);
                    self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_FISH, true, false);
                    self:UpdateCoastalScore(CoastalScoring.FISH_REEF_R2)
                    stepDone = true;
                    _Debug(h:PrintXY().." ImproveCoastal - Empty to FishReef R2")
                elseif self:CanAddToCoastalScore(CoastalScoring.FISH_R2) then
                    self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_FISH, true, false);
                    self:UpdateCoastalScore(CoastalScoring.FISH_R2)
                    stepDone = true;
                    _Debug(h:PrintXY().." ImproveCoastal - Empty to Fish R2")
                elseif self:CanAddToCoastalScore(CoastalScoring.CRABS_R2) then
                    self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_CRABS, true, false);
                    self:UpdateCoastalScore(CoastalScoring.CRABS_R2)
                    stepDone = true;
                    _Debug(h:PrintXY().." ImproveCoastal - Empty to Crab R2")
                elseif self:CanAddToCoastalScore(CoastalScoring.REEF_R2) then
                    self:TerraformHex(h, 2, TerraformType[2], g_FEATURE_REEF, true, false);
                    self:UpdateCoastalScore(CoastalScoring.REEF_R2)
                    stepDone = true;
                    _Debug(h:PrintXY().." ImproveCoastal - Empty to Reef R2")
                end
            end
        end

        if stepDone == false then
            local waterEmptyRing3 = GetShuffledCopyOfTable(self.RingTables[3].WATER_EMPTY);
            for _, h in pairs(waterEmptyRing3) do
                -- Fish reef test -- TODO if reef is near coast ?
                if self:CanAddToCoastalScore(CoastalScoring.FISH_REEF_R3) then
                    self:TerraformHex(h, 3, TerraformType[2], g_FEATURE_REEF, true, false);
                    self:TerraformHex(h, 3, TerraformType[3], g_RESOURCE_FISH, true, false);
                    self:UpdateCoastalScore(CoastalScoring.FISH_REEF_R3)
                    stepDone = true;
                    _Debug(h:PrintXY().." ImproveCoastal - Empty to FishReef R3")
                elseif self:CanAddToCoastalScore(CoastalScoring.FISH_R3) then
                    self:TerraformHex(h, 3, TerraformType[3], g_RESOURCE_FISH, true, false);
                    self:UpdateCoastalScore(CoastalScoring.FISH_R3)
                    stepDone = true;
                    _Debug(h:PrintXY().." ImproveCoastal - Empty to Fish R3")
                elseif self:CanAddToCoastalScore(CoastalScoring.CRABS_R3) then
                    self:TerraformHex(h, 3, TerraformType[3], g_RESOURCE_CRABS, true, false);
                    self:UpdateCoastalScore(CoastalScoring.CRABS_R3)
                    stepDone = true;
                    _Debug(h:PrintXY().." ImproveCoastal - Empty to Crab R3")
                elseif self:CanAddToCoastalScore(CoastalScoring.REEF_R3) then
                    self:TerraformHex(h, 3, TerraformType[2], g_FEATURE_REEF, true, false);
                    self:UpdateCoastalScore(CoastalScoring.REEF_R3)
                    stepDone = true;
                    _Debug(h:PrintXY().." ImproveCoastal - Empty to Reef R3")
                end
            end
        end
        -- if nothing else could be done
        if stepDone == false then
            _Debug("ImproveCoastal - could not nerf further, aimed = "..tostring(self.AimedCoastalScore).." score = "..tostring(self.CoastalScore))
            break
        end
    end
end

function SpawnBalancing:NerfCoastal()
    if self.AimedCoastalScore == 0 or self.CoastalScore == 0 then
        return
    end
    while math.abs(self.AimedCoastalScore - self.CoastalScore) > CoastalScoring.COASTAL_MARGIN do
        _Debug("NerfCoastal diff score = "..tostring(self.CoastalScore - self.AimedCoastalScore))
        -- stepDone used as a break to loop over while
        local stepDone = false;
        _Debug("NerfCoastal RingTables[2].WATER_RF = "..tostring(#self.RingTables[2].WATER_RF))
        local waterRFRing2 = GetShuffledCopyOfTable(self.RingTables[2].WATER_RF);
        for _, h in pairs(waterRFRing2) do
            if h.IsTaggedAsMinimum == false then
                if h.ResourceType == g_RESOURCE_FISH and h.FeatureType == g_FEATURE_REEF then
                    if self:CanAddToCoastalScore(- CoastalScoring.FISH_REEF_R2) and self:CanNerfFishR2() then
                        self:TerraformHex(h, 2, TerraformType[2], g_FEATURE_NONE, true, false);
                        self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_NONE, true, false);
                        self:UpdateCoastalScore(- CoastalScoring.FISH_REEF_R2)
                        stepDone = true;
                        _Debug(h:PrintXY().." NerfCoastal - FishReef to Empty R2");
                    elseif self:CanAddToCoastalScore(CoastalScoring.REEF_R2 - CoastalScoring.FISH_REEF_R2) and self:CanNerfFishR2() then
                        self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_NONE, true, false);
                        self:UpdateCoastalScore(CoastalScoring.REEF_R2 - CoastalScoring.FISH_REEF_R2)
                        stepDone = true;
                        _Debug(h:PrintXY().." NerfCoastal - FishReef to Reef R2");
                    elseif self:CanAddToCoastalScore(CoastalScoring.CRABS_R2 - CoastalScoring.FISH_REEF_R2) and self:CanNerfFishR2() then
                        self:TerraformHex(h, 2, TerraformType[2], g_FEATURE_NONE, true, false);
                        self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_CRABS, true, false);
                        self:UpdateCoastalScore(CoastalScoring.CRABS_R2 - CoastalScoring.FISH_REEF_R2)
                        stepDone = true;
                        _Debug(h:PrintXY().." NerfCoastal - FishReef to Crabs R2");
                    elseif self:CanAddToCoastalScore(CoastalScoring.FISH_R2 - CoastalScoring.FISH_REEF_R2) then
                        self:TerraformHex(h, 2, TerraformType[2], g_FEATURE_NONE, true, false);
                        self:UpdateCoastalScore(CoastalScoring.FISH_R2 - CoastalScoring.FISH_REEF_R2)
                        stepDone = true;
                        _Debug(h:PrintXY().." NerfCoastal - FishReef to Fish R2");
                    end
                end
                if stepDone == false and h.ResourceType == g_RESOURCE_FISH and h.FeatureType == g_FEATURE_NONE and self:CanNerfFishR2() then
                    if self:CanAddToCoastalScore(- CoastalScoring.FISH_R2) then
                        self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_NONE, true, false);
                        self:UpdateCoastalScore(- CoastalScoring.FISH_R2)
                        stepDone = true;
                        _Debug(h:PrintXY().." NerfCoastal - Fish to Empty R2");
                    elseif self:CanAddToCoastalScore(CoastalScoring.CRABS_R2 - CoastalScoring.FISH_R2) then
                        self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_CRABS, true, false);
                        self:UpdateCoastalScore(CoastalScoring.CRABS_R2 - CoastalScoring.FISH_R2)
                        stepDone = true;
                        _Debug(h:PrintXY().." NerfCoastal - Fish to Crabs R2");
                    end
                elseif h.ResourceType == g_RESOURCE_NONE and h.FeatureType == g_FEATURE_REEF
                        and self:CanAddToCoastalScore(- CoastalScoring.REEF_R2) then
                    self:TerraformHex(h, 2, TerraformType[2], g_FEATURE_NONE, true, false);
                    self:UpdateCoastalScore(- CoastalScoring.REEF_R2)
                    stepDone = true;
                    _Debug(h:PrintXY().." NerfCoastal - Reef to Empty R2");
                elseif h.ResourceType == g_RESOURCE_CRABS then
                    self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_NONE, true, false);
                    self:UpdateCoastalScore(- CoastalScoring.CRABS_R2)
                    stepDone = true;
                    _Debug(h:PrintXY().." NerfCoastal - Crabs to Empty R2");
                end
            end
        end
        --
        if stepDone == false then
            _Debug("NerfCoastal RingTables[3].WATER_RF = "..tostring(#self.RingTables[3].WATER_RF))
            local waterRFRing3 = GetShuffledCopyOfTable(self.RingTables[3].WATER_RF);
            for _, h in pairs(waterRFRing3) do
                if h.ResourceType == g_RESOURCE_FISH and h.FeatureType == g_FEATURE_REEF then
                    if self:CanAddToCoastalScore(- CoastalScoring.FISH_REEF_R3) then
                        self:TerraformHex(h, 3, TerraformType[2], g_FEATURE_NONE, true, false);
                        self:TerraformHex(h, 3, TerraformType[3], g_RESOURCE_NONE, true, false);
                        self:UpdateCoastalScore(- CoastalScoring.FISH_REEF_R3)
                        stepDone = true;
                        _Debug(h:PrintXY().." NerfCoastal - FishReef to Empty R3");
                    elseif self:CanAddToCoastalScore(CoastalScoring.REEF_R3 - CoastalScoring.FISH_REEF_R3) then
                        self:TerraformHex(h, 3, TerraformType[3], g_RESOURCE_NONE, true, false);
                        self:UpdateCoastalScore(CoastalScoring.REEF_R3 - CoastalScoring.FISH_REEF_R3)
                        stepDone = true;
                        _Debug(h:PrintXY().." NerfCoastal - FishReef to Reef R3");
                    elseif self:CanAddToCoastalScore(CoastalScoring.CRABS_R3 - CoastalScoring.FISH_REEF_R3) then
                        self:TerraformHex(h, 3, TerraformType[2], g_FEATURE_NONE, true, false);
                        self:TerraformHex(h, 3, TerraformType[3], g_RESOURCE_CRABS, true, false);
                        self:UpdateCoastalScore(CoastalScoring.CRABS_R3 - CoastalScoring.FISH_REEF_R3)
                        stepDone = true;
                        _Debug(h:PrintXY().." NerfCoastal - FishReef to Crabs R3");
                    elseif self:CanAddToCoastalScore(CoastalScoring.FISH_R3 - CoastalScoring.FISH_REEF_R3) then
                        self:TerraformHex(h, 3, TerraformType[2], g_FEATURE_NONE, true, false);
                        self:UpdateCoastalScore(CoastalScoring.FISH_R3 - CoastalScoring.FISH_REEF_R3)
                        stepDone = true;
                        _Debug(h:PrintXY().." NerfCoastal - FishReef to Fish R3");
                    end
                end
                if stepDone == false and h.ResourceType == g_RESOURCE_FISH and h.FeatureType == g_FEATURE_NONE then
                    if self:CanAddToCoastalScore(- CoastalScoring.FISH_R3) then
                        self:TerraformHex(h, 3, TerraformType[3], g_RESOURCE_NONE, true, false);
                        self:UpdateCoastalScore(- CoastalScoring.FISH_R3)
                        stepDone = true;
                        _Debug(h:PrintXY().." NerfCoastal - Fish to Empty R3");
                    elseif self:CanAddToCoastalScore(CoastalScoring.CRABS_R3 - CoastalScoring.FISH_R3) then
                        self:TerraformHex(h, 3, TerraformType[3], g_RESOURCE_CRABS, true, false);
                        self:UpdateCoastalScore(CoastalScoring.CRABS_R3 - CoastalScoring.FISH_R3)
                        stepDone = true;
                        _Debug(h:PrintXY().." NerfCoastal - Fish to Crabs R3");
                    end
                elseif stepDone == false and h.ResourceType == g_RESOURCE_NONE and h.FeatureType == g_FEATURE_REEF
                    and self:CanAddToCoastalScore(- CoastalScoring.REEF_R3) then
                    self:TerraformHex(h, 3, TerraformType[2], g_FEATURE_NONE, true, false);
                    self:UpdateCoastalScore(- CoastalScoring.REEF_R3)
                    stepDone = true;
                    _Debug(h:PrintXY().." NerfCoastal - Reef to Empty R3");
                elseif stepDone == false and h.ResourceType == g_RESOURCE_CRABS
                    and self:CanAddToCoastalScore(- CoastalScoring.CRABS_R3) then
                    self:TerraformHex(h, 3, TerraformType[3], g_RESOURCE_NONE, true, false);
                    self:UpdateCoastalScore(- CoastalScoring.CRABS_R3)
                    stepDone = true;
                    _Debug(h:PrintXY().." NerfCoastal - Crabs to Empty R3");
                end
            end
        end
        -- Only lux to nerf in the spawn ?
        if stepDone == false then
            for _, h in pairs(waterRFRing2) do
                if h.ResourceType == g_RESOURCE_TURTLES and self:CanAddToCoastalScore(CoastalScoring.FISH_REEF_R2 - CoastalScoring.TURTLES_R2) then
                    self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_FISH, true, false);
                    self:UpdateCoastalScore(CoastalScoring.FISH_REEF_R2 - CoastalScoring.TURTLES_R2)
                    _Debug(h:PrintXY().." NerfCoastal - Turtles to FishReef R3");
                elseif h.ResourceType == g_RESOURCE_WHALES and self:CanAddToCoastalScore(CoastalScoring.FISH_REEF_R2 - CoastalScoring.WHALES_R2) then
                    self:TerraformHex(h, 2, TerraformType[3], g_RESOURCE_FISH, true, false);
                    self:UpdateCoastalScore(CoastalScoring.FISH_REEF_R2 - CoastalScoring.WHALES_R2)
                    _Debug(h:PrintXY().." NerfCoastal - Whales to FishReef R3");
                end
            end

        end
        if stepDone == false then
            _Debug("NerfCoastal - could not nerf further, aimed = "..tostring(self.AimedCoastalScore).." score = "..tostring(self.CoastalScore))
            break
        end
    end
end

-- The garanteed fish in ring 2 of spawn should not be used in NerfCoastal method
function SpawnBalancing:CanNerfFishR2()
    local fishR2count = 0;
    for _, h in pairs(self.RingTables[2].WATER_RF) do
        if h.ResourceType == g_RESOURCE_FISH then
            fishR2count = fishR2count + 1;
        end
    end
    return fishR2count > 1;
end

-- Call basic terraforming method depending on type
function SpawnBalancing:Terraform(hex, type, id, forced, boolParam)
    if type == TerraformType[1] then
        return self.HexMap:TerraformSetTerrain(hex, id);
    elseif type == TerraformType[2] then
        return self.HexMap:TerraformSetFeature(hex, id, forced);
    elseif type == TerraformType[3] then
        return self.HexMap:TerraformSetResource(hex, id, forced);
    elseif type == TerraformType[4] then
        return self.HexMap:TerraformTo4Yields(hex, boolParam, forced);
    elseif type == TerraformType[5] then
        return self.HexMap:TerraformDesert(hex);
    elseif type == TerraformType[6] then
        return self.HexMap:TerraformAdd1Food(hex, forced, boolParam);
    elseif type == TerraformType[7] then
        return self.HexMap:TerraformRemove1Food(hex, forced);
    elseif type == TerraformType[8] then
        return self.HexMap:TerraformAdd1Prod(hex, forced, boolParam);
    elseif type == TerraformType[9] then
        return self.HexMap:TerraformRemove1Prod(hex, forced);
    elseif type == TerraformType[10] then
        return self.HexMap:TerraformMountainToHill(hex);
    elseif type == TerraformType[11] then
        return self.HexMap:TerraformAddRandomLux(hex, boolParam, forced);
    elseif type == TerraformType[12] then
        return self.HexMap:TerraformToStandardHighFoodYields(hex, boolParam);
    elseif type == TerraformType[13] then
        return self.HexMap:Terraform4YieldsToHighYields(hex, forced, boolParam);
    elseif type == TerraformType[14] then
        return self.HexMap:TerraformToHill(hex, boolParam);
    elseif type == TerraformType[15] then
        return self.HexMap:TerraformToFlat(hex, boolParam);
    elseif type == TerraformType[16] then
        return self.HexMap:TerraformTo22Yields(hex, boolParam);  
    elseif type == TerraformType[99] then
       return self.HexMap:TerraformEmptyTile(hex);
    else
        return false;
    end
end
