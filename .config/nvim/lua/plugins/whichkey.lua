return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require "which-key"

      local icons = require "utils.icons"

      local opts = require("utils.whichkey").opts

      local mappings = {
        ["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment" },
        ["a"] = { "<cmd>Alpha<cr>", "Alpha" },
        ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
        ["w"] = { "<cmd>w!<CR>", "Save" },
        ["W"] = { "<cmd>noautocmd w!<CR>", "NoAutocmd Save" },
        ["R"] = { '<cmd>lua require("configs").reload()<CR>', "Reload" },
        ["q"] = { "<cmd>q!<CR>", "Quit" },
        ["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
        ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
        ["f"] = {
          "<cmd>Telescope find_files<cr>",
          "Find files",
        },
        b = {
          name = "Buffers",
          j = { "<cmd>BufferLinePick<cr>", "Jump" },
          f = {
            "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
            "Find",
          },
          b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
          e = {
            "<cmd>BufferLinePickClose<cr>",
            "Pick which buffer to close",
          },
          h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
          l = {
            "<cmd>BufferLineCloseRight<cr>",
            "Close all to the right",
          },
          D = {
            "<cmd>BufferLineSortByDirectory<cr>",
            "Sort by directory",
          },
          L = {
            "<cmd>BufferLineSortByExtension<cr>",
            "Sort by language",
          },
          p = { "<cmd>BufferLineTogglePin<cr>", "Pin current buffer" },
          m = { "<cmd>WindowsMaximize<cr>", "Maximize current buffer" },
        },
        v = {
          name = "DiffView",
          o = { "<cmd>DiffviewOpen<cr>", "ViewOpen" },
          c = { "<cmd>DiffviewClose<cr>", "ViewClose" },
          r = { "<cmd>DiffviewRefresh<cr>", "ViewRefresh" },
          h = { "<cmd>DiffviewFileHistory<cr>", "FileHistory" },
          f = { "<cmd>DiffviewFileHistory %<cr>", "Current File FileHistory" },
          t = { "<cmd>DiffviewToggleFiles<cr>", "ToggleFiles" },
        },
        g = {
          name = "Git",
          g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
          j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
          k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
          l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
          p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
          r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
          R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
          s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
          u = {
            "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
            "Undo Stage Hunk",
          },
          t = {
            "Toggle",
            n = { "<cmd>lua require 'gitsigns'.toggle_numhl()<cr>", "Toggle Numhl" },
            l = { "<cmd>lua require 'gitsigns'.toggle_linehl()<cr>", "Toggle Linehl" },
            w = { "<cmd>lua require 'gitsigns'.toggle_word_diff()<cr>", "Toggle Word Diff" },
          },
          o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
          b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
          c = { "<cmd>lua _GIT_COMMIT_TOGGLE()<cr>", "Git cz Commit" },
          C = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        },
        s = {
          name = "Search/Session",
          b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
          t = { "<cmd>Telescope live_grep<cr>", "Find Text" },
          c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
          h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
          M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
          r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
          R = { "<cmd>Telescope registers<cr>", "Registers" },
          k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
          C = { "<cmd>Telescope commands<cr>", "Commands" },
          s = { "<cmd>SessionSave<cr>", "Save Session" },
          l = { "<cmd>SessionLoad<cr>", "Load Session" },
          L = { "<cmd>SessionLoadLast<cr>", "Load Last Session" },
          d = { "<cmd>SessionDelete<cr>", "Del Cur Session" },
          p = {
            "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
            "Colorscheme with Preview",
          },
        },
        t = {
          name = "Terminal",
          -- n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
          u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
          w = { "viw<cmd>Translate ZH<cr><esc>", "Translate word" },
          t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
          p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
          f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
          h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
          v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
        },
        m = {
          name = "Hop",
          w = { "<cmd>HopWord<cr>", "HopWord" },
          l = { "<cmd>HopLine<cr>", "HopLine" },
          a = { "<cmd>HopAnywhere<cr>", "HopAnywhere" },
          v = { "<cmd>HopVertical<cr>", "HopVertical" },
          c = { "<cmd>HopChar1<cr>", "HopChar1" },
          ["2"] = { "<cmd>HopChar2<cr>", "HopChar2" },
          p = { "<cmd>HopPattern<cr>", "HopPattern" },
          n = { "<cmd>lua require'tsht'.nodes()<cr>", "TSNodes" },
        },
        u = { "<cmd>Telescope undo<cr>", "Undo" },
      }

      local vopts = require("utils.whichkey").vopts

      local vmappings = {
        ["/"] = { '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', "Comment" },
        ["r"] = {
          name = "Refactoring",
          r = { "<esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", "Switch" },
        },
        ["t"] = { "<cmd>Translate ZH<cr>", "Translate" },
      }

      wk.setup {
        plugins = {
          marks = true, -- shows a list of your marks on ' and `
          registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
          spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
          },
          -- the presets plugin, adds help for a bunch of default keybindings in Neovim
          -- No actual key bindings are created
          presets = {
            operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
          },
        },
        -- add operators that will trigger motion and text object completion
        -- to enable all native operators, set the preset / operators plugin above
        -- operators = { gc = "Comments" },
        key_labels = {
          -- override the label used to display some keys. It doesn't effect WK in any other way.
          -- For example:
          -- ["<space>"] = "SPC",
          -- ["<cr>"] = "RET",
          -- ["<tab>"] = "TAB",
        },
        icons = {
          breadcrumb = icons.ui.DoubleChevronRight,
          separator = icons.ui.BoldArrowRight,
          group = icons.ui.Plus,
        },
        popup_mappings = {
          scroll_down = "<c-d>", -- binding to scroll down inside the popup
          scroll_up = "<c-u>", -- binding to scroll up inside the popup
        },
        window = {
          border = "rounded", -- none, single, double, shadow
          position = "bottom", -- bottom, top
          margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
          padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
          winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3, -- spacing between columns
          align = "left", -- align columns left, center or right
        },
        ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
        show_help = true, -- show help message on the command line when the popup is visible
        triggers = "auto", -- automatically setup triggers
        -- triggers = { "<leader>" }, -- or specify a list manually
        triggers_blacklist = {
          -- list of mode / prefixes that should never be hooked by WhichKey
          -- this is mostly relevant for key maps that start with a native binding
          -- most people should not need to change this
          i = { "j", "k" },
          v = { "j", "k" },
        },
        -- disable the WhichKey popup for certain buf types and file types.
        -- Disabled by default for Telescope
        disable = {
          buftypes = {},
          filetypes = { "TelescopePrompt" },
        },
      }
      -- {
      --   show_help = false,
      --   key_labels = { ["<leader>"] = "SPC" },
      --   triggers = "auto",
      --   icons = {
      --     breadcrumb = icons.ui.DoubleChevronRight,
      --     separator = icons.ui.BoldArrowRight,
      --     group = icons.ui.Plus,
      --   },
      --   window = {
      --     border = "rounded",
      --     padding = { 2, 2, 2, 2 },
      --   },
      --   disable = {
      --     buftypes = {},
      --     filetypes = { "TelescopePrompt" },
      --   },
      -- }

      wk.register(mappings, opts)
      wk.register(vmappings, vopts)

      local c = _G.configs

      -- setup dap keymaps
      if c.dap then
        wk.register({
          d = {
            name = "+Debugger",
            b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "toggle breakpoint" },
            c = { "<cmd>lua require'dap'.continue()<cr>", "continue" },
            C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "continue to cursor" },
            j = { "<cmd>lua require'dap'.step_over()<cr>", "step over" },
            s = { "<cmd>lua require'dap'.step_into()<cr>", "step into" },
            S = { "<cmd>lua require'dap'.step_out()<cr>", "step out" },
            e = { "<cmd>lua require'dap'.close()<cr>", "stop debugger" },
            l = { "<cmd>lua require'dap'.list_breakpoints()<cr>", "list all breakpoint" },
            r = { "<cmd>lua require'dap'.clear_breakpoints()<cr>", "remove all breakpont" },
            o = { "<cmd>lua require'dapui'.open()<cr>", "open debug ui window" },
            x = { "<cmd>lua require'dapui'.close()<cr>", "close debug ui window" },
            t = { "<cmd>lua require'dapui'.toggle()<cr>", "toggle debug ui window" },
            f = { "<cmd>lua require'dapui'.float_element()<cr>", "get value" },
            v = { "<cmd>lua require'dapui'.eval(nil,{enter=true})<cr>", "eval value" },
          },
        }, opts)
      end

      if c.refactor then
        wk.register({
          r = {
            name = "Refactoring",
            r = { "<esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", "Switch" },
          },
        }, opts)
      end

      if c.lsp then
        local code_action = "<cmd>lua vim.lsp.buf.code_action()<cr>"

        if vim.fn.exists ":CodeActionMenu" then
          code_action = "<cmd>CodeActionMenu<cr>"
        end

        local km = {
          l = {
            name = "+LSP",
            a = { code_action, "Code Action" },
            f = { "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", "Format" },
            g = {
              Name = "Generate Doc",
              t = { "<cmd>Neogen type<cr>", "Type doc" },
              c = { "<cmd>Neogen class<cr>", "Class doc" },
              f = { "<cmd>Neogen func<cr>", "Func doc" },
              d = { "<cmd>Neogen file<cr>", "Doc doc" },
            },
            I = { "<cmd>Telescope lsp_implementations<cr>", "Implementations" },
            j = { "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", "Next Diagnostic" },
            k = { "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", "Prev Diagnostic" },
            r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
            R = { "<cmd>Telescope lsp_references<cr>", "References" },
            s = { "<cmd>Telescope lsp_document_symbols<cr>", "Doc Symbols" },
            S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
            q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Diagnostic List" },
            w = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
            W = { '<cmd>lua require("telescope.builtin").diagnostics({ bufnr = 0 })<cr>', "Doc Diagnostics" },
            e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
            h = { ":lua require('lsp-inlayhints').toggle()<cr>", "Toggle InlayHints" },
          },
        }

        if configs.refactor then
          km["l"]["c"] =
            { "<cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", "Choose refactoring" }
        end

        wk.register(km, opts)
      end
    end,
  },
}
