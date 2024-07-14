return {
  {
    "github/copilot.vim",
    event = "VeryLazy",
    keys = {
      {
        "<C-s>",
        "<Plug>(copilot-next)",
        desc = "CoplitNext",
        mode = { "i" },
        callback = function()
          require("cmp").mapping.abort()(function() end)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(copilot-next)", true, true, true), "m", true)
        end,
      },
      {
        "<C-a>",
        "",
        desc = "CopilotSuggest",
        mode = { "i" },
        callback = function()
          require("cmp").mapping.abort()(function() end)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(copilot-suggest)", true, true, true), "m", true)
        end,
      },
      {
        "<C-d>",
        "<Plug>(copilot-dismiss)",
        desc = "CopilotDismiss",
        mode = { "i" },
      },
      {
        "<C-j>",
        "<Plug>(copilot-accept)",
        desc = "CopilotAccept",
        mode = { "i" },
        callback = function()
          require("cmp").mapping.abort()(function() end)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(copilot-accept)", true, true, true), "m", true)
        end,
      },
      {
        "<C-l>",
        "<Plug>(copilot-accept-word)",
        desc = "CopilotAcceptWord",
        mode = { "i" },
        callback = function()
          require("cmp").mapping.abort()(function() end)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(copilot-accept-word)", true, true, true), "m", true)
        end,
      },
    },
    config = function()
      -- copilot setup
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      vim.g.copilot_filetypes = {
        ["json"] = true,
        ["javascript"] = true,
        ["javascriptreact"] = true,
        ["typescript"] = true,
        ["typescriptreact"] = true,
        ["lua"] = true,
        ["rust"] = true,
        ["c"] = true,
        ["c#"] = true,
        ["c++"] = true,
        ["go"] = true,
        ["python"] = true,
        ["norg"] = true,
        ["sh"] = true,
      }

      vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })

      vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)")
    end,
  },
}
