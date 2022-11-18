return {
  default_config = {
    -- `colorscheme_config`  colorscheme configures
    colorscheme_config = {
      -- duskfox,nightfly,nightfox,github_dimmed,tokyonight,sonokai,onedarkpro,monokai_soda,catppuccin,tokyodark,kanagawa,material
      colorscheme = "kanagawa",
      config = function()
        vim.o.background = require("user.utils.time").is_dark() and "dark" or "light"
      end,
    },
    -- `lsp`
    lsp = true,
    -- `dap`
    -- Debug Adapter Protocol client implementation for Neovim
    -- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
    dap = false,
    -- tint
    -- Dim inactive windows in Neovim using window-local highlight namespaces.
    -- [tint.nvim](https://github.com/levouh/tint.nvim)
    tint = false,
    -- `refactor`
    -- The Refactoring library based off the Refactoring book by Martin Fowler
    -- [refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim)
    refactor = false,
    -- `autopairs`
    -- autopairs for neovim written by lua
    -- [nvim-autopairs](https://github.com/windwp/nvim-autopairs)
    autopairs = true,
    -- `rust_tools`
    -- Tools for better development in rust using neovim's builtin lsp
    -- [rust-tools.nvim](https://github.com/simrat39/rust-tools.nvim)
    rust_tools = false,
    -- `color_picker`
    -- Super powerful color picker / colorizer plugin.
    -- [ccc.nvim](https://github.com/uga-rosa/ccc.nvim)
    color_picker = false,
    --`markdown_preview`
    -- markdown preview plugin for (neo)vim
    -- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
    markdown_preview = false,
    -- `org`
    -- Orgmode clone written in Lua for Neovim 0.7+.
    -- [orgmode](https://github.com/nvim-orgmode/orgmode)
    org = false,
    -- `neorg`
    -- Modernity meets insane extensibility. The future of organizing your life in Neovim.
    -- [neorg](https://github.com/nvim-neorg/neorg)
    neorg = false,
    -- `better_fold`
    -- Not UFO in the sky, but an ultra fold in Neovim.
    -- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo)
    better_fold = false,
    -- `better_tui`
    -- 💥 Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
    -- [noice.nvim](https://github.com/folke/noice.nvim)
    better_tui = false,
    -- `format_on_save`
    -- Format your code on save
    format_on_save = true,
    -- `transparent_window`
    -- Transparent window
    transparent_window = false,
    autocmds = {
      custom_groups = {},
    },
    -- `pre_hook`
    -- execute before loading configs
    pre_hook = function()
      -- conda setup
      if os.getenv "conda_prefix" ~= "" and os.getenv "conda_prefix" ~= nil then
        vim.g.python3_host_prog = os.getenv "conda_prefix" .. "/bin/python"
      end
    end,
    after_hook = function()
      -- do noting
    end,
  },
}
