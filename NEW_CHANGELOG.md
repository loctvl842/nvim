# Changelog

All notable changes to BeastVim will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Initial BeastVim configuration structure
- Core module system with `beastvim` namespace
- Lazy.nvim plugin manager integration
- Plugin system with modular imports from `beastvim.plugins`
- Comprehensive configuration system with modular loading
- Utility module with comprehensive helper functions
- Error handling system with `M.error`, `M.warn` and `M.info` functions
- Notification system with `M.notify` and `M.lazy_notify`
- Safe function execution with `M.try` wrapper
- Safe keymap setting with `M.safe_keymap_set`
- Complete options configuration with Neovim settings
- Extensive keymap system with categorized bindings
- Window navigation and management keymaps
- Buffer navigation and management
- Text manipulation and movement commands
- Search and highlight management
- Split window functionality
- Scrolling and cursor movement enhancements
- Snippet navigation support (for Neovim < 0.11)
- Fuzzy search integration with Telescope
- **LSP (Language Server Protocol) system with Mason integration**
- **Auto-completion engine with Blink.cmp**
- **Lua Language Server with advanced configuration**
- **LSP client utilities and helper functions**
- **Dynamic LSP capability detection and management**
- **Comprehensive LSP keymaps for code navigation and actions**
- **Mason package management utilities**
- **LSP features: diagnostics, code lens, inlay hints, UI enhancements**
- **Snippet expansion and management system**
- **Auto-completion with LSP, path, buffer, and snippet sources**
- **Command-line completion support**
- **Intelligent completion menu with custom icons and formatting**
- **Native snippet support with forward/backward navigation**
- **Completion preview and documentation**
- **Custom icon system for diagnostics, git, mason, and completion kinds**
- Monokai Pro colorscheme support with fallback
- Automatic lazy loading for plugins
- Semver version management for plugins
- Custom UI icons for plugin manager
- Metatable-based module loading system
- LazyUtil integration for extended functionality

### Changed

- Set up lazy loading as default for all plugins
- Disabled automatic config change detection
- Disabled plugin update checker notifications
- Configured mapleader as space and maplocalleader as backslash
- Set up comprehensive Neovim options for optimal editing experience
- Configured clipboard integration with system clipboard
- Set up folding with visual indicators
- Configured ripgrep as default grep program

### Infrastructure

- Created main entry point (`init.lua`)
- Established Lua module structure under `lua/beastvim/`
- Set up lazy.nvim bootstrapping and configuration
- Implemented utility module at `lua/beastvim/util/init.lua`
- Created configuration system at `lua/beastvim/config/`
- Added comprehensive options configuration (`options.lua`)
- Implemented extensive keymap system (`keymaps.lua`)
- **Built LSP feature system at `lua/beastvim/features/lsp/`**
- **Implemented LSP utilities (`util/lsp.lua`, `util/mason.lua`, `util/cmp.lua`)**
- **Created modular LSP configuration in `plugins/lsp.lua` and `plugins/coding.lua`**
- **Set up language-specific configurations in `plugins/lang/`**
- **Configured icon system at `config/icons.lua`**
- **Established completion and snippet management system**
- Set up modular config loading with event system
- Added type annotations and documentation
- Structured module imports with dynamic loading
- Configured autocommand system for delayed loading
