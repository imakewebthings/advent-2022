local lines = io.lines('input.txt')
local subsetCount = 0

for line in lines do
  local elves = {
    { 0, 0 },
    { 0, 0 }
  }
  local eCount = 1

  for range in string.gmatch(line .. ",", "([^,]+)") do
    local mCount = 1 
    for num in string.gmatch(range .. "-", "([^-]+)") do
      elves[eCount][mCount] = tonumber(num)
      mCount = mCount + 1
    end
    eCount = eCount + 1
  end

  local firstSuper = elves[1][1] <= elves[2][1] and elves[1][2] >= elves[2][2]
  local secondSuper = elves[2][1] <= elves[1][1] and elves[2][2] >= elves[1][2]
  if firstSuper or secondSuper then
    subsetCount = subsetCount + 1
  end
end

print(subsetCount)
