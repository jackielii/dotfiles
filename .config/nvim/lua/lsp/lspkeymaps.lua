local M = {}

---@type LazyKeysLspSpec[]|nil
M._keys = nil

---@alias LazyKeysLspSpec LazyKeysSpec|{has?:string|string[], cond?:fun():boolean}
---@alias LazyKeysLsp LazyKeys|{has?:string|string[], cond?:fun():boolean}

---@return LazyKeysLspSpec[]
function M.get()
  if M._keys then
    return M._keys
  end
    -- stylua: ignore
    M._keys =  {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
      { "gd", vim.lsp.buf.definition(), desc = "Goto Definition", has = "definition" },
      { "gr", vim.lsp.buf.references(), desc = "References", nowait = true },
      { "gI", vim.lsp.buf.implementation(), desc = "Goto Implementation" },
      { "gy", vim.lsp.buf.type_definition(), desc = "Goto T[y]pe Definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
      { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
      { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, has = "codeLens" },
      { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
      -- { "<leader>cR", LazyVim.lsp.rename_file, desc = "Rename File", mode ={"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
      -- { "<leader>cA", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
      { "]]", function() LazyVim.lsp.words.jump(vim.v.count1) end, has = "documentHighlight",
        desc = "Next Reference", cond = function() return LazyVim.lsp.words.enabled end },
      { "[[", function() LazyVim.lsp.words.jump(-vim.v.count1) end, has = "documentHighlight",
        desc = "Prev Reference", cond = function() return LazyVim.lsp.words.enabled end },
      { "<a-n>", function() LazyVim.lsp.words.jump(vim.v.count1, true) end, has = "documentHighlight",
        desc = "Next Reference", cond = function() return LazyVim.lsp.words.enabled end },
      { "<a-p>", function() LazyVim.lsp.words.jump(-vim.v.count1, true) end, has = "documentHighlight",
        desc = "Prev Reference", cond = function() return LazyVim.lsp.words.enabled end },
    }

  return M._keys
end

---@param method string|string[]
function M.has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end
  method = method:find("/") and method or "textDocument/" .. method
  local clients = LazyVim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

---@return LazyKeysLsp[]
function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  if not Keys.resolve then
    return {}
  end
  local spec = M.get()
  local opts = LazyVim.opts("nvim-lspconfig")
  local clients = LazyVim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach_lazy(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    local has = not keys.has or M.has(buffer, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

    if has and cond then
      local opts = Keys.opts(keys)
      opts.cond = nil
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

function M.on_attach(_, buffer)
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
    vim.lsp.buf.code_action({
      filter = function(a)
        return a.kind == "quickfix"
      end,
      apply = true,
    })
  end, "Quick Fix")

  local provider = require("telescope.builtin")
  -- local provider = require("fzf-lua")
  local go = function(handler, opts)
    opts = opts
      or {
        include_current_line = false,
        include_declaration = false,
        ignore_current_line = true,
        jump_to_single_result = true,
      }
    return function()
      provider[handler](opts)
    end
  end
  k("gd", function()
    provider.lsp_definitions({ ignore_current_line = true, jump_to_single_result = true })
  end, "[G]oto [D]efinition")
  k("gr", go("lsp_references"), "[G]oto [R]eferences")
  k("gI", go("lsp_implementations"), "[G]oto [I]mplementation")
  -- k("gy", goto("lsp_typedefs"), "Type [D]efinition") -- fzf-lua
  k("gy", go("lsp_type_definitions"), "Type [D]efinition")
  k("<leader>ds", go("lsp_document_symbols", { symbol_width = 70 }), "[D]ocument [S]ymbols")
  k("<leader>da", go("diagnostics", {}), "Workspace Diagnostics")
  k("<leader>dl", go("lsp_dynamic_workspace_symbols", {}), "[W]orkspace [S]ymbols")
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

  ---@param count number
  ---@param cycle? boolean
  local function jump(count, cycle)
    local words, idx = LazyVim.lsp.words.get()
    if not idx then
      return
    end
    idx = idx + count
    if cycle then
      idx = (idx - 1) % #words + 1
    end
    if idx < 1 then
      idx = 1
    elseif idx > #words then
      idx = #words
    end
    local target = words[idx]
    if target then
      vim.api.nvim_win_set_cursor(0, target.from)
    end
  end

  k("]]", function()
    jump(vim.v.count1)
  end, "Next Reference", "n")

  k("[[", function()
    jump(-vim.v.count1)
  end, "Prev Reference", "n")
end

return M
