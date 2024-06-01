return {
  {
    "bennypowers/nvim-regexplainer",
    cmd = {
      "RegexplainerShowSplit",
      "RegexplainerShowPopup",
      "RegexplainerHide",
      "RegexplainerToggle",
    },
    config = function()
      require("regexplainer").setup()
    end,
  },
}
