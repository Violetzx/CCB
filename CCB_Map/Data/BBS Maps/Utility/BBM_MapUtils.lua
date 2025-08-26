
---------------------------------------
-- Firaxis constants maps scripts
---------------------------------------
MapScripts = {};
MapScripts.MAP_HIGHLANDS = "Highlands_XP2.lua"
MapScripts.MAP_RICH_HIGHLANDS = "rich_highlands_xp2.lua"
MapScripts.MAP_LAKES = "Lakes.lua"
MapScripts.MAP_INLAND_SEA = "InlandSea.lua"
MapScripts.MAP_SEVEN_SEAS = "Seven_Seas.lua"
MapScripts.MAP_PRIMORDIAL = "Primordial.lua"
MapScripts.MAP_PANGAEA = "Pangaea.lua"
MapScripts.MAP_TILTED_AXIS = "Tilted_Axis.lua"
MapScripts.MAP_TILTED_AXIS_WRAP = "Tilted_Axis_Wrap.lua"
MapScripts.MAP_FRACTAL = "Fractal.lua"
MapScripts.MAP_ISLAND_PLATES = "Island_Plates.lua"
MapScripts.MAP_SMALL_CONTINENTS = "Small_Continents.lua"
MapScripts.MAP_CONTINENTS = "Continents.lua"
MapScripts.MAP_WETLANDS = "Wetlands_XP2.lua"
MapScripts.MAP_CONTINENTS_ISLANDS = "Continents_Islands.lua"
MapScripts.MAP_SPLINTERED_FRACTAL = "Splintered_Fractal.lua"
MapScripts.MAP_TERRA = "Terra.lua"
MapScripts.MAP_PANGAEA_ULTIMA = "pangaea_ultima.lua"

g_FEATURE_VOLCANO			    = GetGameInfoIndex("Features", "FEATURE_VOLCANO");
g_FEATURE_VOLCANIC_SOIL			= GetGameInfoIndex("Features", "FEATURE_VOLCANIC_SOIL");
g_FEATURE_GEOTHERMAL_FISSURE	= GetGameInfoIndex("Features", "FEATURE_GEOTHERMAL_FISSURE");


g_RESOURCE_NONE				    = -1;
g_RESOURCE_BANANAS				= GetGameInfoIndex("Resources", "RESOURCE_BANANAS");--0
g_RESOURCE_CATTLE				= GetGameInfoIndex("Resources", "RESOURCE_CATTLE");
g_RESOURCE_COPPER               = GetGameInfoIndex("Resources", "RESOURCE_COPPER");
g_RESOURCE_CRABS				= GetGameInfoIndex("Resources", "RESOURCE_CRABS");
g_RESOURCE_DEER				    = GetGameInfoIndex("Resources", "RESOURCE_DEER");
g_RESOURCE_FISH                 = GetGameInfoIndex("Resources", "RESOURCE_FISH");--5
g_RESOURCE_RICE     			= GetGameInfoIndex("Resources", "RESOURCE_RICE");
g_RESOURCE_SHEEP    			= GetGameInfoIndex("Resources", "RESOURCE_SHEEP");
g_RESOURCE_STONE                = GetGameInfoIndex("Resources", "RESOURCE_STONE");
g_RESOURCE_WHEAT                = GetGameInfoIndex("Resources", "RESOURCE_WHEAT");
g_RESOURCE_CITRUS               = GetGameInfoIndex("Resources", "RESOURCE_CITRUS");--10
g_RESOURCE_COCOA                = GetGameInfoIndex("Resources", "RESOURCE_COCOA");
g_RESOURCE_COFFEE               = GetGameInfoIndex("Resources", "RESOURCE_COFFEE");
g_RESOURCE_COTTON               = GetGameInfoIndex("Resources", "RESOURCE_COTTON");
g_RESOURCE_DIAMONDS             = GetGameInfoIndex("Resources", "RESOURCE_DIAMONDS");
g_RESOURCE_DYES                 = GetGameInfoIndex("Resources", "RESOURCE_DYES");--15
g_RESOURCE_FURS                 = GetGameInfoIndex("Resources", "RESOURCE_FURS");
g_RESOURCE_GYPSUM               = GetGameInfoIndex("Resources", "RESOURCE_GYPSUM");
g_RESOURCE_INCENSE              = GetGameInfoIndex("Resources", "RESOURCE_INCENSE");
g_RESOURCE_IVORY                = GetGameInfoIndex("Resources", "RESOURCE_IVORY");
g_RESOURCE_JADE                 = GetGameInfoIndex("Resources", "RESOURCE_JADE");--20
g_RESOURCE_MARBLE               = GetGameInfoIndex("Resources", "RESOURCE_MARBLE");
g_RESOURCE_MERCURY              = GetGameInfoIndex("Resources", "RESOURCE_MERCURY");
g_RESOURCE_PEARLS               = GetGameInfoIndex("Resources", "RESOURCE_PEARLS");
g_RESOURCE_SALT                 = GetGameInfoIndex("Resources", "RESOURCE_SALT");
g_RESOURCE_SILK                 = GetGameInfoIndex("Resources", "RESOURCE_SILK");--25
g_RESOURCE_SILVER               = GetGameInfoIndex("Resources", "RESOURCE_SILVER");
g_RESOURCE_SPICES               = GetGameInfoIndex("Resources", "RESOURCE_SPICES");
g_RESOURCE_SUGAR                = GetGameInfoIndex("Resources", "RESOURCE_SUGAR");
g_RESOURCE_TEA                  = GetGameInfoIndex("Resources", "RESOURCE_TEA");
g_RESOURCE_TOBACCO              = GetGameInfoIndex("Resources", "RESOURCE_TOBACCO");--30
g_RESOURCE_TRUFFLES             = GetGameInfoIndex("Resources", "RESOURCE_TRUFFLES");
g_RESOURCE_WHALES               = GetGameInfoIndex("Resources", "RESOURCE_WHALES");
g_RESOURCE_WINE                 = GetGameInfoIndex("Resources", "RESOURCE_WINE");
g_RESOURCE_JEANS                = GetGameInfoIndex("Resources", "RESOURCE_JEANS");
g_RESOURCE_PERFUME              = GetGameInfoIndex("Resources", "RESOURCE_PERFUME");--35
g_RESOURCE_COSMETICS            = GetGameInfoIndex("Resources", "RESOURCE_COSMETICS");
g_RESOURCE_TOYS                 = GetGameInfoIndex("Resources", "RESOURCE_TOYS");
g_RESOURCE_CINNAMON             = GetGameInfoIndex("Resources", "RESOURCE_CINNAMON");
g_RESOURCE_CLOVES               = GetGameInfoIndex("Resources", "RESOURCE_CLOVES");
g_RESOURCE_ALUMINUM             = GetGameInfoIndex("Resources", "RESOURCE_ALUMINUM");--40
g_RESOURCE_COAL                 = GetGameInfoIndex("Resources", "RESOURCE_COAL");
g_RESOURCE_HORSES               = GetGameInfoIndex("Resources", "RESOURCE_HORSES");
g_RESOURCE_IRON                 = GetGameInfoIndex("Resources", "RESOURCE_IRON");
g_RESOURCE_NITER                = GetGameInfoIndex("Resources", "RESOURCE_NITER");
g_RESOURCE_OIL                  = GetGameInfoIndex("Resources", "RESOURCE_OIL");--45
g_RESOURCE_URANIUM              = GetGameInfoIndex("Resources", "RESOURCE_URANIUM");
g_RESOURCE_ANTIQUITY_SITE       = GetGameInfoIndex("Resources", "RESOURCE_ANTIQUITY_SITE");
g_RESOURCE_SHIPWRECK            = GetGameInfoIndex("Resources", "RESOURCE_SHIPWRECK");
g_RESOURCE_AMBER                = GetGameInfoIndex("Resources", "RESOURCE_AMBER");
g_RESOURCE_OLIVES               = GetGameInfoIndex("Resources", "RESOURCE_OLIVES");--50
g_RESOURCE_TURTLES              = GetGameInfoIndex("Resources", "RESOURCE_TURTLES");
-- Resources were added with Mayan DLC so we should not set them to nil if they not exist in database
g_RESOURCE_MAIZE                = GetGameInfoIndex("Resources", "RESOURCE_MAIZE") or 52;
g_RESOURCE_HONEY                = GetGameInfoIndex("Resources", "RESOURCE_HONEY") or 53;
-- BBG Extended 
g_RESOURCE_PENGUINS             = GetGameInfoIndex("Resources", "RESOURCE_P0K_PENGUINS") or 54;
g_RESOURCE_POMEGRANATES         = GetGameInfoIndex("Resources", "RESOURCE_CVS_POMEGRANATES") or 55;
g_RESOURCE_PAPYRUS              = GetGameInfoIndex("Resources", "RESOURCE_P0K_PAPYRUS") or 56;
g_RESOURCE_MAPLE                = GetGameInfoIndex("Resources", "RESOURCE_P0K_MAPLE") or 57;
g_RESOURCE_OPAL                 = GetGameInfoIndex("Resources", "RESOURCE_P0K_OPAL") or 58;
g_RESOURCE_PLUMS                = GetGameInfoIndex("Resources", "RESOURCE_P0K_PLUMS") or 59;




g_RESOURCES_LUX_LIST = {}
g_RESOURCES_LUX_LIST[g_RESOURCE_CITRUS]= true;--Plains/Grass
g_RESOURCES_LUX_LIST[g_RESOURCE_COCOA]= true;--Jungle
g_RESOURCES_LUX_LIST[g_RESOURCE_COFFEE]= true;--Jungle/Grass
g_RESOURCES_LUX_LIST[g_RESOURCE_COTTON]= true;--Plains/Grass/Flood
g_RESOURCES_LUX_LIST[g_RESOURCE_DIAMONDS]= true;--Jungle / Hill
g_RESOURCES_LUX_LIST[g_RESOURCE_DYES]= true;--Forest/Jungle
g_RESOURCES_LUX_LIST[g_RESOURCE_FURS]= true;--Forest/Tundra
g_RESOURCES_LUX_LIST[g_RESOURCE_GYPSUM]= true;--Plains/PlainsHills
g_RESOURCES_LUX_LIST[g_RESOURCE_INCENSE]= true;--Desert/Plains
g_RESOURCES_LUX_LIST[g_RESOURCE_IVORY]= true;--Forest/Jungle/Plains/PlainsHills/Desert
g_RESOURCES_LUX_LIST[g_RESOURCE_JADE]= true;--Grass/Tundra
g_RESOURCES_LUX_LIST[g_RESOURCE_MARBLE]= true;--Grass/GrassHills/PlainsHills
g_RESOURCES_LUX_LIST[g_RESOURCE_MERCURY]= true;--Plains
g_RESOURCES_LUX_LIST[g_RESOURCE_PEARLS]= true;--Coast
g_RESOURCES_LUX_LIST[g_RESOURCE_SALT]= true;--Desert/Plains/Tundra
g_RESOURCES_LUX_LIST[g_RESOURCE_SILK]= true;--Forest
g_RESOURCES_LUX_LIST[g_RESOURCE_SILVER]= true;--DesertFlat+Hills/Tundra Flat+Hills
g_RESOURCES_LUX_LIST[g_RESOURCE_SPICES]= true;--Forest/Jungle
g_RESOURCES_LUX_LIST[g_RESOURCE_SUGAR]= true;--Flood/Marsh
g_RESOURCES_LUX_LIST[g_RESOURCE_TEA]= true;--Grass/Grass Hills
g_RESOURCES_LUX_LIST[g_RESOURCE_TOBACCO]= true;--Grass/Plains/Jungle/Forest
g_RESOURCES_LUX_LIST[g_RESOURCE_TRUFFLES]= true;--Forest/Jungle/Marsh
g_RESOURCES_LUX_LIST[g_RESOURCE_WHALES]= true;--Coast
g_RESOURCES_LUX_LIST[g_RESOURCE_WINE]= true;--Forest/Plains/Grass
g_RESOURCES_LUX_LIST[g_RESOURCE_JEANS]= true;
g_RESOURCES_LUX_LIST[g_RESOURCE_PERFUME]= true;
g_RESOURCES_LUX_LIST[g_RESOURCE_COSMETICS]= true;
g_RESOURCES_LUX_LIST[g_RESOURCE_TOYS]= true;
g_RESOURCES_LUX_LIST[g_RESOURCE_CINNAMON]= true;
g_RESOURCES_LUX_LIST[g_RESOURCE_CLOVES]= true;
g_RESOURCES_LUX_LIST[g_RESOURCE_AMBER]= true;--Forest/Jungle/coast
g_RESOURCES_LUX_LIST[g_RESOURCE_OLIVES]= true;--Plains
g_RESOURCES_LUX_LIST[g_RESOURCE_TURTLES]= true;--Coast
g_RESOURCES_LUX_LIST[g_RESOURCE_HONEY]= true;--Plains/Grass
g_RESOURCES_LUX_LIST[g_RESOURCE_PENGUINS]= true;--AllFlat/AllHills
g_RESOURCES_LUX_LIST[g_RESOURCE_POMEGRANATES]= true;--Plains/PlainsHills/Flood/Grass
g_RESOURCES_LUX_LIST[g_RESOURCE_PAPYRUS]= true;--Marsh/Flood
g_RESOURCES_LUX_LIST[g_RESOURCE_MAPLE]= true;--Plains/PlainsHills/Grass/GrassHills
g_RESOURCES_LUX_LIST[g_RESOURCE_OPAL]= true;--DesertHills/Plains/PlainsHills/TundraHills
g_RESOURCES_LUX_LIST[g_RESOURCE_PLUMS]= true;--Plains/Grass/GrassHills

-- Lux placement forced requirements for adding lux purposes (flat, hill or forest)
-- Only take most restrictives lux, not these that can be flat or hills, only flat lux or only forest
g_LUX_ON_FLAT_PLAINS_LIST = {}
g_LUX_ON_FLAT_PLAINS_LIST[g_RESOURCE_CITRUS]= true
g_LUX_ON_FLAT_PLAINS_LIST[g_RESOURCE_COTTON]= true
g_LUX_ON_FLAT_PLAINS_LIST[g_RESOURCE_INCENSE]= true
g_LUX_ON_FLAT_PLAINS_LIST[g_RESOURCE_GYPSUM]= true
g_LUX_ON_FLAT_PLAINS_LIST[g_RESOURCE_MERCURY]= true
g_LUX_ON_FLAT_PLAINS_LIST[g_RESOURCE_SALT]= true
g_LUX_ON_FLAT_PLAINS_LIST[g_RESOURCE_OLIVES]= true
g_LUX_ON_FLAT_PLAINS_LIST[g_RESOURCE_HONEY]= true
g_LUX_ON_FLAT_PLAINS_LIST[g_RESOURCE_PLUMS]= true

g_LUX_ON_FLAT_GRASS_LIST = {}
g_LUX_ON_FLAT_GRASS_LIST[g_RESOURCE_CITRUS]= true
g_LUX_ON_FLAT_GRASS_LIST[g_RESOURCE_COFFEE]= true
g_LUX_ON_FLAT_GRASS_LIST[g_RESOURCE_JADE]= true
g_LUX_ON_FLAT_GRASS_LIST[g_RESOURCE_MARBLE]= true
g_LUX_ON_FLAT_GRASS_LIST[g_RESOURCE_TEA]= true
g_LUX_ON_FLAT_GRASS_LIST[g_RESOURCE_HONEY]= true

g_LUX_ON_FOREST_LIST = {}
g_LUX_ON_FOREST_LIST[g_RESOURCE_DYES] = true
g_LUX_ON_FOREST_LIST[g_RESOURCE_FURS] = true
g_LUX_ON_FOREST_LIST[g_RESOURCE_SILK] = true
g_LUX_ON_FOREST_LIST[g_RESOURCE_TOBACCO] = true
g_LUX_ON_FOREST_LIST[g_RESOURCE_TRUFFLES] = true
g_LUX_ON_FOREST_LIST[g_RESOURCE_SPICES] = true
g_LUX_ON_FOREST_LIST[g_RESOURCE_AMBER] = true

-- List of lux with bonus culture, science or faith
g_RESOURCES_LUX_EXTRA_YIELD = {}
-- Culture
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_AMBER]= true;
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_COFFEE]= true;
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_JADE]= true;
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_MARBLE]= true;
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_SILK]= true;
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_PLUMS]= true;

-- Science
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_MERCURY]= true;
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_TEA]= true;
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_TURTLES]= true;
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_PENGUINS]= true;
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_PAPYRUS]= true;

-- Faith
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_DYES]= true;
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_INCENSE]= true;
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_PEARLS]= true;
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_TOBACCO]= true;
g_RESOURCES_LUX_EXTRA_YIELD[g_RESOURCE_POMEGRANATES]= true;

g_RESOURCES_BONUS_LIST = {}
g_RESOURCES_BONUS_LIST[g_RESOURCE_BANANAS]= true;
g_RESOURCES_BONUS_LIST[g_RESOURCE_CATTLE]= true;
g_RESOURCES_BONUS_LIST[g_RESOURCE_COPPER]= true;
g_RESOURCES_BONUS_LIST[g_RESOURCE_CRABS]= true;
g_RESOURCES_BONUS_LIST[g_RESOURCE_DEER]= true;
g_RESOURCES_BONUS_LIST[g_RESOURCE_FISH]= true;
g_RESOURCES_BONUS_LIST[g_RESOURCE_RICE]= true;
g_RESOURCES_BONUS_LIST[g_RESOURCE_SHEEP]= true;
g_RESOURCES_BONUS_LIST[g_RESOURCE_STONE]= true;
g_RESOURCES_BONUS_LIST[g_RESOURCE_WHEAT]= true;
g_RESOURCES_BONUS_LIST[g_RESOURCE_MAIZE]= true;

g_RESOURCES_FARM_LIST = {}
g_RESOURCES_FARM_LIST[g_RESOURCE_RICE]= true;
g_RESOURCES_FARM_LIST[g_RESOURCE_WHEAT]= true;
g_RESOURCES_FARM_LIST[g_RESOURCE_MAIZE]= true;

g_RESOURCES_MINE_LIST = {}
g_RESOURCES_MINE_LIST[g_RESOURCE_DIAMONDS]= true;
g_RESOURCES_MINE_LIST[g_RESOURCE_JADE]= true;
g_RESOURCES_MINE_LIST[g_RESOURCE_AMBER]= true;
g_RESOURCES_MINE_LIST[g_RESOURCE_MERCURY]= true;
g_RESOURCES_MINE_LIST[g_RESOURCE_SALT]= true;
g_RESOURCES_MINE_LIST[g_RESOURCE_SILVER]= true;
g_RESOURCES_MINE_LIST[g_RESOURCE_COPPER]= true;
g_RESOURCES_MINE_LIST[g_RESOURCE_IRON]= true;
g_RESOURCES_MINE_LIST[g_RESOURCE_NITER]= true;
g_RESOURCES_MINE_LIST[g_RESOURCE_COAL]= true;
g_RESOURCES_MINE_LIST[g_RESOURCE_ALUMINUM]= true;
g_RESOURCES_MINE_LIST[g_RESOURCE_URANIUM]= true;
g_RESOURCES_MINE_LIST[g_RESOURCE_OPAL]= true;

g_RESOURCES_QUARRY_LIST = {};
g_RESOURCES_QUARRY_LIST[g_RESOURCE_STONE] = true;
g_RESOURCES_QUARRY_LIST[g_RESOURCE_MARBLE] = true;
g_RESOURCES_QUARRY_LIST[g_RESOURCE_GYPSUM] = true;

g_RESOURCES_PASTURE_LIST = {}
g_RESOURCES_PASTURE_LIST[g_RESOURCE_HORSES]= true;
g_RESOURCES_PASTURE_LIST[g_RESOURCE_CATTLE]= true;
g_RESOURCES_PASTURE_LIST[g_RESOURCE_SHEEP]= true;

g_RESOURCES_CAMP_LIST = {}
g_RESOURCES_CAMP_LIST[g_RESOURCE_DEER]= true;
g_RESOURCES_CAMP_LIST[g_RESOURCE_TRUFFLES]= true;
g_RESOURCES_CAMP_LIST[g_RESOURCE_IVORY]= true;
g_RESOURCES_CAMP_LIST[g_RESOURCE_HONEY]= true;
g_RESOURCES_CAMP_LIST[g_RESOURCE_FURS]= true;
g_RESOURCES_CAMP_LIST[g_RESOURCE_PENGUINS]= true;


g_RESOURCES_PLANTATION_LIST = {}
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_BANANAS]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_CITRUS]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_COCOA]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_COTTON]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_COFFEE]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_DYES]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_INCENSE]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_OLIVES]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_SILK]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_SPICES]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_SUGAR]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_TEA]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_TOBACCO]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_WINE]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_POMEGRANATES]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_MAPLE]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_PLUMS]= true;
g_RESOURCES_PLANTATION_LIST[g_RESOURCE_PAPYRUS]= true;

g_RESOURCES_FISHINGBOAT_LIST = {}
g_RESOURCES_FISHINGBOAT_LIST[g_RESOURCE_CRABS]= true;
g_RESOURCES_FISHINGBOAT_LIST[g_RESOURCE_FISH]= true;
g_RESOURCES_FISHINGBOAT_LIST[g_RESOURCE_AMBER]= true;
g_RESOURCES_FISHINGBOAT_LIST[g_RESOURCE_PEARLS]= true;
g_RESOURCES_FISHINGBOAT_LIST[g_RESOURCE_TURTLES]= true;
g_RESOURCES_FISHINGBOAT_LIST[g_RESOURCE_WHALES]= true;

