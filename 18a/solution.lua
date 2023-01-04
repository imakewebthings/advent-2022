local lines = io.lines('input.txt')
local cubes = {}
local minX, minY, minZ = math.maxinteger, math.maxinteger, math.maxinteger
local maxX, maxY, maxZ = 0, 0, 0

function addCube (x, y, z)
  minX = math.min(minX, x)
  minY = math.min(minY, y)
  minZ = math.min(minZ, z)
  maxX = math.max(maxX, x)
  maxY = math.max(maxY, y)
  maxZ = math.max(maxZ, z)
  table.insert(cubes, {x=x, y=y, z=z})
end

function zSlice (x, y)
  local slice = {}
  for _, cube in ipairs(cubes) do
    if cube.x == x and cube.y == y then
      table.insert(slice, cube.z)
    end
  end
  table.sort(slice)
  return slice
end

function ySlice (x, z)
  local slice = {}
  for _, cube in ipairs(cubes) do
    if cube.x == x and cube.z == z then
      table.insert(slice, cube.y)
    end
  end
  table.sort(slice)
  return slice
end

function xSlice (y, z)
  local slice = {}
  for _, cube in ipairs(cubes) do
    if cube.y == y and cube.z == z then
      table.insert(slice, cube.x)
    end
  end
  table.sort(slice)
  return slice
end

for line in lines do
  x, y, z = line:match('(%d+),(%d+),(%d+)')
  addCube(tonumber(x), tonumber(y), tonumber(z))
end

local rangeCount = 0

for x = minX, maxX do
  for y = minY, maxY do
    local slice = zSlice(x, y) 
    for i, z in ipairs(slice) do
      if i == 1 or z > slice[i-1] + 1 then
        rangeCount = rangeCount + 1
      end
    end
  end
end

for x = minX, maxX do
  for z = minZ, maxZ do
    local slice = ySlice(x, z) 
    for i, y in ipairs(slice) do
      if i == 1 or y > slice[i-1] + 1 then
        rangeCount = rangeCount + 1
      end
    end
  end
end

for y = minY, maxY do
  for z = minZ, maxZ do
    local slice = xSlice(y, z) 
    for i, x in ipairs(slice) do
      if i == 1 or x > slice[i-1] + 1 then
        rangeCount = rangeCount + 1
      end
    end
  end
end

print(rangeCount * 2)
