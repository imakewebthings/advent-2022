local lines = io.lines('input.txt')
local monkeys = {}
local currentMonkey

for line in lines do
  if line:match('^Monkey') then
    currentMonkey = {
      items = {},
      inspectionCount = 0
    }
  elseif line:match('Starting') then
    for num in line:gmatch('%d+') do
      table.insert(currentMonkey.items, tonumber(num))
    end
  elseif line:match('Operation') then
    local operation = line:match('new = old (.+)')
    currentMonkey.operator = operation:sub(1, 1) 
    currentMonkey.operand = operation:sub(3, -1)
  elseif line:match('Test') then
    currentMonkey.divisibleBy = tonumber(line:match('(%d+)'))
  elseif line:match('If true') then
    currentMonkey.throwTrue = tonumber(line:match('(%d+)')) + 1
  elseif line:match('If false') then
    currentMonkey.throwFalse = tonumber(line:match('(%d+)')) + 1
    table.insert(monkeys, currentMonkey)
  end
end

function doMonkeyBusiness (monkey)
  for i, item in ipairs(monkey.items) do
    local y = 0
    if monkey.operand == 'old' then
      y = item
    else
      y = tonumber(monkey.operand)
    end
    if monkey.operator == '+' then
      item = item + y
    elseif monkey.operator == '*' then
      item = item * y
    end
    item = math.floor(item / 3)
    if item % monkey.divisibleBy == 0 then
      table.insert(monkeys[monkey.throwTrue].items, item)
    else
      table.insert(monkeys[monkey.throwFalse].items, item)
    end
    monkey.inspectionCount = monkey.inspectionCount + 1
  end
  monkey.items = {}
end

for i = 1, 20 do
  for j, monkey in ipairs(monkeys) do
    doMonkeyBusiness(monkey)    
  end
end

table.sort(monkeys, function(a, b)
  return a.inspectionCount > b.inspectionCount
end)

print(monkeys[1].inspectionCount * monkeys[2].inspectionCount)
