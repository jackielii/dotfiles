_G.__code_action_operator = function(type)
  local range = {
    start = vim.api.nvim_buf_get_mark(0, "["),
    ["end"] = vim.api.nvim_buf_get_mark(0, "]"),
  }
  vim.lsp.buf.code_action({ range = range })
end

-- LSP keymaps
return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      ["*"] = {
        keys = {
          -- stylua: ignore start
          -- Disable default keymaps
          { "<C-k>", false, mode = "i" },
          { "<A-n>", false, mode = "n" },
          { "<A-p>", false, mode = "n" },
          { "<leader>cc", false },
          { "<leader>cr", false },
          { "<leader>cR", false },

          -- Custom keymaps
          { "<leader>cr", function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
              return
            end
            local name = clients[1].name
            if vim.bo.filetype == "templ" then
              name = "templ"
            end
            vim.notify("Restarting LSP for " .. name, vim.log.levels.WARN)
            vim.cmd("LspRestart ".. name)
          end, desc = "Restart LSP" },

          { "<leader>rn", vim.lsp.buf.rename, desc = "Rename" },
          { "<leader>rN", function() Snacks.rename.rename_file() end, desc = "Rename File", mode = { "n" }, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
          { "<leader>a", "<Esc><cmd>set operatorfunc=v:lua.__code_action_operator<CR>g@", desc = "Code Action Operator" },
          { "<leader>ac", vim.lsp.buf.code_action, desc = "[C]ode [A]ction", mode = { "n" } },
          { "<F3>", vim.lsp.buf.code_action, desc = "[C]ode [A]ction", mode = { "n", "v" } },

          { "<leader>ag", function()
            vim.lsp.buf.code_action({
              context = {
                only = { "source" },
                diagnostics = {},
              },
            })
          end, desc = "Source Action" },

          { "<leader>gi", LazyVim.lsp.action["source.organizeImports"], desc = "Organize Imports" },

          { "<leader>qf", function()
            vim.lsp.buf.code_action({
              filter = function(a)
                return a.kind == "quickfix"
              end,
              apply = true,
            })
          end, desc = "Quick Fix" },

          { "<D-i>", vim.lsp.buf.signature_help, desc = "Signature Documentation", mode = "i" },
          -- stylua: ignore end
        },
      },
    },
  },
}
