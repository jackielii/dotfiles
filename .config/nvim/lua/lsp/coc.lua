return {
  { "tpope/vim-scriptease", cmd = { "Messages", "Scriptname" } },

  {
    "Shougo/echodoc.vim",
    event = "VeryLazy",
    init = function()
      vim.g.echodoc_enable_at_startup = 1
      vim.g.echodoc_type = "signature"
    end,
  },

  -- coc.nvim enabled = false,
  {
    -- 'neoclide/coc.nvim',
    dir = "~/personal/coc.nvim",
    branch = "master",
    build = "npm ci",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.coc_node_path = vim.env.HOMEBREW_PREFIX .. "/bin/node"
      vim.g.coc_node_args = { "--max-old-space-size=8192" }

      vim.cmd([[hi! link CocPumSearch @text.uri]])
      -- """"https://github.com/neoclide/coc.nvim/wiki/Debug-coc.nvim
      -- vim.g.node_client_debug = 1
      -- vim.g.coc_node_args = { '--nolazy', '--inspect=6045', '-r',
      --   expand('~/.config/yarn/global/node_modules/source-map-support/register') }
      -- """"
      --
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("coclist", { clear = true }),
        pattern = "list",
        callback = function()
          vim.keymap.set("n", "<C-p>", "<Up>", { buffer = true })
        end,
      })

      vim.g.coc_snippet_next = "<Plug>(coc-snippet-next)"
      vim.g.coc_snippet_prev = "<Plug>(coc-snippet-prev)"
    end,
    dependencies = {
      { dir = "~/personal/coc-go" },
      { dir = "~/personal/coc-java" },
      { dir = "~/personal/coc-java-ext" },
    },
    keys = {
      -- coc
      {
        "<C-Space>",
        "coc#refresh()",
        mode = "i",
        silent = true,
        expr = true,
      },
      {
        "<cr>",
        function()
          if vim.fn["coc#pum#visible"]() ~= 0 then
            return vim.fn["coc#pum#confirm"]()
          else
            return require("nvim-autopairs").autopairs_cr()
          end
        end,
        mode = "i",
        expr = true,
        replace_keycodes = false,
      },
      {
        "<C-e>",
        [[coc#pum#visible() ? coc#pum#cancel() : "\<C-e>")]],
        mode = "i",
        expr = true,
        silent = true,
        replace_keycodes = false,
      },
      {
        "<C-j>",
        [[coc#pum#visible() ? coc#pum#next(0) : coc#jumpable() ? '<Plug>(coc-snippet-next)' : coc#refresh()]],
        mode = "i",
        expr = true,
        remap = true,
        replace_keycodes = false,
      },
      {
        "<C-k>",
        [[coc#pum#visible() ? coc#pum#prev(0) : coc#jumpable() ? '<Plug>(coc-snippet-prev)' : CocActionAsync('showSignatureHelp')]],
        mode = "i",
        expr = true,
        replace_keycodes = false,
      },
      { "<C-j>", "<Plug>(coc-snippet-next)", mode = "s" },
      { "<C-k>", "<Plug>(coc-snippet-prev)", mode = "s" },

      --
      { "<leader>ki", "<cmd>CocCommand git.chunkInfo<cr>" },
      { "<leader>ku", "<cmd>CocCommand git.chunkUndo<cr>" },
      { "]n", "<cmd>CocCommand document.jumpToNextSymbol<cr>", desc = "Coc Next Symbol" },
      {
        "[n",
        "<cmd>CocCommand document.jumpToPrevSymbol<cr>",
        desc = "Coc Previous Symbol",
      },

      --
      -- { '<M-C-k>',    '<Plug>(coc-diagnostic-info)',                                            mode = 'n' },
      {
        "<D-i>",
        "<Plug>(coc-diagnostic-info)",
        mode = "n",
      },
      -- { '<M-C-k>',    [[<C-\><C-o>:call CocAction('diagnosticPreview')<cr>]],                   mode = 'i' },
      {
        "<D-i>",
        [[<C-\><C-o>:call CocAction('diagnosticPreview')<cr>]],
        mode = "i",
      },
      { "<leader>kk", [[<cmd>call CocAction('diagnosticPreview')<cr>]] },
      -- { '<M-i>',      [[<CMD>call CocActionAsync('showSignatureHelp')<cr>]],  mode = { 'i' } },
      -- { '<D-i>',      [[<CMD>call CocActionAsync('showSignatureHelp')<cr>]],  mode = { 'i' } },
      -- nnoremap <leader>gi :call CocAction('runCommand', 'editor.action.organizeImport')<CR>
      { "<leader>gi", [[<cmd>call CocAction('runCommand', 'editor.action.organizeImport')<CR>]] },

      --
      { "<leader>ko", "<cmd>CocOutline<cr>" },
      { "<leader>ho", '<cmd>call CocAction("showOutgoingCalls")<cr>' },
      { "<leader>hi", '<cmd>call CocAction("showIncomingCalls")<cr>' },

      -- go
      {
        "<leader>kgd",
        [[<cmd>lua require('dap-go').debug_tests_in_file()<cr>]],
        desc = "debug tests in file",
      },
      { "<leader>kgr", [[<cmd>CocCommand go.gopls.tidy<cr>]] },
      { "<leader>kgt", [[<cmd>CocCommand go.gopls.runTests<cr>]] },
      { "<leader>kgl", [[<cmd>CocCommand go.gopls.listKnownPackages<cr>]] },

      -- explorer
      { "<leader>F", [[<cmd>execute 'CocCommand explorer '.g:project_path<cr>]] },
      { "<leader>l", [[<cmd>execute 'CocCommand explorer '<cr>]] },

      --
      { "<C-l>", "<Plug>(coc-snippets-select)", mode = "v" },
      { "<C-l>", "<Plug>(coc-snippets-expand)", mode = "i" },
      { "[d", "<Plug>(coc-diagnostic-prev)" },
      { "[D", "<Plug>(coc-diagnostic-prev-error)" },
      { "]d", "<Plug>(coc-diagnostic-next)" },
      { "]D", "<Plug>(coc-diagnostic-next-error)" },
      { "[c", "<Plug>(coc-git-prevchunk)" },
      { "]c", "<Plug>(coc-git-nextchunk)" },
      { "gd", "<Plug>(coc-definition)" },
      { "gy", "<Plug>(coc-type-definition)" },
      { "gI", "<Plug>(coc-implementation)" },
      { "gr", "<Plug>(coc-references)" },

      { "<leader>rn", [[<Plug>(coc-rename)]] },

      -- nmap <leader>rf <Plug>(coc-refactor)
      -- " Remap keys for apply refactor code actions.
      -- nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
      -- xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
      -- nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
      { "<leader>rf", [[<Plug>(coc-refactor)]] },
      { "<leader>re", [[<Plug>(coc-codeaction-refactor)]] },
      { "<leader>r", [[<Plug>(coc-codeaction-refactor-selected)]], mode = { "n", "x" } },

      -- " Remap for format selected region
      { "<leader>gf", [[<Plug>(coc-format-selected)]], mode = { "n", "x" } },
      { "<leader>kf", [[<cmd>call CocAction('format')<cr>]] },
      {
        "K",
        function()
          local ft = vim.bo.filetype
          if ft == "vim" or ft == "help" then
            vim.cmd([[execute 'h '.expand('<cword>')]])
          else
            vim.fn["CocActionAsync"]("doHover")
          end
        end,
      },

      --
      { "<leader>a", [[<Plug>(coc-codeaction-selected)]], mode = { "v", "n" } },
      { "<leader>ac", [[<Plug>(coc-codeaction-line)]], mode = { "n" } },
      { "<leader>ag", [[<Plug>(coc-codeaction-source)]], mode = { "n" } },
      { "<leader>qf", [[<Plug>(coc-fix-current)]], mode = { "n" } },
      { "<F9>", [[<Plug>(coc-fix-current)]], mode = { "n" } },
      { "<C-w>f", [[<cmd>call coc#float#jump()<cr>]], mode = { "n" } },
      {
        "<C-f>",
        [[coc#float#has_float() ? coc#float#scroll(1,1) : "\<C-f>"]],
        mode = { "n", "i", "v" },
        expr = true,
      },
      {
        "<C-b>",
        [[coc#float#has_float() ? coc#float#scroll(0,1) : "\<C-b>"]],
        mode = { "n", "i", "v" },
        expr = true,
      },
      { "<F7>", "<cmd>call coc#float#close_all()<cr><cmd>nohl<cr>", mode = { "n", "i" } },

      -- " Using CocList
      -- " Show all diagnostics
      -- nnoremap <silent> <leader>ds :<C-u>CocList outline<cr>
      -- nnoremap <silent> <leader>da :<C-u>CocList diagnostics<cr>
      -- nnoremap <silent> <leader>dl :<C-u>CocList symbols<cr>
      { "<leader>ds", "<cmd>CocList outline<cr>" },
      { "<leader>da", "<cmd>CocList diagnostics<cr>" },
      { "<leader>dl", "<cmd>CocList symbols<cr>" },
      { "<leader>cr", "<cmd>CocListResume<cr>" },
      -- " nnoremap <silent> <leader>dr :<C-u>CocListResume<cr>
      --
      -- " Manage extensions
      -- nnoremap <silent> <leader>ce  :<C-u>CocList extensions<cr>
      -- nnoremap <silent> <leader>cm  :<C-u>CocList marketplace<cr>
      { "<leader>ce", "<cmd>CocList extensions<cr>" },
      { "<leader>cm", "<cmd>CocList marketplace<cr>" },

      -- " Show commands
      -- nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
      -- nnoremap <silent> <leader>cl  :<C-u>CocList<cr>
      -- nnoremap <silent> <leader>co  :CocCommand workspace.showOutput<cr>
      { "<leader>cc", "<cmd>CocList commands<cr>" },
      { "<leader>cl", "<cmd>CocList<cr>" },
      { "<leader>co", "<cmd>CocCommand workspace.showOutput<cr>" },
      -- " Do default action for next item.
      -- " nnoremap <silent> <leader>gj  :<C-u>CocNext<cr>
      -- nnoremap <silent> ]g  :<C-u>CocNext<cr>
      -- " Do default action for previous item.
      -- " nnoremap <silent> <leader>gk  :<C-u>CocPrev<cr>
      -- nnoremap <silent> [g  :<C-u>CocPrev<cr>
      { "]g", "<cmd>CocNext<cr>" },
      { "[g", "<cmd>CocPrev<cr>" },
      -- " Resume latest coc list
      -- nnoremap <silent> <leader>cr  :CocRestart<cr>
      -- nnoremap <silent> <leader>p  :<C-u>CocListResume<cr>
      -- nnoremap <silent> <leader>ct  :<C-u>CocList tasks<cr>
      { "<leader>cR", "<cmd>CocRestart<cr>" },
      { "<leader>P", "<cmd>CocListResume<cr>" },
      { "<leader>ct", "<cmd>CocList tasks<cr>" },
      -- nnoremap <leader>cs :CocSearch<space>
      { "<leader>cs", ":CocSearch<space>" },
    },
    config = function()
      vim.api.nvim_create_autocmd("CursorHold", {
        pattern = "*",
        command = [[call CocActionAsync('highlight')]],
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "CocJumpPlaceholder",
        command = [[call CocActionAsync('showSignatureHelp')]],
      })
      --
      vim.fn["coc#config"]("python.formatting.blackPath", vim.env.HOMEBREW_PREFIX .. "/bin/black")
      --
      -- autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        command = [[silent call CocAction('runCommand', 'editor.action.organizeImport')]],
      })
    end,
  },
}