g_RESOURCES_STRATEGICS = {}
g_RESOURCES_STRATEGICS[g_RESOURCE_HORSES]= true;
g_RESOURCES_STRATEGICS[g_RESOURCE_IRON]= true;
g_RESOURCES_STRATEGICS[g_RESOURCE_NITER]= true;
g_RESOURCES_STRATEGICS[g_RESOURCE_COAL]= true;
g_RESOURCES_STRATEGICS[g_RESOURCE_OIL]= true;
g_RESOURCES_STRATEGICS[g_RESOURCE_ALUMINUM]= true;
g_RESOURCES_STRATEGICS[g_RESOURCE_URANIUM]= true;

g_RESOURCES_STRATEGICS_EARLY = {}
g_RESOURCES_STRATEGICS_EARLY[g_RESOURCE_HORSES]= true;
g_RESOURCES_STRATEGICS_EARLY[g_RESOURCE_IRON]= true;

g_RESOURCES_HIGHFOOD = {}
g_RESOURCES_HIGHFOOD[g_RESOURCE_CITRUS] = true;
g_RESOURCES_HIGHFOOD[g_RESOURCE_HONEY] = true;
g_RESOURCES_HIGHFOOD[g_RESOURCE_SUGAR] = true;

g_RESOURCES_HIGHPROD = {}
g_RESOURCES_HIGHPROD[g_RESOURCE_DEER] = true;
g_RESOURCES_HIGHPROD[g_RESOURCE_IVORY] = true;
g_RESOURCES_HIGHPROD[g_RESOURCE_GYPSUM] = true;

g_HILLS = "Hills";
g_PASSABLE_LAND = "PassableLand";

TeamerConfigStandard = "Standard";
TeamerConfigEastVsWest = "EastVsWest";
EastTeam = "East";
WestTeam = "West";


function _Debug(...)
    --print(...);
end

function IsWorldAgeOld()
 return MapConfiguration.GetValue("world_age") == 1
end

---------------------------------------
-- Hex
---------------------------------------
Hex = {}

function Hex.new(pX, pY)
    local instance = {};
    setmetatable(instance, {__index = Hex});
    instance.x = pX;
    instance.y = pY;
    return instance;
end

function Hex:GetX()
    return self.x;
end

function Hex:GetY()
    return self.y;
end

function Hex:PrintXY()
    return "("..tostring(self.x)..", "..tostring(self.y)..")("..tostring(self.Food)..", "..tostring(self.Prod)..")";
end


-- Fill the data for selected hex through firaxis datas
function Hex:FillHexDatas()
    local plot = Map.GetPlot(self:GetX(), self:GetY());
    if plot ~= nil then
        self.Plot = plot;
        self.ResourceType = plot:GetResourceType() or g_RESOURCE_NONE;
        self.HexResource = HexResource.new(self.ResourceType)
        self.FeatureType = plot:GetFeatureType() or g_FEATURE_NONE;
        self.TerrainType = plot:GetTerrainType();
        self.IsNaturalWonder = plot:IsNaturalWonder();
        self.IsFreshWater = plot:IsFreshWater();
        self.IsOnRiver = plot:IsRiver();
        self.IsCoastal = AdjacentToSaltWater(self.x, self.y);
        self.IslandId = plot:GetArea():GetID();
        self.IslandSize = plot:GetArea():GetPlotCount();
        self.IdContinent = plot:GetContinentType();
        self.IsOnSplit = Map.FindSecondContinent(plot, 1);
        self.IsMajorSpawnable = not self:IsWater();
        self.IsMinorSpawnable = true;
        self.IsCivStartingPlot = false;
        self.IsCloseToTundra = false;
        self.IsCloseToDesert = false;
        self.IsTaggedAsMinimum = false; --used later for spawn balancing
        self:UpdateYields();
        return;
    end
end

function Hex:UpdateYields()
    local plot = Map.GetPlot(self.x, self.y);
    self.Food = plot:GetYield(g_YIELD_FOOD);
    self.Prod = plot:GetYield(g_YIELD_PRODUCTION);
    self.Gold = plot:GetYield(g_YIELD_GOLD);
    self.Science = plot:GetYield(g_YIELD_SCIENCE);
    self.Culture = plot:GetYield(g_YIELD_CULTURE);
    self.Faith = plot:GetYield(g_YIELD_FAITH);
    -- Strategics not taken into account for yield when spawning
    if self.ResourceType == g_RESOURCE_HORSES or self.ResourceType == g_RESOURCE_NITER then
        self.Food = self.Food - 1;
        self.Prod = self.Prod - 1;
    elseif self.ResourceType == g_RESOURCE_COAL or self.ResourceType == g_RESOURCE_URANIUM then
        self.Prod = self.Prod - 2;
    elseif self.ResourceType == g_RESOURCE_OIL then
        self.Prod = self.Prod - 3;
    elseif self.ResourceType == g_RESOURCE_IRON or self.ResourceType == g_RESOURCE_ALUMINUM then
        self.Science = self.Science - 1;
    end
    self.ExtraYield = self.Science >= 1 or self.Culture >= 1 or self.Faith >= 1 or self.Gold >= 3;
    self.Is22 = self.Food == 2 and self.Prod == 2
    self.Is31 = self.Food == 3 and self.Prod == 1
end

function Hex:IsMountain()
    return IsMountain(self.TerrainType);
 end

 function IsMountain(terrainIndex)
    return terrainIndex == g_TERRAIN_TYPE_DESERT_MOUNTAIN
        or terrainIndex == g_TERRAIN_TYPE_DESERT_MOUNTAIN
        or terrainIndex == g_TERRAIN_TYPE_GRASS_MOUNTAIN
        or terrainIndex == g_TERRAIN_TYPE_PLAINS_MOUNTAIN
        or terrainIndex == g_TERRAIN_TYPE_SNOW_MOUNTAIN
        or terrainIndex == g_TERRAIN_TYPE_TUNDRA_MOUNTAIN;
 end


function Hex:SetCentroid(c)
    self.Centroid = c
end

function Hex:IsWater()
    return self.TerrainType == g_TERRAIN_TYPE_OCEAN
        or self.TerrainType == g_TERRAIN_TYPE_COAST;
end

function Hex:IsCoast()
    return self:IsWater() and self.Plot:IsLake() == false;
end

function Hex:GetAdjacentLandTiles()
    local adjHex = {}
    for _, h in pairs(self.AllRing6Map[1]) do
        if h:IsWater() == false then
            table.insert(adjHex, h);
        end
    end
    return adjHex;
end

function Hex:IsFlat()
    return IsFlat(self.TerrainType);
end

function IsFlat(terrainIndex)
    return terrainIndex == g_TERRAIN_TYPE_DESERT
            or terrainIndex == g_TERRAIN_TYPE_GRASS
            or terrainIndex == g_TERRAIN_TYPE_SNOW
            or terrainIndex == g_TERRAIN_TYPE_TUNDRA
            or terrainIndex == g_TERRAIN_TYPE_PLAINS;
end

function Hex:IsHill()
    return IsHill(self.TerrainType);
end

function Hex:SetTaggedAsMinimum(bool)
    self.IsTaggedAsMinimum = bool;
    _Debug("SetTaggedAsMinimum : ", bool, self:PrintXY())
end

function IsHill(terrainIndex)
    return terrainIndex == g_TERRAIN_TYPE_DESERT_HILLS
        or terrainIndex == g_TERRAIN_TYPE_GRASS_HILLS
        or terrainIndex == g_TERRAIN_TYPE_SNOW_HILLS
        or terrainIndex == g_TERRAIN_TYPE_TUNDRA_HILLS
        or terrainIndex == g_TERRAIN_TYPE_PLAINS_HILLS;
end


-- List of method to get type of terrain (mountains excluded)
function Hex:IsPlainLand()
    return IsPlainLand(self.TerrainType);
end

function IsPlainLand(terrainIndex)
    return terrainIndex == g_TERRAIN_TYPE_PLAINS_HILLS
        or terrainIndex == g_TERRAIN_TYPE_PLAINS
        or terrainIndex == g_TERRAIN_TYPE_PLAINS_MOUNTAIN;
end

function Hex:IsGrassLand()
    return IsGrassLand(self.TerrainType);
end

function IsGrassLand(terrainIndex)
    return terrainIndex == g_TERRAIN_TYPE_GRASS_HILLS
        or terrainIndex == g_TERRAIN_TYPE_GRASS
        or terrainIndex == g_TERRAIN_TYPE_GRASS_MOUNTAIN
end

function Hex:IsDesertLand()
    return IsDesertLand(self.TerrainType);
end

function IsDesertLand(terrainIndex)
    return terrainIndex == g_TERRAIN_TYPE_DESERT_HILLS
        or terrainIndex == g_TERRAIN_TYPE_DESERT
        or terrainIndex == g_TERRAIN_TYPE_DESERT_MOUNTAIN
end

function Hex:IsTundraLand()
    return IsTundraLand(self.TerrainType);
end

function IsTundraLand(terrainIndex)
    return terrainIndex == g_TERRAIN_TYPE_TUNDRA_HILLS
        or terrainIndex == g_TERRAIN_TYPE_TUNDRA
        or terrainIndex == g_TERRAIN_TYPE_TUNDRA_MOUNTAIN
end

function Hex:IsSnowLand()
    return IsSnowLand(self.TerrainType);
end

function IsSnowLand(terrainIndex)
    return terrainIndex == g_TERRAIN_TYPE_SNOW_HILLS
        or terrainIndex == g_TERRAIN_TYPE_SNOW
        or terrainIndex == g_TERRAIN_TYPE_SNOW_MOUNTAIN
end

function Hex:IsFloodplains(includeDesert)
    return IsFloodplains(self.FeatureType, includeDesert);
end

function IsFloodplains(featureIndex, includingDesert)
    if includingDesert then
        return featureIndex == g_FEATURE_FLOODPLAINS
                or featureIndex == g_FEATURE_FLOODPLAINS_GRASSLAND
                or featureIndex == g_FEATURE_FLOODPLAINS_PLAINS;
    end
    return featureIndex == g_FEATURE_FLOODPLAINS_GRASSLAND
        or featureIndex == g_FEATURE_FLOODPLAINS_PLAINS;
end

function Hex:IsImpassable()
    return self:IsWater() or self:IsMountain();
end

function Hex:HasLux()
    if self.ResourceType == nil or self.ResourceType == g_RESOURCE_NONE then
        return false
    end
    return g_RESOURCES_LUX_LIST[self.ResourceType];
end

function Hex:IsCloseToCoast()
    for i, ring in pairs(self.AllRing6Map) do
        if i < 4 then
            for _, h in pairs(ring) do
                if h.IsCoastal then
                    return true;
                end
            end

        end
    end
    return false;
end

function Hex:GetClosestCoastToHex(maxRange)
    if self.IsCoastal then
        return 0;
    end
    for i = 1, maxRange do
        for _, h in pairs(self.AllRing6Map[i]) do
            if h.IsCoastal then
                return i;
            end
        end
    end
    return nil;
end

function Hex:IsNextToCoastalFreshWater()
    for _, h in pairs(self.AllRing6Map[1]) do
        if h.IsCoastal and h.IsOnRiver then
            return true;
        end
    end
    return false;
end

function Hex:HexAdd(vec)
    if vec.getmetatable == Hex then
        local newX = self:GetX() + vec.x;
        local newY = self:GetY() + vec.y;
        return Hex(newX, newY);
    else
        _Debug("HexAdd - parameter must be an Hex")
    end
end

function Hex:DistanceTo(other)
    if self.x == other.x and self.y == other.y then
        return 0;
    end
    return Map.GetPlotDistance(self.x, self.y, other.x, other.y);
    --[[local q = self.y - self.x - even(self.x) / 2
    local r = self.x;
    local otherQ = other.y - (other.x - even(other.x)) / 2;
    local otherR = other.x;
    local result = (math.abs(q - otherQ) + math.abs(q - otherQ + r - otherR) + math.abs(r - otherR)) / 2;
    return result;]]
end


-- return the closest point to this hex among the list of points in param
function Hex:Closest(hexMap, points)
	local min = 999;
	local min_i
    local point
    local dist
    local shiftedPoint
    local shiftedDist
    for k = 1, #points do
        point = points[k]
        dist = self:DistanceTo(point)
        if dist ~= 0 then
            if hexMap.canCircumnavigate then
                shiftedPoint = Hex.new(point.x + hexMap.width, point.y)
                shiftedDist = self:DistanceTo(shiftedPoint)
                if shiftedDist < dist then
                    dist = shiftedDist
                end
            end
            if dist < min then
                min = dist
                min_i = k
            end
        end
    end
	return points[min_i]
end

function Hex:DistanceToClosest(hexMap, points)
    local closest = self:Closest(hexMap, points)
    if closest == nil then
        return nil;
    end
    return self:DistanceTo(closest);
end

---------------------------------------
-- HexResource
-- Contains resources data as categories - fill as needed
---------------------------------------
HexResource = {}
function HexResource.new(resIndex)
    local instance = {}
    setmetatable(instance, {__index = HexResource});
    instance.ResourceIndex = resIndex;
    instance.IsPlantationResource = g_RESOURCES_PLANTATION_LIST[resIndex] ~= nil;
    instance.IsFarmResource = g_RESOURCES_FARM_LIST[resIndex] ~= nil;
    instance.IsPastureResource= g_RESOURCES_PASTURE_LIST[resIndex] ~= nil;
    instance.IsMineResource = g_RESOURCES_MINE_LIST[resIndex] ~= nil;
    instance.IsFishingResource=  g_RESOURCES_FISHINGBOAT_LIST[resIndex] ~= nil;
    instance.IsStrategic = g_RESOURCES_STRATEGICS[resIndex] ~= nil;
    instance.IsBonus = g_RESOURCES_BONUS_LIST[resIndex] ~= nil;
    instance.IsLux = g_RESOURCES_LUX_LIST[resIndex] ~= nil;
    return instance;
end

---------------------------------------
-- Centroid
---------------------------------------
Centroid = {}

function Centroid:new(pX, pY, pId)
    local instance = {}
    setmetatable(instance, self);
    self.__index = self
    instance.x = pX;
    instance.y = pY;
    instance.id = pId;
    -- List of hexes closest to this centroid
    instance.HexCluster = {};
    -- Put cluster datas here (number of ressources, hills etc ?)
    instance.ResourcesScore = {};
    instance.FeaturesScore = {};
    instance.TerrainsScore = {};
    instance.FreshWaterScore = 0;
    instance.IsRiverScore = 0;
    instance.IsTundraCentroid = false;
    instance.IsCoastalCentroid = false;
    instance.HasCoast = false;
    instance.TundraScore = 0
    instance.PlacedCiv = false
    return instance;
end

function Centroid:GetHillsInCluster()
    local count = 0;
    local mappedHex = {};
    if self.HexCluster ~= nil and #self.HexCluster > 0 then
        for _, hex in pairs(self.HexCluster) do
            if hex:IsHill() then
                count = count + 1;
                table.insert(mappedHex, hex);
            end
        end
    end
    return count;
end


function Centroid:GetTotalResourcesCountInCluster()
    local countLux = 0;
    local countBonus = 0;
    local countStrategics = 0;
    for _, hex in pairs(self.HexCluster) do
        if hex.HexResource.IsLux then
            countLux = countLux + 1;
        elseif hex.HexResource.IsBonus then
            countBonus = countBonus + 1;
        elseif hex.HexResource.IsStrategic then
            countStrategics = countStrategics + 1;
        end
    end
    return countLux, countBonus, countStrategics;
end

function Centroid:GetLuxResourcesInCluster()
    local count = 0;
    local mappedHex = {};
    if self.HexCluster ~= nil and #self.HexCluster > 0 then
        for _, hex in pairs(self.HexCluster) do
            if hex:HasLux() then
                count = count + 1;
                table.insert(mappedHex, hex);
            end
        end
    end
    return count, mappedHex;
end

function Centroid:GetRessourceIdCountInCluster(ressourceId)
    local count = 0;
    local mappedHex = {};
    if self.HexCluster ~= nil and #self.HexCluster > 0 then
        for _, hex in pairs(self.HexCluster) do
            if hex.ResourceType == ressourceId then
                count = count + 1;
                table.insert(mappedHex, hex);
            end
        end
    end
    return count, mappedHex;
end

function Centroid:GetTerrainTypeCountInCluster(terrainId)
    local count = 0;
    local mappedHex = {};
    if self.HexCluster ~= nil and #self.HexCluster > 0 then
        for _, hex in pairs(self.HexCluster) do
            if hex.TerrainType == terrainId then
                count = count + 1;
                table.insert(mappedHex, hex);
            end
        end
    end
    return count, mappedHex;
end

function Centroid:ComputeCentroidScore()
    if self.HexCluster ~= nil and #self.HexCluster > 0 then
        local numberCoastalHex = 0
        for _, hex in pairs(self.HexCluster) do
            local ressource = hex.ResourceType
            if ressource ~= g_RESOURCE_NONE then
                local hexScore = hex.ResourcesScore[ressource]
                local centScore = self.ResourcesScore[ressource] or 0 --init
                centScore = centScore + hexScore
                self.ResourcesScore[ressource] = centScore
            end
            local feature = hex.FeatureType
            if feature ~= g_FEATURE_NONE then
                local hexScore = hex.FeaturesScore[feature]
                local centScore = self.FeaturesScore[feature] or 0 --init
                centScore = centScore + hexScore
                self.FeaturesScore[feature] = centScore
            end
            local terrain = hex.TerrainType
            if terrain ~= g_TERRAIN_TYPE_NONE then
                local hexScore = hex.TerrainsScore[terrain]
                local centScore = self.TerrainsScore[terrain] or 0 --init
                centScore = centScore + hexScore
                self.TerrainsScore[terrain] = centScore
            end
            if hex.IsFreshWater then
                self.FreshWaterScore = self.FreshWaterScore + 1
            end
            if hex.IsOnRiver then
                self.IsRiverScore = self.IsRiverScore + 1
            end
            if hex.IsTundraLand then
                self.TundraScore = self.TundraScore + hex.TundraScore
            end
            if hex.IsCoastal and hex:IsTundraLand() == false and hex:IsSnowLand() == false then
                self.HasCoast = true
                numberCoastalHex = numberCoastalHex + 1;
                if numberCoastalHex > 7 then
                    self.IsCoastalCentroid = true;
                end
            end

        end
        -- Mean score
        for id, _ in pairs(self.ResourcesScore) do
            local scoreRes = self.ResourcesScore[id]
            self.ResourcesScore[id] = scoreRes / #self.HexCluster
        end
        for id, _ in pairs(self.FeaturesScore) do
            local scoreFeat = self.FeaturesScore[id]
            self.FeaturesScore[id] = scoreFeat / #self.HexCluster
        end
        for id, _ in pairs(self.TerrainsScore) do
            local scoreTerr = self.TerrainsScore[id]
            self.TerrainsScore[id] = scoreTerr / #self.HexCluster
        end
        self.FreshWaterScore = self.FreshWaterScore / #self.HexCluster
        self.IsRiverScore = self.IsRiverScore / #self.HexCluster
        self.TundraScore = self.TundraScore / #self.HexCluster
    end
end

---------------------------------------
-- HexMap
---------------------------------------

HexMap = {}

function HexMap.new(_width, _height, mapScript)
    local instance = {};
    setmetatable(instance, {__index = HexMap});
    instance.width = _width;
    instance.height = _height;
    instance.mapScript = mapScript;
    instance.canCircumnavigate = instance:CanCircumnavigate();
    instance.minimumDistanceMajorToMajorCivs = instance:SetMinimumDistanceMajorToMajorCivs();
    print("BBMDistance = ", instance.minimumDistanceMajorToMajorCivs)
    instance.minimumDistanceMinorToMajorCivs = GlobalParameters.START_DISTANCE_MINOR_MAJOR_CIVILIZATION or 8;
    instance.minimumDistanceMinorToMinorCivs = GlobalParameters.START_DISTANCE_MINOR_CIVILIZATION_START or 7;
    instance.map = {};
    instance.mapFreshWater = {};
    instance.mapCostal = {};
    instance.mapResources = {};
    instance.mapFeatures = {};
    instance.mapTerrains = {};
    instance.mapDesert = {};
    instance.mapTundra = {};
    instance.mapWater = {};
    instance.mapOcean = {};
    instance.mapContinents = {};
    instance.mapOnSplit = {}
    instance.mapWonders = {};
    instance.map22 = {}
    instance.centroidsArray = {};
    instance.LuxTable = {};
    instance.PeninsulaScoreThreshold = 35;
    instance:FillHexMapDatas();
    instance:StoreHexRings();
    instance:GlobalMountainsTerraform();
    instance:CalculateWalkableHexInRange();
    instance:CleanGlobalHighYieldsOnFresh();
    instance:ComputeScoreHex();
    instance.ValidSpawnHexes = {};
    instance.tempMajorSpawns = {};
    instance.majorSpawns = {};
    instance.minorSpawns = {};
    instance.BiggestIsland = Areas.FindBiggestArea(false);
    instance.TeamerConfig = instance:GetTeamerPositionConfig();
    instance.MiddleX = _width / 2;
    -- Starting from middle of the map, East vs West setup allows that much space for war civ spawn, rest is for simmers
    instance.RTSPangaeaTeamerEvWBuffer = math.floor(_width * 0.05 + 0.5); --% from middle of map +-4
    instance.RTSPangaeaTeamerConfigWarMax = math.floor(_width * 0.13 + 0.5); -- on 4v4 = +-11 from middle
    instance.RTSPangaeaTeamerConfigWarMaxTundra = math.floor(_width * 0.18 + 0.5); -- on 4v4 = +-15 from middle
    instance.RTSPangaeaTeamerConfigSimMin = math.floor(_width * 0.2 + 0.5); -- on 4v4 = +-17 from middle
    -- Put maps parameters here ? (world age, temperature, rainfall etc)
    -- BBM Mountains change = recalculate areas
    AreaBuilder.Recalculate();
    TerrainBuilder.AnalyzeChokepoints();
    return instance;
