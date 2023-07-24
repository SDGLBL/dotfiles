local swap_next, swap_prev = (function()
  local swap_objects = {
    p = "@parameter.inner",
    f = "@function.outer",
    c = "@class.outer",
  }

  local n, p = {}, {}
  for key, obj in pairs(swap_objects) do
    n[string.format("<leader>j%s", key)] = obj
    p[string.format("<leader>k%s", key)] = obj
  end

  return n, p
end)()

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- "p00f/nvim-ts-rainbow",
      "windwp/nvim-ts-autotag",
      "andymass/vim-matchup",
      "mfussenegger/nvim-ts-hint-textobject",
      "nvim-treesitter/nvim-treesitter-textobjects",
      {

        "romgrk/nvim-treesitter-context",
        enabled = not vim.g.neovide,
      },
      {
        url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
        config = function()
          -- This module contains a number of default definitions
          local rainbow_delimiters = require "rainbow-delimiters"

          vim.g.rainbow_delimiters = {
            strategy = {
              [""] = rainbow_delimiters.strategy["local"],
              vim = rainbow_delimiters.strategy["local"],
            },
            query = {
              [""] = "rainbow-delimiters",
              lua = "rainbow-blocks",
            },
            highlight = {
              "RainbowDelimiterRed",
              "RainbowDelimiterYellow",
              "RainbowDelimiterBlue",
              "RainbowDelimiterOrange",
              "RainbowDelimiterGreen",
              "RainbowDelimiterViolet",
              "RainbowDelimiterCyan",
            },
          }
        end,
      },
    },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "c",
        "php",
        "org",
        "css",
        "vim",
        "bash",
        "html",
        "yaml",
        "query",
        "regex",
        "toml",
      },
      highlight = {
        enable = true,
      },
      rainbow = {
        enable = false,
      },
      matchup = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
      indent = {
        enable = true,
        disable = { "python" },
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = "<TAB>",
          node_decremental = "<BS>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["il"] = "@loop.inner",
            ["al"] = "@loop.outer",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ap"] = "@parameter.outer",
            ["ip"] = "@parameter.inner",
            ["id"] = "@conditional.inner",
            ["ad"] = "@conditional.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = swap_next,
          swap_previous = swap_prev,
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
