local function augroup(name)
  return vim.api.nvim_create_augroup("jl_" .. name, { clear = true })
end
return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    enabled = false,
    keys = {
      { "<M-n>", desc = "Visual Multi find under", mode = { "n", "v" } },
      { "<C-Up>", desc = "Visual Multi up" },
      { "<C-Down>", desc = "Visual Multi down" },
      { [["\\gS"]], desc = "Visual Multi reselect" },
      { [["\\A"]], desc = "Visual Multi select all" },
      { [["\\/"]], desc = "Visual Multi regex" },
    },
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<A-n>",
        ["Find Subword Under"] = "<A-n>",
        ["Switch Mode"] = "v",
        -- ["I BS"]               = '', -- disable backspace mapping
      }
      vim.g.VM_theme = "ocean"
      vim.g.VM_set_statusline = 3
      vim.api.nvim_create_autocmd("User", {
        group = augroup("my_visual_multi_start"),
        pattern = "visual_multi_start",
        callback = function()
          vim.b["minipairs_disable"] = true
          -- require("nvim-autopairs").disable()
          require("lualine").hide()
          -- local lualine = pcall(require, "lualine")
          -- if lualine then
          --   lualine.hide()
          -- end
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        group = augroup("my_visual_multi_exit"),
        pattern = "visual_multi_exit",
        callback = function()
          vim.b["minipairs_disable"] = false
          -- require("nvim-autopairs").enable()
          -- require("nvim-autopairs").force_attach()
          require("lualine").hide({ unhide = true })
          -- local lualine = pcall(require, "lualine")
          -- if lualine then
          --   lualine.hide({ unhide = true })
          -- end
        end,
      })
      -- -- autocmd User visual_multi_mappings  imap <buffer><expr> <CR> pumvisible() ? "\<C-Y>" : "\<Plug>(VM-I-Return)"
      -- vim.api.nvim_create_autocmd("User", {
      --   group = augroup("my_visual_multi"),
      --   pattern = "visual_multi_mappings",
      --   command = [[imap <buffer><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<Plug>(VM-I-Return)"]],
      -- })
      vim.api.nvim_create_autocmd("User", {
        group = augroup("my_visual_multi_mapping"),
        pattern = "visual_multi_mappings",
        -- command = [[imap <buffer><expr> <CR> v:lua.require'cmp'.visible() ? v:lua.require'cmp'.confirm() : "\<Plug>(VM-I-Return)"]],
        callback = function()
          vim.keymap.set("i", "<CR>", function()
            if require("cmp").visible() then
              require("cmp").confirm({ select = true })
              return "<NOP>"
            end
            return "<Plug>(VM-I-Return)"
          end, { buffer = true, expr = true })
        end,
      })
    end,
  },
}
