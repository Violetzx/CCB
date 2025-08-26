---------------------------------------
-- CivilizationAssignSpawn
---------------------------------------

CivilizationAssignSpawn = {}

function CivilizationAssignSpawn.new(player, leader, name, team, index)
    local instance = {}
    setmetatable(instance, {__index = CivilizationAssignSpawn});
    instance.PlayerIndex = index;
    instance.Player = player;
    instance.CivilizationLeader = leader;
    instance.CivilizationName = name;
    instance.CivilizationTeam = team;
    instance.IsNoBias = false;
    instance.IsCoastalBias = false;
    instance.IsJungleBias = false;
    instance.IsDesertBias = false;
    instance.IsTundraBias = false;
    instance.IsRiverBias = false;
    instance.IsFloodplainsBias = false;
    instance.IsHydrophobicBias = false;
    instance.IsNoFreshWaterBias = false;
    instance.IsSaltyBias = false;
    instance.IsKingNorthBias = false;
    instance.IsContSplitBias = false;
    instance.IsMountainLoverBias = false;
    instance.IsMountainBias = false; --less priority than the lover
    instance.IsOceanBias = false;
    instance.HighestBias = 6
    instance.CivilizationBiases = instance:GetBiases();
    -- Table containing all differents score for each centroid
    instance.CentroidsScore = {}
    instance.AttributedCentroid = nil;
    instance.StartingHex = nil;
    instance.TeamerSim = false;
    instance.TeamerWar = false;
    instance.TeamerSide = "";
    instance.TeamerContinentId = nil;
    _Debug("Init CivilizationAssignSpawn ", player, leader, name, team);
    return instance;
end

-- Fill all the biases data for the civ and set the parameters
function CivilizationAssignSpawn:GetBiases()
    local biases = {};
    if GameInfo.Leaders_XP2[self.CivilizationLeader] ~= nil and GameInfo.Leaders_XP2[self.CivilizationLeader].OceanStart == true then
        --self.IsOceanBias = true;
        local bias = {};
        bias.IsNegative = false;
        bias.Tier = 1;
        bias.Type = "TERRAINS";
        bias.Value = g_TERRAIN_TYPE_COAST;
        _Debug("BBM_AssignStartingPlots: Add Bias : Civilization",self.CivilizationName,"Bias Type:", bias.Type, "Tier :", bias.Tier, "Type :", row.TerrainType);
        table.insert(biases, bias);
        self.IsCoastalBias = true;
    end
    for row in GameInfo.StartBiasResources() do
        if(row.CivilizationType == self.CivilizationName) then
            local bias = {};
            bias.IsNegative = false;
            bias.Tier = row.Tier;
            bias.Type = "RESOURCES";
            bias.Value = GetResourceIndex(row.ResourceType);
            _Debug("BBM_AssignStartingPlots: Add Bias : Civilization",self.CivilizationName,"Bias Type:", bias.Type, "Tier :", bias.Tier, "Type :", row.ResourceType);
            table.insert(biases, bias);
        end
    end
    for row in GameInfo.StartBiasFeatures() do
        if(row.CivilizationType == self.CivilizationName) then
            local bias = {};
            bias.IsNegative = false;
            bias.Tier = row.Tier;
            bias.Type = "FEATURES";
            bias.Value = GetFeatureIndex(row.FeatureType);
            _Debug("BBM_AssignStartingPlots: Add Bias : Civilization",self.CivilizationName,"Bias Type:", bias.Type, "Tier :", bias.Tier, "Type :", row.FeatureType);
            table.insert(biases, bias);
            if bias.Value == g_FEATURE_FLOODPLAINS or bias.Value == g_FEATURE_FLOODPLAINS_GRASSLAND or bias.Value == g_FEATURE_FLOODPLAINS_PLAINS then
                self.IsFloodplainsBias = true;
            end
            if bias.Value == g_FEATURE_JUNGLE then
                self.IsJungleBias = true;
            end
        end
    end
    for row in GameInfo.StartBiasTerrains() do
        if(row.CivilizationType == self.CivilizationName) then
            local bias = {};
            bias.IsNegative = false;
            bias.Tier = row.Tier;
            bias.Type = "TERRAINS";
            bias.Value = GetTerrainIndex(row.TerrainType);
            _Debug("BBM_AssignStartingPlots: Add Bias : Civilization",self.CivilizationName,"Bias Type:", bias.Type, "Tier :", bias.Tier, "Type :", row.TerrainType);
            table.insert(biases, bias);
            if bias.Value == g_TERRAIN_TYPE_COAST then --only wilhemine has non T1 coast bias -what to do with her)
                self.IsCoastalBias = true
            elseif bias.Value == g_TERRAIN_TYPE_DESERT or bias.Value == g_TERRAIN_TYPE_DESERT_HILLS or bias.Value == g_TERRAIN_TYPE_DESERT_MOUNTAIN then
                self.IsDesertBias = true;
            elseif bias.Value == g_TERRAIN_TYPE_TUNDRA or bias.Value == g_TERRAIN_TYPE_TUNDRA_HILLS or bias.Value == g_TERRAIN_TYPE_TUNDRA_MOUNTAIN then
                self.IsTundraBias = true;
            elseif IsMountain(bias.Value) then
                self.IsMountainBias = true;
            end
        end
    end
    for row in GameInfo.StartBiasRivers() do
        if(row.CivilizationType == self.CivilizationName) then
            local bias = {};
            bias.IsNegative = false;
            bias.Tier = row.Tier;
            bias.Type = "RIVERS";
            bias.Value = nil;
            _Debug("BBM_AssignStartingPlots: Add Bias : Civilization",self.CivilizationName,"Bias Type:", bias.Type, "Tier :", bias.Tier, "Type :", bias.Value);
            table.insert(biases, bias);
            _Debug("BBM_AssignStartingPlots - Civilization ",self.CivilizationName)
            self.IsRiverBias = true;
        end
    end
	for _, row in ipairs(bbs_negative_bias) do
        if(row.CivilizationType == self.CivilizationName) then
            local bias = {};
            bias.IsNegative = true;
			if row.TerrainType ~= nil then
				bias.Value = GetTerrainIndex(row.TerrainType);
				bias.Type = "NEGATIVE_TERRAINS";
				bias.Tier = row.Tier;
				_Debug("BBM_AssignStartingPlots: Add Bias : Civilization",self.CivilizationName,"Bias Type:", bias.Type, "Tier :", bias.Tier, "Type :", row.TerrainType);
				table.insert(biases, bias);
				elseif row.FeatureType ~= nil then
				bias.Value = GetFeatureIndex(row.FeatureType);
				bias.Type = "NEGATIVE_FEATURES";
				bias.Tier = row.Tier;
				_Debug("BBM_AssignStartingPlots: Add Bias : Civilization",self.CivilizationName,"Bias Type:", bias.Type, "Tier :", bias.Tier, "Type :", row.FeatureType);
				table.insert(biases, bias);
				elseif row.ResourceType ~= nil then
				bias.Value = GetResourceIndex(row.ResourceType);
				bias.Type = "NEGATIVE_RESOURCES";
				bias.Tier = row.Tier;
				_Debug("BBM_AssignStartingPlots: Add Bias : Civilization",self.CivilizationName,"Bias Type:", bias.Type, "Tier :", bias.Tier, "Type :", row.ResourceType);
				table.insert(biases, bias);
			end	
        end
    end
	for _, row in ipairs(bbs_custom_bias) do
        if(row.CivilizationType == self.CivilizationName) then
            local bias = {};
            bias.IsNegative = false;
			if row.CustomPlacement ~= nil then
				bias.Type = row.CustomPlacement;
				bias.Tier = 1;
				bias.Value = -1;
				_Debug("BBM_AssignStartingPlots: Add Bias : Civilization",self.CivilizationName,"Bias Type:", bias.Type, "Tier :", bias.Tier, "Type :", bias.Value);
				_Debug("BBM_AssignStartingPlots: Add Bias : Civilization",self.CivilizationName,"Bias Type:", bias.Type, "Tier :", bias.Tier, "Type :", bias.Value);
				table.insert(biases, bias);
                -- Custom Biases 
                if (bias.Type == "CUSTOM_NO_FRESH_WATER") then
                    self.IsNoFreshWaterBias = true;
                elseif (bias.Type == "CUSTOM_CONTINENT_SPLIT") then
                    self.IsContSplitBias = true;
                elseif (bias.Type == "CUSTOM_NO_LUXURY_LIMIT") then
                    _Debug("Calculate no lux limit score "..tostring(bias.Value))
                elseif (bias.Type == "CUSTOM_MOUNTAIN_LOVER") then
                    _Debug("self.IsMountainLoverBias = true")
                    self.IsMountainLoverBias = true;
                elseif (bias.Type == "CUSTOM_KING_OF_THE_NORTH") then	
                    _Debug("King of the North Bias found")
                    self.IsKingNorthBias = true;
                elseif (bias.Type == "CUSTOM_I_AM_SALTY")  then	
                    self.IsSaltyBias = true;
                elseif (bias.Type == "CUSTOM_HYDROPHOBIC") then	
                    self.IsHydrophobicBias = true;
                    self.IsNoFreshWaterBias = true;
                end			
			end			
        end
    end
    table.sort(biases, function(a, b) return a.Tier < b.Tier; end);
    if #biases > 0 then
        -- Get highest non negative feature (mapuche has negative feat as highest tier)
        -- 6 is default value for non bias
        for i, bias in pairs(biases) do
            if self.HighestBias == 6 and bias.Type ~= "NEGATIVE_FEATURES" and bias.Type ~= "NEGATIVE_TERRAINS" and bias.Type ~= "NEGATIVE_RESOURCES" then
                self.HighestBias = biases[i].Tier
            end
        end
       
    else 
        self.HighestBias = 6
        self.IsNoBias = true;
    end
    return biases;
