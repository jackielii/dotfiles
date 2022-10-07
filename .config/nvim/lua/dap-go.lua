local M = {}

local function get_arguments()
  local co = coroutine.running()
  if co then
    return coroutine.create(function()
      local args = {}
      vim.ui.input({ prompt = 'Args: ' }, function(input)
        args = vim.split(input or "", " ")
      end)
      coroutine.resume(co, args)
    end)
  else
    local args = {}
    vim.ui.input({ prompt = 'Args: ' }, function(input)
      args = vim.split(input or "", " ")
    end)
    return args
  end
end

local function setup_go_adapter(dap)
  dap.adapters.go = function(callback, config)
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local host = config.host or "127.0.0.1"
    local port = config.port or "38697"
    local addr = string.format("%s:%s", host, port)
    local opts = {
      stdio = {nil, stdout, stderr},
      args = {"dap", "-l", addr},
      detached = true
    }
    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
      stdout:close()
      stderr:close()
      handle:close()
      if code ~= 0 then
        print('dlv exited with code', code)
      end
    end)
    assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
    stderr:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require('dap.repl').append(chunk)
        end)
      end
    end)
    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require('dap.repl').append(chunk)
        end)
      end
    end)
    -- Wait for delve to start
    vim.defer_fn(
      function()
        callback({type = "server", host = "127.0.0.1", port = port})
      end,
      1000)
  end
end

-- local function setup_go_adapter(dap)
--   dap.adapters.go = {
--     type = 'executable';
--     command = 'node';
--     args = { os.getenv('HOME') .. '/personal/vscode-go/dist/debugAdapter.js' };
--   }
-- end

require('dap').set_log_level('TRACE')

local function setup_go_configuration(dap)
  dap.configurations.go = {
    {
      type = "go",
      name = "Debug Workspace",
      request = "launch",
      program = "${workspaceFolder}",
    },
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}",
    },
    {
      type = "go",
      name = "Debug (Arguments)",
      request = "launch",
      program = "${file}",
      args = get_arguments,
    },
    {
      type = "go",
      name = "Debug Package",
      request = "launch",
      program = "${fileDirname}",
    },
    {
      type = "go",
      name = "Attach",
      mode = "local",
      request = "attach",
      processId = require('dap.utils').pick_process,
    },
    {
      type = "go",
      name = "Debug test",
      request = "launch",
      mode = "test",
      program = "${file}",
    },
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    }
  }
end

function M.setup()
  local dap = require("dap")
  setup_go_adapter(dap)
  setup_go_configuration(dap)
end

return M
