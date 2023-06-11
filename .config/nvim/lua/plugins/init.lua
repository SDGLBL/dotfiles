return {
  "moll/vim-bbye",
  "nvim-lua/plenary.nvim",
  "famiu/bufdelete.nvim",

  {
    "wintermute-cell/gitignore.nvim",
    cmd = "Gitignore",
  },

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
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory ",
    },
    config = true,
  },

  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
    },
    enabled = configs.dap,
  },

  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },

  {
    "phaazon/hop.nvim",
    event = "VeryLazy",
    branch = "v2",
    config = true,
  },

  {
    "danymat/neogen",
    event = "VeryLazy",
    config = true,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "BufRead",
    config = true,
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
    "uga-rosa/translate.nvim",
    event = "VeryLazy",
    config = function()
      require("translate").setup {
        default = {
          command = "google",
          output = "floating",
        },
        preset = {
          output = {
            split = {
              append = true,
            },
          },
        },
      }
    end,
  },

  {
    "olimorris/persisted.nvim",
    event = "BufReadPre",
    config = function()
      require("persisted").setup {
        use_git_branch = true,
        should_autosave = function()
          -- do not autosave if the alpha dashboard is the current filetype
          if vim.bo.filetype == "alpha" then
            return false
          end
          return true
        end,
      }

      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.load_extension "persisted"
      end
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
}
