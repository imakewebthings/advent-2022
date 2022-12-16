local lines = io.lines('input.txt')
local sensors = {}
local SIDE <const> = 4000000

function cabDistance (a, b, x, y)
  return math.abs(a-x) + math.abs(b-y)
end

for line in lines do
  local sx, sy, bx, by = line:match('x=(.+),.*y=(.+):.*x=(.+),.*y=(.+)' )
  local sensorX, sensorY = tonumber(sx), tonumber(sy)
  local beaconX, beaconY = tonumber(bx), tonumber(by)
  local sensor = {
    x = sensorX,
    y = sensorY,
    reach = cabDistance(sensorX, sensorY, beaconX, beaconY)
  }
  table.insert(sensors, sensor)
end

function coveredRange (sensor, row)
  local diff = sensor.reach - math.abs(sensor.y - row)
  if diff < 0 then
    return nil
  end
  return {math.max(sensor.x - diff, 0), math.min(sensor.x + diff, SIDE)}
end

for i = 0, SIDE do
  local ranges = {}
  for _, sensor in ipairs(sensors) do
    local range = coveredRange(sensor, i)
    if range then
      table.insert(ranges, range)
    end
  end
  table.sort(ranges, function (a, b)
    if a[1] == b[1] then
      return a[2] < b[2]
    end
    return a[1] < b[1]
  end)

  local collapsedRange = {ranges[1][1], ranges[1][2]}
  for j = 2, #ranges do
    if ranges[j][1] - collapsedRange[2] == 2 then
      print((collapsedRange[2]+ 1) * SIDE + i)
      return
    end
    collapsedRange[2] = math.max(collapsedRange[2], ranges[j][2])
  end
end
