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

local visibleFromTop = {}
local visibleFromBottom = {}
local visibleFromLeft = {}
local visibleFromRight = {}
for i = 1, size do
  table.insert(visibleFromTop, {})
  table.insert(visibleFromBottom, {})
  table.insert(visibleFromLeft, {})
  table.insert(visibleFromRight, {})
end

for i = 1, size do
  local topMax, bottomMax, leftMax, rightMax = -1, -1, -1, -1
  for j = 1, size do
    local leftTree = trees[i][j]
    visibleFromLeft[i][j] = leftTree > leftMax
    leftMax = math.max(leftTree, leftMax)

    local rightTree = trees[i][size - j + 1]
    visibleFromRight[i][size - j + 1] = rightTree > rightMax
    rightMax = math.max(rightTree, rightMax)

    local topTree = trees[j][i]
    visibleFromTop[j][i] = topTree > topMax
    topMax = math.max(topTree, topMax)

    local bottomTree = trees[size - j + 1][i]
    visibleFromBottom[size - j + 1][i] = bottomTree > bottomMax
    bottomMax = math.max(bottomTree, bottomMax)
  end
end

local visibleCount = 0
for i = 1, size do
  for j = 1, size do
    if visibleFromLeft[i][j] or visibleFromRight[i][j] or visibleFromTop[i][j] or visibleFromBottom[i][j] then
      visibleCount = visibleCount + 1
    end
  end
end

print(visibleCount)
