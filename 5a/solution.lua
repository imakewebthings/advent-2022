local lines = io.lines('input.txt')
local stacks = { {}, {}, {}, {}, {}, {}, {}, {}, {} }
local startingPositions = true

for line in lines do
  if line == nil or line == "" or string.sub(line, 1, 2) == " 1" then
    startingPositions = false
  end

  if startingPositions then
    for i = 2, 34, 4 do
      local char = string.sub(line, i, i)
      if not (char == " ") then
        table.insert(stacks[math.ceil(i/4)], 1, char)
      end
    end
  else
    local j = 1
    for count, from, to in string.gmatch(line, "move (%d+) from (%d+) to (%d+)") do
      for i = 1, tonumber(count) do
        table.insert(stacks[tonumber(to)], table.remove(stacks[tonumber(from)]))
      end
    end
  end
end

local answer = ""
for _, stack in ipairs(stacks) do
  answer = answer .. table.remove(stack)
end

print(answer)
