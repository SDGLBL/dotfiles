return {
  {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions" },
    keys = {
      { "<leader>a", desc = "AI" },
      { "<leader>ac", desc = "ChatGPT" },
      { "<leader>ace", "<cmd>ChatGPTEditWithInstructions<cr>", mode = { "n", "v" }, desc = "Edit with Instructions" },
      { "<leader>acc", "<cmd>ChatGPTRun complete_code<cr>", mode = { "n", "v" }, desc = "Complete Code" },
      { "<leader>acg", "<cmd>ChatGPTRun grammar_correction<cr>", mode = { "n", "v" }, desc = "Grammar Correction" },
      { "<leader>act", "<cmd>ChatGPTRun translate chinese<cr>", mode = { "n", "v" }, desc = "Translate" },
      { "<leader>acd", "<cmd>ChatGPTRun docstring<cr>", mode = { "n", "v" }, desc = "Docstring" },
      { "<leader>aca", "<cmd>ChatGPTRun add_tests<cr>", mode = { "n", "v" }, desc = "Add Tests" },
      { "<leader>aco", "<cmd>ChatGPTRun optimize_code<cr>", mode = { "n", "v" }, desc = "Optimize Code" },
      { "<leader>acs", "<cmd>ChatGPTRun summarize<cr>", mode = { "n", "v" }, desc = "Summarize Code" },
      { "<leader>acf", "<cmd>ChatGPTRun fix_bugs<cr>", mode = { "n", "v" }, desc = "Fix Bug" },
      { "<leader>acx", "<cmd>ChatGPTRun explain_code<cr>", mode = { "n", "v" }, desc = "Explain Code" },
      -- { "<leader>acr", "<cmd>ChatGPTRun roxygen_edit<cr>", mode = { "n", "v" }, desc = "Roxygen Edit" },
      { "<leader>acr", "<cmd>ChatGPTRun write_example<cr>", mode = { "n", "v" }, desc = "Write Example" },
      { "<leader>acl", "<cmd>ChatGPTRun code_readability_analysis<cr>", mode = { "n", "v" }, desc = "Code Analysis" },
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
      { "<leader>aa", desc = "NeoAI" },
      { "<leader>aas", desc = "Summarize Text" },
      { "<leader>aag", desc = "Generate Git Message" },
    },
    opts = {
      shortcuts = {
        {
          name = "textify",
          key = "<leader>aas",
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
          key = "<leader>aag",
          desc = "generate git commit message",
          use_context = false,
          prompt = function()
            return [[
                    Using the following git diff generate a consise and
                    clear git commit message, with a short title summary
                    that is 75 characters or less:
                ]] .. vim.fn.system "git diff --cached"
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
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {},
    --stylua: ignore
    keys = {
      { "<leader>sD", function() require("wtf").ai() end, desc = "Search Diagnostic with AI" },
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
