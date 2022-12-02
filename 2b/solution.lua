local lines = io.lines('input.txt')

local WLD_POINTS = {
  X = 0,
  Y = 3,
  Z = 6,
}

local PLAY_POINTS <const> = {
  X = 1,
  Y = 2,
  Z = 3,
}

local PLAY <const> = {
  X = {
    A = "Z",
    B = "X",
    C = "Y",
  },
  Y = {
    A = "X",
    B = "Y",
    C = "Z",
  },
  Z = {
    A = "Y",
    B = "Z",
    C = "X",
  },
}

local points = 0

for line in lines do
  local opponent = string.sub(line, 1, 1)
  local outcome = string.sub(line, 3, 3)
  points = points + WLD_POINTS[outcome] + PLAY_POINTS[PLAY[outcome][opponent]]
end

print(points)
