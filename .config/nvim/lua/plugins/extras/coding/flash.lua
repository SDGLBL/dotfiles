return {
  {
    "folke/flash.nvim",
    -- enabled = false,
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        "m",
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
      -- {
      --   "<leader>t",
      --   mode = { "n", "o", "x" },
      --   function()
      --     local win = vim.api.nvim_get_current_win()
      --     local view = vim.fn.winsaveview()
      --     require("flash").jump {
      --       action = function(match, state)
      --         state:hide()
      --         vim.api.nvim_set_current_win(match.win)
      --         vim.api.nvim_win_set_cursor(match.win, match.pos)
      --         require("flash").treesitter()
      --         vim.schedule(function()
      --           vim.api.nvim_set_current_win(win)
      --           vim.fn.winrestview(view)
      --         end)
      --       end,
      --     }
      --   end,
      --   desc = "Flash Treesitter Copy",
      -- },
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

  -- Flash Telescope config
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      if not require("utils").has "flash.nvim" then
        return
      end
      local function flash(prompt_bufnr)
        require("flash").jump {
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        }
      end
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = { n = { s = flash }, i = { ["<C-s>"] = flash } },
      })
    end,
  },
}
