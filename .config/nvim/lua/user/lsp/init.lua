local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "user.lsp.mason"
require("user.lsp.handlers").setup()
require "user.lsp.mason-null-ls"

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
      R = { "<cmd>Telescope lsp_references<cr>","References" },
      s = { "<cmd>Telescope lsp_document_symbols<cr>", "Doc Symbols" },
      S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols" },
      q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Diagnostic List" },
    },
  }, require("user.whichkey").opts)
end
