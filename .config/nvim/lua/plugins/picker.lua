---@param dir 'cwd' | 'parent' | 'current'
---@return function
local function toggle_dir(dir)
  return function(picker, item)
    local path = picker:cwd()
    if not dir or dir == "current" then
      path = picker:dir()
    elseif dir == "cwd" then
      path = vim.uv.cwd()
    elseif dir == "parent" then
      path = vim.fs.dirname(path)
    else
      vim.notify("Invalid dir: " .. dir, vim.log.levels.WARN)
    end
    local title = picker.title
    local parts = vim.split(title, " ")
    if #parts > 1 then
      title = parts[1] .. " " .. pretty_path(path)
    else
      title = pretty_path(path)
    end
    picker.title = title
    picker:set_cwd(path)
    picker.input.filter.paths = { [path] = true }
    picker:find({ refresh = true })
  end
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>uC", false },
    },
    ---@type snacks.Config
    opts = {

      picker = {
        layout = {
          cycle = false,
        },
        formatters = {
          file = {
            filename_first = true,
            truncate = 1000,
          },
        },
        win = {
          -- input window
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<C-o>"] = { "toggle_focus", mode = "i" },
              ["<C-u>"] = false,
              ["<C-f>"] = { "list_scroll_down", mode = { "i", "n" } },
              ["<C-b>"] = { "list_scroll_up", mode = { "i", "n" } },
              ["<C-Up>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<C-Down>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<C-Left>"] = { "preview_scroll_left", mode = { "i", "n" } },
              ["<C-Right>"] = { "preview_scroll_right", mode = { "i", "n" } },

              -- custom
              ["<C-l>"] = { "toggle_dir_in", mode = "i" },
              ["<C-h>"] = { "toggle_dir_up", mode = "i" },
              ["<C-BS>"] = { "toggle_dir_up", mode = "i" },
              ["<C-Space>"] = { "toggle_dir_cwd", mode = "i" },
            },
          },
          list = {
            keys = {
              ["<c-j>"] = false,
              ["<c-k>"] = false,
              ["<c-p>"] = false,
              ["<C-e>"] = "list_down",
              ["<C-y>"] = "list_up",
              ["<C-Up>"] = "preview_scroll_up",
              ["<C-Down>"] = "preview_scroll_down",
              ["<C-Left>"] = "preview_scroll_left",
              ["<C-Right>"] = "preview_scroll_right",
              ["<C-Space>"] = "toggle_dir_cwd",
            },
          },
        },
        actions = {
          toggle_dir_in = toggle_dir("current"),
          toggle_dir_up = toggle_dir("parent"),
          toggle_dir_cwd = toggle_dir("cwd"),
        },
        sources = {
          grep = {
            case_sensitive = false, -- New! Define custom variable
            fixed_strings = false, -- Toggle for literal string matching
            toggles = {
              case_sensitive = "s",
              fixed_strings = "f",
            },
            ---@class snacks.Picker
            ---@field [string] unknown
            ---@class snacks.picker.Config
            ---@field [string] unknown

            finder = function(opts, ctx)
              local args_extend = { "--case-sensitive", "--fixed-strings" }
              opts.args = vim
                .iter(opts.args or {})
                :filter(function(val)
                  return not vim.list_contains(args_extend, val)
                end)
                :totable()
              if opts.case_sensitive then
                opts.args = vim.list_extend(opts.args, { "--case-sensitive" })
              end
              if opts.fixed_strings then
                opts.args = vim.list_extend(opts.args, { "--fixed-strings" })
              end
              -- vim.print(opts.args) -- Debug
              return require("snacks.picker.source.grep").grep(opts, ctx)
            end,
            actions = {
              toggle_live_case_sensitive = function(picker) -- [[Override]]
                picker.opts.case_sensitive = not picker.opts.case_sensitive
                picker:find()
              end,
              toggle_live_fixed_strings = function(picker)
                picker.opts.fixed_strings = not picker.opts.fixed_strings
                picker:find()
              end,
            },
            win = {
              input = {
                keys = {
                  ["<M-s>"] = { "toggle_live_case_sensitive", mode = { "i", "n" } },
                  ["<M-f>"] = { "toggle_live_fixed_strings", mode = { "i", "n" } },
                },
              },
            },
          },
          filetypes = {
            name = "filetypes",
            format = "text",
            preview = "none",
            -- layout = { preset = "vscode" },
            confirm = function(picker, item)
              picker:close()
              if item then
                vim.schedule(function()
                  vim.cmd("setfiletype " .. item.text)
                end)
              end
            end,
            finder = function()
              local items = {}
              local filetypes = vim.fn.getcompletion("", "filetype")
              for _, type in ipairs(filetypes) do
                items[#items + 1] = {
                  text = type,
                }
              end
              return items
            end,
          },
        },
      },
    },
  },
}
