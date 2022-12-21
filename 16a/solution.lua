local lines = io.lines('input.txt')
local valves = {}
local distances = {}

function copyTable(t)
  local copy = {}
  for k, v in pairs(t) do
    if type(v) == 'table' then
      copy[k] = copyTable(v)
    else
      copy[k] = v
    end
  end
  return copy
end

function setDistance (a, b, distance)
  if not distances[a] then
    distances[a] = {}
  end
  if not distances[b] then
    distances[b] = {}
  end
  distances[a][b] = distance
  distances[b][a] = distance
end

function getDistance (a, b)
  if not distances[a] or not distances[b] then
    return -1
  elseif distances[a][b] ~= distances[b][a] then
    return -2
  end
  return distances[a][b]
end

for line in lines do
  local name, rate = line:match('Valve (%u+) has flow rate=(%d+);')
  valves[name] = tonumber(rate)
  for c in line:gmatch('(%u+)', 40) do
    setDistance(name, c, 1)
  end
end

function collapse (map, removed)
  local connections = distances[removed]
  for c1, d1 in pairs(connections) do
    for c2, d2 in pairs(connections) do
      if c1 ~= c2 then
        if distances[c1][c2] then
          distances[c1][c2] = math.min(distances[c1][c2], d1 + d2)
          distances[c2][c1] = math.min(distances[c1][c2], d1 + d2)
        else
          distances[c1][c2] = d1 + d2
          distances[c2][c1] = d1 + d2
        end
        distances[c2][removed] = nil
      end
    end
  end
  distances[removed] = nil
  valves[removed] = nil
end

for valve, rate in pairs(valves) do
  if valve ~= 'AA' and rate == 0 then
    collapse(valves, valve)
  end
end

function shortestDistance (a, b, seen)
  local distance = getDistance(a, b)
  seen[a] = true
  if not distance or distance < 0 then
    local shortest = 999999
    for child, childDistance in pairs(distances[a]) do
      if not seen[child] then
        shortest = math.min(shortest, childDistance + shortestDistance(child, b, copyTable(seen)))
      end
    end
    return shortest
  else
    return distance
  end
end

for v1, _ in pairs(valves) do
  for v2, _ in pairs(valves) do
    if v1 ~= v2 then
      setDistance(v1, v2, shortestDistance(v1, v2, {}))
    end
  end
end

function run ()
  local solutions = {}
  local q = {
    {
      path = {'AA'},
      seen = {AA=true},
      current = 'AA',
      budget = 30,
      score = 0
    }
  }

  while next(q) do
    local solution = table.remove(q, 1)
    local producedChildren = false
    for child, distance in pairs(distances[solution.current]) do
      if (not solution.seen[child]) and solution.budget - distance > 0 then
        local childSolution = copyTable(solution)
        table.insert(childSolution.path, child)
        childSolution.seen[child] = true
        childSolution.current = child
        childSolution.budget = childSolution.budget - distance - 1
        childSolution.score = childSolution.score + childSolution.budget * valves[child]
        table.insert(q, childSolution)
        producedChildren = true
      end
    end
    if not producedChildren then
      table.insert(solutions, solution)
    end
  end

  table.sort(solutions, function (a, b) return a.score > b.score end)
  print(solutions[1].score)
end

run()
