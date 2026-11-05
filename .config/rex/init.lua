-- Move between terminal panes with Ctrl-H/J/K/L.
rex.bind("ctrl+h", "pane.focus", { direction = "left" })
rex.bind("ctrl+j", "pane.focus", { direction = "down" })
rex.bind("ctrl+k", "pane.focus", { direction = "up" })
rex.bind("ctrl+l", "pane.focus", { direction = "right" })

-- Rex config, migrated from ~/.tmux.conf and ~/.config/kitty/kitty.conf

-- cmd+k clears the terminal; the session picker moves to ctrl+a>l
rex.bind("cmd+k", "com.superlogical.terminal.clear")
rex.bind("ctrl+a>l", "session.switch") -- kitty.conf:194

-- Prefix ctrl+a passes through to programs (kitty.conf:61)
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- tmux
rex.bind("ctrl+a>v", "pane.split", { direction = "right" }) -- .tmux.conf:28, kitty.conf:100
rex.bind("ctrl+a>s", "pane.split", { direction = "down" }) -- .tmux.conf:29, kitty.conf:99
rex.bind("ctrl+a>n", "client.tab.new") -- .tmux.conf:30, kitty.conf:89
rex.bind("ctrl+a>ctrl+z", "pane.zoom") -- .tmux.conf:87
rex.bind("ctrl+alt+n", "client.tab.next") -- .tmux.conf:140
rex.bind("ctrl+alt+p", "client.tab.previous") -- .tmux.conf:141
rex.bind("ctrl+a>shift+t", "client.tab.new") -- .tmux.conf:167

-- tmux resize (bind -r), .tmux.conf:60-63
rex.bind("ctrl+a>ctrl+shift+j", "pane.resize", { direction = "down", amount = 5 })
rex.bind("ctrl+a>ctrl+shift+k", "pane.resize", { direction = "up", amount = 5 })
rex.bind("ctrl+a>ctrl+shift+h", "pane.resize", { direction = "left", amount = 5 })
rex.bind("ctrl+a>ctrl+shift+l", "pane.resize", { direction = "right", amount = 5 })

rex.mode("repeat", { exclusive = true })
rex.bind("ctrl+a>r", "client.mode.enter", { name = "repeat" })
rex.bind("repeat/enter", "client.mode.exit")
rex.bind("repeat/escape", "client.mode.exit")
rex.bind("repeat/ctrl+shift+j", "pane.resize", { direction = "down", amount = 5 })
rex.bind("repeat/ctrl+shift+k", "pane.resize", { direction = "up", amount = 5 })
rex.bind("repeat/ctrl+shift+h", "pane.resize", { direction = "left", amount = 5 })
rex.bind("repeat/ctrl+shift+l", "pane.resize", { direction = "right", amount = 5 })

-- kitty
rex.bind("ctrl+i", "pane.send_key", { key = "f20" }) -- kitty.conf:62
rex.bind("ctrl+a>left", "pane.focus", { direction = "left" }) -- kitty.conf:82
rex.bind("ctrl+a>right", "pane.focus", { direction = "right" }) -- kitty.conf:83
rex.bind("ctrl+a>up", "pane.focus", { direction = "up" }) -- kitty.conf:84
rex.bind("ctrl+a>down", "pane.focus", { direction = "down" }) -- kitty.conf:85
rex.bind("ctrl+a>x", "pane.close") -- kitty.conf:90
rex.bind("ctrl+a>,", "client.tab.rename") -- kitty.conf:91

