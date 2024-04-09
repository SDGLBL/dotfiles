return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- Optional
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
    cmds = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionToggle", "CodeCompanionActions" },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Actions" },
      { "<leader>av", "<cmd>CodeCompanionAdd<cr>", mode = { "v" }, desc = "Add Visual" },
      { "<leader>at", "<cmd>CodeCompanionToggle<cr>", mode = { "n", "v" }, desc = "Toggle" },
      -- { "<leader>sd", function() require("wtf").ai() end, desc = "Search Diagnostic with AI" },
      -- { "<leader>sD", function() require("wtf").search() end, desc = "Search Diagnostic with Google" },
    },
    config = function(_, _)
      require("codecompanion").setup {
        adapters = {
          openai = require("codecompanion.adapters").use("openai", {
            env = {
              api_key = "cmd:gpg --decrypt ~/.openai-api-key.gpg 2>/dev/null",
            },
            url = os.getenv "OPENAI_API_BASE" .. "/chat/completions",
          }),
        },
        actions = {
          {
            name = "Generate Git Message",
            strategy = "inline",
            description = "Generate a git commit message",
            opts = { placement = "cursor" },
            prompts = {
              {
                role = "system",
                content = [[You are an expert software engineer.
Review the provided context and diffs which are about to be committed to a git repo.
Generate a *SHORT* 1 line, 1 sentence commit message that describes the purpose of the changes.
The commit message MUST be in the past tense.
It must describe the changes *which have been made* in the diffs!
Reply with JUST the commit message, without quotes, comments, questions, etc!]],
              },
              {
                role = "user",
                content = [[ CONTEXT: ]] .. vim.fn.system "git diff --cached",
              },
            },
          },
        },
      }
    end,
  },

  {
    "jackMort/ChatGPT.nvim",
    enabled = false,
    cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions" },
    keys = {
      { "<leader>a", desc = "AI" },
      -- { "<leader>ae", "<cmd>ChatGPTEditWithInstructions<cr>", mode = { "n", "v" }, desc = "Edit with Instructions" },
      -- { "<leader>ac", "<cmd>ChatGPTRun complete_code<cr>", mode = { "n", "v" }, desc = "Complete Code" },
      -- { "<leader>ag", "<cmd>ChatGPTRun grammar_correction<cr>", mode = { "n", "v" }, desc = "Grammar Correction" },
      { "<leader>at", "<cmd>ChatGPTRun translate chinese<cr>", mode = { "n", "v" }, desc = "Translate" },
      { "<leader>ad", "<cmd>ChatGPTRun docstring<cr>", mode = { "n", "v" }, desc = "Docstring" },
      -- { "<leader>aa", "<cmd>ChatGPTRun add_tests<cr>", mode = { "n", "v" }, desc = "Add Tests" },
      -- { "<leader>ao", "<cmd>ChatGPTRun optimize_code<cr>", mode = { "n", "v" }, desc = "Optimize Code" },
      -- { "<leader>as", "<cmd>ChatGPTRun summarize<cr>", mode = { "n", "v" }, desc = "Summarize Code" },
      -- { "<leader>af", "<cmd>ChatGPTRun fix_bugs<cr>", mode = { "n", "v" }, desc = "Fix Bug" },
      -- { "<leader>ax", "<cmd>ChatGPTRun explain_code<cr>", mode = { "n", "v" }, desc = "Explain Code" },
      -- { "<leader>acr", "<cmd>ChatGPTRun roxygen_edit<cr>", mode = { "n", "v" }, desc = "Roxygen Edit" },
      -- { "<leader>aw", "<cmd>ChatGPTRun write_example<cr>", mode = { "n", "v" }, desc = "Write Example" },
      -- {
      --   "<leader>ar",
      --   "<cmd>ChatGPTRun code_readability_analysis<cr>",
      --   mode = { "n", "v" },
      --   desc = "Readablility Analysis",
      -- },
    },
    opts = {
      openai_params = {
        model = "gpt-4-1106-preview",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 3000,
        temperature = 0,
        top_p = 1,
        n = 1,
      },
      actions_paths = {
        vim.fn.stdpath "data" .. "/chatgpt/actions.json",
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

  {
    "Bryley/neoai.nvim",
    enabled = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
      "NeoAIShortcut",
    },
    keys = {
      -- { "<leader>aa", desc = "NeoAI" },
      { "<leader>as", desc = "Summarize Text" },
      { "<leader>ag", desc = "Generate Git Message" },
    },
    opts = {
      models = {
        {
          name = "openai",
          model = "gpt-3.5-turbo-1106",
          params = nil,
        },
      },
      shortcuts = {
        {
          name = "textify",
          key = "<leader>as",
          desc = "fix text with AI",
          use_context = true,
          prompt = [[
                Please rewrite the text to make it more readable, clear,
                concise, and fix any grammatical, punctuation, or spelling
                errors
            ]],
          modes = { "v" },
          strip_function = nil,
        },
        {
          name = "gitcommit",
          key = "<leader>ag",
          desc = "generate git commit message",
          use_context = false,
          prompt = function()
            return [[You are an expert software engineer.
Review the provided context and diffs which are about to be committed to a git repo.
Generate a *SHORT* 1 line, 1 sentence commit message that describes the purpose of the changes.
The commit message MUST be in the past tense.
It must describe the changes *which have been made* in the diffs!
Reply with JUST the commit message, without quotes, comments, questions, etc! CONTEXT: ]] .. vim.fn.system "git diff --cached"
          end,
          modes = { "n" },
          strip_function = nil,
        },
      },
    },
    config = function(_, opts)
      require("neoai").setup(opts)
    end,
  },

  {
    "piersolenski/wtf.nvim",
    enabled = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {},
    --stylua: ignore
    keys = {
      { "<leader>sd", function() require("wtf").ai() end, desc = "Search Diagnostic with AI" },
      { "<leader>sD", function() require("wtf").search() end, desc = "Search Diagnostic with Google" },
    },
  },

  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    enabled = false,
    -- stylua: ignore
    config = function ()
      vim.g.codeium_disable_bindings = 1
      vim.keymap.set("i", "<A-l>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("i", "<A-f>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<A-b>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<A-c>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
      vim.keymap.set("i", "<A-s>", function() return vim.fn["codeium#Complete"]() end, { expr = true })
    end,
  },
}
