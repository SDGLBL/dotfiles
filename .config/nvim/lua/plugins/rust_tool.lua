return {
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    enabled = configs.rust_tools,
    config = function()
      if not configs.rust_tools then
        return
      end

      local rt = require "rust-tools"

      rt.setup {
        server = {
          on_attach = function(client, bufnr)
            require("user.lsp.handlers").on_attach(client, bufnr)
            -- Hover actions
            vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>la", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
      }
    end,
  },
}
