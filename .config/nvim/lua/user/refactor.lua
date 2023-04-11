if not configs.refactor then
  return
end

local status_ok, refactor = pcall(require, "refactoring")
if not status_ok then
  return
end

local ok, telescope = pcall(require, "telescope")
if ok then
  telescope.load_extension "refactoring"
end

refactor.setup {}
