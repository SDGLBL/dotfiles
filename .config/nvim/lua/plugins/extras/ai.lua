return {
  {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions" },
    keys = {
      { "<leader>a", desc = "AI" },
      { "<leader>ae", "<cmd>ChatGPTEditWithInstructions<cr>", mode = { "n", "v" }, desc = "Edit with Instructions" },
      { "<leader>ac", "<cmd>ChatGPTRun complete_code<cr>", mode = { "n", "v" }, desc = "Complete Code" },
      -- { "<leader>ag", "<cmd>ChatGPTRun grammar_correction<cr>", mode = { "n", "v" }, desc = "Grammar Correction" },
      { "<leader>at", "<cmd>ChatGPTRun translate chinese<cr>", mode = { "n", "v" }, desc = "Translate" },
      { "<leader>ad", "<cmd>ChatGPTRun docstring<cr>", mode = { "n", "v" }, desc = "Docstring" },
      { "<leader>aa", "<cmd>ChatGPTRun add_tests<cr>", mode = { "n", "v" }, desc = "Add Tests" },
      { "<leader>ao", "<cmd>ChatGPTRun optimize_code<cr>", mode = { "n", "v" }, desc = "Optimize Code" },
      -- { "<leader>as", "<cmd>ChatGPTRun summarize<cr>", mode = { "n", "v" }, desc = "Summarize Code" },
      { "<leader>af", "<cmd>ChatGPTRun fix_bugs<cr>", mode = { "n", "v" }, desc = "Fix Bug" },
      { "<leader>ax", "<cmd>ChatGPTRun explain_code<cr>", mode = { "n", "v" }, desc = "Explain Code" },
      -- { "<leader>acr", "<cmd>ChatGPTRun roxygen_edit<cr>", mode = { "n", "v" }, desc = "Roxygen Edit" },
      { "<leader>aw", "<cmd>ChatGPTRun write_example<cr>", mode = { "n", "v" }, desc = "Write Example" },
      {
        "<leader>ar",
        "<cmd>ChatGPTRun code_readability_analysis<cr>",
        mode = { "n", "v" },
        desc = "Readablility Analysis",
      },
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
