-- Game
Game:SetProperty(string, data);
Game:GetProperty(string);

-- GameInfo
GameInfo.StartBiasResources();
GameInfo.StartBiasFeatures();
GameInfo.StartBiasTerrains();
GameInfo.StartBiasRivers();
GameInfo.Resources();
--[[ GameInfo.Eras[EraType]; ]]--
GameInfo.Maps();
GameInfo.TypeTags();
--[[ GameInfo.Resources[ResourceType] ]]--
--[[ GameInfo.Leaders_XP2[LeaderType] ]]--
--[[ GameInfo.Leaders_XP2[LeaderType].OceanStart ]]--

-- GameConfiguration
GameConfiguration.GetStartEra();
GameConfiguration.GetValue(string);
GameConfiguration.IsAnyMultiplayer();

-- MapConfiguration
MapConfiguration.GetValue(string);

-- Players
--[[
    [list] of all Players accessible from IDS
    Players[ID]:GetTeam();
    Players[ID]:SetStartingPlot(plot);
    local plot = Players[ID]:GetStartingPlot();
    Players[ID]:IsAlive(); -- bool
    Players[ID]:IsMajor(); -- bool
]]--

-- PlayerManager
PlayerManager.GetAliveMajorIDs(); -- Civilisations
PlayerManager.GetAliveMinorIDs(); -- City States
PlayerManager.GetAliveMajorsCount();
PlayerManager.GetAliveMinorsCount();

-- PlayerConfigurations
--[[
    [list] of all civ in the game including CS accessible from IDS
    PlayerConfigurations[ID]:GetLeaderTypeName();
    PlayerConfigurations[ID]:GetCivilizationTypeName();
    PlayerConfigurations[ID]:GetHandicapTypeID(); --> 2021024770 seems to be not counted as real player.
]]--

-- TerrainBuilder
TerrainBuilder.SetTerrainType(plot, terrainID);
TerrainBuilder.SetFeatureType(plot, featureID, 1); -- if featureID is -1, no need for the added as last argument and will remove feature, need to check for flood plains.
TerrainBuilder.GetRandomNumber(range, string);

-- ResourceBuilder
ResourceBuilder.SetResourceType(plot, resourceID, 1);
ResourceBuilder.CanHaveResource(plot, resourceID); -- return bool
    
-- Map
Map.GetMapSize(); -- return map size from configs
local width, height = Map.GetGridSize(); -- return grid size
local count = Map.GetPlotCount(); -- return number of plots in the map
local plot = Map.GetPlotByIndex(plotIndex); -- return plot reference from plotIndex
local plot = Map.GetPlot(i , j); -- Get the reference of a plot from coordinates x, y
local plot = Map.GetAdjacentPlot(X, Y, index); -- What is index ?
local distance = Map.GetPlotDistance(indexA, indexB); -- return distance between 2 plots
local plot = Map.GetPlotXYWithRangeCheck(plotX, plotY, dx, dy, index) -- What is index ?
local plot = Map.GetPlotXY(plotX, plotY, dx, dy, index); -- What is index ?

-- Plot functions
-- from plot reference Types
plot:GetFeatureType();
plot:GetTerrainType();
plot:GetResourceType();
-- from plot reference getYields
plot:GetYield(g_YIELD_FOOD);
plot:GetYield(g_YIELD_PRODUCTION);
plot:GetYield(g_YIELD_GOLD);
plot:GetYield(g_YIELD_SCIENCE);
plot:GetYield(g_YIELD_CULTURE);
plot:GetYield(g_YIELD_FAITH);
-- Special plot functions
plot:IsRiver();
plot:IsLake();
plot:IsWater();
plot:IsImpassable();
plot:IsNaturalWonder();
-- Tile status
plot:IsFreshWater();
plot:IsCoastalLand();
-- Continent
plot:GetContinentType();
-- Indexing / coords from plot
plot:GetIndex();
plot:GetX();
plot:GetY();