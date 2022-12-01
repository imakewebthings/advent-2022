local lines = io.lines('input.txt')
local max = 0
local current = 0

for line in lines do
  if line == nil or line == '' then
    if current > max then
      max = current
    end
    current = 0
  else
    current = current + tonumber(line)
  end
end

print(max)
