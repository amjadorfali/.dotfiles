#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

# Create symlinks for all dotfiles except .gitignore
for file in "$SCRIPT_DIR"/.*; do
    if [[ -f "$file" && "$(basename "$file")" != ".gitignore" && "$(basename "$file")" != "." && "$(basename "$file")" != ".." ]]; then
        ln -sf "$file" "$HOME_DIR/$(basename "$file")"
        echo "Linked $(basename "$file") to $HOME_DIR"
    fi
done

# Create .config directory if it doesn't exist
mkdir -p "$HOME_DIR/.config"

# Link nvim folder to ~/.config/nvim
ln -sf "$SCRIPT_DIR/nvim" "$HOME_DIR/.config/nvim"
echo "Linked nvim to $HOME_DIR/.config/nvim"

echo "All symlinks created successfully!" 