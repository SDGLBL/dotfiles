local opts = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local vopts = {
  mode = "v",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

return {
  opts = opts,
  vopts = vopts,
  opts_with_buffer = function(bufnr)
    vim.tbl_extend("force", opts, { buffer = bufnr })
  end,
  vopts_with_buffer = function(bufnr)
    vim.tbl_extend("force", vopts, { buffer = bufnr })
  end,
}
