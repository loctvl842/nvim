#!/bin/sh

# Define variables
NEOVIM_REPO="neovim/neovim"
NEOVIM_INSTALL_DIR="$HOME/.config/nvim/neovim"

# Fetch Neovim releases using curl and parse JSON with jq
RELEASES=$(curl -s "https://api.github.com/repos/$NEOVIM_REPO/releases" | jq -r '.[].tag_name')

# Fallback if API returns nothing (rate limited or error)
if [ -z "$RELEASES" ]; then
    echo "⚠️ Failed to fetch releases (possibly rate-limited). Falling back to 'stable'..."
    SELECTED_RELEASE="stable"
else
    # Display releases using fzf for interactive selection
    echo "Select a Neovim release:"
    SELECTED_RELEASE=$(echo "$RELEASES" | fzf --reverse)

    # If user cancels fzf, fallback to stable
    if [ -z "$SELECTED_RELEASE" ]; then
        echo "⚠️ No selection made. Falling back to 'stable'..."
        SELECTED_RELEASE="stable"
    fi
fi

# Fetch the actual commit SHA associated with the selected release tag
# This gets the actual release commit, not just the branch it was created from
NEOVIM_COMMIT_HASH=$(curl -s "https://api.github.com/repos/$NEOVIM_REPO/git/refs/tags/$SELECTED_RELEASE" | jq -r '.object.sha')

# Allow the user to select build type
echo "Select build type:"
BUILD_TYPES="RelWithDebInfo\nRelease\nDebug"
SELECTED_BUILD_TYPE=$(echo -e "$BUILD_TYPES" | fzf --reverse)

# Ask if user wants to keep the source directory for debugging
echo "Keep source directory for debugging? (y/n)"
read -r KEEP_SOURCE
KEEP_SOURCE=$(echo "$KEEP_SOURCE" | tr '[:upper:]' '[:lower:]')

# Create the installation directory if it doesn't exist
mkdir -p "$NEOVIM_INSTALL_DIR"

# Clone Neovim repository
git clone "https://github.com/$NEOVIM_REPO" "$NEOVIM_INSTALL_DIR"

# Move to Neovim directory
cd "$NEOVIM_INSTALL_DIR" || exit 1

# Reset to the specified commit
git reset --hard "$NEOVIM_COMMIT_HASH"

# Remove existing Neovim installation (if any)
sudo rm -f /usr/local/bin/nvim
sudo rm -rf /usr/local/share/nvim/

# Build and install Neovim with the selected build type
echo "Building Neovim with CMAKE_BUILD_TYPE=$SELECTED_BUILD_TYPE..."
make CMAKE_BUILD_TYPE="$SELECTED_BUILD_TYPE"
sudo make install

# Check if the installation was successful
if [ $? -eq 0 ]; then
    echo "Neovim (commit hash $NEOVIM_COMMIT_HASH) from release $SELECTED_RELEASE has been successfully built and installed!"
    
    # Check for debug symbols
    echo "Checking debug symbols:"
    if file /usr/local/bin/nvim | grep -q "not stripped"; then
        echo "✅ Debug symbols present"
    else
        echo "⚠️ Debug symbols missing"
    fi
    
    # Check Neovim version
    neovim_version=$(nvim --version | head -n 1)
    echo "Installed Neovim version: $neovim_version"
    
    # Clean up based on user choice
    if [ "$KEEP_SOURCE" != "y" ]; then
        echo "Removing source directory..."
        cd "$HOME" || exit 1
        rm -rf "$NEOVIM_INSTALL_DIR"
        echo "Source directory removed."
    else
        echo "Source directory kept at: $NEOVIM_INSTALL_DIR"
        echo "You can use this for debugging purposes."
    fi
else
    echo "❌ Neovim installation failed!"
    echo "The source directory has been kept at: $NEOVIM_INSTALL_DIR for troubleshooting."
fi
