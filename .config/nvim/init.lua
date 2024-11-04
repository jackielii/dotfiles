P = function(...)
  local args = { ... }
  for _, v in ipairs(args) do
    vim.schedule(function()
      print(vim.inspect(v))
    end)
  end
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