end

-- Need to convert the bias value (in text) from database to the corresponding index
function GetTerrainIndex(terrainType)
    if (terrainType == "TERRAIN_COAST") then
        return g_TERRAIN_TYPE_COAST;
    elseif (terrainType == "TERRAIN_DESERT") then
        return g_TERRAIN_TYPE_DESERT;
    elseif (terrainType == "TERRAIN_TUNDRA") then
        return g_TERRAIN_TYPE_TUNDRA;
    elseif (terrainType == "TERRAIN_SNOW") then
        return g_TERRAIN_TYPE_SNOW;
    elseif (terrainType == "TERRAIN_PLAINS") then
        return g_TERRAIN_TYPE_PLAINS;
    elseif (terrainType == "TERRAIN_GRASS") then
        return g_TERRAIN_TYPE_GRASS;
    elseif (terrainType == "TERRAIN_DESERT_HILLS") then
        return g_TERRAIN_TYPE_DESERT_HILLS;
    elseif (terrainType == "TERRAIN_TUNDRA_HILLS") then
        return g_TERRAIN_TYPE_TUNDRA_HILLS;
    elseif (terrainType == "TERRAIN_TUNDRA_MOUNTAIN") then
        return g_TERRAIN_TYPE_TUNDRA_MOUNTAIN;
    elseif (terrainType == "TERRAIN_SNOW_HILLS") then
        return g_TERRAIN_TYPE_SNOW_HILLS;
    elseif (terrainType == "TERRAIN_PLAINS_HILLS") then
        return g_TERRAIN_TYPE_PLAINS_HILLS;
    elseif (terrainType == "TERRAIN_GRASS_HILLS") then
        return g_TERRAIN_TYPE_GRASS_HILLS;
    elseif (terrainType == "TERRAIN_GRASS_MOUNTAIN") then
        return g_TERRAIN_TYPE_GRASS_MOUNTAIN;
    elseif (terrainType == "TERRAIN_PLAINS_MOUNTAIN") then
        return g_TERRAIN_TYPE_PLAINS_MOUNTAIN;
    elseif (terrainType == "TERRAIN_DESERT_MOUNTAIN") then
        return g_TERRAIN_TYPE_DESERT_MOUNTAIN;
    end
end

function GetFeatureIndex(featureType)
    if (featureType == "FEATURE_VOLCANO") then
        return g_FEATURE_VOLCANO;
    elseif (featureType == "FEATURE_JUNGLE") then
        return g_FEATURE_JUNGLE;
    elseif (featureType == "FEATURE_FOREST") then
        return g_FEATURE_FOREST;
    elseif (featureType == "FEATURE_MARSH") then
        return 5;
    elseif (featureType == "FEATURE_FLOODPLAINS") then
        return g_FEATURE_FLOODPLAINS;
    elseif (featureType == "FEATURE_FLOODPLAINS_PLAINS") then
        return g_FEATURE_FLOODPLAINS_PLAINS;
    elseif (featureType == "FEATURE_FLOODPLAINS_GRASSLAND") then
        return g_FEATURE_FLOODPLAINS_GRASSLAND;
    elseif (featureType == "FEATURE_GEOTHERMAL_FISSURE") then
        return g_FEATURE_GEOTHERMAL_FISSURE;
    end
