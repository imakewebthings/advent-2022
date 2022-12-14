function parseInput (str)
  if str:sub(1, 1) == '[' and str:sub(#str, #str) == ']' then
    local contents = str:sub(2, #str-1)
    local depth = 0
    local buffer = ''
    local arr = {}
    for char in contents:gmatch('.') do
      if char == '[' then
        depth = depth + 1
        buffer = buffer .. char
      elseif char == ']' then
        depth = depth - 1
        buffer = buffer .. char
      elseif char == ',' and depth == 0 then
        table.insert(arr, parseInput(buffer))
        buffer = ''
      else
        buffer = buffer .. char
      end
    end
    if buffer ~= '' then
      table.insert(arr, parseInput(buffer))
    end
    return arr
  else
    return tonumber(str)
  end
end

local lines = io.lines('input.txt')
local pairz = {}
local currentPair = {}

for line in lines do
  if line == '' then
    table.insert(pairz, currentPair)
    currentPair = {}
  else
    table.insert(currentPair, parseInput(line))
  end
end
table.insert(pairz, currentPair)

function compair (left, right)
  local leftType, rightType = type(left), type(right)
  
  if leftType == 'number' and rightType == 'number' then
    return left - right
  elseif leftType == 'table' and rightType == 'table' then
    for i = 1, math.max(#left, #right) do
      local leftItem, rightItem = left[i], right[i]
      if not leftItem then
        return -1
      elseif not rightItem then
        return 1
      end
      local compairison = compair(leftItem, rightItem)
      if compairison ~= 0 then
        return compairison
      end
    end
    return 0
  elseif leftType == 'number' then
    return compair({left}, right)
  else
    return compair(left, {right})
  end
end

local iSum = 0
for i, pair in pairs(pairz) do
  if compair(table.unpack(pair)) <= 0 then
    iSum = iSum + i
  end
end

print(iSum)
