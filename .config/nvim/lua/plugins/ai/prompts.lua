local M = {}

local comment_prompts = require("plugins.ai.comment_prompts").comment_prompts
local buf_utils = require "codecompanion.utils.buffers"
local content_prompt = require "plugins.ai.prompts.content_prompt"
local context_groups = require "context-groups"

M.support_languages = {
  "Chinese",
  "English",
  "Japanese",
  "Korean",
  "French",
  "Spanish",
  "Portuguese",
  "Russian",
  "German",
  "Italian",
}

M.add_struct_field_comment = {
  strategy = "chat",
  description = "Write comment for struct fields",
  opts = {
    index = 1,
    default_prompt = false,
    modes = { "n", "v" },
    auto_submit = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = "system",
      content = function(context)
        return "I want you to act as a senior "
          .. context.filetype
          .. " developer. I will give you specific task and I want you to return raw code or comments only (no codeblocks and no explanations). If you can't respond with code or comment, respond with nothing"
      end,
    },
    {
      role = "${user}",
      condition = function(context)
        return not context.is_visual
      end,
      content = "I have the following code:\n\n",
    },
    {
      role = "${user}",
      condition = function(context)
        return context.is_visual
      end,
      content = function(context)
        local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

        return "I have the following code:\n\n```"
          .. context.filetype
          .. "\n"
          .. text
          .. "\n```\n\n Please add comments to the struct fields. Here are some references: \n "
      end,
    },
  },
}

M.write_comment = {
  name = "Write comment",
  strategy = "inline",
  description = "Write comment",
  opts = {
    modes = { "v" },
    placement = "before",
    stop_context_insertion = true,
    user_prompt = true,
  },
  picker = {
    prompt = "Select language",
    items = function()
      local languages = {}

      for _, lang in ipairs(M.support_languages) do
        table.insert(languages, {
          name = lang,
          strategy = "inline",
          description = "Write comment in " .. lang,
          opts = {
            modes = { "v" },
            placement = "before",
            stop_context_insertion = true,
            -- user_prompt = true,
            adapter = {
              -- name = "groq",
              -- model = "llama-3.2-90b-text-preview",
              -- name = "openai",
              -- model = "gpt-4o-mini",
              -- name = "ollama",
              -- model = "qwen2.5-coder",
              -- model = "gemini-1.5-flash-latest",
              name = "siliconflow",
              model = "Qwen/Qwen2.5-Coder-32B-Instruct",
            },
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                return "You are an expert coder and helpful assistant who can help write documentation comments for the " .. context.filetype .. " language. "
              end,
            },
            {
              role = "user",
              condition = function(context)
                return vim.tbl_contains(vim.tbl_keys(comment_prompts), context.filetype)
              end,
              content = function(context)
                return comment_prompts[context.filetype]
              end,
            },
            {
              role = "user",
              contains_code = true,
              -- opts = {
              --   contains_code = true,
              -- },
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                local bufnr = context.bufnr
                local buf_content = buf_utils.get_content(bufnr)
                return string.format(
                  [[
As an expert coder, please write a comprehensive documentation comment for the following %s code snippet. Consider the full context of the file provided below.

Full file context:
```%s
%s
```

Specific code to comment:
```%s
%s
```

Requirements:
1. Write the comment in %s.
2. Include parameter and return types if applicable.
3. Provide a brief explanation of the code's purpose and functionality.
4. Use the appropriate comment syntax for %s.
5. Only return the comment, without any code or additional explanations.
6. Ensure the comment is concise yet informative.
7. Only write comment without any markdown code fences like '```'.

Please provide the comment now:]],
                  context.filetype,
                  context.filetype,
                  buf_content,
                  context.filetype,
                  code,
                  lang,
                  context.filetype
                )
              end,
            },
          },
        })
      end

      return languages
    end,
  },
}

