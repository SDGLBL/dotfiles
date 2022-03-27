-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.lint_on_save = true
lvim.transparent_window = true
-- lvim.colorscheme = 'sonokai'
-- lvim.colorscheme = 'monokai_soda'
-- lvim.colorscheme = 'onedarkpro'
lvim.colorscheme = 'tokyonight'
-- lvim.colorscheme = 'rose-pine'

-- colorscheme sonokai style
-- `'default'`, `'atlantis'`, `'andromeda'`, `'shusia'`, `'maia'`, `'espresso'`
vim.g.sonokai_style = 'shusia'

-- vim opt set
vim.opt.relativenumber = true
vim.opt.shell = "/bin/sh"
vim.opt.scrolloff = 5
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cmdheight = 1
vim.opt.conceallevel = 0
vim.opt.cursorline = true
vim.opt.colorcolumn = "99999"

-- copilot setup
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""


-- Please check https://github.com/agriffis/skel/blob/master/neovim/bin/clipboard-provider
-- vim.g['clipboard'] = {
--     ['name']='clipboard-provider',
--     ['copy']= {
--         ['+']= 'clipboard-provider copy',
--         ['*']= 'clipboard-provider copy',
--     },
--     ['paste']= {
--         ['+']= 'clipboard-provider paste',
--         ['*']= 'clipboard-provider paste',
--     },
-- }

-- Please check https://github.com/equalsraf/win32yank
-- If you use wsl2 or wsl in windows
-- vim.g.clipboard = {
--   ["name"] = "win32yank-wsl",
--   ['copy']= {
--       ['+']= '/mnt/c/Users/lijie/win32yank.exe -i --crlf',
--       ['*']= '/mnt/c/Users/lijie/win32yank.exe -i --crlf',
--   },
--   ['paste']= {
--       ['+']= '/mnt/c/Users/lijie/win32yank.exe -o --lf',
--       ['*']= '/mnt/c/Users/lijie/win32yank.exe -o --lf',
--   },
-- }


-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode = {
  -- Disable Ex mode, because what the fuck is that...
  ["Q"] = "<NOP>",
  -- Alternative way to save
  ["<C-s>"] = ":SymbolsOutline<CR>",
  -- Use CTRL+C instead of <ESC>...
  ["<C-c>"] = "<ESC>",

  -- Navigate buffers
  ["<Tab>"] = ":bnext<CR>",
  ["<S-Tab>"] = ":bprevious<CR>",

  -- Windows control
  ["sq"] = "<C-w><C-q>",
  ["ss"] = ":split<Return><C-w>w",
  ["sv"] = ":vsplit<Return><C-w>w",
  ["sh"] = "<C-w>h",
  ["sk"] = "<C-w>k",
  ["sj"] = "<C-w>j",
  ["sl"] = "<C-w>l",
}

lvim.keys.visual_block_mode = {
  -- Move line in visual modle
  ["K"] = ":move '<-2<CR>gv-gv",
  ["J"] = ":move '>+1<CR>gv-gv",
}



-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dap.active = true
lvim.builtin.alpha.active = true
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 1



-- terminal setup
lvim.builtin.terminal.open_mapping = "<c-\\>"
-- lvim.builtin.terminal.float_opts.width = 240
-- lvim.builtin.terminal.float_opts.height = 40

-- Copilot key mapping
lvim.builtin.cmp.mapping["<C-e>"] = function (fallback)
    require "cmp".mapping.abort()
    local copilot_keys = vim.fn["copilot#Accept"]()
    if copilot_keys ~= "" then
      vim.api.nvim_feedkeys(copilot_keys, "i", true)
    else
      fallback()
    end
end


-- Lualine setup
local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.sections.lualine_a = {
  components.mode
}
lvim.builtin.lualine.sections.lualine_c = {
  components.encoding
}

-- treesister setup
-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
  "go",
  "php",
}

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.treesitter.matchup.enable = true
lvim.builtin.treesitter.textobjects.select.enable = true
lvim.builtin.treesitter.textobjects.select.lookahead = true
lvim.builtin.treesitter.textobjects.select.keymaps = {
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
    ["il"] = "@loop.inner",
    ["al"] = "@loop.outer",
    ["ip"] = "@parameter.inner",
    ["ap"] = "@parameter.outer",
}

require("nvim-treesitter.configs").setup {
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<TAB>",
            node_decremental = "<BS>",
        }
    },
    indent = {
        enable = true,
    }
}

local exist,dap = pcall(require,"dap")

