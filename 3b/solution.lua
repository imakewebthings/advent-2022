local lines = io.lines('input.txt')
local common = {}
local sum = 0
local groupCount = 1

for line in lines do
  if groupCount == 1 then
    for i = 1, #line do
      common[string.sub(line, i, i)] = true
    end
  else

    local intersection = {}
    for i=1, #line do
      local char = string.sub(line, i, i)
      if common[char] then
        intersection[char] = true
      end
    end
    common = intersection

    if groupCount == 3 then
      for k, v in pairs(common) do
        value = string.byte(k) - 64
        if value < 27 then
          value = value + 26
        else
          value = value - 32 
        end
        sum = sum + value
      end
      groupCount = 0
      common = {}
    end
  end
  groupCount = groupCount + 1
end

print(sum)
