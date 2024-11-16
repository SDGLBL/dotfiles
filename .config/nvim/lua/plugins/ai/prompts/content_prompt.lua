local system_prompt = [[As a code assistant, you need to understand and process various input formats:
1. Source code file: Usually enclosed in <document></document> tags, may contain code segments to be modified, which are surrounded by <rewrite_this></rewrite_this> tags.
2. User queries: May be inquiries about code optimization or feature improvements. These queries typically appear in regular user messages.
3. Assistant replies: Your previous responses, which may include code suggestions or explanations.
4. Rewrite instructions: In the last user message, rewrite instructions are usually contained within <prompt></prompt> tags. These instructions may relate to previous user queries and your replies.
5. Context association: Note that rewrite instructions may be related to previous conversation content. When handling rewrite requests, consider previous user queries and your responses.
6. Code rewriting: When encountering rewrite instructions, only modify the code within <rewrite_this></rewrite_this> tags, keeping other parts unchanged. Maintain the original indentation level when rewriting, and rewrite the entire section completely, even if some parts don't need changes.
7. Code insertion: When encountering insert instructions, insert the code at the position marked by <insert_here></insert_here> tags. Ensure that the inserted code matches the indentation level of the surrounding code.
8. Return the modified code directly without any markdown formatting, code fences, or additional text. Do not wrap the response in ``` or any other code fences. The response should start with the actual code content and contain nothing else.

Here are examples to demonstrate the expected behavior:

Example 1 - Code Rewriting:
User: Here's my code that needs optimization:
<document>
def calculate_sum(numbers):
    <rewrite_this>
    total = 0
    for num in numbers:
        total = total + num
    return total
    </rewrite_this>
</document>

<prompt>
Optimize this function to use sum() built-in function
</prompt>

Assistant should respond with:
    return sum(numbers)

Example 2 - Code Insertion:
User: Here's my code that needs a new validation:
<document>
def process_user_data(name, age):
    <insert_here>
    
    # Process the data
    print(f"Processing data for {name}, age {age}")
</document>

<prompt>
Add input validation to check if age is a positive integer
</prompt>

Assistant should respond with:
    if not isinstance(age, int) or age <= 0:
        raise ValueError("Age must be a positive integer")

Example 3 - Context-Aware Rewriting:
User: I need to handle errors in my code.
Assistant: You should use try-except blocks for error handling.

User: Here's my code:
<document>
def divide_numbers(a, b):
    <rewrite_this>
    return a / b
    </rewrite_this>
</document>

<prompt>
Apply the error handling we discussed
</prompt>

Assistant should respond with:
    try:
        return a / b
    except ZeroDivisionError:
        raise ValueError("Cannot divide by zero")


Important Notes:
- Always maintain the original indentation level
- Don't add any explanatory text in the response
- Don't use code fences or markdown formatting 
- Consider the entire conversation context when making changes
- Rewrite the entire code block within rewrite_this tag, even if only part of it needs changes
- Make sure inserted code matches the surrounding code style]]
local template = {
  --[[
  Detailed comments explaining all fields that need to be passed in `data` for the `render` function:

  - `data.language_name`: (string) The name of the programming language the file is written in. If provided, it will be included in the rendered output.
  - `data.codebase`: (string) The codebase that needs to be edited or inserted into. This will be included in the rendered output.
  - `data.context_files`(table) A table of context files that provide additional information about the codebase. Each context file includes: 
    - `name`: (string) The name of the file.
    - `filetype`: (string) The type of the file (e.g., "lua", "json").
    - `content`: (string) The content of the file.
  - `data.is_insert`: (boolean) Indicates whether the operation is an insertion. If true, the output will instruct to insert content in place of `<insert_here></insert_here>` tags. If false, it will instruct to rewrite content within `<rewrite_this></rewrite_this>` tags.
  - `data.document_content`: (string) The content of the document that needs to be edited or inserted into. This will be included in the rendered output.
  - `data.is_truncated`: (boolean) Indicates whether the context around the relevant section has been truncated for brevity. If true, a message about truncation will be included in the output.
  - `data.content_type`: (string) The type of content being edited or inserted (e.g., "code", "text"). This will be used in the instructions for the user.
  - `data.user_prompt`: (string) The prompt provided by the user that guides the editing or insertion. This will be included in the rendered output to inform the user what to generate or edit based on.
  - `data.rewrite_section`: (string) The section of content that needs to be rewritten, if the operation is a rewrite. This will be included in the rendered output for reference.
  --]]
  render = function(data)
    local result = ""

    if data.language_name then
      result = result .. "Here's a file of " .. data.language_name .. " that I'm going to ask you to make an edit to.\n"
    else
      result = result .. "Here's a file of text that I'm going to ask you to make an edit to.\n"
    end

    if data.context_files and #data.context_files > 0 then
      result = result .. "\nFirst, here are some related context files that might help you understand the codebase:\n\n"
      for _, ctx_file in ipairs(data.context_files) do
        result = result .. string.format('<context_file name="%s" type="%s">\n%s\n</context_file>\n\n', ctx_file.name, ctx_file.filetype, ctx_file.content)
      end
    end

    if data.codebase and data.codebase ~= "" then
      result = result .. "Here's the codebase you'll be working with:\n"
      result = result .. "<codebase>\n" .. data.codebase .. "\n</codebase>\n"
    end

    if data.is_insert then
      result = result .. "The point you'll need to insert at is marked with <insert_here></insert_here>.\n"
    else
      result = result .. "The section you'll need to rewrite is marked with <rewrite_this></rewrite_this> tags.\n"
    end

    result = result .. "<document>\n" .. (data.document_content or "") .. "\n</document>\n"

    if data.is_truncated then
      result = result .. "The context around the relevant section has been truncated (possibly in the middle of a line) for brevity.\n"
    end

    if data.is_insert then
      result = result
        .. "You can't replace "
        .. (data.content_type or "")
        .. ", your answer will be inserted in place of the `<insert_here></insert_here>` tags. Don't include the insert_here tags in your output.\n"
      result = result .. "Generate " .. (data.content_type or "") .. " based on the following prompt:\n"
      result = result .. "<prompt>\n" .. (data.user_prompt or "") .. "\n</prompt>\n"
      result = result
        .. "Match the indentation in the original file in the inserted "
        .. (data.content_type or "")
        .. [[, don't include any indentation on blank lines.

Please consider all context files provided above when generating the content. Your response should be well-integrated with the existing codebase.

Immediately start without any markdown code fences.]]
    --         .. [[Immediately start with the following format with no remarks:
    --
    -- ```
    -- {{INSERTED_CODE}}
    -- ```]]
    else
      result = result .. "Edit the section of " .. (data.content_type or "") .. " in <rewrite_this></rewrite_this> tags based on the following prompt:\n"
      result = result .. "<prompt>\n" .. (data.user_prompt or "") .. "\n</prompt>\n"

      if data.rewrite_section then
        result = result .. "And here's the section to rewrite based on that prompt again for reference:\n"
        result = result .. "<rewrite_this>\n" .. data.rewrite_section .. "\n</rewrite_this>\n"
      end

      result = result
        .. "Only make changes that are necessary to fulfill the prompt, leave everything else as-is. All surrounding "
        .. (data.content_type or "")
        .. " will be preserved.\n"
      result = result
        .. "Start at the indentation level in the original file in the rewritten "
        .. (data.content_type or "")
        .. [[. Consider all context files provided above when making changes to ensure consistency with the existing codebase. Don't stop until you've rewritten the entire section, even if you have no more changes to make, always write out the whole section with no unnecessary elisions.

Immediately start without any markdown code fences.]]
      --         .. [[Immediately start with the following format with no remarks:
      --
      -- ```
      -- {{REWRITTEN_CODE}}
      -- ```]]
    end

    return result
  end,
}

return {
  system_prompt = system_prompt,
  user_prompt_template = template,
}
