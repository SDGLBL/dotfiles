local M = {}

local comment_prompts = require("plugins.ai.comment_prompts").comment_prompts

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

M.write_cn_doc_comment = {
  name = "/doc cn",
  strategy = "inline",
  description = "(CN) Write doc comment in chinese",
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
          .. "\n```\n reply with just the comment only and no explanation, no codeblocks and do not return the code either. If necessary add parameter and return types. Please use chinese write the comments."
      end,
    },
  },
}

M.write_en_doc_comment = {
  name = "/doc en",
  strategy = "inline",
  description = "(EN) Write doc comment in english",
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
          .. "\n```\n reply with just the comment only and no explanation, no codeblocks and do not return the code either. If necessary add parameter and return types."
      end,
    },
  },
}

M.write_cn_git_message = {
  name = "(CN) Write Git Message ",
  strategy = "inline",
  description = "Write git commit message in chinese",
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
        return "You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message which written by chinese for me:"
          .. "\n\n```\n"
          .. vim.fn.system "git diff --staged -p"
          .. "\n```"
      end,
    },
  },
}

M.write_en_git_message = {
  name = "(EN) Write Git Message",
  strategy = "inline",
  description = "Write git commit message in english",
  opts = {
    modes = { "n" },
    placement = "cursor|before|after|replace|new", --
  },
  prompts = {
    {
      role = "system",
      content = [[You are an expert at following the Conventional Commit specification.  ]],
    },
    {
      role = "user",
      content = function()
        return "You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:"
          .. "\n\n```\n"
          .. vim.fn.system "git diff --staged -p"
          .. "\n```"
      end,
    },
  },
}

return M