end

function GetResourceIndex(resourceType)
    local resourceTypeName = "LOC_" .. resourceType .. "_NAME";
    for row in GameInfo.Resources() do
        if (row.Name == resourceTypeName) then
            return row.Index;
        end
    end
end

-- Find the total score 
function CivilizationAssignSpawn:CalculateTotalScores(BBM_HexMap)
    -- Define scores for centroids and order them by score
    if self.CivilizationLeader ~= BBS_LEADER_TYPE_SPECTATOR then
        self:CalculateOrderCentroidsScore(BBM_HexMap);
        -- Sum of centroid scores (cover all maps) 
        local totalScore = 0 
        local totalValidTiles = 0
        local maxCentScore = 0
        for _, c in pairs(self.CentroidsScore) do
            totalScore = totalScore + c.Score
            totalValidTiles = totalValidTiles + #c.ValidTilesBias
            if c.Score > maxCentScore then
                maxCentScore = c.Score;
            end
        end
        -- By default, if no bias are giving score, put the max score by default being the max number of regions
        if maxCentScore == 0 then
            totalScore = GlobalNumberOfRegions;
            maxCentScore = 1;
        end
        self.TotalMapScore = totalScore / maxCentScore
        self.TotalValidTiles = totalValidTiles
        self.RandomPlaceIdOrder = TerrainBuilder.GetRandomNumber(100, "Spawn A"); -- Used to determine in what order will be placed civ with same score and valid tiles (typically no bias)
        _Debug("CalculateTotalScores "..self.CivilizationLeader.." "..tostring(totalValidTiles))
    else 
        self.TotalMapScore = 100;
        self.TotalValidTiles = 0;
        self.RandomPlaceIdOrder = TerrainBuilder.GetRandomNumber(100, "Spawn Spec");
    end

end


-- Main first method to call to assign spawn
-- Complete function of assigning spawn to a major civ 
-- Add more random to calculations for non coastal and non bias ? 
function CivilizationAssignSpawn:AssignSpawnByCentroid(BBM_HexMap)
    -- _Debug("AssignSpawnByCentroid for "..self.CivilizationLeader);
    if self.CivilizationLeader == BBS_LEADER_TYPE_SPECTATOR then
        return true;
    end
    -- Recalculate valid tiles in each centroid
    self:CalculateOrderCentroidsScore(BBM_HexMap);
    -- Find the best tiles based on score of top centroids 
    local hexSpawnFound, score = self:FindHighestScoreHex();

    -- 
    if hexSpawnFound ~= nil then
        self:AssignMajorCivSpawn(BBM_HexMap, hexSpawnFound);
        return true, hexSpawnFound, score;
    else 
         -- Try again or go to firaxis placement
         print("Unable to find a valid tile for this civ on this map", self.CivilizationLeader)
        return false, nil, nil;
    end
end


