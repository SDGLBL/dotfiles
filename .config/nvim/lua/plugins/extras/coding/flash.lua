return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          -- default options: exact mode, multi window, all directions, with a backdrop
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "<leader>t",
        mode = { "n", "o", "x" },
        function()
          local win = vim.api.nvim_get_current_win()
          local view = vim.fn.winsaveview()
          require("flash").jump {
            action = function(match, state)
              state:hide()
              vim.api.nvim_set_current_win(match.win)
              vim.api.nvim_win_set_cursor(match.win, match.pos)
              require("flash").treesitter()
              vim.schedule(function()
                vim.api.nvim_set_current_win(win)
                vim.fn.winrestview(view)
              end)
            end,
          }
        end,
        desc = "Flash Treesitter Copy",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
    },
  },
}
