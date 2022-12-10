local lines = io.lines('input.txt')
local cycles = {1}

for line in lines do
  table.insert(cycles, cycles[#cycles])
  if not (line == 'noop') then
    local addx = tonumber(line:sub(6, -1))
    table.insert(cycles, cycles[#cycles] + addx)
  end
end

local total = 0
for i = 20, 220, 40 do
  total = total + i * cycles[i]
end
print(total)
