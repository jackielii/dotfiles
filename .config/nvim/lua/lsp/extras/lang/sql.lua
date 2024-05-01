return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      local sqlOptions = {}
      for _, line in ipairs(vim.fn.systemlist({ "sqlfluff", "dialects" })) do
        local _, _, dialect = line:find("^(%a+):")
        if dialect then
          table.insert(sqlOptions, dialect)
        end
      end
      vim.api.nvim_create_user_command("SqlDialect", function()
        vim.ui.select(sqlOptions, {
          prompt = "Selct SQL dialect:",
          -- format_item = function(item)
          --   return "I'd like to choose " .. item
          -- end,
        }, function(choice)
          if choice then
            vim.b["sql_dialect"] = choice
          end
        end)
      end, {})

      return vim.tbl_deep_extend("force", opts, {
        formatters_by_ft = {
          sql = { "sqlfluff" },
        },
        formatters = {
          sqlfluff = function()
            local dialect = vim.b["sql_dialect"] or "ansi"
            -- vim.print({ "fix", "--force", "--dialect=" .. dialect, "-" })
            return {
              command = "sqlfluff",
              args = { "fix", "--force", "--dialect=" .. dialect, "-" },
              stdin = true,
              exit_codes = { 0, 1 }, -- it seems to report any misformatted SQL as exit code 1
            }
          end,
        },
      })
    end,
  },
}
