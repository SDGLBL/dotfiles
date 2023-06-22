local function input_args()
  ---@diagnostic disable-next-line: redundant-parameter
  local args = vim.fn.input("Arguments: ", "", "file")

  if args ~= "" then
    return vim.split(args, " ")
  else
    return {}
  end
end

return {
  input_args = input_args,
}
