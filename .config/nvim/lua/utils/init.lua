local function input_args()
  ---@diagnostic disable-next-line: redundant-parameter
  local args = vim.fn.input("Arguments: ", "", "file")

  if args ~= "" then
    return vim.split(args, " ")
  else
    return {}
  end
end

local function os_name()
  local on = vim.loop.os_uname().sysname

  if on == "Darwin" then
    return "macOS"
  elseif on == "Linux" then
    return "Linux"
  elseif on == "Windows" then
    return "Windows"
  else
    return on
  end
end

return {
  input_args = input_args,
  os_name = os_name,
}
