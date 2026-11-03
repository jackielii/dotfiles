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
        local result, focus_err = rex.session.focus_window{window_id = id}
        if focus_err then error(focus_err) end
        return result
      end
    end
  end,
}
rex.bind("ctrl+q", "previous_visited_tab")
