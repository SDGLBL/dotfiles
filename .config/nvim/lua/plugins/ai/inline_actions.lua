local M = {}

local send_code = function(context)
  local text = require("codecompanion.helpers.code").get_code(context.start_line, context.end_line)

  return "I have the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
end

M.generate_inline_action = {
  name = "Generate",
  strategy = "inline",
  description = "Generate Text",
  picker = {
    prompt = "Select an generate action",
    items = {
      {
        name = "/doc cn",
        strategy = "inline",
        description = "Add a documentation comment",
        opts = {
          modes = { "v" },
          placement = "before|cursor|after|replace|new", --
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
            contains_code = true,
            content = function(context)
              return send_code(context)
            end,
          },
          {
            role = "user",
            content = "Please add a documentation comment to the provided code and reply with just the comment only and no explanation, no codeblocks and do not return the code either. If necessary add parameter and return types.Please use chinese write the comments.",
          },
        },
      },
      {
        name = "Generate Git Message",
        strategy = "inline",
        description = "Generate a git commit message",
        opts = {
          placement = "cursor|before|after|replace|new", --
        },
        prompts = {
          {
            role = "system",
            content = [[Generate a concise, past tense commit message for provided diffs without additional content.]],
          },
          {
            role = "user",
            content = [[ CONTEXT: ]] .. vim.fn.system "git diff --cached",
          },
        },
      },
      {
        name = "(CN) Generate Git Message ",
        strategy = "inline",
        description = "Generate a chinese git commit message",
        opts = { placement = "cursor|after" },
        prompts = {
          {
            role = "system",
            content = [[使用中文生成提供的差异的简明过去式提交消息，不包含其他内容。]],
          },
          {
            role = "user",
            content = [[ CONTEXT: ]] .. vim.fn.system "git diff --cached",
          },
        },
      },
    },
  },
}

M.translate_inline_action = {
  name = "Translate",
  strategy = "inline",
  description = "Translate text",
  picker = {
    prompt = "Select an translate action",
    items = {
      {
        name = "Translate 2 CN",
        strategy = "inline",
        description = "Translate to chinese",
        opts = {
          modes = { "v" },
          placement = "replace|before|cursor|after|replace|new", --
        },
        prompts = {
          {
            role = "system",
            content = [[You are a translation engine that can only translate text and cannot interpret it.
You will receive text in any language sent by the user, and you need to translate it into fluent Chinese.
When you encounter any comment symbols in any programming language, keep them as they are, only translate the text part. For some specific computer terms, you do not need to translate and can directly use the original text
Please reply with just the translation only and no explanation, no codeblocks and do not return the markdown codeblock symbol ```.
]],
          },
          {
            role = "user",
            content = function(context)
              return require("codecompanion.helpers.code").get_code(context.start_line, context.end_line)
            end,
          },
        },
      },
      {
        name = "Translate 2 EN",
        strategy = "inline",
        description = "Translate to english",
        opts = { modes = { "v" }, placement = "replace|cursor" },
        prompts = {
          {
            role = "system",
            content = [[You are a translation engine that can only translate text and cannot interpret it.
You will receive text in any language sent by the user, and you need to translate it into fluent English.
When you encounter any comment symbols in any programming language, keep them as they are, only translate the text part. For some specific computer terms, you do not need to translate and can directly use the original text
Please reply with just the translation only and no explanation, no codeblocks and do not return the markdown codeblock symbol ```.
]],
          },
          {
            role = "user",
            content = function(context)
              return require("codecompanion.helpers.code").get_code(context.start_line, context.end_line)
            end,
          },
        },
      },
    },
  },
}

return M
