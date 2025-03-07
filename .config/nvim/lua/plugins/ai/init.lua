return {
  {
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
      { "<leader>amd", "<cmd>CodeCompanionChat deepseek<cr>", mode = { "n", "v" }, desc = "Deepseek" },
      { "<leader>amo", "<cmd>CodeCompanionChat openrouter<cr>", mode = { "n", "v" }, desc = "Openrouter" },
      { "<leader>ama", "<cmd>CodeCompanionChat ark<cr>", mode = { "n", "v" }, desc = "Ark" },
    },
    init = function()
      require("plugins.ai.fidget-spinner"):init()
    end,
    config = function(_, _)
      vim.cmd [[cab cc CodeCompanionCopilot]]
      vim.cmd [[cab ccb CodeCompanionWithBuffers]]

      require("codecompanion").setup {
        opts = {
          log_level = "INFO",
          -- log_level = "TRACE",
        },
        adapters = {
          ark = require("codecompanion.adapters").extend("deepseek", {
            env = {
              api_key = os.getenv "ARK_API_KEY",
            },
            opts = {
              can_reason = true,
            },
            url = os.getenv "ARK_API_BASE" .. "/chat/completions",
            schema = {
              model = {
                default = "deepseek-r1-250120",
                choices = {
                  "deepseek-r1-250120",
                  "deepseek-v3-241226",
                  "doubao-1-5-pro-256k-250115",
                  "deepseek-r1-distill-qwen-32b-250120",
                },
              },
            },
          }),
          moonshot = require("codecompanion.adapters").extend("openai", {
            env = {
              api_key = os.getenv "MOONSHOT_API_KEY",
            },
            url = os.getenv "MOONSHOT_API_BASE" .. "/chat/completions",
            schema = {
              model = {
                default = "moonshot-v1-auto",
                choices = {
                  "moonshot-v1-auto",
                },
              },
            },
          }),
          openrouter = require("codecompanion.adapters").extend("deepseek", {
            env = {
              api_key = os.getenv "OPENROUTER_API_KEY",
            },
            opts = {
              can_reason = true,
            },
            url = os.getenv "OPENROUTER_API_BASE" .. "/chat/completions",
            schema = {
              model = {
                default = "google/gemini-2.0-flash-001",
                choices = {
                  "deepseek/deepseek-r1",
                  "deepseek/deepseek-chat",
                  "qwen/qwen-2.5-coder-32b-instruct",
                  "qwen/qwen-2.5-72b-instruct",
                  "google/gemini-2.0-flash-001",
                  "google/gemini-exp-1206:free",
                  "anthropic/claude-3.7-sonnet:beta",
                  "openai/gpt-4o-2024-11-20",
                },
              },
            },
            handlers = {
              ---@param self CodeCompanion.Adapter
              ---@return boolean
              setup = function(self)
                local os = require("codecompanion.adapters.openai").handlers.setup
                if os then
                  os(self)
                end

                self.parameters.provider = {
                  order = {
                    "Groq",
                  },
                  allow_fallbacks = true,
                }

                return true
              end,
            },
          }),
          siliconflow = require("codecompanion.adapters").extend("openai", {
            env = {
              api_key = os.getenv "SILICONFLOW_API_KEY",
            },
            url = os.getenv "SILICONFLOW_API_BASE" .. "/chat/completions",
            schema = {
              model = {
                default = "Qwen/Qwen2.5-Coder-32B-Instruct",
                choices = {
                  "Qwen/Qwen2.5-Coder-32B-Instruct",
                },
              },
            },
          }),
          gemini = require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = os.getenv "GEMINI_API_KEY",
            },
            schema = {
              model = {
                default = "gemini-2.0-flash-exp",
              },
            },
          }),
          copilot = require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-3-5-sonnet",
              },
            },
          }),
          ollama = require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "qwen2.5-coder:1.5b",
                choices = {
                  "qwen2.5-coder:1.5b",
                },
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
                  "chatgpt-4o-latest",
                  "gpt-4-turbo-preview",
                  "gpt-4o-2024-08-06",
                  "gpt-4",
                  "gpt-3.5-turbo",
                  "gemini-1.5-pro-latest",
                  "gemini-1.5-flash-latest",
                  "TA/meta-llama/Meta-Llama-3.1-405B-Instruct-Turbo",
                  "TA/meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo",
                  "claude-3.5-sonnet-latest",
                  "claude-3-5-sonnet-20240620",
                },
              },
            },
          }),
          deepseek = require("codecompanion.adapters").extend("deepseek", {
            env = {
              api_key = os.getenv "DEEPSEEK_API_KEY",
            },
            url = os.getenv "DEEPSEEK_API_BASE" .. "/chat/completions",
            schema = {
              model = {
                default = "deepseek-reasoner",
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
                default = "claude-3-5-sonnet-latest",
                choices = {
                  "claude-3-5-sonnet-latest",
                  "claude-3-5-haiku-latest",
                },
              },
            },
          }),
        },
        strategies = {
          chat = {
            adapter = "openai",
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
          diff = {
            enabled = true,
            provider = "default",
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
    dir = "~/project/context-groups.nvim",
    config = function()
      require("context-groups").setup {
        keymaps = {
          add_context = "<leader>ca",
          show_context = "<leader>cs",
          add_imports = "<leader>ci",
        },
        storage_path = vim.fn.stdpath "data" .. "/context-groups",
        import_prefs = {
          show_stdlib = false,
          show_external = false,
          ignore_patterns = { "node_modules", "__pycache__" },
        },
        max_preview_lines = 500,
        telescope_theme = require("telescope.themes").get_ivy(),
        on_context_change = function()
          -- Custom callback when context group changes
          vim.notify "Context group updated"
        end,
        -- 导出相关配置
        export = {
          max_tree_depth = 4, -- 项目树的最大深度
          exclude_patterns = { -- 要排除的文件模式
            "__pycache__",
            "node_modules",
            ".git",
            ".idea",
            ".vscode",
            "build",
            "dist",
            ".pytest_cache",
            ".mypy_cache",
            ".tox",
            "venv",
            "env",
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
