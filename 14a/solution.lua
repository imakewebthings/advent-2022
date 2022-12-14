local lines = io.lines('input.txt')
local grid = {}
local OCCUPIED <const> = '#'
local abyssLine = 0

for line in lines do
  local prevX, prevY
  for xStr, yStr in line:gmatch('(%d+),(%d+)') do
    local x, y = tonumber(xStr), tonumber(yStr)
    if prevX and prevY then
      for i = math.min(prevX, x), math.max(prevX, x) do
        if not grid[i] then
          grid[i] = {}
        end
        for j = math.min(prevY, y), math.max(prevY, y) do
          grid[i][j] = OCCUPIED
        end
      end
    end
    prevX, prevY = x, y
    abyssLine = math.max(abyssLine, y)
  end
end

function dropSand ()
  local x, y = 500, 0
  while true do
    if y > abyssLine then
      return false
    elseif not grid[x][y+1] then
      y = y + 1
    elseif not grid[x-1] then
      return false
    elseif not grid[x-1][y+1] then
      x = x - 1
      y = y + 1
    elseif not grid[x+1] then
      return false
    elseif not grid[x+1][y+1] then
      x = x + 1
      y = y + 1
    else
      grid[x][y] = OCCUPIED
      return true
    end
  end
end

local restedCount = 0
while dropSand() do
  restedCount = restedCount + 1
end
print(restedCount)
