return {
  {
    "github/copilot.vim",
    event = "VeryLazy",
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
    end,
  },
}
