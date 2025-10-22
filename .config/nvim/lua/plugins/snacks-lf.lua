-- snacks-lf.nvim integration
return {
  {
    "jackielii/snacks-lf.nvim",
    dir = "~/personal/snacks-lf.nvim", -- Optional: use local dev version
    dev = true,
    dependencies = {
      "folke/snacks.nvim",
    },
    keys = {
      {
        "<leader>l",
        function()
          require("snacks-lf").toggle()
        end,
        desc = "Lf file manager",
      },
    },
    opts = {
      resize_key = "R",
    },
  },

  -- {
  --   "jackielii/vim-floaterm",
  --   keys = {
  --     -- {
  --     --   "<F18>",
  --     --   "<cmd>FloatermToggle<cr>",
  --     --   mode = { "n", "t", "i" },
  --     -- },
  --     -- {
  --     --   "<C-/>",
  --     --   "<cmd>FloatermToggle<cr>",
  --     --   mode = { "n", "t", "i", "t" },
  --     -- },
  --     -- {
  --     --   "<F6>",
  --     --   "<cmd>FloatermNew --title=lazygit lazygit<cr>",
  --     --   mode = { "n", "i" },
  --     -- },
  --     -- o is mapped to open file in lf, so here we want it to use system open
  --     {
  --       "<leader>l",
  --       function()
  --         local fn = vim.fn.expand("%:p")
  --         -- if file doesn't exist, open directory
  --         if vim.fn.filereadable(fn) == 0 then
  --           fn = vim.g.project_path or vim.getcwd()
  --         end
  --         vim.cmd(
  --           "FloatermNew --name=Lf --title=Lf lf -command 'map l open;map o ${{open $f}};set sortby name;set noreverse' '"
  --             .. fn
  --             .. "'"
  --         )
  --       end,
  --       desc = "Lf",
  --     },
  --   },
  --   init = function()
  --     vim.g.floaterm_width = 0.8
  --     vim.g.floaterm_height = 0.9
  --     vim.g.floaterm_title = "Terminal"
  --     vim.g.floaterm_titleposition = "left"
  --   end,
  --   config = function()
  --     vim.api.nvim_create_autocmd("VimResized", {
  --       group = augroup("resize-floaterm"),
  --       pattern = "*",
  --       callback = function(args)
  --         if string.find("floaterm", vim.bo.filetype) then
  --           vim.cmd([[FloatermUpdate]])
  --         end
  --       end,
  --     })
  --     vim.api.nvim_create_autocmd("FileType", {
  --       group = augroup("lf-mappings"),
  --       pattern = "floaterm",
  --       callback = function(args)
  --         if vim.b.floaterm_name ~= "Lf" then
  --           return
  --         end
  --         vim.b.floaterm_opener = "edit"
  --         local maps = {
  --           ["<C-t>"] = "tabedit",
  --           ["<C-s>"] = "split",
  --           ["<C-v>"] = "vsplit",
  --         }
  --         for k, v in pairs(maps) do
  --           map(
  --             "t",
  --             k,
  --             '<cmd>let b:floaterm_opener = "' .. v .. '"<cr><cmd>call feedkeys("l", "i")<cr>',
  --             { buffer = true }
  --           )
  --         end
  --
  --         -- HACK: remove old buffer if renamed in Lf
  --         vim.api.nvim_create_autocmd("TermLeave", {
  --           group = augroup("lf-rename"),
  --           callback = function()
  --             for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  --               local fn = vim.api.nvim_buf_get_name(buf)
  --               if not vim.bo[buf].readonly and fn ~= "" and vim.fn.filereadable(fn) ~= 1 then
  --                 local success, msg = pcall(vim.api.nvim_buf_delete, buf, { force = true })
  --                 if not success then
  --                   print("Error deleting buffer: " .. msg)
  --                 end
  --               end
  --             end
  --             vim.api.nvim_clear_autocmds({ event = "TermLeave", group = augroup("lf-rename") })
  --           end,
  --         })
  --       end,
  --     })
  --   end,
  -- },
}
