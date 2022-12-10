local KNOT_COUNT <const> = 10
local visited = {
  [0] = {
    [0] = true
  }
}

local knots = {}
for i = 1, KNOT_COUNT do
  knots[i] = {0,0}
end
local vector = {0, 0}

local moveHead = {
  L = function ()
    knots[1][1] = knots[1][1] - 1
  end,
  R = function ()
    knots[1][1] = knots[1][1] + 1
  end,
  U = function ()
    knots[1][2] = knots[1][2] - 1
  end,
  D = function ()
    knots[1][2] = knots[1][2] + 1
  end
}

function sign (i)
  if i < 0 then
    return -1
  elseif i > 0 then
    return 1
  end
  return 0
end

function moveKnot (i)
  local xDiff = knots[i-1][1] - knots[i][1]
  local yDiff = knots[i-1][2] - knots[i][2]
  
  if math.abs(xDiff) < 2 and math.abs(yDiff) < 2 then
    return
  end

  knots[i][1] = knots[i][1] + sign(xDiff)
  knots[i][2] = knots[i][2] + sign(yDiff)
end

local lines = io.lines('input.txt')
for line in lines do
  local direction = line:sub(1, 1)  
  local amount = tonumber(line:sub(3, -1))

  for i = 1, amount do
    moveHead[direction]()
    for i = 2, KNOT_COUNT do
      moveKnot(i)
    end
    if visited[knots[KNOT_COUNT][1]] == nil then
      visited[knots[KNOT_COUNT][1]] = {}
    end
    visited[knots[KNOT_COUNT][1]][knots[KNOT_COUNT][2]] = true
  end
end

local visitedCount = 0
for x, ys in pairs(visited) do
  for y, _ in pairs(ys) do
    visitedCount = visitedCount + 1
  end
end
print(visitedCount)
