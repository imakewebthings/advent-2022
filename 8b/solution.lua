local size = 0
local trees = {}

local lines = io.lines('input.txt')
for line in lines do
  size = size + 1

  local row = {}
  for i = 1, #line do
    local char = line:sub(i, i)
    table.insert(row, tonumber(char))
  end
  table.insert(trees, row)
end

local scenicUp = {}
local scenicDown = {}
local scenicLeft = {}
local scenicRight = {}
for i = 1, size do
  table.insert(scenicUp, {})
  table.insert(scenicDown, {})
  table.insert(scenicLeft, {})
  table.insert(scenicRight, {})
end

for i = 1, size do
  local topMax, bottomMax, leftMax, rightMax = -1, -1, -1, -1
  for j = 1, size do
    local height = trees[i][j]
    local k = j - 1
    local count = 0
    while k > 0 and trees[i][k] < height do
      k = k - 1
      count = count + 1
    end
    if k > 0 then
      count = count + 1
    end
    scenicLeft[i][j] = count

    k = j + 1
    count = 0
    while k <= size and trees[i][k] < height do
      k = k + 1
      count = count + 1
    end
    if k <= size then
      count = count + 1
    end
    scenicRight[i][j] = count

    k = i - 1
    count = 0
    while k > 0 and trees[k][j] < height do
      k = k - 1
      count = count + 1
    end
    if k > 0 then
      count = count + 1
    end
    scenicUp[i][j] = count

    k = i + 1
    count = 0
    while k <= size and trees[k][j] < height do
      k = k + 1
      count = count + 1
    end
    if k <= size then
      count = count + 1
    end
    scenicDown[i][j] = count
  end
end

local best = 0
for i = 1, size do
  for j = 1, size do
    best = math.max(best, scenicUp[i][j] * scenicDown[i][j] * scenicLeft[i][j] * scenicRight[i][j])
  end
end

print(best)
