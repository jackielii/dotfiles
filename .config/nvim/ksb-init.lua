local map = vim.keymap.set
local kitty_data;
vim.o.clipboard = 'unnamedplus'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  {
    -- https://github.com/numToStr/Navigator.nvim/pull/26
    'craigmac/Navigator.nvim',
    keys = {
      { '<C-h>', [[<cmd>NavigatorLeft<cr>]],     desc = "NavigatorLeft" },
      { '<C-j>', [[':NavigatorDown<cr>']],       desc = "NavigatorDown",    expr = true, silent = true },
      { '<C-k>', [[':NavigatorUp<cr>']],         desc = "NavigatorUp",      expr = true, silent = true },
      { '<C-l>', [[<cmd>NavigatorRight<cr>]],    desc = "NavigatorRight" },
      { '<M-`>', [[<cmd>NavigatorPrevious<cr>]], desc = "NavigatorPrevious" },
      { '<D-`>', [[<cmd>NavigatorPrevious<cr>]], desc = "NavigatorPrevious" },
    },
    opts = {},
  },

  {
    'RRethy/nvim-base16',
    config = function()
      if vim.fn.exists('$BASE16_THEME') and (not vim.g.colors_name or vim.g.colors_name ~= 'base16-$BASE16_THEME') then
        vim.g.base16colorspace = 256
        vim.cmd('colorscheme base16-$BASE16_THEME')
      end
    end
  },

  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", 'x', 'o' }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", 'x', 'o' }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },

  {
    'tyru/open-browser.vim',
    keys = {
      { 'gx', [[<Plug>(openbrowser-smart-search)]], desc = "open browser", mode = { 'n', 'v' } },
    },
  },

  {
    dir = '~/personal/kitty-scrollback.nvim',
    config = function()
      local ksb_api = require('kitty-scrollback.api')
      require('kitty-scrollback.backport').setup()

      vim.api.nvim_create_autocmd('filetype', {
        pattern = 'ksb_paste',
        callback = function(args)
          local opts = { buffer = args.buffer }
          map({ 'n' }, 'p', '<Plug>(KsbPaste)', opts)
          map({ 'n', 'i' }, '<c-cr>', ksb_api.execute_command, opts)
          map({ 'n', 'i' }, '<s-cr>', ksb_api.paste_command, opts)
        end
      })

      map({ 'n', 'v' }, ' ', 'v')

      map({ 'v' }, '<C-y>', [["+y]], {})

      map({ 'v' }, 'Y', function()
        local txt = buf_vtext()
        vim.system({ 'kitty', '@', 'send-text', '--match=id:' .. kitty_data.window_id, txt })
        require('kitty-scrollback.kitty_commands').signal_term_to_kitty_child_process(true)
      end, {})

      map({ 'n', 't', 'v' }, 'q', ksb_api.quit_all, {})
      map({ 'n' }, '<Esc>', ksb_api.close_or_quit_all, {})
      map({ 'n', 't', 'i' }, 'ZZ', ksb_api.quit_all, {})

      map('n', 'K', function()
        local ft = vim.bo.filetype
        if ft == "vim" or ft == "help" then
          vim.cmd [[execute 'h '.expand('<cword>')]]
        else
          vim.cmd [[execute &keywordprg . " " . expand('<cword>')]]
        end
      end)

      require('kitty-scrollback').setup({
        keymaps_enabled = false,
        paste_window = {
          filetype = 'ksb_paste'
        },
        callbacks = {
          after_setup = function(kd)
            kitty_data = kd
          end,
        }
      })
    end
  }

})

function _G.buf_vtext()
  -- local a_orig = vim.fn.getreg('*')
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' then
    vim.cmd([[normal! gv]])
  end
  vim.cmd([[silent! normal! "*ygv]])
  local text = vim.fn.getreg('*')
  -- vim.fn.setreg('a', a_orig)
  return text
end

-- local Plug = vim.fn['plug#']
--
-- vim.call('plug#begin', '~/.config/nvim/plugged')
-- Plug 'craigmac/Navigator.nvim'
-- Plug 'RRethy/nvim-base16'
-- Plug 'folke/flash.nvim'
-- Plug 'tyru/open-browser.vim'
-- Plug '~/personal/kitty-scrollback.nvim'
-- vim.call('plug#end')
--
-- vim.cmd [[ colorscheme base16-decaf ]]
-- vim.o.clipboard = 'unnamedplus'
--
-- local map = vim.keymap.set
-- require("flash").setup {}
-- map({ "n", "x", "o" }, "s", function() require("flash").jump() end)
--
-- require('Navigator').setup {}
-- map({ 'n', 't' }, '<C-h>', function() require("Navigator").left() end)
-- map({ 'n', 't' }, '<C-j>', function() require("Navigator").down() end)
-- map({ 'n', 't' }, '<C-k>', function() require("Navigator").up() end)
-- map({ 'n', 't' }, '<C-l>', function() require("Navigator").right() end)
-- map({ 'n', 't' }, '<M-`>', function() require("Navigator").previous() end)
-- map({ 'n', 't' }, '<D-`>', function() require("Navigator").previous() end)
--
-- map('n', 'gx', '<Plug>(openbrowser-smart-search)')
-- map('v', 'gx', '<Plug>(openbrowser-smart-search)')
--

-- local map = vim.keymap.set
-- local kitty_data;
--
-- map({ 'n', 'v' }, ' ', 'v')
-- local ksb_api = require('kitty-scrollback.api')
--
-- vim.api.nvim_create_autocmd('filetype', {
--   pattern = 'ksb_paste',
--   callback = function(args)
--     local opts = { buffer = args.buffer }
--     map({ 'n' }, 'p', '<Plug>(KsbPaste)', opts)
--     map({ 'n', 'i' }, '<c-cr>', ksb_api.execute_command, opts)
--     map({ 'n', 'i' }, '<s-cr>', ksb_api.paste_command, opts)
--   end
-- })
--
-- map({ 'v' }, '<C-y>', function()
--   vim.cmd [[ normal! "+y ]]
--   ksb_api.quit_all()
-- end, {})
--
-- map({ 'v' }, 'Y', function()
--   vim.cmd [[ normal! "+y ]]
--   local util = require('kitty-scrollback.util')
--   local cmds = require('kitty-scrollback.kitty_commands')
--
--   local txt = vim.fn.getreg('+')
--   util.vim_system({
--     'kitty',
--     '@',
--     'send-text',
--     '--match=id:' .. kitty_data.window_id,
--     txt
--   })
--   cmds.signal_term_to_kitty_child_process(true)
-- end, {})
--
-- map({ 'n' }, 'q', ksb_api.quit_all, {})
-- map({ 'n', 't', 'i' }, '<Esc>', ksb_api.close_or_quit_all, {})
-- map({ 'n', 't', 'i' }, 'ZZ', ksb_api.quit_all, {})
--
-- require('kitty-scrollback').setup({
--   keymaps_enabled = false,
--   paste_window = {
--     filetype = 'ksb_paste'
--   },
--   callbacks = {
--     after_setup = function(kd)
--       kitty_data = kd
--     end,
--     -- after_ready = function(kd, opts, p)
--     --   map({ 'n' }, 'q', '<Plug>(KsbCloseOrQuitAll)', {})
--     -- end,
--   }
-- })
