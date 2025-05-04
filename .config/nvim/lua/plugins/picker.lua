local function toggle_dir(up)
  return function(picker, item)
    local path = picker:cwd()
    if not up then
      path = picker:dir()
    else
      path = vim.fs.dirname(path)
    end
    picker.title = pretty_path(path)
    picker:set_cwd(path)
    picker.input.filter.paths = { [path] = true }
    picker:find({ refresh = true })
    vim.api.nvim_buf_set_lines(picker.input.win.buf, 0, -1, false, { "" })

    -- picker.input.filter.search = ""
    -- picker.input.filter.all = false
    -- picker:update({ force = true })
    -- picker.list.update()
    -- picker.input:update()
    -- picker.input = picker.input.new(picker)
    -- P(picker.input.set("", ""))
    -- picker.input.set("", "")
    -- picker.list.update()

    -- local path = picker:dir()
    -- -- require("snacks.picker").files({
    -- local ref = picker:ref()
    -- ref.new({
    --   cwd = path,
    --   -- pattern = picker:filter().pattern,
    --   filter = { paths = { [path] = true } },
    -- })
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

              ["<C-l>"] = { "toggle_dir_in", mode = "i" },
              ["<C-h>"] = { "toggle_dir_up", mode = "i" },
            },
          },
          list = {
            keys = {
              ["<c-j>"] = false,
              ["<C-e>"] = "list_down",
              ["<C-y>"] = "list_up",
              ["<c-k>"] = false,
            },
          },
        },
        actions = {
          toggle_dir_in = toggle_dir(false),
          toggle_dir_up = toggle_dir(true),
        },
        sources = {
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