rex.action{
  name = "rename_tab_to_folder",
  title = "Rename Tab to Current Folder",
  run = function(ctx)
    local view, err = rex.session.view{}
    if err then error(err) end
    local window
    for _, candidate in ipairs(view.windows or {}) do
      if candidate.window_id == view.active_window_id then window = candidate end
    end
    if not window then error("No active tab") end
    local directory, pwd_err = rex.block.call("com.superlogical.terminal", "pwd", {
      block_id = ctx.block_id or window.focused_block_id,
    })
    if pwd_err then error(pwd_err) end
    local path = directory.pwd
    if not path or path == "" then error("The terminal has not reported its directory") end
    if path:match("^file://") then
      path = path:gsub("^file://[^/]*", "")
      path = path:gsub("%%(%x%x)", function(hex) return string.char(tonumber(hex, 16)) end)
    end
    local label = path:gsub("/+$", ""):match("([^/]+)$") or "/"
    local result, rename_err = rex.session.set_window_label{
      window_id = window.window_id,
      label = label,
    }
    if rename_err then error(rename_err) end
    return result
  end,
}
rex.bind("ctrl+a>ctrl+,", "rename_tab_to_folder")
rex.bind("ctrl+a>shift+1", "pane.move_to_new_tab") -- kitty.conf:93
rex.bind("ctrl+a>alt+s", "pane.split", { direction = "down" }) -- kitty.conf:101
rex.bind("ctrl+a>alt+v", "pane.split", { direction = "right" }) -- kitty.conf:102
rex.bind("ctrl+a>z", "pane.zoom") -- kitty.conf:105
rex.bind("cmd+f", "pane.zoom") -- kitty.conf:106
rex.bind("ctrl+a>shift+h", "pane.move", { direction = "left" }) -- kitty.conf:107
rex.bind("ctrl+a>shift+j", "pane.move", { direction = "down" }) -- kitty.conf:108
rex.bind("ctrl+a>shift+k", "pane.move", { direction = "up" }) -- kitty.conf:109
rex.bind("ctrl+a>shift+l", "pane.move", { direction = "right" }) -- kitty.conf:110
rex.bind("ctrl+shift+h", "pane.resize", { direction = "left", amount = 2 }) -- kitty.conf:113
rex.bind("ctrl+shift+j", "pane.resize", { direction = "down", amount = 2 }) -- kitty.conf:114
rex.bind("ctrl+shift+k", "pane.resize", { direction = "up", amount = 2 }) -- kitty.conf:115
rex.bind("ctrl+shift+l", "pane.resize", { direction = "right", amount = 2 }) -- kitty.conf:116
rex.bind("alt+shift+k", "client.prompt.previous") -- kitty.conf:120
rex.bind("alt+shift+j", "client.prompt.next") -- kitty.conf:121
rex.bind("ctrl+a>ctrl+q", "pane.send_key", { key = "ctrl+q" }) -- kitty.conf:156
rex.bind("ctrl+a>shift+c", "com.superlogical.terminal.clear") -- kitty.conf:170

rex.action{
  name = "open_kitty_docs",
  title = "Open kitty Docs",
  run = function(ctx, args)
    rex.exec{ "open", "https://sw.kovidgoyal.net/kitty/" }
  end,
}
rex.bind("ctrl+shift+/>/", "open_kitty_docs") -- kitty.conf:177

rex.bind("cmd+[", "client.tab.previous") -- kitty.conf:186
rex.bind("shift+cmd+[", "client.tab.move", { direction = "backward" }) -- kitty.conf:187
rex.bind("cmd+]", "client.tab.next") -- kitty.conf:188
rex.bind("shift+cmd+]", "client.tab.move", { direction = "forward" }) -- kitty.conf:189

-- More tmux-like keys
rex.bind("ctrl+a>ctrl+c", "session.rename")
rex.bind("ctrl+a>=", "pane.balance")

-- Scrollback pager and pickers. Rex has no overlays, so these open a zoomed
-- split or a floating pane that closes when its program exits.
local terminal = "com.superlogical.terminal"

local function pane_text(block_id, unwrap)
  local r, err = rex.block.call(terminal, "format", {
    block_id = block_id, format = "text", trim = true, unwrap = unwrap ~= false,
  })
  if err then error(err, 0) end
  return r.content
end

local function temp_file(name, text)
  local dir = (os.getenv("TMPDIR") or "/tmp"):gsub("/+$", "")
  local path = string.format("%s/rex-%s-%d-%d", dir, name, os.time(), math.random(1000000))
  local file = assert(io.open(path, "w"))
  file:write(text)
  file:close()
  return path
end

local function command_block(command)
  return rex.layout.block{ flavor = terminal .. ".shell", options = { command = command } }
end

local function open_zoomed(ctx, command)
  local _, err = rex.session.new_split{
    anchor_id = ctx.block_id, direction = "vertical", side = "after", focus = true,
    layout = command_block(command),
  }
  if err then error(err, 0) end
  rex.client.queue("pane.zoom")
end

local function open_float(command)
  local _, err = rex.session.new_layer{
    bounds = { 0.15, 0.15, 0.7, 0.7 }, focus = true,
    layout = command_block(command),
  }
  if err then error(err, 0) end
end

