-- Run with `rex do ~/.config/rex/tab-history.lua --all` (see LaunchAgent).
-- Only this listener writes the cache; readers always see an atomic snapshot.
local path = os.getenv("HOME") .. "/.cache/rex/tab-history.json"
rex.exec{"/bin/mkdir", "-p", os.getenv("HOME") .. "/.cache/rex"}
local history = {}
local file = io.open(path, "r")
if file then
  local ok, saved = pcall(rex.json.decode, file:read("*a"))
  file:close()
  if ok and type(saved) == "table" then history = saved end
end
local function save()
  local out = assert(io.open(path .. ".tmp", "w"))
  out:write(rex.json.encode(history))
  out:close()
  assert(os.rename(path .. ".tmp", path))
end
local function visit(session, window)
  if not session or not window then return end
  local old, new = history[session] or {}, {window}
  for _, id in ipairs(old) do
    if id ~= window then new[#new + 1] = id end
  end
  history[session] = new
end
local function reconcile(session)
  local view, err = rex.session.view{session_id = session}
  if err then return end
  local live, kept = {}, {}
  for _, window in ipairs(view.windows or {}) do live[window.window_id] = true end
  for _, id in ipairs(history[session] or {}) do
    if live[id] then kept[#kept + 1] = id end
  end
  history[session] = kept
  visit(session, view.active_window_id)
end
rex.on("active_window_changed", function(ctx, ev)
  visit(ctx.session_id, ev.window_id)
  save()
end)
rex.on("window_closed", function(ctx)
  reconcile(ctx.session_id)
  save()
end)
rex.on("session_destroyed", function(ctx, ev)
  history[ctx.session_id or ev.session_id] = nil
  save()
end)
local sessions, err = rex.call("session.list")
if err then error(err) end
local live = {}
for _, session in ipairs(sessions.sessions) do
  live[session.session_id] = true
  reconcile(session.session_id)
end
for id in pairs(history) do if not live[id] then history[id] = nil end end
save()
