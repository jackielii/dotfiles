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
  -- {
  --   "vrischmann/tree-sitter-templ",
  --   dir = "~/personal/tree-sitter-templ",
  --   config = function()
  --     -- For debugging the Templ parser
  --     local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
  --     parser_configs.templ = {
  --       install_info = {
  --         url = "/Users/jackieli/personal/tree-sitter-templ",
  --         files = {
  --           "src/parser.c",
  --           "src/scanner.c",
  --         },
  --       },
  --     }
  --   end,
  -- },

  -- {
  --   "stevearc/conform.nvim",
  --   optional = true,
  --   opts = {
  --     formatters_by_ft = {
  --       templ = { "local_templ" },
  --     },
  --     formatters = {
  --       local_templ = {
  --         command = "/Users/jackieli/go/bin/templ",
  --         args = { "fmt", "-stdin-filepath", "$FILENAME" },
  --         stdin = true,
  --       },
  --     },
  --   },
  -- },

  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.filetype.add({ extension = { templ = "templ" } })
    end,
    opts = {
      servers = {
        -- templ = false,
        -- templ = {
        --   cmd = { vim.env.HOME .. "/go/bin/templ", "lsp" },
        --   -- cmd = { "templ", "lsp" },
        -- },
        -- htmx = {
        --   filetypes = { "html", "templ" },
        -- },
        html = {
          -- filetypes = { "html", "htm", "templ" },
          filetypes = { "html", "htm" },
        },
        -- emmet_ls = {
        --   filetypes = { "html", "htm", "htmx", "templ" },
        -- },
      },
      setup = {
        htmx = function ()
          return true
        end,
        templ = function()
          -- disable templ, use built-in vim.lsp.config
          -- https://www.lazyvim.org/plugins/lsp#nvim-lspconfig
          vim.lsp.enable("templ")
          return true
        end,
        -- templ = function(_, opts)
        --   vim.lsp.enable("templ")
        -- end,
        -- html = function(_, opts)
        --   LazyVim.lsp.on_attach(function(client, buffer)
        --     local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer })
        --     if ft == "templ" then
        --       client.server_capabilities.documentSymbolProvider = false
        --     end
        --   end, "html")
        -- end,
        -- templ = function(_, opts)
        --   LazyVim.lsp.on_attach(function(client, buffer)
        --     client.capabilities = require("blink.cmp").get_lsp_capabilities({
        --       textDocument = { completion = { completionItem = { additionalTextEdits = false } } },
        --     })
        --   end, "templ")
        -- end,
      },
    },
  },

  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        providers = {
          lsp = {
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                -- templ makes this mistake if a completion item is not exactly a string type
                -- it adds a additionalTextEdits that gets inserted into the import section
                -- and also adds a ) at the end of the completion item
                if item.client_name == "templ" then
                  if item.additionalTextEdits ~= nil then
                    if not string.find(item.additionalTextEdits[1].newText, '"') then
                      item.additionalTextEdits = nil
                      if
                        item.textEdit ~= nil
                        and item.textEdit.newText ~= nil
                        and item.textEdit.newText:sub(-1) == ")"
                        and item.textEdit.newText:sub(-2, -1) ~= "()"
                      then
                        item.textEdit.newText = item.textEdit.newText:sub(1, -2)
                      end
                    end
                  end
                  item.score_offset = 100
                end
              end
              return items
            end,
          },
        },
      },
    },
  },
}
