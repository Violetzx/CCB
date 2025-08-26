------------------------------------------------------------------------------
--	FILE:	 Pangaea.lua
--	AUTHOR:  
--	PURPOSE: Base game script - Simulates a Pan-Earth Supercontinent.
------------------------------------------------------------------------------
--	Copyright (c) 2014 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------

include "MapEnums"
include "DW_MapUtilities"
include "BBS_MountainsCliffs"
include "RiversLakes"
include "BBS_TerrainGenerator"
include "TerrainGenerator"
include "BBS_NaturalWonderGenerator"
include "BBS_ResourceGenerator"
include "CoastalLowlands"
include "AssignStartingPlots"
include "BBM_AssignStartingPlots"

include "BBM_MapUtils"
include "BBM_FeatureGenerator"

local g_iW, g_iH;
local g_iFlags = {};
local g_continentsFrac = nil;
local g_iNumTotalLandTiles = 0;
local featureGen = nil;
local world_age_new = 5;
local world_age_normal = 3;
local world_age_old = 2;

-------------------------------------------------------------------------------
function BBS_Assign(args)
	print("BBS_Assign: Injecting Spawn Placement")
	local start_plot_database = {};

	start_plot_database = BBM_AssignStartingPlots.Create(args)

	return start_plot_database
end
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Ice just wastes space on the map so limit it to 2 tiles from the map edges
function LimitExistingIce()
    print("Limiting ice to 2 tiles from map edges");
    
    local g_iW, g_iH = Map.GetGridSize();
    local MAX_ICE_DISTANCE = 2; -- Maximum distance from edge to allow ice
    
    -- Process center rows to remove any ice beyond our limit
    for y = MAX_ICE_DISTANCE, g_iH - 1 - MAX_ICE_DISTANCE do
        for x = 0, g_iW - 1 do
            local plot = Map.GetPlotByIndex(y * g_iW + x);
            if plot ~= nil and plot:GetFeatureType() == g_FEATURE_ICE then
                -- Remove ice that's too far from map edges
                TerrainBuilder.SetFeatureType(plot, -1);
                
                -- If this was ocean terrain under the ice, make sure it stays as ocean
                if plot:IsWater() then
                    TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_OCEAN);
                end
            end
        end
    end
end
-------------------------------------------------------------------------------
function GenerateMap()
	print("Generating Pangea Map");

	local pPlot;

	-- Set globals
	g_iW, g_iH = Map.GetGridSize();
	g_iFlags = TerrainBuilder.GetFractalFlags();
	local temperature = MapConfiguration.GetValue("temperature"); -- Default setting is Temperate.
	if temperature == 4 then
		temperature  =  1 + TerrainBuilder.GetRandomNumber(3, "Random Temperature- Lua");
	end

	--	local world_age
	local world_age = MapConfiguration.GetValue("world_age");
	if (world_age == 1) then
		world_age = world_age_new;
	elseif (world_age == 2) then
		world_age = world_age_normal;
	elseif (world_age == 3) then
		world_age = world_age_old;
	else
		world_age = 2 + TerrainBuilder.GetRandomNumber(4, "Random World Age - Lua");
	end

	plotTypes = GeneratePlotTypes(world_age);
	local BBS_temp = false;
	if (GameConfiguration.GetValue("BBStemp") ~= nil) then
		if (GameConfiguration.GetValue("BBStemp") == true) then
			BBS_temp = true;
			print ("BBS Temperature: On");
			terrainTypes = BBS_GenerateTerrainTypes(plotTypes, g_iW, g_iH, g_iFlags, true, temperature);
			else
			BBS_temp = false;
			terrainTypes = GenerateTerrainTypes(plotTypes, g_iW, g_iH, g_iFlags, true, temperature);
		end
		else
		BBS_temp = false;
		terrainTypes = GenerateTerrainTypes(plotTypes, g_iW, g_iH, g_iFlags, true, temperature);
	end
	ApplyBaseTerrain(plotTypes, terrainTypes, g_iW, g_iH);
	
	-- -- optimize terrain to limit desert
    OptimizeDesert();

	-- -- normalize settleable tiles to reach ~2700
	NormalizeSettleableTiles();

	AreaBuilder.Recalculate();
	TerrainBuilder.AnalyzeChokepoints();
	TerrainBuilder.StampContinents();

	local iContinentBoundaryPlots = GetContinentBoundaryPlotCount(g_iW, g_iH);
	local biggest_area = Areas.FindBiggestArea(false);
	print("After Adding Hills: ", biggest_area:GetPlotCount());

	if (MapConfiguration.GetValue("BBSRidge") ~= 1) then
		print("Adding Ridges");
		AddTerrainFromContinents(plotTypes, terrainTypes, world_age, g_iW, g_iH, iContinentBoundaryPlots);
	end

	AreaBuilder.Recalculate();

	-- set a local parameter for more rivers without affecting rainforest and woods
	local riverArgs = {rainfall = 3}; -- Higher rainfall = more rivers (values 1-4)
	-- River generation is affected by plot types, originating from highlands and preferring to traverse lowlands.
	AddRivers();

	-- Lakes would interfere with rivers, causing them to stop and not reach the ocean, if placed any sooner.
	local numLargeLakes = math.ceil(GameInfo.Maps[Map.GetMapSize()].Continents * 1.5);
	AddLakes(numLargeLakes);

	-- get rid of snow
	ReduceSnowCoverage();

	AddFeatures();
	TerrainBuilder.AnalyzeChokepoints();

	print("Adding cliffs");
	AddCliffs(plotTypes, terrainTypes);

	local args = {
		numberToPlace = GameInfo.Maps[Map.GetMapSize()].NumNaturalWonders,
	};

	local nwGen = BBS_NaturalWonderGenerator.Create(args);

	AddFeaturesFromContinents();
	MarkCoastalLowlands();

	-- extend coast tiles BEFORE resource generation
    ExtendCoastTiles();

	resourcesConfig = MapConfiguration.GetValue("resources");
	local startConfig = MapConfiguration.GetValue("start");-- Get the start config
	local args = {
		iWaterLux = 2,
		resources = resourcesConfig,
		START_CONFIG = startConfig,
	}
	local resGen = BBS_ResourceGenerator.Create(args);

	if (MapConfiguration.GetValue("BBSRidge") == 1) then
		AddVolcanos(plotTypes,world_age,g_iW, g_iH)
	end

	print("Creating start plot database.");
	-- START_MIN_Y and START_MAX_Y is the percent of the map ignored for major civs' starting positions.
	local args = {
		MIN_MAJOR_CIV_FERTILITY = 300,
		MIN_MINOR_CIV_FERTILITY = 5,
		MIN_BARBARIAN_FERTILITY = 1,
		START_MIN_Y = 15,
		START_MAX_Y = 15,
		START_CONFIG = startConfig,
		LAND = true,
	};
	local start_plot_database = BBS_Assign(args)

	local GoodyGen = AddGoodiesBBM(g_iW, g_iH);
	
	AreaBuilder.Recalculate();
	TerrainBuilder.AnalyzeChokepoints();
    
	-- write map stats to the log
    local mapStats = PrintMapStatistics();

    -- Add this line to validate continents
    local continentData = ValidateContinents();	
end

