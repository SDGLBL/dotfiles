local status_ok, dap = pcall(require, "dap")
if not status_ok then
  return
end

-- go debug
dap.adapters.go = {
  type = 'executable';
  command = 'node';
  args = { '/home/lijie/.local/share/nvim/dapinstall/go/vscode-go/dist/debugAdapter.js' };
}
dap.configurations.go = {
  {
    type = 'go';
    name = 'Debug';
    request = 'launch';
    showLog = false;
    program = "${file}";
    dlvToolPath = vim.fn.exepath('dlv') -- Adjust to where delve is installed
  },
  {
    type = "go",
    name = "Attach",
    request = "attach",
    processId = require("dap.utils").pick_process,
    -- program = "${workspaceFolder}",
    dlvToolPath = vim.fn.exepath('dlv')
  },
  {
    type = "go",
    name = "Debug curr test",
    request = "launch",
    mode = "test",
    program = "${file}",
    dlvToolPath = vim.fn.exepath('dlv')
  },
  {
    type = "go",
    name = "Debug test",
    request = "launch",
    mode = "test",
    program = "${workspaceFolder}",
    dlvToolPath = vim.fn.exepath('dlv')
  },

}

lvim.builtin.which_key.mappings["d"] = {
  name = "+Debugger",
  b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "toggle breakpoint" },
  c = { "<cmd>lua require'dap'.continue()<cr>", "continue" },
  C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "continue to cursor" },
  n = { "<cmd>lua require'dap'.step_over()<cr>", "step over" },
  s = { "<cmd>lua require'dap'.step_into()<cr>", "step into" },
  S = { "<cmd>lua require'dap'.step_out()<cr>", "step out" },
  e = { "<cmd>lua require'dap'.close()<cr>", "stop debugger" },
  l = { "<cmd>lua require'dap'.list_breakpoints()<cr>", "list all breakpoint" },
  r = { "<cmd>lua require'dap'.clear_breakpoints()<cr>", "remove all breakpont" },
  o = { "<cmd>lua require'dapui'.open()<cr>", "open debug ui window" },
  x = { "<cmd>lua require'dapui'.close()<cr>", "close debug ui window" },
  t = { "<cmd>lua require'dapui'.toggle()<cr>", "toggle debug ui window" },
  f = { "<cmd>lua require'dapui'.float_element()<cr>", "get value" },
  v = { "<cmd>lua require'dapui'.eval(nil,{enter=true})<cr>", "eval value" },
}

-- python debug
dap.adapters.python = {
  type = 'executable';
  command = '/home/lijie/.local/share/nvim/dapinstall/python/bin/python';
  args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";
    justMyCode = false;

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      elseif os.getenv("CONDA_PREFIX") ~= "" then
        return os.getenv("CONDA_PREFIX") .. '/bin/python'
      else
        return '/usr/bin/python'
      end
    end;
  },
}


local dapui_ok, dapui = pcall(require, "dapui")
if dapui_ok then
  dapui.setup()
end
local dapvok, dapv = pcall(require, "nvim-dap-virtual-text")
if dapvok then
  dapv.setup()
end
