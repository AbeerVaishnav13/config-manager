# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A personal macOS development environment configuration repository (dotfiles). It manages configurations for:
- **LunarVim** (`lvim/`) — primary editor, the most complex part of this repo
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

Navigation keys are remapped for ergonomic comfort (easier to press than vim defaults). The critical remapping in LunarVim:

| Key | Action (instead of default) |
|-----|----------------------------|
| `i` | Move up (was `k`) |
| `k` | Move down (was `j`) |
| `j` | Move left (was `h`) |
| `u` | Enter insert mode (was `i`) |
| `h` | Undo (was `u`) |

When editing keymaps, always preserve this layout. Do not "fix" these to standard vim bindings.

## LunarVim Architecture (`lvim/`)

`config.lua` is the entry point — it sources all modules via a `reload()` utility from `lua/utils.lua`.

| Module | Purpose |
|--------|---------|
| `lua/user-opts.lua` | Editor settings: colorscheme (Catppuccin Mocha), tabs, transparency |
| `lua/keymaps.lua` | All custom keybindings; graphite-layout remaps |
| `lua/plugin-opts.lua` | Plugin configuration (surround, neogen, treesitter, catppuccin, icon-picker) |
| `lua/lsp-config.lua` | LSP setup for Python, Rust, Lua |
| `lua/lsp-handlers.lua` | Custom LSP diagnostic/hover handlers |
| `lua/autocmds.lua` | Autocommands and event hooks |
| `lua/utils.lua` | Buffer/window helpers, cht.sh integration, transparency toggle |
| `lua/jupyter_tools.lua` | IPython/Jupyter cell execution via Wezterm panes, matplotlib via itermplot |

## Fish Shell (`fish/config.fish`)

- Vi key bindings are enabled globally
- `cat` → `bat`, `ls`/`ll`/`la` → `eza` variants
- Git abbreviations: `ga`, `gb`, `gd`, `gp`, `gst`, etc.
- Custom prompt shows: git branch, conda/venv env, vim mode indicator
- PATH includes: Homebrew, LLVM, Mason (for LunarVim), TeX

## Consistency Rules

- **Color scheme**: Catppuccin Mocha everywhere (LunarVim, Alacritty, Wezterm, btop)
- **Vi mode**: Enabled in Fish shell and all terminal tools
- **Rust CLI tools**: Prefer over GNU equivalents (`bat` over `cat`, `eza` over `ls`, `fd` over `find`, `ripgrep` over `grep`)
