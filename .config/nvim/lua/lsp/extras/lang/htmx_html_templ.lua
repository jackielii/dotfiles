return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "templ",
        "html",
      })
    end,
  },
  {
    "vrischmann/tree-sitter-templ",
    dir = "~/personal/tree-sitter-templ",
    config = function()
      -- For debugging the Templ parser
      local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
      parser_configs.templ = {
        install_info = {
          url = "/Users/jackieli/personal/tree-sitter-templ",
          files = {
            "src/parser.c",
            "src/scanner.c",
          },
        },
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.filetype.add({ extension = { templ = "templ" } })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "templ",
        callback = function()
          vim.b.autoformat = true
          vim.bo.shiftwidth = 4
          vim.bo.tabstop = 4
          vim.bo.commentstring = "// %s"
        end,
      })
    end,
    opts = {
      servers = {
        htmx = {
          filetypes = { "html", "templ" },
        },
        html = {
          filetypes = { "html", "htm", "templ" },
          -- filetypes = { "html", "htm" },
        },
        templ = {
          cmd = { "/Users/jackieli/go/bin/templ", "lsp" },
          -- cmd = { "templ", "lsp" },
        },
        -- emmet_ls = {
        --   filetypes = { "html", "htm", "htmx", "templ" },
        -- },
      },
      setup = {
        html = function(_, opts)
          LazyVim.lsp.on_attach(function(client, buffer)
            local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer })
            if ft == "templ" then
              client.server_capabilities.documentSymbolProvider = false
            end
          end, "html")
        end,
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        -- templ = { "/Users/jackieli/go/bin/templ" },
        templ = { "templ" },
      },
    },
  },
}
