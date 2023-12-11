local map = vim.keymap.set
local kitty_data;
vim.o.clipboard = 'unnamedplus'
vim.o.shada = ''

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
      require('kitty-scrollback').setup({
        global = function()
          return {
            keymaps_enabled = false,
            paste_window = {
              filetype = 'ksb_paste'
            },
            callbacks = {
              after_setup = function(kd)
                kitty_data = kd
              end,
            }
          }
        end
      })

      require('kitty-scrollback.backport').setup()

      local ksb_api = require('kitty-scrollback.api')
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'ksb_paste',
        callback = function(args)
          local ksb_kitty_cmds = require('kitty-scrollback.kitty_commands')
          local bufid = args.buffer or true
          vim.keymap.set({ 'n', 'i' }, '<C-CR>', function()
            ksb_kitty_cmds.send_paste_buffer_text_to_kitty_and_quit(true)
          end, { buffer = bufid })
          vim.keymap.set({ 'n', 'i' }, '<S-CR>', function()
            ksb_kitty_cmds.send_paste_buffer_text_to_kitty_and_quit(false)
          end, { buffer = bufid })
          vim.keymap.set({ 'n' }, 'g?', ksb_api.toggle_footer, { buffer = bufid })
          -- set_default({ 'n' }, 'g?', '<Plug>(KsbToggleFooter)', {})
          -- set_default({ 'n', 'i' }, '<c-cr>', '<Plug>(KsbExecuteCmd)', {})
          -- set_default({ 'n', 'i' }, '<s-cr>', '<Plug>(KsbPasteCmd)', {})
          -- require('kitty-scrollback.')
          -- local opts = { buffer = true }
          -- print('ksb_paste')
          -- map({ 'n', 'i' }, '<C-CR>', ksb_api.execute_command)
          -- map({ 'n', 'i' }, '<S-CR>', ksb_api.paste_command)
          -- map({ 'n', 'i' }, '<C-CR>', '<Plug>(KsbExecuteCmd)', opts)
          -- map({ 'n', 'i' }, '<S-CR>', '<Plug>(KsbPasteCmd)', opts)
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