-- Order the regions based on bias score and number of valid spawn tiles
function CivilizationAssignSpawn:CalculateOrderCentroidsScore(BBM_HexMap)
    self.CentroidsScore = {};
     -- Mean score for each hex in centroid cluster by bias
    for i, centroid in pairs(BBM_HexMap.centroidsArray) do
        local centScore = self:ComputeBiasScoreCivCentroid(centroid);
        local meanPeninsulaScore = 0;
        local validTiles = self:GetValidSpawnsInHexList(BBM_HexMap, centroid.HexCluster);
        local validBiasTiles = {}
        if #validTiles > 0 then
            for _, hex in pairs(validTiles) do
                if self:IsBiasRespected(hex, BBM_HexMap) then
                    table.insert(validBiasTiles, hex);
                    meanPeninsulaScore = meanPeninsulaScore + hex.PeninsulaScore;
                end
            end
            meanPeninsulaScore = meanPeninsulaScore / #validBiasTiles;
        end
        table.insert(self.CentroidsScore, { Centroid = centroid, Score = centScore, ValidTiles = validTiles, ValidTilesBias = validBiasTiles, MeanPeninsulaScore = meanPeninsulaScore, TundraScoring = centroid.TundraScore });
    end
     -- Go through each centroid, from highest to lower centroid score for the civ
    table.sort(self.CentroidsScore,
    function(a, b)
        if a.Score == 0 and b.Score == 0 then
            return #a.ValidTilesBias > #b.ValidTilesBias
        else
            return a.Score > b.Score
        end
    end)

    _Debug("Civilization : "..self.CivilizationLeader, self.TeamerSide)
    for _, c in pairs(self.CentroidsScore) do
        _Debug("AssignSpawnByCentroid - Score for centroid "..tostring(c.Centroid.id).." = "..tostring(c.Score).." Valid = "..tostring(#c.ValidTiles).." ValidBias = "..tostring(#c.ValidTilesBias).." TundraScoring = "..tostring(c.TundraScoring).." PeninsulaScore = "..tostring(c.MeanPeninsulaScore));
    end

    return self.CentroidsScore;
end

-- Main method to get valid spawns tiles depending on civ bias
function CivilizationAssignSpawn:GetValidSpawnsInHexList(BBM_HexMap, listHex)
    local validTiles = {}
    local isTerraMap = BBM_HexMap.mapScript == MapScripts.MAP_TERRA;
    for _, hex in pairs(listHex) do
        -- In Terra, major civ spawn on the biggest island
        local terraCondition = isTerraMap == false or (isTerraMap and hex.Plot:GetArea():GetID() == BBM_HexMap.BiggestIsland:GetID())
        local RTScondition = self:GetXPlacementCondition(BBM_HexMap, hex);
        if RTScondition and terraCondition and hex.IsMajorSpawnable and self:ValidWalkableTiles(hex) and self:ValidTundraDensity(hex) then --pre calculation of technical spawns
            if self.IsTundraBias == false and self.IsDesertBias == false and hex:IsNextToOasis() == false then
                -- If Maya ignore fresh water, it will be placed last because there is too much valid tiles
                if self.IsCoastalBias and hex.IsCoastal and hex:IsTundraLand() == false then
                    -- Fresh water is favored on score calculations
                    table.insert(validTiles, hex);
                elseif self.IsCoastalBias == false and (hex.IsFreshWater or hex.IsCoastal) and hex:IsTundraLand() == false then
                    table.insert(validTiles, hex);
                end
            elseif self.IsTundraBias and hex:IsTundraLand() and hex.IsFreshWater then
                table.insert(validTiles, hex);
            --elseif self.IsDesertBias and hex:IsDesertLand() and hex.IsFreshWater then
            elseif self.IsDesertBias  and self:FindDesertBiasV2(hex) then
                table.insert(validTiles, hex);
            end
        end
    end

    return validTiles;
end

function CivilizationAssignSpawn:GetXPlacementCondition(BBM_HexMap, hex)
    if  BBM_HexMap.TeamerConfig == TeamerConfigStandard then
        return true;
    end
    BBM_HexMap.RTSContinentSetup = BBM_HexMap.RTSContinentSetup or {}
    if BBM_HexMap.mapScript == MapScripts.MAP_PANGAEA 
        or BBM_HexMap.mapScript == MapScripts.MAP_INLAND_SEA 
        or BBM_HexMap.mapScript == MapScripts.MAP_PANGAEA_ULTIMA then
        if self.TeamerWar then
            local warSizeMax = BBM_HexMap.RTSPangaeaTeamerConfigWarMax
            if self.IsTundraBias then
                warSizeMax = BBM_HexMap.RTSPangaeaTeamerConfigWarMaxTundra;
            end
            if self.TeamerSide == EastTeam then
                return hex:GetX() > BBM_HexMap.MiddleX + BBM_HexMap.RTSPangaeaTeamerEvWBuffer and hex:GetX() <= BBM_HexMap.MiddleX + warSizeMax;
            elseif self.TeamerSide == WestTeam then
                return hex:GetX() < BBM_HexMap.MiddleX - BBM_HexMap.RTSPangaeaTeamerEvWBuffer and hex:GetX() >= BBM_HexMap.MiddleX - warSizeMax;
            else -- Side not attributed yet
                return (hex:GetX() > BBM_HexMap.MiddleX + BBM_HexMap.RTSPangaeaTeamerEvWBuffer and hex:GetX() <= BBM_HexMap.MiddleX + warSizeMax)
                    or (hex:GetX() < BBM_HexMap.MiddleX - BBM_HexMap.RTSPangaeaTeamerEvWBuffer and hex:GetX() >= BBM_HexMap.MiddleX - warSizeMax)
            end 
        elseif self.TeamerSim then
            local minimumSimDistance = BBM_HexMap.RTSPangaeaTeamerConfigSimMin;
            if BBM_PlayerNumber == 2 then
                minimumSimDistance = 5;
            end
            if self.TeamerSide == EastTeam then
                return hex:GetX() > BBM_HexMap.MiddleX + minimumSimDistance;
            elseif self.TeamerSide == WestTeam then
                return hex:GetX() < BBM_HexMap.MiddleX - minimumSimDistance;
            else -- Side not attributed yet
                return (hex:GetX() > BBM_HexMap.MiddleX + minimumSimDistance) or (hex:GetX() < BBM_HexMap.MiddleX - minimumSimDistance);
            end 
        end
        return true;
    end
    if BBM_HexMap.mapScript == MapScripts.MAP_CONTINENTS or BBM_HexMap.mapScript == MapScripts.MAP_CONTINENTS_ISLANDS then
        local continentTeam = BBM_HexMap.RTSContinentSetup[self.CivilizationTeam];
        if continentTeam == nil or continentTeam == hex.IslandId then
            if self.TeamerSide == EastTeam then
                return hex:GetX() >= BBM_HexMap.MiddleX;
            elseif self.TeamerSide == WestTeam then
                return hex:GetX() < BBM_HexMap.MiddleX;
            end
        else 
            return false;
        end
        return true;
    end
    return true;
end

-- Test for Mali : at least 2 desert tiles and 2 non desert
-- We do not check here fresh water, we will add oasis if needed
function CivilizationAssignSpawn:FindDesertBiasV2(hex)
    if hex:IsDesertLand() == false then
        return false;
    end
    local countDesertR1 = 0
    local countLandR1 = 0
    local countDesertR2 = 0
    local countLandR2 = 0
    for _, r in pairs(hex.AllRing6Map[1]) do
        if r:IsImpassable() == false then
            if r:IsDesertLand() then
                countDesertR1 = countDesertR1 + 1;
            elseif r:IsGrassLand() or r:IsPlainLand() then
                countLandR1 = countLandR1 + 1;
            end
        end
    end
    for _, r in pairs(hex.AllRing6Map[2]) do
        if r:IsImpassable() == false then
            if r:IsDesertLand() then
                countDesertR2 = countDesertR2 + 1;
            elseif r:IsGrassLand() or r:IsPlainLand() then
                countLandR2 = countLandR2 + 1;
            end
        end
    end
    if countDesertR1 >= 2 and countDesertR2 >= 3 and countLandR1 > 0 and countLandR1 + countLandR2 >= 4 then
        return true;
    end
    return false;
end

function CivilizationAssignSpawn:GetNonTundraTilesCountRing3(hex)
    local nbNonTundraTilesInRing3 = 0;
    local mapRing6 = hex.AllRing6Map
    for i = 1, 3 do
        for _, h in ipairs(mapRing6[i]) do
            if h:IsWater() == false and h:IsTundraLand() == false and h:IsSnowLand() == false then
                nbNonTundraTilesInRing3 = nbNonTundraTilesInRing3 + 1;
            end
        end
    end
    return nbNonTundraTilesInRing3;
end

-- On top of peninisula score that goes up to ring 6, make sure we have enough tiles in ring 3 that are accessible to settle
function CivilizationAssignSpawn:ValidWalkableTiles(hex)
    return hex:HasSpawnEnoughWalkableTiles()
end

function CivilizationAssignSpawn:ValidTundraDensity(hex)
    if self.IsTundraBias and hex:IsTundraLand() then
        return true;
    end
    -- Precalculated number of tundra in ring 6 around hex
    if hex.TundraScore > 20 then
        return false;
    end
    -- No tundra in ring 3, complements the previous condition in case there is patch of tundra in a peninsula too close to the spawn
    for i, ring in pairs(hex.AllRing6Map) do
        for _, h in pairs(ring) do
            if i <= 3 and IsTundraLand(h.TerrainType) then
                return false;
            end
        end
    end
    return true;
end


-- Find the best centroid for the civ from data analysis
function CivilizationAssignSpawn:FindHighestScoreHex()
    local topCentroids =  {};
    local i = 0;
    local totalSpawnableBias = 0;
    local useEveryValidTiles = false;
    -- self.CentroidsScore must be filled by CalculateOrderCentroidsScore method
    -- Get 3 best regions (already sorted by score or valid tiles)
    for _, c in pairs(self.CentroidsScore) do
        if #c.ValidTilesBias > 0 then
            table.insert(topCentroids, c)
            i = i + 1
            totalSpawnableBias = totalSpawnableBias + #c.ValidTilesBias
            if i == 5 then
                break;
            end
        end
    end
    -- TODO TRY : if not enough valid bias tile but lots of valid spawn : use these
    if totalSpawnableBias == 0 then
        print("Not enough vald tiles for bias, use default valid spawns")
        useEveryValidTiles = true;
        topCentroids =  {};
        i = 0
        for _, c in pairs(self.CentroidsScore) do
            if #c.ValidTiles > 0 then
                table.insert(topCentroids, c)
                local maxC = 99;
                if self.TeamerSide == "" then
                    maxC = 5;
                end
                i = i + 1
                if i == maxC then
                    break;
                end
            end
        end
    end
    if #topCentroids == 0 then
        --  No centroid found => not even a valid tile in the map = impossible to place civ
        return nil;
    end
    -- Compare regions by size of valids tiles and best score tile in region
    local validTilesInTop5 = {}
    for _, c in pairs(topCentroids) do
        if useEveryValidTiles then
            for _, h in pairs(c.ValidTiles) do
                table.insert(validTilesInTop5, h);
            end
        else
            for _, h in pairs(c.ValidTilesBias) do
                table.insert(validTilesInTop5, h);
            end
        end
    end

    -- Take random tile among the highest scores
    local selectedHex, score = self:GetHighestHexScore(validTilesInTop5)

    return selectedHex, score;
end


-- Return the highest score hex for this civ
function CivilizationAssignSpawn:GetHighestHexScore(hexList)
    local scoring = {}
    -- Get all the hex scores for this civ and order them
    for _, h in pairs(hexList) do
        local score = self:ComputeHexScoreCiv(h)
        table.insert(scoring, { Hex = h, Score = score})
    end
    table.sort(scoring, function(a, b)
        return a.Score > b.Score;
    end);
    local highestScore = scoring[1].Score;
    -- Take the highest score among the tiles
    local highestScoresTable = {}
    for _, s in pairs(scoring) do
        if s.Score == highestScore then
            -- print("GetHighestHexScore - Highest score found = "..tostring(s.Score).." "..s.Hex:PrintXY());
            table.insert(highestScoresTable, s)
        end
    end
    -- If multiples tiles with same score, take a random one
    if #highestScoresTable > 1 then
        highestScoresTable = GetShuffledCopyOfTable(highestScoresTable);
    end

    return highestScoresTable[1].Hex, highestScoresTable[1].Score;
end


-- Calculate the hex score for a civ, taking account for the bias score + extra parameters like fresh water/yield etc (to determine)
function CivilizationAssignSpawn:ComputeHexScoreCiv(hex)
    local score = 100

    -------------------
    -- 1 - Fresh water - Slight preference for fresh water on coastal spawn or no bias civ
    -------------------
    if self.IsNoFreshWaterBias or hex.IsFreshWater  then
        score = score + 20;
    elseif  hex.IsCoastal and (self.IsNoBias or self.IsCoastalBias) then -- coastal for no bias TEST
        score = score + 18;
    end
    -------------------
    -- 2 - Bias score - Density of desired tiles around the spawn - capped
    -------------------
    local baseScore = tostring(score);
    local totalBiasScore = self:ComputeHexScoreBiasCiv(hex);
    score = score + totalBiasScore;

    -------------------
    -- 3 - Peninsula score - Amount of walkable tiles around spawn to avoid tiny peninsulas or islands
    -------------------
    local peninsulaScore = math.floor((hex.PeninsulaScore / 10) + 0.5) * 10
    if self.IsNoBias or self.IsKingNorthBias or self.IsMountainBias then
        score = score + math.min(70, peninsulaScore)
    else
        -- especially for river and coastal else 5 pt is not much when testing other biases
        score = score + math.min(50, peninsulaScore)
    end

    -------------------
    -- 4 - Tundra score - Discourage from spawning too close to tundra, reducing the score for non tundra civ (unspawnable after a certain threshold)
    -------------------
    -- Desert not calculated because future terraforming
    local tundraScore = math.floor(hex.TundraScore / 4 + 0.5) * 10;
    if self.IsTundraBias == false then
        score = score - tundraScore;
    end
    -------------------
    -- 5 - Malus scoring to discourage this spawn unless this is the last option
    -------------------
    -- Flood malus - Discourage from spawning inside floodplains if not in bias
    local floodMalus = 0;
    if self.IsFloodplainsBias == false and self:IsFloodplainsMalus(hex) then
        floodMalus = 20;
        score = score - floodMalus
    end
    -- 2 impassable tiles in a row ring 1 for non coastal civ
    local impassableR1Malus = 0;
    if self.IsCoastalBias == false and hex:IsHexRing1NextToImpassableInARow(2) then
        impassableR1Malus = 20;
        score = score - impassableR1Malus
    end
    -- Coastal : have at least 2 water tiles ring 2 if possible
    if hex:HasMoreThan2WaterCoastRing2() == false then
        score = score - 20
    end
    -- Hydrophobic bias : in rare case when the "isBiasRespected" do not find any, we still discourage spawn clost to coast
    if self.IsHydrophobicBias then
        local distToCoast = hex:GetClosestCoastToHex(5)
        if distToCoast ~= nil then
            local malusScore = (5 - distToCoast) * 6
            _Debug("IsHydrophobicBias debuff ", malusScore, distToCoast, hex:PrintXY())
            score = score - malusScore
        else 
            _Debug("IsHydrophobicBias debuff none in ", hex:PrintXY())
        end
    end
    _Debug(hex:PrintXY(), " Score = ", baseScore, " BiasScore = ", totalBiasScore, " PeninsulaScore = ", peninsulaScore, " TundraScore = ", tundraScore, " - FloodMalus = ", floodMalus, hex.TundraScore, math.floor(score + 0.5), os.date("%c"))

    return math.floor(score + 0.5);
end

function CivilizationAssignSpawn:ComputeHexScoreBiasCiv(hex)
    local totalBiasScore = 0;
    local biasScoreCategory = {}
    local biasCategoryList = {}
    local categotyTier = {}
    -- Check bias category 
    for _, bias in pairs(self.CivilizationBiases) do
        local category = self:GetBiasCategory(bias);
        biasCategoryList[category] = biasCategoryList[category] or {}
        table.insert(biasCategoryList[category], bias)

        --local thisBiasScore = ComputeHexScoreByBias(hex, bias);
        
        --biasScoreCategory[category] = biasScoreCategory[category] or {}
        --table.insert(biasScoreCategory[category], thisBiasScore)
        categotyTier[category] = bias.Tier
    end

    for category, _ in pairs(biasCategoryList) do
        local biases = {}
        for _, bias in ipairs(biasCategoryList[category]) do
            table.insert(biases, bias);
        end
        local scoreCategory = ComputeHexScoreByBiasCategory(hex, biases)
        biasScoreCategory[category] = biasScoreCategory[category] or {}
        table.insert(biasScoreCategory[category], scoreCategory)
        --categotyTier[category] = bias.Tier
    end

    -- Do the mean score for each category
    for categoryKey, scoreTable in pairs(biasScoreCategory) do
        local meanScore = 0
        for _, score in pairs(scoreTable) do
            _Debug("ComputeHexScoreBiasCiv ", self.CivilizationLeader, " Score = ", score);
            meanScore = meanScore + score;
        end
        meanScore = meanScore / #scoreTable;
        local tier =  categotyTier[categoryKey]
        if tier ~= nil and tier ~= 0 then
            meanScore = meanScore / tier;
        end
        totalBiasScore = totalBiasScore + meanScore;
        _Debug("ComputeHexScoreBiasCiv ", self.CivilizationLeader, " Category = ", categoryKey, " Mean score = ", meanScore);
    end
    return totalBiasScore;
end

-- Dividing bias by category (type of terrain or resources) and by tier
function CivilizationAssignSpawn:GetBiasCategory(bias)
    if bias.IsNegative then
        return "NEGATIVES_T"..tostring(bias.Tier);
    end
    if bias.Type == "RESOURCES" then
        if g_RESOURCES_MINE_LIST[bias.Value] then
            return "MINES_T"..tostring(bias.Tier);
        elseif g_RESOURCES_QUARRY_LIST[bias.Value] then
            return "QUARRIES_T"..tostring(bias.Tier);
        elseif g_RESOURCES_PASTURE_LIST[bias.Value] then
            return "PASTURES_T"..tostring(bias.Tier);
        elseif g_RESOURCES_CAMP_LIST[bias.Value] then
            return "CAMPS_T"..tostring(bias.Tier);
        elseif g_RESOURCES_PLANTATION_LIST[bias.Value] then
            return "PLANTATIONS_T"..tostring(bias.Tier);
        elseif g_RESOURCES_FARM_LIST[bias.Value] then
            return "FARMS_T"..tostring(bias.Tier);
        end
    elseif bias.Type == "FEATURES" then
        -- Group forest/jungle
        return "FEATURES_T"..tostring(bias.Tier);
    elseif bias.Type == "TERRAINS" then
        if bias.Value == g_TERRAIN_TYPE_COAST then
            return "COAST_T"..tostring(bias.Tier);
        elseif IsMountain(bias.Value) then
            return "MOUNTAIN_T"..tostring(bias.Tier);
        elseif IsPlainLand(bias.Value) then
            return "PLAIN_T"..tostring(bias.Tier);
        elseif IsGrassLand(bias.Value) then
            return "GRASS_T"..tostring(bias.Tier);
        elseif IsTundraLand(bias.Value) then
            return "TUNDRA_T"..tostring(bias.Tier);
        elseif IsDesertLand(bias.Value) then
            return "DESERT_T"..tostring(bias.Tier);
        end
    elseif bias.Type == "RIVERS" then
        return "RIVERS_T"..tostring(bias.Tier);
    end
    return "CUSTOM_T"..tostring(bias.Tier);
end



-- For each hex in cluster, calculate the bias score and take score mean
function CivilizationAssignSpawn:ComputeBiasScoreCivCentroid(centroid)
    if self.CivilizationLeader == BBS_LEADER_TYPE_SPECTATOR or self.IsOceanBias then
        return;
    end
    local centScore = 0
    local nbBias = 0;
    for _, bias in pairs(self.CivilizationBiases) do
        local scoredBias = 0
        for _, hex in pairs(centroid.HexCluster) do
            local score = ComputeHexScoreByBias(hex, bias)
            scoredBias = scoredBias + score
            centScore = centScore + score
        end
        if scoredBias > 0 then
            nbBias = nbBias + 1
        end
    end
    if nbBias == 0 then
        centScore = centScore / #centroid.HexCluster
    else
        centScore = centScore / (#centroid.HexCluster * nbBias)
    end
    return centScore;
end


-- Get the hex score for a given bias
-- Score for each tile are from the HexMap:ComputeScores -- TODO : takes into account the tile surroundings in ring 6 for now
-- Weighted by bias tier TODO : determine the weight for each tier
-- Score max per bias = 120 -- Higher Tier = need more tiles to get to the max score (= prio on placement and higher chance of highroll)
function ComputeHexScoreByBias(hex, bias)
    local biasScore = GetBiasScorePerFactor(hex, bias);
    -- TODO : Bias threshold and factor : highter tier = higher threshold ?
    local scoreThreshold = 120; 
    return math.min(biasScore, scoreThreshold);
end

-- Variation of bias scoring, group all bias in one score threshold instead of doing averages of all bias category
-- Ex : Mountains can be plains or grass, if there is 10+ grass and 0 plains, the score would be capped at half score while there is more mountains than in a 4 grass + 4 plains spawn
function ComputeHexScoreByBiasCategory(hex, biases)
    local biasScores = 0;
    local scoreThreshold = 120; 
    for _, bias in ipairs(biases) do
        local biasScore = GetBiasScorePerFactor(hex, bias);
        local biasScoreThreshold = scoreThreshold * #biases;
        -- For resources, still cap the category at twice the initial amount to avoid highrolls
        if bias.Type == "RESOURCES" then
            biasScoreThreshold = math.min(scoreThreshold * 2, scoreThreshold * #biases);
        end
        biasScore = math.min(biasScore, biasScoreThreshold);
        biasScores = biasScores + biasScore;
    end
    biasScores = biasScores / #biases
    return math.min(biasScores, scoreThreshold);
end


function GetBiasScorePerFactor(hex, bias) 
    local biasScore = 0;
    if bias.Value == g_TERRAIN_TYPE_COAST and hex.IsCoastal then
        -- Not taking into account the number of coastal tiles in the centroid for now 
        return biasScore;
    elseif (bias.Type == "TERRAINS" and bias.Value ~= g_TERRAIN_TYPE_COAST) then
        if hex.TerrainsScore[bias.Value] ~= nil  then
            -- Terrains are more common (hills, plains etc) so factoring less 
            biasScore = hex.TerrainsScore[bias.Value] * GetBiasFactorV2(bias);
        end
    elseif (bias.Type == "FEATURES") then
        if hex.FeaturesScore[bias.Value] ~= nil  then
            biasScore = hex.FeaturesScore[bias.Value] * GetBiasFactorV2(bias)
        end
    elseif (bias.Type == "RIVERS") then
        if hex.IsOnRiver  then
            biasScore = hex.RiverScore * GetBiasFactorV2(bias);
        end
    elseif (bias.Type == "RESOURCES") then
        if hex.ResourcesScore[bias.Value] ~= nil  then
            biasScore = hex.ResourcesScore[bias.Value] * GetBiasFactorV2(bias)
        end
    -- Negative Biases are optionnal and act as repellents 	
    elseif (bias.Type == "NEGATIVE_TERRAINS") then
        if hex.TerrainsScore[bias.Value] ~= nil  then
            biasScore = - hex.TerrainsScore[bias.Value] * GetBiasFactorV2(bias);
        end
    elseif (bias.Type == "NEGATIVE_FEATURES") then
        if hex.FeaturesScore[bias.Value] ~= nil  then
            biasScore = - hex.FeaturesScore[bias.Value] * GetBiasFactorV2(bias)
        end
    -- not exist atm
    elseif (bias.Type == "NEGATIVE_RESOURCES") then
        if hex.ResourcesScore[bias.Value] ~= nil  then
            biasScore = - hex.ResourcesScore[bias.Value] * GetBiasFactorV2(bias)
        end
    -- Custom Biases are usually computed in valid tiles and isBiasRespected method, not in the score
    end
    return biasScore;
end

function CivilizationAssignSpawn:IsFloodplainsMalus(hex)
    local ring1 = hex.AllRing6Map[1]
    local floodCountR1 = 0;
    for _, h in ipairs(ring1) do
        if h:IsFloodplains(true) then
            floodCountR1 = floodCountR1 + 1;
        end
    end
    if hex:IsFloodplains(true) then
        floodCountR1 = floodCountR1 + 2
    end
    local ring2 = hex.AllRing6Map[2]
    local floodCountR2 = 0;
    for _, h in ipairs(ring2) do
        if h:IsFloodplains(true) then
            floodCountR2 = floodCountR2 + 1;
        end
    end
    if hex:IsFloodplains(true) then
        floodCountR2 = floodCountR2 + 2
    end
    return floodCountR1 >= 2 or (floodCountR1 + floodCountR2 >= 4 and hex.IsCoastal) 
end

-- TODO : determine weight 
function GetBiasFactor(bias)
    if bias.Tier == 1 then
        return 3;
    elseif bias.Tier == 2 then
        return 1.75;
    elseif bias.Tier == 3 then
        return 1.5;
    elseif bias.Tier == 4 then
        return 1.25;
    elseif bias.Tier == 5 then
        return 1.1;
    end
end

function GetBiasFactorV2(bias)
    if (bias.Type == "TERRAINS" and bias.Value ~= g_TERRAIN_TYPE_COAST) then
        if IsMountain(bias.Value) then
            if bias.Tier == 1 then
                return 10;
            elseif bias.Tier == 2 then
                return 12;
            elseif bias.Tier == 3 then
                return 20;
            elseif bias.Tier == 4 then
                return 24;
            elseif bias.Tier == 5 then
                return 30;
            end
        else
            if bias.Tier == 1 then
                return 3;
            elseif bias.Tier == 2 then
                return 4;
            elseif bias.Tier == 3 then
                return 5;
            elseif bias.Tier == 4 then
                return 6;
            elseif bias.Tier == 5 then
                return 8;
            end
        end
    elseif (bias.Type == "FEATURES") then
        if bias.Tier == 1 then
            return 6;
        elseif bias.Tier == 2 then
            return 8;
        elseif bias.Tier == 3 then
            return 10;
        elseif bias.Tier == 4 then
            return 12;
        elseif bias.Tier == 5 then
            return 15;
        end
    elseif (bias.Type == "RIVERS") then
        if bias.Tier == 1 then
            return 5;
        elseif bias.Tier == 2 then
            return 6;
        elseif bias.Tier == 3 then
            return 7;
        elseif bias.Tier == 4 then
            return 8;
        elseif bias.Tier == 5 then
            return 10;
        end
    elseif (bias.Type == "RESOURCES") then
        if bias.Tier == 1 then
            return 10;
        elseif bias.Tier == 2 then
            return 12;
        elseif bias.Tier == 3 then
            return 20;
        elseif bias.Tier == 4 then
            return 30;
        elseif bias.Tier == 5 then
            return 40;
        end
    -- Negative Biases are optionnal and act as repellents 	
    elseif (bias.Type == "NEGATIVE_TERRAINS" or bias.Type == "NEGATIVE_FEATURES" or bias.Type == "NEGATIVE_RESOURCES") then
        if bias.Tier == 1 then
            return 10;
        elseif bias.Tier == 2 then
            return 4;
        elseif bias.Tier == 3 then
            return 3;
        elseif bias.Tier == 4 then
            return 2;
        elseif bias.Tier == 5 then
            return 1;
        end
    end
end


-- Set the starting hex
-- Firaxis method SetStartingPlot called in BBM_AssignStartingPlots
function CivilizationAssignSpawn:AssignMajorCivSpawn(BBM_HexMap, startingHex)
    if startingHex.Centroid ~= nil then
        self.AttributedCentroid = startingHex.Centroid
        self.AttributedCentroid.PlacedCiv = true
    end
    self.StartingHex = startingHex;
    startingHex.IsCivStartingPlot = true;
    startingHex.IsMajorSpawnable = false;
    startingHex.IsMinorSpawnable = false;
    -- Set minimum distance around starting hex
    local list, mappedHex = BBM_HexMap:GetAllHexInRing(startingHex, BBM_HexMap.minimumDistanceMajorToMajorCivs)
    for i, ringHexes in pairs(mappedHex) do
        for _, h in pairs(ringHexes) do
            h.IsMajorSpawnable = false;
            -- distance to cs usually shorter 
            if i <= BBM_HexMap.minimumDistanceMinorToMajorCivs then
                h.IsMinorSpawnable = false;
            end
        end
        
    end
    --BBM_HexMap:PrintHexSpawnableMap()
    _Debug("Assigned spawn "..startingHex:PrintXY().." for civ "..tostring(self.CivilizationLeader))
    return;
end

-- To call after placing majors civs
function CivilizationAssignSpawn:AssignMinorCivSpawn(BBM_HexMap, startingHex)
    self.StartingHex = startingHex
    startingHex.IsCivStartingPlot = true;
    startingHex.IsMinorSpawnable = false;
    table.insert(BBM_HexMap.minorSpawns, startingHex);
    local list, _ = BBM_HexMap:GetAllHexInRing(startingHex, BBM_HexMap.minimumDistanceMinorToMinorCivs)
    for i, hex in pairs(list) do
        hex.IsMinorSpawnable = false;
    end
end


-- Return a boolean testing bias respect on hex in parameter
function CivilizationAssignSpawn:IsBiasRespected(hex, hexMap)
    -- Biases should be already sorted by tier
    -- TODO : Make custom variable per category for better management ? (isMineResourceBias etc)
    if #self.CivilizationBiases == 0 then
        return true;
    end
    -- Need to terraform to hills so avoid floodplains
    if self.CivilizationLeader == "LEADER_MENELIK" and hex:IsFloodplains(true) then
        return false;
    end
    if self.IsFloodplainsBias and hex:IsFloodplains(false) == false then
        return false;
    end
    if self.IsTundraBias then
        local nonTundraRing3 = self:GetNonTundraTilesCountRing3(hex)
        if self.CivilizationLeader == "LEADER_LAURIER" and nonTundraRing3 > 3 then
            return false
        elseif self.CivilizationLeader == "LEADER_PETER_GREAT" and nonTundraRing3 <= 3 then
            return false
        end
    end
     -- Custom bias treated by valid tiles
    local isOneOfBiasRespected = false;
    for _, bias in pairs(self.CivilizationBiases) do
        local countHill = 0
        local countMountains = 0;
        local countJungle = 0;
        -- Mandatory biases
        if bias.Type == "TERRAINS" and IsTundraLand(bias.Value) and hex:IsTundraLand() == false then
            return false;
        --elseif bias.Type == "TERRAINS" and IsDesertLand(bias.Value) and hex:IsDesertLand() == false then
        --    return false;
        elseif bias.Type == "RIVERS" then
            if hex.IsOnRiver then
                isOneOfBiasRespected = true;
            else
                return false;
            end
        elseif bias.Type == "TERRAINS" and bias.Value == g_TERRAIN_TYPE_COAST then
            if hex.IsCoastal  then
                isOneOfBiasRespected = true;
            else
                return false;
            end
        elseif bias.Type == "CUSTOM_HYDROPHOBIC" then
            if hex.PeninsulaScore > 45 and hex:IsCloseToCoast() == false then
                isOneOfBiasRespected = true;
            else 
                return false;
            end  
        elseif bias.Type == "CUSTOM_KING_OF_THE_NORTH" then
            if hex.TundraScore > 0 then
                isOneOfBiasRespected = true;
            end 
        end
        if bias.Type == "CUSTOM_CONTINENT_SPLIT" and hex:HasContinentInWalkableRange(4) == false then
            return false;
        end
        local jungleFound = false;
        for i, ringList in pairs(hex.AllRing6Map) do
            for _, hring in pairs(ringList) do
                if bias.Type == "RESOURCES" then
                    -- Respected if at least 1 ressource in ring 3
                    if i < 4 and hring.ResourceType == bias.Value then
                        isOneOfBiasRespected = true;
                    end
                elseif bias.Type == "FEATURES" then
                    -- Respected if at lease 1 feature in ring 3
                    if i <= 2 and hring.FeatureType == bias.Value then
                        if self.IsJungleBias and bias.Value == g_FEATURE_JUNGLE then
                            countJungle = countJungle + 1;
                            if countJungle > 2 then
                                jungleFound = true;
                                isOneOfBiasRespected = true;
                            end
                        else 
                            isOneOfBiasRespected = true;
                        end
                    end     
                elseif (bias.Type == "TERRAINS" and bias.Value ~= g_TERRAIN_TYPE_COAST) or self.IsMountainLoverBias then
                    if self.IsMountainLoverBias then
                        if i <= 2 and hring:IsMountain() then
                            countMountains = countMountains + 1;
                            if countMountains >= 2 then
                                isOneOfBiasRespected = true;
                            end
                        end
                    elseif IsMountain(bias.Value) then
                        -- At least 2 mountains in ring 3, density score do the rest
                        if i <= 3 and hring:IsMountain() then
                            countMountains = countMountains + 1;
                            if countMountains >= 2 then
                                isOneOfBiasRespected = true;
                            end
                        end
                    elseif IsHill(bias.Value) then
                        if i <= 2 and IsHill(hring.TerrainType) then
                            countHill = countHill + 1;
                            -- 18 tiles total in ring 1+2, need at least 9
                            -- For now this is the only bias of greece and korea and ethiopia
                            if countHill >= 7 then
                                isOneOfBiasRespected = true;
                            end
                        end
                    elseif i < 4 and hring.TerrainType == bias.Value then
                        -- Plains and grassland checked by density, tundra and desert bias in valid tile checks
                        isOneOfBiasRespected = true;
                    end            
                elseif bias.Type == "NEGATIVE_TERRAINS" then
                    -- Test: excluded by tile scoring
                    if i < 4 and hring.TerrainType == bias.Value then
                        return false;
                    end
                elseif bias.Type == "NEGATIVE_FEATURES" then
                    if i < 4 and hring.FeatureType == bias.Value then
                        return false;
                    end
                elseif bias.Type == "NEGATIVE_RESOURCES" then
                    if i < 4 and hring.ResourceType == bias.Value then
                        return false;
                    end
                end
            end
        end
        if self.IsJungleBias and bias.Type == "FEATURES" and bias.Value == g_FEATURE_JUNGLE then
            return jungleFound;
        end
    end
    return isOneOfBiasRespected;
end


function CivilizationAssignSpawn:FindTotalNumberOfValidTiles(BBM_HexMap)
    local totalValidTiles = 0;
    for i, centroid in pairs(BBM_HexMap.centroidsArray) do
        local centScore = self:ComputeBiasScoreCivCentroid(centroid);
        local meanPeninsulaScore = 0;
        local validTiles = self:GetValidSpawnsInHexList(BBM_HexMap, centroid.HexCluster);
        totalValidTiles = totalValidTiles + #validTiles;
    end    
end


