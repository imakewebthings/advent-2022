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

local underTotal = 0
function dirSize (dirname, dir)
  local fileSize = 0
  for filename, size in pairs(dir.files) do
    fileSize = fileSize + size
  end
  local directorySize = 0
  for name, directory in pairs(dir.directories) do
    directorySize = directorySize + dirSize(name, directory)
  end
  local totalSize = fileSize + directorySize
  if totalSize < 100000 then
    underTotal = underTotal + totalSize
  end
  return totalSize
end

dirSize('root', root)
print(underTotal)
