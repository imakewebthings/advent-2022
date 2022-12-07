local commands = io.lines('input.txt')
local root = {
  files = {},
  directories = {},
}
local currentDirectory = root

for command in commands do
  if command:sub(1,3) == 'dir' then
    currentDirectory.directories[command:sub(5, -1)] = {
      files = {},
      directories = {},
      parent = currentDirectory
    }
  elseif command:match('^(%d+) ') then
    local size, filename = command:match('^(%d+) (.+)$')
    currentDirectory.files[filename] = tonumber(size)
  elseif command:match('^$ cd %.%.') then
    currentDirectory = currentDirectory.parent
  elseif command:match('^$ cd (.+)') then
    local dir = command:match('^$ cd (.+)')
    if not (dir == '/') then
      currentDirectory = currentDirectory.directories[dir]
    end
  end
end


function dirSize (dir)
  local fileSize = 0
  for filename, size in pairs(dir.files) do
    fileSize = fileSize + size
  end
  local directorySize = 0
  for name, directory in pairs(dir.directories) do
    directorySize = directorySize + dirSize(directory)
  end
  local totalSize = fileSize + directorySize
  dir.size = totalSize
  return totalSize
end

local deleteTarget = 70000000
local toDeleteSize = 70000000
local toDelete = 'root'

function freeSpace(dirname, dir)
  if dir.size >= deleteTarget and dir.size < toDeleteSize then
    toDelete = dirname
    toDeleteSize = dir.size
  end
  for name, directory in pairs(dir.directories) do
    freeSpace(name, directory)
  end
end

dirSize(root)
deleteTarget = 30000000 - (70000000 - root.size)
toDeleteSize = root.size
freeSpace('root', root)
print(toDelete, toDeleteSize)