end

function HexMap:CanCircumnavigate()
    return self.mapScript ~= MapScripts.MAP_INLAND_SEA and self.mapScript ~= MapScripts.MAP_TILTED_AXIS;
end

function HexMap:SetMinimumDistanceMajorToMajorCivs()
    local minDistanceConfig = MapConfiguration.GetValue("BBMMinDistance");
    if minDistanceConfig == 0 then
        if self.mapScript == MapScripts.MAP_HIGHLANDS 
        or self.mapScript == MapScripts.MAP_LAKES 
        or self.mapScript == MapScripts.MAP_RICH_HIGHLANDS then
            return 15;
        elseif self.mapScript == MapScripts.MAP_INLAND_SEA 
        or self.mapScript == MapScripts.MAP_PANGAEA_ULTIMA then
            return 14;
        elseif self.mapScript == MapScripts.MAP_SEVEN_SEAS
         then
            return 13;
        elseif self.mapScript == MapScripts.MAP_PANGAEA 
            or self.mapScript == MapScripts.MAP_SHUFFLE 
            or self.mapScript == MapScripts.MAP_TILTED_AXIS 
            or self.mapScript == MapScripts.MAP_TILTED_AXIS_WRAP 
            or self.mapScript == MapScripts.MAP_PRIMORDIAL then
            return 12;
        elseif self.mapScript == MapScripts.MAP_TERRA then
            return 8;
        else
            return 10;
        end
    else
        return minDistanceConfig;
    end
end

-- Put datas of every hex in map
function HexMap:FillHexMapDatas()
    _Debug("Start FillHexMapDatas",  os.date("%c"))
    local luxTable = {}
    for y = 0, self.height - 1 do
        self.map[y] = {};
        for x = 0, self.width - 1 do
            local newHex = Hex.new(x,y);
            newHex:FillHexDatas();
            self.map[y][x] = newHex;
            if newHex.IsFreshWater then
                table.insert(self.mapFreshWater, newHex);
            end
            if newHex.IsCoastal then
                table.insert(self.mapCostal, newHex);
            end
            --self:InsertMapResources(newHex);
            self:InsertMapFeatures(newHex);
            self:InsertMapTerrains(newHex);
            if newHex.IdContinent ~= nil then
                self.mapContinents[newHex.IdContinent] = self.mapContinents[newHex.IdContinent] or {}
                table.insert(self.mapContinents[newHex.IdContinent], newHex);
            end
            if newHex.IsOnSplit == true then
                table.insert(self.mapOnSplit, newHex);
            end
            if newHex.IsNaturalWonder == true then
                table.insert(self.mapWonders, newHex);
            end
            if newHex:IsWater() == true then
                table.insert(self.mapWater, newHex);
            end
            if newHex.TerrainType == g_TERRAIN_TYPE_OCEAN then
                table.insert(self.mapOcean, newHex);
            end
            if newHex:IsTundraLand() == true then
                table.insert(self.mapTundra, newHex);
            end
            if newHex:IsDesertLand() == true then
                table.insert(self.mapDesert, newHex);
            end
            -- Lux analysis
            --_Debug(newHex:PrintXY().." - IdContinent = "..tostring(newHex.IdContinent))
            if g_RESOURCES_LUX_LIST[newHex.ResourceType] then
                luxTable[newHex.IdContinent] = luxTable[newHex.IdContinent] or {}
                if Contains(luxTable[newHex.IdContinent], newHex.ResourceType) == false
                        and (newHex.IdContinent ~= -1 and newHex:IsWater()) == false then
                    -- Lakes are attached to a continent so lux in lakes (amber) should not be attached to the continent
                    table.insert(luxTable[newHex.IdContinent], newHex.ResourceType)
                end
            end
        end
    end
    self.LuxTable = luxTable;
    _Debug("End FillHexMapDatas",  os.date("%c"))

end

-- Pre store rings data for each hex for later uses and improve performances
function HexMap:StoreHexRings()
    _Debug("Start StoreHexRings",  os.date("%c"))
    for y = 0, self.height - 1 do
        for x = 0, self.width - 1 do
            local hex = self:GetHexInMap(x, y);
            hex.AllRing6, hex.AllRing6Map = self:GetAllHexInRing(hex, 6);
            -- Fill as needed
        end
    end
    _Debug("End StoreHexRings",  os.date("%c"))
end

function HexMap:CalculateWalkableHexInRange()
    _Debug("Start SetAllWalkableHexInRange",  os.date("%c"))
    for y = 0, self.height - 1 do
        for x = 0, self.width - 1 do
            local hex = self:GetHexInMap(x, y);
            hex:SetAllWalkableHexInRange(6);
        end
    end
    _Debug("End SetAllWalkableHexInRange",  os.date("%c"))
end

function HexMap:CanHaveJungle(hex)
    -- Rainforest on Earth mostly in Tropics, so keep in narrow band around Equator
    local equator = math.ceil(self.height / 2);
    local jungleBottom = equator - (20 * self.height / 180);
    local jungleTop = equator + (20 * self.height / 180);
    if (self.mapScript == MAP_TILTED_AXIS) then
        local centerX = math.ceil(self.height / 2);
        local centerY = math.ceil(self.width / 2);
        local distanceToCenter = Map.GetPlotDistance(hex:GetX(), hex:GetY(), centerX, centerY);
        jungleBottom = equator - (20 * self.height / 180);
        jungleTop = equator + (20 * self.height / 180);
        if(distanceToCenter >= jungleBottom and distanceToCenter <= jungleTop) then
            return true;
        else
            return false;
        end
    end
    if(hex:GetY() >= jungleBottom  and hex:GetY() <= jungleTop) then
        return true;
    end
    return false;
end
-- For each tile, store the score density for each ressource/feature/terrain - use for civ biases
-- TODO : how to calculate a score
function HexMap:ComputeScoreHex()
    _Debug("Start ComputeScoreHex",  os.date("%c"))
    for y = 0, self.height - 1 do
        for x = 0, self.width - 1 do
            local hex = self:GetHexInMap(x, y);
            self:ComputeCostalScore(hex);
            self:ComputePeninsulaScore(hex);
            self:ComputeResourcesScore(hex);
            self:ComputeFeaturesScore(hex);
            self:ComputeTerrainsScore(hex);
            self:ComputeWaterScore(hex);
            self:ComputeRiverScore(hex);
            self:ComputeMajorSpawnableTiles(hex);
            self:ComputeMinorSpawnableTiles(hex);
        end
    end
    _Debug("End ComputeScoreHex",  os.date("%c"))
end

function HexMap:ResetSpawnableHex()
    for y = 0, self.height - 1 do
        for x = 0, self.width - 1 do
            local hex = self:GetHexInMap(x, y);
            self:ComputeMajorSpawnableTiles(hex);
            self:ComputeMinorSpawnableTiles(hex);
            hex.IsCivStartingPlot = false;
        end
    end
end

function HexMap:ComputeCostalScore(hex)
    local score = {}
    local ring_distance = 3
    local min_land_tiles = 0
    local start_ring = 1
    for i = start_ring, ring_distance do
        min_land_tiles = min_land_tiles + 6 * i * (ring_distance + 1 - i)
        score[i] = ring_distance + 1 - i
    end
    min_land_tiles = min_land_tiles * 0.4 -- 40% of land tiles
    hex.CostalScore = 0
    if hex:IsWater() == false and (hex.IslandSize > 31 or hex:IsMountain()) then
        for i = start_ring, ring_distance, 1 do
            local t = self:GetHexInRing(hex, i);
            for _, h in pairs(t) do
                if h:IsWater() == false and (h.IslandSize > 31 or h:IsMountain()) then
                    hex.CostalScore = hex.CostalScore + score[i]
                end
            end
        end
        if (hex.CostalScore / min_land_tiles) >= 1 then
            hex.CostalScore = 1
        else
            hex.CostalScore = 0
        end
    end
