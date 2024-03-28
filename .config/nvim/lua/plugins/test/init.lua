return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        ["<leader>t"] = { name = "+Test" },
        ["<leader>tt"] = { name = "+Overseer" },
      },
    },
  },

  {
    "vim-test/vim-test",
    opts = {
      setup = {},
    },
    config = function(plugin, opts)
      vim.g["test#strategy"] = "neovim"
      vim.g["test#neovim#term_position"] = "belowright"
      vim.g["test#neovim#preserve_screen"] = 1

      -- Set up vim-test
      for k, _ in pairs(opts.setup) do
        opts.setup[k](plugin, opts)
      end
    end,
  },

  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerToggle",
      "OverseerTaskAction",
    },
    keys = {
      { "<leader>ttR", "<cmd>OverseerRunCmd<cr>", desc = "Run Command" },
      { "<leader>tta", "<cmd>OverseerTaskAction<cr>", desc = "Task Action" },
      { "<leader>ttb", "<cmd>OverseerBuild<cr>", desc = "Build" },
      { "<leader>ttc", "<cmd>OverseerClose<cr>", desc = "Close" },
      { "<leader>ttd", "<cmd>OverseerDeleteBundle<cr>", desc = "Delete Bundle" },
      { "<leader>ttl", "<cmd>OverseerLoadBundle<cr>", desc = "Load Bundle" },
      { "<leader>tto", "<cmd>OverseerOpen<cr>", desc = "Open" },
      { "<leader>ttq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
      { "<leader>ttr", "<cmd>OverseerRun<cr>", desc = "Run" },
      { "<leader>tts", "<cmd>OverseerSaveBundle<cr>", desc = "Save Bundle" },
      { "<leader>ttt", "<cmd>OverseerToggle bottom<cr>", desc = "Toggle" },
    },
    opts = {},
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-vim-test",
      "vim-test/vim-test",
      "nvim-neotest/nvim-nio",
    },
    --stylua: ignore
    keys = {
      {
        "<leader>tF",
        "<cmd>w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
        desc = "Debug File",
      },
      { "<leader>tL", "<cmd>w|lua require('neotest').run.run_last({strategy = 'dap'})<cr>", desc = "Debug Last" },
      { "<leader>ta", "<cmd>w|lua require('neotest').run.attach()<cr>", desc = "Attach" },
      { "<leader>tf", "<cmd>w|lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "File" },
      { "<leader>tl", "<cmd>w|lua require('neotest').run.run_last()<cr>", desc = "Last" },
      { "<leader>tn", "<cmd>w|lua require('neotest').run.run()<cr>", desc = "Nearest" },
      { "<leader>tN", "<cmd>w|lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Nearest" },
      { "<leader>to", "<cmd>w|lua require('neotest').output.open({ enter = true })<cr>", desc = "Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<leader>ts", "<cmd>w|lua require('neotest').run.stop()<cr>", desc = "Stop" },
      { "<leader>tS", "<cmd>w|lua require('neotest').summary.toggle()<cr>", desc = "Summary" },
    },
    opts = function()
      return {
        adapters = {
          require "neotest-vim-test" {
            ignore_file_types = { "python", "vim", "lua" },
          },
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
        quickfix = {
          open = function()
            if require("utils").has "trouble.nvim" then
              require("trouble").open { mode = "quickfix", focus = false }
            else
              vim.cmd "copen"
            end
          end,
        },
        -- overseer.nvim
        consumers = {
          overseer = require "neotest.consumers.overseer",
        },
        overseer = {
          enabled = true,
          force_default = true,
        },
      }
    end,
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"

      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      if require("utils").has "trouble.nvim" then
        opts.consumers = opts.consumers or {}
        -- Refresh and auto close trouble after running tests
        ---@diagnostic disable-next-line: undefined-doc-name
        ---@type neotest.Consumer
        ---@diagnostic disable-next-line: assign-type-mismatch
        opts.consumers.trouble = function(client)
          client.listeners.results = function(adapter_id, results, partial)
            if partial then
              return
            end

            local tree = assert(client:get_position(nil, { adapter = adapter_id }))

            local failed = 0
            for pos_id, result in pairs(results) do
              if result.status == "failed" and tree:get_key(pos_id) then
                failed = failed + 1
              end
            end

            vim.schedule(function()
              local trouble = require "trouble"

              if trouble.is_open() then
                trouble.refresh()
                if failed == 0 then
                  trouble.close()
                end
              end
            end)

            return {}
          end
        end
      end

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require("neotest").setup(opts)
    end,
  },

  {
    "andythigpen/nvim-coverage",
    cmd = { "Coverage" },
    config = function()
      require("coverage").setup()
    end,
  },

  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    opts = {},
  },
}
