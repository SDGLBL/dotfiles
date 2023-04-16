local default_workspace = {
  library = {
    vim.fn.expand "$VIMRUNTIME",
    require("neodev.config").types(),
  },
  checkThirdParty = false,

  maxPreload = 5000,
  preloadFileSize = 10000,
}

local add_packages_to_workspace = function(packages, config)
  -- config.settings.Lua = config.settings.Lua or { workspace = default_workspace }
  local runtimedirs = vim.api.nvim__get_runtime({ "lua" }, true, { is_lua = true })
  table.insert(runtimedirs, "~/.config/new_nvim/lua")
  local workspace = config.settings.Lua.workspace
  for _, v in pairs(runtimedirs) do
    for _, pack in ipairs(packages) do
      if v:match(pack) and not vim.tbl_contains(workspace.library, v) then
        table.insert(workspace.library, v)
      end
    end
  end
end

local lspconfig = require "lspconfig"

local make_on_new_config = function(on_new_config, _)
  return lspconfig.util.add_hook_before(on_new_config, function(new_config, _)
    local server_name = new_config.name

    if server_name ~= "lua_ls" then
      return
    end
    local plugins = { "plenary.nvim", "telescope.nvim", "nvim-treesitter", "LuaSnip" }
    add_packages_to_workspace(plugins, new_config)
  end)
end

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
  on_new_config = make_on_new_config(lspconfig.util.default_config.on_new_config),
})

return {

  -- add lua to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "lua" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              telemetry = {
                enable = false,
              },
              diagnostics = {
                globals = { "vim" },
              },
              runtime = {
                version = "LuaJIT",
                special = {
                  reload = "require",
                },
              },
              workspace = default_workspace,
            },
          },
        },
      },
    },
  },
}