end
-- Calculate number of reachable tiles in ring 6 to avoid peninsula spawns
function HexMap:ComputePeninsulaScore(hex)
    hex.PeninsulaScore = 0
    if hex:IsImpassable() == false and hex:IsHexNextTo4ImpassableTiles() == false and hex:IsSnowLand() == false then
        local visitedRing = {}
        local visitedHex = {}
        local totalVisited = 0
        visitedRing[0] = {}
        table.insert(visitedRing[0], hex)
        for n = 1, 6 do
            visitedRing[n] = {}
            local n1 = n - 1
            for i, h in pairs(visitedRing[n1]) do
                for _, neighbor in pairs(h.AllRing6Map[1]) do
                    if neighbor:IsImpassable() == false and visitedHex[neighbor] == nil then
                        visitedHex[neighbor] = true;
                        table.insert(visitedRing[n], neighbor)
                        totalVisited = totalVisited + 1
                    end
                end
            end
        end
        hex.PeninsulaScore = math.floor((totalVisited / #hex.AllRing6) * 100 )
    end
end

--TODO - refacto
function HexMap:ComputeResourcesScore(hex)
    hex.ResourcesScore = {}
    local mapRing6 = hex.AllRing6Map
    for i = 1, #mapRing6 do
        local ring = mapRing6[i]
        for j = 1, #ring do
            local h = ring[j]
            if h:IsImpassable() == false and h.ResourceType ~= g_RESOURCE_NONE then
                local score = hex.ResourcesScore[h.ResourceType] or 0 --init
                score = score + 1 * ScoreDistanceFactor(i)
                hex.ResourcesScore[h.ResourceType] = score
            end
        end

    end

    --[[for i, ring in pairs(hex.AllRing6Map) do
        for _, h in pairs(ring) do
            if h:IsImpassable() == false and h.ResourceType ~= g_RESOURCE_NONE then
                local score = hex.ResourcesScore[h.ResourceType] or 0 --init
                score = score + 1 * ScoreDistanceFactor(i)
                hex.ResourcesScore[h.ResourceType] = score
            end
        end
    end]]
    -- Include the tile itself
    if hex.ResourceType ~= g_RESOURCE_NONE then
        local hexScore = hex.ResourcesScore[hex.ResourceType] or 0
        hexScore = hexScore + 1
        hex.ResourcesScore[hex.ResourceType] = hexScore
    end

    --for ress, _ in pairs(hex.ResourcesScore) do
    --    hex.ResourcesScore[ress] = hex.ResourcesScore[ress] / #hex.AllRing6  * 100;
    --end

end

function HexMap:ComputeFeaturesScore(hex)
    hex.FeaturesScore = {}
    local mapRing6 = hex.AllRing6Map
    for i = 1, #mapRing6 do
        local ring = mapRing6[i]
        for j = 1, #ring do
            local h = ring[j]
            if h.FeatureType ~= g_FEATURE_NONE then
                local score = hex.FeaturesScore[h.FeatureType] or 0 --init
                score = score + 1
                hex.FeaturesScore[h.FeatureType] = score
            end
        end
    end
    if hex.FeatureType ~= g_FEATURE_NONE then
        local hexScore = hex.FeaturesScore[hex.FeatureType] or 0
        hexScore = hexScore + 1
        hex.FeaturesScore[hex.FeatureType] = hexScore
    end
end

function HexMap:ComputeTerrainsScore(hex)
    hex.TerrainsScore = {}
    local mapRing6 = hex.AllRing6Map
    for i = 1, #mapRing6 do
        local ring = mapRing6[i]
        hex.TerrainsScore[g_HILLS] = 0 --init
        for j = 1, #ring do
            local h = ring[j]
            if h.TerrainType ~= g_TERRAIN_TYPE_NONE then
                local score = hex.TerrainsScore[h.TerrainType] or 0 --init
                score = score + 1
                hex.TerrainsScore[h.TerrainType] = score
            end
            -- Compute coastal tiles score
            local isCoastal = h.IsCoastal
            if isCoastal == true then
                local score = hex.TerrainsScore[g_TERRAIN_TYPE_COAST] or 0 --init
                score = score + 1
                hex.TerrainsScore[g_TERRAIN_TYPE_COAST] = score
            end
            if h:IsTundraLand() and i < 3 then
                hex.IsCloseToTundra = true
            elseif h:IsDesertLand() and i < 4 then
                hex.IsCloseToDesert = true
            end
            local isCoastal = h.IsCoastal
            -- Hills score
            if IsHill(h.TerrainType) then
                local hillScore = hex.TerrainsScore[g_HILLS] or 0;
                hillScore = hillScore + 1;
                hex.TerrainsScore[g_HILLS] = hillScore
            end
            if h:IsImpassable() == false then
                local totalLand = hex.TerrainsScore[g_PASSABLE_LAND] or 0; --init
                totalLand = totalLand + 1;
                hex.TerrainsScore[g_PASSABLE_LAND] = totalLand;
            end
        end

    end
    -- Include the tile itself
    if hex.TerrainType ~= g_TERRAIN_TYPE_NONE then
        local hexScore = hex.TerrainsScore[hex.TerrainType] or 0
        hexScore = hexScore + 1
        hex.TerrainsScore[hex.TerrainType] = hexScore
    end

   -- for terr, _ in pairs(hex.TerrainsScore) do
    --    hex.TerrainsScore[terr] = hex.TerrainsScore[terr] / #hex.AllRing6 * 100;
    --end

    -- see if how to calculate for more precision in score (by ring distance etc)
    local flatTundraScore =  hex.TerrainsScore[g_TERRAIN_TYPE_TUNDRA] or 0;
    local hillsTundraScore = hex.TerrainsScore[g_TERRAIN_TYPE_TUNDRA_HILLS] or 0;
    local mountainTundraScore=  hex.TerrainsScore[g_TERRAIN_TYPE_TUNDRA_MOUNTAIN] or 0;
    hex.TundraScore = flatTundraScore + hillsTundraScore + mountainTundraScore;

    local flatDesertScore =  hex.TerrainsScore[g_TERRAIN_TYPE_DESERT] or 0;
    local hillsDesertScore = hex.TerrainsScore[g_TERRAIN_TYPE_DESERT_HILLS] or 0;
    local mountainDesertScore=  hex.TerrainsScore[g_TERRAIN_TYPE_DESERT_MOUNTAIN] or 0;
    hex.DesertScore = flatDesertScore + hillsDesertScore + mountainDesertScore;
end

function HexMap:ComputeWaterScore(hex)
    hex.WaterScore = 0
    for _, h in ipairs(hex.AllRing6) do
        if h:IsImpassable() == false and h.IsFreshWater then
            local score = hex.WaterScore or 0 --init
            score = score + 1
            hex.WaterScore = score
        end
    end
    -- Include the tile itself
    if hex.IsFreshWater == false then
        local hexScore = hex.WaterScore or 0
        hexScore = hexScore + 1
        hex.WaterScore = hexScore
    end

    hex.WaterScore = hex.WaterScore / #hex.AllRing6  * 100;

end

function HexMap:ComputeRiverScore(hex)
    hex.RiverScore = 0
    for _, h in ipairs(hex.AllRing6) do
        if h:IsImpassable() == false and h.IsOnRiver then
            local score = hex.RiverScore or 0 --init
            score = score + 1
            hex.RiverScore = score
        end
    end
    -- Include the tile itself
    if hex.IsOnRiver == false then
        local hexScore = hex.RiverScore or 0
        hexScore = hexScore + 1
        hex.RiverScore = hexScore
    end

    hex.RiverScore = hex.RiverScore / #hex.AllRing6  * 100;
end

-- Initial analysis of the tile to avoid technical spawns
function HexMap:ComputeMajorSpawnableTiles(hex)
    local isCloseToMapBorderX = self.canCircumnavigate == false and (self.width - hex.x <= 3 or hex.x <= 3);
    local isCloseToMapBorderY = self.height - hex.y <= 3 or hex.y <= 3;
    local isTooCloseToNaturalWonder = hex:IsCloseToNaturalWonder()
    local isCloseToTooManyFlood = hex:IsHexTooCloseToFloodTiles();
    local isNextToVolcano = hex:IsNextToVolcano();
    local coastalNextToRiver = hex.IsCoastal and hex.IsFreshWater == false and hex:IsNextToCoastalFreshWater();
    local nextTo3LakesInARow = hex:IsHexRing1NextToImpassableInARow(3);
    local isNotInPeninsula = hex.PeninsulaScore >= self.PeninsulaScoreThreshold
    local isTooCloseToSnow = hex:IsHexCloseToSnow()
    local hasEnoughWorkableRing2 = hex:HasEnoughWorkableRing2();
    local hasEmptyWaterCoastRing2 = hex:HasEmptyWaterCoastRing2() ;
    hex.IsMajorSpawnable = hex:IsImpassable() == false
        and hex:IsSnowLand() == false
        and hex.FeatureType ~= g_FEATURE_OASIS
        and isCloseToMapBorderX == false
        and isCloseToMapBorderY == false
        and isNotInPeninsula == true
        and isCloseToTooManyFlood == false
        and isNextToVolcano == false
        and nextTo3LakesInARow == false
        and isTooCloseToNaturalWonder == false
        and coastalNextToRiver == false
        and hasEnoughWorkableRing2 == true
        and isTooCloseToSnow == false
        and hasEmptyWaterCoastRing2 == true;
end

function HexMap:ComputeMinorSpawnableTiles(hex)
    hex.IsMinorSpawnable = hex:IsImpassable() == false and hex:IsCloseToNaturalWonder() == false and hex:IsSurroundedByImpassable() == false
        and hex:IsSnowLand() == false;
end

-- TODO : Testing score calculations depending on distance
function ScoreDistanceFactor(dist)
   if dist < 4 then
        return 1.5;
    else
        return 1;
    end
end

function Hex:IsCloseToNaturalWonder()
    for i, r in ipairs(self.AllRing6Map) do
        for _, h in ipairs(r) do
            -- Limit to 5 tiles like BBS
            if self.IsNaturalWonder or (h.IsNaturalWonder and i < 5) then
                return true;
            end
        end
    end
    return false;
end

function Hex:IsHexNextTo4ImpassableTiles()
    local ring1 = self.AllRing6Map[1];
    local impassableRing1 = 0
    for _, r1 in pairs(ring1) do
        if r1:IsImpassable() then
            impassableRing1 = impassableRing1 + 1
        end
        if impassableRing1 > 3 then
            return true;
        end
    end
    return false;
end

function Hex:IsSurroundedByImpassable()
    local ring1 = self.AllRing6Map[1];
    for _, r1 in pairs(ring1) do
        if r1:IsImpassable() == false then
            return false;
        end
    end
    return true;
end

function Hex:HasSpawnEnoughWalkableTiles()
    -- Half of ring 3 shoukld be accessible
    local walkable = #self.WalkableHexInRing[3]
    local limit = #self.AllRing6Map[3] / 2 - 1
    return walkable >= limit, walkable
end

function Hex:LogWalkableTiles(testRing)
    local walkableInRing = self.WalkableHexInRing[testRing]
    _Debug("HasEnoughWalkableTiles in ring ", testRing, " = ", walkableInRing)
    return walkableInRing;
end

function Hex:IsHexRing1NextToImpassableInARow(threshold)
    if self:IsWater() then
        return false
    end
    local ring1 = self.AllRing6Map[1];
    local lakesOrMountains = 0
    local firstHexRing = ring1[1];
    local lastHexRing = ring1[6];
    -- Not used in true coastal
    for i, r1 in ipairs(ring1) do
        if r1.Plot:IsLake() or r1:IsMountain() then
            lakesOrMountains = lakesOrMountains + 1;
            -- Starting from west tile from Hex, so we need to add the last tile analysed in ring to check (same for last tile, need to add first one)
            if (i == 1 and lastHexRing ~= nil and (lastHexRing.Plot:IsLake() or lastHexRing:IsMountain())) 
                or (i == 6 and firstHexRing ~= nil and (firstHexRing.Plot:IsLake() or firstHexRing:IsMountain())) then
                lakesOrMountains = lakesOrMountains + 1;
            end
        else
            lakesOrMountains = 0;
        end
        if lakesOrMountains >= threshold then
            return true;
        end
    end
    return false;
end

-- Add a check to have at least have half of ring 2 tiles workable
-- So mountains or coastal+lakes spawn have enough space to terraform tiles and expands
function Hex:HasEnoughWorkableRing2()
    local ring2 = self.AllRing6Map[2];
    local impassableTiles = 0
    for _, h in ipairs(ring2) do
        if h:IsImpassable() then
            impassableTiles = impassableTiles + 1;
        end
        if impassableTiles > 6 then
            return false;
        end
    end
    return true;
end

function Hex:HasEmptyWaterCoastRing2()
    if self.IsCoastal == false then
        return true;
    end
    local ring2 = self.AllRing6Map[2];
    for _, h in ipairs(ring2) do
        if h:IsWater() and h.Plot:IsLake() == false and h.ResourceType == g_RESOURCE_NONE and h.FeatureType == g_FEATURE_NONE then
            return true;
        end
    end
    return false;
end

function Hex:HasMoreThan2WaterCoastRing2()
    if self.IsCoastal == false then
        return true;
    end
    local ring2 = self.AllRing6Map[2];
    local waterRing2 = 0;
    for _, h in ipairs(ring2) do
        if h:IsWater() and h.Plot:IsLake() == false then
            waterRing2 = waterRing2 + 1;
            if waterRing2 > 1 then
                return true;
            end
        end
    end
    return false;
end

function Hex:IsHexCloseToSnow()
    local ring1 = self.AllRing6Map[1];
    local snowCount = 0
    for _, r1 in pairs(ring1) do
        if r1:IsSnowLand() then
            snowCount = snowCount + 1
        end
        if snowCount > 1 then
            return true;
        end
    end
    local ring2 = self.AllRing6Map[2];
    for _, r2 in pairs(ring2) do
        if r2:IsSnowLand() then
            snowCount = snowCount + 1
        end
        if snowCount >= 3 then
            return true;
        end
    end
    return false;
end

function Hex:IsNextToVolcano()
    local ring1 = self.AllRing6Map[1];
    for _, r1 in ipairs(ring1) do
        if r1.FeatureType == g_FEATURE_VOLCANO then
            return true;
        end
    end
    return false;
end

function Hex:IsNextToLake()
    local ring1 = self.AllRing6Map[1];
    for _, r1 in ipairs(ring1) do
        if r1.Plot:IsLake() then
            return true;
        end
    end
    return false;
end


-- Avoid spawns on too many floodplains ring 1 and coastal on spawning
function Hex:IsHexTooCloseToFloodTiles()
    local ring1 = self.AllRing6Map[1];
    local floodplainsR1 = 0
    for _, r1 in pairs(ring1) do
        if r1:IsFloodplains(true) or r1:IsWater() then
            floodplainsR1 = floodplainsR1 + 1
        end
        if floodplainsR1 > 3 then
            return true;
        end
    end
    local ring2 = self.AllRing6Map[2];
    local floodplainsR2 = 0
    for _, r2 in pairs(ring2) do
        if r2:IsFloodplains(true) or r2:IsWater() then
            floodplainsR2 = floodplainsR2 + 1
        end
        if floodplainsR2 > 5 then
            return true;
        end
    end
    
    return false;
end

function Hex:IsNextToOasis()
    local ring1 = self.AllRing6Map[1];
    for _, r1 in pairs(ring1) do
        if r1.FeatureType == g_FEATURE_OASIS then
            return true;
        end
    end
    return false;
end

function HexMap:InsertMapResources(hex)
    if hex ~= nil and hex.ResourceType ~= g_RESOURCE_NONE then
        self.mapResources[hex.ResourceType] = self.mapResources[hex.ResourceType] or {}
        table.insert(self.mapResources[hex.ResourceType], hex);
        if g_RESOURCES_LUX_LIST[hex.ResourceType] ~= nil then
            table.insert(self.mapResourcesLux, hex);
        elseif g_RESOURCES_BONUS_LIST[hex.ResourceType] ~= nil then
            table.insert(self.mapResourcesBonus, hex);
        elseif g_RESOURCES_STRATEGICS[hex.ResourceType] ~= nil then
            table.insert(self.mapResourcesStrategics, hex);
        elseif g_RESOURCES_MINE_LIST[hex.ResourceType] ~= nil and hex:IsWater() == false then
            table.insert(self.mapResourcesMines, hex);
        elseif g_RESOURCES_FARM_LIST[hex.ResourceType] ~= nil then
            table.insert(self.mapResourcesFarms, hex);
        elseif g_RESOURCES_PASTURE_LIST[hex.ResourceType] ~= nil then
            table.insert(self.mapResourcesPastures, hex);
        elseif g_RESOURCES_QUARRY_LIST[hex.ResourceType] ~= nil then
            table.insert(self.mapResourcesQuarries, hex);
        elseif g_RESOURCES_PLANTATION_LIST[hex.ResourceType] ~= nil then
            table.insert(self.mapResourcesPlantations, hex);
        elseif g_RESOURCES_FISHINGBOAT_LIST[hex.ResourceType] ~= nil and hex:IsWater() == true then
            table.insert(self.mapResourcesFishings, hex);
        end
    end
end

-- Remove from the map the hex with current resource
-- Amber can be mine ressource (on land) and fishing (on water) - have to deal with that during mapping
function HexMap:RemoveMapResources(hex)
    if hex ~= nil and hex.ResourceType ~= g_RESOURCE_NONE then
        -- Remove previous resource from map
        for i , h in ipairs(self.mapResources[hex.ResourceType]) do
            if h == hex then
                table.remove(self.mapResources[hex.ResourceType], i)
                break;
            end
        end
        -- Remove from map to corresponding type of resources
        if g_RESOURCES_LUX_LIST[hex.ResourceType] ~= nil then
            table.remove(self.mapResourcesLux, hex);
        elseif g_RESOURCES_BONUS_LIST[hex.ResourceType] ~= nil then
            table.remove(self.mapResourcesBonus, hex);
        elseif g_RESOURCES_STRATEGICS[hex.ResourceType] ~= nil then
            table.remove(self.mapResourcesStrategics, hex);
        elseif g_RESOURCES_MINE_LIST[hex.ResourceType] ~= nil and hex:IsWater() == false then
            table.remove(self.mapResourcesMines, hex);
        elseif g_RESOURCES_PASTURE_LIST[hex.ResourceType] ~= nil then
            table.remove(self.mapResourcesPastures, hex);
        elseif g_RESOURCES_FARM_LIST[hex.ResourceType] ~= nil then
            table.remove(self.mapResourcesFarms, hex);
        elseif g_RESOURCES_QUARRY_LIST[hex.ResourceType] ~= nil then
            table.remove(self.mapResourcesQuarries, hex);
        elseif g_RESOURCES_PLANTATION_LIST[hex.ResourceType] ~= nil then
            table.remove(self.mapResourcesPlantations, hex);
        elseif g_RESOURCES_FISHINGBOAT_LIST[hex.ResourceType] ~= nil and hex:IsWater() == true then
            table.remove(self.mapResourcesFishings, hex);
        end
    end
end


function HexMap:InsertMapFeatures(hex)
    if hex ~= nil and hex.FeatureType ~= g_FEATURE_NONE then
        self.mapFeatures[hex.FeatureType] = self.mapFeatures[hex.FeatureType] or {};
        table.insert(self.mapFeatures[hex.FeatureType], hex)
    end
end

function HexMap:RemoveMapFeatures(hex)
    if hex ~= nil and hex.FeatureType ~= g_FEATURE_NONE then
        for i , h in ipairs(self.mapFeatures[hex.FeatureType]) do
            if h == hex then
                table.remove(self.mapFeatures[hex.FeatureType], i)
                break;
            end
        end
    end
end

function HexMap:InsertMapTerrains(hex)
    if hex ~= nil and hex.TerrainType ~= g_TERRAIN_TYPE_NONE then
        self.mapTerrains[hex.TerrainType] = self.mapTerrains[hex.TerrainType] or {};
        table.insert(self.mapTerrains[hex.TerrainType], hex)
    end
end

function HexMap:RemoveMapTerrains(hex)
    for i , h in ipairs(self.mapTerrains[hex.TerrainType]) do
        if h == hex then
            table.remove(self.mapTerrains[hex.TerrainType], i)
            break;
        end
    end
end

function HexMap:GetMapResourcesLux()
    local resourceLuxList = {}
    for idRes, t in pairs(self.mapResources) do
        if g_RESOURCES_LUX_LIST[idRes] ~= nil then
            local mapResourceIndex = self.mapResources[idRes];
            for _, hex in ipairs(mapResourceIndex) do
                table.insert(resourceLuxList, hex);
            end
        end
    end
    return resourceLuxList;
end

function HexMap:GetMapResourcesBonus()
    local resourceBonusList = {}
    for idRes, t in pairs(self.mapResources) do
        if g_RESOURCES_BONUS_LIST[idRes] ~= nil then
            local mapResourceIndex = self.mapResources[idRes];
            for _, hex in ipairs(mapResourceIndex) do
                table.insert(resourceBonusList, hex);
            end
        end
    end
    return resourceBonusList;
end

function HexMap:GetMapResourcesStrategics()
    local resourceStratList = {}
    for idRes, t in pairs(self.mapResources) do
        if g_RESOURCES_STRATEGICS[idRes] ~= nil then
            local mapResourceIndex = self.mapResources[idRes];
            for _, hex in ipairs(mapResourceIndex) do
                table.insert(resourceStratList, hex);
            end
        end
    end
    return resourceStratList;
end

function HexMap:GetMapResourcesFarms()
    local resourceFarmsList = {}
    for idRes, t in pairs(self.mapResources) do
        if g_RESOURCES_FARM_LIST[idRes] ~= nil then
            local mapResourceIndex = self.mapResources[idRes];
            for _, hex in ipairs(mapResourceIndex) do
                table.insert(resourceFarmsList, hex);
            end
        end
    end
    return resourceFarmsList;
end

function HexMap:GetMapResourcesPastures()
    local resourcePasturesList = {}
    for idRes, t in pairs(self.mapResources) do
        if g_RESOURCES_PASTURE_LIST[idRes] ~= nil then
            local mapResourceIndex = self.mapResources[idRes];
            for _, hex in ipairs(mapResourceIndex) do
                table.insert(resourcePasturesList, hex);
            end
        end
    end
    return resourcePasturesList;
end

function HexMap:GetMapResourcesMines()
    local resourceMinesList = {}
    for idRes, t in pairs(self.mapResources) do
        if g_RESOURCES_MINE_LIST[idRes] ~= nil then
            local mapResourceIndex = self.mapResources[idRes];
            for _, hex in ipairs(mapResourceIndex) do
                table.insert(resourceMinesList, hex);
            end
        end
    end
    return resourceMinesList;
end

function HexMap:GetMapResourcesQuarries()
    local resourceQuarriesList = {}
    for idRes, t in pairs(self.mapResources) do
        if g_RESOURCES_QUARRY_LIST[idRes] ~= nil then
            local mapResourceIndex = self.mapResources[idRes];
            for _, hex in ipairs(mapResourceIndex) do
                table.insert(resourceQuarriesList, hex);
            end
        end
    end
    return resourceQuarriesList;
end

function HexMap:GetMapResourcesPlantations()
    local resourcePlantationsList = {}
    for idRes, t in pairs(self.mapResources) do
        if g_RESOURCES_PLANTATION_LIST[idRes] ~= nil then
            local mapResourceIndex = self.mapResources[idRes];
            for _, hex in ipairs(mapResourceIndex) do
                table.insert(resourcePlantationsList, hex);
            end
        end
    end
    return resourcePlantationsList;
end

function HexMap:GetMapResourcesFishings()
    local resourcesFishingsList = {}
    for idRes, t in pairs(self.mapResources) do
        if g_RESOURCES_FISHINGBOAT_LIST[idRes] ~= nil then
            local mapResourceIndex = self.mapResources[idRes];
            for _, hex in ipairs(mapResourceIndex) do
                table.insert(resourcesFishingsList, hex);
            end
        end
    end
    return resourcesFishingsList;
end


-- Return the hex at the coord in parameter. nil if out of bound
function HexMap:GetHexInMap(pX, pY)
    if self.canCircumnavigate then
        pX = pX % self.width;
    end
    if (self.canCircumnavigate == false and (pX < 0 or pX >= self.width)) or (pY < 0 or pY >= self.height) then
        return nil
    end
    local hex = self.map[pY][pX];
    return hex
end

-- Return the sum of two hex vectors - do not check if the result is on map or not
function HexMap:GetHexSum(hex, vec)
    local newX = hex.x + vec.x
    local newY = hex.y + vec.y
    if self.canCircumnavigate then
        newX = newX % self.width
    end
    return Hex.new(newX, newY)
end

-- Return multiplication of hex vector times the factor in param
-- TODO : Warning - does not work with directions dependent to Y, for the moment only use with West or East direction
function HexMap:GetHexScale(hex, factor)
    return Hex.new(hex.x * factor, hex.y * factor)
end

-- 1 -> 0
-- 2 -> 1
-- 3 -> 2
-- 4 -> 3
-- Loop through all tiles in the specified ring in parameter
function HexMap:GetHexInRing(hexCenter, ringRadius)
    local hexList = {};
    -- Starting from the hex to the left
    local hexWest = self:GetHexSum(hexCenter, self:GetHexScale(hexCenter:GetAdjDirection(DirectionTypes.DIRECTION_WEST), ringRadius));
    local testHex = hexWest;
    local hexToAdd
    local hexDir
    for i=0, DirectionTypes.NUM_DIRECTION_TYPES - 1 do
        for r = 0, ringRadius - 1 do
            -- Check if the tested hex is in map coord range
            hexToAdd = self:GetHexInMap(testHex.x, testHex.y)
            -- if yes we add it to the table
            if hexToAdd ~= nil then
                table.insert(hexList, hexToAdd);
            end
            -- in every cases we move to the next tile
            hexDir = testHex:GetAdjDirection(i);
            testHex = self:GetHexSum(testHex, hexDir)
        end
    end
    return hexList;
end

-- Loop through all rings up to ring radius in parameter
function HexMap:GetAllHexInRing(hexCenter, ringRadius)
    local hexList = {};
    local hexTable = {};
    local hexInRingX = {};
    for i=0, ringRadius do
        hexTable[i] = {}
        hexInRingX = self:GetHexInRing(hexCenter, i);
        for k=1, #hexInRingX do
            table.insert(hexList, hexInRingX[k]);
            table.insert(hexTable[i], hexInRingX[k])
        end
    end
    return hexList, hexTable;
end

function Hex:GetAdjDirection(directionIndex)
    if self.y % 2 == 0 then
        if directionIndex == DirectionTypes.DIRECTION_NORTHEAST then
            return Hex.new(0, 1);
        elseif directionIndex == DirectionTypes.DIRECTION_EAST then
            return Hex.new(1, 0);
        elseif directionIndex == DirectionTypes.DIRECTION_SOUTHEAST then
            return Hex.new(0, -1);
        elseif directionIndex == DirectionTypes.DIRECTION_SOUTHWEST then
            return Hex.new(-1, -1);
        elseif directionIndex == DirectionTypes.DIRECTION_WEST then
            return Hex.new(-1, 0);
        elseif directionIndex == DirectionTypes.DIRECTION_NORTHWEST then
            return Hex.new(-1, 1);
        end
    elseif self.y % 2 == 1 then
        if directionIndex == DirectionTypes.DIRECTION_NORTHEAST then
            return Hex.new(1, 1);
        elseif directionIndex == DirectionTypes.DIRECTION_EAST then
           return Hex.new(1, 0);
        elseif directionIndex == DirectionTypes.DIRECTION_SOUTHEAST then
           return Hex.new(1, -1);
        elseif directionIndex == DirectionTypes.DIRECTION_SOUTHWEST then
           return Hex.new(0, -1);
        elseif directionIndex == DirectionTypes.DIRECTION_WEST then
           return Hex.new(-1, 0);
        elseif directionIndex == DirectionTypes.DIRECTION_NORTHWEST then
           return Hex.new(0, 1);
        end
   end
end

function HexMap:GetAdjDirectionInMap(hex, directionIndex)
    local adjHex = nil;
    if hex.y % 2 == 0 then
        if directionIndex == DirectionTypes.DIRECTION_NORTHEAST then
            adjHex = self:GetHexSum(hex, Hex.new(0, 1))
            return self:GetHexInMap(adjHex.x, adjHex.y)
        elseif directionIndex == DirectionTypes.DIRECTION_EAST then
            adjHex = self:GetHexSum(hex, Hex.new(1, 0))
            return self:GetHexInMap(adjHex.x, adjHex.y)
        elseif directionIndex == DirectionTypes.DIRECTION_SOUTHEAST then
            adjHex = self:GetHexSum(hex, Hex.new(0, -1))
            return self:GetHexInMap(adjHex.x, adjHex.y)
        elseif directionIndex == DirectionTypes.DIRECTION_SOUTHWEST then
            adjHex = self:GetHexSum(hex, Hex.new(-1, -1))
            return self:GetHexInMap(adjHex.x, adjHex.y)
        elseif directionIndex == DirectionTypes.DIRECTION_WEST then
            adjHex = self:GetHexSum(hex, Hex.new(-1, 0))
            return self:GetHexInMap(adjHex.x, adjHex.y)
        elseif directionIndex == DirectionTypes.DIRECTION_NORTHWEST then
            adjHex = self:GetHexSum(hex, Hex.new(-1, 1))
            return self:GetHexInMap(adjHex.x, adjHex.y)
        end
    elseif hex.y % 2 == 1 then
        if directionIndex == DirectionTypes.DIRECTION_NORTHEAST then
            adjHex = self:GetHexSum(hex, Hex.new(1, 1))
            return self:GetHexInMap(adjHex.x, adjHex.y)
        elseif directionIndex == DirectionTypes.DIRECTION_EAST then
            adjHex = self:GetHexSum(hex, Hex.new(1, 0))
            return self:GetHexInMap(adjHex.x, adjHex.y)
        elseif directionIndex == DirectionTypes.DIRECTION_SOUTHEAST then
            adjHex = self:GetHexSum(hex, Hex.new(1, -1))
            return self:GetHexInMap(adjHex.x, adjHex.y)
        elseif directionIndex == DirectionTypes.DIRECTION_SOUTHWEST then
            adjHex = self:GetHexSum(hex, Hex.new(0, -1))
            return self:GetHexInMap(adjHex.x, adjHex.y)
        elseif directionIndex == DirectionTypes.DIRECTION_WEST then
            adjHex = self:GetHexSum(hex, Hex.new(-1, 0))
            return self:GetHexInMap(adjHex.x, adjHex.y)
        elseif directionIndex == DirectionTypes.DIRECTION_NORTHWEST then
            adjHex = self:GetHexSum(hex, Hex.new(0, 1))
            return self:GetHexInMap(adjHex.x, adjHex.y)
        end
   end
end

function HexMap:ContinentsInRange(hex, range)
    local hexes, _ = self:GetAllHexInRing(hex, range)
    local listOfIdContinent = {}
    local continentsInRange = 1
    table.insert(listOfIdContinent, hex.IdContinent);
    for _ , h in pairs(hexes) do
        if h.IdContinent ~= hex.IdContinent and h.IdContinent ~= -1 then
            continentsInRange = continentsInRange + 1
            table.insert(listOfIdContinent, h.IdContinent);
        end
    end
    return continentsInRange, listOfIdContinent;
end

function HexMap:GetGlobalHillPercent()
    local countHills, _ = self:LookForHills();
    local countLandTiles, _ = self:GetLandHexList();
    _Debug("GetGlobalHillPercent = ", countHills / countLandTiles)
   return countHills / countLandTiles
end

-- Hills / Passable land - 0 to 1
function HexMap:GetHillPercentInRange(hex, range)
    local totalRingInRange = self:GetAllHexInRing(hex, range);
    local passableLand = {};
    local passableLandCount = 0;
    local hillsTiles = {};
    local hillsCount = 0;
    for _, h in pairs(totalRingInRange) do
        if h:IsImpassable() == false then
            passableLandCount = passableLandCount + 1;
            table.insert(passableLand, h)
            if IsHill(h.TerrainType) then
                hillsCount = hillsCount + 1;
                table.insert(hillsTiles, h)
            end
        end
    end
    if hillsCount == 0 then
        return passableLandCount, hillsCount, 0;
    end
   return passableLand, passableLandCount, hillsTiles, hillsCount, hillsCount / passableLandCount;
end


-- Return the list of hex in each ring that are accessible by walking, range is step, if no obstacle, range = ring
function Hex:SetAllWalkableHexInRange(range)
    if self:IsImpassable() then
        return;
    end
    local visitedRing = {};
    local visitedHex = {};
    visitedRing[0] = {};
    visitedHex[self] = true;
    table.insert(visitedRing[0], self);
    local n1 -- index previous ring
    local h --hex analysed during loops
    local visitedRingN1 -- list of visited hex in previous ring
    local hRing1 -- ring1 of h
    local neighbor --current analysed neighbor r1 of h
    for n = 1, range do
        visitedRing[n] = {};
        n1 = n - 1;
        visitedRingN1 = visitedRing[n1]
        for i = 1, #visitedRingN1 do
            h = visitedRingN1[i]
            hRing1 = h.AllRing6Map[1]
            for j = 1, #hRing1 do
                neighbor = hRing1[j]
                if neighbor:IsImpassable() == false and visitedHex[neighbor] == nil then
                    visitedHex[neighbor] = true;
                    table.insert(visitedRing[n], neighbor);
                end
            end
        end
    end
    self.WalkableHexInRing = visitedRing;
end

function Hex:IsWalkableInRange(hexTarget, range)
    if self.WalkableHexInRing == nil then
        return
    end
    for _, h in pairs(self.WalkableHexInRing[range]) do
        if h == hexTarget then
            return true;
        end
    end
    return false;
end

function Hex:HasContinentInWalkableRange(range)
    if self.WalkableHexInRing == nil then
        return
    end
    if range > 6 then
        _Debug("WARN - Walkable tiles limited at 6 by default")
        return false;
    end
    local i = 1;
    while(i < range + 1) do
        for _, h in pairs(self.WalkableHexInRing[i]) do
            if h.IdContinent ~= self.IdContinent then
                return true;
            end
        end
        i = i + 1;
    end
    return false;
end

-- Used for terraforming method, to avoid relocate plain on tundra for example
function Hex:IsSameTerrainCategory(terrainId)
    local isTundraOrSnow = (self:IsTundraLand() or self:IsSnowLand()) and (IsTundraLand(terrainId) or IsSnowLand(terrainId));
    local isDesert = self:IsDesertLand() and IsDesertLand(terrainId)
    local otherTerrain = (self:IsGrassLand() or self:IsPlainLand()) and (IsGrassLand(terrainId) or IsPlainLand(terrainId));
    return isTundraOrSnow or isDesert or otherTerrain;
end

function Hex:FindFloodplainArea()
    if self:IsFloodplains(true) == false then
        return;
    end
    local visitedRing = {};
    local visitedHex = {};
    visitedRing[0] = {};
    visitedHex[self] = true;
    table.insert(visitedRing[0], self);
    local countFloodArea = 1;
    local n1 -- index previous ring
    local h --hex analysed during loops
    local visitedRingN1 -- list of visited hex in previous ring
    local hRing1 -- ring1 of h
    local neighbor --current analysed neighbor r1 of h
    for n = 1, 6 do
        visitedRing[n] = {};
        n1 = n - 1;
        visitedRingN1 = visitedRing[n1]
        for i = 1, #visitedRingN1 do
            h = visitedRingN1[i]
            hRing1 = h.AllRing6Map[1]
            for j = 1, #hRing1 do
                neighbor = hRing1[j]
                if neighbor:IsImpassable() == false and visitedHex[neighbor] == nil and neighbor:IsFloodplains(true) then
                    countFloodArea = countFloodArea + 1;
                    visitedHex[neighbor] = true;
                    table.insert(visitedRing[n], neighbor);
                end
            end
        end
    end
    return countFloodArea;
end

---------------------------------------
-- Terraforming methods
---------------------------------------

---------------------------------------
-- Terrains
-- Should never be none
---------------------------------------
function HexMap:TerraformSetTerrain(hex, terrainId)
    if hex ~= nil and hex.TerrainType ~= g_TERRAIN_TYPE_NONE and hex.IsTaggedAsMinimum == false then
        --self:RemoveMapTerrains(hex);
        TerrainBuilder.SetTerrainType(hex.Plot, terrainId);
        hex.TerrainType = terrainId
        hex:UpdateYields();
       --self:InsertMapTerrains(hex);
        return true;
    end
    return false;
end

---------------------------------------
-- Resources
---------------------------------------
function HexMap:TerraformSetResource(hex, resourceId, forced)
    --and ResourceBuilder.CanHaveResource(hex.Plot, resourceId)
    if hex.Plot ~= nil  then
        if resourceId == g_RESOURCE_NONE then
            ResourceBuilder.SetResourceType(hex.Plot, g_RESOURCE_NONE);
            hex.ResourceType = resourceId;
            hex.HexResource = HexResource.new(self.ResourceType);
            hex:UpdateYields()
            return true;
        end
        -- For specifics resources, we can force a good tile to meet the right conditions
        if forced and (hex:IsSnowLand() == false and hex:IsDesertLand() == false) then
            ResourceBuilder.SetResourceType(hex.Plot, g_RESOURCE_NONE);
            -- Only oil and niter strats can be on floods, and we do not remove floods when forcing strats
            if hex:IsFloodplains(true) and g_RESOURCES_STRATEGICS[resourceId] ~= nil 
                and resourceId ~= g_RESOURCE_NITER and resourceId ~= g_RESOURCE_OIL then
                return false;
            end
            if resourceId == g_RESOURCE_HORSES then
                if (IsPlainLand(hex.TerrainType) == false and IsGrassLand(hex.TerrainType) == false) then
                    return false;
                end
                self:TerraformToFlat(hex, true);
            elseif resourceId == g_RESOURCE_IRON then
                self:TerraformToHill(hex, true);
            elseif resourceId == g_RESOURCE_NITER then
                self:TerraformToFlat(hex, true);
            elseif resourceId == g_RESOURCE_COAL then
                if IsPlainLand(hex.TerrainType) == false and IsGrassLand(hex.TerrainType) == false then
                    return false;
                end
                self:TerraformToHill(hex, true);
            elseif resourceId == g_RESOURCE_ALUMINUM then
                if self:CanHaveJungle(hex) then
                    self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS);
                    self:TerraformSetFeature(hex, g_FEATURE_JUNGLE);
                elseif hex.TerrainType == g_TERRAIN_TYPE_DESERT_HILLS then
                    self:TerraformToFlat(hex, true);
                elseif IsTundraLand(hex.TerrainType) == false and IsSnowLand(hex.TerrainType) == false then
                    self:TerraformToFlat(hex, true);
                    self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS);
                end
            elseif resourceId == g_RESOURCE_OIL and hex:IsWater() == false then
                self:TerraformSetFeature(hex, g_FEATURE_NONE);
                self:TerraformToFlat(hex, true);
            -- Special force placement on lux, to help CheckLuxThreshold method to make room for most restrictives lux placements
            elseif hex:IsFloodplains(true) == false then
                print("Try force placement of lux ", resourceId, hex:PrintXY())
                if g_LUX_ON_FLAT_GRASS_LIST[resourceId] then
                    self:TerraformSetFeature(hex, g_FEATURE_NONE)
                    self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS);
                elseif g_LUX_ON_FLAT_PLAINS_LIST[resourceId] then
                    self:TerraformSetFeature(hex, g_FEATURE_NONE)
                    self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS);
                elseif g_LUX_ON_FOREST_LIST[resourceId] then
                    self:TerraformSetFeature(hex, g_FEATURE_FOREST)
                    self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS);
                end
            end
        end
        -- Forcing to do try on desert, tundra if it can not have the resource
        -- In case of forcing lux, terraforming should have been done previously in forced method
        if self:CanHaveResource(hex, resourceId)
            or (forced and hex:IsWater() == false and hex:IsDesertLand() == false and hex:IsSnowLand() == false and g_RESOURCES_LUX_LIST[resourceId] == false) then
            _Debug("From TerraformSetResource ", hex:PrintXY(), hex.TerrainType, hex.FeatureType, hex.ResourceType);
            ResourceBuilder.SetResourceType(hex.Plot, g_RESOURCE_NONE);
            ResourceBuilder.SetResourceType(hex.Plot, resourceId, 1);
            hex.ResourceType = resourceId;
            hex.HexResource = HexResource.new(self.ResourceType);
            --self:InsertMapResources(hex);
            hex:UpdateYields()
            _Debug("Terraform resource on ", hex:PrintXY(), hex.TerrainType, hex.FeatureType, hex.ResourceType);
            return true;
        else
            _Debug("TerraformSetResource - Can't terraform "..tostring(resourceId).." on "..hex:PrintXY())
        end
    end
    return false;
