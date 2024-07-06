return {
  {
    "olimorris/codecompanion.nvim",
    -- dir = "~/project/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- Optional
      {
        "grapp-dev/nui-components.nvim",
        dependencies = {
          "MunifTanjim/nui.nvim",
        },
      },
      {
        "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
        opts = {},
      },
      {
        "folke/edgy.nvim",
        event = "VeryLazy",
        init = function()
          vim.opt.laststatus = 3
          vim.opt.splitkeep = "screen"
        end,
        opts = {
          animate = {
            enabled = false,
          },
          right = {
            { ft = "codecompanion", title = "Code Companion Chat", size = { width = 0.45 } },
          },
        },
      },
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Actions" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "InlineCode" },
      { "<leader>av", "<cmd>CodeCompanionAdd<cr>", mode = { "v" }, desc = "Add Visual" },
      { "<leader>at", "<cmd>CodeCompanionToggle<cr>", mode = { "n", "v" }, desc = "Toggle" },
    },
    config = function(_, _)
      vim.cmd [[cab cc CodeCompanion]]
      vim.cmd [[cab ccb CodeCompanionWithBuffers]]

      require("codecompanion").setup {
        log_level = vim.log.levels.INFO,
        adapters = {
          openai = require("codecompanion.adapters").use("openai", {
            env = {
              api_key = "cmd:gpg --decrypt ~/.openai-api-key.gpg 2>/dev/null",
            },
            url = os.getenv "OPENAI_API_BASE" .. "/chat/completions",
            schema = {
              model = {
                default = "gpt-4o",
                choices = {
                  "gpt-4o",
                  "gpt-4-turbo-preview",
                  "gpt-4",
                  "gpt-3.5-turbo",
                },
              },
            },
          }),
          anthropic = require("codecompanion.adapters").use("anthropic", {
            env = {
              api_key = "cmd:gpg --decrypt ~/.openai-api-key.gpg 2>/dev/null",
            },
            url = os.getenv "OPENAI_API_BASE" .. "/messages",
            schema = {
              model = {
                default = "claude-3-5-sonnet",
              },
            },
          }),
        },
        actions = {
          require("plugins.ai.inline_actions").generate_inline_action,
          require("plugins.ai.inline_actions").translate_inline_action,
        },
        strategies = {
          chat = "openai",
          inline = "anthropic",
          tool = "openai",
        },
        display = {
          inline = {
            diff = {
              enabled = false,
            },
          },
        },
      }

      -- require "telescope".load_extension "codecompanion"
    end,
  },

  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    enabled = false,
    -- stylua: ignore
    config = function()
      vim.g.codeium_disable_bindings = 1
      vim.keymap.set("i", "<A-l>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("i", "<A-f>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<A-b>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<A-c>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
      vim.keymap.set("i", "<A-s>", function() return vim.fn["codeium#Complete"]() end, { expr = true })
    end,
  },
}
