local lines = io.lines('input.txt')
local sum = 0

for line in lines do
  local part1 = {}
  local part2 = {}

  for i = 1, string.len(line) / 2 do
    part1[string.sub(line, i, i)] = true
  end
  for i = string.len(line) / 2 + 1, string.len(line) do
    part2[string.sub(line, i, i)] = true
  end

  for k, v in pairs(part1) do
    if part2[k] then
      local value = string.byte(k) - 64
      if value < 27 then
        value = value + 26
      else
        value = value - 32 
      end
      sum = sum + value
    end
  end
end

print(sum)
