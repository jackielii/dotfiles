return {
  -- copilot
  {
    "zbirenbaum/copilot.lua",
    keys = {
      { "<leader>ua", "<cmd>Copilot toggle<cr>", desc = "Copilot toggle" },
    },
    opts = function()
      LazyVim.cmp.actions.ai_accept = function()
        if require("copilot.suggestion").is_visible() then
          LazyVim.create_undo()
          require("copilot.suggestion").accept()
          return true
        end
      end
      LazyVim.cmp.actions.ai_next = function()
        if require("copilot.suggestion").is_visible() then
          return require("copilot.suggestion").next()
        end
      end
      LazyVim.cmp.actions.ai_prev = function()
        if require("copilot.suggestion").is_visible() then
          return require("copilot.suggestion").prev()
        end
      end
      LazyVim.cmp.actions.ai_disable = function()
        if vim.b.copilot_suggestion_auto_trigger == false then
          return
        end
        local copilot = require("copilot.suggestion")
        if copilot.is_visible() then
          copilot.dismiss()
        end
        vim.b.copilot_suggestion_auto_trigger = false
        require("copilot.command").detach()
      end
      LazyVim.cmp.actions.ai_enable = function()
        if vim.b.copilot_suggestion_auto_trigger then
          return
        end
        vim.b.copilot_suggestion_auto_trigger = true
        require("copilot.command").attach()
        require("copilot.suggestion").next()
        -- copilot.next()
      end
      LazyVim.cmp.actions.ai_enabled = function()
        return vim.b.copilot_suggestion_auto_trigger
      end
      return {
        copilot_node_command = vim.fn.expand("$HOME/.nvm/versions/node/v20.10.0/bin/node"),
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            -- accept = "<tab>",
            accept_word = "<M-l>",
            accept_line = "<M-C-L>",
            next = "<M-j>",
            prev = "<M-k>",
            -- dismiss = "<C-h>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          -- help = true,
        },
      }
    end,
  },
}
