# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## What This Repo Is

A personal macOS development environment configuration repository (dotfiles). It manages configurations for:
- **LazyVim** (`lazyvim/`) — primary editor (Neovim with LazyVim distribution)
- **Fish shell** (`fish/`) — shell with custom prompt, aliases, and vi-mode keybindings
- **Wezterm** (`wezterm/`) — terminal emulator with Lua config
- **Zellij** (`zellij/`) — terminal multiplexer
- **Other tools**: bat, btop, lazygit, helix, alacritty

## Installation / Uninstallation

```bash
# Install everything (Homebrew + all packages + symlinks)
zsh install-pkgconfigs.zsh

# Uninstall
zsh uninstall.zsh
```

There are no build, test, or lint commands — this is a configuration-only repo.

## Key Layout

Navigation keys are remapped for ergonomic comfort (easier to press than vim defaults). The critical remapping in LazyVim:

| Key | Action (instead of default) |
|-----|----------------------------|
| `i` | Move up (was `k`) |
| `k` | Move down (was `j`) |
| `j` | Move left (was `h`) |
| `u` | Enter insert mode (was `i`) |
| `h` | Undo (was `u`) |

When editing keymaps, always preserve this layout. Do not "fix" these to standard vim bindings.

## LazyVim Architecture (`lazyvim/`)

Uses the standard LazyVim directory structure. Launched via `NVIM_APPNAME=lazyvim nvim`.

| Module | Purpose |
|--------|---------|
| `lua/config/options.lua` | Editor settings: tabs, scrolloff, colorcolumn |
| `lua/config/keymaps.lua` | All custom keybindings; ergonomic nav remaps |
| `lua/config/autocmds.lua` | Autocommands: markdown settings, pandoc, rename-with-qflist |
| `lua/plugins/` | Plugin specs: colorscheme, editor, LSP, treesitter, formatting, UI |
| `lua/utils.lua` | Buffer/window helpers, cht.sh integration, markdown template |
| `lua/lsp-handlers.lua` | Custom LSP rename handler with quickfix list |

## Fish Shell (`fish/config.fish`)

- Vi key bindings are enabled globally
- `cat` → `bat`, `ls`/`ll`/`la` → `eza` variants
- Git abbreviations: `ga`, `gb`, `gd`, `gp`, `gst`, etc.
- Custom prompt shows: git branch, conda/venv env, vim mode indicator
- PATH includes: Homebrew, LLVM, Mason (for LazyVim), TeX

## Consistency Rules

- **Color scheme**: Catppuccin Mocha everywhere (LazyVim, Alacritty, Wezterm, btop)
- **Vi mode**: Enabled in Fish shell and all terminal tools
- **Rust CLI tools**: Prefer over GNU equivalents (`bat` over `cat`, `eza` over `ls`, `fd` over `find`, `ripgrep` over `grep`)
