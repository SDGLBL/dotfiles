return {
  {
    -- "olimorris/codecompanion.nvim",
    -- commit = "4fadafcf93c9cff736e4305e62b36f6930818728",
    -- commit = "1952a9e600cd569c3f8ddf6499474e7142338bad",
    dir = "~/project/codecompanion.nvim",
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
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Actions" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "InlineCode" },
      { "<leader>av", "<cmd>CodeCompanionAdd<cr>", mode = { "v" }, desc = "Add Visual" },
      { "<leader>at", "<cmd>CodeCompanionToggle<cr>", mode = { "n", "v" }, desc = "Toggle" },
      { "<leader>am", desc = "Switch Mode Chat" },
      { "<leader>ama", "<cmd>CodeCompanionChat anthropic<cr>", mode = { "n", "v" }, desc = "Anthropic" },
      { "<leader>amd", "<cmd>CodeCompanionChat deepseek<cr>", mode = { "n", "v" }, desc = "Deepseek" },
      { "<leader>amo", "<cmd>CodeCompanionChat openai<cr>", mode = { "n", "v" }, desc = "Openai" },
    },
    config = function(_, _)
      vim.cmd [[cab cc CodeCompanionCopilot]]
      vim.cmd [[cab ccb CodeCompanionWithBuffers]]

      require("codecompanion").setup {
        opts = {
          log_level = "INFO",
          -- log_level = "TRACE",
        },
        adapters = {
          ollama = require("codecompanion.adapters").use("ollama", {
            schema = {
              model = {
                default = "llama3.1",
                choices = {},
              },
            },
          }),
          openai = require("codecompanion.adapters").use("openai", {
            env = {
              api_key = "cmd:gpg --decrypt ~/.openai-api-key.gpg 2>/dev/null",
            },
            url = os.getenv "OPENAI_API_BASE" .. "/chat/completions",
            schema = {
              model = {
                default = "gpt-4o-2024-08-06",
                choices = {
                  "gpt-4o",
                  "gpt-4o-mini",
                  "gpt-4-turbo-preview",
                  "gpt-4o-2024-08-06",
                  "gpt-4",
                  "gpt-3.5-turbo",
                  "gemini-1.5-pro-001",
                  "TA/meta-llama/Meta-Llama-3.1-405B-Instruct-Turbo",
                  "TA/meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo",
                },
              },
            },
          }),
          deepseek = require("codecompanion.adapters").use(require "plugins.ai.deepseek", {
            env = {
              api_key = "cmd:gpg --decrypt ~/.deepseek-api-key.gpg 2>/dev/null",
            },
            url = os.getenv "DEEPSEEK_API_BASE" .. "/chat/completions",
            schema = {
              model = {
                default = "deepseek-chat",
                choices = {
                  "deepseek-coder",
                  "deepseek-chat",
                },
              },
              max_token = {
                default = 8192,
              },
              temperature = {
                default = 1,
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
                default = "claude-3-5-sonnet-20240620",
              },
            },
          }),
        },
        strategies = {
          chat = {
            adapter = "anthropic",
          },
          inline = {
            adapter = "anthropic",
          },
          agent = {
            adapter = "deepseek",
            tools = {
              opts = {
                auto_submit_errors = false,
                auto_submit_success = false,
              },
            },
          },
        },
        actions = {
          require("plugins.ai.actions").translate,
          require("plugins.ai.actions").write,
        },
        display = {
          inline = {
            diff = {
              enabled = false,
            },
          },
          chat = {
            show_settings = true,
          },
        },
      }
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