-------------------------------------------------------------------------------
function GeneratePlotTypes(world_age)
	print("Generating Plot Types");
	local plotTypes = {};

	local sea_level_low = 36; -- 53
	local sea_level_normal = 37;  -- 58
	local sea_level_high = 40;  -- 63

	local grain_amount = 3;
	local adjust_plates = 1.3;
	local shift_plot_types = true;
	local tectonic_islands = true;
	local hills_ridge_flags = g_iFlags;
	local peaks_ridge_flags = g_iFlags;
	local has_center_rift = false;

	--	local sea_level
    local sea_level = MapConfiguration.GetValue("sea_level");
	local water_percent;
	if sea_level == 1 then -- Low Sea Level
		water_percent = sea_level_low
	elseif sea_level == 2 then -- Normal Sea Level
		water_percent =sea_level_normal
	elseif sea_level == 3 then -- High Sea Level
		water_percent = sea_level_high
	else
		water_percent = TerrainBuilder.GetRandomNumber(sea_level_high - sea_level_low, "Random Sea Level - Lua") + sea_level_low + 1;
	end

	-- Generate continental fractal layer and examine the largest landmass. Reject
	-- the result until the largest landmass occupies 84% or more of the total land.
	local done = false;
	local iAttempts = 0;
	local iWaterThreshold, biggest_area, iNumBiggestAreaTiles, iBiggestID;
	while done == false do
		local grain_dice = TerrainBuilder.GetRandomNumber(7, "Continental Grain roll - LUA Pangea");
		if grain_dice < 4 then
			grain_dice = 1;
		else
			grain_dice = 2;
		end
		local rift_dice = TerrainBuilder.GetRandomNumber(3, "Rift Grain roll - LUA Pangea");
		if rift_dice < 1 then
			rift_dice = -1;
		end

		g_continentsFrac = nil;
		InitFractal{continent_grain = grain_dice, rift_grain = rift_dice};
		iWaterThreshold = g_continentsFrac:GetHeight(water_percent);
		local landmassOnBordersCount = 0;
		g_iNumTotalLandTiles = 0;
		local oceanTable = {};
		local hasEnoughLandMiddle = true;
		for x = 0, g_iW - 1 do
			for y = 0, g_iH - 1 do
				local i = y * g_iW + x;
				local val = g_continentsFrac:GetHeight(x, y);
				local pPlot = Map.GetPlotByIndex(i);
				--if (val > iWaterThreshold or ((g_iW * 0.3 < x and x < g_iW * 0.7) and (g_iH * 0.3 < y and y < g_iH * 0.7))) then
				-- Inside the for x/y loop where land is determined add more land in center regions
				if (val > iWaterThreshold or 
					-- Force more land in center regions (more aggressive parameters)
					((g_iW * 0.15 < x and x < g_iW * 0.85) and 
					 (g_iH * 0.15 < y and y < g_iH * 0.85) and 
					 val > iWaterThreshold * 0.75)) then
					plotTypes[i] = g_PLOT_TYPE_LAND;
					TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
					g_iNumTotalLandTiles = g_iNumTotalLandTiles + 1;
					if x < g_iW * 0.05 or x > g_iW * 0.95 then
						landmassOnBordersCount = landmassOnBordersCount + 1;
					end
				else
					plotTypes[i] = g_PLOT_TYPE_OCEAN;
					TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);  -- temporary setting so can calculate areas
					-- split the map in 10 regions horizontally, check we have enough land (>40%?) around pangaea center
					local mapVerticalRegionIndex = math.floor((x * 100 / g_iW) / 10);
					local oceanTileAdded = oceanTable[mapVerticalRegionIndex] or 0
					if y > g_iH * 0.1 and y < g_iH * 0.9 then
						oceanTable[mapVerticalRegionIndex] = oceanTileAdded + 1;
					end
				end
			end
		end

		-- Further restrict water in center regions for a more consistent Pangaea
		local maxWaterCenter = 0.1 * g_iH * 0.8 * 0.1 * g_iW; -- Reduced from 0.15
		local maxWaterNextToCenter = 0.25 * g_iH * 0.8 * 0.1 * g_iW; -- Reduced from 0.4
		-- Increase allowable land on border
		local maxLandBorder = 0.2 * g_iH * 0.1 * g_iW; -- Increased from 0.15
		local isLandmassOnBordersOK = landmassOnBordersCount < maxLandBorder;
		_Debug("Max water per 10th index 3 to 6 : ", maxWaterCenter)
		_Debug("Max water per 10th index 2 and 7 : ", maxWaterNextToCenter)
		-- Index going from 0 to 9, excluding 30% of the map each side, we inspect index 3, 4, 5, 6 to check water
		for i, waterCount in pairs(oceanTable) do
			_Debug("Ocean table index ; ", i, oceanTable[i])
			if (i >= 3 and i <= 6 and waterCount > maxWaterCenter) or ((i == 2 or i == 7) and waterCount > maxWaterNextToCenter) then
				hasEnoughLandMiddle = false;
			end
		end

		AreaBuilder.Recalculate();
		local biggest_area = Areas.FindBiggestArea(false);
		iNumBiggestAreaTiles = biggest_area:GetPlotCount();
		local totalTiles =  g_iW * g_iH
		local landPercent = (g_iNumTotalLandTiles / totalTiles) * 100;
		-- Now test the biggest landmass to see if it is large enough.
		if iNumBiggestAreaTiles >= g_iNumTotalLandTiles * 0.98 and isLandmassOnBordersOK and hasEnoughLandMiddle then
			done = true;
			iBiggestID = biggest_area:GetID();
		end
		iAttempts = iAttempts + 1;

		-- Printout for debug use only
		_Debug("--- Pangea landmass generation, Attempt#", iAttempts, "---");
		_Debug("- This attempt successful: ", done);
		_Debug("- Total Land Plots in world:", g_iNumTotalLandTiles);
		_Debug("- Land percentage : ", landPercent)
		_Debug("- Land Plots belonging to biggest landmass:", iNumBiggestAreaTiles);
		_Debug("- Percentage of land belonging to Pangaea: ", 100 * iNumBiggestAreaTiles / g_iNumTotalLandTiles);
		_Debug("- Continent Grain for this attempt: ", grain_dice);
		_Debug("- Rift Grain for this attempt: ", rift_dice);
		_Debug("- Landmass on border count: ", landmassOnBordersCount)
		_Debug("- isLandmassOnBordersOK: ", isLandmassOnBordersOK)
		_Debug("- hasEnoughLandMiddle: ", hasEnoughLandMiddle)
		_Debug("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");

	end

	local args = {};
	args.world_age = world_age;
	args.iW = g_iW;
	args.iH = g_iH
	args.iFlags = g_iFlags;
	args.blendRidge = 10;
	args.blendFract = 1;
	args.extra_mountains = 4;

	-- --Fill inland seas to create a true Pangaea with no interior water bodies
	plotTypes = FillInlandSeas(plotTypes);

	-- --Apply pre-tectonic smoothing to create a better landmass shape
	plotTypes = PreTectonicSmoothing(plotTypes);

	-- after general smoothing, refine coastlines to get rid of 'lonley coast land'
	plotTypes = SmoothLonelyCoastlines(plotTypes);
	

	plotTypes = ApplyTectonics(args, plotTypes);
	if (MapConfiguration.GetValue("BBSRidge") == 1) then
		local mountainRatio = 8 + world_age * 3;
		plotTypes = AddLonelyMountains(plotTypes, mountainRatio);
	end
	
	-- add hills after tectonics
	plotTypes = AddExtraHills(plotTypes); -- Add more hills to the map, so that it is not too flat.



	-- Now shift everything toward one of the poles, to reduce how much jungles tend to dominate this script.
	local shift_dice = TerrainBuilder.GetRandomNumber(2, "Shift direction - LUA Pangaea");
	local iStartRow, iNumRowsToShift;
	local bFoundPangaea, bDoShift = false, false;
	if shift_dice == 1 then
		-- Shift North
		for y = g_iH - 2, 1, -1 do
			for x = 0, g_iW - 1 do
				local i = y * g_iW + x;
				if plotTypes[i] == g_PLOT_TYPE_HILLS or plotTypes[i] == g_PLOT_TYPE_LAND then
					local plot = Map.GetPlot(x, y);
					local iAreaID = plot:GetArea();
					if iAreaID == iBiggestID then
						bFoundPangaea = true;
						iStartRow = y + 1;
						if iStartRow < iNumPlotsY - 4 then -- Enough rows of water space to do a shift.
							bDoShift = true;
						end
						break
					end
				end
			end
			-- Check to see if we've found the Pangaea.
			if bFoundPangaea == true then
				break
			end
		end
	else
		-- Shift South
		for y = 1, g_iH - 2 do
			for x = 0, g_iW- 1 do
				local i = y * g_iW + x;
				if plotTypes[i] == g_PLOT_TYPE_HILLS or plotTypes[i] == g_PLOT_TYPE_LAND then
					local plot = Map.GetPlot(x, y);
					local iAreaID = plot:GetArea();
					if iAreaID == iBiggestID then
						bFoundPangaea = true;
						iStartRow = y - 1;
						if iStartRow > 3 then -- Enough rows of water space to do a shift.
							bDoShift = true;
						end
						break
					end
				end
			end
			-- Check to see if we've found the Pangaea.
			if bFoundPangaea == true then
				break
			end
		end
	end
	if bDoShift == true then
		if shift_dice == 1 then -- Shift North
			local iRowsDifference = g_iH - iStartRow - 2;
			local iRowsInPlay = math.floor(iRowsDifference * 0.7);
			local iRowsBase = math.ceil(iRowsDifference * 0.3);
			local rows_dice = TerrainBuilder.GetRandomNumber(iRowsInPlay, "Number of Rows to Shift - LUA Pangaea");
			local iNumRows = math.min(iRowsDifference - 1, iRowsBase + rows_dice);
			local iNumEvenRows = 2 * math.floor(iNumRows / 2); -- MUST be an even number or we risk breaking a 1-tile isthmus and splitting the Pangaea.
			local iNumRowsToShift = math.max(2, iNumEvenRows);
			--print("-"); print("Shifting lands northward by this many plots: ", iNumRowsToShift); print("-");
			-- Process from top down.
			for y = (g_iH - 1) - iNumRowsToShift, 0, -1 do
				for x = 0, g_iW - 1 do
					local sourcePlotIndex = y * g_iW + x + 1;
					local destPlotIndex = (y + iNumRowsToShift) * g_iW + x + 1;
					plotTypes[destPlotIndex] = plotTypes[sourcePlotIndex]
				end
			end
			for y = 0, iNumRowsToShift - 1 do
				for x = 0, g_iW - 1 do
					local i = y * g_iW + x + 1;
					plotTypes[i] = g_PLOT_TYPE_OCEAN;
				end
			end
		else -- Shift South
			local iRowsDifference = iStartRow - 1;
			local iRowsInPlay = math.floor(iRowsDifference * 0.7);
			local iRowsBase = math.ceil(iRowsDifference * 0.3);
			local rows_dice = TerrainBuilder.GetRandomNumber(iRowsInPlay, "Number of Rows to Shift - LUA Pangaea");
			local iNumRows = math.min(iRowsDifference - 1, iRowsBase + rows_dice);
			local iNumEvenRows = 2 * math.floor(iNumRows / 2); -- MUST be an even number or we risk breaking a 1-tile isthmus and splitting the Pangaea.
			local iNumRowsToShift = math.max(2, iNumEvenRows);
			--print("-"); print("Shifting lands southward by this many plots: ", iNumRowsToShift); print("-");
			-- Process from bottom up.
			for y = 0, (g_iH - 1) - iNumRowsToShift do
				for x = 0, g_iW - 1 do
					local sourcePlotIndex = (y + iNumRowsToShift) * g_iW + x + 1;
					local destPlotIndex = y * g_iW + x + 1;
					plotTypes[destPlotIndex] = plotTypes[sourcePlotIndex]
				end
			end
			for y = g_iH - iNumRowsToShift, g_iH - 1 do
				for x = 0, g_iW - 1 do
					local i = y * g_iW + x + 1;
					plotTypes[i] = g_PLOT_TYPE_OCEAN;
				end
			end
		end
	end

	
	
	return plotTypes;
