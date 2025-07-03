P = function(...)
  local args = { ... }
  for _, v in ipairs(args) do
    vim.schedule(function()
      print(vim.inspect(v))
    end)
  end
end

_G.pretty_path = function(path)
  -- local pp = vim.g.project_path or LazyVim.root()
  -- if path:find(pp, 1, true) == 1 then
  --   path = path:sub(#pp + 2)
  -- end
  if path:find(vim.fn.expand("~"), 1, true) == 1 then
    path = path:gsub(vim.fn.expand("~"), "~", 1)
  end
  return path
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
