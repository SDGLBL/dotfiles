return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = { mode = "cursor", max_lines = 3 },
    keys = {
      {
        "<leader>ut",
        function()
          local tsc = require "treesitter-context"
          tsc.toggle()
          if require("utils").get_upvalue(tsc.toggle, "enabled") then
            vim.notify("Enabled Treesitter Context", vim.log.levels.INFO, { title = "Option" })
          else
            vim.notify("Disabled Treesitter Context", vim.log.levels.WARN, { title = "Option" })
          end
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  },
}
