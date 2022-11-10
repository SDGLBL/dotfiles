local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

local ok_nlsp, nlspsettings = pcall(require, "nlspsettings")

if ok_nlsp then
  nlspsettings.setup {
    config_home = vim.fn.stdpath "config" .. "/nlsp-settings",
    local_settings_dir = ".nlsp-settings",
    local_settings_root_markers_fallback = { ".git" },
    append_default_schemas = true,
    loader = "json",
  }
end

local lspconfig = require "lspconfig"

local servers = {
  "jsonls",
  "sumneko_lua",
  "tsserver",
  -- "jedi_language_server",
  "gopls",
  "ccls",
  "clangd",
  "cssls",
  "yamlls",
  "bashls",
  "dockerls",
  "rust_analyzer",
  "emmet_ls",
  "asm_lsp",
  "pylsp",
}

lsp_installer.setup {
  ensure_installed = servers,
}

local capabilities = require("user.lsp.handlers").capabilities
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
  capabilities = capabilities,
})

local opts = {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = capabilities,
}

for _, server in pairs(servers) do
  local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
  end

  lspconfig[server].setup(opts)
end
