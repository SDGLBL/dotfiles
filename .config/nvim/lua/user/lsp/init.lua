if not configs.lsp then
  return
end

local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "user.lsp.mason"
require("user.lsp.handlers").setup()
require "user.lsp.mason-null-ls"
require "user.lsp.mason-nvim-dap"

local ok_which_key, wk = pcall(require, "which-key")

if ok_which_key then
  local code_action = "<cmd>lua vim.lsp.buf.code_action()<cr>"

  if vim.fn.exists ":CodeActionMenu" then
    code_action = "<cmd>CodeActionMenu<cr>"
  end

  wk.register({
    l = {
      name = "+LSP",
      a = { code_action, "Code Action" },
      f = { "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", "Format" },
      i = { "<cmd>Telescope lsp_implementations<cr>", "Impl" },
      j = { "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", "Next Diagnostic" },
      k = { "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", "Prev Diagnostic" },
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      R = { "<cmd>Telescope lsp_references<cr>", "References" },
      ["rr"] = { "<cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", "Switch refactoring" },
      s = { "<cmd>Telescope lsp_document_symbols<cr>", "Doc Symbols" },
      S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
      q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Diagnostic List" },
      w = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
      W = { '<cmd>lua require("telescope.builtin").diagnostics({ bufnr = 0 })<cr>', "Doc Diagnostics" },
      e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
    },
  }, require("user.whichkey").opts)
end
