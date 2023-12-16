return {
  "moll/vim-bbye",
  "nvim-lua/plenary.nvim",

  {
    "ethanholz/nvim-lastplace",
    config = true,
  },

  {
    "nacro90/numb.nvim",
    event = "BufReadPre",
    config = true,
  },

  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },

  {
    "danymat/neogen",
    keys = {
      { "<leader>lgt", "<cmd>Neogen type<cr>", desc = "Type doc" },
      { "<leader>lgc", "<cmd>Neogen class<cr>", desc = "Class doc" },
      { "<leader>lgf", "<cmd>Neogen func<cr>", desc = "Func doc" },
      { "<leader>lgd", "<cmd>Neogen file<cr>", desc = "Doc doc" },
    },
    event = "VeryLazy",
    config = true,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "BufRead",
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next ToDo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous ToDo" },
      { "<leader>lt", "<cmd>TodoTrouble<cr>", desc = "ToDo (Trouble)" },
      { "<leader>lT", "<cmd>TodoTelescope<cr>", desc = "ToDo" },
    },
  },

  {
    "SDGLBL/ggl.nvim",
    cmd = { "GLineLink", "GPermaLink" },
    config = true,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup(require("utils.lualine.styles").styles.lvim)
    end,
  },

  {
    "bennypowers/splitjoin.nvim",
    lazy = true,
    keys = {
      {
        "gj",
        function()
          require("splitjoin").join()
        end,
        desc = "Join the object under cursor",
      },
      {
        "g,",
        function()
          require("splitjoin").split()
        end,
        desc = "Split the object under cursor",
      },
    },
  },

  {
    "famiu/bufdelete.nvim",
    keys = {
      { "<leader>c", "<cmd>Bdelete!<CR>", desc = "Close Buffer" },
    },
  },
}
