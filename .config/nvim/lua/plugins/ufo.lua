return {
  {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = "kevinhwang91/promise-async",
    enabled = configs.better_fold,
    config = function()
      if not configs.better_fold then
        return
      end

      local ok, ufo = pcall(require, "ufo")
      if not ok then
        return
      end

      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()

        if not winid then
          -- choose one of coc.nvim and nvim lsp
          vim.lsp.buf.hover()
        end
      end)

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

        table.insert(newVirtText, { suffix, "MoreMsg" })

        return newVirtText
      end

      local ftMap = {
        norg = { "treesitter", "indent" },
        yaml = { "treesitter", "indent" },
      }

      ufo.setup {
        open_fold_hl_timeout = 20,
        fold_virt_text_handler = handler,
        provider_selector = function(_, filetype, _)
          return ftMap[filetype]
        end,
      }

      -- buffer scope handler
      -- will override global handler if it is existed
      ufo.setFoldVirtTextHandler(vim.api.nvim_get_current_buf(), handler)
    end,
  },
}