local servers = {
  "jsonls",
  "sumneko_lua",
  "tsserver",
  "gopls",
  "yamlls",
  "bashls",
  "dockerls",
  "rust_analyzer",
  "emmet_ls",
  "pylsp",
}

-- if use rust-tools then remove rust_analyzer from servers
if configs.rust_tools then
  for i, server in ipairs(servers) do
    if server == "rust_analyzer" then
      table.remove(servers, i)
    end
  end
end

local settings = {
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

require("mason").setup(settings)
require("mason-lspconfig").setup {
  ensure_installed = servers,
  automatic_installation = true,
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  ---@diagnostic disable-next-line: missing-parameter
  server = vim.split(server, "@")[1]

  local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
  if require_ok then
    opts = vim.tbl_deep_extend("force", conf_opts, opts)
  end

  lspconfig[server].setup(opts)
end
