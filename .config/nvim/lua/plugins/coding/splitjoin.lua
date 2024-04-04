return {
  {
    "bennypowers/splitjoin.nvim",
    enabled = false,
    lazy = true,
    keys = {
      {
        "gj",
        function()
          require("splitjoin").join()
        end,
        desc = "Join the object under cursor",
      },
      {
        "g,",
        function()
          require("splitjoin").split()
        end,
        desc = "Split the object under cursor",
      },
    },
  },
}
