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
---@diagnostic disable: inject-field
-- lua/plugins/ai/fidget-spinner.lua

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

  handle.reasoning_chunks = {}
  handle.current_state = "initializing" -- initializing, reasoning, responding, finished
  handle.line_count = 3 -- 最多显示的行数
  handle.char_per_line = 50 -- 每行字符数

  return handle
end

function M:update_reasoning(handle, reasoning_chunk)
  if handle.title ~= "" then
    handle.title = ""
  end

  handle.current_state = "reasoning"

  table.insert(handle.reasoning_chunks, reasoning_chunk)

  -- 使用多行格式
  local multiline_text = self:format_reasoning_multiline(handle.reasoning_chunks, handle.line_count, handle.char_per_line)

  -- 保持message为字符串类型
  handle.message = "Reasoning:\n" .. multiline_text
end

-- 新增函数：格式化多行推理显示
function M:format_reasoning_multiline(reasoning_chunks, max_lines, chars_per_line)
  -- 将所有内容合并成一个字符串
  local all_text = table.concat(reasoning_chunks)

  -- 清理文本：替换换行符为空格
  all_text = all_text:gsub("\n", " "):gsub("%s+", " ")

  -- 分割成每行固定字符数的行
  local lines = {}
  local start_pos = math.max(1, #all_text - (max_lines * chars_per_line) + 1)

  for i = 1, max_lines do
    local end_pos = start_pos + chars_per_line - 1
    if start_pos <= #all_text then
      local line = all_text:sub(start_pos, math.min(end_pos, #all_text))
      table.insert(lines, line)
      start_pos = end_pos + 1
    else
      -- 如果没有更多文本，退出循环
      break
    end
  end

  -- 如果第一行不是以"..."开头，并且我们实际上截断了文本
  if #lines > 0 and start_pos > 1 and #all_text > (max_lines * chars_per_line) then
    lines[1] = "..." .. lines[1]:sub(4)
  end

  return table.concat(lines, "\n")
end

function M:format_reasoning_display(reasoning_chunks)
  local latest_chunks = {}
  local count = 0
  for i = #reasoning_chunks, 1, -1 do
    table.insert(latest_chunks, 1, reasoning_chunks[i])
    count = count + #reasoning_chunks[i]
    if count >= 50 then
      break
    end
  end

  local combined = table.concat(latest_chunks)
  combined = combined:gsub("\n", " "):gsub("%s+", " ")
  if #combined > 50 then
    combined = "..." .. combined:sub(-47)
  end

  return combined
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
