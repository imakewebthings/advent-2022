local input = io.input('input.txt'):read('a')
local hotseat = {}

for i = 1, #input do
  local current = input:sub(i, i)
  local map = {}
  local dupes = false

  if #hotseat == 4 then
    table.remove(hotseat, 1)
  end

  table.insert(hotseat, current)
  if #hotseat == 4 then
    for _, char in ipairs(hotseat) do
      dupes = dupes or not (map[char] == nil)
      map[char] = true
    end

    if not dupes then
      print(i)
      return
    end
  end
end
