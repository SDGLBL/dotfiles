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

local name_icons = {
  cmp_ai = " ",
  emoji = "󰞅 ",
  crates = " ",
  npm = " ",
  calc = " ",
  dictionary = " ",
  path = " ",
  cmdline_history = " ",
}

local source_names = {
  nvim_lsp = "(LSP)",
  emoji = "(Emoji)",
  path = "(Path)",
  calc = "(Calc)",
  cmp_tabnine = "(Tabnine)",
  nvim_lua = "(NvimLua)",
  vsnip = "(Snippet)",
  luasnip = "(Snippet)",
  buffer = "(Buffer)",
  orgmode = "(Org)",
  neorg = "(Neorg)",
  spell = "(Spell)",
  latex_symbols = "(LaTeX)",
  npm = "(Npm)",
  crates = "(Crates)",
  dictionary = "(Dict)",
  ["otter:pyright"] = "(LSP)",
  otter = "(LSP)",
}

local max_width = 20

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- duplicates
local duplicates = {
  dictionary = 3,
  buffer = 2,
  path = 2,
  luasnip = 2,
  cmp_tabnine = 0,
  nvim_lsp = 1,
}

return {
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
      {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        config = true,
      },
      {
        "uga-rosa/cmp-dictionary",
        build = "aspell -d en dump master | aspell -l en expand > " .. vim.fn.stdpath "config" .. "/dict/en_us.dict",
        config = function()
          local dict = require "cmp_dictionary"
          dict.setup {
            paths = {
              vim.fn.stdpath "config" .. "/dict/en_us.dict",
            },
          }
        end,
      },
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require "cmp"
      local defaults = require "cmp.config.default"()
      return {
        auto_brackets = {}, -- configure any filetype to auto add brackets
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        view = {
          entries = {
            name = "custom",
          },
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp", group_index = 1 },
          { name = "buffer", group_index = 3 },
          { name = "dictionary", keyword_length = 4, group_index = 3, max_item_count = 3 },
          { name = "path", group_index = 5 },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            -- Apply max width
            if max_width ~= 0 and #vim_item.abbr > max_width then
              vim_item.abbr = string.sub(trim(vim_item.abbr), 1, max_width - 1) .. "…"
            end

            -- Kind icons
            vim_item.kind = string.format("%s", name_icons[entry.source.name] or kind_icons[vim_item.kind])
            vim_item.menu = source_names[entry.source.name]

            -- vim_item dup
            vim_item.dup = duplicates[entry.source.name] or 0
            return require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
          end,
        },
        experimental = {
          -- ghost_text = {
          --   hl_group = "CmpGhostText",
          -- },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sorting = defaults.sorting,
      }
    end,
    ---@param opts cmp.ConfigSchema | {auto_brackets?: string[]}
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end

      local cmp = require "cmp"
      local Kind = cmp.lsp.CompletionItemKind
      cmp.setup(opts)

      -- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
          { name = "cmdline_history" },
        }),
      })

      cmp.event:on("confirm_done", function(event)
        if not vim.tbl_contains(opts.auto_brackets or {}, vim.bo.filetype) then
          return
        end
        local entry = event.entry
        local item = entry:get_completion_item()
        if vim.tbl_contains({ Kind.Function, Kind.Method }, item.kind) then
          local keys = vim.api.nvim_replace_termcodes("()<left>", false, false, true)
          vim.api.nvim_feedkeys(keys, "i", true)
        end
      end)
    end,
  },

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find "Windows") and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp" or nil,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      {
        "honza/vim-snippets",
        config = function()
          require("luasnip.loaders.from_snipmate").lazy_load()

          -- One peculiarity of honza/vim-snippets is that the file with the global snippets is _.snippets, so global snippets
          -- are stored in `ls.snippets._`.
          -- We need to tell luasnip that "_" contains global snippets:
          require("luasnip").filetype_extend("all", { "_" })
        end,
      },
      {
        "nvim-cmp",
        dependencies = {
          "saadparwaiz1/cmp_luasnip",
        },
        opts = function(_, opts)
          opts.snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          }
          table.insert(opts.sources, { name = "luasnip", group_index = 2 })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          local copilot_keys = vim.fn["copilot#Accept"]()
          if copilot_keys ~= "" then
            vim.api.nvim_feedkeys(copilot_keys, "i", true)
            return
          end

          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
}
