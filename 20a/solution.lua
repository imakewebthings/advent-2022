local lines = io.lines('input.txt')
local original = {}
local mixed = {}

for line in lines do
  table.insert(original, {tonumber(line)})
end

for _, v in ipairs(original) do
  table.insert(mixed, v)
end

function index (array, value)
  for i, v in ipairs(array) do
    if value == v then
      return i
    end
  end
end

for _, n in ipairs(original) do
  local i = index(mixed, n)
  local target = (i + n[1]) % (#original - 1)
  if target <= 1 then
    target = #original + target - 1
  end
  table.remove(mixed, i)
  table.insert(mixed, target, n)
end

function firstZero (array)
  for i, n in ipairs(array) do
    if n[1] == 0 then
      return i
    end
  end
end

local zeroNdx = firstZero(mixed)
function wrappedValueAt (array, n)
  local i = n % #array
  if i == 0 then
    i = #array
  end
  return array[i][1]
end

local answer = 0
for x = 1000, 3000, 1000 do
  answer = answer + wrappedValueAt(mixed, zeroNdx + x)
end
print(answer)
