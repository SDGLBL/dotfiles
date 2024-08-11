local M = {}

local comment_prompts = require("plugins.ai.comment_prompts").comment_prompts

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
    placement = "before|cursor|after|replace|new",
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
            placement = "before|cursor|after|replace|new",
            stop_context_insertion = true,
            user_prompt = true,
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
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return "Please add a documentation comment to the provided code:\n\n```"
                  .. context.filetype
                  .. "\n"
                  .. code
                  .. "\n```\n reply with just the comment only and no explanation, no codeblocks and do not return the code either. If necessary add parameter and return types. Please write the comments in "
                  .. lang
                  .. "."
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
    modes = { "n" },
    placement = "cursor|after",
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
            placement = "cursor|after",
          },
          prompts = {
            {
              role = "system",
              content = [[You are an expert at following the Conventional Commit specification.  ]],
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
                  .. "Do not return the markdown codeblock symbol ``` in your response. "
              end,
            },
          },
        })
      end

      return languages
    end,
  },
}

M.write_in_context = {
  name = "Write in context",
  strategy = "inline",
  description = "Write in context",
  opts = {
    modes = { "n", "v" },
    placement = "replace|cursor",
    user_prompt = true,
  },
  prompts = {
    {
      role = "system",
      condition = function(context)
        return context.is_visual
      end,
      content = [[
You are an expert coder and helpful assistant who can write code or comments in context, specifically focusing on selected code regions. Follow these guidelines:
1. Analyze the provided code context carefully, paying special attention to the code enclosed between <|Selected|> and </|Selected|> tags. This is the user's selected area.
2. Identify the programming language used in the context and ensure you use the same language in your response.
3. Your task is to modify, improve, or expand the selected code while considering the broader context.
4. Your entire response will replace the content between the <|Selected|> tags, including the tags themselves.
5. Your response should seamlessly integrate with the existing code surrounding the selected region.
6. Do not include the <|Selected|> or </|Selected|> markers in your response.
7. Do not add any explanations or comments about your response outside the code.
8. Ensure your code follows the style, conventions, and language used in the surrounding code.
9. If you're adding comments within the code, make sure they're in the appropriate style for the identified language (// or /* */ for most languages, # for Python, etc.).
10. Consider the purpose of the selected code and aim to enhance its functionality, readability, or efficiency.
11. If the surrounding code contains non-English comments or string literals, maintain the same language for consistency.
      ]],
    },
    {
      role = "system",
      condition = function(context)
        return not context.is_visual
      end,
      content = [[
You are an expert coder and helpful assistant who can write code or comments in context. Follow these guidelines:
1. Analyze the provided code context carefully.
2. Identify the programming language used in the context and ensure you use the same language in your response.
3. Write your response exactly where the <|Write text here|> marker is placed.
4. Your response should seamlessly integrate with the existing code.
5. Do not include the <|Write text here|> marker in your response.
6. Do not add any explanations or comments about your response.
7. Ensure your code follows the style, conventions, and language used in the surrounding code.
8. If you're adding comments within the code, make sure they're in the appropriate style for the identified language (// or /* */ for most languages, # for Python, etc.).
9. Your entire response will be inserted directly into the code, so make sure it's ready to use as-is.
10. Consider the context around the insertion point and aim to enhance the functionality, readability, or efficiency of the code.
11. If the surrounding code contains non-English comments or string literals, maintain the same language for consistency.
      ]],
    },
    {
      role = "user",
      condition = function(context)
        return context.is_visual
      end,
      content = function(context)
        local bufnr = context.bufnr
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local start_line, start_col = context.start_line, context.start_col
        local end_line, end_col = context.end_line, context.end_col

        -- Insert the selection markers
        lines[start_line] = string.sub(lines[start_line], 1, start_col - 1) .. "<|Selected|>" .. string.sub(lines[start_line], start_col)
        lines[end_line] = string.sub(lines[end_line], 1, end_col) .. "</|Selected|>" .. string.sub(lines[end_line], end_col + 1)

        local full_content = table.concat(lines, "\n")

        return string.format(
          [[
Given the entire content of the current buffer below, please focus on the code enclosed in <|Selected|> tags:

```
%s
```

The code between <|Selected|> and </|Selected|> is the user's selected area. Analyze this area carefully and provide improvements, modifications, or expansions as appropriate. Your response will completely replace the content between these tags, including the tags themselves.

Ensure that you use the same programming language and follow the coding style present in the surrounding code. If there are non-English comments or string literals, maintain the same language for consistency.

Generate your response without any additional explanation. Your generated text will directly replace the selected area in the buffer.

Do not return the markdown codeblock symbol ``` in your response.
]],
          full_content
        )
      end,
    },
    {
      role = "user",
      condition = function(context)
        return not context.is_visual
      end,
      content = function(context)
        local bufnr = context.bufnr
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local cursor_line, cursor_col = unpack(context.cursor_pos)

        -- Insert the marker at the cursor position
        local current_line = lines[cursor_line]
        local before_cursor = string.sub(current_line, 1, cursor_col - 1)
        local after_cursor = string.sub(current_line, cursor_col)
        lines[cursor_line] = before_cursor .. "<|Write text here|>" .. after_cursor

        local full_content = table.concat(lines, "\n")

        return string.format(
          [[
Given the entire content of the current buffer below, please generate code or comments to replace the <|Write text here|> marker:

```
%s
```

Ensure that you use the same programming language and follow the coding style present in the surrounding code. If there are non-English comments or string literals, maintain the same language for consistency.

Generate your response without any additional explanation. Your generated text will replace the <|Write text here|> marker directly in the buffer.

Do not return the markdown codeblock symbol ``` in your response.
]],
          full_content
        )
      end,
    },
  },
}

return M