-- Page the scrollback with nvimpager, as kitty.conf:132 did.
rex.action{
  name = "scrollback_in_pager",
  title = "Open Scrollback in Pager",
  run = function(ctx)
    local path = temp_file("scrollback", pane_text(ctx.block_id))
    open_zoomed(ctx, { "sh", "-c", 'nvimpager -p "$1"; rm -f "$1"', "sh", path })
  end,
}
rex.bind("ctrl+a>enter", "scrollback_in_pager")

-- Pick a URL from the pane with fzf and open it, newest first.
rex.action{
  name = "open_url_hints",
  title = "Open URL from Pane…",
  run = function(ctx)
    local found, seen, urls = {}, {}, {}
    for url in pane_text(ctx.block_id):gmatch("%a[%w+.-]*://[%w%-._~:/?#%[%]@!$&'()*+,;=%%]+") do
      table.insert(found, (url:gsub("[.,;:)'%]]+$", "")))
    end
    for i = #found, 1, -1 do
      if not seen[found[i]] then
        seen[found[i]] = true
        table.insert(urls, found[i])
      end
    end
    if #urls == 0 then return end
    local path = temp_file("urls", table.concat(urls, "\n") .. "\n")
    open_float({ "sh", "-c", 'url=$(fzf --no-sort < "$1"); rm -f "$1"; [ -n "$url" ] && open "$url"', "sh", path })
  end,
}
rex.bind("ctrl+shift+u>j", "open_url_hints")

-- Pick a word from every pane in the tab, like kitty-select-word-stream:
-- Enter types it into this pane, Tab copies it. Starts with what is on
-- screen; ctrl-h in fzf adds the scrollback.
rex.action{
  name = "word_picker",
  title = "Pick Word from Panes…",
  run = function(ctx)
    local view, err = rex.session.view{}
    if err then error(err, 0) end
    local blocks = { ctx.block_id }
    for _, window in ipairs(view.windows or {}) do
      local here, others = false, {}
      for _, layer in ipairs(window.layers or {}) do
        for _, block in ipairs(layer.blocks or {}) do
          if block.block_id == ctx.block_id then
            here = true
          elseif block.creator_name == terminal then
            table.insert(others, block.block_id)
          end
        end
      end
      if here then
        for _, id in ipairs(others) do table.insert(blocks, id) end
      end
    end

    local screen, all = {}, {}
    for _, id in ipairs(blocks) do
      local text = pane_text(id, false)
      local lines = {}
      for line in (text .. "\n"):gmatch("(.-)\n") do table.insert(lines, line) end
      local size = rex.block.call(terminal, "size", { block_id = id })
      local rows = size and size.rows or #lines
      table.insert(screen, table.concat(lines, "\n", math.max(1, #lines - rows + 1)))
      table.insert(all, text)
    end

    local dir = temp_file("words", "")
    os.remove(dir)
    local made = rex.exec({ "mkdir", dir })
    if not made.ok then error(made.stderr, 0) end
    for name, parts in pairs({ ["screen.txt"] = screen, ["all.txt"] = all }) do
      local file = assert(io.open(dir .. "/" .. name, "w"))
      file:write(table.concat(parts, "\n"), "\n")
      file:close()
    end
    open_float({ os.getenv("HOME") .. "/.config/rex/bin/rex-word-picker", dir, ctx.block_id })
  end,
}
rex.bind("ctrl+a>tab", "word_picker")

-- Ctrl-Q toggles the last visited tabs, including visits made by clicking.
-- tab-history.lua listens to server events via the user LaunchAgent.
rex.action{
  name = "previous_visited_tab",
  title = "Switch to Last Visited Tab",
  run = function(ctx)
    local file = io.open(os.getenv("HOME") .. "/.cache/rex/tab-history.json", "r")
    if not file then return end
    local ok, history = pcall(rex.json.decode, file:read("*a"))
    file:close()
    if not ok then return end
    local view, err = rex.session.view{}
    if err then error(err) end
    local live = {}
    for _, window in ipairs(view.windows or {}) do live[window.window_id] = true end
    for _, id in ipairs(history[ctx.session_id] or {}) do
      if id ~= view.active_window_id and live[id] then
        -- Server focus alone does not select the visible tab in Rex.app.
        for index, window in ipairs(view.windows or {}) do
          if window.window_id == id then
            rex.client.queue("client.tab.goto", {index = index})
            return
          end
        end
      end
    end
  end,
}
rex.bind("ctrl+q", "previous_visited_tab")