if exist then
    -- go debug
    dap.adapters.go = {
        type = 'executable';
        command = 'node';
        args ={ '/home/lijie/.local/share/nvim/dapinstall/go/vscode-go/dist/debugAdapter.js'};
    }
    dap.configurations.go = {
    {
            type = 'go';
            name = 'Debug';
            request = 'launch';
            showLog = false;
            program = "${file}";
            dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed
        },
    {
            type = "go",
            name = "Attach",
            request = "attach",
            processId = require("dap.utils").pick_process,
            -- program = "${workspaceFolder}",
            dlvToolPath = vim.fn.exepath('dlv')
        },
    {
            type = "go",
            name = "Debug curr test",
            request = "launch",
            mode = "test",
            program = "${file}",
            dlvToolPath = vim.fn.exepath('dlv')
        },
    {
            type = "go",
            name = "Debug test",
            request = "launch",
            mode = "test",
            program = "${workspaceFolder}",
            dlvToolPath = vim.fn.exepath('dlv')
        },

    }

    lvim.builtin.which_key.mappings["d"] = {
        name = "+Debugger",
        b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "toggle breakpoint" },
        c = { "<cmd>lua require'dap'.continue()<cr>", "continue" },
        C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "continue to cursor" },
        n = { "<cmd>lua require'dap'.step_over()<cr>", "step over" },
        s = { "<cmd>lua require'dap'.step_into()<cr>", "step into" },
        S = { "<cmd>lua require'dap'.step_out()<cr>", "step out" },
        e = { "<cmd>lua require'dap'.close()<cr>", "stop debugger" },
        l = { "<cmd>lua require'dap'.list_breakpoints()<cr>", "list all breakpoint"},
        r = { "<cmd>lua require'dap'.clear_breakpoints()<cr>","remove all breakpont"},
        o = {"<cmd>lua require'dapui'.open()<cr>", "open debug ui window" },
        x = {"<cmd>lua require'dapui'.close()<cr>", "close debug ui window" },
        t = {"<cmd>lua require'dapui'.toggle()<cr>", "toggle debug ui window" },
        f = {"<cmd>lua require'dapui'.float_element()<cr>", "get value" },
        v = {"<cmd>lua require'dapui'.eval(nil,{enter=true})<cr>", "eval value" },
    }

    -- python debug
    dap.adapters.python = {
        type = 'executable';
        command = '/home/lijie/.local/share/nvim/dapinstall/python/bin/python';
        args = { '-m', 'debugpy.adapter' };
    }

    dap.configurations.python = {
    {
            -- The first three options are required by nvim-dap
            type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = 'launch';
            name = "Launch file";
            justMyCode = false;

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            program = "${file}"; -- This configuration will launch the current file if used.
            pythonPath = function()
                -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                local cwd = vim.fn.getcwd()
                if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                    return cwd .. '/venv/bin/python'
                elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                    return cwd .. '/.venv/bin/python'
                else
                    return '/usr/bin/python'
                end
            end;
        },
}

    require("dapui").setup()
    require("nvim-dap-virtual-text").setup()

end


-- generic LSP settings
lvim.lsp.on_attach_callback = function(client, _)
    -- close php auto format
    if client.name == "intelephense" then
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end
end

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheReset` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins
lvim.plugins = {
    -- Theme
    {"npxbr/gruvbox.nvim",requires = "rktjmp/lush.nvim"},
    {"tanvirtin/monokai.nvim"},
    {
        "folke/tokyonight.nvim",
        config = function ()
            -- storm dark light
            vim.g['tokyonight_style'] = 'storm'
        end
    },
    {
        "frenzyexists/aquarium-vim",
        config = function ()
            -- dark light
            vim.g.aquarium_style = "dark"
        end
    },
    {"olimorris/onedarkpro.nvim"},
    {"shaunsingh/solarized.nvim"},
    {
        "rose-pine/neovim",
        as = 'rose-pine',
        config = function ()
            -- Set variant
            -- Defaults to 'dawn' if vim background is light
            -- @usage 'base' | 'moon' | 'dawn' | 'rose-pine[-moon][-dawn]'
            vim.g.rose_pine_variant = 'dawn'
        end
    },
    -- Plugins
    {
        "ethanholz/nvim-lastplace",
        config = function ()
            require'nvim-lastplace'.setup{}
        end
    },
    {"p00f/nvim-ts-rainbow"},
    {"nvim-treesitter/nvim-treesitter-textobjects"},
    {
        "romgrk/nvim-treesitter-context",
        config = function ()
            require("treesitter-context").setup{
                enable = true,
                throttle = true,
            }
        end
    },
    {"lukas-reineke/indent-blankline.nvim"},
    {"github/copilot.vim"},
    {
        "ray-x/lsp_signature.nvim",
        config = function()
            local cfg = {
                bind = true,
                hint_prefix = " ",
            }
            require"lsp_signature".setup(cfg)
        end,
        -- event = "InsertEnter"
    },
    {
        "tzachar/cmp-tabnine",
        requires = "hrsh7th/nvim-cmp",
        config = function ()
            local cfg = {
                max_lines = 1000,
                max_num_results = 5,
                sort = true,
                run_on_every_keystroke = true,
            }
            require('cmp_tabnine.config'):setup(cfg)
        end,
        run = "./install.sh"
    },
    {
        "ahonn/vim-fileheader",
        config = function ()
            vim.g['fileheader_auto_update'] = 0
        end
    },
    {"fatih/vim-go"},
    {"buoto/gotests-vim"},
    {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {}end,
        event = "BufRead",
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
  },
  {"theHamsta/nvim-dap-virtual-text"},
  {"rcarriga/nvim-dap-ui"},
  {'christoomey/vim-tmux-navigator'},
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
    { "BufWinEnter", "*.go", "setlocal ts=4 sw=4" },
    { "BufWinEnter", "*.lua", "setlocal ts=4 sw=4" },
    { "BufWinEnter", "*.php", "setlocal ts=4 sw=4" },
    -- { "BufWinEnter", "*.js", "setlocal ts=2 sw=2" },
    -- { "BufWinEnter", "*.jsx", "setlocal ts=2 sw=2" },
    -- { "BufWinEnter", "*.ts", "setlocal ts=2 sw=2" },
    -- { "BufWinEnter", "*.tsx", "setlocal ts=2 sw=2" },
}
