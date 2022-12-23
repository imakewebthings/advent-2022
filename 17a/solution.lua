local wind = io.input('input.txt'):read('a')
local pieces = { '-', '+', ']', '|', '#' }
local DASH, PLUS, BRACKET, PIPE, BLOCK = table.unpack(pieces)
local ROCK = 'r'
local grid = {}
local summit = 0
local rockCounter = 0
local rock = {}

for i = 1, 7 do
  table.insert(grid, {})
end

function canLeft ()
  if rock.x == 1 then
    return false
  end
  if rock.shape == DASH then
    return not grid[rock.x-1][rock.y] 
  elseif rock.shape == PLUS then
    return not grid[rock.x][rock.y]
    and not grid[rock.x-1][rock.y+1]
    and not grid[rock.x][rock.y+2]
  elseif rock.shape == BRACKET then
    return not grid[rock.x-1][rock.y]
    and not grid[rock.x+1][rock.y+1]
    and not grid[rock.x+1][rock.y+2]
  elseif rock.shape == PIPE then
    return not grid[rock.x-1][rock.y]
    and not grid[rock.x-1][rock.y+1]
    and not grid[rock.x-1][rock.y+2]
    and not grid[rock.x-1][rock.y+3]
  elseif rock.shape == BLOCK then
    return not grid[rock.x-1][rock.y] 
    and not grid[rock.x-1][rock.y+1]
  end
end

function canRight ()
  if rock.shape == DASH then
    return rock.x < 4
    and not grid[rock.x+4][rock.y] 
  elseif rock.shape == PLUS then
    return rock.x < 5
    and not grid[rock.x+2][rock.y]
    and not grid[rock.x+3][rock.y+1]
    and not grid[rock.x+2][rock.y+2]
  elseif rock.shape == BRACKET then
    return rock.x < 5
    and not grid[rock.x+3][rock.y]
    and not grid[rock.x+3][rock.y+1]
    and not grid[rock.x+3][rock.y+2]
  elseif rock.shape == PIPE then
    return rock.x < 7
    and not grid[rock.x+1][rock.y]
    and not grid[rock.x+1][rock.y+1]
    and not grid[rock.x+1][rock.y+2]
    and not grid[rock.x+1][rock.y+3]
  elseif rock.shape == BLOCK then 
    return rock.x < 6
    and not grid[rock.x+2][rock.y] 
    and not grid[rock.x+2][rock.y+1]
  end
end

local windCounter = 0
function sideways ()
  windCounter = windCounter + 1
  if windCounter >= #wind then
    windCounter = 1
  end
  local direction = wind:sub(windCounter, windCounter)
  if direction == '>' and canRight() then
    rock.x = rock.x + 1 
  elseif direction == '<' and canLeft() then
    rock.x = rock.x - 1
  end
end


function canDown ()
  if rock.y == 1 then
    return false
  end
  if rock.shape == DASH then
    return not grid[rock.x][rock.y-1]
    and not grid[rock.x+1][rock.y-1]
    and not grid[rock.x+2][rock.y-1]
    and not grid[rock.x+3][rock.y-1]
  elseif rock.shape == PLUS then
    return not grid[rock.x][rock.y]
    and not grid[rock.x+1][rock.y-1]
    and not grid[rock.x+2][rock.y]
  elseif rock.shape == BRACKET then
    return not grid[rock.x][rock.y-1]
    and not grid[rock.x+1][rock.y-1]
    and not grid[rock.x+2][rock.y-1]
  elseif rock.shape == PIPE then
    return not grid[rock.x][rock.y-1]
  elseif rock.shape == BLOCK then 
    return not grid[rock.x][rock.y-1]
    and not grid[rock.x+1][rock.y-1]
  end
end

function land ()
  if rock.shape == DASH then
    grid[rock.x][rock.y] = ROCK
    grid[rock.x+1][rock.y] = ROCK
    grid[rock.x+2][rock.y] = ROCK
    grid[rock.x+3][rock.y] = ROCK
  elseif rock.shape == PLUS then
    grid[rock.x][rock.y+1] = ROCK
    grid[rock.x+1][rock.y] = ROCK
    grid[rock.x+1][rock.y+1] = ROCK
    grid[rock.x+1][rock.y+2] = ROCK
    grid[rock.x+2][rock.y+1] = ROCK
  elseif rock.shape == BRACKET then
    grid[rock.x][rock.y] = ROCK
    grid[rock.x+1][rock.y] = ROCK
    grid[rock.x+2][rock.y] = ROCK
    grid[rock.x+2][rock.y+1] = ROCK
    grid[rock.x+2][rock.y+2] = ROCK
  elseif rock.shape == PIPE then
    grid[rock.x][rock.y] = ROCK
    grid[rock.x][rock.y+1] = ROCK
    grid[rock.x][rock.y+2] = ROCK
    grid[rock.x][rock.y+3] = ROCK
  elseif rock.shape == BLOCK then 
    grid[rock.x][rock.y] = ROCK
    grid[rock.x][rock.y+1] = ROCK
    grid[rock.x+1][rock.y] = ROCK
    grid[rock.x+1][rock.y+1] = ROCK
  end
end

local rockHeight = {
  [DASH] = 0,
  [PLUS] = 2,
  [BRACKET] = 2,
  [PIPE] = 3,
  [BLOCK] = 1
}
function rockElevation ()
  return rock.y + rockHeight[rock.shape]
end

function newRock ()
  rock = {
    shape = pieces[(rockCounter % 5) + 1],
    x = 3,
    y = summit + 4
  }
  rockCounter = rockCounter + 1
end

function downward ()
  if canDown() then
    rock.y = rock.y - 1
  else
    land()
    local oldSummit = summit
    summit = math.max(summit, rockElevation())
    newRock()
  end
end

local tickCounter = 0
function tick ()
  tickCounter = tickCounter + 1
  if tickCounter % 2 == 1 then
    sideways()
  else
    downward()
  end
end

function printGrid ()
  for y = math.max(summit, 10), 1, -1 do
    local str = '|'
    for x = 1, 7 do
      local cell = '.'
      if grid[x][y] then
        cell = '#'
      end
      str = str .. cell
    end
    str = str .. '|'
    print(str)
  end
  print('+-------+')
end

newRock()
while rockCounter < 2023 do
  tick()
end
printGrid()
print(summit)
