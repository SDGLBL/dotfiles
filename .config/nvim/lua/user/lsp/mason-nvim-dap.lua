local ok, dap = pcall(require, "dap")
if not ok then
  return
end

require("mason-nvim-dap").setup {
  automatic_setup = true,
  ensure_installed = { "python", "delve" },
}

require("mason-nvim-dap").setup_handlers {
  function(source_name)
    -- all sources with no handler get passed here
    -- Keep original functionality of `automatic_setup = true`
    require "mason-nvim-dap.automatic_setup"(source_name)
  end,

  python = function(_)
    dap.adapters.python = {
      type = "executable",
      command = "/usr/bin/python3",
      args = {
        "-m",
        "debugpy.adapter",
      },
    }

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        justMyCode = false,
        program = "${file}",
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
            return cwd .. "/venv/bin/python"
          elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
            return cwd .. "/.venv/bin/python"
          elseif os.getenv "CONDA_PREFIX" ~= "" then
            return os.getenv "CONDA_PREFIX" .. "/bin/python"
          else
            return "/usr/bin/python"
          end
        end,
      },
    }
  end,

  delve = function(_)
    dap.adapters.go = {
      type = "server",
      port = "${port}",
      executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" },
      },
    }

    dap.configurations.go = {
      {
        type = "go",
        name = "Debug File",
        request = "launch",
        program = "${file}",
        dlvToolPath = vim.fn.exepath "dlv",
      },
      {
        type = "go",
        name = "Debug Program",
        request = "launch",
        program = "${workspaceFolder}",
        dlvToolPath = vim.fn.exepath "dlv",
      },
      {
        type = "go",
        name = "Debug Test file",
        request = "launch",
        mode = "test",
        program = "${file}",
        dlvToolPath = vim.fn.exepath "dlv",
      },
      {
        type = "go",
        name = "Debug test",
        request = "launch",
        mode = "test",
        program = "${workspaceFolder}",
        dlvToolPath = vim.fn.exepath "dlv",
      },
      {
        type = "go",
        name = "Attach",
        request = "attach",
        processId = require("dap.utils").pick_process,
        dlvToolPath = vim.fn.exepath "dlv",
      },
    }
  end,

  cppdbg = function(_)
    dap.adapters.cppdbg = {
      id = "cppdbg",
      type = "executable",
      command = "/home/"
        .. (os.getenv "USER" or "default")
        .. "/software/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
    }

    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = true,
      },
      {
        name = "Attach to gdbserver :1234",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerServerAddress = "localhost:1234",
        miDebuggerPath = "/usr/bin/gdb",
        cwd = "${workspaceFolder}",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
      },
    }

    dap.configurations.c = dap.configurations.cpp

    dap.configurations.rust = {
      {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = true,
      },
      {
        name = "Attach to gdbserver :1234",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerServerAddress = "localhost:1234",
        miDebuggerPath = "/usr/bin/gdb",
        cwd = "${workspaceFolder}",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
      },
    }
  end,
}

local dapui_ok, dapui = pcall(require, "dapui")
if dapui_ok then
  dapui.setup()
end

local dapvok, dapv = pcall(require, "nvim-dap-virtual-text")
if dapvok then
  dapv.setup()
end

local ok_which_key, _ = pcall(require, "which-key")

if ok_which_key then
  local wk = require "user.whichkey"

  if wk.mappings["d"] ~= nil then
    return
  end

  wk.mappings["d"] = {
    name = "+Debugger",
    b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "toggle breakpoint" },
    c = { "<cmd>lua require'dap'.continue()<cr>", "continue" },
    C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "continue to cursor" },
    n = { "<cmd>lua require'dap'.step_over()<cr>", "step over" },
    s = { "<cmd>lua require'dap'.step_into()<cr>", "step into" },
    S = { "<cmd>lua require'dap'.step_out()<cr>", "step out" },
    e = { "<cmd>lua require'dap'.close()<cr>", "stop debugger" },
    l = { "<cmd>lua require'dap'.list_breakpoints()<cr>", "list all breakpoint" },
    r = { "<cmd>lua require'dap'.clear_breakpoints()<cr>", "remove all breakpont" },
    o = { "<cmd>lua require'dapui'.open()<cr>", "open debug ui window" },
    x = { "<cmd>lua require'dapui'.close()<cr>", "close debug ui window" },
    t = { "<cmd>lua require'dapui'.toggle()<cr>", "toggle debug ui window" },
    f = { "<cmd>lua require'dapui'.float_element()<cr>", "get value" },
    v = { "<cmd>lua require'dapui'.eval(nil,{enter=true})<cr>", "eval value" },
  }
end
