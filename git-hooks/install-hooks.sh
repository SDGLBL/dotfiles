#!/usr/bin/env bash

# Script to install the Git hooks

# Exit on error
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel)"
HOOK_TARGET_DIR="$REPO_ROOT/.git/hooks"

# Install Git hooks
echo "Installing Git hooks..."
mkdir -p "$HOOK_TARGET_DIR"

# Copy git hooks
for hook in "$SCRIPT_DIR"/*; do
  hook_name=$(basename "$hook")
  # Skip this script itself
  if [ "$hook_name" == "install-hooks.sh" ]; then
    continue
  fi
  cp "$hook" "$HOOK_TARGET_DIR/"
  chmod +x "$HOOK_TARGET_DIR/$hook_name"
  echo "Installed Git hook: $hook_name"
done

# Setup token password
echo "Setting up TOKEN_DECODE_PASSWORD..."
password="123456" # Default password

# Prompt user for a custom password
read -p "Enter a password for token encryption (default: 123456): " custom_password
if [ -n "$custom_password" ]; then
  password="$custom_password"
fi

# Add to .zshrc if it doesn't exist
if [ -f "$HOME/.zshrc" ]; then
  if ! grep -q "TOKEN_DECODE_PASSWORD" "$HOME/.zshrc"; then
    echo "export TOKEN_DECODE_PASSWORD=\"$password\"" >> "$HOME/.zshrc"
    echo "Added TOKEN_DECODE_PASSWORD to .zshrc"
  else
    echo "TOKEN_DECODE_PASSWORD already exists in .zshrc"
  fi
fi

# Setup .token.sh from template if it doesn't exist
if [ ! -f "$REPO_ROOT/.token.sh" ] && [ -f "$REPO_ROOT/.token.sh.template" ]; then
  cp "$REPO_ROOT/.token.sh.template" "$REPO_ROOT/.token.sh"
  chmod +x "$REPO_ROOT/.token.sh"
  echo "Created .token.sh from template"
fi

echo "Setup complete! Remember to source your .zshrc or open a new terminal window."