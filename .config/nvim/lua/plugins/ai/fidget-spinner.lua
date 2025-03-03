---@diagnostic disable: inject-field
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
    title = " Requesting assistance (" .. request.data.strategy .. ")",
    message = "In progress...",
    lsp_client = {
      name = M:llm_role_title(request.data.adapter),
    },
  }

  handle.reasoning_chunks = {}
  handle.current_state = "initializing" -- initializing, reasoning, responding, finished

  return handle
end

function M:update_reasoning(handle, reasoning_chunk)
  if handle.title ~= "" then
    handle.title = ""
  end

  handle.current_state = "reasoning"

  table.insert(handle.reasoning_chunks, reasoning_chunk)

  local display_text = self:format_reasoning_display(handle.reasoning_chunks)

  handle.message = "Reasoning: " .. display_text
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
