return {
  setup = function(opts)
    local servers = opts.servers
    local icons = require "utils.icons"

    require("mason").setup {
      ui = {
        border = "rounded",
        icons = {
          package_installed = icons.ui.Check,
          package_pending = icons.ui.CloudDownload,
          package_uninstalled = icons.ui.Close,
        },
      },
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
    }

    require("mason-lspconfig").setup {
      ensure_installed = servers,
      automatic_installation = true,
    }

    local lsp_keymaps = function(client, bufnr)
      if client.name == "null-ls" or client.name == "copilot" then
        return
      end

      local keymaps_opts = { noremap = true, silent = true }
      local keymap = vim.api.nvim_buf_set_keymap

      if vim.fn.exists ":CodeActionMenu" then
        keymap(bufnr, "n", "<leader>la", "<cmd>CodeActionMenu<CR>", keymaps_opts)
      else
        keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", keymaps_opts)
      end

      if client.name == "rust_analyzer" then
        keymap(bufnr, "n", "K", "<cmd>RustHoverActions<CR>", keymaps_opts)
      else
        keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", keymaps_opts)
      end

      if vim.fn.getbufvar(bufnr, "&filetype") == "go" then
        keymap(bufnr, "n", "<leader>li", "<cmd>lua require'telescope'.extensions.goimpl.goimpl{}<CR>", keymaps_opts)
      end

      keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", keymaps_opts)
      keymap(bufnr, "n", "gd", "<cmd>Telescope lsp_definitions<CR>", keymaps_opts)
      keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<CR>", keymaps_opts)
      keymap(bufnr, "n", "gI", "<cmd>Telescope lsp_implementations<CR>", keymaps_opts)
      keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", keymaps_opts)
      keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", keymaps_opts)
      keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", keymaps_opts)
      keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", keymaps_opts)
      keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", keymaps_opts)
      keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", keymaps_opts)

      vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format({ async = true })' ]]
    end

    local inlay_hint = function(client, bufnr)
      if client.name == "copilot" or client.name == "null-ls" then
        return
      end

      if not client.supports_method "textDocument/inlayHint" then
        return
      end

      vim.lsp.buf.inlay_hint(bufnr, true)
    end

    require("utils.lsp").on_attach(function(client, bufnr)
      -- because tsserver formatting always timeout
      if client.name == "tsserver" then
        client.server_capabilities.documentFormattingProvider = false
      end

      if client.name == "sumneko_lua" then
        client.server_capabilities.documentFormattingProvider = false
      end

      if client.name == "intelephense" then
        client.server_capabilities.documentFormattingProvider = false
      end

      lsp_keymaps(client, bufnr)
      inlay_hint(client, bufnr)
    end, { group = "_lsp_keymaps", desc = "init lsp keymaps" })

    local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    if status_cmp_ok then
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local handlers = {
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {
          capabilities = capabilities,
        }
      end,
    }

    local server_opts = {}

    for name, server in pairs(servers) do
      if server ~= nil then
        server_opts = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
        }, server)

        handlers[name] = function()
          if opts.setup[name] ~= nil then
            if opts.setup[name](name,server_opts) then
              return
            end
          elseif opts.setup["*"] then
            if opts.setup["*"](name,server_opts) then
              return
            end
          end

          require("lspconfig")[name].setup(server_opts)
        end
      end
    end

    require("mason-lspconfig").setup_handlers(handlers)
  end,
}
