math.randomseed(42)

g_dW = 10
g_dH = 10
local list = {}

function tInitRawMap(map)
    for i = 0, g_dH, 1 do
        map[i] = {}
    end
    return map
end

function tFillMapRandom(map, threshold)
    for i = 0, g_dH, 1 do
        for j = 0, g_dW, 1 do
            local value = 0;
            if math.random() > threshold
            then
                value = 1;
            end
            map[i][j] = value
        end
    end
    return map
end

function tOutputMap(map)
    for i = 0, g_dH, 1 do
        if (math.fmod(i,2) == 1) then
            io.write(' ')
        end  
        for j = 0, g_dW, 1 do
            local label = map[i][j]
            if label == 0 then
                label = '. '
            elseif 0 < label and label <= 1 then
                label = '1 '
            elseif 1 < label and label <= 2 then
                label = '2 '
            elseif 2 < label and label <= 3 then
                label = '3 '
            elseif 3 < label and label <= 4 then
                label = '4 '
            elseif 4 < label and label <= 5 then
                label = '5 '
            elseif 5 < label and label <= 6 then
                label = '6 '
            else
                label = '# '
            end
            io.write(label)
        end
        io.write("\n")
        io.flush()
    end
end

function tIsValidCoords(iI, iJ)
    return not (iI < 0 or g_dH < iI or iJ < 0 or g_dW < iJ)
end

function tKernelRun(map, kernelSize, iI, iJ, roundMap)
    --[[
    Case 1: even line
     -1 0 
    -1 0 1
     -1 0 
    Case 2: odd line
      0 1 
    -1 0 1
      0 1 
    ]]--
    local size = kernelSize
    local lI = nil
    local lJ = nil
    local kernelvalue = 0
    local tilevalue = nil

    if not tIsValidCoords(iI, iJ) then
        return nil
    end
    if (math.fmod(iI,2) == 0) then
        for i = -size, size, 1 do
            for j = -size, size, 1 do
                tilevalue = 0
                lI = iI + i

                if (roundMap) then 
                    lJ = math.fmod(iJ + j + g_dW, g_dW) 
                else 
                    lJ = iJ + j 
                end

                if (tIsValidCoords(lI, lJ))  then
                    tilevalue = map[lI][lJ]
                end

                if not (j == size and i ~= 0) then
                    kernelvalue = kernelvalue + tilevalue
                end
            end
        end
    else
        for i = -size, size, 1 do
            for j = -size, size, 1 do
                tilevalue = 0
                lI = iI + i

                if (roundMap) then 
                    lJ = math.fmod(iJ + j + g_dW, g_dW) 
                else 
                    lJ = iJ + j 
                end

                if (tIsValidCoords(lI, lJ))  then
                    tilevalue = map[lI][lJ]
                end
                if not (j == -size and i ~= 0) then
                    kernelvalue = kernelvalue + tilevalue 
                end
            end
        end
    end
    return kernelvalue
end

function tConvolution2DMap(map, kernelSize, roundMap)
    list = {}
    tmpmap = tInitRawMap(list)
    for i = 0, g_dH, 1 do
        for j = 0, g_dW, 1 do
            tmpmap[i][j] = tKernelRun(map, kernelSize, i, j, roundMap)
        end
    end
    return tmpmap
end


map = tInitRawMap(list)
map = tFillMapRandom(map, 0.95)
tOutputMap(map)
print()
map = tConvolution2DMap(map, 1, false)
tOutputMap(map)

