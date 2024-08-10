local go_comment_prompt = [[# Go Comment Writing Guide

## 1. Package Comments

Key points:
- Begin with "Package [name]"
- Briefly introduce the package's purpose
- May include usage examples or important API overview

Example:
```go
// Package path implements utility routines for manipulating slash-separated paths.
package path
```

## 2. Type Comments

Key points:
- Explain what each instance represents
- State concurrency safety
- Explain zero value meaning (if not obvious)

Example:
```go
// Buffer is a variable-sized buffer of bytes with Read and Write methods.
// The zero value for Buffer is an empty buffer ready to use.
type Buffer struct {
    // ...
}
```

## 3. Function/Method Comments

Key points:
- Explain what the function does or returns
- Describe parameters and return values
- Mention any special cases

Example:
```go
// Quote returns a double-quoted Go string literal representing s.
// The returned string uses Go escape sequences for control characters
// and non-printable characters as defined by IsPrint.
func Quote(s string) string {
    // ...
}
```

## 4. Constant Comments

Key points:
- Can use group comments to introduce related constants
- Use complete sentences for individual constants

Example:
```go
// The result of Scan is one of these tokens or a Unicode character.
const (
    EOF = -(iota + 1)
    Ident
    Int
    // ...
)
```

## 5. Variable Comments

Key points:
- Similar rules to constant comments
- Explain the variable's purpose

Example:
```go
// ErrInvalid indicates an invalid argument.
// A nil value for this error indicates a valid argument.
var ErrInvalid = errors.New("invalid argument")
```

## 6. General Formatting

Key points:
- Use complete sentences
- Start with a capital letter
- End with a period
- Use blank lines to separate paragraphs
- Indent code blocks
- Use Markdown-style link syntax]]

