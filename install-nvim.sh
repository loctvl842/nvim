#!/bin/sh

# Define variables
NEOVIM_REPO="neovim/neovim"
NEOVIM_INSTALL_DIR="$HOME/.config/nvim/neovim"

# Fetch Neovim releases using curl and parse JSON with jq
RELEASES=$(curl -s "https://api.github.com/repos/$NEOVIM_REPO/releases" | jq -r '.[].tag_name')

# Display releases using fzf for interactive selection
echo "Select a Neovim release:"
SELECTED_RELEASE=$(echo "$RELEASES" | fzf --reverse)

# Fetch the commit associated with the selected release
NEOVIM_COMMIT_HASH=$(curl -s "https://api.github.com/repos/$NEOVIM_REPO/releases/tags/$SELECTED_RELEASE" | jq -r '.target_commitish')

# Clone Neovim repository
git clone "https://github.com/$NEOVIM_REPO" "$NEOVIM_INSTALL_DIR"

# Move to Neovim directory
cd "$NEOVIM_INSTALL_DIR" || return

# Reset to the specified commit
git reset --hard "$NEOVIM_COMMIT_HASH"

# Remove existing Neovim installation (if any)
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/

# Build and install Neovim with RelWithDebInfo
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

# Clean up: Remove the cloned repository
rm -rf "$NEOVIM_INSTALL_DIR"

# Additional features
echo "Neovim (commit hash $NEOVIM_COMMIT_HASH) from release $SELECTED_RELEASE has been successfully built and installed!"

# Check Neovim version
neovim_version=$(nvim --version | head -n 1)
echo "Installed Neovim version: $neovim_version"
