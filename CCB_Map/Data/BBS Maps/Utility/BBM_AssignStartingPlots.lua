------------------------------------------------------------------------------
--	FILE:	BBS_AssignStartingPlot.lua    -- 2.2.0
--	AUTHOR:  Talasta, Keride, Vodairo
--	PURPOSE: Custom Spawn Placement Script
------------------------------------------------------------------------------
--	Copyright (c) 2014 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------
include("MapEnums");
include("MapUtilities");
include("FeatureGenerator");
include("TerrainGenerator");
include("NaturalWonderGenerator");
include("ResourceGenerator");
include("AssignStartingPlots");
include "BBM_MapUtils";
include "BBM_SpawnBalancing";
include "BBM_CivilizationAssign";

local BBS_VERSION = "2.2.0"

--------------------------------------------------------------------------------
-- constant definition  --------------------------------------------------------
--------------------------------------------------------------------------------
-- Special civilisations types
BBS_LEADER_TYPE_SPECTATOR = "LEADER_SPECTATOR"

--------------------------------------------------------------------------------
--  Init metatable -------------------------------------------------------------
--------------------------------------------------------------------------------
BBM_AssignStartingPlots = {};
local BBM_HexMap = {};
local BBM_Civilisations = {};
local BBM_Teams = {};
BBM_PlayerNumber = 0;
------------------------------------------------------------------------------
function ___Debug(...)
    print(...);
end

