local lines = io.lines('input.txt')
local cubes = {}
local waterMap = {}
local cubeMap = {}
local minX, minY, minZ = math.maxinteger, math.maxinteger, math.maxinteger
local maxX, maxY, maxZ = 0, 0, 0

function mapKey (x, y, z)
  return table.concat({x, y, z}, ',')
end

function addCube (x, y, z)
  minX = math.min(minX, x)
  minY = math.min(minY, y)
  minZ = math.min(minZ, z)
  maxX = math.max(maxX, x)
  maxY = math.max(maxY, y)
  maxZ = math.max(maxZ, z)
  table.insert(cubes, {x=x, y=y, z=z})
  cubeMap[mapKey(x, y, z)] = true
end

function visitable (x, y, z)
  if x < minX or x > maxX or y < minY or y > maxY or z < minZ or z > maxZ then
    return false
  end
  local key = mapKey(x, y, z)
  return not (cubeMap[key] or waterMap[key])
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

minX = minX - 1
minY = minY - 1
minZ = minZ - 1
maxX = maxX + 1
maxY = maxY + 1
maxZ = maxZ + 1

local queue = {{minX, minY, minZ}}
while next(queue) do
  local point = table.remove(queue, 1)
  if visitable(point[1] + 1, point[2], point[3]) then
    waterMap[mapKey(point[1] + 1, point[2], point[3])] = true
    table.insert(queue, {point[1] + 1, point[2], point[3]})
  end
  if visitable(point[1] - 1, point[2], point[3]) then
    waterMap[mapKey(point[1] - 1, point[2], point[3])] = true
    table.insert(queue, {point[1] - 1, point[2], point[3]})
  end
  if visitable(point[1], point[2] + 1, point[3]) then
    waterMap[mapKey(point[1], point[2] + 1, point[3])] = true
    table.insert(queue, {point[1], point[2] + 1, point[3]})
  end
  if visitable(point[1], point[2] - 1, point[3]) then
    waterMap[mapKey(point[1], point[2] - 1, point[3])] = true
    table.insert(queue, {point[1], point[2] - 1, point[3]})
  end
  if visitable(point[1], point[2], point[3] + 1) then
    waterMap[mapKey(point[1], point[2], point[3] + 1)] = true
    table.insert(queue, {point[1], point[2], point[3] + 1})
  end
  if visitable(point[1], point[2], point[3] - 1) then
    waterMap[mapKey(point[1], point[2], point[3] - 1)] = true
    table.insert(queue, {point[1], point[2], point[3] - 1})
  end
end

for x = minX, maxX do
  for y = minY, maxY do
    for z = minZ, maxZ do
      if visitable(x, y, z) then
        addCube(x, y, z)
      end
    end
  end
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
