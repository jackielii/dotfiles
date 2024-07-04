local util = require("conform.util")

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      local sqlfluff = require("lint").linters.sqlfluff
      sqlfluff.args = {
        "lint",
        "--format=json",
        function()
          if vim.b["sql_dialect"] then
            return "--dialect=" .. vim.b["sql_dialect"]
          end
          return "-n" -- means --no-color. We need to return something to make it run
        end,
      }
      return vim.tbl_deep_extend("force", opts, {
        linters_by_ft = {
          sql = { "sqlfluff" },
        },
      })
    end,
  },
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
            local args = { "fix" }
            if vim.b["sql_dialect"] then
              table.insert(args, "--dialect=" .. vim.b["sql_dialect"])
            end
            table.insert(args, "-")
            return {
              command = "sqlfluff",
              args = args,
              stdin = true,
              -- exit_codes = { 0, 1 }, -- it seems to report any misformatted SQL as exit code 1
              cwd = util.root_file({
                ".sqlfluff",
                "pep8.ini",
                "pyproject.toml",
                "setup.cfg",
                "tox.ini",
              }),
              require_cwd = false,
            }
          end,
        },
      })
    end,
  },
}