local python_comment_prompt = [[# Python Comment Writing Guide

## 1. Module Docstrings

Key points:
- Place at the beginning of the file
- Briefly describe the module's purpose
- May include usage examples or important API overview

Example:
```python
"""
This module provides utility functions for handling file operations.

It includes functions for reading, writing, and manipulating files
in various formats.
"""
```

## 2. Class Docstrings

Key points:
- Place immediately after the class definition
- Describe the class's purpose and behavior
- Mention important attributes and methods

Example:
```python
class FileHandler:
    """
    A class for handling file operations.

    This class provides methods for reading, writing, and
    manipulating files in various formats.

    Attributes:
        file_path (str): The path to the file being handled.
    """
```

## 3. Function/Method Docstrings

Key points:
- Use triple quotes """
- Describe what the function does
- Document parameters, return values, and raised exceptions
- Use Google-style, reST, or NumPy-style formatting

Example (Google-style):
```python
def read_csv(file_path: str, delimiter: str = ',') -> List[Dict]:
    """
    Read a CSV file and return its contents as a list of dictionaries.

    Args:
        file_path (str): The path to the CSV file.
        delimiter (str, optional): The delimiter used in the CSV. Defaults to ','.

    Returns:
        List[Dict]: A list of dictionaries, where each dictionary represents a row in the CSV.

    Raises:
        FileNotFoundError: If the specified file does not exist.
        ValueError: If the CSV is empty or improperly formatted.
    """
```

## 4. Inline Comments

Key points:
- Use sparingly, only when necessary
- Explain complex logic or non-obvious reasons for code
- Place on the same line as the code or just above it

Example:
```python
x = x + 1  # Compensate for zero-indexing
```

## 5. TODO Comments

Key points:
- Use to indicate planned changes or improvements
- Include "TODO" in all caps
- Optionally include the author's name or initials

Example:
```python
# TODO(JohnD): Implement error handling for network failures
```

## 6. General Guidelines

Key points:
- Follow PEP 8 style guide for comments
- Keep comments up-to-date with code changes
- Write clear, concise comments in English
- Use complete sentences, starting with a capital letter
- Limit line length to 72 characters for comments
- Use two spaces after a sentence-ending period in multi-sentence comments

## 7. Type Hinting

Key points:
- Use type hints in function signatures
- Can be combined with docstrings for clearer documentation

Example:
```python
def greet(name: str) -> str:
    """
    Return a greeting message for the given name.

    Args:
        name (str): The name to greet.

    Returns:
        str: A greeting message.
    """
    return f"Hello, {name}!"
```]]

local lua_comment_prompt = [=[
Lua Comment and Type Hint Guide (with LuaLS)

1. Basic Comments

Lua uses `--` for single-line comments and `--[[ ]]` for multi-line comments.

-- This is a single-line comment

--[[ 
    This is a
    multi-line comment
]]

2. Function Documentation

Use `---` to start a documentation comment. LuaLS recognizes these for type hints and documentation.

---This function adds two numbers
---@param a number The first number
---@param b number The second number
---@return number sum The sum of a and b
function add(a, b)
    return a + b
end

3. Type Hints for Variables

Use `---@type` to specify types for variables.

---@type string
local name = "John"

---@type number[]
local scores = {98, 95, 92}

4. Complex Types

LuaLS supports complex type definitions.

---@alias Point {x: number, y: number}

---@type Point
local point = {x = 10, y = 20}

---@type table<string, number>
local ages = {John = 30, Jane = 28}

5. Class-like Structures

For class-like tables, use `---@class` and `---@field`.

---@class Person
---@field name string
---@field age number
local Person = {}

function Person:new(name, age)
    local obj = {name = name, age = age}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

---@type Person
local john = Person:new("John", 30)

6. Function Overloading

LuaLS supports documenting function overloads.

---Prints a greeting
---@overload fun(name: string)
---@param name string
---@param age number
function greet(name, age)
    if age then
        print("Hello, " .. name .. "! You are " .. age .. " years old.")
    else
        print("Hello, " .. name .. "!")
    end
end

7. Generics

LuaLS supports generic type annotations.

---@generic T
---@param list T[]
---@param index number
---@return T
function getElement(list, index)
    return list[index]
end

8. Module Documentation

For documenting modules:

---@meta

---@class MyModule
local M = {}

---Adds two numbers
---@param a number
---@param b number
---@return number
function M.add(a, b)
    return a + b
end

return M

9. Enums

LuaLS supports enum-like structures:

---@enum Color
local Color = {
    RED = 1,
    GREEN = 2,
    BLUE = 3
}

Remember, these type hints are for documentation and tooling purposes. 
They don't affect the runtime behavior of Lua, which remains dynamically typed.
]=]

local bash_comment_prompt = [[# Bash Script Comment Guide

## 1. Shebang

Always start your Bash scripts with a shebang. This is not a comment, but it's crucial for script execution.

```bash
#!/bin/bash
```

## 2. Script Header Comment

Begin your script with a comment block describing its purpose, usage, and other important details.

```bash
#!/bin/bash

# Script Name: example_script.sh
# Description: This script demonstrates proper commenting in Bash
# Author: Your Name
# Date Created: YYYY-MM-DD
# Last Modified: YYYY-MM-DD

# Usage: ./example_script.sh [OPTIONS]
# Options:
#   -h, --help    Show this help message and exit
#   -v, --version Show version information and exit
```

## 3. Single-Line Comments

Use `#` for single-line comments.

```bash
# This is a single-line comment
echo "Hello, World!" # This is an inline comment
```

## 4. Multi-Line Comments

Bash doesn't have built-in multi-line comments, but you can use these workarounds:

```bash
: <<'END_COMMENT'
This is a
multi-line
comment
END_COMMENT

# Alternative method:
#
# This is also a
# multi-line comment
#
```

## 5. Function Comments

Document functions with a comment block above the function declaration.

```bash
# calculate_sum()
# 
# Calculates the sum of two numbers
#
# Arguments:
#   $1 - First number
#   $2 - Second number
#
# Returns:
#   The sum of the two numbers
calculate_sum() {
    echo $(($1 + $2))
}
```

## 6. Variable Comments

Comment on the purpose and usage of important variables.

```bash
# Maximum number of retries for the network operation
MAX_RETRIES=5

# User's home directory (default to current user if not specified)
USER_HOME=${USER_HOME:-$HOME}
```

## 7. Section Comments

Use comment blocks to separate major sections of your script.

```bash
#=====================
# Input Validation
#=====================

# ... input validation code here ...

#=====================
# Main Processing
#=====================

# ... main processing code here ...
```

## 8. TODO Comments

Mark areas that need future work or improvement.

```bash
# TODO: Implement error handling for network failures
# FIXME: This function is not efficient for large inputs
```

## 9. Debug Comments

Use comments to explain complex logic or temporary debugging code.

```bash
# DEBUG: Temporarily disable error exit for testing
# set +e

# The following line is complex, here's how it works:
# 1. curl fetches the webpage
# 2. grep extracts lines containing 'version'
# 3. sed removes HTML tags
# 4. sort orders the versions
# 5. tail -n 1 selects the last (latest) version
latest_version=$(curl -s "$URL" | grep 'version' | sed 's/<[^>]*>//g' | sort -V | tail -n 1)
```

## 10. Exit Codes

Comment on the meaning of exit codes, especially non-zero ones.

```bash
# Exit codes:
#   0: Success
#   1: Invalid arguments
#   2: File not found
#   3: Permission denied

# ... script logic ...

exit 0  # Success
```

Remember, good comments explain why something is done, not just what is being done. The code itself should be clear enough to show what is happening; comments should provide additional context or explanation where necessary.]]

local rust_comment_prompt = [[# Rust Comment and Documentation Guide

## 1. Regular Comments

### Single-line comments
Use `//` for single-line comments.

```rust
// This is a single-line comment
let x = 5; // This is an inline comment
```

### Multi-line comments
Use `/* */` for multi-line comments.

```rust
/* This is a multi-line comment.
   It can span several lines. */
```

## 2. Doc Comments

### Outer doc comments
Use `///` for outer doc comments. These are used to document the item that follows them.

```rust
/// Adds two numbers and returns the result.
///
/// # Examples
///
/// ```
/// let result = add(2, 3);
/// assert_eq!(result, 5);
/// ```
fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

### Inner doc comments
Use `//!` for inner doc comments. These are used to document the item that contains them.

```rust
//! This module contains utility functions for mathematical operations.

/// Adds two numbers and returns the result.
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

## 3. Documentation Attributes

Use `#[doc = "..."]` for adding documentation programmatically.

```rust
#[doc = "This function multiplies two numbers."]
fn multiply(a: i32, b: i32) -> i32 {
    a * b
}
```

## 4. Module-level documentation

Use `//!` at the beginning of a module file to provide module-level documentation.

```rust
//! # My Math Module
//!
//! This module provides basic mathematical operations.

/// Adds two numbers.
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

/// Subtracts two numbers.
pub fn subtract(a: i32, b: i32) -> i32 {
    a - b
}
```

## 5. Documenting Macros

Use `#[macro_export]` and `///` to document macros.

```rust
/// Creates a vector containing the given elements.
///
/// # Examples
///
/// ```
/// let v = vec![1, 2, 3];
/// assert_eq!(v, [1, 2, 3]);
/// ```
#[macro_export]
macro_rules! vec {
    ( $( $x:expr ),* ) => {
        {
            let mut temp_vec = Vec::new();
            $(
                temp_vec.push($x);
            )*
            temp_vec
        }
    };
}
```

## 6. Documentation Best Practices

### Include examples
Use triple backticks ``` to include runnable examples in your documentation.

```rust
/// Divides two numbers.
///
/// # Examples
///
/// ```
/// let result = divide(10, 2);
/// assert_eq!(result, 5);
/// ```
///
/// # Panics
///
/// This function will panic if the divisor is zero.
///
/// ```should_panic
/// divide(10, 0);
/// ```
fn divide(a: i32, b: i32) -> i32 {
    if b == 0 {
        panic!("Cannot divide by zero");
    }
    a / b
}
```

### Document panics and errors
Use `# Panics` and `# Errors` sections to document when your function can panic or return an error.

### Use markdown
Rust doc comments support Markdown for rich formatting.

```rust
/// # Safety
///
/// This function is unsafe because it dereferences a raw pointer.
/// The caller must ensure that the pointer is valid.
unsafe fn dangerous_function(ptr: *mut i32) {
    *ptr = 42;
}
```

### Link to other items
Use square brackets to link to other items in your documentation.

```rust
/// See also: [`std::vec::Vec`]
pub struct MyVec<T> {
    // fields...
}
```

## 7. Documentation Tests

Doc-tests are run by default when you run `cargo test`. Ensure your examples are correct and up-to-date.

```rust
/// ```
/// let x = 5;
/// assert_eq!(x, 5);
/// ```
fn documented_function() {
    // Function implementation...
}
```

Remember, good documentation is crucial for the usability of your code. Rust's documentation system is powerful and allows you to create comprehensive, testable documentation directly in your source code.]]

local prompts = {
  go = go_comment_prompt,
  python = python_comment_prompt,
  lua = lua_comment_prompt,
  bash = bash_comment_prompt,
  rust = rust_comment_prompt,
}

return {
  comment_prompts = prompts,
}