M.write_git_message = {
  name = "Write Git Message ",
  strategy = "inline",
  description = "Write git commit message",
  opts = {
    index = 2,
    modes = { "n" },
    placement = "add",
  },
  picker = {
    prompt = "Select language",
    items = function()
      local languages = {}

      for _, lang in ipairs(M.support_languages) do
        table.insert(languages, {
          name = lang,
          strategy = "inline",
          description = "Write git commit message in " .. lang,
          opts = {
            modes = { "n" },
            placement = "add",
            adapter = {
              -- name = "deepseek",
              -- model = "deepseek-chat",
              -- name = "groq",
              -- model = "llama-3.2-90b-text-preview",
              name = "siliconflow",
              model = "Qwen/Qwen2.5-Coder-32B-Instruct",
            },
          },
          prompts = {
            {
              role = "system",
              content = [[You are a git commit message generator specialized in Conventional Commits. Output only the detailed commit message, avoiding any markdown or code block syntax.]],
            },
            {
              role = "user",
              content = function()
                return "You are an expert at following the Conventional Commit specification. Given the git diff listed below. please generate a commit message which written in "
                  .. lang
                  .. " for me:"
                  .. "\n\n```\n"
                  .. vim.fn.system "git diff --staged -p"
                  .. "\n```"
              end,
            },
          },
        })
      end

      return languages
    end,
  },
}

local write_in_context_adapter = {
  -- name = "deepseek",
  -- model = "deepseek-chat",
  name = "siliconflow",
  model = "Qwen/Qwen2.5-Coder-32B-Instruct",
  -- name = "groq",
  -- model = "llama-3.2-90b-text-preview",
  -- name = "copilot",
  -- model = "claude-3-5-sonnet",
  -- name = "openai",
  -- model = "gpt-4o-mini",
  -- name = "yi",
  -- model = "yi-lightning",
  -- name = "anthropic",
  -- model = "claude-3-5-haiku-latest",
  -- name = "openai",
  -- model = "gemini-1.5-flash-latest",
  -- name = "ollama",
  -- model = "qwen2.5-coder:1.5b",
}