end

function HexMap:CanHaveResource(hex, resourceId) 
    if resourceId == g_RESOURCE_PENGUINS then
        return (hex.IsCoastal or hex:IsNextToLake()) and ResourceBuilder.CanHaveResource(hex.Plot, resourceId)
    end
    return ResourceBuilder.CanHaveResource(hex.Plot, resourceId)
end

function HexMap:TerraformSetResourceRequirements(hex, resourceId)
    return (resourceId == g_RESOURCE_NONE or self:CanHaveResource(hex, resourceId)) and hex.IsTaggedAsMinimum == false;
end

function HexMap:TerraformAddRandomLux(hex, canAddOnWater, forced)
    if hex:IsWater() and canAddOnWater == false then
        return false;
    end
    local continentId = hex.IdContinent;
    local possiblesLux = self.LuxTable[continentId];
    possiblesLux = GetShuffledCopyOfTable(possiblesLux);
    for _, idLux in ipairs(possiblesLux) do
        if self:TerraformSetResource(hex, idLux, forced) then
            print("TerraformAddRandomLux - A lux has been added (id = ", idLux, ")")
            self:CleanHighYieldsOnFresh(hex)
            return true;
        end
    end
    return false;
end

---------------------------------------
-- Features -- We do not terraform features linked to disaster so volcano and floodplains
---------------------------------------
function HexMap:TerraformSetFeature(hex, featureId, forced)
    if self:TerraformSetFeatureRequirements(hex, featureId, forced) then
        _Debug("From TerraformSetFeature ", hex:PrintXY(), hex.TerrainType, hex.FeatureType, hex.ResourceType);
        self:RemoveMapFeatures(hex)
        TerrainBuilder.SetFeatureType(hex.Plot, featureId);
        hex.FeatureType = featureId;
        hex:UpdateYields()
        self:InsertMapFeatures(hex);
        _Debug("Terraform feature ", featureId, " on ", hex:PrintXY())
        return true;
    else
        _Debug("Can't terraform feature "..tostring(featureId).." on "..hex:PrintXY())
    end
    return false;
end

function HexMap:TerraformSetFeatureRequirements(hex, featureId, forced)
    local disasterTile = (IsFloodplains(hex.FeatureType, false) and IsFloodplains(featureId, false) == false) or hex.FeatureType == g_FEATURE_VOLCANO;
    if hex.Plot ~= nil and disasterTile == false and (TerrainBuilder.CanHaveFeature(hex.Plot, featureId) or forced) and hex.IsTaggedAsMinimum == false then
        return true
    end
    return false;
end

function HexMap:TerraformEmptyTile(hex)
    if self:TerraformSetFeatureRequirements(hex, g_FEATURE_NONE, true) then
        self:TerraformSetFeature(hex, g_FEATURE_NONE, true);
    end
    if self:TerraformSetResourceRequirements(hex, g_RESOURCE_NONE) then
        self:TerraformSetResource(hex, g_RESOURCE_NONE, true);
        return true;
    end
    return false;
end

---------------------------------------
-- Hills
-- Info : not currently mapped, see if needed
---------------------------------------
function HexMap:TerraformToHill(hex, cleanTile)
    if (cleanTile) then
        self:TerraformSetFeature(hex, g_FEATURE_NONE, true);
        self:TerraformSetResource(hex, g_RESOURCE_NONE, true);
    end
    if hex.TerrainType == g_TERRAIN_TYPE_GRASS then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS)
    elseif hex.TerrainType == g_TERRAIN_TYPE_PLAINS then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS)
    elseif hex.TerrainType == g_TERRAIN_TYPE_DESERT then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_DESERT_HILLS)
    elseif hex.TerrainType == g_TERRAIN_TYPE_TUNDRA then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_TUNDRA_HILLS)
    elseif hex.TerrainType == g_TERRAIN_TYPE_SNOW then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_SNOW_HILLS)
    end
    hex:UpdateYields()
    return true;
end

function HexMap:TerraformMountainToHill(hex)
    if hex.FeatureType == g_FEATURE_VOLCANO then
        return false;
    end
    if hex.TerrainType == g_TERRAIN_TYPE_GRASS_MOUNTAIN then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS)
    elseif hex.TerrainType == g_TERRAIN_TYPE_PLAINS_MOUNTAIN then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS)
    elseif hex.TerrainType == g_TERRAIN_TYPE_DESERT_MOUNTAIN then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_DESERT_HILLS)
    elseif hex.TerrainType == g_TERRAIN_TYPE_TUNDRA_MOUNTAIN then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_TUNDRA_HILLS)
    elseif hex.TerrainType == g_TERRAIN_TYPE_SNOW_MOUNTAIN then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_SNOW_HILLS)
    end
    hex:UpdateYields()
    _Debug("TerraformMountainToHill - ", hex:PrintXY(), " is now ", hex.TerrainType)
    return true;
end

-- Used when terraforming water to land for example
function HexMap:TerraformBasicTile(hex)
    local rng = TerrainBuilder.GetRandomNumber(100, "Plain or grass terraform");
    local rngHills = TerrainBuilder.GetRandomNumber(100, "Hills terraform");
    local rngForest = TerrainBuilder.GetRandomNumber(100, "Forest terraform");
    if rng <= 50 then
        if rngHills <= 50 then
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS)
        else
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS)
        end
    else
        if rngHills <= 50 then
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS)
        else
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS)
        end
    end
    if rngForest <= 25 then
        self:TerraformSetFeature(hex, g_FEATURE_FOREST, false);
    end
    return true;
end

function HexMap:TerraformDesert(hex)
    if hex:IsDesertLand() == false then
        _Debug("TerraformDesert - Not a desert")
        return false;
    end
    _Debug("Enter TerraformDesert")
    if hex.ResourceType == g_RESOURCE_SILVER then
        _Debug("TerraformDesert deleted a silver that cannot exist outside of desert (seems to be deleted by firaxis at start while existing in further methods if not on desert)")
        self:TerraformSetResource(hex, g_RESOURCE_NONE, true)
    end
    --50% plain/grass
    local rngTerrain = TerrainBuilder.GetRandomNumber(100, "Desert terrain terraform");
    -- leave oasis as it is (cant be terraformed correctly to lakes)
    if hex.FeatureType == g_FEATURE_OASIS then
        _Debug("Removed oasis", hex:PrintXY())
         self:TerraformSetFeature(hex, g_FEATURE_NONE, true);
     elseif hex.FeatureType == g_FEATURE_FLOODPLAINS then
        local floodArea = hex:FindFloodplainArea()
        -- minimumFloodArea is 4, lower than this value, flood can safely be removed, else left as such
        if floodArea < 4 then
            _Debug("Flood desert to none", hex:PrintXY(), " Floodarea = ", floodArea)
            self:TerraformSetFeature(hex, g_FEATURE_NONE, true);
        else
            _Debug("Flood desert untouched", hex:PrintXY(), " Floodarea = ", floodArea)
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS)
            return self:TerraformSetFeature(hex, g_FEATURE_FLOODPLAINS_PLAINS, true);
        end
        --
    end
    local rng = TerrainBuilder.GetRandomNumber(100, "Desert terraform");
    if hex.TerrainType == g_TERRAIN_TYPE_DESERT then
        if rngTerrain <= 50 then
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS)
        else 
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS)
        end
    elseif hex.TerrainType == g_TERRAIN_TYPE_DESERT_HILLS then
        if rngTerrain <= 50 then
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS)
        else 
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS)
        end
        -- Avoid 1/3 settle
        if hex.ResourceType == g_RESOURCE_GYPSUM and (hex.IsFreshWater or hex.IsCoastal) then
            self:TerraformToFlat(hex, false)
        end
    elseif hex.TerrainType == g_TERRAIN_TYPE_DESERT_MOUNTAIN then
        if rngTerrain <= 50 then
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_MOUNTAIN)
        else 
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_MOUNTAIN)
        end
    end
    if rng <= 33 and hex.FeatureType == g_FEATURE_NONE and hex.ResourceType == g_RESOURCE_NONE then
        self:TerraformSetFeature(hex, g_FEATURE_FOREST, false);
    end
    return true;
end

-- Possible 2/2 tiles without lux :
-- Grass+Hill+Forest, Plain+Junle+Hills, Stone+Hills, Deer+Forest, Grass+Sheeps
-- Extra yield (gold faith culture science) not taken in account here
function HexMap:TerraformTo4Yields(hex, garanteed22, canChangeBonusRes)
    -- Low yield strategics and lux are not changed here, floodplains untouched because placement is making sure we are not around 5 or 6 flood in ring 1
    if self:HasTerraformTo4YieldsRequirements(hex) == false then
        return false;
    end
    _Debug("TerraformTo4Yields entry ", garanteed22, hex:PrintXY());
    if hex:IsTundraLand() then
        return self:TerraformTo4YieldsTundra(hex, garanteed22)
    end
    -- If true, we should terraform this tile to be 2/2
    if garanteed22 and (hex.Food ~= 2 or hex.Prod ~= 2) then
        _Debug("TerraformTo4Yields go to TerraformTo22Yields ", garanteed22, hex:PrintXY());
        return self:TerraformTo22Yields(hex, true);
    elseif hex.Food + hex.Prod >= 4 then
        _Debug("TerraformTo4Yields already a 4 yields tiles");
        return false;
    end
    -- Low yields upgrades
    if hex.TerrainType == g_TERRAIN_TYPE_GRASS and hex.FeatureType == g_FEATURE_FOREST then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS);
    elseif hex.TerrainType == g_TERRAIN_TYPE_PLAINS and hex.FeatureType == g_FEATURE_JUNGLE and hex.ResourceType == g_RESOURCE_NONE then
        local rng = TerrainBuilder.GetRandomNumber(100, "Random");
        if rng <= 50 then
            _Debug("Jungle flat to hills")
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS);
        else
            _Debug("Add bananas to jungle")
            self:TerraformSetResource(hex, g_RESOURCE_BANANAS);
        end
    elseif hex.TerrainType == g_TERRAIN_TYPE_PLAINS and hex.FeatureType == g_FEATURE_FOREST and hex.ResourceType == g_RESOURCE_NONE then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS);
    elseif hex.ResourceType == g_RESOURCE_STONE and hex.TerrainType == g_TERRAIN_TYPE_GRASS then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS);
    -- Standard terraform empty tile to 22
    elseif hex.ResourceType == g_RESOURCE_NONE and (hex.FeatureType == g_FEATURE_NONE or hex.FeatureType == g_FEATURE_MARSH)
        and hex:IsTundraLand() == false and hex:IsDesertLand() == false then
        local rng = TerrainBuilder.GetRandomNumber(100, "Random");
        if hex:IsPlainLand() and hex.FeatureType ~= g_FEATURE_MARSH then
            if rng <= 25 then
                self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS);
                self:TerraformSetFeature(hex, g_FEATURE_FOREST, true);
            elseif rng <= 50 and self:CanHaveJungle(hex) then
                self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS);
                self:TerraformSetFeature(hex, g_FEATURE_JUNGLE, true);
                self:TerraformSetResource(hex, g_RESOURCE_BANANAS);
            else 
                self:TerraformTo22Yields(hex, true);
            end
        else
            self:TerraformTo22Yields(hex, true);
        end
    -- Some bonus or lux resources that cant be changed naturally
    elseif canChangeBonusRes and g_RESOURCES_BONUS_LIST[hex.ResourceType] then
        self:TerraformSetResource(hex, g_RESOURCE_NONE);
        return self:TerraformTo22Yields(hex, true);
    else
        _Debug("TerraformTo4Yields - Can't upgrade naturally - Terrain : "..tostring(hex.TerrainType).." Resource :"..tostring(hex.ResourceType).." - Feature : "..tostring(hex.FeatureType))
        return false;
    end
    hex:UpdateYields()
    return true;
end

function HexMap:HasTerraformTo4YieldsRequirements(hex)
    if hex.IsNaturalWonder
        or hex:IsSnowLand() or hex:IsDesertLand()
        or g_RESOURCES_STRATEGICS[hex.ResourceType]
        or g_RESOURCES_LUX_LIST[hex.ResourceType]
        or hex:IsWater()
        or hex:IsFloodplains(true)
        or hex.FeatureType == g_FEATURE_GEOTHERMAL_FISSURE then
            return false;
    end
    return true;
end

function HexMap:TerraformTo4YieldsTundra(hex, garanteed22)
    -- 4yields considered as 1/2 or 1/3
    -- Possible resources (lux excluded) are sheep, deer, copper
    _Debug("Enter TerraformTo4YieldsTundra ", hex:PrintXY())
    if garanteed22 then
        -- Default will be deer with hill/forest or both
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_TUNDRA);
        self:TerraformSetFeature(hex, g_FEATURE_NONE, true);
        self:TerraformSetResource(hex, g_RESOURCE_DEER, true);
        local rng = TerrainBuilder.GetRandomNumber(100, "Random yields");
        if rng <= 45 then
            return self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_TUNDRA_HILLS);
        elseif rng <= 75 then
            return self:TerraformSetFeature(hex, g_FEATURE_FOREST, true);
        else
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_TUNDRA_HILLS);
            return self:TerraformSetFeature(hex, g_FEATURE_FOREST, true);
        end
    end
    if hex.ResourceType == g_RESOURCE_COPPER then
        return false;
    end
    local rng = TerrainBuilder.GetRandomNumber(100, "Random resource");
    _Debug("TerraformTo4YieldsTundra - added hills ", hex:PrintXY());
    self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_TUNDRA_HILLS);
    if rng <= 10 then
        _Debug("TerraformTo4YieldsTundra - added deer hills forest ", rng, hex:PrintXY())
        self:TerraformSetResource(hex, g_RESOURCE_DEER, true);
        return self:TerraformSetFeature(hex, g_FEATURE_FOREST, true);
    elseif rng <= 25 then
        _Debug("TerraformTo4YieldsTundra - added deer hills ", rng, hex:PrintXY())
        return self:TerraformSetResource(hex, g_RESOURCE_DEER, true);
    elseif rng <= 40 then
        _Debug("TerraformTo4YieldsTundra - added deer forest ", rng, hex:PrintXY())
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_TUNDRA);
        self:TerraformSetResource(hex, g_RESOURCE_DEER, true);
        return self:TerraformSetFeature(hex, g_FEATURE_FOREST, true);
    else
        _Debug("TerraformTo4YieldsTundra - added forest ", rng, hex:PrintXY())
        return self:TerraformSetFeature(hex, g_FEATURE_FOREST, true);
    end
end

