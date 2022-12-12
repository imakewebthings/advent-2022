local grid = {}
local lines = io.lines('input.txt')
local root = {0, 0}
local target = {0, 0}
local width, height = 0, 0

for line in lines do
  height = height + 1
  local row = {}
  for i = 1, #line do
    local char = line:sub(i, i)
    local cell = { value = char }
    table.insert(row, cell)
    if char == 'S' then
      root = {i, height}
      cell.visited = true
      cell.value = 'a'
    elseif char == 'E' then
      target = {i, height}
      cell.value = 'z'
    end
  end
  table.insert(grid, row)
  width = math.max(width, #line)
end

function edges(coords)
  local x, y = table.unpack(coords)
  local value = grid[y][x].value
  local maxStep = string.char(string.byte(value) + 1)
  local children = {{x,y-1}, {x,y+1}, {x-1,y}, {x+1,y}}
  for i = 4, 1, -1 do
    local cx, cy = table.unpack(children[i])
    if cx < 1 or cy < 1 or cx > width or cy > height then
      table.remove(children, i)
    elseif grid[cy][cx].value > maxStep or grid[cy][cx].visited then
      table.remove(children, i)
    end
  end
  return children
end

function search ()
  local queue = {}
  table.insert(queue, root)
  while next(queue) do
    local coords = table.remove(queue, 1)
    local x, y = table.unpack(coords)
    local cell = grid[y][x]
    if x == target[1] and y == target[2] then
      return
    end
    local childrenCoords = edges(coords)
    for _, childCoords in ipairs(childrenCoords) do
      local cx, cy = table.unpack(childCoords)
      local child = grid[cy][cx]
      child.visited = true
      child.parent = coords
      table.insert(queue, childCoords)
    end
  end
end

search()
local count = 0
while not (target[1] == root[1] and target[2] == root[2]) do
  count = count + 1
  target = grid[target[2]][target[1]].parent
end
print(count)
