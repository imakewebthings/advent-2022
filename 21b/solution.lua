local lines = io.lines('input.txt')
local monkeys = {}

for line in lines do
  local name, expr = line:match('^(%a+): (.+)$')
  local left, op, right = expr:match('^(%a+) (.) (%a+)$')
  local monkey
  if not op then
    monkey = { left=tonumber(expr) }
  else
    monkey = { left=left, op=op, right=right }
  end
  monkeys[name] = monkey
end

function computeMonkey (name)
  local monkey = monkeys[name]
  if not monkey.op then
    return monkey.left
  elseif monkey.op == '+' then
    return computeMonkey(monkey.left) + computeMonkey(monkey.right)
  elseif monkey.op == '-' then
    return computeMonkey(monkey.left) - computeMonkey(monkey.right)
  elseif monkey.op == '*' then
    return computeMonkey(monkey.left) * computeMonkey(monkey.right)
  elseif monkey.op == '/' then
    return computeMonkey(monkey.left) / computeMonkey(monkey.right)
  end
end

function reduce (name, acc)
  if name == 'humn' then
    return acc
  end

  local monkey = monkeys[name]
  monkeys['humn'].left = 1
  local leftA, rightA = computeMonkey(monkey.left), computeMonkey(monkey.right)
  monkeys['humn'].left = 2
  local leftB, rightB = computeMonkey(monkey.left), computeMonkey(monkey.right)
  local constant = rightA
  local nextMonkey = monkey.left
  if leftA == leftB then
    constant = leftA
    nextMonkey = monkey.right
  end

  local newAcc = 0
  if name == 'root' then
    newAcc = constant
  elseif monkey.op == '+' then
    newAcc = acc - constant
  elseif monkey.op == '*' then
    newAcc = acc / constant
  elseif monkey.op == '-' and nextMonkey == monkey.right then
    newAcc = constant - acc
  elseif monkey.op == '-' then
    newAcc = constant + acc
  elseif monkey.op == '/' and nextMonkey == monkey.right then
    newAcc = constant / acc
  elseif monkey.op == '/' then
    newAcc = constant * acc
  end

  return reduce(nextMonkey, newAcc)
end

print(reduce('root', 0))
