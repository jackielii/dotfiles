return {
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_compiler_method = 'generic'
      vim.g.vimtex_compiler_generic = {
        command = 'air-tex'
      }
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("vimtexcompile", { clear = true }),
        pattern = "tex",
        callback = function()
          vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile %<cr>", { buffer = true })
          require('nvim-autopairs').disable()
        end,
      })
      -- vim.g.vimtex_compiler_tectonic = {
      --   out_dir = '',
      --   hooks = {},
      --   options = {
      --     "--synctex",
      --     "--keep-logs",
      --   }
      -- }
      vim.g.vimtex_view_method = 'skim'
    end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "latex",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              build = {
                executable = "tectonic",
                args = {
                  "-X",
                  "compile",
                  "%f",
                  "--synctex",
                  "--keep-logs",
                  "--keep-intermediates"
                },
              }
            }
          }
        }
      }
    }
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "texlab" })
    end,
  },
}
