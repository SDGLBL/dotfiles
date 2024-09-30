return {
  {
    -- dir = "~/project/codecompanion.nvim",
    -- enabled = function()
    --   local dir_path = vim.fn.expand "~/project/codecompanion.nvim"
    --   if vim.fn.isdirectory(dir_path) == 0 then
    --     return false
    --   end
    --   return true
    -- end,
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- Optional
      "echasnovski/mini.diff",
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
      { "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle" },
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
          ollama = require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "llama3.1",
                choices = {},
              },
            },
          }),
          openai = require("codecompanion.adapters").extend("openai", {
            env = {
              api_key = os.getenv "OPENAI_API_KEY",
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
                  "gemini-1.5-flash-001",
                  "TA/meta-llama/Meta-Llama-3.1-405B-Instruct-Turbo",
                  "TA/meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo",
                  "Claude-3.5-Sonnet",
                  "claude-3-5-sonnet-20240620",
                },
              },
            },
          }),
          deepseek = require("codecompanion.adapters").extend("openai", {
            env = {
              api_key = os.getenv "DEEPSEEK_API_KEY",
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
              max_tokens = {
                default = 8192,
              },
              temperature = {
                default = 1,
              },
            },
          }),
          anthropic = require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = os.getenv "ANTHROPIC_API_KEY",
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
        prompt_library = {
          ["Translate"] = require("plugins.ai.actions").translate,
          ["Write"] = require("plugins.ai.actions").write,
        },
        display = {
          inline = {
            diff = {
              enabled = true,
            },
          },
          chat = {
            show_settings = true,
          },
        },
        slash_commands = {
          prompts = require "plugins.ai.prompts.slash_prompts",
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
