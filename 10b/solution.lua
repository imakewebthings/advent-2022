local lines = io.lines('input.txt')
local cycles = {1}

for line in lines do
  table.insert(cycles, cycles[#cycles])
  if not (line == 'noop') then
    local addx = tonumber(line:sub(6, -1))
    table.insert(cycles, cycles[#cycles] + addx)
  end
end

local str = ""
for i = 1, #cycles do
  local offset = math.floor(i / 40) * 40 + 1
  if math.abs(cycles[i] + offset - i) < 2 then
    str = str .. '# '
  else
    str = str .. '. '
  end
  if i % 40 == 0 then
    str = str .. '\n'
  end
end
print(str)
