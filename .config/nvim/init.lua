-- colorscheme sonokai style
-- `'default'`, `'atlantis'`, `'andromeda'`, `'shusia'`, `'maia'`, `'espresso'`
vim.g.sonokai_style = "maia"

-- copilot setup
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

-- conda setup
if os.getenv("CONDA_PREFIX") ~= "" then
	vim.g.python3_host_prog = os.getenv("CONDA_PREFIX") .. "/bin/python"
end

require("system.setup").setup({
	transparent_window = false,
	format_on_save = true,
	colorscheme = "duskfox",
	-- colorscheme = "nightfly",
	-- colorscheme = "nightfox",
	-- colorscheme = "github_dimmed",
	-- colorscheme        = "tokyonight",
	-- colorscheme = "sonokai",
	-- colorscheme = "onedarkpro",
	-- colorscheme = "monokai_soda",
	-- colorscheme        = "catppuccin",
	-- colorscheme        = "rose-pine",
	active_autopairs = true,
	active_lsp = true,
	-- active_refactor    = true,
	active_dap = true,
	autocmds = {
		custom_groups = {
			{ "BufWinEnter", "*.go", "setlocal ts=4 sw=4" },
			{ "BufWinEnter", "*.c", "setlocal ts=4 sw=4" },
			{ "BufWinEnter", "*.cpp", "setlocal ts=4 sw=4" },
			{ "BufWinEnter", "*.h", "setlocal ts=4 sw=4" },
			{ "BufWinEnter", "*.php", "setlocal ts=4 sw=4" },
		},
	},
})