end

-- custom function to extend coastal waters with a minimal approach (single layer)
function ExtendCoastTiles()
    print("Extending coast tiles with minimal 1-tile approach");
    
    local g_iW, g_iH = Map.GetGridSize();
    
    -- Find ocean tiles directly adjacent to land
    local coastPlots = {};
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local plot = Map.GetPlot(x, y);
            if plot and plot:IsWater() and not plot:IsLake() and plot:GetTerrainType() == g_TERRAIN_TYPE_OCEAN then
                -- Check if this ocean tile is adjacent to land
                local adjacentToLand = false;
                for direction = 0, 5, 1 do
                    local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
                    if adjacentPlot and not adjacentPlot:IsWater() then
                        adjacentToLand = true;
                        break;
                    end
                end
                
                -- Add this to our coast list if it's directly adjacent to land
                if adjacentToLand then
                    table.insert(coastPlots, plot:GetIndex());
                end
            end
        end
    end
    
    -- Convert the identified ocean tiles to coast
    for _, i in ipairs(coastPlots) do
        local plot = Map.GetPlotByIndex(i);
        TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_COAST);
    end
    
    print("Extended coast with " .. #coastPlots .. " coast tiles (minimal 1-tile approach)");
end

-- Simplified function to optimize terrain with better climate distribution
function OptimizeDesert()
    print("Optimizing desert - randomly converting excess desert tiles");

    local g_iW, g_iH = Map.GetGridSize();
    local desertTiles = {};
    local initialDesertCount = 0;
    
    -- Define terrain class constants
    local TERRAIN_CLASS_DESERT = 3;
    
    -- Define terrain types needed for conversion
    local TERRAIN_TYPE_PLAINS = 3;
    local TERRAIN_TYPE_GRASS = 0;
    
    -- First, identify all desert tiles
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local plot = Map.GetPlot(x, y);
            if plot and not plot:IsWater() and not plot:IsMountain() then
                if plot:GetTerrainClassType() == TERRAIN_CLASS_DESERT then
                    initialDesertCount = initialDesertCount + 1;
                    table.insert(desertTiles, {x = x, y = y});
                end
            end
        end
    end
    
    -- Set target desert count (100-110 tiles)
    local targetDesertCount = 100 + TerrainBuilder.GetRandomNumber(10, "Desert Count Variation");
    
    -- Calculate how many to convert
    local desertToKeep = math.min(initialDesertCount, targetDesertCount);
    local desertToConvert = initialDesertCount - desertToKeep;
    
    print("Initial desert count: " .. initialDesertCount);
    print("Target desert count: " .. targetDesertCount);
    print("Desert tiles to convert: " .. desertToConvert);
    
    -- If we need to convert desert tiles
    if desertToConvert > 0 then
        -- Shuffle the desert tiles to randomize which ones we'll convert
        for i = #desertTiles, 2, -1 do
            local j = TerrainBuilder.GetRandomNumber(i, "Shuffle desert tiles") + 1;
            desertTiles[i], desertTiles[j] = desertTiles[j], desertTiles[i];
        end
        
        -- Convert the required number of desert tiles
        local converted = 0;
        for i = 1, math.min(desertToConvert, #desertTiles) do
            local plotData = desertTiles[i];
            local plot = Map.GetPlot(plotData.x, plotData.y);
            
            -- Make sure it's still desert
            if plot and plot:GetTerrainClassType() == TERRAIN_CLASS_DESERT then
                -- Calculate normalized distance from equator
                local distFromEquator = math.abs((g_iH / 2) - plotData.y);
                local normalizedDist = distFromEquator / (g_iH * 0.5);
                
                -- Determine terrain type (more plains near equator, more grass away)
                local plainsChance = 70 - (normalizedDist * 40);
                
                -- Convert to plains or grass
                if TerrainBuilder.GetRandomNumber(100, "Desert Conversion") < plainsChance then
                    TerrainBuilder.SetTerrainType(plot, TERRAIN_TYPE_PLAINS, plot:IsHills(), plot:IsMountain());
                else
                    TerrainBuilder.SetTerrainType(plot, TERRAIN_TYPE_GRASS, plot:IsHills(), plot:IsMountain());
                end
                
                converted = converted + 1;
            end
        end
        
        print("Desert optimization complete - converted " .. converted .. " desert tiles");
        print("Final desert count: approximately " .. (initialDesertCount - converted));
    else
        print("No desert conversion needed - already at or below target count");
    end
end
-------------------------------------------------------------------------------

function SmoothLonelyCoastlines(plotTypes)
    print("Performing ultra-aggressive coastline smoothing");
    
    local g_iW, g_iH = Map.GetGridSize();
    local lonelyLandRemoved = 0;
    
    -- Do multiple passes for maximum thoroughness
    for pass = 1, 3 do
        local changes = {};
        local passRemoved = 0;
        
        -- Process the entire map including edges
        for y = 0, g_iH - 1 do
            for x = 0, g_iW - 1 do
                local i = y * g_iW + x;
                
                -- Only process land tiles
                if plotTypes[i] ~= g_PLOT_TYPE_OCEAN then
                    -- Count hexagonal water neighbors (more accurate than 8-way)
                    local waterNeighbors = 0;
                    
                    for direction = 0, 5 do
                        local newX, newY;
                        
                        if direction == 0 then -- NE
                            newX, newY = x + 1, y - 1;
                        elseif direction == 1 then -- E
                            newX, newY = x + 1, y;
                        elseif direction == 2 then -- SE
                            newX, newY = x, y + 1;
                        elseif direction == 3 then -- SW
                            newX, newY = x - 1, y + 1;
                        elseif direction == 4 then -- W
                            newX, newY = x - 1, y;
                        elseif direction == 5 then -- NW
                            newX, newY = x, y - 1;
                        end
                        
                        if newX >= 0 and newX < g_iW and newY >= 0 and newY < g_iH then
                            local ni = newY * g_iW + newX;
                            if plotTypes[ni] == g_PLOT_TYPE_OCEAN then
                                waterNeighbors = waterNeighbors + 1;
                            end
                        end
                    end
                    
                    -- ULTRA-aggressive - Even tiles with just 3+ water neighbors are converted to water
                    if waterNeighbors >= 3 then
                        changes[i] = g_PLOT_TYPE_OCEAN;
                        passRemoved = passRemoved + 1;
                    end
                end
            end
        end
        
        -- Apply changes
        for i, plotType in pairs(changes) do
            plotTypes[i] = plotType;
            g_iNumTotalLandTiles = g_iNumTotalLandTiles - 1;
        end
        
        lonelyLandRemoved = lonelyLandRemoved + passRemoved;
        print("Pass " .. pass .. ": Removed " .. passRemoved .. " lonely coastline tiles");
        
        -- If we didn't find many tiles to fix, we can stop
        if passRemoved < 10 then
            break;
        end
    end
    
    print("Ultra-aggressive coastline smoothing complete: Removed " .. lonelyLandRemoved .. " lonely coastline tiles");
    
    return plotTypes;
end

function AddExtraHills(plotTypes)
    print("Adding extra hills to the map");
    
    local g_iW, g_iH = Map.GetGridSize();
    local hillsAdded = 0;
    local hillConversionChance = 16; -- 15% base chance to convert flat land to hills
    local maxHillsTarget = 0.50; -- Target up to 50% of land as hills
    
    -- First count current hills and land to determine how many we need to add
    local totalLandTiles = 0;
    local existingHills = 0;
    
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local plot = Map.GetPlot(x, y);
            if plot and not plot:IsWater() and not plot:IsMountain() then
                totalLandTiles = totalLandTiles + 1;
                if plot:IsHills() then
                    existingHills = existingHills + 1;
                end
            end
        end
    end
    
    local currentHillPercent = 0;
    if totalLandTiles > 0 then
        currentHillPercent = existingHills / totalLandTiles;
    end
    
    print("Current hill percentage: " .. string.format("%.1f%%", currentHillPercent * 100));
    print("Target hill percentage: " .. string.format("%.1f%%", maxHillsTarget * 100));
    
    -- If we're already over our target, reduce the chance
    if currentHillPercent >= maxHillsTarget then
        print("Already at or above target hill percentage, reducing chance");
        hillConversionChance = 20; -- Much lower chance if we already have enough hills
    end
    
    -- Process plots to add hills
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local i = y * g_iW + x;
            local plot = Map.GetPlot(x, y);
            
            -- Only process land tiles that are not already hills or mountains
            if plot and not plot:IsWater() and not plot:IsHills() and not plot:IsMountain() then
                -- Higher chance to add hills if adjacent to existing hills or mountains
                local adjacentHillsOrMountains = 0;
                for direction = 0, 5 do
                    local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
                    if adjacentPlot and (adjacentPlot:IsHills() or adjacentPlot:IsMountain()) then
                        adjacentHillsOrMountains = adjacentHillsOrMountains + 1;
                    end
                end
                
                -- Base chance + bonus for adjacent hills/mountains
                local finalChance = hillConversionChance + (adjacentHillsOrMountains * 5);
                
                -- Roll for hill conversion
                if TerrainBuilder.GetRandomNumber(100, "Extra Hills") < finalChance then
                    -- Make sure we use the correct terrain type
                    local terrainType = plot:GetTerrainType();
                    
                    -- Set the terrain with hills=true
                    TerrainBuilder.SetTerrainType(plot, terrainType, true, false);
                    
                    -- CRITICAL: Update plotTypes array to reflect this is now a hill
                    plotTypes[i] = g_PLOT_TYPE_HILLS;
                    
                    hillsAdded = hillsAdded + 1;
                end
            end
        end
    end
    
    print("Added " .. hillsAdded .. " extra hills to the map");
    
    -- Calculate new hill percentage
    local newHillPercent = 0;
    if totalLandTiles > 0 then
        newHillPercent = (existingHills + hillsAdded) / totalLandTiles;
    end
    print("New hill percentage: " .. string.format("%.1f%%", newHillPercent * 100));
    
    return plotTypes;
end

------------------------------------------------------------------------------
function FillInlandSeas(plotTypes)
    print("Filling inland seas to maintain true Pangaea shape (with climate-appropriate terrain)");
    
    local g_iW, g_iH = Map.GetGridSize();
    local waterPlotCount = 0;
    local waterPlotsConverted = 0;
    
    -- Define terrain constants
    local TERRAIN_TYPE_GRASS = 0;
    local TERRAIN_TYPE_GRASS_HILLS = 1;
    local TERRAIN_TYPE_PLAINS = 3;
    local TERRAIN_TYPE_PLAINS_HILLS = 4;
    local TERRAIN_TYPE_DESERT = 6;
    local TERRAIN_TYPE_DESERT_HILLS = 7;
    local TERRAIN_TYPE_TUNDRA = 9;
    local TERRAIN_TYPE_TUNDRA_HILLS = 10;
    local TERRAIN_TYPE_SNOW = 12;
    local TERRAIN_TYPE_SNOW_HILLS = 13;
    local TERRAIN_TYPE_COAST = 15;
    local TERRAIN_TYPE_OCEAN = 16;
    
    -- Climate band parameters from BBS_GenerateTerrainTypes
    local fSnowLatitude = 0.86;
    local fTundraLatitude = 0.66;
    local fGrassLatitude = 0.1;
    local fDesertBottomLatitude = 0.4;
    local fDesertTopLatitude = 0.6;
    
    -- Create a floodfill function to detect isolated water bodies
    local function FloodFill(x, y, visited)
        local stack = {{x = x, y = y}};
        local waterBody = {};
        local reachedTopBottomEdge = false;
        local touchesLeftRightEdge = false;
        local isLargeWaterBody = false;
        local edgeCount = 0;
        local MAX_SIZE_TO_FILL = 400;
        
        while #stack > 0 do
            local curr = table.remove(stack);
            local i = curr.y * g_iW + curr.x;
            
            if not visited[i] then
                visited[i] = true;
                
                if plotTypes[i] == g_PLOT_TYPE_OCEAN then
                    table.insert(waterBody, {index = i, x = curr.x, y = curr.y});
                    
                    -- Check if this water body is getting too large
                    if #waterBody > MAX_SIZE_TO_FILL then
                        isLargeWaterBody = true;
                    end
                    
                    -- Check if we reached any map edge
                    if curr.y == 0 or curr.y == g_iH - 1 then
                        reachedTopBottomEdge = true;
                        edgeCount = edgeCount + 1;
                    end
                    
                    if curr.x == 0 or curr.x == g_iW - 1 then
                        touchesLeftRightEdge = true;
                        edgeCount = edgeCount + 1;
                    end
                    
                    -- Add adjacent water tiles to the stack
                    for direction = 0, 5 do
                        local adjPlot = Map.GetAdjacentPlot(curr.x, curr.y, direction);
                        if adjPlot then
                            local adjX = adjPlot:GetX();
                            local adjY = adjPlot:GetY();
                            local adjI = adjY * g_iW + adjX;
                            
                            if not visited[adjI] and plotTypes[adjI] == g_PLOT_TYPE_OCEAN then
                                table.insert(stack, {x = adjX, y = adjY});
                            end
                        end
                    end
                end
            end
        end
        
        -- Calculate edge ratio: how much of this water body is touching map edges
        local edgeRatio = 0;
        if #waterBody > 0 then
            edgeRatio = edgeCount / #waterBody;
        end
        
        -- Also check water body perimeter to see how enclosed it is
        local landPerimeterCount = 0;
        local edgePerimeterCount = 0;
        local totalPerimeter = 0;
        
        for _, plotData in ipairs(waterBody) do
            local x = plotData.x;
            local y = plotData.y;
            
            for direction = 0, 5 do
                local adjPlot = Map.GetAdjacentPlot(x, y, direction);
                if adjPlot then
                    totalPerimeter = totalPerimeter + 1;
                    local adjX = adjPlot:GetX();
                    local adjY = adjPlot:GetY();
                    
                    -- Check if adjacent tile is at map edge
                    if adjX == 0 or adjX == g_iW - 1 or adjY == 0 or adjY == g_iH - 1 then
                        edgePerimeterCount = edgePerimeterCount + 1;
                    elseif plotTypes[adjY * g_iW + adjX] ~= g_PLOT_TYPE_OCEAN then
                        landPerimeterCount = landPerimeterCount + 1;
                    end
                end
            end
        end
        
        -- Calculate percentage of perimeter that is land
        local landPerimeterRatio = 0;
        if totalPerimeter > 0 then
            landPerimeterRatio = landPerimeterCount / totalPerimeter;
        end
        
        -- If this water body has more than 70% of its perimeter as land, it's considered enclosed
        local isEnclosed = landPerimeterRatio > 0.7;
        
        -- Determine if this is a partially enclosed sea at map edge
        local isPartiallyEnclosedEdgeSea = reachedTopBottomEdge and edgeRatio < 0.5 and landPerimeterRatio > 0.5;
        
        return waterBody, reachedTopBottomEdge, isLargeWaterBody, isEnclosed, isPartiallyEnclosedEdgeSea;
    end
    
    -- Helper function to get appropriate terrain type based on latitude
    local function GetClimateAppropriateTerrainType(y, isHills)
        -- Calculate distance from equator as percentage
        local equatorY = math.floor(g_iH / 2);
        local distFromEquator = math.abs(y - equatorY);
        local latitudePercent = distFromEquator / (g_iH * 0.5);
        
        -- Select appropriate terrain based on latitude
        if latitudePercent >= fSnowLatitude then
            return isHills and TERRAIN_TYPE_SNOW_HILLS or TERRAIN_TYPE_SNOW;
        elseif latitudePercent >= fTundraLatitude then
            return isHills and TERRAIN_TYPE_TUNDRA_HILLS or TERRAIN_TYPE_TUNDRA;
        elseif latitudePercent < fGrassLatitude then
            return isHills and TERRAIN_TYPE_GRASS_HILLS or TERRAIN_TYPE_GRASS;
        elseif latitudePercent >= fDesertBottomLatitude and latitudePercent < fDesertTopLatitude then
            return isHills and TERRAIN_TYPE_DESERT_HILLS or TERRAIN_TYPE_DESERT;
        else
            return isHills and TERRAIN_TYPE_PLAINS_HILLS or TERRAIN_TYPE_PLAINS;
        end
    end
    
    -- Visit all water plots and check if they're part of an inland sea
    local visited = {};
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local i = y * g_iW + x;
            
            if not visited[i] and plotTypes[i] == g_PLOT_TYPE_OCEAN then
                local waterBody, reachedTopBottomEdge, isLargeWaterBody, isEnclosed, isPartiallyEnclosedEdgeSea = 
                    FloodFill(x, y, visited);
                
                -- Fill inland seas and partially enclosed edge seas that aren't the main ocean
                local shouldFill = false;
                
                if not reachedTopBottomEdge then
                    -- Traditional inland seas completely surrounded by land
                    print("Found inland sea with " .. #waterBody .. " water tiles");
                    shouldFill = true;
                elseif isPartiallyEnclosedEdgeSea and not isLargeWaterBody then
                    -- Smaller seas that touch map edge but are mostly enclosed by land
                    print("Found partially enclosed edge sea with " .. #waterBody .. " water tiles");
                    shouldFill = true;
                elseif isEnclosed and not isLargeWaterBody then
                    -- Small seas that are mostly enclosed, regardless of edge contact
                    print("Found mostly enclosed sea with " .. #waterBody .. " water tiles");
                    shouldFill = true;
                end
                
                if shouldFill then
                    -- Convert all water tiles in this sea to land with appropriate terrain
                    for _, plotData in ipairs(waterBody) do
                        -- Convert water to land
                        plotTypes[plotData.index] = g_PLOT_TYPE_LAND;
                        waterPlotsConverted = waterPlotsConverted + 1;
                        g_iNumTotalLandTiles = g_iNumTotalLandTiles + 1;
                        
                        -- Set climate-appropriate terrain type
                        local plot = Map.GetPlot(plotData.x, plotData.y);
                        if plot then
                            -- Randomly decide if this should be hills (15% chance)
                            local isHills = TerrainBuilder.GetRandomNumber(100, "Hill Chance") < 15;
                            
                            -- Get appropriate terrain type for this latitude
                            local newTerrainType = GetClimateAppropriateTerrainType(plotData.y, isHills);
                            
                            -- Set the terrain
                            TerrainBuilder.SetTerrainType(plot, newTerrainType);
                        end
                    end
                end
                
                waterPlotCount = waterPlotCount + #waterBody;
            end
        end
    end
    
    print("Water plots detected: " .. waterPlotCount);
    print("Water plots converted to land with climate-appropriate terrain: " .. waterPlotsConverted);
    
    return plotTypes;
end
-------------------------------------------------------------------------------

function PreTectonicSmoothing(plotTypes)
    print("Pre-tectonic smoothing with climate-appropriate terrain");
    
    local g_iW, g_iH = Map.GetGridSize();
    local peninsulasRemoved = 0;
    local baysFilledIn = 0;
    
    -- Define terrain constants
    local TERRAIN_TYPE_GRASS = 0;
    local TERRAIN_TYPE_GRASS_HILLS = 1;
    local TERRAIN_TYPE_PLAINS = 3;
    local TERRAIN_TYPE_PLAINS_HILLS = 4;
    local TERRAIN_TYPE_DESERT = 6;
    local TERRAIN_TYPE_DESERT_HILLS = 7;
    local TERRAIN_TYPE_TUNDRA = 9;
    local TERRAIN_TYPE_TUNDRA_HILLS = 10;
    local TERRAIN_TYPE_SNOW = 12;
    local TERRAIN_TYPE_SNOW_HILLS = 13;
    local TERRAIN_TYPE_COAST = 15;
    local TERRAIN_TYPE_OCEAN = 16;
    
    -- Climate band parameters from BBS_GenerateTerrainTypes
    local fSnowLatitude = 0.86;
    local fTundraLatitude = 0.66;
    local fGrassLatitude = 0.1;
    local fDesertBottomLatitude = 0.4;
    local fDesertTopLatitude = 0.6;
    
    -- Helper function to get appropriate terrain type based on latitude
    local function GetClimateAppropriateTerrainType(y, isHills)
        -- Calculate distance from equator as percentage
        local equatorY = math.floor(g_iH / 2);
        local distFromEquator = math.abs(y - equatorY);
        local latitudePercent = distFromEquator / (g_iH * 0.5);
        
        -- Select appropriate terrain based on latitude
        if latitudePercent >= fSnowLatitude then
            return isHills and TERRAIN_TYPE_SNOW_HILLS or TERRAIN_TYPE_SNOW;
        elseif latitudePercent >= fTundraLatitude then
            return isHills and TERRAIN_TYPE_TUNDRA_HILLS or TERRAIN_TYPE_TUNDRA;
        elseif latitudePercent < fGrassLatitude then
            return isHills and TERRAIN_TYPE_GRASS_HILLS or TERRAIN_TYPE_GRASS;
        elseif latitudePercent >= fDesertBottomLatitude and latitudePercent < fDesertTopLatitude then
            return isHills and TERRAIN_TYPE_DESERT_HILLS or TERRAIN_TYPE_DESERT;
        else
            return isHills and TERRAIN_TYPE_PLAINS_HILLS or TERRAIN_TYPE_PLAINS;
        end
    end
    
    -- Do multiple passes for better smoothing
    for pass = 1, 3 do
        local changes = {};
        
        for y = 1, g_iH - 2 do
            for x = 1, g_iW - 2 do
                local i = y * g_iW + x;
                
                -- Process land tiles - remove thin peninsulas
                if plotTypes[i] ~= g_PLOT_TYPE_OCEAN then
                    -- Count water neighbors
                    local waterCount = 0;
                    for dy = -1, 1 do
                        for dx = -1, 1 do
                            if not (dx == 0 and dy == 0) then
                                local ni = (y + dy) * g_iW + (x + dx);
                                if ni >= 0 and ni < #plotTypes and plotTypes[ni] == g_PLOT_TYPE_OCEAN then
                                    waterCount = waterCount + 1;
                                end
                            end
                        end
                    end
                    
                    -- More aggressive removal - reduce from 5 to 4 water neighbors
                    if waterCount >= 4 then
                        changes[i] = {newType = g_PLOT_TYPE_OCEAN, x = x, y = y};
                    end
                -- Process water tiles - fill in bays and bites
                else
                    -- Count land neighbors
                    local landCount = 0;
                    local hasNorthLand = false;
                    local hasSouthLand = false;
                    local hasEastLand = false;
                    local hasWestLand = false;
                    
                    for dy = -1, 1 do
                        for dx = -1, 1 do
                            if not (dx == 0 and dy == 0) then
                                local ni = (y + dy) * g_iW + (x + dx);
                                if ni >= 0 and ni < #plotTypes and plotTypes[ni] ~= g_PLOT_TYPE_OCEAN then
                                    landCount = landCount + 1;
                                    
                                    -- Track cardinal directions
                                    if dx == 0 and dy == -1 then hasNorthLand = true; end
                                    if dx == 0 and dy == 1 then hasSouthLand = true; end
                                    if dx == 1 and dy == 0 then hasEastLand = true; end
                                    if dx == -1 and dy == 0 then hasWestLand = true; end
                                end
                            end
                        end
                    end
                    
                    -- Fill in water with 3+ land neighbors (more aggressive)
                    if landCount >= 3 then
                        changes[i] = {newType = g_PLOT_TYPE_LAND, x = x, y = y};
                    -- More aggressively detect and fill U-shapes
                    elseif landCount >= 2 then
                        -- Check for U-shapes (land on opposite sides)
                        if (hasNorthLand and hasSouthLand) or (hasEastLand and hasWestLand) then
                            changes[i] = {newType = g_PLOT_TYPE_LAND, x = x, y = y};
                        end
                    end
                end
            end
        end
        
        -- Apply changes
        local passRemoved = 0;
        local passFilled = 0;
        
        for i, changeData in pairs(changes) do
            if changeData.newType == g_PLOT_TYPE_OCEAN then
                passRemoved = passRemoved + 1;
                g_iNumTotalLandTiles = g_iNumTotalLandTiles - 1;
                plotTypes[i] = g_PLOT_TYPE_OCEAN;
                
                -- Set ocean terrain type for this plot
                local plot = Map.GetPlot(changeData.x, changeData.y);
                if plot then
                    TerrainBuilder.SetTerrainType(plot, TERRAIN_TYPE_OCEAN);
                end
            else
                passFilled = passFilled + 1;
                g_iNumTotalLandTiles = g_iNumTotalLandTiles + 1;
                plotTypes[i] = g_PLOT_TYPE_LAND;
                
                -- Set climate-appropriate terrain type for this plot
                local plot = Map.GetPlot(changeData.x, changeData.y);
                if plot then
                    -- Randomly decide if this should be hills (15% chance)
                    local isHills = TerrainBuilder.GetRandomNumber(100, "Hill Chance") < 15;
                    
                    -- Get appropriate terrain type for this latitude
                    local newTerrainType = GetClimateAppropriateTerrainType(changeData.y, isHills);
                    
                    -- Set the terrain
                    TerrainBuilder.SetTerrainType(plot, newTerrainType);
                end
            end
        end
        
        peninsulasRemoved = peninsulasRemoved + passRemoved;
        baysFilledIn = baysFilledIn + passFilled;
        
        print("Pass " .. pass .. ": Removed " .. passRemoved .. " peninsulas and filled " .. passFilled .. " bays/bites");
    end
    
    print("Pre-tectonic smoothing complete: Removed " .. peninsulasRemoved .. 
          " peninsula tiles and filled " .. baysFilledIn .. " bay/bite tiles");
    
    return plotTypes;
end
-------------------------------------------------------------------------------
-- Function to convert most snow to tundra for better playability
function ReduceSnowCoverage()
    print("Converting most snow to tundra (keeping just 5% of snow)");
    
    local g_iW, g_iH = Map.GetGridSize();
    local snowTiles = {};
    local initialSnowCount = 0;
    
    -- Terrain type constants
    local TERRAIN_TYPE_SNOW = 12;
    local TERRAIN_TYPE_SNOW_HILLS = 13;
    local TERRAIN_TYPE_TUNDRA = 9;
    local TERRAIN_TYPE_TUNDRA_HILLS = 10;
    
    -- First just count the snow tiles to see if we need to do anything
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local plot = Map.GetPlot(x, y);
            if plot and not plot:IsWater() and not plot:IsMountain() then
                local terrainType = plot:GetTerrainType();
                if terrainType == TERRAIN_TYPE_SNOW or terrainType == TERRAIN_TYPE_SNOW_HILLS then
                    initialSnowCount = initialSnowCount + 1;
                    
                    -- Only store non-mountain, non-water snow tiles
                    table.insert(snowTiles, {
                        x = x,
                        y = y,
                        isHills = (terrainType == TERRAIN_TYPE_SNOW_HILLS)
                    });
                end
            end
        end
    end
    
    -- Early exit if no snow or very little snow
    if initialSnowCount < 10 then
        print("Not enough snow tiles found (" .. initialSnowCount .. "), skipping snow reduction.");
        return;
    end
    
    -- Calculate how many to keep (5%)
    local snowToKeep = math.max(1, math.floor(initialSnowCount * 0.05));
    local snowToConvert = initialSnowCount - snowToKeep;
    
    print("Initial snow count: " .. initialSnowCount);
    print("Snow tiles to keep: " .. snowToKeep);
    print("Snow tiles to convert to tundra: " .. snowToConvert);
    
    -- Shuffle the snow tiles to ensure random selection
    for i = #snowTiles, 2, -1 do
        local j = TerrainBuilder.GetRandomNumber(i, "Shuffle snow tiles") + 1;
        snowTiles[i], snowTiles[j] = snowTiles[j], snowTiles[i];
    end
    
    -- Convert the first N tiles in our shuffled list
    local converted = 0;
    for i = 1, math.min(snowToConvert, #snowTiles) do
        local tile = snowTiles[i];
        local plot = Map.GetPlot(tile.x, tile.y);
        
        -- Extra check to make sure this is still a snow tile
        local currentType = plot:GetTerrainType();
        if (currentType == TERRAIN_TYPE_SNOW or currentType == TERRAIN_TYPE_SNOW_HILLS) 
           and not plot:IsWater() and not plot:IsMountain() then
            
            -- Convert to equivalent tundra terrain
            local newType = tile.isHills and TERRAIN_TYPE_TUNDRA_HILLS or TERRAIN_TYPE_TUNDRA;
            TerrainBuilder.SetTerrainType(plot, newType);
            
            converted = converted + 1;
            
            -- Progress update every 25 tiles
            if converted % 25 == 0 then
                print("  - Converted " .. converted .. " snow tiles to tundra");
            end
        end
    end
    
    print("Snow reduction complete - converted " .. converted .. " tiles to tundra");
    print("Final snow count: " .. (initialSnowCount - converted));
end



-------------------------------------------------------------------------------
-- Function to print detailed map statistics
-- This function collects and prints statistics about the map, including terrain distribution and water coverage.
function PrintMapStatistics()
    print("Collecting map statistics...");

    local g_iW, g_iH = Map.GetGridSize();
    local totalTiles = g_iW * g_iH;

   -- Generate a unique map ID using timestamp and random number
    local timestamp = os.time();
    local randomPart = TerrainBuilder.GetRandomNumber(10000, "Map ID Random Part");
    local mapGenID = string.format("MAP_%d_%04d", timestamp, randomPart);

    -- Initialize counters
    local riverCount = 0;
    local grasslandCount = 0;
    local plainsCount = 0;
    local waterCount = 0;
    local oceanCount = 0;
    local coastCount = 0;
    local mountainCount = 0;
    local desertCount = 0;
    local tundraCount = 0;
    local snowCount = 0;
    
    -- Initialize hills-specific counters
    local grasslandHillsCount = 0;
    local plainsHillsCount = 0;
    
    -- Define terrain class constants
    local TERRAIN_CLASS_GRASS = 0;
    local TERRAIN_CLASS_MOUNTAIN = 1;
    local TERRAIN_CLASS_PLAINS = 2;
    local TERRAIN_CLASS_DESERT = 3;
    local TERRAIN_CLASS_TUNDRA = 4;
    local TERRAIN_CLASS_SNOW = 5;
    local TERRAIN_CLASS_WATER = 6;
    
    -- Define terrain type constants
    local TERRAIN_TYPE_COAST = 15;
    local TERRAIN_TYPE_OCEAN = 16;
    
    -- Count all terrain classes, terrain types, and rivers
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local plot = Map.GetPlot(x, y);
            if plot then
                -- Count river tiles
                if plot:IsRiver() then
                    riverCount = riverCount + 1;
                end
                
                -- Count terrain classes
                local terrainClass = plot:GetTerrainClassType();
                
                if terrainClass == TERRAIN_CLASS_GRASS then
                    grasslandCount = grasslandCount + 1;
                    -- Simply use IsHills to count grassland hills
                    if plot:IsHills() then
                        grasslandHillsCount = grasslandHillsCount + 1;
                    end
                elseif terrainClass == TERRAIN_CLASS_PLAINS then
                    plainsCount = plainsCount + 1;
                    -- Simply use IsHills to count plains hills
                    if plot:IsHills() then
                        plainsHillsCount = plainsHillsCount + 1;
                    end
                elseif terrainClass == TERRAIN_CLASS_WATER then
                    waterCount = waterCount + 1;
                    
                    -- Count ocean vs. coast water tiles
                    local terrainType = plot:GetTerrainType();
                    if terrainType == TERRAIN_TYPE_COAST then
                        coastCount = coastCount + 1;
                    elseif terrainType == TERRAIN_TYPE_OCEAN then
                        oceanCount = oceanCount + 1;
                    end
                    
                elseif terrainClass == TERRAIN_CLASS_MOUNTAIN then
                    mountainCount = mountainCount + 1;
                elseif terrainClass == TERRAIN_CLASS_DESERT then
                    desertCount = desertCount + 1;
                elseif terrainClass == TERRAIN_CLASS_TUNDRA then
                    tundraCount = tundraCount + 1;
                elseif terrainClass == TERRAIN_CLASS_SNOW then
                    snowCount = snowCount + 1;
                end
            end
        end
    end
    
    -- Calculate percentages
    local riverPercent = math.floor((riverCount / totalTiles) * 1000 + 0.5) / 10;
    local grasslandHillsPercent = 0;
    local plainsHillsPercent = 0;
    local coastPercent = 0;
    local oceanPercent = 0;
    
    if grasslandCount > 0 then
        grasslandHillsPercent = math.floor((grasslandHillsCount / grasslandCount) * 1000 + 0.5) / 10;
    end
    
    if plainsCount > 0 then
        plainsHillsPercent = math.floor((plainsHillsCount / plainsCount) * 1000 + 0.5) / 10;
    end
    
    if waterCount > 0 then
        coastPercent = math.floor((coastCount / waterCount) * 1000 + 0.5) / 10;
        oceanPercent = math.floor((oceanCount / waterCount) * 1000 + 0.5) / 10;
    end
    
    -- Calculate new settlement statistics exactly as specified
    local settleableTiles = grasslandCount + plainsCount;
    local hillSettleablePercent = 0;
    local riverSettleablePercent = 0;
    
    if settleableTiles > 0 then
        hillSettleablePercent = math.floor(((plainsHillsCount + grasslandHillsCount) / settleableTiles) * 1000 + 0.5) / 10;
        riverSettleablePercent = math.floor((riverCount / settleableTiles) * 1000 + 0.5) / 10;
    end
    
    -- Print the statistics
    print("==================== MAP STATISTICS ====================");
	print("Map Generation ID: " .. mapGenID);
    print("Total Tiles: " .. totalTiles);
    print("River Tiles: " .. riverCount);
    print("");
    print("-- Terrain Distribution --");
    print("Grassland Tiles: " .. grasslandCount);
    print("  - Grassland Hills: " .. grasslandHillsCount);
    print("Plains Tiles: " .. plainsCount);
    print("  - Plains Hills: " .. plainsHillsCount);
    print("Water Tiles: " .. waterCount);
    print("  - Coast Tiles: " .. coastCount);
    print("  - Ocean Tiles: " .. oceanCount);
    print("Mountain Tiles: " .. mountainCount);
    print("Desert Tiles: " .. desertCount);
    print("Tundra Tiles: " .. tundraCount);
    print("Snow Tiles: " .. snowCount);
    print("");
    print("-- Settlement Statistics --");
    print("Total Settleable Tiles: " .. settleableTiles);
    print("Hills % of Settleable: " .. hillSettleablePercent .. "%");
    print("River % of Settleable: " .. riverSettleablePercent .. "%");
    print("================END MAP STATISTICS============================");
    
    -- Return the statistics in a table
    local stats = {
        totalTiles = totalTiles,
        riverTiles = riverCount,
        grasslandTotal = grasslandCount,
        plainsTotal = plainsCount,
        grasslandHills = grasslandHillsCount,
        plainsHills = plainsHillsCount,
        waterTotal = waterCount,
        coastTotal = coastCount,
        oceanTotal = oceanCount,
        mountainTotal = mountainCount,
        desertTotal = desertCount,
        tundraTotal = tundraCount,
        snowTotal = snowCount,
        -- New settlement statistics
        settleableTiles = settleableTiles,
        hillSettleablePercent = hillSettleablePercent,
        riverSettleablePercent = riverSettleablePercent
    };
    
    return stats;
end
-------------------------------------------------------------------------------
-- Add this function after PrintMapStatistics

-------------------------------------------------------------------------------
-- Function to validate and output continent data
function ValidateContinents()
    print("Validating continent structure...");
    
    -- Simply get continents in use and print them
    print("Getting continents using Map.GetContinentsInUse()...");
    local continentsInUse = Map.GetContinentsInUse();
    
    if continentsInUse then
        print("Number of continents found: " .. #continentsInUse);
        print("Individual continent IDs:");
        for i, continentID in ipairs(continentsInUse) do
            print("  Continent #" .. i .. ": ID " .. continentID);
        end
    else
        print("Map.GetContinentsInUse() returned nil - no continents found or function unavailable");
    end
    
    -- Return an empty structure to avoid errors
    return {
        continentCount = continentsInUse and #continentsInUse or 0,
        namedContinents = continentsInUse or {}
    };
end
-------------------------------------------------------------------------------
-- Function to initialize the fractal for Pangaea map generation

-------------------------------------------------------------------------------
function NormalizeSettleableTiles()
    local g_iW, g_iH = Map.GetGridSize();
    local targetSettleableTiles = g_iW * g_iH * 0.46;
    local acceptableVariance = g_iW * g_iH * 0.01;
    local extremeCaseThreshold = g_iW * g_iH * 0.035
    print("Normalizing settleable tiles (plains and grassland) to around "..targetSettleableTiles.." - EXCLUDING DESERT");

    -- Terrain type constants - flats, hills and mountains
    local TERRAIN_TYPE_GRASS = 0;
    local TERRAIN_TYPE_GRASS_HILLS = 1;
    local TERRAIN_TYPE_GRASS_MOUNTAIN = 2;
    local TERRAIN_TYPE_PLAINS = 3;
    local TERRAIN_TYPE_PLAINS_HILLS = 4;
    local TERRAIN_TYPE_PLAINS_MOUNTAIN = 5;
    local TERRAIN_TYPE_DESERT = 6;
    local TERRAIN_TYPE_DESERT_HILLS = 7;
    local TERRAIN_TYPE_DESERT_MOUNTAIN = 8;
    local TERRAIN_TYPE_TUNDRA = 9;
    local TERRAIN_TYPE_TUNDRA_HILLS = 10;
    local TERRAIN_TYPE_TUNDRA_MOUNTAIN = 11;
    local TERRAIN_TYPE_SNOW = 12;
    local TERRAIN_TYPE_SNOW_HILLS = 13;
    local TERRAIN_TYPE_SNOW_MOUNTAIN = 14;
    local TERRAIN_TYPE_COAST = 15;
    local TERRAIN_TYPE_OCEAN = 16;
    
    -- Climate band parameters from BBS_GenerateTerrainTypes
    local fSnowLatitude = 0.86;
    local fTundraLatitude = 0.66;
    local fGrassLatitude = 0.1;
    local fDesertBottomLatitude = 0.4;
    local fDesertTopLatitude = 0.6;
    
    local equatorY = math.floor(g_iH / 2);
    
    -- Count both flat and hills versions of each terrain type
    local grasslandCount = 0;
    local grassHillsCount = 0;
    local plainsCount = 0;
    local plainsHillsCount = 0;
    local desertCount = 0;
    local desertHillsCount = 0;
    local tundraCount = 0;
    local tundraHillsCount = 0;
    local snowCount = 0;
    local snowHillsCount = 0;
    local waterCount = 0;
    
    -- Create lists for all terrain types, organized by latitudinal bands
    local plotsByLatitude = {};
    
    -- Initialize plot arrays for each climate band
    for i = 0, g_iH-1 do
        plotsByLatitude[i] = {
            grass = {},
            grassHills = {},
            plains = {},
            plainsHills = {},
            desert = {},
            desertHills = {},
            tundra = {},
            tundraHills = {},
            snow = {},
            snowHills = {}
        };
    end
    
    -- Gather all terrain information
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local plot = Map.GetPlot(x, y);
            if plot then
                local terrainType = plot:GetTerrainType();
                local isRiver = plot:IsRiver();
                
                -- Add plot to appropriate list by terrain type and latitude
                if terrainType == TERRAIN_TYPE_GRASS then
                    grasslandCount = grasslandCount + 1;
                    if not isRiver then
                        table.insert(plotsByLatitude[y].grass, {x = x, y = y, type = terrainType});
                    end
                elseif terrainType == TERRAIN_TYPE_GRASS_HILLS then
                    grassHillsCount = grassHillsCount + 1;
                    if not isRiver then
                        table.insert(plotsByLatitude[y].grassHills, {x = x, y = y, type = terrainType});
                    end
                elseif terrainType == TERRAIN_TYPE_PLAINS then
                    plainsCount = plainsCount + 1;
                    if not isRiver then
                        table.insert(plotsByLatitude[y].plains, {x = x, y = y, type = terrainType});
                    end
                elseif terrainType == TERRAIN_TYPE_PLAINS_HILLS then
                    plainsHillsCount = plainsHillsCount + 1;
                    if not isRiver then
                        table.insert(plotsByLatitude[y].plainsHills, {x = x, y = y, type = terrainType});
                    end
                elseif terrainType == TERRAIN_TYPE_DESERT then
                    desertCount = desertCount + 1;
                    table.insert(plotsByLatitude[y].desert, {x = x, y = y, type = terrainType});
                elseif terrainType == TERRAIN_TYPE_DESERT_HILLS then
                    desertHillsCount = desertHillsCount + 1;
                    table.insert(plotsByLatitude[y].desertHills, {x = x, y = y, type = terrainType});
                elseif terrainType == TERRAIN_TYPE_TUNDRA then
                    tundraCount = tundraCount + 1;
                    table.insert(plotsByLatitude[y].tundra, {x = x, y = y, type = terrainType});
                elseif terrainType == TERRAIN_TYPE_TUNDRA_HILLS then
                    tundraHillsCount = tundraHillsCount + 1;
                    table.insert(plotsByLatitude[y].tundraHills, {x = x, y = y, type = terrainType});
                elseif terrainType == TERRAIN_TYPE_SNOW then
                    snowCount = snowCount + 1;
                    table.insert(plotsByLatitude[y].snow, {x = x, y = y, type = terrainType});
                elseif terrainType == TERRAIN_TYPE_SNOW_HILLS then
                    snowHillsCount = snowHillsCount + 1;
                    table.insert(plotsByLatitude[y].snowHills, {x = x, y = y, type = terrainType});
                elseif terrainType == TERRAIN_TYPE_COAST or terrainType == TERRAIN_TYPE_OCEAN then
                    waterCount = waterCount + 1;
                end
            end
        end
    end
    
    -- Calculate total settleable tiles (grassland + grass hills + plains + plains hills)
    local settleableTiles = grasslandCount + grassHillsCount + plainsCount + plainsHillsCount;
    local tileDifference = targetSettleableTiles - settleableTiles;
    
    print("Current terrain distribution:");
    print("Grass (flat): " .. grasslandCount);
    print("Grass (hills): " .. grassHillsCount);
    print("Plains (flat): " .. plainsCount);
    print("Plains (hills): " .. plainsHillsCount);
    print("Desert (flat): " .. desertCount);
    print("Desert (hills): " .. desertHillsCount);
    print("Tundra (flat): " .. tundraCount);
    print("Tundra (hills): " .. tundraHillsCount);
    print("Snow (flat): " .. snowCount);
    print("Snow (hills): " .. snowHillsCount);
    print("Water: " .. waterCount);
    print("Current settleable tiles: " .. settleableTiles);
    print("Target settleable tiles: " .. targetSettleableTiles);
    print("Difference: " .. tileDifference);
    
    -- If we're within acceptable range, we're done
    if math.abs(tileDifference) <= acceptableVariance then
        print("Settleable tile count within acceptable range, no adjustments needed.");
        return;
    end
    
    -- Helper function to shuffle plots in place
    local function ShuffleList(list)
        for i = #list, 2, -1 do
            local j = TerrainBuilder.GetRandomNumber(i, "Shuffle plots") + 1;
            list[i], list[j] = list[j], list[i];
        end
    end
    
    -- Force a more drastic approach for large differences
    -- Had weird terraforming in tundra in some cases with extreme, disabled for now
    local extremeCase = false;
    --if math.abs(tileDifference) > extremeCaseThreshold then
        --extremeCase = true;
        --print("EXTREME difference detected (" .. tileDifference .. "), using drastic measures");
   -- end
    
    -- Function to get the next appropriate terrain type based on latitude and conversion direction
    local function GetNextTerrainType(y, currentType, convertingTo)
        local isHills = (currentType == TERRAIN_TYPE_GRASS_HILLS or 
                        currentType == TERRAIN_TYPE_PLAINS_HILLS or
                        currentType == TERRAIN_TYPE_DESERT_HILLS or
                        currentType == TERRAIN_TYPE_TUNDRA_HILLS or
                        currentType == TERRAIN_TYPE_SNOW_HILLS);
        
        -- Calculate distance from equator as percentage
        local distFromEquator = math.abs(y - equatorY) / (g_iH * 0.5);
        
        -- Determine next terrain type based on latitude and conversion direction
        if convertingTo == "settleable" then
            -- Converting to settleable (tundra/snow -> plains/grass)
            if distFromEquator >= fTundraLatitude then
                -- In tundra/snow zone, convert to grassland
                return isHills and TERRAIN_TYPE_GRASS_HILLS or TERRAIN_TYPE_GRASS;
            else
                -- In other zones, decide based on distance from equator
                if distFromEquator < 0.3 then
                    return isHills and TERRAIN_TYPE_GRASS_HILLS or TERRAIN_TYPE_GRASS;
                else
                    return isHills and TERRAIN_TYPE_PLAINS_HILLS or TERRAIN_TYPE_PLAINS;
                end
            end
        else
            -- Converting from settleable (plains/grass -> tundra)
            -- Always convert to tundra regardless of location when removing settleable tiles
            return isHills and TERRAIN_TYPE_TUNDRA_HILLS or TERRAIN_TYPE_TUNDRA;
        end
    end
    
    -- Order latitudes to process - start from equator and move outward to maintain natural transitions
    local latitudeOrder = {};
    for offset = 0, math.ceil(g_iH/2) do
        if equatorY - offset >= 0 then
            table.insert(latitudeOrder, equatorY - offset);
        end
        if equatorY + offset < g_iH and offset > 0 then
            table.insert(latitudeOrder, equatorY + offset);
        end
    end
    
    -- Process based on whether we need more or fewer settleable tiles
    if tileDifference > 0 then
        -- Need MORE settleable tiles
        print("Need to ADD " .. tileDifference .. " settleable tiles (using only tundra/snow)");
        
        local converted = 0;
        local northConverted = 0; 
        local southConverted = 0;
        
        -- First pass: convert tundra only in alternating north/south bands
        for _, y in ipairs(latitudeOrder) do
            -- Check if we need to balance north/south conversions
            local isNorth = (y < equatorY);
            local canConvertHere = true;
            
            if northConverted > southConverted + 20 and isNorth then
                canConvertHere = false; -- Skip northern conversions to balance
            elseif southConverted > northConverted + 20 and not isNorth then
                canConvertHere = false; -- Skip southern conversions to balance
            end
            
            if canConvertHere then
                -- Shuffle the non-settleable plots at this latitude for more natural distribution
                local nonSettleablePlots = {};
                
                -- ONLY include tundra plots (NOT desert) at this latitude
                for _, plot in ipairs(plotsByLatitude[y].tundra) do
                    table.insert(nonSettleablePlots, plot);
                end
                for _, plot in ipairs(plotsByLatitude[y].tundraHills) do
                    table.insert(nonSettleablePlots, plot);
                end
                
                -- If extreme case, also consider snow
                if extremeCase then
                    for _, plot in ipairs(plotsByLatitude[y].snow) do
                        table.insert(nonSettleablePlots, plot);
                    end
                    for _, plot in ipairs(plotsByLatitude[y].snowHills) do
                        table.insert(nonSettleablePlots, plot);
                    end
                end
                
                ShuffleList(nonSettleablePlots);
                
                -- Convert plots at this latitude
                for _, plotData in ipairs(nonSettleablePlots) do
                    if converted >= tileDifference then
                        break;
                    end
                    
                    local plot = Map.GetPlot(plotData.x, plotData.y);
                    local newType = GetNextTerrainType(plotData.y, plotData.type, "settleable");
                    
                    -- Direct terrain type conversion
                    TerrainBuilder.SetTerrainType(plot, newType);
                    
                    -- Verify the conversion worked
                    if plot:GetTerrainType() == newType then
                        converted = converted + 1;
                        if isNorth then
                            northConverted = northConverted + 1;
                        else
                            southConverted = southConverted + 1;
                        end
                        
                        if converted % 20 == 0 then
                            print("  - Converted " .. converted .. " tiles (North: " .. northConverted .. ", South: " .. southConverted .. ")");
                        end
                    end
                    
                    if converted >= tileDifference then
                        break;
                    end
                end
            end
            
            if converted >= tileDifference then
                break;
            end
        end
        
        print("Successfully converted " .. converted .. " tiles to settleable terrain");
        print("North/South balance: " .. northConverted .. "/" .. southConverted);
        
        -- If we couldn't convert enough tundra/snow tiles, notify the user
        if converted < tileDifference then
            print("WARNING: Could only convert " .. converted .. " of " .. tileDifference .. " needed tiles");
            print("Not enough tundra/snow to reach the target settleable count.");
        end
    end
    
    -- Verify final result with more detailed breakdown
    local finalGrass = 0;
    local finalGrassHills = 0;
    local finalPlains = 0;
    local finalPlainsHills = 0;
    local finalTundra = 0;
    local finalTundraHills = 0;
    
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local plot = Map.GetPlot(x, y);
            if plot then
                local terrainType = plot:GetTerrainType();
                if terrainType == TERRAIN_TYPE_GRASS then
                    finalGrass = finalGrass + 1;
                elseif terrainType == TERRAIN_TYPE_GRASS_HILLS then
                    finalGrassHills = finalGrassHills + 1;
                elseif terrainType == TERRAIN_TYPE_PLAINS then
                    finalPlains = finalPlains + 1;
                elseif terrainType == TERRAIN_TYPE_PLAINS_HILLS then
                    finalPlainsHills = finalPlainsHills + 1;
                elseif terrainType == TERRAIN_TYPE_TUNDRA then
                    finalTundra = finalTundra + 1;
                elseif terrainType == TERRAIN_TYPE_TUNDRA_HILLS then
                    finalTundraHills = finalTundraHills + 1;
                end
            end
        end
    end
    
    local finalSettleable = finalGrass + finalGrassHills + finalPlains + finalPlainsHills;
    local finalDifference = finalSettleable - targetSettleableTiles;
    
    print("Final verification:");
    print("Grass (flat): " .. finalGrass);
    print("Grass (hills): " .. finalGrassHills);
    print("Plains (flat): " .. finalPlains);
    print("Plains (hills): " .. finalPlainsHills);
    print("Tundra (flat): " .. finalTundra);
    print("Tundra (hills): " .. finalTundraHills);
    print("Total settleable: " .. finalSettleable);
    print("Final difference from target: " .. finalDifference);
end
-------------------------------------------------------------------------------
function ValidateTerrainCounts(label)
    print("Validating terrain distribution... " .. (label or ""));

    local g_iW, g_iH = Map.GetGridSize();
    local grasslandCount = 0;
    local plainsCount = 0;
    local desertCount = 0;
    local tundraCount = 0;
    local snowCount = 0;
    
    -- Define terrain class constants
    local TERRAIN_CLASS_GRASS = 0;
    local TERRAIN_CLASS_MOUNTAIN = 1;
    local TERRAIN_CLASS_PLAINS = 2;
    local TERRAIN_CLASS_DESERT = 3;
    local TERRAIN_CLASS_TUNDRA = 4;
    local TERRAIN_CLASS_SNOW = 5;
    local TERRAIN_CLASS_WATER = 6;
    
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local plot = Map.GetPlot(x, y);
            if plot and not plot:IsWater() then
                -- Use terrain class rather than terrain type
                local terrainClass = plot:GetTerrainClassType();
                
                if terrainClass == TERRAIN_CLASS_GRASS then
                    grasslandCount = grasslandCount + 1;
                elseif terrainClass == TERRAIN_CLASS_PLAINS then
                    plainsCount = plainsCount + 1;
                elseif terrainClass == TERRAIN_CLASS_DESERT then
                    desertCount = desertCount + 1;
                elseif terrainClass == TERRAIN_CLASS_TUNDRA then
                    tundraCount = tundraCount + 1;
                elseif terrainClass == TERRAIN_CLASS_SNOW then
                    snowCount = snowCount + 1;
                end
            end
        end
    end
    
    local settleableTiles = grasslandCount + plainsCount;
    
    print("=== TERRAIN VALIDATION " .. (label or "") .. " ===");
    print("Grassland: " .. grasslandCount);
    print("Plains: " .. plainsCount);
    print("Desert: " .. desertCount);
    print("Tundra: " .. tundraCount);
    print("Snow: " .. snowCount);
    print("Settleable count: " .. settleableTiles);
    print("===============================");
    
    return {
        grassland = grasslandCount,
        plains = plainsCount,
        desert = desertCount,
        tundra = tundraCount,
        snow = snowCount,
        settleable = settleableTiles
    };
end
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------

function InitFractal(args)

	if(args == nil) then args = {}; end

	local continent_grain = args.continent_grain or 2;
	local rift_grain = args.rift_grain or -1; -- Default no rifts. Set grain to between 1 and 3 to add rifts. - Bob
	local invert_heights = args.invert_heights or false;
	local polar = args.polar or true;
	local ridge_flags = args.ridge_flags or g_iFlags;

	local fracFlags = {};

	if(invert_heights) then
		fracFlags.FRAC_INVERT_HEIGHTS = true;
	end

	if(polar) then
		fracFlags.FRAC_POLAR = true;
	end

	if(rift_grain > 0 and rift_grain < 4) then
		local riftsFrac = Fractal.Create(g_iW, g_iH, rift_grain, {}, 6, 5);
		g_continentsFrac = Fractal.CreateRifts(g_iW, g_iH, continent_grain, fracFlags, riftsFrac, 6, 5);
	else
		g_continentsFrac = Fractal.Create(g_iW, g_iH, continent_grain, fracFlags, 6, 5);
	end

	-- Use Brian's tectonics method to weave ridgelines in to the continental fractal.
	-- Without fractal variation, the tectonics come out too regular.
	--
	--[[ "The principle of the RidgeBuilder code is a modified Voronoi diagram. I
	added some minor randomness and the slope might be a little tricky. It was
	intended as a 'whole world' modifier to the fractal class. You can modify
	the number of plates, but that is about it." ]]-- Brian Wade - May 23, 2009
	--
	local MapSizeTypes = {};
	for row in GameInfo.Maps() do
		MapSizeTypes[row.MapSizeType] = row.PlateValue;
	end
	local sizekey = Map.GetMapSize();

	local numPlates = MapSizeTypes[sizekey] or 4

	-- Blend a bit of ridge into the fractal.
	-- This will do things like roughen the coastlines and build inland seas. - Brian

	g_continentsFrac:BuildRidges(numPlates, {}, 1, 2);
end

function AddFeatures()
	print("Adding Features");

	-- Get Rainfall setting input by user.
	local rainfall = MapConfiguration.GetValue("rainfall");
	if rainfall == 4 then
		rainfall = 1 + TerrainBuilder.GetRandomNumber(3, "Random Rainfall - Lua");
	end

	local args = {rainfall = rainfall}
	featuregen = BBM_FeatureGenerator.Create(args);
	featuregen:AddFeatures(true, true);  --second parameter is whether or not rivers start inland);
    -- Call our custom function to limit ice after normal feature generation
    LimitExistingIce();
end

function AddFeaturesFromContinents()
	print("Adding Features from Continents");

	featuregen:AddFeaturesFromContinents();
end

