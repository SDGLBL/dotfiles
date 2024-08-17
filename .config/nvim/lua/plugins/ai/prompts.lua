local M = {}

local comment_prompts = require("plugins.ai.comment_prompts").comment_prompts
local buf_utils = require "codecompanion.utils.buffers"

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
            ..
            " developer. I will give you specific task and I want you to return raw code or comments only (no codeblocks and no explanations). If you can't respond with code or comment, respond with nothing"
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
            -- user_prompt = true,
            adapter = {
              name = "openai",
              model = "gpt-4o-mini",
            },
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                return "You are an expert coder and helpful assistant who can help write documentation comments for the " ..
                    context.filetype .. " language. "
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
            adapter = {
              name = "deepseek",
              model = "deepseek-chat",
            },
          },
          prompts = {
            {
              role = "system",
              content =
              [[You are a git commit message generator specialized in Conventional Commits. Output only the detailed commit message, avoiding any markdown or code block syntax.]],
            },
            {
              role = "user",
              content = function()
                return
                    "You are an expert at following the Conventional Commit specification. Given the git diff listed below. please generate a commit message which written in "
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

M.write_in_context = {
  name = "Write in context",
  strategy = "inline",
  description = "Write in context",
  opts = {
    index = 1,
    modes = { "n", "v" },
    placement = "replace",
    user_prompt = true,
    stop_context_insertion = true,
    adapter = {
      name = "deepseek",
      model = "deepseek-chat",
    },
  },
  prompts = {
    {
      role = "system",
      condition = function(context)
        return context.is_visual
      end,
      content = [[
You are an expert writer and helpful assistant who can edit and improve various types of text in context, considering multiple document buffers. Follow these guidelines:

1. Analyze the provided context carefully across all buffers.
2. Pay special attention to the main buffer, focusing on the text enclosed between <|Selected|> and </|Selected|> tags. This is the user's selected area.
3. Identify the type of content (e.g., prose, code, poetry, script) and the language used in each buffer, ensuring you match the appropriate style and language in your response.
4. Your task is to modify, improve, or expand the selected text while considering the broader context from all buffers.
5. Your entire response will replace the content between the <|Selected|> tags, including the tags themselves.
6. Your response should seamlessly integrate with the existing text surrounding the selected region.
7. Do not include the <|Selected|> tags in your response.
8. Do not add any explanations or comments about your response outside the edited text.
9. Ensure your edit follows the style, tone, conventions, and language used in the surrounding text of the main buffer.
10. If you're adding comments or annotations within the text, make sure they're appropriate for the identified content type.
11. Consider the purpose of the selected text and aim to enhance its clarity, impact, readability, or effectiveness.
12. If any buffer contains non-English text, maintain the same language for consistency in that buffer.
13. You may reference or use information from other buffers, but your primary focus should be on modifying the selected area in the main buffer.
14. Output only the edited content, avoiding any additional formatting or markup unless it's part of the original text.
15. Be prepared to work with various text formats, including but not limited to: essays, articles, stories, scripts, poems, emails, reports, and code snippets.
16. Adapt your editing approach based on the specific needs of the text type, such as improving narrative flow in stories, strengthening arguments in essays, or enhancing clarity in technical documents.
17. Preserve any existing formatting or structural elements (e.g., headings, lists, paragraphs) unless explicitly instructed to change them.
18. If the text contains specialized terminology or jargon, maintain it appropriately within the context of the document.
      ]],
    },
    {
      role = "system",
      condition = function(context)
        return not context.is_visual
      end,
      content = [[
You are an expert writer and helpful assistant who can write or edit text in context, considering multiple document buffers. Follow these guidelines:

1. Analyze the provided context carefully, including all visible buffers.
2. Pay special attention to the main buffer, focusing on the area around the <|Write text here|> marker.
3. Identify the type of content (e.g., prose, code, poetry, script) and the language used in each buffer, ensuring you match the appropriate style and language in your response.
4. Your task is to write or edit text to replace the <|Write text here|> marker while considering the broader context from all buffers.
5. Your response should seamlessly integrate with the existing text surrounding the marker.
6. Do not include the <|Write text here|> marker in your response.
7. Do not add any explanations or comments about your response outside the written/edited text.
8. Ensure your text follows the style, tone, conventions, and language used in the surrounding content of the main buffer.
9. If you're adding comments or annotations within the text, make sure they're appropriate for the identified content type.
10. Consider the context around the insertion point and aim to enhance the clarity, impact, readability, or effectiveness of the text.
11. If any buffer contains non-English text, maintain the same language for consistency in that buffer.
12. You may reference or use information from other buffers, but your primary focus should be on writing or editing text at the marker position in the main buffer.
13. Output only the detailed content, avoiding any additional formatting or markup unless it's part of the original text.
14. Be prepared to work with various text formats, including but not limited to: essays, articles, stories, scripts, poems, emails, reports, and code snippets.
15. Adapt your writing or editing approach based on the specific needs of the text type, such as maintaining narrative flow in stories, supporting arguments in essays, or ensuring clarity in technical documents.
16. Preserve any existing formatting or structural elements (e.g., headings, lists, paragraphs) in the surrounding text, and match them in your new content if appropriate.
17. If the surrounding text contains specialized terminology or jargon, use it appropriately within your new content.
18. Consider the purpose and audience of the document when crafting your response.]],
    },
    {
      role = "user",
      condition = function(context)
        return context.is_visual
      end,
      content = function(context)
        local bufnr = context.bufnr
        local main_buffer_content = buf_utils.get_content(bufnr)
        local start_line, start_col = context.start_line, context.start_col
        local end_line, end_col = context.end_line, context.end_col

        -- Insert the selection markers
        local lines = vim.split(main_buffer_content, "\n")
        lines[start_line] = string.sub(lines[start_line], 1, start_col - 1) ..
            "<|Selected|>" .. string.sub(lines[start_line], start_col)
        lines[end_line] = string.sub(lines[end_line], 1, end_col) ..
            "</|Selected|>" .. string.sub(lines[end_line], end_col + 1)
        main_buffer_content = table.concat(lines, "\n")

        local prompt = string.format(
          [[
Given the content of multiple buffers, please focus on the main buffer and the selected area within it.

Main buffer:
%s

]],
          main_buffer_content
        )

        local other_buffers = buf_utils.get_open(context.filetype)
        for _, buffer in ipairs(other_buffers) do
          if buffer.id ~= bufnr then
            local buf_info = buf_utils.get_info(buffer.id)
            prompt = prompt
                .. string.format(
                  [[
Buffer ID: %d
Name: %s
Path: %s
Filetype: %s
Content:
```%s
%s
```
]],
                  buf_info.id,
                  buf_info.name,
                  buf_info.path,
                  buf_info.filetype,
                  buf_info.filetype,
                  buf_utils.get_content(buffer.id)
                )
          end
        end

        prompt = prompt
            .. [[
In the main buffer, the text between <|Selected|> and </|Selected|> is the user's selected area. Analyze this area carefully and provide improvements, modifications, or expansions as appropriate. Your response will completely replace the content between these tags, including the tags themselves.

Ensure that you use the same programming language and follow the coding style present in the surrounding code of the main buffer. If there are non-English comments or string literals in any buffer, maintain the same language for consistency in that buffer.

Generate your response without any additional explanation. Your generated text will directly replace the selected area in the main buffer. Output only the detailed content, avoiding any markdown or code block syntax.]]

        return prompt
      end,
    },
    {
      role = "user",
      condition = function(context)
        return not context.is_visual
      end,
      content = function(context)
        local bufnr = context.bufnr
        local main_buffer_content = buf_utils.get_content(bufnr)
        local cursor_line, cursor_col = unpack(context.cursor_pos)

        -- Insert the marker at the cursor position
        local lines = vim.split(main_buffer_content, "\n")
        local current_line = lines[cursor_line]
        local before_cursor = string.sub(current_line, 1, cursor_col - 1)
        local after_cursor = string.sub(current_line, cursor_col)
        lines[cursor_line] = before_cursor .. "<|Write text here|>" .. after_cursor
        main_buffer_content = table.concat(lines, "\n")

        local prompt = string.format(
          [[
Given the content of multiple buffers, please focus on the main buffer and generate code or comments to replace the <|Write text here|> marker.

Main buffer:
%s

]],
          main_buffer_content
        )

        local other_buffers = buf_utils.get_open(context.filetype)
        for _, buffer in ipairs(other_buffers) do
          if buffer.id ~= bufnr then
            local buf_info = buf_utils.get_info(buffer.id)
            prompt = prompt
                .. string.format(
                  [[
Buffer ID: %d
Name: %s
Path: %s
Filetype: %s
Content:
```%s
%s
```
]],
                  buf_info.id,
                  buf_info.name,
                  buf_info.path,
                  buf_info.filetype,
                  buf_info.filetype,
                  buf_utils.get_content(buffer.id)
                )
          end
        end

        prompt = prompt
            .. [[
In the main buffer, generate text to replace the <|Write text here|> marker.

Ensure that you use the same programming language and follow the coding style present in the surrounding code of the main buffer. If there are non-English comments or string literals in any buffer, maintain the same language for consistency in that buffer.

Generate your response without any additional explanation. Your generated text will replace the <|Write text here|> marker directly in the main buffer. Output only the detailed content, avoiding any markdown or code block syntax.]]

        return prompt
      end,
    },
  },
}

return M
