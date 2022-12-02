local lines = io.lines('input.txt')

local WLD_POINTS <const> = {
  ["A X"] = 3,
  ["A Y"] = 6,
  ["A Z"] = 0,
  ["B X"] = 0,
  ["B Y"] = 3,
  ["B Z"] = 6,
  ["C X"] = 6,
  ["C Y"] = 0,
  ["C Z"] = 3,
}

local PLAY_POINTS <const> = {
  X = 1,
  Y = 2,
  Z = 3,
}

local points = 0

for line in lines do
  points = points + WLD_POINTS[line] + PLAY_POINTS[string.sub(line, 3, 3)]
end

print(points)