------------------------------------------------------------- BBS ----------------------------
function BBM_AssignStartingPlots.Create(args)
    bbs_game_config = {
        BBM_Team_Spawn = MapConfiguration.GetValue("BBM_Team_Spawn"),
        BBS_MAP_SCRIPT = MapConfiguration.GetValue("MAP_SCRIPT"),
        BBS_MAP_SIZE = Map.GetMapSize(),
        BBS_GAME_SYNC_SEED = GameConfiguration.GetValue("GAME_SYNC_RANDOM_SEED"),
        BBS_MULTIPLAYER_GAME = GameConfiguration.IsAnyMultiplayer(),
        BBS_GAME_SEED = MapConfiguration.GetValue("RANDOM_SEED"),
        BBS_BASE_TEMPERATURE = MapConfiguration.GetValue("temperature"),
        BBS_BOOL_TEMPERATURE = GameConfiguration.GetValue("BBStemp"),
        BBS_RAINFALL = MapConfiguration.GetValue("rainfall"),
        BBS_WORLD_AGE = MapConfiguration.GetValue("world_age"),
        BBS_RIDGE = MapConfiguration.GetValue("BBSRidge"),
        BBS_SEA_LEVEL = MapConfiguration.GetValue("sea_level"),
        BBS_STRATEGIC_RESOURCES = MapConfiguration.GetValue("BBSStratRes"),
        BBS_BASE_RESOURCES = MapConfiguration.GetValue("resources"),
        BBS_START = MapConfiguration.GetValue("start"),
        BBM_MIN_ATTEMPTS = MapConfiguration.GetValue("BBMMinAttempts"),
        BBM_MIN_DISTANCE = MapConfiguration.GetValue("BBMMinDistance")
    }

    instance = {
        __InitStartingData      = BBM_AssignStartingPlots.__InitStartingData,
        __FindBias              = BBM_AssignStartingPlots.__FindBias,
        __ComputeBiasScore      = BBM_AssignStartingPlots.__ComputeBiasScore,
        __GetTerrainIndex       = BBM_AssignStartingPlots.__GetTerrainIndex,
        __GetFeatureIndex       = BBM_AssignStartingPlots.__GetFeatureIndex,
        __GetResourceIndex      = BBM_AssignStartingPlots.__GetResourceIndex,
        __PlaceMajorCivs        = BBM_AssignStartingPlots.__PlaceMajorCivs,
        __ResetMajorsSpawns     = BBM_AssignStartingPlots.__ResetMajorsSpawns,
    }
    print("-----------------------")
    print("Starting BBM Placement",  os.date("%c"))
    print("-----------------------")
    -- Get Bias all
    bbs_negative_bias = {}
    bbs_custom_bias = {}
    -- Custom negative bias located in StartBiasNegatives table
    local ret = DB.Query("SELECT * from StartBiasNegatives");
    for key, value in pairs(ret) do
        if value.CivilizationType ~= nil then
            _Debug("StartBiasNegatives", value.CivilizationType, value.TerrainType,  value.FeatureType, value.Tier, value.Extra);
            table.insert(bbs_negative_bias, {
                CivilizationType = value.CivilizationType,
                TerrainType = value.TerrainType,
                FeatureType = value.FeatureType,
                Tier = value.Tier,
                Extra = value.Extra
            });
        end
    end

    -- Custom bias located in StartBiasNegatives table
    local ret = DB.Query("SELECT * from StartBiasCustom");
    for key, value in pairs(ret) do
        if value.CivilizationType ~= nil then
            _Debug("StartBiasCustom", value.CivilizationType, value.CustomPlacement);
            table.insert(bbs_custom_bias, {
                CivilizationType = value.CivilizationType,
                CustomPlacement = value.CustomPlacement
            });
        end
    end

    -- Get Players data
    local civilisationsIDs = PlayerManager.GetAliveMajorIDs();
    local playerIndex = 1;
    for i = 1, PlayerManager.GetAliveMajorsCount() do
        local player = Players[civilisationsIDs[i]];
        local leader = PlayerConfigurations[civilisationsIDs[i]]:GetLeaderTypeName();
        local name = PlayerConfigurations[civilisationsIDs[i]]:GetCivilizationTypeName();
        local team = Players[civilisationsIDs[i]]:GetTeam();
        local newCivilization = CivilizationAssignSpawn.new(player, leader, name, team, playerIndex)
        if leader ~= BBS_LEADER_TYPE_SPECTATOR then
            playerIndex = playerIndex + 1;
            BBM_Teams[team] = BBM_Teams[team] or {}
            _Debug("IsTeamerConfig - Added in team ", team)
            table.insert(BBM_Teams[team], newCivilization)
            BBM_PlayerNumber = BBM_PlayerNumber + 1;
        end
        _Debug("Leader added ", i, player, leader, name, team)
        table.insert(BBM_Civilisations, newCivilization);
    end

    -- Get City States data
    local BBS_Citystates = {}
    local citystatesIDs = PlayerManager.GetAliveMinorIDs();

    for i = 1, PlayerManager.GetAliveMinorsCount() do
        local player = Players[citystatesIDs[i]];
        local leader = PlayerConfigurations[citystatesIDs[i]]:GetLeaderTypeName();
        local name = PlayerConfigurations[citystatesIDs[i]]:GetCivilizationTypeName();
        local newCS = CivilizationAssignSpawn.new(player, leader, name, nil)

        table.insert(BBS_Citystates, newCS);
    end

    -- Adjust min distance in function of player number
    -- Count number of real players in the game
    total_players = 0
    for i = 1, PlayerManager.GetAliveMajorsCount() do
        player = PlayerConfigurations[civilisationsIDs[i]]
        if (player:GetLeaderTypeName() ~= BBS_LEADER_TYPE_SPECTATOR and player:GetHandicapTypeID() ~= 2021024770) then
            total_players = total_players + 1
        end
    end

    GlobalNumberOfRegions = total_players + PlayerManager.GetAliveMinorsCount();

    if MapConfiguration.GetValue("BBM_Team_Spawn") ~= nil then
        Teamers_Config = MapConfiguration.GetValue("BBM_Team_Spawn")
    end

    instance:__InitStartingData()

    if Contains(MapScripts, bbs_game_config.BBS_MAP_SCRIPT) == false then
        print("Map is not supported by BBM ' Firaxis placement will be used");
        Game:SetProperty("BBM_SUPPORTEDMAP", false)
        CallFiraxisPlacement(args);
        return instance;
    else
        Game:SetProperty("BBM_SUPPORTEDMAP", true)
        print("Map is supported by BBM");
    end

    -- Set game properties
    Game:SetProperty("BBM_MAJOR_DISTANCE", BBM_HexMap.minimumDistanceMajorToMajorCivs);

    print("Start Assign Score Centroid",  os.date("%c"))

    local isTeamer = Is1v1OrTeamerConfig();

    -- Define scores for centroids and place 
    local team1Index = 0;
    local team2Index = 0;
    local firstTeamNumber = nil;
    for _, civ in pairs(BBM_Civilisations) do
        -- On RTS East vs West mod, define position by index (spectator excluded) pp
        -- With odd number teams, the additionnal player will be in sim position
        _Debug("BBM_Teams[civ.CivilizationTeam] = ", civ.CivilizationTeam, BBM_Teams[civ.CivilizationTeam])
        if civ.CivilizationLeader ~= BBS_LEADER_TYPE_SPECTATOR then
            local playerTeamIndex;
            if firstTeamNumber == nil then
                firstTeamNumber = civ.CivilizationTeam
            end
            if civ.CivilizationTeam == firstTeamNumber then
                team1Index = team1Index + 1;
                playerTeamIndex = team1Index;
            else
                team2Index = team2Index + 1;
                playerTeamIndex = team2Index;
            end
            local teamSize = #BBM_Teams[civ.CivilizationTeam] or 1    
            
            if BBM_HexMap.TeamerConfig == TeamerConfigEastVsWest then
                civ.TeamerSim = playerTeamIndex <= teamSize / 2 + teamSize % 2;
                civ.TeamerWar = playerTeamIndex > teamSize / 2 + teamSize % 2;
            end  
        end
        civ:CalculateTotalScores(BBM_HexMap);
    end

    print("End Assign Score Centroid",  os.date("%c"))

    print("Start Assign spawn order",  os.date("%c"))
    -- Define spawn order 
    -- Comparing first the number of valid tiles, placing first 
    for _, civ in pairs(BBM_Civilisations) do
        _Debug(tostring(civ.CivilizationLeader).." - ScoreTotal = "..tostring(civ.TotalMapScore).." -  Valid tiles = "..tostring(civ.TotalValidTiles))
    end

    table.sort(BBM_Civilisations,
            function(a, b)
                if a.TotalValidTiles == b.TotalValidTiles then
                    if a.TotalMapScore == b.TotalMapScore then
                        return a.RandomPlaceIdOrder < b.RandomPlaceIdOrder;
                    else
                        return a.TotalMapScore < b.TotalMapScore
                    end
                else
                    -- less score = more constraints for bias respect
                    return a.TotalValidTiles < b.TotalValidTiles
                end
            end)

    for _, civ in pairs(BBM_Civilisations) do
        _Debug(tostring(civ.CivilizationLeader).." - ScoreTotal = "..tostring(civ.TotalMapScore).." -  Valid tiles = "..tostring(civ.TotalValidTiles))
    end

    -- Recursive call 
    local BBS_AssignTries = 0;
    local BBS_Success = false;
    local TriesMajorSpawnableLeft = {};
    while BBS_Success == false and BBS_AssignTries < bbs_game_config.BBM_MIN_ATTEMPTS do
        BBS_AssignTries = BBS_AssignTries + 1;
        -- Place all civs and fill BBM_HexMap.tempMajorSpawns
        local placementOK = instance:__PlaceMajorCivs(BBM_Civilisations, BBM_HexMap, BBS_AssignTries);
        -- Determine how many spawnable tiles left
        local countMajorSpawnableLeft = BBM_HexMap:GetNumberMajorSpawnable(true);
        TriesMajorSpawnableLeft[BBS_AssignTries] = countMajorSpawnableLeft;
       
        instance:__ResetMajorsSpawns(BBM_Civilisations, BBM_HexMap);
        if placementOK == false then
            --instance:__ResetMajorsSpawns(BBM_Civilisations, BBM_HexMap);
            BBM_HexMap.tempMajorSpawns[BBS_AssignTries] = {};
            print("Failed try number "..tostring(BBS_AssignTries))
        else
            print("BBS_Success on try "..tostring(BBS_AssignTries),  os.date("%c"))
        end
    end
    local maxMeanScore = 0;
    local globalMinScore = 0;
    local maxMeanScoreIndex = 0
    local globalMajorSpawnableScore = 0;
    for index, c in pairs(BBM_HexMap.tempMajorSpawns) do
        local list = BBM_HexMap.tempMajorSpawns[index]
        local majorSpawnableScore = TriesMajorSpawnableLeft[index]
        local minLocalScore = 9999;
        local maxLocalScore = 0;
        local minDiffScore = 0;
        local meanScore = 0
        if #list > 0 then
            local totalScore = 0
            for _, civscore in pairs(list) do
                totalScore = totalScore + civscore.Score;
                if civscore.Score < minLocalScore then
                    minLocalScore = civscore.Score;
                end
                if civscore.Score > maxLocalScore then
                    maxLocalScore = civscore.Score;
                end
            end

            _Debug("majorSpawnableScore = ", majorSpawnableScore);

            meanScore = totalScore / #list
            if isTeamer and BBM_HexMap:IsTeamerValidContinentPlacement(index) == false then
                print("Malus try score because all team spawns in a single continent")
                meanScore = meanScore - 20;
            end

            minDiffScore = maxLocalScore - minLocalScore
            -- Take the highest minimum score, if equals, highest mean
            if (minLocalScore > globalMinScore) or (meanScore > maxMeanScore and minLocalScore >= globalMinScore) then
                BBS_Success = true;
                --globalMinDiffScore = minDiffScore;
                maxMeanScore = meanScore;
                globalMinScore = minLocalScore;
                globalMajorSpawnableScore = majorSpawnableScore;
                maxMeanScoreIndex = index;
            end
        end
        print("Assign mean score for try "..tostring(index).." = "..meanScore.." with minimum score of "..tostring(minLocalScore).." and maximum of "..tostring(maxLocalScore))
    end

    print("End Assign spawn order",  os.date("%c"))
    print("BBS_AssignTries = "..tostring(BBS_AssignTries).." - BBS_Success = "..tostring(BBS_Success))
    if BBS_Success then
        print("Selected try max score = "..tostring(maxMeanScoreIndex))
        if isTeamer then
            Game:SetProperty("BBS_TEAMERCONTINENTCHECK", BBM_HexMap:IsTeamerValidContinentPlacement(maxMeanScoreIndex))
        end
        for _, c in pairs(BBM_HexMap.tempMajorSpawns[maxMeanScoreIndex]) do
            _Debug("tempMajorSpawns AssignMajorCivSpawn for "..c.Civ.CivilizationLeader.." "..c.Spawn:PrintXY())
            c.Civ:AssignMajorCivSpawn(BBM_HexMap, c.Spawn);
        end
         -- Firaxis methods for attribution of spawns 
        for j, civ in pairs(BBM_Civilisations) do
            if civ.CivilizationLeader ~= BBS_LEADER_TYPE_SPECTATOR then
                civ.Player:SetStartingPlot(civ.StartingHex.Plot)
                table.insert(BBM_HexMap.majorSpawns, civ.StartingHex);
                local bW, nbW = civ.StartingHex:HasSpawnEnoughWalkableTiles()
                _Debug(civ.CivilizationLeader.." spawn = "..tostring(civ.StartingHex:PrintXY()).." - HasWalkableRequirements = "..tostring(bW).." "..tostring(nbW));
            else
                local hex0 = BBM_HexMap:GetHexInMap(j, 0);
                civ.Player:SetStartingPlot(hex0.Plot)
            end
        end
        -- Measure minimum distance
        local closestDist = 9999
        for _, hex in ipairs(BBM_HexMap.majorSpawns) do
            local localClosestDist = hex:DistanceToClosest(BBM_HexMap, BBM_HexMap.majorSpawns)
            if localClosestDist < closestDist then
                closestDist = localClosestDist;
            end
        end
        Game:SetProperty("BBM_ACTUALMINDIST", closestDist)
        _Debug("BBM_ACTUALMINDIST = ", closestDist)
        _Debug("BBM_ACTUALMINDIST GameProperty = ", Game:GetProperty("BBM_ACTUALMINDIST"))
        print("Start BalanceMap",  os.date("%c"))
        BalanceMap(BBM_HexMap);

        print("Start InitSpawnBalancing",  os.date("%c"))
        local allSpawnBalancing = {}
        for _, civ in pairs(BBM_Civilisations) do
            if civ.CivilizationLeader ~= BBS_LEADER_TYPE_SPECTATOR then
                local spawn = InitSpawnBalancing(BBM_HexMap, civ);
                table.insert(allSpawnBalancing, spawn);
            end
        end
        printAllStartYields(BBM_HexMap);
        BalanceAllCivYields(allSpawnBalancing)
        print("End InitSpawnBalancing",  os.date("%c"))
        
        -- randomly place cs in free space
        for i, cs in pairs(BBS_Citystates) do
            local foundSpawn = false
            local validspawnsleft = BBM_HexMap:GetAnyMinorSpawnablesTiles()
            while foundSpawn == false do
                local rng = TerrainBuilder.GetRandomNumber(#validspawnsleft - 1, "Random valid spawns");
                local testedHex = validspawnsleft[rng+1]
                if testedHex.IsCivStartingPlot == false then
                    foundSpawn = true;
                    cs:AssignMinorCivSpawn(BBM_HexMap, testedHex)
                    cs.Player:SetStartingPlot(cs.StartingHex.Plot)
                    _Debug("CS "..tostring(i).." - "..tostring(cs.CivilizationName).." spawn = "..tostring(cs.StartingHex:PrintXY()))
                end
            end
            
        end
        Game:SetProperty("BBM_RESPAWN", true)
        print("End Assign Centroid",  os.date("%c"))
    else
        print("BBM: To Many Attempts Failed - Go to Firaxis Placement")
        CallFiraxisPlacement(args);
    end   
    
    print("-----------------------")
    print("Ending BBM Placement",  os.date("%c"))
    print("-----------------------")
    return instance
end

BBS_resources_count = {};

-- Check bias in cluster
-- Check closest water tile from center of cluster
-- Exclude distance to player

-- 1: Min distance between civilisations
-- 2: Spawn bias
-- 3: Fresh water settle
function BBM_AssignStartingPlots:__InitStartingData()
    _Debug("Start parsing map",  os.date("%c"))
    -- Datas stored in HexMap object
    local width, height = Map.GetGridSize();
    BBM_HexMap = HexMap.new(width, height, bbs_game_config.BBS_MAP_SCRIPT);

    --BBM_HexMap:PrintHexSpawnableMap();
    BBM_HexMap:PrintHexPeninsuleMap();

    BBM_HexMap:RunKmeans(GlobalNumberOfRegions, 30);
    BBM_HexMap:PrintHexMap();
    for _, c in pairs(BBM_HexMap.centroidsArray) do
        c:ComputeCentroidScore();
    end
    -- TEMP get hexes from a region (same centroid)
    -- TEMP count % of hills in a region
    for index, centroid in ipairs(BBM_HexMap.centroidsArray) do
        if centroid.HexCluster ~= nil and #centroid.HexCluster > 0 then 
            local count = centroid:GetHillsInCluster();
            local hillPercent = (count / #centroid.HexCluster) * 100
            _Debug("Number of hill in centroid "..tostring(index).." = "..tostring(count).." for a total of "..tostring(#centroid.HexCluster).." tiles (="..tostring(hillPercent).."%)")
            local luxCount, bonusCount, strategicsCount = centroid:GetTotalResourcesCountInCluster();
            _Debug("Number of lux resource in centroid "..tostring(index).." = "..tostring(luxCount))
            _Debug("Number of bonus resource in centroid "..tostring(index).." = "..tostring(bonusCount))
            _Debug("Number of strat resource in centroid "..tostring(index).." = "..tostring(strategicsCount))
        end
    end
    -- Count % of hills on the land map
    local countHills, _ = BBM_HexMap:LookForHills();
    local countLandTiles, _ = BBM_HexMap:GetLandHexList();
    _Debug("totalLandPlots = "..tostring(countLandTiles))
    _Debug("totalHillPlots = "..tostring(countHills))
    _Debug("totalCostal = "..tostring(#BBM_HexMap.mapCostal))
    local hillpercent = (countHills / countLandTiles) * 100
    _Debug("Hill% = "..tostring(hillpercent).." %")
    _Debug("Done parsing map",  os.date("%c"))
end

function BBM_AssignStartingPlots:__PlaceMajorCivs(civs, BBM_HexMap, index) 
-- TODO : manage cases when unable to place a civ => rollback and try again
    BBM_HexMap.tempMajorSpawns[index] = {};
    
    for ind, civ in pairs(civs) do
        if civ.CivilizationLeader ~= BBS_LEADER_TYPE_SPECTATOR then
            local placed, spawnHex, score = civ:AssignSpawnByCentroid(BBM_HexMap);
            if placed == false then
                print("Failed to place civ "..tostring(civ.CivilizationLeader))
                return false;
            end
            table.insert(BBM_HexMap.tempMajorSpawns[index], {Civ = civ, Spawn = spawnHex, Score = score});
            if BBM_HexMap.TeamerConfig == TeamerConfigEastVsWest then
                BBM_HexMap.RTSContinentSetup = BBM_HexMap.RTSContinentSetup or {}
                BBM_HexMap.RTSContinentSetup[civ.CivilizationTeam] = spawnHex.IslandId;
                if spawnHex:GetX() > BBM_HexMap.MiddleX then
                    civ.TeamerSide = EastTeam;
                else
                    civ.TeamerSide = WestTeam;
                end
                for team, _ in pairs(BBM_Teams) do
                    for _, teamCiv in pairs(BBM_Teams[team]) do
                        if teamCiv.TeamerSide == "" then
                            if civ.CivilizationTeam == teamCiv.CivilizationTeam then
                                _Debug("Going through same team civ ", teamCiv.CivilizationLeader, teamCiv.CivilizationTeam, civ.TeamerSide);
                                teamCiv.TeamerSide = civ.TeamerSide;
                                teamCiv.TeamerContinentId = spawnHex.IslandId;
                            else
                                _Debug("Other side for opposing team ", teamCiv.CivilizationLeader, teamCiv.CivilizationTeam, civ.TeamerSide);
                                teamCiv.TeamerSide = getRTSOtherSide(civ.TeamerSide);
                            end
                        end
                    end
                end
                
            end
            _Debug("Civ ", ind, " in team ", civ.CivilizationTeam, " - Continent ID = ", spawnHex.IdContinent)
        end
    end
    return true;
end

-- teamerSide = EastTeam or WestTeam global var
function getRTSOtherSide(teamerSide)
    if teamerSide == EastTeam then
        return WestTeam;
    elseif teamerSide == WestTeam then
        return EastTeam;
    end
end

function BBM_AssignStartingPlots:__ResetMajorsSpawns(civs, BBM_HexMap)
    BBM_HexMap.majorSpawns = {};
    BBM_HexMap:ResetSpawnableHex();
    for _, civ in pairs(civs) do
        if civ.AttributedCentroid ~= nil then
            civ.AttributedCentroid.PlacedCiv = false;
            civ.TeamerSide = "";
        end
        civ.AttributedCentroid = nil;
        civ.StartingHex = {};
    end
end

-- 1v1 or 2 teams 
-- Fixed index is used here in case team number is not the usual 1 and 2
function Is1v1OrTeamerConfig()
    local teamCount = 0
    local team1Size = 0
    local team2Size = 0
    local fixedIndex = 1
    for team, _ in pairs(BBM_Teams) do
        teamCount = teamCount + 1;
        if fixedIndex == 1 then
            team1Size = #BBM_Teams[team]
        elseif fixedIndex == 2 then
            team2Size = #BBM_Teams[team]
        end
        fixedIndex = fixedIndex + 1;
    end
    local isTeamerConfig = teamCount == 2;
    _Debug("IsTeamerConfig : ", teamCount, team1Size, team2Size, isTeamerConfig);
    return isTeamerConfig;
end

-- Call default fixaris placement script
function CallFiraxisPlacement(args)
    Game:SetProperty("BBM_RESPAWN", false)
    local argSPlot = AssignStartingPlots.Create(args)
end