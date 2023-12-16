return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        -- ["<leader>t"] = { name = "+Terminal" },
      },
    },
  },

  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    commit = "12cba0a",
    keys = {
      -- { "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>", desc = "Node" },
      -- { "<leader>tu", "<cmd>lua _NCDU_TOGGLE()<cr>", desc = "NCDU" },
      -- { "<leader>tw", "viw<cmd>Translate ZH<cr><esc>", desc = "Translate word" },
      -- { "<leader>tt", "<cmd>lua _HTOP_TOGGLE()<cr>", desc = "Htop" },
      -- { "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", desc = "Python" },
      -- { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float" },
      -- { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal" },
      -- { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical" },
    },
    config = function()
      local toggleterm = require "toggleterm"

      toggleterm.setup {
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        -- float
        direction = "float",
        close_on_exit = false,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      }

      function _G.set_terminal_keymaps()
        local opts = { noremap = true }
        -- vim.api.nvim_buf_set_keymap(0, "t", "<esc>"k [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
      end

      vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

      local Terminal = require("toggleterm.terminal").Terminal
      local git_commit = Terminal:new {
        cmd = "git cz",
        dir = "git_dir",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "double",
        },
      }

      function _GIT_COMMIT_TOGGLE()
        git_commit:toggle()
      end

      local lazygit = Terminal:new {
        cmd = "lazygit -ucf ~/.config/lazygit/config.yml",
        hidden = true,
        direction = "float",
        close_on_exit = true,
      }

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      local node = Terminal:new { cmd = "node", hidden = true }

      function _NODE_TOGGLE()
        node:toggle()
      end

      local ncdu = Terminal:new { cmd = "ncdu", hidden = true }

      function _NCDU_TOGGLE()
        ncdu:toggle()
      end

      local htop = Terminal:new { cmd = "htop", hidden = true }

      function _HTOP_TOGGLE()
        htop:toggle()
      end

      local python = Terminal:new { cmd = "python", hidden = true }

      function _PYTHON_TOGGLE()
        python:toggle()
      end
    end,
  },
}
