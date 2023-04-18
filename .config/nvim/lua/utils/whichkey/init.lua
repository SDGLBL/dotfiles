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
  register = function(mappings)
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.register(mappings, opts)
    end
  end,
  vregister = function(mappings)
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.register(mappings, vopts)
    end
  end,
  register_with_buffer = function(mappings, bufnr)
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.register(mappings, vim.tbl_extend("force", opts, { buffer = bufnr }))
    end
  end,
  vregister_with_buffer = function(mappings, bufnr)
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.register(mappings, vim.tbl_extend("force", vopts, { buffer = bufnr }))
    end
  end,
}
