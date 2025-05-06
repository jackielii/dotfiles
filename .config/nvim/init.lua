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

_G.list_known_gopls_packages = function()
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client.name == "gopls" then
      local command = {
        command = "gopls.package_symbols",
        arguments = {
          { uri = vim.uri_from_bufnr(0) },
        },
      }

      client:exec_cmd(command, { bufnr = 0 }, function(err, result)
        if err then
          vim.notify("Error running gopls.list_known_packages: " .. err.message, vim.log.levels.ERROR)
          return
        end
        if result then
          vim.notify("Known packages:\n" .. vim.inspect(result), vim.log.levels.INFO)
        else
          vim.notify("No known packages returned by gopls.", vim.log.levels.WARN)
        end
      end)
      return
    end
  end

  vim.notify("gopls LSP client not found", vim.log.levels.ERROR)
end
