local status_ok, comment_box = pcall(require, "comment-box")
if not status_ok then
  return
end

comment_box.setup {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │              your configuration comes here               │
  --  │      or leave it empty to use the default settings       │
  --  │         refer to the configuration section below         │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    doc_width = 80, -- width of the document
    box_width = 60, -- width of the boxes
    borders = { -- symbols used to draw a box
      top = "─",
      bottom = "─",
      left = "│",
      right = "│",
      top_left = "╭",
      top_right = "╮",
      bottom_left = "╰",
      bottom_right = "╯",
    },
    line_width = 70, -- width of the lines
    line = { -- symbols used to draw a line
      line = "─",
      line_start = "─",
      line_end = "─",
    },
    outer_blank_lines = false, -- insert a blank line above and below the box
    inner_blank_lines = false, -- insert a blank line above and below the text
    line_blank_line_above = false, -- insert a blank line above the line
    line_blank_line_below = false, -- insert a blank line below the line
  },
}

local ok_which_key, wk = pcall(require, "which-key")

if ok_which_key then
  wk.register({
    n = {
      name = "CommentBox",
      a = {
        name = "Adapted",
        b = { "<cmd>lua require('comment-box').lbox()<CR><esc>", "LeftAdaptedBox+LeftText" },
        c = {
          name = "Center",
          c = { "<cmd>lua require('comment-box').clbox()<CR><esc>", "CenterAdaptedBox+LeftText" },
          l = { "<cmd>lua require('comment-box').cbox()<CR><esc>", "LeftAdaptedBox+CenterText" },
          b = { "<cmd>lua require('comment-box').ccbox()<CR><esc>", "CenterAdaptedBox+CenterText" },
        },
      },
      b = { "<cmd>lua require('comment-box').cbox()<CR><esc>", "LeftBox+LeftText" },
      c = {
        name = "Center",
        c = { "<cmd>lua require('comment-box').clbox()<CR><esc>", "CenterBox+LeftText" },
        l = { "<cmd>lua require('comment-box').cbox()<CR><esc>", "LeftBox+CenterText" },
        b = { "<cmd>lua require('comment-box').ccbox()<CR><esc>", "CenterBox+CenterText" },
      },
      l = { "<cmd>lua require('comment-box').line()<CR><esc>", "CenterLine" },
    },
  }, require("user.whichkey").opts)

  wk.register({
    b = {
      name = "CommentBox",
      b = { "<cmd>lua require('comment-box').albox()<CR><esc>", "LeftBox+LeftText" },
      c = { "<cmd>lua require('comment-box').accbox()<CR><esc>", "CenterBox+CenterText" },
      l = { "<cmd>lua require('comment-box').cline()<CR><esc>", "CenterLine" },
    },
  }, require("user.whichkey").vopts)
end
