return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.filetype.add({ extension = { templ = "templ" } })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "templ",
        callback = function()
          ---@diagnostic disable-next-line: inject-field
          vim.b.autoformat = true
          vim.o.commentstring = "// %s"
        end,
      })
    end,
    opts = {
      servers = {
        htmx = {
          filetypes = { "html", "templ" },
        },
        html = {
          filetypes = { "html", "htm", "htmx", "templ" },
        },
        templ = {
          cmd = { "templ", "lsp" },
        },
        -- emmet_ls = {
        --   filetypes = { "html", "htm", "htmx", "templ" },
        -- },
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