function HexMap:TerraformTo22Yields(hex, emptyTileBeforeTerraform)
    _Debug("TerraformTo22Yields entry");
    if IsFloodplains(hex.FeatureType,true) or (hex:IsGrassLand() == false and hex:IsPlainLand() == false) then
        _Debug("TerraformTo22Yields - only terraform grass or plains and no floodplains ", hex:PrintXY())
        return false;
    end
    if emptyTileBeforeTerraform then
        self:TerraformSetFeature(hex, g_FEATURE_NONE, true);
        self:TerraformSetResource(hex, g_RESOURCE_NONE, true);
    end
    local rng = TerrainBuilder.GetRandomNumber(100, "Random");
    if rng <= 10 then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS);
        self:TerraformSetFeature(hex, g_FEATURE_FOREST, false);
        self:TerraformSetResource(hex, g_RESOURCE_DEER, true);
        _Debug("TerraformTo4Yields "..hex:PrintXY().." to 2/2 Deer");
    elseif rng <= 25 then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS);
        self:TerraformSetResource(hex, g_RESOURCE_SHEEP, true);
        _Debug("TerraformTo4Yields "..hex:PrintXY().." to 2/2 Sheep");
    elseif rng <= 40 then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS);
        self:TerraformSetResource(hex, g_RESOURCE_STONE, true);
        _Debug("TerraformTo4Yields "..hex:PrintXY().." to 2/2 Stone");
    else
        return self:TerraformTo22YieldsNoResource(hex);
    end
    return true;
end

function HexMap:TerraformAdd1Food(hex, canMinusProd, canExtraYield)
    if  g_RESOURCES_STRATEGICS[hex.ResourceType]
            or g_RESOURCES_LUX_LIST[hex.ResourceType]
            or hex:IsWater()
            or hex.FeatureType == g_FEATURE_GEOTHERMAL_FISSURE then
        _Debug("TerraformAdd1Food - Can't upgrade naturally (excluded lux, strat, water) - Terrain : "..tostring(hex.TerrainType).." Resource :"..tostring(hex.ResourceType).." - Feature : "..tostring(hex.FeatureType))
        return false;
    end
    -- Security check to not terraform an existing resource on tested tile
    if hex.ResourceType ~= g_RESOURCE_NONE then
        if hex.ResourceType == g_RESOURCE_MAIZE or hex.ResourceType == g_RESOURCE_COPPER then
            self:TerraformSetResource(hex, g_RESOURCE_NONE, false);
        elseif hex.Food + hex.Prod == 3 and g_RESOURCES_BONUS_LIST[hex.ResourceType] then
            self:TerraformTo22Yields(hex, true);
        else
            return false;
        end
    end
    if hex.FeatureType ~= g_FEATURE_NONE then
        return self:TerraformAdd1FoodOnFeatureHex(hex, canMinusProd, canExtraYield)
    else
        return self:TerraformAdd1FoodEmptyHex(hex);
    end
end

-- Tile without feature or resource => Add 1 food
function HexMap:TerraformAdd1FoodEmptyHex(hex)
    if hex.FeatureType ~= g_FEATURE_NONE or hex.ResourceType  ~= g_RESOURCE_NONE then
        return false;
    end
    local rng = TerrainBuilder.GetRandomNumber(100, "Random Add food from empty");
    if self:CanHaveJungle(hex) and IsPlainLand(hex.TerrainType) and rng < 50 then
        return self:TerraformSetFeature(hex, g_FEATURE_JUNGLE, false);
    end
    if hex.TerrainType == g_TERRAIN_TYPE_GRASS then
        if rng <= 45 then
            return self:TerraformSetResource(hex, g_RESOURCE_RICE);
        elseif rng <= 90 then
            return self:TerraformSetResource(hex, g_RESOURCE_CATTLE);
        else
            return self:TerraformSetFeature(hex, g_FEATURE_MARSH);
        end
    elseif hex.TerrainType == g_TERRAIN_TYPE_PLAINS then
        return self:TerraformSetResource(hex, g_RESOURCE_WHEAT);
    -- To 4yields tile
    elseif hex.TerrainType == g_TERRAIN_TYPE_GRASS_HILLS or hex.TerrainType == g_TERRAIN_TYPE_PLAINS_HILLS
            or hex.TerrainType == g_TERRAIN_TYPE_DESERT_HILLS or hex.TerrainType == g_TERRAIN_TYPE_TUNDRA_HILLS then
        return self:TerraformSetResource(hex, g_RESOURCE_SHEEP);
    end
end

-- Terraform tiles with a feature and no resource to add 1 food on
function HexMap:TerraformAdd1FoodOnFeatureHex(hex, canMinusProd, canExtraYield)
    if hex.FeatureType == g_FEATURE_NONE or hex.ResourceType ~= g_RESOURCE_NONE then
        return false;
    end
    -- FLOODPLAINS
    if canMinusProd and hex.FeatureType == g_FEATURE_FLOODPLAINS_PLAINS and hex.ResourceType == g_RESOURCE_NONE then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS);
        return self:TerraformSetFeature(hex, g_FEATURE_FLOODPLAINS_GRASSLAND, true);
        --_Debug("TerraformAdd1FoodOnFeatureHex added resource on flood")
        --if hex.TerrainType == g_TERRAIN_TYPE_PLAINS then
        --    return self:TerraformSetResource(hex, g_RESOURCE_WHEAT);
        --elseif hex.TerrainType == g_TERRAIN_TYPE_GRASS then
        --    return self:TerraformSetResource(hex, g_RESOURCE_RICE);
        --end
    -- JUNGLE
    elseif hex.FeatureType == g_FEATURE_JUNGLE then
        _Debug("TerraformAdd1FoodOnFeatureHex added bananas")
        return self:TerraformSetResource(hex, g_RESOURCE_BANANAS, false)
    -- FOREST
    elseif hex.FeatureType == g_FEATURE_FOREST then
        if canMinusProd and IsPlainLand(hex.TerrainType) then
            if self:CanHaveJungle(hex) then
                _Debug("TerraformAdd1FoodOnFeatureHex forest to jungle")
                return self:TerraformSetFeature(hex, g_FEATURE_JUNGLE, true);
            elseif hex.TerrainType == g_TERRAIN_TYPE_PLAINS then
                _Debug("TerraformAdd1FoodOnFeatureHex plain to grass")
                return self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS);
            elseif hex.TerrainType == g_TERRAIN_TYPE_PLAINS_HILLS then
                _Debug("TerraformAdd1FoodOnFeatureHex plain hills to grass hills")
                return self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS);
            end
        else
            -- 1/2 plain forest to grass hill forest
            if hex.TerrainType == g_TERRAIN_TYPE_PLAINS then
                return self:TerraformTo22YieldsNoResource(hex)
            -- 1/3 to 2/3 if allowed
            elseif hex.TerrainType == g_TERRAIN_TYPE_PLAINS_HILLS and canExtraYield then
                self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS);
                return self:TerraformSetResource(hex, g_RESOURCE_DEER, false);
            -- grass forest with or without hill => can only get to 3/2 by lux or banana jungle
            elseif hex.TerrainType == g_TERRAIN_TYPE_GRASS_HILLS and self:CanHaveJungle(hex) and canExtraYield then
                self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS);
                self:TerraformSetFeature(hex, g_FEATURE_JUNGLE, true);
                return self:TerraformSetResource(hex, g_RESOURCE_BANANAS, true);
            else
                return false;
            end

        end
    -- MARCH -- 4food tiles
    elseif hex.FeatureType == g_FEATURE_MARSH then
        return self:TerraformSetResource(hex, g_RESOURCE_RICE, true);
    else
        -- Other features
        return false;
    end
end






-- Possibles 4yields : without resource, stone, sheep, deer, lux
function HexMap:Terraform4YieldsToHighYields(hex, canChangeResource, canAddLux)
    if (hex.Food + hex.Prod ~= 4) or (IsTundraLand(hex.TerrainType) and hex.Food + hex.Prod ~= 3)
            or g_RESOURCES_LUX_LIST[hex.ResourceType] or g_RESOURCES_STRATEGICS[hex.ResourceType] or IsDesertLand(hex.TerrainType) then
        return
    end
    _Debug("Terraform4YieldsToHighYields")
    -- If is a water tile, turn into fish reef
    if hex:IsWater() then
        _Debug("Terraform4YieldsToHighYields Add FishReef")
        self:TerraformSetFeature(hex, g_FEATURE_REEF, true);
        return self:TerraformSetResource(hex, g_RESOURCE_FISH, true);
    else
        if canAddLux and hex.ResourceType == g_RESOURCE_NONE and self:TerraformAddRandomLux(hex, false, false) then
            _Debug("Terraform4YieldsToHighYields Added a lux from standard ", hex.ResourceType)
            return true;
        end
        if canChangeResource and (hex.ResourceType ~= g_RESOURCE_NONE and g_RESOURCES_LUX_LIST[hex.ResourceType] == false and g_RESOURCES_STRATEGICS[hex.ResourceType] == false) then
            -- Stone, Sheep
            if hex.ResourceType ~= g_RESOURCE_BANANAS and hex.ResourceType ~= g_RESOURCE_DEER then
                _Debug("Terraform4YieldsToHighYields Resource cleared", hex.ResourceType);
                self:TerraformSetResource(hex, g_RESOURCE_NONE, true);
                self:TerraformTo22YieldsNoResource(hex)
            end
        end
        if IsTundraLand(hex.TerrainType) then
            _Debug("Terraform4YieldsToHighYields tundra Deer + hills + forests");
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_TUNDRA_HILLS);
            self:TerraformSetFeature(hex, g_FEATURE_FOREST, true);
            return self:TerraformSetResource(hex, g_RESOURCE_DEER, true);
        elseif hex.FeatureType == g_FEATURE_JUNGLE then
            if hex.ResourceType ~= g_RESOURCE_BANANAS then
                _Debug("Terraform4YieldsToHighYields Jungle 2/2 to Bananas 3/2");
                return self:TerraformSetResource(hex, g_RESOURCE_BANANAS, true);
            else
                _Debug("Terraform4YieldsToHighYields 3/1 Bananas to Bananas 3/2");
                return self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS);
            end
        elseif hex.FeatureType == g_FEATURE_FOREST then
            -- Grassland hills forest
            if hex.ResourceType == g_RESOURCE_NONE then
                _Debug("Terraform4YieldsToHighYields To Deer 2/3");
                return self:TerraformSetResource(hex, g_RESOURCE_DEER, true);
                -- Is a 1/3 deer on plainhills
            elseif hex.ResourceType == g_RESOURCE_DEER then
                _Debug("Terraform4YieldsToHighYields To Deer 2/3");
                return self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS);
            end
        end
    end
end


function HexMap:TerraformAdd1Prod(hex, canMinusFood, canExtraYield)
    if  g_RESOURCES_STRATEGICS[hex.ResourceType]
        or g_RESOURCES_LUX_LIST[hex.ResourceType]
        or hex:IsWater()
        or hex.FeatureType == g_FEATURE_GEOTHERMAL_FISSURE then
            _Debug("TerraformAdd1Prod - Can't upgrade naturally (excluded lux, strat, water) - Terrain : "..tostring(hex.TerrainType).." Resource :"..tostring(hex.ResourceType).." - Feature : "..tostring(hex.FeatureType))
            return false;
    end
    _Debug("Try TerraformAdd1Prod on ", hex:PrintXY(), " ", hex.TerrainType, " ", hex.FeatureType, " ", hex.ResourceType)
    if hex.ResourceType ~= g_RESOURCE_NONE then
        if hex.ResourceType == g_RESOURCE_MAIZE or hex.ResourceType == g_RESOURCE_COPPER then
            self:TerraformSetResource(hex, g_RESOURCE_NONE, false);
        elseif hex.ResourceType == g_RESOURCE_STONE and hex.TerrainType == g_TERRAIN_TYPE_GRASS then
            return self:TerraformToHill(hex, false);
        elseif canMinusFood and hex.ResourceType == g_RESOURCE_CATTLE or hex.ResourceType == g_RESOURCE_WHEAT or hex.ResourceType == g_RESOURCE_RICE then
            self:TerraformSetResource(hex, g_RESOURCE_NONE, false);
            return self:TerraformAdd1ProdEmptyHex(hex, false); 
        elseif hex.Food + hex.Prod == 3 and g_RESOURCES_BONUS_LIST[hex.ResourceType] then
            return self:TerraformTo22Yields(hex, true);
        else
            return false;
        end
    end
    if hex.FeatureType ~= g_FEATURE_NONE then
        return self:TerraformAdd1ProdOnFeatureHex(hex, canMinusFood, canExtraYield)
    else
        return self:TerraformAdd1ProdEmptyHex(hex, canMinusFood);
    end
    return false;
end

function HexMap:TerraformAdd1ProdEmptyHex(hex, canMinusFood)
    if hex.FeatureType ~= g_FEATURE_NONE or hex.ResourceType ~= g_RESOURCE_NONE then
        return false;
    end
    local rng = TerrainBuilder.GetRandomNumber(100, "Random");
    if rng <= 15 and self:TerraformSetResourceRequirements(hex, g_RESOURCE_DEER) then
        _Debug("TerraformAdd1ProdEmptyHex - Add deer", rng)
        return self:TerraformSetResource(hex, g_RESOURCE_DEER, false);
    elseif IsGrassLand(hex.TerrainType) and rng <= 30 then
        _Debug("TerraformAdd1ProdEmptyHex - Add stone", rng)
        return self:TerraformSetResource(hex, g_RESOURCE_STONE, false);
    elseif IsHill(hex.TerrainType) then
        _Debug("TerraformAdd1ProdEmptyHex - Add forest on hill", rng)
        return self:TerraformSetFeature(hex, g_FEATURE_FOREST, false);
    -- Change flat to hills or forest
    elseif rng <= 33 then
        _Debug("TerraformAdd1ProdEmptyHex - Add forest on flat", rng)
        return self:TerraformSetFeature(hex, g_FEATURE_FOREST, false);
    else
        _Debug("TerraformAdd1ProdEmptyHex - Add hills on flat", rng)
        return self:TerraformToHill(hex, false);
    end
end

function HexMap:TerraformAdd1ProdOnFeatureHex(hex, canMinusFood, canExtraYield)
    if hex.FeatureType == g_FEATURE_NONE or hex.ResourceType ~= g_RESOURCE_NONE then
        return false;
    end
    if canMinusFood and hex.TerrainType == g_TERRAIN_TYPE_GRASS and hex.FeatureType == g_FEATURE_FLOODPLAINS_GRASSLAND and hex.ResourceType == g_RESOURCE_NONE then
        _Debug("TerraformAdd1ProdOnFeatureHex - Flood grass to plain")
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS);
        return self:TerraformSetFeature(hex, g_FEATURE_FLOODPLAINS_PLAINS, true);
        --if hex.ResourceType == g_RESOURCE_NONE then
        --    self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS);
        --    self:TerraformSetFeature(hex, g_FEATURE_FLOODPLAINS_PLAINS, true);
        --    self:TerraformSetResource(hex, g_RESOURCE_WHEAT, false);
        --    return true;
        --else
        --    return false;
        --end
    end
    local rng = TerrainBuilder.GetRandomNumber(100, "Random");
    if IsFlat(hex.TerrainType) and (hex.FeatureType == g_FEATURE_FOREST or hex.FeatureType == g_FEATURE_JUNGLE) then
        _Debug("TerraformAdd1ProdOnFeatureHex - To hill", rng)
        return self:TerraformToHill(hex, false);
    elseif rng <= 20 and (hex.FeatureType == g_FEATURE_FOREST and IsFlat(hex.TerrainType)
            or (hex.FeatureType == g_FEATURE_NONE and IsHill(hex.TerrainType))) then
        _Debug("TerraformAdd1ProdOnFeatureHex - Add deer", rng)
        return self:TerraformSetResource(hex, g_RESOURCE_DEER, false);
    elseif canMinusFood then
        if hex.FeatureType == g_FEATURE_MARSH then
            _Debug("TerraformAdd1ProdOnFeatureHex - Remove marsh, add hill")
            self:TerraformSetFeature(hex, g_FEATURE_NONE, false);
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS);
        elseif hex.FeatureType == g_FEATURE_JUNGLE then
            _Debug("TerraformAdd1ProdOnFeatureHex - Jungle to forest")
            return self:TerraformSetFeature(hex, g_FEATURE_FOREST, true);
        elseif hex.FeatureType == g_FEATURE_FOREST and IsGrassLand(hex.TerrainType) then
            _Debug("TerraformAdd1ProdOnFeatureHex - Grass to plains")
            if hex.TerrainType == g_TERRAIN_TYPE_GRASS then
                return self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS);
            elseif hex.TerrainType == g_TERRAIN_TYPE_GRASS_HILLS then
                return self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS);
            end
        else
            -- if other feature, do nothing
            return false;
        end
        -- 1/3 to 1/4 or 2/2 to 2/3 if allowed
    elseif canExtraYield and hex.FeatureType == g_FEATURE_FOREST and (hex.TerrainType == g_TERRAIN_TYPE_PLAINS_HILLS or hex.TerrainType == g_TERRAIN_TYPE_GRASS_HILLS) then
        return self:TerraformSetResource(hex, g_RESOURCE_DEER, true);
    else
        -- other features
        return false;
    end
end


function HexMap:TerraformRemove1Food(hex, canAddProd)
    -- Do not change fissures
    if hex.FeatureType == g_FEATURE_GEOTHERMAL_FISSURE then
        return false;
    end
    -- Allow to convert food to prod by changing from grass to plains
    _Debug("TerraformRemove1Food enter ", hex:PrintXY(), canAddProd, hex.TerrainType, hex.FeatureType, hex.ResourceType)
    if canAddProd and IsGrassLand(hex.TerrainType) and hex.ResourceType == g_RESOURCE_NONE and (hex.FeatureType == g_FEATURE_FOREST or hex.FeatureType == g_FEATURE_NONE) then
        _Debug("TerraformRemove1Food Grass to plains")
        if hex.TerrainType == g_TERRAIN_TYPE_GRASS then
            return self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS);
        elseif hex.TerrainType == g_TERRAIN_TYPE_GRASS_HILLS then
            return self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS);
        end
    end
    -- Try to remove marsh
    if hex.FeatureType == g_FEATURE_MARSH then
        return self:TerraformSetFeature(hex, g_FEATURE_NONE, false);
    end
    -- Remove bonus resources giving food
    if hex.ResourceType == g_RESOURCE_CATTLE
        or hex.ResourceType == g_RESOURCE_SHEEP
        or hex.ResourceType == g_RESOURCE_RICE
        or hex.ResourceType == g_RESOURCE_WHEAT
        or hex.ResourceType == g_RESOURCE_BANANAS then
        _Debug("TerraformRemove1Food Removed ressource ", hex.ResourceType)
        return self:TerraformSetResource(hex, g_RESOURCE_NONE, false);
    end
    -- Remove features giving food
    if hex.FeatureType == g_FEATURE_JUNGLE then
        return self:TerraformSetFeature(hex, g_FEATURE_NONE, false);
    end
    -- Floodplains Grass to plains
    if canAddProd and hex.TerrainType == g_TERRAIN_TYPE_GRASS and hex.FeatureType == g_FEATURE_FLOODPLAINS_GRASSLAND and hex.ResourceType == g_RESOURCE_NONE then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS);
        return self:TerraformSetFeature(hex, g_FEATURE_FLOODPLAINS_PLAINS, true);
    end
    if IsGrassLand(hex.TerrainType) and hex.ResourceType == g_RESOURCE_NONE then
        -- 2/2 Grass to 1/2 
        if hex.Prod == 2 then
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS);
            return self:TerraformSetFeature(hex, g_FEATURE_NONE, false);  
        elseif hex.Prod == 1 then
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS);
            return self:TerraformSetFeature(hex, g_FEATURE_NONE, false);
        end
    end
    return false;
end


function HexMap:TerraformRemove1Prod(hex, canAddFood)
     -- Do not change fissures
    if hex.FeatureType == g_FEATURE_GEOTHERMAL_FISSURE then
        return false;
    end
    -- Allow to convert prod to food by changing from plains to grass
    if canAddFood then
        if hex.ResourceType == g_RESOURCE_NONE and (hex.FeatureType == g_FEATURE_FOREST or hex.FeatureType == g_FEATURE_NONE) then
            if hex.TerrainType == g_TERRAIN_TYPE_PLAINS then
                return self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS);
            elseif hex.TerrainType == g_TERRAIN_TYPE_PLAINS_HILLS then
                return self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS);
            end
        end
    end
    -- Remove bonus resources giving prod
    if hex.ResourceType == g_RESOURCE_DEER
        or hex.ResourceType == g_RESOURCE_STONE then
        return self:TerraformSetResource(hex, g_RESOURCE_NONE);
    end
    -- Remove forest
    if hex.FeatureType == g_FEATURE_FOREST then
        return self:TerraformSetFeature(hex, g_FEATURE_NONE);
    end
    if hex.ResourceType == g_RESOURCE_NONE and hex.FeatureType == g_FEATURE_JUNGLE then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS);     
        return self:TerraformSetFeature(hex, g_FEATURE_NONE)
    end
    -- Floodplains plain to Grass
    if canAddFood and hex.TerrainType == g_TERRAIN_TYPE_PLAINS and hex.FeatureType == g_FEATURE_FLOODPLAINS_PLAINS and hex.ResourceType == g_RESOURCE_NONE then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS);
        return self:TerraformSetFeature(hex, g_FEATURE_FLOODPLAINS_GRASSLAND, true);
    end
    -- Remove hills last resort (surely not needed)
    if hex.TerrainType == g_TERRAIN_TYPE_PLAINS_HILLS then
        return self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS);
    elseif hex.TerrainType == g_TERRAIN_TYPE_GRASS_HILLS then
        return self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS);
    end

    return false;
