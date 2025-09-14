# 🦁 BeastVim

_My Beast_

> **Neovim version:** Requires **v0.11.0** or higher

> ⚠️ **Warning:** This configuration is for personal use and evolves frequently. It references a lot from [LazyVim](https://www.lazyvim.org/), which is a better option for those starting out. Proceed with caution if you're looking for a more stable setup.

![image](https://github.com/loctvl842/tvl-library/assets/80513079/3771ae81-50bf-4b6a-8b5c-a9ec44bc6e6f)

## 🛠️ Prerequisites

Before setting up this Neovim configuration, ensure that the following dependencies are installed on your system:

- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [xclip](https://github.com/astrand/xclip)
- [unzip](https://linux.die.net/man/1/unzip) (Required for installing language packs)
- [npm (node)](https://www.npmjs.com/get-npm)
- [pass](https://www.passwordstore.org/)
- fzf
- cmake
- jq

## Tools

Image Previews for pickers

- viu (for MacOS)
- ueberzug (for Linux)

## Installation

Running the following script if you want to install Neovim at a specific version:

```sh
~/.config/nvim/install-nvim.sh
```

### ⚙️ Terminal

This Neovim configuration is designed to work seamlessly with the [Kitty terminal emulator](https://sw.kovidgoyal.net/kitty/). For optimal visual results, it is recommended to use the Nerd Font with fixed underline. Add the following configuration to your Kitty terminal settings:

```conf
modify_font                     strikethrough_position 130%
modify_font                     strikethrough_thickness 0.1px
modify_font                     underline_position 150%
modify_font                     underline_thickness 0.1px
modify_font                     cell_height 305%
```

## 🆚 VSCode Integration

This configuration includes full VSCode integration via the [vscode-neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim) extension, allowing you to use your Neovim setup within VSCode.

### Setup VSCode-Neovim

1. **Install the Extension**
   ```
   https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim
   ```

2. **VSCode Settings** - Add to your `settings.json`:
   ```json
   {
     "vscode-neovim.neovimInitVimPaths.darwin": "/Users/loctvl842/.config/nvim/init.lua",
     "vscode-neovim.compositeKeys": {
       "jk": { "command": "vscode-neovim.escape" },
       "Jk": { "command": "vscode-neovim.escape" },
       "jK": { "command": "vscode-neovim.escape" }
     },
     "editor.minimap.enabled": false,
     "editor.fontSize": 13,
     "editor.fontFamily": "'JetBrainsMono Nerd Font', Menlo, Monaco, 'Courier New', monospace",
     "editor.fontLigatures": true,
     "terminal.integrated.fontFamily": "JetBrainsMono Nerd Font",
     "workbench.colorTheme": "Monokai Pro"
   }
   ```

3. **MacOS Key Repeat Fix**
   ```sh
   defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
   ```

### VSCode Keymaps

| Category | Keymap | Action |
|----------|---------|--------|
| **Search & Navigation** | `<leader>f` | Find files |
| | `<leader>F` | Find in files (global search) |
| | `<leader>b` | Show open buffers |
| | `<leader>e` | Focus file explorer |
| | `<leader>E` | Toggle sidebar |
| **Splits & Windows** | `<leader>/` | Split horizontally |
| | `<leader>\` | Split vertically |
| | `<leader>z` | Toggle maximize editor group |
| **LSP & Diagnostics** | `gd` | Go to definition |
| | `gD` | Go to declaration |
| | `gr` | Go to references |
| | `gl` | Show hover info |
| | `]d` | Next diagnostic |
| | `[d` | Previous diagnostic |
| **Git Integration** | `]c` / `[c` | Navigate git hunks |
| | `<leader>gs` | Stage hunk |
| | `<leader>gr` | Revert hunk |
| | `<leader>gp` | Preview hunk |
| | `<leader>gb` | Toggle git blame |
| **File Operations** | `<leader>w` | Save file |
| | `<leader>W` | Format and save |
| | `<leader>d` | Close current editor |
| | `<leader>q` | Close editor group |
| **Folding** | `fa` | Toggle fold |
| | `fm` | Fold all |
| | `fr` | Unfold all |
| **Terminal** | `<leader>tt` | Toggle terminal |
| | `<leader>tn` | New terminal |

### Enabled Plugins for VSCode

The VSCode integration automatically enables only compatible plugins:
- **Core**: lazy.nvim, snacks.nvim, plenary.nvim
- **Text Editing**: nvim-treesitter, nvim-ts-autotag
- **UI Plugins**: Disabled (VSCode handles the UI)
