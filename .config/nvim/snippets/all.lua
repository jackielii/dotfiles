---@diagnostic disable: undefined-global

local sets = { { 97, 122 }, { 65, 90 }, { 48, 57 } } -- a-z, A-Z, 0-9
-- local strong = { { 97, 122 }, { 65, 90 }, { 48, 57 } } -- a-z, A-Z, 0-9
local function randomString(chars)
  local str = ""
  for i = 1, chars do
    math.randomseed(os.clock() ^ 5)
    local set = sets[math.random(1, #sets)]
    str = str .. string.char(math.random(set[1], set[2]))
  end
  return str
end

return {
  s(
    "password",
    c(1, {
      p(randomString, 5),
      p(randomString, 10),
      p(randomString, 20),
    })
  ),
  s({ trig = "password(%d+)", regTrig = true }, {
    f(function(_, snip)
      return randomString(snip.captures[1])
    end),
    i(0),
  }),
  s("pwd", { p(vim.fn.getcwd) }),
}
