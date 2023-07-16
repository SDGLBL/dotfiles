if not configs.vue then
  return {}
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "vue" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        volar = {},
      },
    },
  },
}
