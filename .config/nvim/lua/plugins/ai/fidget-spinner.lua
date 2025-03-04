---@diagnostic disable: inject-field, undefined-field
-- lua/plugins/ai/fidget-spinner.lua

-- Fidget spinner implementation for Code Companion
-- This module provides visual feedback during AI request processing
-- It shows a progress spinner and reasoning updates in the Neovim UI
--
-- The mechanism works as follows:
-- 1. Creates a progress handle with spinner and message
-- 2. Listens to Code Companion events via autocommands
-- 3. Updates progress display based on request status
-- 4. Manages multiple concurrent requests
-- 5. Handles cleanup and status reporting on completion
--
-- Key components:
-- - Progress handle management
-- - Reasoning text formatting
-- - State tracking
-- - Neovim UI integration
local progress = require "fidget.progress"

local M = {}

function M:init()
  local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

  -- 创建自定义高亮组
  self:setup_custom_highlights()

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(request)
      local handle = M:create_progress_handle(request)
      M:store_progress_handle(request.data.id, handle)
    end,
  })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionReasoningUpdated",
    group = group,
    callback = function(event)
      local handle = M.handles[event.data.id]
      if handle then
        M:update_reasoning(handle, event.data.reasoning)
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(request)
      local handle = M:pop_progress_handle(request.data.id)
      if handle then
        M:report_exit_status(handle, request)
        handle:finish()
      end
    end,
  })

  -- 当配色方案改变时重新应用高亮
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      self:setup_custom_highlights()
    end,
  })
end

-- 设置自定义高亮组
function M:setup_custom_highlights()
  -- 创建自定义高亮组
  vim.api.nvim_set_hl(0, "CodeCompanionFidgetNormal", {
    bg = "#2E3440", -- 背景色 (Nordic 深色主题颜色)
    fg = "#D8DEE9", -- 前景色
  })

  vim.api.nvim_set_hl(0, "CodeCompanionFidgetTitle", {
    bg = "#2E3440", -- 背景色
    fg = "#88C0D0", -- 标题颜色 (亮蓝色)
    bold = true,
  })

  vim.api.nvim_set_hl(0, "CodeCompanionFidgetReasoning", {
    bg = "#2E3440", -- 背景色
    fg = "#A3BE8C", -- 推理文本颜色 (绿色)
  })

  -- 设置 Fidget 使用我们的高亮组
  -- 这需要 Fidget 的配置支持
  if vim.g.fidget_configured ~= true then
    require("fidget").setup {
      notification = {
        window = {
          winblend = 0, -- 设置为0以确保背景色完全不透明
        },
        configs = {
          default = {
            group_style = "CodeCompanionFidgetTitle",
            annote_style = "CodeCompanionFidgetReasoning",
          },
        },
      },
    }
    vim.g.fidget_configured = true
  end
end

M.handles = {}

function M:store_progress_handle(id, handle)
  M.handles[id] = handle
end

function M:pop_progress_handle(id)
  local handle = M.handles[id]
  M.handles[id] = nil
  return handle
end

function M:create_progress_handle(request)
  local handle = progress.handle.create {
    title = " Requesting assistance (" .. request.data.strategy .. ")",
    message = "In progress...",
    lsp_client = {
      name = M:llm_role_title(request.data.adapter),
    },
    -- 尝试应用自定义样式
    style = "CodeCompanionFidgetNormal",
  }

  handle.reasoning_text = "" -- 存储完整的推理文本
  handle.reasoning_lines = {} -- 存储分行后的推理文本
  handle.max_lines = 20 -- 最多显示的行数
  handle.chars_per_line = 80 -- 每行字符数

  return handle
end

function M:update_reasoning(handle, reasoning_chunk)
  if handle.title ~= "" then
    handle.title = ""
  end

  -- 追加新的推理文本
  handle.reasoning_text = handle.reasoning_text .. reasoning_chunk

  -- 处理文本：替换换行符为空格
  local processed_text = handle.reasoning_text:gsub("\n", " "):gsub("%s+", " ")

  -- 重新生成所有行
  handle.reasoning_lines = {}
  for i = 1, #processed_text, handle.chars_per_line do
    local line = processed_text:sub(i, i + handle.chars_per_line - 1)
    table.insert(handle.reasoning_lines, line)
  end

  -- 如果行数超过最大限制，移除最早的行
  while #handle.reasoning_lines > handle.max_lines do
    table.remove(handle.reasoning_lines, 1)
    -- 添加省略号到第一行表示内容被截断
    if #handle.reasoning_lines > 0 then
      handle.reasoning_lines[1] = "..." .. handle.reasoning_lines[1]:sub(4)
    end
  end

  -- 更新消息
  handle.message = "Reasoning:\n" .. table.concat(handle.reasoning_lines, "\n")
  handle.style = "CodeCompanionFidgetReasoning" -- 尝试应用自定义样式
end

function M:llm_role_title(adapter)
  local parts = {}
  table.insert(parts, adapter.formatted_name)
  if adapter.model and adapter.model ~= "" then
    table.insert(parts, "(" .. adapter.model .. ")")
  end
  return table.concat(parts, " ")
end

function M:report_exit_status(handle, request)
  if request.data.status == "success" then
    handle.message = "✓ Completed"
  elseif request.data.status == "error" then
    handle.message = "⨯ Error"
  else
    handle.message = "󰜺 Cancelled"
  end
end

return M
