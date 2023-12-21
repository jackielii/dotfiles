P = function(v)
  vim.schedule(function()
    print(vim.inspect(v))
  end)
  return v
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
