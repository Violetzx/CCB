--------------------------------------------------------------------------------
-- constant definition  --------------------------------------------------------
--------------------------------------------------------------------------------
-- Min distance definition
local BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE = {};
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Highlands_XP2.lua"] = 15
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Lakes.lua"] = 15
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["InlandSea.lua"] = 14
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Seven_Seas.lua"] = 13
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Primordial.lua"] = 13
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Pangaea.lua"] = 12
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["DWPangaea.lua"] = 12
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Shuffle.lua"] = 12
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Tilted_Axis.lua"] = 12
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Tilted_Axis.lua"] = 12
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Fractal.lua"] = 10
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Island_Plates.lua"] = 10
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Small_Continents.lua"] = 10
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Archipelago_XP2.lua"] = 10
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Continents.lua"] = 10
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Wetlands_XP2.lua"] = 10
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Continents_Islands.lua"] = 10
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Splintered_Fractal.lua"] = 10
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["DWArchipelago.lua"] = 10
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["DWFractal.lua"] = 10
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["DWMixedLand.lua"] = 10
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["DWSmallContinents.lua"] = 10
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["DWMixedIslands.lua"] = 10
BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE["Terra.lua"] = 8

-- Special civilisation types
BBS_LEADER_TYPE_SPECTATOR = "LEADER_SPECTATOR"

--------------------------------------------------------------------------------
-- Gather base game info and setup config --------------------------------------
--------------------------------------------------------------------------------

-- Get map size and min distance data
local Width, Height = Map.GetGridSize();
local minDistance = MapConfiguration.GetValue("BBSMinDistance");
local mapScript = MapConfiguration.GetValue("MAP_SCRIPT");

-- Set min distance if minDistance is nil or 0
if ((minDistance == nil or minDistance == 0) and mapScript ~= nil) then
    minDistance = BBS_MAP_MAP_SCRIPT_TO_MIN_DISTANCE[mapScript]
end

-- Adjust min distance in function of player number
minDistance = minDistance + BBS_DistanceFromPlayerCount()

Game:SetProperty("BBS_MAJOR_DISTANCE", minDistance)

-- Get map type

-- Get Players data
local civilisations = {}
local civilisationsIDs = PlayerManager.GetAliveMajorIDs();

for i = 1, PlayerManager.GetAliveMajorsCount() do
    local leader = PlayerConfigurations[civilisationsIDs[i]]:GetLeaderTypeName();
    local name = PlayerConfigurations[civilisationsIDs[i]]:GetCivilizationTypeName();
    local team = Players[civilisationsIDs[i]]:GetTeam();
    table.insert(civilisations, {
        leader = leader,
        name = name,
        team = team
    });
end

-- Get City States data
local citystates = {}
local citystatesIDs = PlayerManager.GetAliveMinorIDs();

for i = 1, PlayerManager.GetAliveMinorsCount() do
    local leader = PlayerConfigurations[citystatesIDs[i]]:GetLeaderTypeName();
    local name = PlayerConfigurations[citystatesIDs[i]]:GetCivilizationTypeName();

    table.insert(citystates, {
        leader = leader,
        name = name
    });
end

-- Get Bias all
local g_negative_bias = {}
local g_custom_bias = {}

local ret = DB.Query("SELECT * from StartBiasNegatives");
for key, value in pairs(ret) do
    if value.CivilizationType ~= nil then
        table.insert(g_negative_bias, {
            CivilizationType = value.CivilizationType,
            TerrainType = value.TerrainType,
            FeatureType = value.FeatureType,
            Tier = value.Tier,
            Extra = value.Extra
        });
    end
end

local ret = DB.Query("SELECT * from StartBiasCustom");
for key, value in pairs(ret) do
    if value.CivilizationType ~= nil then
        table.insert(g_custom_bias, {
            CivilizationType = value.CivilizationType,
            CustomPlacement = value.CustomPlacement
        });
    end
end

function BBS_DistanceFromPlayerCount()
    local civilisationsIDs = PlayerManager.GetAliveMajorIDs();
    local totalPlayers = 0
    for i = 1, PlayerManager.GetAliveMajorsCount() do
        player = PlayerConfigurations[civilisationsIDs[i]]
        if (player:GetLeaderTypeName() ~= BBS_LEADER_TYPE_SPECTATOR and player:GetHandicapTypeID() ~= 2021024770) then
            totalPlayers = totalPlayers + 1
        end
    end
    local mapSize = Map.GetMapSize();
    local numberPlayerSettings = (mapSize + 1) * 2
    if totalPlayers > numberPlayerSettings then
        return -2;
    elseif totalPlayers < numberPlayerSettings then
        return 2
    end
    return 0
end
