return {
  {
    "rcarriga/nvim-notify",
    enabled = true,
    event = "VeryLazy",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss { silent = true, pending = true }
        end,
        desc = "Dismiss all Notifications",
      },
    },
    config = function()
      local icons = require "utils.icons"

      local defaults = {
        ---@usage Animation style one of { "fade", "slide", "fade_in_slide_out", "static" }
        stages = "static",

        ---@usage Function called when a new window is opened, use for changing win settings/config
        on_open = nil,

        ---@usage Function called when a window is closed
        on_close = nil,

        ---@usage timeout for notifications in ms, default 5000
        timeout = 1500,

        -- Render function for notifications. See notify-render()
        render = "default",

        top_down = false,

        ---@usage highlight behind the window for stages that change opacity
        background_colour = "Normal",

        ---@usage minimum width for notification windows
        minimum_width = 50,

        ---@usage Icons for the different levels
        icons = {
          ERROR = icons.diagnostics.Error,
          WARN = icons.diagnostics.Warning,
          INFO = icons.diagnostics.Hint,
          DEBUG = icons.diagnostics.Debug,
          TRACE = icons.diagnostics.Trace,
        },
      }

      local status_ok, notify = pcall(require, "notify")

      if #vim.api.nvim_list_uis() == 0 or not status_ok then
        -- no need to configure notifications in headless
        return
      end

      notify.setup(defaults)
      vim.notify = notify

      local tele_status_ok, telescope = pcall(require, "telescope")
      if not tele_status_ok then
        return
      end

      telescope.load_extension "notify"
    end,
  },
}
