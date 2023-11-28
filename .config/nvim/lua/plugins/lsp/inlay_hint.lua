return {
  on_attach = function(client, bufnr)
    if client.name == "copilot" or client.name == "null-ls" then
      return
    end

    if not client.supports_method "textDocument/inlayHint" then
      return
    end

    vim.lsp.inlay_hint.enable(bufnr, true)
  end,
}
