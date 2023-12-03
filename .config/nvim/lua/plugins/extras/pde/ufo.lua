local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ("  %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0

  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)

    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]

      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end

    curWidth = curWidth + chunkWidth
  end

  local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
  suffix = (" "):rep(rAlignAppndx) .. suffix

  -- Check if the current folded section is a Go if err != nil block
  local bufnr = vim.api.nvim_get_current_buf()
  ---@diagnostic disable-next-line: deprecated
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  if filetype == "go" then
    local foldedLines = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, endLnum, false)
    local isSimpleCheck = false
    local returnStatement = nil
    for i, line in ipairs(foldedLines) do
      if i == 1 and line:match "^%s*if%s+.+[%!=><]+.+%s+{" then
        isSimpleCheck = true
      end

      if line:match "^%s*return%s+" then
        -- remove "return " in line
        returnStatement = line:gsub("^%s*return%s+", "")
        break
      end
    end

    if isSimpleCheck and returnStatement ~= nil then
      table.insert(newVirtText, { "  : " .. returnStatement .. " 󱟀", "MoreMsg" })
    end
  end

  table.insert(newVirtText, { suffix, "MoreMsg" })

  return newVirtText
end

local ftMap = {
  norg = { "treesitter", "indent" },
  yaml = { "treesitter", "indent" },
}

return {
  {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require "statuscol.builtin"
          require("statuscol").setup {
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          }
        end,
      },
    },
    enabled = configs.ufo,
    keys = {
      { "zc" },
      { "zo" },
      { "zC" },
      { "zO" },
      { "za" },
      { "zA" },
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds()
        end,
        desc = "Open Folds Except Kinds",
      },
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open All Folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close All Folds",
      },
      {
        "zm",
        function()
          require("ufo").closeFoldsWith()
        end,
        desc = "Close Folds With",
      },
      {
        "zp",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek Fold",
      },
    },
    opts = {
      open_fold_hl_timeout = 40,
      fold_virt_text_handler = handler,
      close_fold_kinds = { "imports", "comment" },
      provider_selector = function(_, filetype, _)
        return ftMap[filetype]
      end,
    },
    config = function(_, opts)
      local ufo = require "ufo"

      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      ufo.setup(opts)

      -- buffer scope handler
      -- will override global handler if it is existed
      ufo.setFoldVirtTextHandler(vim.api.nvim_get_current_buf(), handler)
    end,
  },
}
