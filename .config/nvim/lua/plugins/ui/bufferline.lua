return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>b", group = "Buffer" },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump" },
      -- {
      --   "<leader>bf",
      --   "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
      --   desc = "Find",
      -- },
      { "<leader>bb", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous" },
      { "<leader>be", "<cmd>BufferLinePickClose<cr>", desc = "Pick which buffer to close" },
      { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left" },
      { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close all to the right" },
      { "<leader>bD", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by directory" },
      { "<leader>bL", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by language" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin current buffer" },
      { "<leader>bm", "<cmd>WindowsMaximize<cr>", desc = "Maximize current buffer" },
    },
    config = function()
      local bufferline = require "bufferline"

      local icons = require "utils.icons"

      bufferline.setup {
        options = {
          indicator = {
            icon = icons.ui.BoldLineLeft,
            style = "icon",
          },
          buffer_close_icon = icons.ui.Close,
          modified_icon = icons.ui.Circle,
          close_icon = icons.ui.BoldClose,
          left_trunc_marker = icons.ui.ArrowCircleLeft,
          right_trunc_marker = icons.ui.ArrowCircleRight,
          max_name_length = 30,
          max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
          tab_size = 21,
          diagnostics = "nvim_lsp", -- | "nvim_lsp" | "coc",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            },
          },
          separator_style = "thick", -- "slant" | "thick" | "thin" | { 'any', 'any' }
          enforce_regular_tabs = true,
        },
        highlights = {
          fill = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          background = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          buffer_visible = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          close_button = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          close_button_visible = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          tab_selected = {
            fg = { attribute = "fg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
          tab = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          tab_close = {
            -- fg = {attribute='fg',highlight='LspDiagnosticsDefaultError'},
            fg = { attribute = "fg", highlight = "TabLineSel" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
          duplicate_selected = {
            fg = { attribute = "fg", highlight = "TabLineSel" },
            bg = { attribute = "bg", highlight = "TabLineSel" },
            italic = true,
          },
          duplicate_visible = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
            italic = true,
          },
          duplicate = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
            italic = true,
          },
          modified = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          modified_selected = {
            fg = { attribute = "fg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
          modified_visible = {
            fg = { attribute = "fg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          separator = {
            fg = { attribute = "bg", highlight = "TabLine" },
            bg = { attribute = "bg", highlight = "TabLine" },
          },
          separator_selected = {
            fg = { attribute = "bg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
          indicator_selected = {
            fg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
        },
      }
    end,
  },
}
