local lines = io.lines('input.txt')
local blueprints = {}

for line in lines do
  local oreRobot, clayRobot, obsidianRobotOre, obsidianRobotClay, geodeRobotOre, geodeRobotObsidian = line:match('Each ore robot costs (%d+) ore. Each clay robot costs (%d+) ore. Each obsidian robot costs (%d+) ore and (%d+) clay. Each geode robot costs (%d+) ore and (%d+) obsidian.')
  local blueprint = {
    oreRobot = tonumber(oreRobot),
    clayRobot = tonumber(clayRobot),
    obsidianRobotOre = tonumber(obsidianRobotOre),
    obsidianRobotClay = tonumber(obsidianRobotClay),
    geodeRobotOre = tonumber(geodeRobotOre),
    geodeRobotObsidian = tonumber(geodeRobotObsidian),
  }
  blueprint.maxOreRobots = math.max(blueprint.oreRobot, blueprint.clayRobot, blueprint.obsidianRobotOre, blueprint.geodeRobotOre)
  table.insert(blueprints, blueprint)
end

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

function collectResources (simulation)
  for k, v in pairs(simulation.resources) do
    simulation.resources[k] = v + simulation.robots[k]
  end
end

function simKey (simulation, seconds)
  return table.concat({
    seconds,
    simulation.resources.ore,
    simulation.resources.clay,
    simulation.resources.obsidian,
    simulation.resources.geode,
    simulation.robots.ore,
    simulation.robots.clay,
    simulation.robots.obsidian,
    simulation.robots.geode
  }, ';')
end

function filterSimulations (simulations)
  table.sort(simulations, function (a, b)
    if a.resources.geode ~= b.resources.geode then
      return a.resources.geode > b.resources.geode
    elseif a.robots.geode ~= b.robots.geode then
      return a.robots.geode > b.robots.geode
    elseif a.resources.obsidian ~= b.resources.obsidian then
      return a.resources.obsidian > b.resources.obsidian
    elseif a.robots.obsidian ~= b.robots.obsidian then
      return a.robots.obsidian > b.robots.obsidian
    elseif a.resources.clay ~= b.resources.clay then
      return a.resources.clay > b.resources.clay
    elseif a.robots.clay ~= b.robots.clay then
      return a.robots.clay > b.robots.clay
    end
    return a.resources.ore > b.resources.ore
  end)
  return table.pack(table.unpack(simulations, 1, 200))
end

function simulate (blueprint, seconds)
  local simulations = {
    {
      resources={
        ore=0,
        clay=0,
        obsidian=0,
        geode=0
      },
      robots={
        ore=1,
        clay=0,
        obsidian=0,
        geode=0
      }
    }
  }
  local seen = {}

  for s = 1, seconds do
    local nextGeneration = {}

    for _, simulation in ipairs(simulations) do
      if simulation.resources.ore >= blueprint.oreRobot and simulation.robots.ore < blueprint.maxOreRobots then
        local oreSim = copyTable(simulation)
        oreSim.parent = simulation
        oreSim.resources.ore = oreSim.resources.ore - blueprint.oreRobot
        collectResources(oreSim)
        oreSim.robots.ore = oreSim.robots.ore + 1
        if not seen[simKey(oreSim, s)] then
          seen[simKey(oreSim, s)] = true
          table.insert(nextGeneration, oreSim)
        end
      end
      if simulation.resources.ore >= blueprint.clayRobot and simulation.robots.clay < blueprint.obsidianRobotClay then
        local claySim = copyTable(simulation)
        claySim.parent = simulation
        claySim.resources.ore = claySim.resources.ore - blueprint.clayRobot
        collectResources(claySim)
        claySim.robots.clay = claySim.robots.clay + 1
        if not seen[simKey(claySim, s)] then
          seen[simKey(claySim, s)] = true
          table.insert(nextGeneration, claySim)
        end
      end
      if simulation.resources.ore >= blueprint.obsidianRobotOre
        and simulation.resources.clay >= blueprint.obsidianRobotClay
        and simulation.robots.obsidian < blueprint.geodeRobotObsidian then
        local obsidianSim = copyTable(simulation)
        obsidianSim.parent = simulation
        obsidianSim.resources.ore = obsidianSim.resources.ore - blueprint.obsidianRobotOre obsidianSim.resources.clay = obsidianSim.resources.clay - blueprint.obsidianRobotClay
        collectResources(obsidianSim)
        obsidianSim.robots.obsidian = obsidianSim.robots.obsidian + 1
        if not seen[simKey(obsidianSim, s)] then
          seen[simKey(obsidianSim, s)] = true
          table.insert(nextGeneration, obsidianSim)
        end
      end
      if simulation.resources.ore >= blueprint.geodeRobotOre
        and simulation.resources.obsidian >= blueprint.geodeRobotObsidian then
        local geodeSim = copyTable(simulation)
        geodeSim.parent = simulation
        geodeSim.resources.ore = geodeSim.resources.ore - blueprint.geodeRobotOre
        geodeSim.resources.obsidian = geodeSim.resources.obsidian - blueprint.geodeRobotObsidian
        collectResources(geodeSim)
        geodeSim.robots.geode = geodeSim.robots.geode + 1
        if not seen[simKey(geodeSim, s)] then
          seen[simKey(geodeSim, s)] = true
          table.insert(nextGeneration, geodeSim)
        end
      end
      local nobotSim = copyTable(simulation)
      nobotSim.parent = simulation
      collectResources(nobotSim)
      if not seen[simKey(nobotSim, s)] then
        seen[simKey(nobotSim, s)] = true
        table.insert(nextGeneration, nobotSim)
      end
    end

    simulations = filterSimulations(nextGeneration)
  end

  return simulations
end

function printSim (simulation)
  local str = ''
  local currentSim = simulation
  local m = 25
  while currentSim do
    str = string.format('\nStart of minute %d\n  resources: %d ore, %d clay, %d obsidian, %d geode\n  robots: %d ore, %d clay, %d obsidian, %d geode', m, currentSim.resources.ore, currentSim.resources.clay, currentSim.resources.obsidian, currentSim.resources.geode, currentSim.robots.ore, currentSim.robots.clay, currentSim.robots.obsidian, currentSim.robots.geode) .. str
    m = m - 1
    currentSim = currentSim.parent
  end
  print(str)
end

local total = 1
blueprints = table.pack(table.unpack(blueprints, 1, 3))
for i, blueprint in ipairs(blueprints) do
  local sims = simulate(blueprint, 32)
  local bestSim = sims[1]
  for _, sim in ipairs(sims) do
    if sim.resources.geode > bestSim.resources.geode then
      bestSim = sim
    end
  end
  total = total * bestSim.resources.geode
  --printSim(bestSim)
end
print(total)
