local icons = require "utils.icons"

local kind_icons = {
  Array = icons.kind.Array .. " ",
  Boolean = icons.kind.Boolean,
  Class = icons.kind.Class .. " ",
  Color = icons.kind.Color .. " ",
  Constant = icons.kind.Constant .. " ",
  Constructor = icons.kind.Constructor .. " ",
  Enum = icons.kind.Enum .. " ",
  EnumMember = icons.kind.EnumMember .. " ",
  Event = icons.kind.Event .. " ",
  Field = icons.kind.Field .. " ",
  File = icons.kind.File .. " ",
  Folder = icons.kind.Folder .. " ",
  Function = icons.kind.Function .. " ",
  Interface = icons.kind.Interface .. " ",
  Key = icons.kind.Key .. " ",
  Keyword = icons.kind.Keyword .. " ",
  Method = icons.kind.Method .. " ",
  Module = icons.kind.Module .. " ",
  Namespace = icons.kind.Namespace .. " ",
  Null = icons.kind.Null .. " ",
  Number = icons.kind.Number .. " ",
  Object = icons.kind.Object .. " ",
  Operator = icons.kind.Operator .. " ",
  Package = icons.kind.Package .. " ",
  Property = icons.kind.Property .. " ",
  Reference = icons.kind.Reference .. " ",
  Snippet = icons.kind.Snippet .. " ",
  String = icons.kind.String .. " ",
  Struct = icons.kind.Struct .. " ",
  Text = icons.kind.Text .. " ",
  TypeParameter = icons.kind.TypeParameter .. " ",
  Unit = icons.kind.Unit .. " ",
  Value = icons.kind.Value .. " ",
  Variable = icons.kind.Variable .. " ",
}

return {
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
      "mikavilpas/blink-ripgrep.nvim",
      -- " rafamadriz/friendly-snippets",
      {
        "Kaiser-Yang/blink-cmp-dictionary",
        build = "aspell -d en dump master | aspell -l en expand > " .. vim.fn.stdpath "config" .. "/dict/en_us.dict",
      },
    },

    -- use a release tag to download pre-built binaries
    version = "*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        preset = "enter",

        -- ["<c-f>"] = {
        --   function()
        --     -- invoke manually, requires blink >v0.8.0
        --     require("blink-cmp").show { providers = { "ripgrep" } }
        --   end,
        -- },
      },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "normal",
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "dictionary", "lsp", "path", "snippets", "buffer", "ripgrep" },

        providers = {
          dictionary = {
            module = "blink-cmp-dictionary",
            name = "Dict",
            -- Make sure this is at least 2.
            -- 3 is recommended
            max_items = 2,
            min_keyword_length = 3,
            opts = {
              -- options for blink-cmp-dictionary
              dictionary_files = {
                vim.fn.stdpath "config" .. "/dict/en_us.dict",
              },
            },
          },
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            -- the options below are optional, some default values are shown
            ---@module "blink-ripgrep"
            ---@type blink-ripgrep.Options
            opts = {
              -- For many options, see `rg --help` for an exact description of
              -- the values that ripgrep expects.

              -- the minimum length of the current word to start searching
              -- (if the word is shorter than this, the search will not start)
              prefix_min_len = 3,

              -- The number of lines to show around each match in the preview
              -- (documentation) window. For example, 5 means to show 5 lines
              -- before, then the match, and another 5 lines after the match.
              context_size = 5,

              -- The maximum file size of a file that ripgrep should include in
              -- its search. Useful when your project contains large files that
              -- might cause performance issues.
              -- Examples:
              -- "1024" (bytes by default), "200K", "1M", "1G", which will
              -- exclude files larger than that size.
              max_filesize = "1M",

              -- Specifies how to find the root of the project where the ripgrep
              -- search will start from. Accepts the same options as the marker
              -- given to `:h vim.fs.root()` which offers many possibilities for
              -- configuration. If none can be found, defaults to Neovim's cwd.
              --
              -- Examples:
              -- - ".git" (default)
              -- - { ".git", "package.json", ".root" }
              project_root_marker = ".git",

              -- Enable fallback to neovim cwd if project_root_marker is not
              -- found. Default: `true`, which means to use the cwd.
              project_root_fallback = true,

              -- The casing to use for the search in a format that ripgrep
              -- accepts. Defaults to "--ignore-case". See `rg --help` for all the
              -- available options ripgrep supports, but you can try
              -- "--case-sensitive" or "--smart-case".
              search_casing = "--ignore-case",

              -- (advanced) Any additional options you want to give to ripgrep.
              -- See `rg -h` for a list of all available options. Might be
              -- helpful in adjusting performance in specific situations.
              -- If you have an idea for a default, please open an issue!
              --
              -- Not everything will work (obviously).
              additional_rg_options = {},

              -- When a result is found for a file whose filetype does not have a
              -- treesitter parser installed, fall back to regex based highlighting
              -- that is bundled in Neovim.
              fallback_to_regex_highlighting = true,

              -- Absolute root paths where the rg command will not be executed.
              -- Usually you want to exclude paths using gitignore files or
              -- ripgrep specific ignore files, but this can be used to only
              -- ignore the paths in blink-ripgrep.nvim, maintaining the ability
              -- to use ripgrep for those paths on the command line. If you need
              -- to find out where the searches are executed, enable `debug` and
              -- look at `:messages`.
              ignore_paths = {},

              -- Any additional paths to search in, in addition to the project
              -- root. This can be useful if you want to include dictionary files
              -- (/usr/share/dict/words), framework documentation, or any other
              -- reference material that is not available within the project
              -- root.
              additional_paths = {},

              -- Show debug information in `:messages` that can help in
              -- diagnosing issues with the plugin.
              debug = false,
            },
            -- (optional) customize how the results are displayed. Many options
            -- are available - make sure your lua LSP is set up so you get
            -- autocompletion help
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                -- example: append a description to easily distinguish rg results
                item.labelDetails = {
                  description = "(rg)",
                }
              end
              return items
            end,
          },
        },
      },

      completion = {
        menu = {
          border = "rounded",
          draw = {
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  return kind_icons[ctx.kind]
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = { border = "rounded" },
        },
      },

      signature = { enabled = true, window = { border = "rounded" } },
    },

    opts_extend = { "sources.default" },
  },
}
