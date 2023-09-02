if not configs.nix then
  return {}
end

return {
  -- add nix to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "nix" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      -- LSP Server Settings
      servers = {
        nil_ls = {
          settings = {
            nil_ls = {},
          },
        },
      },
    },
  },
}
