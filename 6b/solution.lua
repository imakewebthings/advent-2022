local input = io.input('input.txt'):read('a')
local hotseat = {}
local MARKER_WIDTH <const> = 14

for i = 1, #input do
  local current = input:sub(i, i)
  local map = {}
  local dupes = false

  if #hotseat == MARKER_WIDTH then
    table.remove(hotseat, 1)
  end

  table.insert(hotseat, current)
  if #hotseat == MARKER_WIDTH then
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
