return {
  "moll/vim-bbye",
  "nvim-lua/plenary.nvim",

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

  {
    "SDGLBL/hapigo.nvim",
    dependencies = {
      {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
          vdefaults = {
            ["<leader>c"] = { name = "+Copy" },
            ["<leader>a"] = { name = "+AI" },
            ["<leader>ac"] = { name = "+ChatGPT" },
            ["<leader>an"] = { name = "+NeoAI" },
            ["<leader>l"] = { name = "+LSP" },
          },
        },
      },
    },
    cmd = {
      "HapigoAPPSerchWord",
      "HapigoAPPSerch",
      "HapigoFileSerchWord",
      "HapigoFileSerch",
      "HapigoClipboardSerchWord",
      "HapigoClipboardSerch",
      "HapigoTranslateWord",
      "HapigoTranslate",
    },
    keys = {
      {
        "<leader>cs",
        function()
          local text = require("hapigo.config").config.visual_text()
          vim.fn.setreg("+", text)
        end,
        mode = "v",
        desc = "Join By Space",
      },
    },
    config = true,
  },

  {
    "phaazon/hop.nvim",
    event = "VeryLazy",
    branch = "v2",
    enabled = false,
    dependencies = {
      {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
          defaults = {
            ["<leader>m"] = { name = "+Move" },
          },
        },
      },
    },
    keys = {
      { "<leader>mw", "<cmd>HopWord<cr>", desc = "HopWord" },
      { "<leader>ml", "<cmd>HopLine<cr>", desc = "HopLine" },
      { "<leader>ma", "<cmd>HopAnywhere<cr>", desc = "HopAnywhere" },
      { "<leader>mv", "<cmd>HopVertical<cr>", desc = "HopVertical" },
      { "<leader>mc", "<cmd>HopChar1<cr>", desc = "HopChar1" },
      { "<leader>m2", "<cmd>HopChar2<cr>", desc = "HopChar2" },
      { "<leader>mp", "<cmd>HopPattern<cr>", desc = "HopPattern" },
      { "<leader>mn", "<cmd>lua require'tsht'.nodes()<cr>", desc = "TSNodes" },
      { "<leader>mb", "<cmd>lua require('dropbar.api').pick()<cr>", desc = "DropBar" },
    },
    config = true,
  },

  {
    "gbprod/yanky.nvim",
    keys = {
      { "p", "<Plug>(YankyPutAfter)", desc = "PutAfter", mode = { "n", "v" } },
      { "P", "<Plug>(YankyPutBefore)", desc = "PutBefore", mode = { "n", "v" } },
      { "gp", "<Plug>(YankyGPutAfter)", desc = "GPutAfter", mode = { "n", "v" } },
      { "gP", "<Plug>(YankyGPutBefore)", desc = "GPutBefore", mode = { "n", "v" } },
      { "<c-n>", "<Plug>(YankyCycleForward)", desc = "CycleForward", mode = { "n" } },
      { "<c-p>", "<Plug>(YankyCycleBackward)", desc = "CycleBackward", mode = { "n" } },
    },
    config = function()
      require("yanky").setup {
        highlight = {
          on_put = false,
          on_yank = false,
          timer = 500,
        },
      }

      local ok, telescope = pcall(require, "telescope")
      if ok then
        require("telescope").load_extension "yank_history"
      end
    end,
  },
}
