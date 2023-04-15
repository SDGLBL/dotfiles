return {
  {
    "ThePrimeagen/refactoring.nvim",
    event = "VeryLazy",
    enabled = configs.refactor,
    config = function()
      if not configs.refactor then
        return
      end

      local refactor = require "refactoring"

      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.load_extension "refactoring"
      end

      refactor.setup {}
    end,
  },
}
