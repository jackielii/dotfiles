-- claudecode.nvim with custom "none" terminal provider
--
-- Architecture:
--   This config uses a custom terminal provider that does NOT manage terminals.
--   Instead, it publishes the Neovim RPC socket path to a lock file, allowing
--   external scripts (like Claude Code's PostToolUse hooks) to send commands
--   back to Neovim (e.g., :checktime to reload changed buffers).
--
-- Flow:
--   1. On plugin setup, write a lock file: ~/.claude/ide/nvim-sockets/<pid>.lock
--      containing { nvimSocket, workspaceFolders, pid }
--   2. External script (nvim-checktime.sh) reads lock files, matches workspace,
--      and sends "checktime" via: nvim --server <socket> --remote-expr '...'
--   3. On VimLeavePre, the lock file is cleaned up
--
-- Why not use the built-in terminal provider?
--   We run Claude Code in a separate terminal (e.g., tmux pane), not inside
--   Neovim's :terminal. This provider lets claudecode.nvim still work for
--   features like ClaudeCodeAdd/ClaudeCodeSend while we handle the terminal externally.

return {
  {
    "coder/claudecode.nvim",
    lazy = false,
    dependencies = { "folke/snacks.nvim" },
    keys = {
      -- Normal mode: send current buffer as @ mention (no line refs)
      { "<leader>as", "<cmd>ClaudeCodeAdd %:p<cr>", mode = "n", desc = "Add current buffer", silent = false },
      -- {
      --   "<leader>as",
      --   function()
      --     require("claudecode").send_at_mention(vim.api.nvim_buf_get_name(0), nil, nil, "keybind")
      --   end,
      --   mode = "n",
      --   desc = "Add current buffer",
      -- },
      -- Visual mode: send selection as @ mention (with line refs)
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
    },
    opts = function()
      local lock_dir = vim.fn.expand("~/.claude/ide/nvim-sockets")
      local lock_file = nil -- tracks our lock file path for cleanup

      -- Collect workspace folders from cwd + LSP clients
      local function get_workspace_folders()
        local folders = { vim.fn.getcwd() }
        local clients = vim.lsp.get_clients and vim.lsp.get_clients() or {}
        for _, client in pairs(clients) do
          if client.config and client.config.workspace_folders then
            for _, ws in ipairs(client.config.workspace_folders) do
              local path = ws.uri
              if path:sub(1, 7) == "file://" then
                path = path:sub(8)
              end
              if not vim.tbl_contains(folders, path) then
                table.insert(folders, path)
              end
            end
          end
        end
        return folders
      end

      -- Write lock file so external scripts can find this Neovim instance
      local function write_lock_file()
        local socket = vim.v.servername -- Neovim's RPC socket path
        if not socket or socket == "" then
          return
        end
        vim.fn.mkdir(lock_dir, "p")
        local filename = lock_dir .. "/" .. vim.fn.getpid() .. ".lock"
        local content = {
          nvimSocket = socket,
          workspaceFolders = get_workspace_folders(),
          pid = vim.fn.getpid(),
        }
        local f = io.open(filename, "w")
        if f then
          f:write(vim.json.encode(content))
          f:close()
          lock_file = filename
        end
      end

      local function remove_lock_file()
        if lock_file then
          os.remove(lock_file)
          lock_file = nil
        end
      end

      -- Custom provider: publishes socket info but doesn't manage terminals
      ---@type ClaudeCodeTerminalProvider
      local provider = {
        setup = function()
          write_lock_file()
          vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = remove_lock_file,
          })
        end,
        -- No-op terminal methods (we use external terminal)
        open = function() end,
        close = function() end,
        simple_toggle = function() end,
        focus_toggle = function() end,
        toggle = function() end,
        ensure_visible = function() end,
        get_active_bufnr = function() return nil end,
        is_available = function() return true end,
        _get_terminal_for_test = function() return nil end,
      }

      return {
        terminal = {
          provider = provider,
        },
      }
    end,
  },
}
