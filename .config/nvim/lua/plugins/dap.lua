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
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input "[Condition] > ")
        end,
        desc = "Conditional Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dE",
        function()
          require("dapui").eval(vim.fn.input "[Expression] > ")
        end,
        desc = "Evaluate Input",
      },
      {
        "<leader>ds",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>dj",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>de",
        function()
          require("dap").close()
        end,
        desc = "Quit",
      },
      {
        "<leader>dl",
        function()
          require("dap").list_breakpoints()
        end,
        desc = "list all breakpoint",
      },
      {
        "<leader>dr",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "remove all breakpont",
      },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Hover Variables",
      },
      {
        "<leader>dS",
        function()
          require("dap.ui.widgets").scopes()
        end,
        desc = "Scopes",
      },
      {
        "<leader>dx",
        function()
          require("dapui").close()
        end,
        desc = "close debug ui window",
      },
      {
        "<leader>dt",
        function()
          require("dapui").toggle()
        end,
        desc = "toggle debug ui window",
      },
      {
        "<leader>df",
        function()
          require("dapui").float_element()
        end,
        desc = "get value",
      },
      {
        "<leader>dv",
        function()
          require("dapui").eval(nil, { enter = true })
        end,
        desc = "eval value",
      },
    },
    opts = {},
    config = function(_, opts)
      opts.setup = opts.setup == nil and {} or opts.setup

      require("nvim-dap-virtual-text").setup {
        commented = true,
      }

      local dap, dapui = require "dap", require "dapui"
      dapui.setup {}

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      local handlers = {
        function(source_name)
          -- all sources with no handler get passed here
          -- Keep original functionality of `automatic_setup = true`
          require "mason-nvim-dap.automatic_setup"(source_name)
        end,
      }

      -- set up debugger
      for k, v in pairs(opts.setup) do
        handlers[k] = v
      end

      require("mason-nvim-dap").setup {
        automatic_setup = true,
        ensure_installed = { "python", "delve" },
        handlers = handlers,
      }
    end,
  },
}
