local M = {}

local prompts = require "plugins.ai.prompts"
local support_languages = require("plugins.ai.prompts").support_languages

M.translate = {
  name = "Translate",
  strategy = "",
  description = "Translate the provided text",
  opts = {
    index = 3,
    modes = { "v" },
  },
  picker = {
    prompt = "Translate to",
    items = function()
      local languages = {}

      for _, lang in ipairs(support_languages) do
        table.insert(languages, {
          name = "Translate to " .. lang,
          strategy = "inline",
          description = "Translate the provided text to " .. lang,
          opts = {
            modes = { "v" },
            placement = "replace|cursor",
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "system",
              content = [[You are a translator that can only translate text and cannot interpret it.
You will receive text in any language sent by the user, and you need to translate it into fluent]]
                .. lang
                .. [[.
When you encounter any comment symbols in any programming language, keep them as they are, only translate the text part. For some specific computer terms, you do not need to translate and can directly use the original text
Please reply with just the translation only and no explanation, no codeblocks and do not return the markdown codeblock symbol ```.
]],
            },
            {
              role = "user",
              content = function(context)
                return require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
              end,
            },
          },
        })
      end

      return languages
    end,
  },
}

M.write = {
  name = "Write",
  strategy = "inline",
  description = "Write doc/comments/commit message",
  opts = {
    index = 2,
    modes = { "n", "v" },
  },
  picker = {
    prompt = "Write",
    items = function()
      local select_items = {}
      table.insert(select_items, prompts.write_in_context)
      table.insert(select_items, prompts.write_comment)
      table.insert(select_items, prompts.write_git_message)
      return select_items
    end,
  },
}

return M
