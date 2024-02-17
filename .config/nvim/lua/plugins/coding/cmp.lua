return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-path" },
      { "f3fora/cmp-spell" },
      { "hrsh7th/cmp-emoji" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "dmitmel/cmp-cmdline-history" },
      {
        "tzachar/cmp-ai",
        config = function()
          local cmp_ai = require "cmp_ai.config"

          cmp_ai:setup {
            max_lines = 1000,
            provider = "OpenAI",
            provider_options = {
              model = "gpt-3.5-turbo",
            },
            notify = true,
            notify_callback = function(msg)
              vim.notify(msg)
            end,
            run_on_every_keystroke = false,
            ignored_file_types = {
              -- default is not to ignore
              -- uncomment to ignore in lua:
              -- lua = true
            },
          }
        end,
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

      { "saadparwaiz1/cmp_luasnip" },
      {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        config = true,
      },
      {
        "David-Kunz/cmp-npm",
        event = { "BufRead package.json" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
          require("cmp-npm").setup {}
        end,
      },
      { "kdheepak/cmp-latex-symbols", ft = "plaintext" },
      -- {
      --   "L3MON4D3/LuaSnip",
      --   build = "make install_jsregexp",
      --   dependencies = { "rafamadriz/friendly-snippets" },
      --   event = "VeryLazy",
      --   config = function()
      --     require("luasnip.loaders.from_vscode").lazy_load { exclude = { "rust" } }
      --     require("luasnip.loaders.from_vscode").lazy_load { paths = { "./vscode-snippets" } }
      --     require("luasnip.loaders.from_snipmate").lazy_load()
      --   end,
      -- },
    },
    enabled = configs.lsp,
    opts = function()
      local cmp = require "cmp"
      local icons = require "utils.icons"
      local snip_status_ok, luasnip = pcall(require, "luasnip")
      local neogen_status_ok, neogen = pcall(require, "neogen")

      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match "^%s*$" == nil
      end

      local function trim(s)
        return (s:gsub("^%s*(.-)%s*$", "%1"))
      end

      ---checks if emmet_ls is available and active in the buffer
      ---@return boolean true if available, false otherwise
      local is_emmet_active = function()
        local clients = vim.lsp.get_clients { name = "emmet_ls" }
        return #clients > 0
      end

      ---when inside a snippet, seeks to the nearest luasnip field if possible, and checks if it is jumpable
      ---@param dir number 1 for forward, -1 for backward; defaults to 1
      ---@return boolean true if a jumpable luasnip field is found while inside a snippet
      local function jumpable(dir)
        if not snip_status_ok then
          return false
        end

        local win_get_cursor = vim.api.nvim_win_get_cursor
        local get_current_buf = vim.api.nvim_get_current_buf

        ---sets the current buffer's luasnip to the one nearest the cursor
        ---@return boolean true if a node is found, false otherwise
        local function seek_luasnip_cursor_node()
          -- for outdated versions of luasnip
          if not luasnip.session.current_nodes then
            return false
          end

          local node = luasnip.session.current_nodes[get_current_buf()]
          if not node then
            return false
          end

          local snippet = node.parent.snippet
          local exit_node = snippet.insert_nodes[0]

          local pos = win_get_cursor(0)
          pos[1] = pos[1] - 1

          -- exit early if we're past the exit node
          if exit_node then
            local exit_pos_end = exit_node.mark:pos_end()
            if (pos[1] > exit_pos_end[1]) or (pos[1] == exit_pos_end[1] and pos[2] > exit_pos_end[2]) then
              snippet:remove_from_jumplist()
              luasnip.session.current_nodes[get_current_buf()] = nil

              return false
            end
          end

          node = snippet.inner_first:jump_into(1, true)
          while node ~= nil and node.next ~= nil and node ~= snippet do
            local n_next = node.next
            local next_pos = n_next and n_next.mark:pos_begin()
            local candidate = n_next ~= snippet and next_pos and (pos[1] < next_pos[1]) or (pos[1] == next_pos[1] and pos[2] < next_pos[2])

            -- Past unmarked exit node, exit early
            if n_next == nil or n_next == snippet.next then
              snippet:remove_from_jumplist()
              luasnip.session.current_nodes[get_current_buf()] = nil

              return false
            end

            if candidate then
              luasnip.session.current_nodes[get_current_buf()] = node
              return true
            end

            local ok
            ok, node = pcall(node.jump_from, node, 1, true) -- no_move until last stop
            if not ok then
              snippet:remove_from_jumplist()
              luasnip.session.current_nodes[get_current_buf()] = nil

              return false
            end
          end

          -- No candidate, but have an exit node
          if exit_node then
            -- to jump to the exit node, seek to snippet
            luasnip.session.current_nodes[get_current_buf()] = snippet
            return true
          end

          -- No exit node, exit from snippet
          snippet:remove_from_jumplist()
          luasnip.session.current_nodes[get_current_buf()] = nil
          return false
        end

        if dir == -1 then
          return luasnip.in_snippet() and luasnip.jumpable(-1)
        else
          return luasnip.in_snippet() and seek_luasnip_cursor_node() and luasnip.jumpable(1)
        end
      end

      --   פּ ﯟ   some other good icons
      -- find more here: https://www.nerdfonts.com/cheat-sheet
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

      -- source_names
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

      -- duplicates
      local duplicates = {
        dictionary = 3,
        buffer = 2,
        path = 2,
        luasnip = 2,
        cmp_tabnine = 0,
        nvim_lsp = 1,
      }

      -- max_width of vim_item
      local max_width = 20

      return {
        sorting = {
          comparators = {},
          -- priority_weight = 2,
          -- comparators = {
          --   require("copilot_cmp.comparators").prioritize,

          --   -- Below is the default comparitor list and order for nvim-cmp
          --   cmp.config.compare.offset,
          --   -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
          --   cmp.config.compare.exact,
          --   cmp.config.compare.score,
          --   cmp.config.compare.recently_used,
          --   cmp.config.compare.locality,
          --   cmp.config.compare.kind,
          --   cmp.config.compare.sort_text,
          --   cmp.config.compare.length,
          --   cmp.config.compare.order,
          -- },
        },
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        completion = {
          ---@usage The minimum length of a word to complete on.
          keyword_length = 1,
        },
        view = {
          entries = {
            name = "custom",
          },
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }, { "i" }),
          ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select }, { "i" }),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-x>"] = cmp.mapping(
            cmp.mapping.complete {
              config = {
                sources = cmp.config.sources {
                  { name = "cmp_ai" },
                },
              },
            },
            { "i" }
          ),
          -- TODO: potentially fix emmet nonsense
          ["<C-y>"] = cmp.mapping {
            i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
            c = function(fallback)
              if cmp.visible() then
                cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
              else
                fallback()
              end
            end,
          },
          -- ["<Tab>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() and has_words_before() then
          --     cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
          --   elseif snip_status_ok and luasnip.jumpable(1) then
          --     luasnip.jump(1)
          --   elseif neogen_status_ok and neogen.jumpable() then
          --     neogen.jump_next()
          --   else
          --     -- input a tab symbol
          --     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
          --     fallback()
          --   end
          -- end, {
          --   "i",
          --   "s",
          -- }),
          -- ["<S-Tab>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_prev_item()
          --   elseif snip_status_ok and luasnip.jumpable(-1) then
          --     luasnip.jump(-1)
          --   elseif neogen_status_ok and neogen.jumpable(true) then
          --     neogen.jump_prev()
          --   else
          --     fallback()
          --   end
          -- end, {
          --   "i",
          --   "s",
          -- }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-l>"] = function(fallback)
            cmp.mapping.abort()
            local copilot_keys = vim.fn["copilot#Accept"]()
            if copilot_keys ~= "" then
              vim.api.nvim_feedkeys(copilot_keys, "i", true)
            else
              fallback()
            end
          end,
          ["<CR>"] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
          -- ["<CR>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() and cmp.get_selected_entry() ~= nil then
          --     local confirm_opts = {
          --       behavior = cmp.ConfirmBehavior.Replace,
          --       select = false,
          --     }
          --     local is_insert_mode = function()
          --       return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
          --     end

          --     if is_insert_mode then
          --       confirm_opts.behavior = cmp.ConfirmBehavior.Insert
          --     end
          --     if cmp.confirm(confirm_opts) then
          --       return
          --     end
          --   end
          --   fallback()
          -- end),
          -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          --[[ ["<CR>"] = cmp.mapping.confirm { select = true }, ]]
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            -- Apply max width
            if max_width ~= 0 and #vim_item.abbr > max_width then
              vim_item.abbr = string.sub(trim(vim_item.abbr), 1, max_width - 1) .. "…"
            end

            -- Kind icons
            vim_item.kind = string.format("%s", name_icons[entry.source.name] or kind_icons[vim_item.kind])

            if entry.source.name == "cmp_tabnine" then
              local item = entry.cache.entries["get_completion_item"]
              local item2 = entry.cache.entries["get_completion_item:0"]
              local percent = "None"
              if item ~= nil then
                percent = item.data.detail
              elseif item2 ~= nil then
                percent = item2.data.detail
              end

              vim_item.menu = string.format("%s %s", percent, source_names[entry.source.name])
            else
              vim_item.menu = source_names[entry.source.name]
            end

            -- vim_item dup
            vim_item.dup = duplicates[entry.source.name] or 0

            return require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
          end,
        },
        sources = {
          -- { name = "copilot", group_index = 2 },
          {
            name = "nvim_lsp",
            entry_filter = function(entry, ctx)
              local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
              if kind == "Snippet" and ctx.prev_context.filetype == "java" then
                return false
              end
              return true
            end,
          },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "dictionary", keyword_length = 2, max_item_count = 3 },
          { name = "npm", keyword_length = 4 },
          { name = "neorg" },
          { name = "path" },
          { name = "calc" },
          { name = "latex_symbols" },
          { name = "emoji", insert = true },
          { name = "spell" },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = false,
          native_menu = false,
        },
      }
    end,
    config = function(_, opts)
      local cmp = require "cmp"

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
    end,
  },
}
