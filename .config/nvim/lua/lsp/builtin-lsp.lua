local Util = require("lazyvim.util")

return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      { "folke/neodev.nvim", opts = {} },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          -- prefix = "●",
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          prefix = "icons",
        },
        severity_sort = true,
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = false,
      },
      -- add any global capabilities here
      capabilities = {},
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      semantic_tokens = false,
      -- LSP Server Settings
      -- -@type lspconfig.options
      servers = {
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          -- Use this to add any additional keymaps
          -- for specific lsp servers
          ---@type LazyKeysSpec[]
          -- keys = {},
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      if Util.has("neoconf.nvim") then
        local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
        require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
      end

      -- setup autoformat
      Util.format.register(Util.lsp.formatter())

      local function lsp_keymaps(buffer)
        local k = function(keys, func, desc, mode)
          if desc then
            desc = "LSP: " .. desc
          end
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = buffer or true, desc = desc })
        end

        k("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

        _G.__code_action_operator = function(type)
          local range = {
            start = vim.api.nvim_buf_get_mark(0, "["),
            ["end"] = vim.api.nvim_buf_get_mark(0, "]"),
          }
          vim.lsp.buf.code_action({ range = range })
        end
        k("<leader>a", "<Esc><cmd>set operatorfunc=v:lua.__code_action_operator<CR>g@", "Code Action Operator")
        k("<leader>a", vim.lsp.buf.code_action, "[C]ode [A]ction", { "v" })
        k("<leader>ac", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n" })
        k("<leader>ag", function()
          vim.lsp.buf.code_action({
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          })
        end, "Source Action")

        k("<leader>gi", function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = { "source.organizeImports" },
              diagnostics = {},
            },
          })
        end, "Organize Imports")

        k("<leader>qf", function()
          -- vim.lsp.buf.code_action({
          --   apply = true,
          --   context = {
          --     only = { "quickfix" },
          --     diagnostics = {},
          --   },
          -- })
          vim.lsp.buf.code_action({
            filter = function(a)
              P(a)
              return a.kind == 'quickfix'
            end,
            apply = true,
          })
        end, "Quick Fix")

        local provider = require("telescope.builtin")
        -- local provider = require("fzf-lua")
        local goto = function(handler, opts)
          opts = opts or { ignore_current_line = true, jump_to_single_result = true }
          return function()
            provider[handler](opts)
          end
        end
        k("gd", function()
          provider.lsp_definitions({ ignore_current_line = true, jump_to_single_result = true })
        end, "[G]oto [D]efinition")
        k("gr", goto("lsp_references"), "[G]oto [R]eferences")
        k("gI", goto("lsp_implementations"), "[G]oto [I]mplementation")
        -- k("gy", goto("lsp_typedefs"), "Type [D]efinition") -- fzf-lua
        k("gy", goto("lsp_type_definitions"), "Type [D]efinition")
        k("<leader>ds", goto("lsp_document_symbols", {}), "[D]ocument [S]ymbols")
        k("<leader>da", goto("diagnostics", {}), "Workspace Diagnostics")
        k("<leader>dl", goto("lsp_dynamic_workspace_symbols", {}), "[W]orkspace [S]ymbols")
        -- k("<leader>dl", goto("lsp_live_workspace_symbols", {}), "[W]orkspace [S]ymbols")

        -- See `:help K` for why this keymap
        k("K", vim.lsp.buf.hover, "Hover Documentation")
        k("gK", vim.lsp.buf.signature_help, "Signature Help")

        k("<C-k>", function()
          local cmp = require("cmp")
          local snip = require("luasnip")
          if cmp.visible() then
            cmp.select_prev_item()
          elseif snip.jumpable(-1) then
            snip.jump(-1)
          else
            vim.lsp.buf.signature_help()
          end
        end, "Signature Documentation", "i")
        k("<D-i>", vim.lsp.buf.signature_help, "Signature Documentation", "i")

        -- Lesser used LSP functionality
        k("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        k("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
        k("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
        k("<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist Folders")

        k("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "v" })
        k("<leader>cA", function()
          vim.lsp.buf.code_action({
            context = {
              only = { "source" },
              diagnostics = {},
            },
          })
        end, "Source Action")
      end

      -- setup keymaps
      Util.lsp.on_attach(function(client, buffer)
        lsp_keymaps(buffer)
      end)

      local register_capability = vim.lsp.handlers["client/registerCapability"]

      vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        -- local client_id = ctx.client_id
        ---@type lsp.Client
        -- local client = vim.lsp.get_client_by_id(client_id)
        -- local buffer = vim.api.nvim_get_current_buf()
        lsp_keymaps()
        -- require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
        return ret
      end

      -- diagnostics
      for name, icon in pairs(require("lazyvim.config").icons.diagnostics) do
        -- P(name)
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      if opts.inlay_hints.enabled then
        Util.lsp.on_attach(function(client, buffer)
          if client.supports_method("textDocument/inlayHint") then
            Util.toggle.inlay_hints(buffer, true)
          end
        end)
      end

      if not opts.semantic_tokens then
        Util.lsp.on_attach(function(client, buffer)
          client.server_capabilities.semanticTokensProvider = nil
        end)
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
          or function(diagnostic)
            local icons = require("lazyvim.config").icons.diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
      end

      if Util.lsp.get_config("denols") and Util.lsp.get_config("tsserver") then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        Util.lsp.disable("tsserver", is_deno)
        Util.lsp.disable("denols", function(root_dir)
          return not is_deno(root_dir)
        end)
      end
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        -- "flake8",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
}
