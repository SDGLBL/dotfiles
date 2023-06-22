return {
  -- cpp debug
  {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
      if not type(opts.setup) == "table" then
        return
      end

      local dap = require "dap"
      local input_args = require("utils").input_args
      local os_type = vim.loop.os_uname().sysname

      if os_type == nil then
        return
      end

      local setup = {}

      if string.find(os_type, "Darwin") then
        setup["codelldb"] = function()
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
                args = input_args,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
              },
            }

            dap.configurations.c = dap.configurations.cpp
        end
      elseif string.find(os_type, "Linux") then
        setup["cppdbg"] = function()
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
                args = input_args,
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
                args = input_args,
              },
            }

            dap.configurations.c = dap.configurations.cpp
        end
      end

      vim.list_extend(opts.setup, setup)
    end,
  },
}