M.write_in_selected_context = {
  name = "Write in selected context",
  strategy = "inline",
  description = "Write in selected context",
  opts = {
    index = 1,
    modes = { "n", "v" },
    placement = "replace",
    stop_context_insertion = true,
    user_prompt = true,
    append_user_prompt = false,
    append_last_chat = true,
    append_last_system_prompt = false,
    adapter = write_in_context_adapter,
  },
  prompts = {
    {
      role = "system",
      -- opts = {
      --   contains_code = true,
      -- },
      content = [[As a code assistant, you need to understand and process various input formats:
1. Source code file: Usually enclosed in <document></document> tags, may contain code segments to be modified, which are surrounded by <rewrite_this></rewrite_this> tags.
2. User queries: May be inquiries about code optimization or feature improvements. These queries typically appear in regular user messages.
3. Assistant replies: Your previous responses, which may include code suggestions or explanations.
4. Rewrite instructions: In the last user message, rewrite instructions are usually contained within <prompt></prompt> tags. These instructions may relate to previous user queries and your replies.
5. Context association: Note that rewrite instructions may be related to previous conversation content. When handling rewrite requests, consider previous user queries and your responses. 
6. Code rewriting: When encountering rewrite instructions, only modify the code within <rewrite_this></rewrite_this> tags, keeping other parts unchanged. Maintain the original indentation level when rewriting, and rewrite the entire section completely, even if some parts don't need changes.
7. Code insertion: When encountering insert instructions, insert the code at the position marked by <insert_here></insert_here> tags. Ensure that the inserted code matches the indentation level of the surrounding code.
8. Return the modified code directly without any markdown formatting, code fences, or additional text. Do not wrap the response in ``` or any other code fences. The response should start with the actual code content and contain nothing else.
Please interpret and respond to the following messages according to these rules.]],
    },
    {
      role = "user",
      -- opts = {
      --   contains_code = true,
      -- },
      content = function(context)
        local bufnr = context.bufnr
        local user_prompt = context.user_input
        local main_buffer_content = buf_utils.get_content(bufnr)
        local lines = vim.split(main_buffer_content, "\n")
        local context_files = context_groups.get_context_contents(bufnr)

        -- Determine content type based on filetype
        local content_type = (context.filetype == "markdown" or context.filetype == "html") and "text" or "code"

        -- Common values for both insert and visual mode
        local val = {
          language_name = context.filetype,
          document_content = main_buffer_content,
          content_type = content_type,
          user_prompt = user_prompt,
          context_files = context_files,
        }

        if not context.is_visual then
          -- Insert mode: Add insert marker at cursor position
          local cursor_line, cursor_col = unpack(context.cursor_pos)
          local current_line = lines[cursor_line]
          local before_cursor = string.sub(current_line, 1, cursor_col - 1)
          local after_cursor = string.sub(current_line, cursor_col)
          lines[cursor_line] = before_cursor .. "<insert_here></insert_here>" .. after_cursor
          val.is_insert = true
        else
          -- Visual mode: Add rewrite markers around selected text
          local start_line, start_col = context.start_line, context.start_col
          local end_line, end_col = context.end_line, context.end_col

          lines[start_line] = string.sub(lines[start_line], 1, start_col - 1) .. "<rewrite_this>\n" .. string.sub(lines[start_line], start_col)
          lines[end_line] = string.sub(lines[end_line], 1, end_col) .. "\n</rewrite_this>" .. string.sub(lines[end_line], end_col + 1)
          val.is_insert = false -- This is actually a rewrite operation
        end

        -- Update main_buffer_content with modified lines
        val.document_content = table.concat(lines, "\n")

        -- Generate and return the prompt
        return content_prompt.render(val)
      end,
    },
  },
}

M.write_in_codebase_context = {
  name = "Write in codebase context",
  strategy = "inline",
  description = "Write in codebase context",
  opts = {
    index = 1,
    modes = { "n", "v" },
    placement = "replace",
    stop_context_insertion = true,
    user_prompt = true,
    append_user_prompt = false,
    append_last_chat = true,
    append_last_system_prompt = false,
    adapter = write_in_context_adapter,
  },
  prompts = {
    {
      role = "system",
      -- opts = {
      --   contains_code = true,
      -- },
      content = [[As a code assistant, you need to understand and process various input formats:
1. Source code file: Usually enclosed in <document></document> tags, may contain code segments to be modified, which are surrounded by <rewrite_this></rewrite_this> tags.
2. User queries: May be inquiries about code optimization or feature improvements. These queries typically appear in regular user messages.
3. Assistant replies: Your previous responses, which may include code suggestions or explanations.
4. Rewrite instructions: In the last user message, rewrite instructions are usually contained within <prompt></prompt> tags. These instructions may relate to previous user queries and your replies.
5. Context association: Note that rewrite instructions may be related to previous conversation content. When handling rewrite requests, consider previous user queries and your responses. 
6. Code rewriting: When encountering rewrite instructions, only modify the code within <rewrite_this></rewrite_this> tags, keeping other parts unchanged. Maintain the original indentation level when rewriting, and rewrite the entire section completely, even if some parts don't need changes.
7. Code insertion: When encountering insert instructions, insert the code at the position marked by <insert_here></insert_here> tags. Ensure that the inserted code matches the indentation level of the surrounding code.
8. Return the modified code directly without any markdown formatting, code fences, or additional text. Do not wrap the response in ``` or any other code fences. The response should start with the actual code content and contain nothing else.
Please interpret and respond to the following messages according to these rules.]],
    },
    {
      role = "user",
      -- opts = {
      --   contains_code = true,
      -- },
      content = function(context)
        local bufnr = context.bufnr
        local user_prompt = context.user_input
        local main_buffer_content = buf_utils.get_content(bufnr)
        local lines = vim.split(main_buffer_content, "\n")

        -- Determine content type based on filetype
        local content_type = (context.filetype == "markdown" or context.filetype == "html") and "text" or "code"

        -- Common values for both insert and visual mode
        local val = {
          language_name = context.filetype,
          document_content = main_buffer_content,
          content_type = content_type,
          user_prompt = user_prompt,
          codebase = table.concat(context_groups.export_contents {}, "\n"),
        }

        vim.notify(string.format("codebase: %s", val.codebase), vim.log.levels.INFO)

        if not context.is_visual then
          -- Insert mode: Add insert marker at cursor position
          local cursor_line, cursor_col = unpack(context.cursor_pos)
          local current_line = lines[cursor_line]
          local before_cursor = string.sub(current_line, 1, cursor_col - 1)
          local after_cursor = string.sub(current_line, cursor_col)
          lines[cursor_line] = before_cursor .. "<insert_here></insert_here>" .. after_cursor
          val.is_insert = true
        else
          -- Visual mode: Add rewrite markers around selected text
          local start_line, start_col = context.start_line, context.start_col
          local end_line, end_col = context.end_line, context.end_col

          lines[start_line] = string.sub(lines[start_line], 1, start_col - 1) .. "<rewrite_this>\n" .. string.sub(lines[start_line], start_col)
          lines[end_line] = string.sub(lines[end_line], 1, end_col) .. "\n</rewrite_this>" .. string.sub(lines[end_line], end_col + 1)
          val.is_insert = false -- This is actually a rewrite operation
        end

        -- Update main_buffer_content with modified lines
        val.document_content = table.concat(lines, "\n")

        -- Generate and return the prompt
        return content_prompt.render(val)
      end,
    },
  },
}

return M
