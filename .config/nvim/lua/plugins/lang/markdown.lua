if not configs.markdown_preview then
  return {}
end

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        -- ["<leader>p"] = { name = "+Markdown" },
      },
    },
  },

  -- add json to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      -- make sure mason installs the server
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        -- marksman = {},
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "prettierd", "markdown-toc" })
    end,
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["markdown"] = { { "prettierd", "prettier" }, "markdown-toc" },
        ["markdown.mdx"] = { { "prettierd", "prettier" }, "markdown-toc" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },

  {
    "ChuufMaster/markdown-toc",
    opts = {

      -- The heading level to match (i.e the number of "#"s to match to) max 6
      heading_level_to_match = -1,

      -- Set to True display a dropdown to allow you to select the heading level
      ask_for_heading_level = false,

      -- TOC default string
      -- WARN
      toc_format = "%s- [%s](<%s#%s>)",
    },
  },

  -- add support edit markdown codeblock
  {
    "AckslD/nvim-FeMaco.lua",
    enabled = configs.markdown_preview,
    ft = { "markdown" },
    opts = {},
  },

  -- add support generate markdown toc
  {
    "mzlogin/vim-markdown-toc",
    enabled = configs.markdown_preview,
    ft = { "markdown" },
  },

  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
    enabled = configs.markdown_preview,
    keys = {
      -- { "<leader>p", "", desc = "MKPreview", ft = "markdown" },
      -- { "<leader>pp", "<cmd>MarkdownPreview<cr>", desc = "Preview", ft = "markdown" },
      -- { "<leader>ps", "<cmd>MarkdownPreviewStop<cr>", desc = "Stop", ft = "markdown" },
      -- { "<leader>pt", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle", ft = "markdown" },
      -- { "<leader>pe", "<cmd>FeMaco<cr>", desc = "Edit Code Block", ft = "markdown" },
    },
    config = function()
      if not configs.markdown_preview then
        return
      end
      -- set to 1, nvim will open the preview window after entering the markdown buffer
      -- default: 0
      vim.g.mkdp_auto_start = 0

      -- set to 1, the nvim will auto close current preview window when change
      -- from markdown buffer to another buffer
      -- default: 1
      vim.g.mkdp_auto_close = 1

      -- set to 1, the vim will refresh markdown when save the buffer or
      -- leave from insert mode, default 0 is auto refresh markdown as you edit or
      -- move the cursor
      -- default: 0
      vim.g.mkdp_refresh_slow = 0

      -- set to 1, the MarkdownPreview command can be use for all files,
      -- by default it can be use in markdown file
      -- default: 0
      vim.g.mkdp_command_for_global = 0

      -- set to 1, preview server available to others in your network
      -- by default, the server listens on localhost (127.0.0.1)
      -- default: 0
      vim.g.mkdp_open_to_the_world = 0

      -- use custom IP to open preview page
      -- useful when you work in remote vim and preview on local browser
      -- more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
      -- default empty
      vim.g.mkdp_open_ip = ""

      -- specify browser to open preview page
      -- for path with space
      -- valid: `/path/with\ space/xxx`
      -- invalid: `/path/with\\ space/xxx`
      -- default: ''
      vim.g.mkdp_browser = ""

      -- set to 1, echo preview page url in command line when open preview page
      -- default is 0
      vim.g.mkdp_echo_preview_url = 1

      -- a custom vim function name to open preview page
      -- this function will receive url as param
      -- default is empty
      vim.g.mkdp_browserfunc = ""

      -- options for markdown render
      -- mkit: markdown-it options for render
      -- katex: katex options for math
      -- uml: markdown-it-plantuml options
      -- maid: mermaid options
      -- disable_sync_scroll: if disable sync scroll, default 0
      -- sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
      --   middle: mean the cursor position alway show at the middle of the preview page
      --   top: mean the vim top viewport alway show at the top of the preview page
      --   relative: mean the cursor position alway show at the relative positon of the preview page
      -- hide_yaml_meta: if hide yaml metadata, default is 1
      -- sequence_diagrams: js-sequence-diagrams options
      -- content_editable: if enable content editable for preview page, default: v:false
      -- disable_filename: if disable filename header for preview page, default: 0
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {},
      }

      -- use a custom markdown style must be absolute path
      -- like '/Users/username/markdown.css' or expand('~/markdown.css')
      vim.g.mkdp_markdown_css = ""

      -- use a custom highlight style must absolute path
      -- like '/Users/username/highlight.css' or expand('~/highlight.css')
      vim.g.mkdp_highlight_css = ""

      -- use a custom port to start server or empty for random
      vim.g.mkdp_port = ""

      -- preview page title
      -- ${name} will be replace with the file name
      vim.g.mkdp_page_title = "「${name}」"

      -- recognized filetypes
      -- these filetypes will have MarkdownPreview... commands
      vim.g.mkdp_filetypes = { "markdown" }

      -- set default theme (dark or light)
      -- By default the theme is define according to the preferences of the system
      vim.g.mkdp_theme = require("utils.time").is_dark() and "dark" or "light"
    end,
  },

  {
    "lukas-reineke/headlines.nvim",
    enabled = false,
    opts = function()
      local opts = {}
      for _, ft in ipairs { "markdown", "norg", "rmd", "org" } do
        opts[ft] = {
          headline_highlights = {},
        }
        for i = 1, 6 do
          local hl = "Headline" .. i
          vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
          table.insert(opts[ft].headline_highlights, hl)
        end
      end
      return opts
    end,
    ft = { "markdown", "norg", "rmd", "org" },
    config = function(_, opts)
      -- PERF: schedule to prevent headlines slowing down opening a file
      vim.schedule(function()
        local hl = require "headlines"
        hl.setup(opts)
        local md = hl.config.markdown
        hl.refresh()

        -- Toggle markdown headlines on insert enter/leave
        vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
          callback = function(data)
            if vim.bo.filetype == "markdown" then
              hl.config.markdown = data.event == "InsertLeave" and md or nil
              hl.refresh()
            end
          end,
        })
      end)
    end,
  },

  {
    "MeanderingProgrammer/markdown.nvim",
    -- name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- ft = "norg",
    -- ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    ft = { "markdown", "norg", "rmd", "org" },
    config = function()
      require("render-markdown").setup {
        -- file_types = { "markdown", "norg", "rmd", "org", "codecompanion" },
        file_types = { "markdown", "norg", "rmd", "org" },
      }
    end,
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    enabled = false,
    lazy = true,
    ft = "markdown",
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "work",
          path = "~/Library/Mobile Documents/com~apple~CloudDocs/Work&Life",
        },
      },
    },
  },

  { "ellisonleao/glow.nvim", config = true, cmd = "Glow", enabled = true },
}
