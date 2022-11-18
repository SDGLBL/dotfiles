local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "user.lsp.mason"
require("user.lsp.handlers").setup()
require "user.lsp.mason-null-ls"

local ok_which_key, wk = pcall(require, "which-key")

if ok_which_key then
  local code_action = "<cmd>lua vim.lsp.buf.code_action()<CR>"

  if vim.fn.exists ":CodeActionMenu" then
    code_action = "<cmd>CodeActionMenu<CR>"
  end

  wk.register({
    l = {
      name = "+LSP",
      a = { code_action, "Code Action" },
      f = { "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", "Format" },
      i = { "<cmd>LspInfo<cr>", "Lsp Info" },
      I = { "<cmd>LspInstallInfo<cr>", "Lsp Install Info" },
      j = { "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", "Next Diagnostic" },
      k = { "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", "Prev Diagnostic" },
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
      q = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Diagnostic list" },
    },
  }, require("user.whichkey").opts)
end
