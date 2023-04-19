return {
  "moll/vim-bbye",
  "nvim-lua/plenary.nvim",
  "stevearc/dressing.nvim",
  "nvim-tree/nvim-web-devicons",
  "weilbith/nvim-code-action-menu",

  {
    "github/copilot.vim",
    event = "VeryLazy",
  },
  {
    "ethanholz/nvim-lastplace",
    config = true,
  },
  {
    "levouh/tint.nvim",
    enabled = configs.tint,
    event = "VeryLazy",
    config = true,
  },
  {
    "nacro90/numb.nvim",
    event = "BufReadPre",
    config = true,
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = true,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
  },
  {
    "uga-rosa/ccc.nvim",
    ft = { "javascriptreact", "javascript", "typescript", "typescriptreact", "css", "html", "lua" },
    enabled = configs.color_picker,
    config = function(_, opts)
      require("ccc").setup {}

      require("utils.whichkey").register({ C = { "<cmd>CccPick<cr>", "Color picker" } }, opts)
    end,
  },
  {

    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup(require("utils.lualine.styles").styles.lvim)
    end,
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
    "norcalli/nvim-colorizer.lua",
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
    "edolphin-ydf/goimpl.nvim",
    ft = "go",
    build = "go install github.com/josharian/impl@latest",
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.load_extension "goimpl"
      end
    end,
  },
  {
    "SDGLBL/ggl.nvim",
    cmd = { "GLineLink", "GPermaLink" },
    config = true,
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
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("crates").setup()
    end,
    enabled = configs.rust_tools,
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup {
        text = {
          spinner = "dots", -- animation shown when tasks are ongoing
        },
        window = {
          relative = "editor", -- window position
        },
      }
    end,
  },
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = function()
      vim.o.winwidth = 20
      vim.o.winminwidth = 5
      vim.o.equalalways = false
      require("windows").setup {
        animation = {
          enable = true,
          duration = 200,
          fps = 60,
        },
      }
    end,
    enabled = not vim.g.neovide,
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
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup {
        extra_groups = {
          "SignColumn",
          "TelescopeBorder",
          "TelescopeNormal",
          "NvimTreeNormal",
          "NvimTreeNormalNC",
          "MsgArea",
          "HopPreview",
        }, -- table: additional groups that should be cleared
        exclude_groups = {}, -- table: groups you don't want to clear
      }
    end,
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    event = "BufWinEnter",
    dependencies = {
      "SmiteshP/nvim-navic",
    },
    config = function()
      -- triggers CursorHold event faster
      vim.opt.updatetime = 200

      local icons = require "utils.icons"

      require("barbecue").setup {
        create_autocmd = false, -- prevent barbecue from updating itself automatically
        kinds = require("utils.icons").kind,
        symbols = {
          modified = "●",
          ellipsis = "…",
          separator = icons.ui.ChevronRight,
        },
      }

      vim.api.nvim_create_autocmd({
        "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",

        -- include this if you have set `show_modified` to `true`
        "BufModifiedSet",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })
    end,
  },

  {
    "m-demare/hlargs.nvim",
    event = "VeryLazy",
    config = function()
      require("hlargs").setup {
        disable = function(_, bufnr)
          if vim.b.semantic_tokens then
            return true
          end

          local clients = vim.lsp.get_active_clients { bufnr = bufnr }

          for _, c in pairs(clients) do
            local caps = c.server_capabilities
            if c.name ~= "null-ls" and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
              vim.b.semantic_tokens = true
              return vim.b.semantic_tokens
            end
          end
        end,
      }
    end,
    enabled = configs.hlargs,
  },
}
