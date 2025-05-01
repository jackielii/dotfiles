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
  opts = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    -- stylua: ignore start
    keys[#keys + 1] = { "<A-n>", mode = "n", false }
    keys[#keys + 1] = { "<A-p>", mode = "n", false }

    keys[#keys + 1] = { "<leader>cc", false }
    keys[#keys + 1] = { "<leader>cr", false }
    keys[#keys + 1] = { "<leader>cR", false }
    keys[#keys + 1] = { "<leader>cr", [[<cmd>LspRestart<cr>]], desc = "Restart LSP" }
    keys[#keys + 1] = { "<leader>rn", vim.lsp.buf.rename, desc = "Rename" }
    keys[#keys + 1] = { "<leader>rN", function() Snacks.rename.rename_file() end, desc = "Rename File", mode = { "n" }, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } }
    keys[#keys + 1] =
      { "<leader>a", "<Esc><cmd>set operatorfunc=v:lua.__code_action_operator<CR>g@", desc = "Code Action Operator" }
    keys[#keys + 1] = { "<leader>a", vim.lsp.buf.code_action, desc = "[C]ode [A]ction", mode = { "v" } }
    keys[#keys + 1] = { "<leader>ac", vim.lsp.buf.code_action, desc = "[C]ode [A]ction", mode = { "n" } }
    keys[#keys + 1] = { "<F3>", vim.lsp.buf.code_action, desc = "[C]ode [A]ction", mode = { "n", "v" } }
    keys[#keys + 1] = {
      "<leader>ag",
      function()
        vim.lsp.buf.code_action({
          context = {
            only = {
              "source",
            },
            diagnostics = {},
          },
        })
      end,
      desc = "Source Action",
    }
    keys[#keys + 1] = { "<leader>gi", LazyVim.lsp.action["source.organizeImports"], desc = "Organize Imports" }

    keys[#keys + 1] = {
      "<leader>qf",
      function()
        vim.lsp.buf.code_action({
          filter = function(a)
            return a.kind == "quickfix"
          end,
          apply = true,
        })
      end,
      desc = "Quick Fix",
    }
    --   { "K", vim.lsp.buf.hover, desc = "Hover" },
    --   { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
    keys[#keys + 1] = {
      "<C-k>",
      function()
        local cmp = require("cmp")
        local snip = require("luasnip")
        if cmp.visible() then
          cmp.select_prev_item()
        elseif snip.jumpable(-1) then
          snip.jump(-1)
        else
          vim.lsp.buf.signature_help()
        end
      end,
      desc = "Signature Documentation",
      mode = "i",
    }
    keys[#keys + 1] = { "<D-i>", vim.lsp.buf.signature_help, desc = "Signature Documentation", mode = "i" }
    --
    --   {
    --     "gd",
    --     function()
    --       require("telescope.builtin").lsp_definitions({
    --         ignore_current_line = true,
    --         jump_to_single_result = true,
    --         reuse_win = true,
    --       })
    --     end,
    --     desc = "Goto Definition",
    --   },
    --
    --   { "gr", go("lsp_references"), desc = "[G]oto [R]eferences" },
    --   {
    --     "gI",
    --     function()
    --       require("telescope.builtin").lsp_implementations({ reuse_win = true })
    --     end,
    --     desc = "Goto Implementation",
    --   },
    --   -- k("gy", goto("lsp_typedefs"), "Type [D]efinition") -- fzf-lua
    --   {
    --     "gy",
    --     function()
    --       require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
    --     end,
    --     desc = "Goto T[y]pe Definition",
    --   },
    --   { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
    --
    --   {
    --     "]]",
    --     function()
    --       jump(vim.v.count1)
    --     end,
    --     desc = "Next Reference",
    --     mode = "n",
    --   },
    --
    --   {
    --     "[[",
    --     function()
    --       jump(-vim.v.count1)
    --     end,
    --     "Prev Reference",
    --     "n",
    --   },
    --   { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    -- }
  end,
}
