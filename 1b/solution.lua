local lines = io.lines('input.txt')
local weights = {}
local currentWeight = 0
local currentIndex = 1

for line in lines do
  if line == nil or line == '' then
    weights[currentIndex] = currentWeight
    currentWeight = 0
    currentIndex = currentIndex + 1
  else
    currentWeight = currentWeight + tonumber(line)
  end
end

table.sort(weights, function (a, b) return a > b end)
print(weights[1] + weights[2] + weights[3])
