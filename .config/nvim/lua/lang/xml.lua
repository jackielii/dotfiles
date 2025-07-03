return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        xml = { "xmlformatter1" },
      },
      formatters = {
        xmlformatter1 = {
          command = "xmlformat",
          args = { "-" },
        },
      },
    },
  },
}
