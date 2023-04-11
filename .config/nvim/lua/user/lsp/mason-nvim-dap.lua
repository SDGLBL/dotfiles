if not configs.lsp or not configs.dap then
  return
end

local ok, dap = pcall(require, "dap")
if not ok then
  return
end

local handlers = {
  function(source_name)
    -- all sources with no handler get passed here
    -- Keep original functionality of `automatic_setup = true`
    require "mason-nvim-dap.automatic_setup"(source_name)
  end,

  python = function(_)
    dap.adapters.python = {
      type = "executable",
      command = "python3",
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
}

local os_type = vim.loop.os_uname().sysname

if os_type ~= nil then
  if string.find(os_type, "Darwin") then
    handlers["codelldb"] = function(_)
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          -- CHANGE THIS to your path!
          command = vim.fn.join({ vim.fn.stdpath "data", "mason", "bin", "codelldb" }, "/"),
          args = { "--port", "${port}" },

          -- On windows you may have to uncomment this:
          -- detached = false,
        },
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            ---@diagnostic disable-next-line: redundant-parameter
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp

      dap.configurations.rust = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            ---@diagnostic disable-next-line: redundant-parameter
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end
  elseif string.find(os_type, "Linux") then
    handlers["cppdbg"] = function(_)
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        ---@diagnostic disable-next-line: undefined-global
        command = vim.fn.join({ vim.fn.stdpath "data", "mason", "bin", "OpenDebugAD7" }, "/"),
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            ---@diagnostic disable-next-line: redundant-parameter
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
            ---@diagnostic disable-next-line: redundant-parameter
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
            ---@diagnostic disable-next-line: redundant-parameter
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
            ---@diagnostic disable-next-line: redundant-parameter
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
        },
      }
    end
  end
end

require("mason-nvim-dap").setup {
  automatic_setup = true,
  ensure_installed = { "python", "delve" },
  handlers = handlers,
}

local dapui_ok, dapui = pcall(require, "dapui")
if dapui_ok then
  dapui.setup()
end

local dapvok, dapv = pcall(require, "nvim-dap-virtual-text")
if dapvok then
  dapv.setup()
end
