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
  }

  handle.reasoning_text = "" -- 存储完整的推理文本
  handle.reasoning_lines = {} -- 存储分行后的推理文本
  handle.max_lines = 20 -- 最多显示的行数
  handle.chars_per_line = 70 -- 每行字符数

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
