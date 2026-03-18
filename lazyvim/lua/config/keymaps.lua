-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local utils = require("utils")
local map = vim.keymap.set

-- Custom ergonomic nav remaps
map({ "n", "v" }, "i", "k", { desc = "Move up" })
map({ "n", "v" }, "k", "j", { desc = "Move down" })
map({ "n", "v" }, "j", "h", { desc = "Move left" })
map("n", "u", "i", { desc = "Insert mode" })
map("n", "U", "u", { desc = "Undo" })
map("n", "H", "mzJ`z", { desc = "Join with next line" })

-- Handle visual line wrapping for k/i
map({ "n", "v" }, "k", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
map({ "n", "v" }, "i", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

-- Window navigation (remapped for custom nav keys)
map("n", "<C-i>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-k>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-j>", "<C-w>h", { desc = "Go to left window" })

-- Window resizing
map("n", "<C-w>.", "<C-w>>", { desc = "Increase window width" })
map("n", "<C-w>,", "<C-w><", { desc = "Decrease window width" })
map("n", "<C-w>=", "<C-w>+", { desc = "Increase window height" })
map("n", "<C-w>+", "<C-w>=", { desc = "Equalize all windows" })
map("n", "<C-w><C-v>", "<C-w>t<C-w>H", { desc = "Switch to vertical alignment" })
map("n", "<C-w><C-h>", "<C-w>t<C-w>K", { desc = "Switch to horizontal alignment" })

-- Escape & clear highlight
map({ "n", "v", "i" }, "<C-c>", "<Esc><cmd>noh<cr>", { desc = "Normal mode (no-highlight)" })

-- Command mode swap
map({ "n", "v" }, ";", ":", { desc = "Command mode" })
map({ "n", "v" }, ":", ";", { desc = "Repeat last find" })

-- Write
map("n", "W", "<cmd>w<cr>", { desc = "Write file" })

-- Quit
map({ "n", "v" }, "Q", utils.buf_close_or_quit, { desc = "Close buffer or quit" })

-- Search & Replace
map("n", "S", ":%s///gI<left><left><left><left>", { desc = "Search & Replace" })
-- stylua: ignore
map("n", "R", [[:%s/\<<C-r><C-w>\>//gI<left><left><left>]], { desc = "Search & Replace (cursor word)" })
-- stylua: ignore
map("v", "R", [["1y:%s/<C-r>1//gI<left><left><left>]], { desc = "Search & Replace (visual select)" })

-- Keep cursor centered with motions
map("n", "<C-d>", "<C-d>zz", { desc = "Page-Down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page-Up" })
map("n", "n", "nzz", { desc = "Next search result" })
map("n", "N", "Nzz", { desc = "Prev search result" })

-- Paste without copying in visual mode
map("x", "p", '"_dP', { desc = "Paste w/o copying visual selection" })

-- LSP
map("n", "<leader>kk", vim.lsp.buf.hover, { desc = "Show Documentation" })
map("n", "gt", vim.lsp.buf.type_definition, { desc = "Goto type definition" })

-- Buffer cycling
map("n", "L", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "J", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })

-- Terminal
map("n", "T", "<cmd>vsplit<cr><cmd>term fish<cr>A", { desc = "Open terminal in vsplit" })
map("t", "SQ", function() utils.buf_close_or_quit("!") end, { desc = "Force close terminal" })

-- Snacks
map("n", "<leader>lb", function() Snacks.picker.buffers() end, { desc = "List buffers" })
map("n", "<leader>lg", function() Snacks.lazygit() end, { desc = "Lazygit" })

-- Utility
map("n", "<leader>fp", function() print(utils.get_curr_filename(true)) end, { desc = "Print filename" })
map("n", "<leader>cs", utils.cht_sh_search, { desc = "Cht.sh search" })
map("n", "<leader>ss", utils.save_and_source, { desc = "Save and source" })
