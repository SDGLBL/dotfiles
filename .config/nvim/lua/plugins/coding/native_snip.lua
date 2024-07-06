local utils = require "utils.cmp"

return {
  {
    "nvim-cmp",
    dependencies = {
      {
        "garymjr/nvim-snippets",
        opts = {
          friendly_snippets = true,
          search_paths = {
            vim.fn.stdpath "config" .. "/snippets",
            vim.fn.stdpath "config" .. "/vscode-snippets",
          },
        },
        dependencies = { "rafamadriz/friendly-snippets" },
      },
    },
    opts = function(_, opts)
      opts.snippet = {
        expand = function(item)
          -- return vim.snippet.expand(item.body)
          return utils.expand(item.body)
        end,
      }
      table.insert(opts.sources, 1, { name = "snippets" })
    end,
    keys = {
      {
        "<Tab>",
        function()
          return vim.snippet.active { direction = 1 } and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
      {
        "<S-Tab>",
        function()
          return vim.snippet.active { direction = -1 } and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
    },
  },
}
