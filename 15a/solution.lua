local lines = io.lines('input.txt')
local sensors = {}
local beacons = {}

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
  if not beacons[beaconX] then
    beacons[beaconX] = {}
  end
  beacons[beaconX][beaconY] = true
end

function covering (sensor, row)
  local covered = {}
  local diff = sensor.reach - math.abs(sensor.y - row)
  for i = sensor.x - diff, sensor.x + diff do
    table.insert(covered, i)
  end
  return covered
end

local ROW <const> = 2000000
local count = 0
local seenMap = {}
for _, sensor in ipairs(sensors) do
  local covered = covering(sensor, ROW)
  for i, col in ipairs(covered) do
    local isBeacon = beacons[col] and beacons[col][ROW]
    if (not seenMap[col]) and (not isBeacon) then
      count = count + 1
    end
    seenMap[col] = true
  end
end
print(count)
