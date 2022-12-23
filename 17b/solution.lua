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

local states = {}
local summits = {}
local cycleStart = 0
local cycleEnd = 0
local cycleLength = 0 
local cycleHeight = 0
function saveState ()
  local key = ''
  for x = 1, 7 do
    local diff = 0
    while not grid[x][summit - diff] and summit-diff > 0 do
      diff = diff + 1 
    end
    if diff == summit then
      diff = 'f'
    end
    key = key .. diff .. '-'
  end
  key = string.format('%s;%d;%s', key, windCounter, rock.shape)
  if states[key] and cycleStart == 0 then
    cycleStart = states[key]
    cycleEnd = rockCounter
    cycleLength = cycleEnd - cycleStart
    if cycleStart == 1 then
      cycleHeight = summits[cycleEnd - 1]
    else
      cycleHeight = summits[cycleEnd - 1] - summits[cycleStart - 1]
    end
    return
  end
  states[key] = rockCounter
  table.insert(summits, summit)
end

function downward ()
  if canDown() then
    rock.y = rock.y - 1
  else
    land()
    summit = math.max(summit, rockElevation())
    saveState()
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

function lineAt (y)
  local line = ''
  for x = 1, 7 do
    if grid[x][y] then
      line = line .. '#'
    else
      line = line .. '.'
    end
  end
  return line
end

function dropUntilCycle ()
  while cycleStart == 0 do
    tick()
  end
end

local BIG_NUMBER <const> = 1000000000000
newRock()
dropUntilCycle()
local totalCycles = math.floor((BIG_NUMBER - cycleStart) / cycleLength)
local totalCycleHeight = totalCycles * cycleHeight
local preHeight = 0
if cycleStart > 1 then
  preHeight = summits[cycleStart - 1]
end
local remainingRocks = BIG_NUMBER - totalCycles * cycleLength - cycleStart + 1
local postHeight = summits[cycleStart + remainingRocks - 1] - summits[cycleStart - 1]
local totalHeight = preHeight + totalCycleHeight + postHeight

print(totalHeight)