end


function HexMap:TerraformTo22YieldsNoResource(hex)
    if hex.TerrainType == g_TERRAIN_TYPE_GRASS then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS);
        self:TerraformSetFeature(hex, g_FEATURE_FOREST, false);
        _Debug("TerraformTo4Yields "..hex:PrintXY().." to 2/2 Grass Hill Forest");
    elseif hex.TerrainType == g_TERRAIN_TYPE_GRASS_HILLS then
        self:TerraformSetFeature(hex, g_FEATURE_FOREST, false);
        _Debug("TerraformTo4Yields "..hex:PrintXY().." to 2/2 Grass Hill Forest");
    elseif hex.TerrainType == g_TERRAIN_TYPE_PLAINS then
        if self:CanHaveJungle(hex) then
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS);
            self:TerraformSetFeature(hex, g_FEATURE_JUNGLE, false);
            _Debug("TerraformTo4Yields "..hex:PrintXY().." to 2/2 Plain Hill Jungle");
        else
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS);
            self:TerraformSetFeature(hex, g_FEATURE_FOREST, false);
            _Debug("TerraformTo4Yields "..hex:PrintXY().." to 2/2 Grass Hill Forest");
        end
    elseif hex.TerrainType == g_TERRAIN_TYPE_PLAINS_HILLS then
        if self:CanHaveJungle(hex) then
            self:TerraformSetFeature(hex, g_FEATURE_JUNGLE, false);
            _Debug("TerraformTo4Yields "..hex:PrintXY().." to 2/2 Plain Hill Jungle");
        else
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS);
            self:TerraformSetFeature(hex, g_FEATURE_FOREST, false);
            _Debug("TerraformTo4Yields "..hex:PrintXY().." to 2/2 Grass Hill Forest");
        end
    end
    hex:UpdateYields();
    _Debug("Terraformed to 2/2 "..hex:PrintXY())
    return true;
end

function HexMap:TerraformToStandardHighFoodYields(hex, cleanTile)
    if (cleanTile) then
        self:TerraformSetFeature(hex, g_FEATURE_NONE, true);
        self:TerraformSetResource(hex, g_RESOURCE_NONE, true);
    end
   if IsPlainLand(hex.TerrainType) and (hex.FeatureType == g_FEATURE_NONE or hex.FeatureType == g_FEATURE_JUNGLE) then
        if hex.ResourceType == g_RESOURCE_NONE and hex.FeatureType == g_FEATURE_NONE and self:CanHaveJungle(hex) then
            _Debug("TerraformToStandardHighFoodYields - empty plain to 3/1 Banana")
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS);
            self:TerraformSetFeature(hex, g_FEATURE_JUNGLE, true);
            self:TerraformSetResource(hex, g_RESOURCE_BANANAS, true);
            return true;
        elseif hex.FeatureType == g_FEATURE_JUNGLE and hex.ResourceType == g_RESOURCE_NONE then
            _Debug("TerraformToStandardHighFoodYields - Add Banana to jungle")
            self:TerraformSetResource(hex, g_RESOURCE_BANANAS, true);
            return true;
        elseif hex.FeatureType == g_FEATURE_NONE then
            if IsHill(hex.TerrainType) then
                _Debug("TerraformToStandardHighFoodYields - Default grass to 3/1 Sheep");
                self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS)
                self:TerraformSetResource(hex, g_RESOURCE_SHEEP, true);
            else
                _Debug("TerraformToStandardHighFoodYields - Default grass to 4/0 Rice");
                self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS)
                self:TerraformSetFeature(hex, g_FEATURE_MARSH, true);
                self:TerraformSetResource(hex, g_RESOURCE_RICE, true);
            end
            return true;
        end
    elseif IsGrassLand(hex.TerrainType) and (hex.FeatureType == g_FEATURE_NONE or hex.FeatureType == g_FEATURE_MARSH) then
       if hex.ResourceType == g_RESOURCE_RICE and hex.FeatureType == g_FEATURE_NONE then
           _Debug("TerraformToStandardHighFoodYields - 3/0 Rice to 4/0 Rice Marsh")
           self:TerraformSetFeature(hex, g_FEATURE_MARSH, true);
           return true;
       elseif hex.FeatureType == g_FEATURE_MARSH and hex.ResourceType == g_RESOURCE_NONE then
           _Debug("TerraformToStandardHighFoodYields - 3/0 Marsh to 4/0 Rice Marsh");
           self:TerraformSetResource(hex, g_RESOURCE_RICE, true);
           return true;
       elseif hex.FeatureType == g_FEATURE_NONE then
           if IsHill(hex.TerrainType) then
               _Debug("TerraformToStandardHighFoodYields - Default grass to 3/1 Sheep");
               self:TerraformSetResource(hex, g_RESOURCE_SHEEP, true);
           else
               _Debug("TerraformToStandardHighFoodYields - Default grass to 4/0 Rice");
               self:TerraformSetFeature(hex, g_FEATURE_MARSH, true);
               self:TerraformSetResource(hex, g_RESOURCE_RICE, true);
           end
           return true;
       end
    elseif IsTundraLand(hex.TerrainType) then
       if hex.FeatureType == g_FEATURE_NONE then
           _Debug("TerraformToStandardHighFoodYields - Tundra added Sheep");
           self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_TUNDRA_HILLS);
           self:TerraformSetResource(hex, g_RESOURCE_SHEEP, true);
           return true;
       end
    end
    hex:UpdateYields();
    _Debug("TerraformToStandardHighFoodYields "..hex:PrintXY());
    return false;
end


function HexMap:AddRandomLux(hex)
    local listPossibleLux = self.LuxTable[hex.IdContinent];
    listPossibleLux = GetShuffledCopyOfTable(listPossibleLux)
    for _, lux in pairs(listPossibleLux) do
        if self:TerraformSetResource(hex, lux, false) then
            return true;
        end
    end
    return false;
end


function HexMap:TerraformToFlat(hex, cleanTile)
    if (cleanTile) then
        self:TerraformSetFeature(hex, g_FEATURE_NONE, true);
        self:TerraformSetResource(hex, g_RESOURCE_NONE);
    end
    if hex.TerrainType == g_TERRAIN_TYPE_GRASS_HILLS or hex.TerrainType == g_TERRAIN_TYPE_GRASS_MOUNTAIN then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS)
    elseif hex.TerrainType == g_TERRAIN_TYPE_PLAINS_HILLS or hex.TerrainType == g_TERRAIN_TYPE_PLAINS_MOUNTAIN then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS)
    elseif hex.TerrainType == g_TERRAIN_TYPE_DESERT_HILLS or hex.TerrainType == g_TERRAIN_TYPE_DESERT_MOUNTAIN then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_DESERT)
    elseif hex.TerrainType == g_TERRAIN_TYPE_TUNDRA_HILLS or hex.TerrainType == g_TERRAIN_TYPE_TUNDRA_MOUNTAIN then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_TUNDRA)
    elseif hex.TerrainType == g_TERRAIN_TYPE_SNOW_HILLS or hex.TerrainType == g_TERRAIN_TYPE_SNOW_MOUNTAIN then
        self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_SNOW)
    end
    hex:UpdateYields()
    return true;
end


function HexMap:AddCoastalRiver(hex)
    if hex.IsCoastal == false or hex.IsFreshWater then
        _Debug("addCoastalRiver - hex is not coastal or has fresh water");
        return false;
    end

    local riverID = RiverManager.GetNumRivers();
    _Debug("AddCoastalRiver")
    if riverID == nil then
        _Debug("addCoastalRiver - riverID ", riverID);
       return false;
    end
    local hexNW = self:GetAdjDirectionInMap(hex, DirectionTypes.DIRECTION_NORTHWEST)
    local hexNE = self:GetAdjDirectionInMap(hex, DirectionTypes.DIRECTION_NORTHEAST)
    local hexE = self:GetAdjDirectionInMap(hex, DirectionTypes.DIRECTION_EAST)
    local hexW = self:GetAdjDirectionInMap(hex, DirectionTypes.DIRECTION_WEST)
    local hexSW = self:GetAdjDirectionInMap(hex, DirectionTypes.DIRECTION_SOUTHWEST)
    local hexSE = self:GetAdjDirectionInMap(hex, DirectionTypes.DIRECTION_SOUTHEAST)
    if hexNW == nil or hexNE == nil or hexE == nil or hexW == nil or hexSW == nil or hexSE == nil then
        _Debug("addCoastalRiver - ERROR when getting adjacent tiles");
        return false;
    end

    if (hexSW:IsWater() == false and hexW:IsWater() == false and hexSE:IsWater() == true) then
        _Debug("Gonna put a river on S-W part of tile, flowing S-E");
        TerrainBuilder.SetNEOfRiver(hex.Plot, true, FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST, riverID);
        return true;
     end

     if (hexSW:IsWater() == false and hexSE:IsWater() == false and hexW:IsWater() == true) then
        _Debug("Gonna put a river on S-W part of tile, flowing N-W");
        TerrainBuilder.SetNEOfRiver(hex.Plot, true, FlowDirectionTypes.FLOWDIRECTION_NORTHWEST, riverID);
        return true;
     end

     if (hexNW:IsWater() == false and hexW:IsWater() == false and hexSW:IsWater() == true) then
        _Debug("Gonna put a river on W part of tile, flowing S");
        TerrainBuilder.SetWOfRiver(hexW.Plot, true, FlowDirectionTypes.FLOWDIRECTION_SOUTH, riverID);
        return true;
     end

     if (hexSW:IsWater() == false and hexW:IsWater() == false and hexNW:IsWater() == true) then
        _Debug("Gonna put a river on W part of tile, flowing N");
        TerrainBuilder.SetWOfRiver(hexW.Plot, true, FlowDirectionTypes.FLOWDIRECTION_NORTH, riverID);
        return true;
     end


     if (hexNW:IsWater() == false and hexW:IsWater() == false and hexNE:IsWater() == true) then
        _Debug("Gonna put a river on N-W part of tile, flowing N-E");
        TerrainBuilder.SetNWOfRiver(hexNW.Plot, true, FlowDirectionTypes.FLOWDIRECTION_NORTHEAST, riverID);
        return true;
     end

     if (hexNW:IsWater() == false and hexNE:IsWater() == false and hexW:IsWater() == true) then
        _Debug("Gonna put a river on N-W part of tile, flowing S-W");
        TerrainBuilder.SetNWOfRiver(hexNW.Plot, true, FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST, riverID);
        return true;
     end

     if (hexNE:IsWater() == false and hexNW:IsWater() == false and hexE:IsWater() == true) then
        _Debug("Gonna put a river on N-E part of tile, flowing S-E");
        TerrainBuilder.SetNEOfRiver(hexNE.Plot, true, FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST, riverID);
        return true;
     end

     if (hexNE:IsWater() == false and hexE:IsWater() == false and hexW:IsWater() == true) then
        _Debug("Gonna put a river on N-E part of tile, flowing N-W");
        TerrainBuilder.SetNEOfRiver(hexNE.Plot, true, FlowDirectionTypes.FLOWDIRECTION_NORTHWEST, riverID);
        return true;
     end

     if (hexNE:IsWater() == false and hexE:IsWater() == false and hexSE:IsWater() == true) then
        _Debug("Gonna put a river on E part of tile, flowing S");
        TerrainBuilder.SetWOfRiver(hex.Plot, true, FlowDirectionTypes.FLOWDIRECTION_SOUTH, riverID);
        return true;
     end

     if (hexSE:IsWater() == false and hexE:IsWater() == false and hexNE:IsWater() == true) then
        _Debug("Gonna put a river on E part of tile, flowing S");
        TerrainBuilder.SetWOfRiver(hex.Plot, true, FlowDirectionTypes.FLOWDIRECTION_NORTH, riverID);
        return true;
     end

     if (hexSE:IsWater() == false and hexSW:IsWater() == false and hexE:IsWater() == true) then
        _Debug("Gonna put a river on S-E part of tile, flowing N-E");
        TerrainBuilder.SetNWOfRiver(hex.Plot, true, FlowDirectionTypes.FLOWDIRECTION_NORTHEAST, riverID);
        return true;
     end

     if (hexSE:IsWater() == false and hexE:IsWater() == false and hexSW:IsWater() == true) then
        _Debug("Gonna put a river on S-E part of tile, flowing S-W");
        TerrainBuilder.SetNWOfRiver(hex.Plot, true, FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST, riverID);
        return true;
     end
     _Debug("Could not add river !!");
     return false;
end

function HexMap:GlobalMountainsTerraform()
    local allMont = {}
    for y = 0, self.height - 1 do
        for x = 0, self.width - 1 do
            local hex = self:GetHexInMap(x, y);
            if hex ~= nil and hex:IsMountain() then
                if hex.IsCoastal then
                    -- Clear mountains around coastal volcano (can't terraform volcanoes)
                    if hex.FeatureType == g_FEATURE_VOLCANO then
                        local ring1 = hex.AllRing6Map[1];
                        for _, h in pairs(ring1) do
                            if h:IsMountain() and h.FeatureType ~= g_FEATURE_VOLCANO then
                                self:TerraformMountainToHill(h);
                            end
                        end
                    else
                        -- Clear coastal mountain to hill
                        self:TerraformMountainToHill(hex);
                    end
                elseif hex.FeatureType ~= g_FEATURE_VOLCANO  then 
                    -- Clear all mountains adjacents to lakes and store them in table
                    local ring1 = hex.AllRing6Map[1];
                    local impassableRing1 = 0
                    local mountainClusterSize = hex.Plot:GetArea():GetPlotCount()
                    for _, r1 in pairs(ring1) do
                        if r1.Plot:IsLake() then
                            self:TerraformMountainToHill(hex)
                        else 
                            impassableRing1 = impassableRing1 + 1
                        end
                    end
                    local rng = TerrainBuilder.GetRandomNumber(100, "Random");
                    -- For huge clusters, keep a part of rng so it doesnt disappear completely
                    local maxRng = math.min(mountainClusterSize * 2, 70)
                    maxRng = math.max(maxRng, 25)
                    if mountainClusterSize > 8 and rng < maxRng then
                        self:TerraformMountainToHill(hex)
                        local yieldRng =  TerrainBuilder.GetRandomNumber(100, "Random");
                        if yieldRng < 10 then
                            self:TerraformTo22Yields(hex, true) 
                        elseif yieldRng < 20 then
                            self:TerraformAdd1Food(hex)
                        elseif yieldRng < 30 then
                            self:TerraformAdd1Prod(hex)
                        elseif yieldRng < 55 then
                            self:TerraformToFlat(hex, true) 
                        end
                    end
                end
            end
        end
    end
end

function HexMap:RemoveVolcano(hex)
    if (hex:IsMountain() == true and hex.FeatureType == g_FEATURE_VOLCANO) then
        self:TerraformSetFeature(hex, g_FEATURE_NONE, true);
        if hex.TerrainType == g_TERRAIN_TYPE_DESERT_MOUNTAIN then
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_DESERT_HILLS)
        elseif hex.TerrainType == g_TERRAIN_TYPE_GRASS_MOUNTAIN  then
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_GRASS_HILLS)
        elseif hex.TerrainType == g_TERRAIN_TYPE_PLAINS_MOUNTAIN  then
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS_HILLS)
        elseif hex.TerrainType == g_TERRAIN_TYPE_SNOW_MOUNTAIN  then
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_SNOW_HILLS)
        elseif hex.TerrainType == g_TERRAIN_TYPE_TUNDRA_MOUNTAIN  then
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_TUNDRA_HILLS)
        end
        _Debug("Removed volcano"..tostring(hex.x).." "..tostring(hex.y));
    end
    hex:UpdateYields()
end

function HexMap:CleanGlobalHighYieldsOnFresh()
    _Debug("CleanGlobalHighYieldsOnFresh entry")
    for y = 0, self.height - 1 do
        for x = 0, self.width - 1 do
            local hex = self:GetHexInMap(x, y);
            self:CleanHighYieldsOnFresh(hex)
        end
    end
end

function HexMap:CleanHighYieldsOnFresh(hex)
    local nextToWater = hex.IsFreshWater or hex.IsCoastal
    if hex ~= nil and hex.Food >= 4 and nextToWater and g_RESOURCES_HIGHFOOD[hex.ResourceType] then
        _Debug("CleanHighYieldsOnFresh found lux 4+ food in ", hex:PrintXY())
        if hex.TerrainType == g_TERRAIN_TYPE_GRASS then
            self:TerraformSetTerrain(hex, g_TERRAIN_TYPE_PLAINS);
            _Debug("CleanHighYieldsOnFresh lux 4+ food to plains ", hex:PrintXY())
            if hex:IsFloodplains(true) then
                _Debug("CleanHighYieldsOnFresh changed on flood plains")
                self:TerraformSetFeature(hex, g_FEATURE_FLOODPLAINS_PLAINS, true);
            elseif hex.FeatureType == g_FEATURE_MARSH then -- Sugar on marsh => 3/1
                self:TerraformSetFeature(hex, g_FEATURE_NONE, false);
            end
            _Debug("CleanHighYieldsOnFresh done for hex ", hex:PrintXY())
        elseif hex.TerrainType == g_TERRAIN_TYPE_DESERT then
            self:TerraformSetResource(hex, g_RESOURCE_NONE, false);
        end
        --
    elseif hex ~= nil and hex.Prod >= 3 and nextToWater and g_RESOURCES_HIGHPROD[hex.ResourceType] then
        _Debug("CleanHighYieldsOnFresh found 3+ prod settle on ", hex:PrintXY());
        self:TerraformToFlat(hex, false);
        _Debug("CleanHighYieldsOnFresh done for hex ", hex:PrintXY())
    end
end

---------------------------------------
-- DEBUGGING prints
---------------------------------------
-- DEBUGGING - map for every resources
function HexMap:PrintMaps()
    -- Loop through every resources index
    for idRes, t in pairs(self.mapResources) do
        local mapResourceIndex = self.mapResources[idRes]
        -- Through all resources, then through all hexes
        for _, hex in ipairs(mapResourceIndex) do
            _Debug("Index resource = "..tostring(idRes).." at plot ("..tostring(hex.x)..", "..tostring(hex.y)..")")
        end
    end
end
-- DEBUGGING - Lux - can use any resource list
function HexMap:PrintMapsLux()
    -- Loop through every resources index - only print if they are luxes
    for idRes, t in pairs(self.mapResources) do
        if g_RESOURCES_LUX_LIST[idRes] ~= nil then
            local mapResourceIndex = self.mapResources[idRes]
            -- Through all resources, then through all hexes
            for _, hex in ipairs(mapResourceIndex) do
                _Debug("Index resource = "..tostring(idRes).." at plot ("..tostring(hex.x)..", "..tostring(hex.y)..")")
            end
        end
    end
end

-- DEBUGGING - Print Map in logs with centroid id
function HexMap:PrintHexMap()
    local scanMap = {}
    for y = 0, self.height - 1 do
        local logX = ""
        if y % 2 == 1 then
            logX = " "
        end
        for x = 0, self.width - 1 do
            local hex = self.map[y][x]
            logX = logX..hex:PrintCentroidIdMap().." ";
        end
        scanMap[self.height - y] = logX
    end
    local skeys = {}
    for k in pairs(scanMap) do
        table.insert(skeys, k)
    end
    table.sort(skeys)
    for _,v in ipairs(skeys) do
        _Debug(v, scanMap[v])
    end
end

function HexMap:PrintHexSpawnableMap()
    local scanMap = {}
    for y = 0, self.height - 1 do
        local logX = ""
        if y % 2 == 1 then
            logX = " "
        end
        for x = 0, self.width - 1 do
            local hex = self.map[y][x]
            if hex:IsWater() then
                logX = logX.."~~".." ";
            else
                if hex.IsMajorSpawnable then
                    logX = logX.."11".." ";
                else
                    logX = logX.."00".." ";
                end
            end

        end
        scanMap[self.height - y] = logX
    end
    local skeys = {}
    for k in pairs(scanMap) do
        table.insert(skeys, k)
    end
    table.sort(skeys)
    for _,v in ipairs(skeys) do
        _Debug(v, scanMap[v])
    end
end

function HexMap:PrintHexPeninsuleMap()
    local scanMap = {}
    for y = 0, self.height - 1 do
        local logX = ""
        if y % 2 == 1 then
            logX = " "
        end
        for x = 0, self.width - 1 do
            local hex = self.map[y][x]
            if hex:IsWater() then
                logX = logX.."~~".." ";
            else
                local printScore = ""
                local score = hex.PeninsulaScore
                if score == 0 then
                    score = "00"
                elseif score == 100 then
                    score = "99"
                else
                    score = tostring(hex.PeninsulaScore)
                end
                logX = logX..score.." ";
            end

        end
        scanMap[self.height - y] = logX
    end
    local skeys = {}
    for k in pairs(scanMap) do
        table.insert(skeys, k)
    end
    table.sort(skeys)
    for _,v in ipairs(skeys) do
        _Debug(v, scanMap[v])
    end
end

-- TEMP DEBUG print map for logs
function Hex:PrintCentroidIdMap()
    local printed = ""
    if self:IsWater() == true then
        if self.isCentroid == true then
            return "[~~]"
        end
        return "~~"
    end
    if self.Centroid == nil then
        return "00"
    end
    local idCentroid = self.Centroid.id
    printed = tostring(idCentroid)
    if idCentroid ~= nil and idCentroid < 10 then
        printed = "0"..tostring(idCentroid)
    end
    --if self.isCentroid == true then
    --    printed = "["..printed.."]"
    --end
    return printed
