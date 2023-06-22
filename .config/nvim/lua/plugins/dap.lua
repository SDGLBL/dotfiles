return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        ["<leader>d"] = { name = "+DAP" },
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    enabled = configs.dap,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "jayp0521/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "toggle breakpoint" },
      { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "continue" },
      { "<leader>dC", "<cmd>lua require'dap'.run_to_cursor()<cr>", desc = "continue to cursor" },
      { "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>", desc = "step over" },
      { "<leader>ds", "<cmd>lua require'dap'.step_into()<cr>", desc = "step into" },
      { "<leader>dS", "<cmd>lua require'dap'.step_out()<cr>", desc = "step out" },
      { "<leader>de", "<cmd>lua require'dap'.close()<cr>", desc = "stop debugger" },
      { "<leader>dl", "<cmd>lua require'dap'.list_breakpoints()<cr>", desc = "list all breakpoint" },
      { "<leader>dr", "<cmd>lua require'dap'.clear_breakpoints()<cr>", desc = "remove all breakpont" },
      { "<leader>do", "<cmd>lua require'dapui'.open()<cr>", desc = "open debug ui window" },
      { "<leader>dx", "<cmd>lua require'dapui'.close()<cr>", desc = "close debug ui window" },
      { "<leader>dt", "<cmd>lua require'dapui'.toggle()<cr>", desc = "toggle debug ui window" },
      { "<leader>df", "<cmd>lua require'dapui'.float_element()<cr>", desc = "get value" },
      { "<leader>dv", "<cmd>lua require'dapui'.eval(nil,{enter=true})<cr>", desc = "eval value" },
    },
    config = function()
      local ok, dap = pcall(require, "dap")
      if not ok then
        return
      end

      local function input_args()
        ---@diagnostic disable-next-line: redundant-parameter
        local args = vim.fn.input("Arguments: ", "", "file")

        if args ~= "" then
          return vim.split(args, " ")
        else
          return {}
        end
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
              args = input_args,
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
              args = input_args,
              dlvToolPath = vim.fn.exepath "dlv",
            },
            {
              type = "go",
              name = "Debug Program",
              request = "launch",
              program = "${workspaceFolder}",
              args = input_args,
              dlvToolPath = vim.fn.exepath "dlv",
            },
            {
              type = "go",
              name = "Debug Test file",
              request = "launch",
              mode = "test",
              program = "${file}",
              args = input_args,
              dlvToolPath = vim.fn.exepath "dlv",
            },
            {
              type = "go",
              name = "Debug test",
              request = "launch",
              mode = "test",
              program = "${workspaceFolder}",
              args = input_args,
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
                args = input_args,
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
                args = input_args,
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

            dap.configurations.rust = {
              {
                name = "Launch file",
                type = "cppdbg",
                request = "launch",
                program = function()
                  ---@diagnostic disable-next-line: redundant-parameter
                  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
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
                  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
                end,
                args = input_args,
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
        dapui.setup {}
      end

      local dapvok, dapv = pcall(require, "nvim-dap-virtual-text")
      if dapvok then
        dapv.setup {}
      end
    end,
  },
}
