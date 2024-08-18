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
              name = "openai",
              model = "gpt-4o-mini",
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
    placement = "cursor",
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
            placement = "cursor",
            adapter = {
              name = "deepseek",
              model = "deepseek-chat",
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
  name = "deepseek",
  model = "deepseek-coder",
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
    adapter = write_in_context_adapter,
  },
  prompts = {
    {
      role = "system",
      condition = function(context)
        return context.is_visual
      end,
      content = [[You are an expert writer and helpful assistant capable of editing and improving various types of text in context. Follow these guidelines:

Task Overview:
1. Your primary task is to modify, improve, or expand the text between <|Selected|> and </|Selected|> tags in the main buffer.
2. Your entire response will replace the content between these tags, including the tags themselves.
3. Generate only the edited content, without additional explanations or formatting.

Context Analysis:
4. Analyze all provided contexts carefully, including all visible buffers.
5. Pay special attention to the main buffer, focusing on the text enclosed between <|Selected|> and </|Selected|> tags.
6. Identify the content type (e.g., prose, code, poetry, script) and language used in each buffer.

Language and Style Matching:
7. Match the style, tone, conventions, and language used in the surrounding text of the main buffer.
8. If any buffer contains non-English text, maintain the same language for consistency in that buffer.
9. Use specialized terminology or jargon appropriately if present in the surrounding text.

Content Improvement Guidelines:
10. Consider the purpose of the selected text and aim to enhance its clarity, impact, readability, or effectiveness.
11. Ensure your edit seamlessly integrates with the existing text surrounding the selected region.
12. Preserve existing formatting or structural elements (e.g., headings, lists, paragraphs) unless explicitly instructed to change them.
13. Adapt your editing approach based on the specific needs of the text type (e.g., improving narrative flow in stories, strengthening arguments in essays, enhancing clarity in technical documents).

Special Cases:
14. For code snippets: Use the same programming language and follow the coding style present in the surrounding code of the main buffer.
15. For comments or annotations: Ensure they're appropriate for the identified content type.
16. When handling cross-language content: Maintain consistency within each buffer while adhering to the main buffer's primary language.

Additional Instructions:
17. You may reference or use information from other buffers, but focus primarily on modifying the selected area in the main buffer.
18. If faced with ambiguous or contradictory instructions, prioritize the context in the main buffer.
19. Be prepared to work with various text formats, including but not limited to: essays, articles, stories, scripts, poems, emails, reports, and code snippets.
20. Maintain the exact indentation and whitespace of the original code or text, unless specifically instructed to change it.


Remember:
- Do not include the <|Selected|> tags in your response.
- Do not add any explanations or comments about your response outside the edited text.
- Do not wrap your response in markdown code fences or any other formatting.
- Output only the detailed content that will directly replace the selected area in the main buffer.
- Preserve the exact indentation or space and line breaks of the original text.]],
    },
    {
      role = "system",
      condition = function(context)
        return not context.is_visual
      end,
      content = [[You are an expert writer and helpful assistant capable of writing or editing text in various contexts. Follow these guidelines:

Task Overview:
1. Your primary task is to write or edit text to replace the <|Cursor|> marker in the main buffer.
2. Your response should seamlessly integrate with the existing text surrounding the marker.
3. Generate only the content to replace the marker, without additional explanations or formatting.

Context Analysis:
4. Analyze all provided contexts carefully, including all visible buffers.
5. Pay special attention to the main buffer, focusing on the area around the <|Cursor|> marker.
6. Identify the content type (e.g., prose, code, poetry, script) and language used in each buffer.

Language and Style Matching:
7. Match the style, tone, conventions, and language used in the surrounding content of the main buffer.
8. If any buffer contains non-English text, maintain the same language for consistency in that buffer.
9. Use specialized terminology or jargon appropriately if present in the surrounding text.

Content Generation Guidelines:
10. Consider the purpose and audience of the document when crafting your response.
11. Enhance the clarity, impact, readability, or effectiveness of the text.
12. Preserve existing formatting or structural elements (e.g., headings, lists, paragraphs) and match them in your new content if appropriate.
13. Adapt your approach based on the specific needs of the text type (e.g., maintaining narrative flow in stories, supporting arguments in essays, ensuring clarity in technical documents).

Special Cases:
14. For code snippets: Use the same programming language and follow the coding style present in the surrounding code of the main buffer.
15. For comments or annotations: Ensure they're appropriate for the identified content type.
16. When handling cross-language content: Maintain consistency within each buffer while adhering to the main buffer's primary language.

Additional Instructions:
17. You may reference or use information from other buffers, but focus primarily on the main buffer.
18. If faced with ambiguous or contradictory instructions, prioritize the context in the main buffer.
19. Be prepared to work with various text formats, including but not limited to: essays, articles, stories, scripts, poems, emails, reports, and code snippets.
20. Maintain the exact indentation and whitespace of the original code or text, unless specifically instructed to change it.

Remember:
- Do not include the <|Cursor|> marker in your response.
- Do not add any explanations or comments about your response outside the written/edited text.
- Do not wrap your response in markdown code fences or any other formatting.
- Output only the detailed content that will directly replace the marker in the main buffer.
- Preserve the exact indentation or space and line breaks of the original text.]],
    },
    {
      role = "user",
      condition = function(context)
        return context.is_visual and write_in_context_adapter.name == "deepseek"
      end,
      content = 'Given the content of multiple buffers, please focus on the main buffer and the selected area within it.\n\nMain buffer:\n# pyright: basic\n\nimport re\nimport json\nimport argparse\nfrom pathlib import Path\n\n\ndef replace_escaped_newlines(text):\n    """\n    Replace the escaped newline characters (\'\\\\n\') in the given text with actual newline characters (\'\\n\').\n\n    Parameters:\n    text (str): The input text containing escaped newline characters.\n\n    Returns:\n    str: The text with escaped newline characters replaced by actual newline characters.\n    """\n    return text.replace("\\\\n", "\\n")\n\n\ndef remove_json_markers(s):\n    """\n    Remove the ```json markers at the start and ``` markers at the end of the given string, if present.\n\n    Parameters:\n        s (str): The input string containing possible JSON markers.\n\n    Returns:\n        str: The string with JSON markers removed.\n    """\n    return re.sub(r"(^```json\\n)|(\\n```$)", "", s)\n\n\ndef remove_quotation_mark(s):\n    """\n    Remove the double quotation marks at the beginning and end of the given string, if present.\n\n    Parameters:\n        s (str): The input string containing possible quotation marks.\n\n    Returns:\n        str: The string with quotation marks removed.\n    """\n    <|Selected|># Remove ```json at the start and ``` at the end if present\n    s = re.sub(r"^\\"", "", s)\n    s = re.sub(r"\\"$", "", s)\n    return s</|Selected|>',
    },
    {
      role = "assistant",
      condition = function(context)
        return context.is_visual and write_in_context_adapter.name == "deepseek"
      end,
      content = "    return s.strip('\"')",
    },
    {
      role = "user",
      condition = function(context)
        return not context.is_visual and write_in_context_adapter.name == "deepseek"
      end,
      content = 'Given the content of multiple buffers, please focus on the main buffer and generate code or comments to replace the <|Cursor|> marker.\n\nMain buffer:\n# pyright: basic\n\nimport re\nimport json\nimport argparse\nfrom pathlib import Path\n\n\ndef replace_escaped_newlines(text):\n    """\n    Replace the escaped newline characters (\'\\\\n\') in the given text with actual newline characters (\'\\n\').\n\n    Parameters:\n    text (str): The input text containing escaped newline characters.\n\n    Returns:\n    str: The text with escaped newline characters replaced by actual newline characters.\n    """\n    return text.replace("\\\\n", "\\n")\n\n\ndef remove_json_markers(s):\n    """\n    Remove the ```json markers at the start and ``` markers at the end of the given string, if present.\n\n    Parameters:\n        s (str): The input string containing possible JSON markers.\n\n    Returns:\n        str: The string with JSON markers removed.\n    """\n    return re.sub(r"(^```json\\n)|(\\n```$)", "", s)\n\n\ndef remove_quotation_mark(s):\n    """\n    Remove the double quotation marks at the beginning and end of the given string, if present.\n\n    Parameters:\n        s (str): The input string containing possible quotation marks.\n\n    Returns:\n        str: The string with quotation marks removed.\n    """\n<|Cursor|>',
    },
    {
      role = "assistant",
      condition = function(context)
        return not context.is_visual and write_in_context_adapter.name == "deepseek"
      end,
      content = "    return s.strip('\"')",
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
        lines[start_line] = string.sub(lines[start_line], 1, start_col - 1) .. "<|Selected|>" .. string.sub(lines[start_line], start_col)
        lines[end_line] = string.sub(lines[end_line], 1, end_col) .. "</|Selected|>" .. string.sub(lines[end_line], end_col + 1)
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
        lines[cursor_line] = before_cursor .. "<|Cursor|>" .. after_cursor
        main_buffer_content = table.concat(lines, "\n")

        local prompt = string.format(
          [[
Given the content of multiple buffers, please focus on the main buffer and generate code or comments to replace the <|Cursor|> marker.

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

        return prompt
      end,
    },
  },
}

return M