end

-- Return the count and all the hexes in the map that are not water and not snow
function HexMap:GetNonExtremCostalTiles()
    local landTiles = {}
    local countLandtiles = 0
    for y = 0, self.height - 1 do
        for x = 0, self.width - 1 do
            local hex = self.map[y][x]
            if hex:IsWater() == false and hex:IsSnowLand() == false and hex.CostalScore == 1 then
                countLandtiles = countLandtiles + 1
                table.insert(landTiles, hex)
            end
        end
    end
    return countLandtiles, landTiles;
end

function HexMap:IsHexRing2FromCoast(hex)
    if hex.IsCoastal == false then
        local ring1 = hex.AllRing6Map[1];
        for _, h in pairs(ring1) do
            if h.IsCoastal then
                return true
            end
        end
    end
    return false
end

-- Return the count and all the hexes in the map that are not water and not snow
function HexMap:GetLandHexList()
    local landTiles = {}
    local countLandtiles = 0
    for y = 0, self.height - 1 do
        for x = 0, self.width - 1 do
            local hex = self.map[y][x]
            if hex:IsWater() == false and hex:IsSnowLand() == false then
                countLandtiles = countLandtiles + 1
                table.insert(landTiles, hex)
            end
        end
    end
    return countLandtiles, landTiles;
end

-- Used for city states, get any non water tiles and test if meet requirements
function HexMap:GetAnyMinorSpawnablesTiles()
    local valid = {}
    for y = 0, self.height - 1 do
        for x = 0, self.width - 1 do
            local hex = self:GetHexInMap(x, y)
            local isTerraMap = self.mapScript == MapScripts.MAP_TERRA;
            local terraCondition = isTerraMap == false or (isTerraMap and hex.Plot:GetArea():GetID() ~= self.BiggestIsland:GetID())
            if terraCondition and hex:IsImpassable() == false and hex:IsSnowLand() == false and hex.IsMinorSpawnable then
                table.insert(valid, hex)
            end
        end
    end
    return valid;
end

function HexMap:LookForHills(map)
    -- if map nil, check all the tiles in the map
    local mappedHex = {};
    local count = 0;
    if map == nil then
        for y = 0, self.height - 1 do
            for x = 0, self.width - 1 do
                local hex = self:GetHexInMap(x, y)
                if hex:IsHill() then
                    count = count + 1;
                    table.insert(mappedHex, hex);
                end
            end
        end
    else
        for i = 10, #map do
            -- check is Hex
            local hex = map[i]
            if hex:IsHill() then
                count = count + 1;
                table.insert(mappedHex, hex);
            end
        end
    end

    return count, mappedHex
end

function HexMap:IsTeamerValidContinentPlacement(index)
    local tempSpawn = self.tempMajorSpawns[index]
    local continentMapping = {}; -- continents in ring5 of spawns
    local continentSpawnMapping = {}; --continents on spawn
    for _, civSpawn in pairs(tempSpawn) do
        -- civSpawn.Civ== CivilizationAssign, civSpawn.Spawn == Hex, civSpawn.Score == float Score
        local civ = civSpawn.Civ;
        local team = civ.CivilizationTeam;
        local spawn = civSpawn.Spawn;
        continentSpawnMapping[team] = continentSpawnMapping[team] or {}
        if Contains(continentSpawnMapping[team], spawn.IdContinent) == false then
            table.insert(continentSpawnMapping[team], spawn.IdContinent)
        end
        local _, listIdContinentInRange = self:ContinentsInRange(spawn, 4);
        continentMapping[team] = continentMapping[team] or {}
        for _, id in pairs(listIdContinentInRange) do
            if Contains(continentMapping[team], id) == false then
                table.insert(continentMapping[team], id)
            end
        end
    end
    local nbContinentOnSpawnTeam1 = 0;
    local nbContinentOnSpawnTeam2 = 0;
    local nbContinentR5Team1 = 0;
    local nbContinentR5Team2 = 0;
    local fixedIndex = 1;
    local atLeastTwoContinentPerTeam = true
    for team, _ in pairs(continentMapping) do
        local nbContinentR5 = #continentMapping[team];
        local onSpawnNbContinents = #continentSpawnMapping[team];
        if fixedIndex == 1 then
            nbContinentR5Team1 = nbContinentR5;
            nbContinentOnSpawnTeam1 = onSpawnNbContinents;
        elseif fixedIndex == 2 then
            nbContinentR5Team2 = nbContinentR5;
            nbContinentOnSpawnTeam2 = onSpawnNbContinents;
        end
        _Debug("IsTeamerValidContinentPlacement nbContinent for team ", team , " = ", onSpawnNbContinents, " and also considering in ring 5 then ", nbContinentR5)
        fixedIndex = fixedIndex + 1;
    end
    local contDiffOnSpawn = math.abs(nbContinentOnSpawnTeam1 - nbContinentOnSpawnTeam2);
    local contDiffR5= math.abs(nbContinentR5Team1 - nbContinentR5Team2);
    -- To be valid, we need at least 2+ continent reachable and not a 2 continent difference between 2 team if possible

    if (nbContinentOnSpawnTeam1 == 1 or nbContinentOnSpawnTeam2 == 1) then
        atLeastTwoContinentPerTeam = false;
    end
    _Debug("IsTeamerValidContinentPlacement ", atLeastTwoContinentPerTeam, " contDiffOnSpawn = ", contDiffOnSpawn, " contDiffR5 = ", contDiffR5, "Team 1 = ", nbContinentOnSpawnTeam1, "Team 2 = ",nbContinentOnSpawnTeam2, nbContinentR5Team1, nbContinentR5Team2)
    return atLeastTwoContinentPerTeam;
end


function HexMap:GetNumberMajorSpawnable(ignoreTundra)
    local countMajourSpawnable = 0;
    for y = 0, self.height - 1 do
        for x = 0, self.width - 1 do
            local hex = self:GetHexInMap(x, y)
            -- if true, tundra and snow tiles are not considered marjoSpawnable
            local tundraCondition = ignoreTundra == false or (ignoreTundra and IsTundraLand(hex.TerrainType) == false and IsSnowLand(hex.TerrainType) == false)
            if hex.IsMajorSpawnable and tundraCondition then
                countMajourSpawnable = countMajourSpawnable + 1;
            end
        end
    end
    return countMajourSpawnable;
end


----------------------------
-- K-means
-- Centroids data currently stored in HexMap, if multiples centroids and run configs needed,
-- change the methods to return the list of centroids instead of directly change HexMap.centroidsArray
----------------------------
function HexMap:RunKmeans(n, iters)
    iters = iters or 30
    n = n or 16
    _Debug("Start k-means "..tostring(n).." centroids for "..tostring(iters).." iterations. ", os.date("%c"))
    local _, points = self:GetNonExtremCostalTiles()
    local nbLandTiles = 0
    for _, p in pairs(points) do
        nbLandTiles = nbLandTiles + 1
    end
    _Debug("k-means - nbLandTiles = "..tostring(nbLandTiles))
    -- Init centroids for Kmean
    self:InitKmeanCentroids(n, points)
    -- Run interations
	for i = 1, iters do
		self:UpdateCentroids(points)
	end
    self:CentroidGroupby(points)
    self:UpdateCentroidsSortedIndex()

    _Debug("End k-means ", os.date("%c"))
end

function HexMap:CheckHexInCentroid(hex, centroids)
    for _, c in pairs(centroids) do
        if c.x == hex.x and c.y == hex.y then
            return true;
        end
    end
    return false;
end

-- Init n centroids for Kmean clustering using naive sharding sampling
-- https://www.kdnuggets.com/2017/03/naive-sharding-centroid-initialization-method.html
function HexMap:InitKmeanCentroids(n, spawnableHex)
    _Debug("InitKmeanCentroids:")
    for _, hex in pairs(spawnableHex) do
        hex._mean = hex.x + hex.y
    end
    table.sort(spawnableHex, function (c1, c2) return c1._mean < c2._mean end)

    local sample_size = math.floor(#spawnableHex / n)
    local centroids = {}
    for i = 0, n - 1 do
        -- Need to add +1 in because of table index can not be 0
        local index = TerrainBuilder.GetRandomNumber(sample_size, "pick random centroid") + 1;
        local randomHex = spawnableHex[sample_size * i + index]
        _Debug("Analysis kmeans : "..tostring(sample_size * i + index).." and size = "..tostring(#spawnableHex))

        _Debug("Init random at centroid ("..tostring(randomHex.x)..", "..tostring(randomHex.y)..")")
        table.insert(centroids, randomHex)
    end

    -- OUTDATED random centroid selection
    -- local centroids = {}
    -- for i = 1, n do
    --     local randomHex = self:getRandomHex();
    --     local randomHexIsNotLand = true
    --     -- init random centroids anywhere on land to avoid isolated centroids on water
    --     while (randomHexIsNotLand) do
    --         if randomHex:IsWater() == false and self:CheckHexInCentroid(randomHex, centroids) == false then
    --             randomHexIsNotLand = false
    --         else
    --             randomHex = self:getRandomHex();
    --         end
    --     end
    --     local newCentroid = Centroid.new(randomHex.x, randomHex.y, i)
    --     _Debug("Init random at centroid ("..tostring(newCentroid.x)..", "..tostring(newCentroid.y)..")")
    --     table.insert(centroids, randomHex)
    -- end
    self.centroidsArray = centroids
end

-- Mean of hex coord linked to the selected centroid
function HexMap:UpdateCentroids(points)
    self:CentroidGroupby(points);
    self:ClearCentroidsInMap();
	for i, centroid in pairs(self.centroidsArray) do
        if #centroid.HexCluster > 0 then
            local totalX = 0
            local totalY = 0
            for _, h in pairs(centroid.HexCluster) do
                totalX = totalX + h.x
                totalY = totalY + h.y
            end
            local newX = math.floor(totalX / #centroid.HexCluster);
            local newY= math.floor(totalY / #centroid.HexCluster);
            centroid = Centroid:new(newX, newY, i);
            self.centroidsArray[i] = centroid
            -- For display purpose in log
            local correspondingHex = self:GetHexInMap(centroid.x, centroid.y)
            correspondingHex.isCentroid = true
        end
	end
end

-- Group a list of hex to a centroid (in centroidsArray) as index of the g table
function HexMap:CentroidGroupby(points)
	local g = {};
	for _, p in pairs(points) do
		local centroid = p:Closest(self, self.centroidsArray);
		g[centroid] = g[centroid] or {};
        p.Centroid = centroid
		table.insert(g[centroid], p);
	end
    -- put the list directly in Centroid table c.HexCluster = { list of hexes}
    for _, c in pairs(self.centroidsArray) do
        c.HexCluster = g[c] or {}
    end
end

-- Update indexes of centroids, sorting by x value (for display purpose - might remove later)
function HexMap:UpdateCentroidsSortedIndex()
    local new_centroids = self.centroidsArray
    table.sort(new_centroids, function (c1, c2) return c1.x < c2.x end)
    for i = 1, #new_centroids do
        local centroid = new_centroids[i]
        centroid.id = i
        self.centroidsArray[i] = centroid
        local correspondingHex = self:GetHexInMap(centroid.x, centroid.y)
        correspondingHex.isCentroid = true
        _Debug("Updated new Centroid "..tostring(i).." at ("..tostring(centroid.x)..", "..tostring(centroid.y)..")");
    end
end

function HexMap:ClearCentroidsInMap()
    for y = 0, self.height - 1 do
        for x = 0, self.width - 1 do
            local hex = self:GetHexInMap(x, y)
            hex.isCentroid = false
        end
    end
end

-- TODO error management -- param is index
function HexMap:GetHexListInCentroidId(centroidId)
    local centroid = self.centroidsArray[centroidId]
    return centroid.HexCluster;
end

-- TODO error management -- param is Centroid class
function HexMap:GetHexListInCentroid(centroid)
    return centroid.HexCluster;
end

function even(test)
	if (test % 2 == 0) then
	    return 0
	else
    	return 1
    end
end

function HexMap:GetTeamerPositionConfig() 
    if MapConfiguration.GetValue("BBM_Team_Spawn") ~= nil and Is1v1OrTeamerConfig() then
        local Teamers_Config = MapConfiguration.GetValue("BBM_Team_Spawn");
        _Debug("GetTeamerPositionConfig : ", Teamers_Config)
        if Teamers_Config == 1 then
            return TeamerConfigEastVsWest;
        end
    end 
    return TeamerConfigStandard;
end

function HexMap:CheckRTSContinent(idContCheck)
    local continentSetup = self.RTSContinentSetup or {}
    if continentSetup == {} then  
        return false;
    end
    for _, cont in pairs(continentSetup) do
        if cont == idContCheck then
            _Debug("ContinentOccupied")
            return true;
        end
    end
    return false; 
end

function printAllStartYields(hexMap)
    _Debug("PrintAllStartYields")
    local meanFoodR1 = 0;
    local meanProdR1 = 0;
    for _,start in pairs(hexMap.majorSpawns) do
        _Debug("Start "..start:PrintXY())
        local foodR1 = 0;
        local prodR1 = 0;
        local countR1 = 0;
        local ring1 = hexMap:GetHexInRing(start, 1)
        for _, h in pairs(ring1) do
            foodR1 = foodR1 + h.Food;
            prodR1 = prodR1 + h.Prod;
        end
        _Debug("Start "..start:PrintXY().." Food = "..tostring(foodR1).." and Prod = "..tostring(prodR1))
        meanFoodR1 = meanFoodR1 + foodR1;
        meanProdR1 = meanProdR1 + prodR1;
    end
    meanFoodR1 = meanFoodR1 / #hexMap.majorSpawns;
    meanProdR1 = meanProdR1 / #hexMap.majorSpawns;
    _Debug("meanFoodR1 = "..tostring(meanFoodR1));
    _Debug("meanProdR1 = "..tostring(meanProdR1));
end

function BalanceMap(hexMap)
    local iForestCounter = 0;
    local iNearFloodsCounter = 0;
    local iHillsCounter = 0
    local landTiles = {}
    for y = 0, hexMap.height - 1 do
        for x = 0, hexMap.width - 1 do
            local hex = hexMap:GetHexInMap(x, y);
            if hex:IsImpassable() == false and hex.ResourceType == g_RESOURCE_NONE then
                table.insert(landTiles, hex)
            end
        end
    end
    landTiles = GetShuffledCopyOfTable(landTiles)

    local countHills, _ = hexMap:LookForHills();
    local countLandTiles, _ = hexMap:GetLandHexList();
    local hillPercent = countHills / countLandTiles
    print("Hills count : ", countHills, countLandTiles, hillPercent)

    for k, hex in pairs(landTiles) do
        local ring1 = hex.AllRing6Map[1];
        local iForestScore = 0;
        local iHillsScore = 0;
        local iFloodplainsScore = 0;
        for _, h in pairs(ring1) do
            if hex.FeatureType == g_FEATURE_NONE and h.FeatureType == g_FEATURE_FOREST or h.FeatureType == g_FEATURE_JUNGLE then
                iForestScore = iForestScore + 1;
            elseif (hex.FeatureType == g_FEATURE_FOREST or hex.FeatureType == g_FEATURE_JUNGLE) and h:IsFloodplains(true) then
                iFloodplainsScore = iFloodplainsScore + 1;
            elseif h:IsHill() then
                iHillsScore = iHillsScore + 1;
            end
        end 
        local hillsByPeninsulaScore = (hex.TerrainsScore[g_HILLS] * 100 / 126) / (hex.PeninsulaScore / 100)--Total tiles on r6
        local goalHills = math.ceil(countLandTiles * 0.4)
        local underHillsGoal = IsWorldAgeOld() and (countHills + iHillsCounter <= goalHills)
        _Debug(hex:PrintXY(), " iHillScore = ", iHillsScore, " Hex6 = ", hex.TerrainsScore[g_HILLS], " PenScore = ", hex.PeninsulaScore, " %HillsR6 = ", tt, " Hill%Map = ", hillPercent, " Target = ", goalHills, underHillsGoal)
        if hex:IsHill() == false and hex.ResourceType == g_RESOURCE_NONE and (hex.FeatureType == g_FEATURE_NONE or hex.FeatureType == g_FEATURE_FOREST or hex.FeatureType == g_FEATURE_JUNGLE)
            and hillsByPeninsulaScore < hillPercent * 100 - 5 and BalanceMapHills(hexMap, hex, iHillsScore, hillsByPeninsulaScore, underHillsGoal) then
            -- and BalanceMapHills(hexMap, hex, iHillsScore) then
            _Debug("BalanceMapHills done for ", hex:PrintXY())
            iHillsCounter = iHillsCounter + 1;
        end
        if hex.FeatureType == g_FEATURE_NONE and BalanceMapForests(hexMap, hex, iForestScore) then
            iForestCounter = iForestCounter + 1;
        end
        if (hex.FeatureType == g_FEATURE_NONE or hex.FeatureType == g_FEATURE_FOREST or hex.FeatureType == g_FEATURE_JUNGLE) 
            and BalanceNearFloodplainsYields(hexMap, hex, iFloodplainsScore) then
            iNearFloodsCounter = iNearFloodsCounter + 1;
        end
    end

    print("Added "..tostring(iForestCounter).." Forest to the base map.")
    print("Added "..tostring(iHillsCounter).." hills to the base map.")
    print("Changed "..tostring(iNearFloodsCounter).." near floods to add prod.")
end

---------------------------------------
-- MapBalancing
---------------------------------------
function BalanceMapHills(hexMap, hex, iScore, hillsByPeninsulaScore, isUnderHillsGoal)
    -- Check hills
    local percentage = 0;
    if hillsByPeninsulaScore < 20 then  
        if iScore == 0 then
            percentage = 30
        end
    elseif isUnderHillsGoal then
        if iScore == 0 then
            percentage = 30
        elseif iScore == 1 then
            percentage = 50
        elseif iScore == 2 then
            percentage = 10
        elseif iScore == 3 then
            percentage = 5
        else
            percentage = 0
        end
    end
    
    local rng = TerrainBuilder.GetRandomNumber(100, "Terraform hills");
    if rng < percentage then
        if hexMap:TerraformToHill(hex, false) then
            return true;
        end
    end
    return false;
end


function BalanceMapForests(hexMap, hex, iScore)
    -- Check forest
    -- if between 0 and 2 forest add one (randomly) | 0-50% | 1-40% | 2-20% | 3-10%
    -- if more or equal to 3 jungle do not add
    local percentage = 0;
    if iScore == 0 then
        percentage = 40
    elseif iScore == 1 then
        percentage = 15
    elseif iScore == 2 then
        percentage = 10
    elseif iScore == 3 then
        percentage = 5
    else
        percentage = 0
    end

    local rng = TerrainBuilder.GetRandomNumber(100, "Terraform forest");
    if rng < percentage then
        if hexMap:TerraformSetFeature(hex, g_FEATURE_FOREST, false) then
            return true;
        end
    end
    return false;
end

function BalanceNearFloodplainsYields(hexMap, hex, iScore) 
    local percentage = 0;
    if iScore == 1 then
        percentage = 10
    elseif iScore == 2 then
        percentage = 50
    elseif iScore == 3 then
        percentage = 75
    elseif iScore >= 4 then
        percentage = 90
    else
        return false;
    end

    local rng = TerrainBuilder.GetRandomNumber(100, "Add prod");
    if rng < percentage then
        if IsFlat(hex.TerrainType) and hexMap:TerraformToHill(hex, false) then
            -- Chance to add also forest near lots of floods
            if hex.FeatureType == g_FEATURE_NONE and ((iScore >= 4 and rng < 25) or (iScore >= 2 and rng < 10)) then
                _Debug("BalanceNearFloodplainsYields add forest + hills ", hex:PrintXY())
                return hexMap:TerraformSetFeature(hex, g_FEATURE_FOREST, false);
            end
            _Debug("BalanceNearFloodplainsYields add hills ", hex:PrintXY())
            return true;
        end
    end
    return false;
end


-- Main balancing function per civ
-- To avoid turtles to be deleted after the coastal score calc, we check lux before
function InitSpawnBalancing(hexMap, civ)
    local balancing = SpawnBalancing.new(civ.StartingHex, hexMap, civ);
    print("InitSpawnBalancing ", civ.StartingHex)
    balancing:RemoveRing1MountainsOnRiver();
    balancing:TerraformRing6Deserts();
    balancing:CleanSpawnTile();
    balancing:ApplyMinimalCoastalTiles();
    balancing:CheckLuxThreshold();
    balancing:CheckInnerRingHighYieldsThreshold();
    balancing:GaranteedStandardHighFoodInnerRing();
    balancing:ApplyMinimalLandTiles(1, 6);
    balancing:ApplyGaranteedStrategics();
    --balancing:AddHighYieldFromStandard();
    balancing:CheckMinimumWorkable();
    balancing:HillsMinimumCheck();
    return balancing;
end

function Contains(table1, value)
    if table1 == nil then
        return false;
    end
    for _, v in pairs(table1) do
        if v == value then
          return true
        end
      end
    return false
end

function AddToTable(table1, tableToInsert)
    for i, v in pairs(tableToInsert) do
        table.insert(table1, v)
    end
end

function RemoveFromTable(table1, valueToRemove)
    for i, v in pairs(table1) do
        if v == valueToRemove then
            table1[i] = nil  -- Set the value at index i to nil to remove it
            return true;
        end
    end
    return false;
end