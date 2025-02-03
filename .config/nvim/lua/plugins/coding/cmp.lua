local cmp_utils = require "utils.cmp"
local kind_icons = require("utils.lsp").kind_icons

local name_icons = {
  cmp_ai = " ",
  emoji = "󰞅 ",
  crates = " ",
  npm = " ",
  calc = " ",
  dictionary = " ",
  path = " ",
  cmdline_history = " ",
  buffer = " ",
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
  snippets = "(Snippet)",
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

return {
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
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
      local auto_select = true
      return {
        auto_brackets = {
          "python",
          "lua",
        }, -- configure any filetype to auto add brackets
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
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
          ["<CR>"] = cmp_utils.confirm { select = auto_select },
          ["<C-y>"] = cmp_utils.confirm { select = true },
          ["<S-CR>"] = cmp_utils.confirm { behavior = cmp.ConfirmBehavior.Replace }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        },
        preselect = cmp.PreselectMode.None,
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "dictionary", keyword_length = 4, max_item_count = 3 },
          { name = "path" },
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
            -- vim_item.dup = duplicates[entry.source.name] or 0
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
          { name = "cmdline_history", max_item_count = 3 },
        }),
      })

      cmp.event:on("confirm_done", function(event)
        if not vim.tbl_contains(opts.auto_brackets or {}, vim.bo.filetype) then
          return
        end
        local entry = event.entry
        local item = entry:get_completion_item()
        if vim.tbl_contains({ Kind.Function, Kind.Method }, item.kind) then
          local cursor = vim.api.nvim_win_get_cursor(0)
          local prev_char = vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2] + 1, {})[1]
          if prev_char ~= "(" and prev_char ~= ")" then
            local keys = vim.api.nvim_replace_termcodes("()<left>", false, false, true)
            vim.api.nvim_feedkeys(keys, "i", true)
          end
        end
      end)
    end,
  },
}
