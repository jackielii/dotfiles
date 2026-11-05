nvimpager.maps = false

local follow_timer = nil
local function toggle_follow()
  if follow_timer ~= nil then
    vim.fn.timer_pause(follow_timer, nvimpager.follow)
    nvimpager.follow = not nvimpager.follow
  else
    follow_timer = vim.fn.timer_start(nvimpager.follow_interval, function()
      vim.api.nvim_command("silent checktime")
      vim.api.nvim_command("silent $")
    end, { ["repeat"] = -1 })
    nvimpager.follow = true
  end
  vim.cmd("redrawstatus")
end

local map = vim.keymap.set
map("n", "q", "<CMD>quitall!<CR>")
map("v", "q", "<CMD>quitall!<CR>")
map("n", "<Space>", "<PageDown>")
map("n", "<C-Space>", "<PageUp>")
map("n", "g", "gg")
map("n", "<Up>", "<C-Y>")
map("n", "<Down>", "<C-E>")
map("n", "F", toggle_follow)
map("n", "yow", "<cmd>set wrap!<cr>", { desc = "Toggle wrap" })
map("n", "yol", "<cmd>set list!<cr>", { desc = "Toggle list" })

vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.exrc = false

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  local_spec = false,
  spec = {
    {
      -- https://github.com/numToStr/Navigator.nvim/pull/26
      "craigmac/Navigator.nvim",
      keys = {
        { "<C-h>", [[<cmd>NavigatorLeft<cr>]], desc = "NavigatorLeft" },
        { "<C-j>", [[<cmd>NavigatorDown<cr>]], desc = "NavigatorDown" },
        { "<C-k>", [[<cmd>NavigatorUp<cr>]], desc = "NavigatorUp" },
        { "<C-l>", [[<cmd>NavigatorRight<cr>]], desc = "NavigatorRight" },
      },
      opts = {},
    },
    {
      "RRethy/nvim-base16",
      init = function()
        local base16_theme = "decaf"
        if vim.env.BASE16_THEME and vim.env.BASE16_THEME ~= "" then
          base16_theme = vim.env.BASE16_THEME
        end
        if not vim.g.colors_name or vim.g.colors_name ~= "base16-" .. base16_theme then
          vim.cmd.colorscheme("base16-" .. base16_theme)
        end
      end,
    },
    {
      "folke/flash.nvim",
      -- event = "VeryLazy",
      opts = {
        modes = {
          char = { enabled = false },
          search = { enabled = false },
          remote = { enabled = false },
        },
        -- jump = { autojump = true },
      },
      keys = {
        { "r", mode = "o", false }, -- tpope/vim-abolish
        { "S", mode = { "x", "v" }, false }, -- kylechui/nvim-surround
        {
          "s",
          mode = { "n" },
          function()
            require("flash").jump()
          end,
          desc = "Flash",
        },
        {
          "z",
          mode = "o",
          function()
            require("flash").remote()
          end,
          desc = "Remote Flash",
        },
        {
          "S",
          mode = { "n" },
          function()
            require("flash").treesitter()
          end,
          desc = "Flash visual Treesitter",
        },
        {
          "R",
          mode = { "o", "x" },
          function()
            require("flash").treesitter()
          end,
          desc = "Treesitter Search",
        },
      },
    },
  },
})

map("n", "<D-a>", "ggVG")
map("i", "<D-a>", "<esc>ggVG")
map({ "v" }, "<D-c>", '"+y', { silent = true, noremap = true })
map({ "n" }, "<D-c>", function()
  local reg = vim.fn.getreg('"')
  if reg == "" then
    vim.cmd('normal! gv"+y')
  else
    vim.fn.setreg("+", reg)
  end
end, { silent = true, noremap = true })

map("n", "d", "<C-d>")
map("n", "u", "<C-u>")

map("n", "j", "gj")
map("n", "k", "gk")

vim.cmd([[ function! MoveByWord(flag)
  if mode() == 'v' | execute "norm! gv" | endif
  for n in range(v:count1)
    call search('\v(\w|_|-)+', a:flag, line('.'))
  endfor
endfunction ]])

map({ "n", "v" }, "H", '<cmd>call MoveByWord("b")<cr>', { silent = true })
map({ "n", "n" }, "L", '<cmd>call MoveByWord("")<cr>', { silent = true })

vim.opt.laststatus = 3
vim.opt.statusline = "%{luaeval('nvimpager.follow') ? '[Following] ' : ''}%f"
vim.opt.cmdheight = 0
