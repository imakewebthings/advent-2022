local lines = io.lines('input.txt')
local monkeys = {}

for line in lines do
  local name, expr = line:match('^(%a+): (.+)$')
  local left, op, right = expr:match('^(%a+) (.) (%a+)$')
  if not op then
    monkeys[name] = function () return tonumber(expr) end
  elseif op == '+' then
    monkeys[name] = function () return monkeys[left]() + monkeys[right]() end
  elseif op == '-' then
    monkeys[name] = function () return monkeys[left]() - monkeys[right]() end
  elseif op == '*' then
    monkeys[name] = function () return monkeys[left]() * monkeys[right]() end
  elseif op == '/' then
    monkeys[name] = function () return monkeys[left]() / monkeys[right]() end
  end
end

print(monkeys['root']())
