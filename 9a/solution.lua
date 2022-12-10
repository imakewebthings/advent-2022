local visited = {
  [0] = {
    [0] = true
  }
}
local lines = io.lines('input.txt')

local headX, headY, tailX, tailY = 0, 0, 0, 0
local nextX, nextY = 0, 0

local prepareMove = {
  L = function ()
    nextX = headX - 1
  end,
  R = function ()
    nextX = headX + 1
  end,
  U = function ()
    nextY = headY - 1
  end,
  D = function ()
    nextY = headY + 1
  end
}

function move ()
  if math.abs(nextX - tailX) > 1 or math.abs(nextY - tailY) > 1 then
    tailX = headX
    tailY = headY
    if visited[tailX] == nil then
      visited[tailX] = {}
    end
    visited[tailX][tailY] = true
  end
  headX = nextX
  headY = nextY
end

for line in lines do
  local direction = line:sub(1, 1)  
  local amount = tonumber(line:sub(3, -1))

  for i = 1, amount do
    prepareMove[direction]()
    move()
  end
end

local visitedCount = 0
for x, ys in pairs(visited) do
  for y, _ in pairs(ys) do
    visitedCount = visitedCount + 1
  end
end
print(visitedCount)
