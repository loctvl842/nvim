# Jordan's Neovim Configuration

A heavily customized LazyVim-based Neovim configuration with extensive AI integration, VSCode compatibility, and custom utilities.

![nvim-1](https://user-images.githubusercontent.com/80513079/216895409-4d7b246c-d7da-4f9e-8680-8f6b60ffa201.png)

## 🏗️ Architecture Overview

This configuration is built on LazyVim with significant customizations, following a modular, well-organized structure:

```
init.lua → core.lazy → {core modules + plugins}
```

### Entry Point & Bootstrap

- **`init.lua`**: Simple entry point requiring `core.lazy`
- **`core/lazy.lua`**: Main bootstrap setting up Lazy.nvim package manager
- **Global Utility**: `_G.CoreUtil` loaded globally from `util` module

## 📁 Directory Structure

```
~/.config/nvim/
├── init.lua                           # Entry point
├── lua/
│   ├── core/                          # Core configuration
│   │   ├── lazy.lua                   # Lazy.nvim setup & plugin imports
│   │   ├── settings.lua               # Global utils & deferred loading
│   │   ├── options.lua                # Vim options & settings
│   │   ├── keymaps.lua               # Base keymaps
│   │   ├── autocmds.lua              # Auto-commands & file-type settings
│   │   ├── icons.lua                 # Centralized icon definitions
│   │   └── vscode.lua                # VSCode-Neovim compatibility
│   ├── plugins/                      # Plugin configurations
│   │   ├── init.lua                  # Core plugins (snacks.nvim)
│   │   ├── ui.lua                    # UI enhancements
│   │   ├── editor.lua                # Editor functionality
│   │   ├── coding.lua                # Coding tools
│   │   ├── lsp/                      # LSP configuration
│   │   │   ├── init.lua              # Main LSP setup
│   │   │   └── keymaps.lua           # LSP keymaps
│   │   └── extras/                   # Additional plugins by category
│   │       ├── coding/               # AI, completion, snippets
│   │       ├── editor/               # Navigation, markdown, etc.
│   │       ├── formatting/           # Code formatting
│   │       ├── lang/                 # Language-specific configs
│   │       ├── linting/              # Code linting
│   │       ├── test/                 # Testing frameworks
│   │       └── util/                 # Utility plugins
│   └── util/                         # Custom utility modules
│       ├── init.lua                  # Main utility module
│       ├── format.lua               # Custom formatting system
│       ├── lsp.lua                  # Enhanced LSP utilities
│       ├── root.lua                 # Project root detection
│       ├── cmp.lua                  # Completion utilities
│       ├── lualine.lua              # Custom statusline
│       ├── session.lua              # Session management
│       ├── telescope.lua            # Telescope customizations
│       ├── ui.lua                   # UI helpers
│       ├── pick.lua                 # Picker utilities
│       └── toggle.lua               # Feature toggles
└── lazy-lock.json                    # Plugin version lock
```

## 🔧 Plugin Categories & Key Features

### Core Plugins

- **Snacks.nvim**: Multi-purpose plugin providing notifications, terminal, toggles, debug tools

### UI & Interface

- **Custom Lualine**: Complete reimplementation with Catppuccin theming, bubble separators
- **Bufferline**: Tabbed buffer management with Snacks integration
- **Dashboard**: Startup screen with project navigation
- **Noice**: Enhanced UI for messages, cmdline, popups
- **Mini.icons**: Modern icon set with nvim-web-devicons compatibility
- **Colorizer**: Live color preview in code
- **Scrollbar**: Visual scrollbar with git integration

### Editor Enhancement

- **Neo-tree**: File explorer with multi-source support (files, git, buffers, diagnostics)
- **Flash**: Enhanced navigation and jumping
- **Which-key**: Keymap discovery with organized groups
- **Trouble**: Better diagnostics, quickfix, and symbol navigation
- **Gitsigns**: Git change indicators and hunk operations
- **Todo-comments**: Comment highlighting and navigation
- **Grug-far**: Search and replace across files

### AI Integration (Primary Focus)

- **Sidekick.nvim**: Active AI assistant with CLI integration
  - Next Edit Suggestions (NES) with Copilot LSP
  - Multi-tool support with selection interface
  - Snacks picker integration
- **Copilot**: GitHub Copilot integration via LSP server
- **Claude Code**: Commented out (previously active)

### LSP & Completion

- **Mason**: LSP server, formatter, and linter management
- **nvim-lspconfig**: Core LSP setup with extensive customization
- **Blink.cmp**: Modern completion engine
  - Native snippet support
  - AI completion integration
  - Enhanced snippet handling

### Language Support

- **Treesitter**: Syntax highlighting and text objects
- **Language-specific configs**: Go, TypeScript, Java, Ruby, Terraform, Nix, etc.

## 🛠️ Custom Utilities Deep Dive

### CoreUtil Module (`util/init.lua`)

Central utility module with lazy-loading and LazyUtil integration:

- Plugin management utilities (`has`, `get_plugin`, `opts`)
- Lazy loading helpers (`on_load`, `on_very_lazy`)
- Safe keymap setting to avoid conflicts
- Mason package path utilities
- Notification wrapper with custom titles

### Formatting System (`util/format.lua`)

Sophisticated formatting architecture:

- Multiple formatter registration and priority system
- Per-buffer and global format toggling
- Formatter resolution with conflict handling
- Integration with LSP and external formatters (conform.nvim)

### LSP Utilities (`util/lsp.lua`)

Enhanced LSP capabilities:

- Dynamic capability detection and registration
- Method support tracking with autocmds
- Custom formatter integration
- Client filtering and management
- LSP action shortcuts

### Root Detection (`util/root.lua`)

Intelligent project root detection:

- Multi-strategy detection: LSP workspace, git, file patterns, cwd
- Caching for performance
- Buffer-specific root resolution
- Git root fallback

### Lualine Customization (`util/lualine.lua`)

Complete statusline reimplementation:

- Catppuccin Macchiato color integration
- Mode-based dynamic coloring
- Custom components: project name, file type, git branch, location, diagnostics, LSP status
- Bubble separators with floating design
- Responsive truncation for narrow windows

### Completion Utilities (`util/cmp.lua`)

Advanced completion features:

- Native snippet support with error handling
- Snippet preview and fixing
- Auto-bracket insertion for functions
- Missing documentation generation
- Confirmation with undo point creation

## 🎯 Key Features & Innovations

### VSCode Integration

Comprehensive VSCode-Neovim compatibility layer (`core/vscode.lua`):

- Full keymap translation maintaining LazyVim-like bindings
- Plugin filtering for VSCode environment
- Action wrappers for VSCode commands
- Organized keymaps by category (AI, buffer, code, debug, file, git, etc.)

### Smart Project Management

- Multi-strategy root detection (LSP workspace > git > patterns > cwd)
- Project-based sessions with auto-save/restore
- Dashboard integration with recent projects
- Root-aware terminal and file operations

### AI Workflow Integration

- Sidekick as primary AI with NES (Next Edit Suggestions)
- Tab completion that cycles through: snippets → AI suggestions → fallback
- Visual selection sending to AI tools
- File and project context integration

### Performance Optimizations

- Lazy loading with careful event management
- Memoized utility functions with weak references
- Efficient plugin loading strategies
- VSCode-specific plugin filtering
- Deferred loading of non-essential components

## ⚙️ Configuration Highlights

### Global Settings

```lua
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.autoformat = true
vim.g.ai_cmp = true  -- Use AI in completion when available
vim.g.root_spec = { { ".git", "lua" }, "lsp", "cwd" }
```

### Key Keymaps

- **Leader**: `<Space>`
- **AI**: `<leader>a*` - Sidekick integration
- **Files**: `<leader>f*` - File operations
- **Git**: `<leader>g*` - Git operations
- **Code**: `<leader>c*` - LSP and code actions
- **Buffers**: `<leader>b*` - Buffer management
- **UI**: `<leader>u*` - UI toggles
- **Terminal**: `<C-/>` - Floating terminal

### Recent Changes (Git Status)

- **Modified**: lazy-lock.json, editor.lua, copilot.lua, formatting.lua, lsp/init.lua, util/lsp.lua
- **Deleted**: avante.lua, copilot-chat.lua, goose.lua (consolidated to Sidekick)
- **New**: claude.lua (commented), sidekick.lua (active)

## 🚀 Standout Aspects

1. **Modular Architecture**: Excellent separation of concerns with utility modules
2. **VSCode Compatibility**: Rare full-featured VSCode-Neovim integration
3. **Custom Lualine**: Beautiful, performant statusline with dynamic theming
4. **AI-First Workflow**: Modern AI integration with fallback options
5. **Smart Root Detection**: Sophisticated project management
6. **Flexible Formatting**: Multi-formatter architecture with priority system
7. **Performance Focus**: Lazy loading and efficient resource management
8. **Type Safety**: Extensive use of LSP annotations for better development experience

## 🔄 Development Workflow

This configuration is optimized for:

- **Multi-language development** with LSP support
- **AI-assisted coding** with Sidekick and Copilot
- **Git-centric workflows** with visual indicators and hunk operations
- **Project-based work** with intelligent root detection
- **Cross-editor compatibility** with VSCode integration
- **Performance-conscious usage** with lazy loading and caching

## 📊 Statistics

- **52 Lua files** with modular organization
- **Heavy LazyVim customization** with maintained compatibility
- **Active AI tooling** migration to modern solutions
- **Comprehensive utility layer** for enhanced functionality

---

*This configuration represents a mature, well-architected Neovim setup balancing functionality, performance, and maintainability while providing extensive customization beyond typical LazyVim installations.*

