-- Keymappings [view all by pressing <leader>sk]

-- Import util functions and LSP handlers
local utils = require("utils")
local lsp_handlers = require("lsp-handlers")

---- Leader keymap
lvim.leader = "space"
vim.g.mapleader = " "

-- Normal mode
---- global keymaps
lvim.keys.normal_mode["<C-c>"] = { "<esc><cmd>noh<cr>", { desc = "Normal mode (no-highlight)" } }
lvim.keys.normal_mode["W"] = { "<cmd>w<cr>", { desc = "Write file" } }
lvim.keys.normal_mode["U"] = { "u", { desc = "Undo" } }
lvim.keys.normal_mode["u"] = { "k", { desc = "Move up" } }
lvim.keys.normal_mode["k"] = { "l", { desc = "Move right" } }
lvim.keys.normal_mode["<c-w>k"] = { "<c-w>l" }
lvim.keys.normal_mode["<c-w>u"] = { "<c-w>k" }
lvim.keys.normal_mode["<c-k>"] = { "<c-l>" }
lvim.keys.normal_mode["<c-u>"] = { "<c-k>" }
lvim.keys.normal_mode["<c-w>."] = { "<c-w>>", { desc = "Increase window width" } }
lvim.keys.normal_mode["<c-w>,"] = { "<c-w><", { desc = "Decrease window width" } }
lvim.keys.normal_mode["<c-w>="] = { "<c-w>+", { desc = "Equalize all windows" } }
lvim.keys.normal_mode["<c-w>+"] = { "<c-w>=", { desc = "Increase window height" } }
lvim.keys.normal_mode["<c-w><c-v>"] = { "<c-w>t<c-w>H", { desc = "Switch to vertical window alignment" } }
lvim.keys.normal_mode["<c-w><c-h>"] = { "<c-w>t<c-w>K", { desc = "Switch to horizontal window alignment" } }
lvim.keys.normal_mode["K"] = { "<cmd>BufferLineCycleNext<cr>", { desc = "Switch to next buffer" } }
lvim.keys.normal_mode["H"] = { "<cmd>BufferLineCyclePrev<cr>", { desc = "Switch to prev buffer" } }
lvim.keys.normal_mode["T"] = { "<cmd>vsplit<cr><cmd>term fish<cr>A", { desc = "Open Terminal (vertical split)" } }
lvim.keys.normal_mode["<leader>lb"] = { "<cmd>Telescope buffers<cr>", { desc = "List buffers" } }
lvim.keys.normal_mode["<leader>lg"] =
	{ "<cmd>lua require('lvim.core.terminal').lazygit_toggle()<cr>", { desc = "Open LazyGit" } }

---- Search & Replace keymaps
vim.keymap.set("n", "S", ":%s///gI<left><left><left><left>", { desc = "Search & Replace" })
-- stylua: ignore
vim.keymap.set("n", "R", ":%s/\\<<c-r><c-w>\\>//gI<left><left><left>", { desc = "Search & Replace (cursor word)" })
-- stylua: ignore
vim.keymap.set( "v", "R", "\"1y:%s/<c-r>1//gI<left><left><left>", { desc = "Search & Replace (visual select)" })

---- LSP keymaps
lvim.lsp.buffer_mappings.normal_mode["<leader>kk"] = { vim.lsp.buf.hover, "Show Documentation" }
lvim.lsp.buffer_mappings.normal_mode["gt"] = { vim.lsp.buf.type_definition, "Goto type definition" }
lvim.lsp.buffer_mappings.normal_mode["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" }
lvim.lsp.buffer_mappings.normal_mode["[d"] = { vim.diagnostic.goto_prev, "Prev Diagnostic" }

---- Diable default LSP keymaps by LunarVim
lvim.lsp.buffer_mappings.normal_mode["K"] = nil
lvim.lsp.buffer_mappings.normal_mode["<leader>lj"] = nil
lvim.lsp.buffer_mappings.normal_mode["<leader>lk"] = nil

---- Disable the annoying mappings
lvim.builtin.which_key.mappings["c"] = nil
lvim.builtin.which_key.mappings["q"] = nil
lvim.builtin.which_key.mappings["g"]["g"] = nil
lvim.builtin.which_key.mappings["b"]["b"] = nil
lvim.builtin.which_key.mappings["b"]["n"] = nil

-- Visual mode
---- global keymaps
lvim.keys.visual_mode["<C-c>"] = { "<esc><cmd>noh<cr>", { desc = "Normal mode (no-highlight)" } }
lvim.keys.visual_mode["u"] = { "k", { desc = "Move up" } }
lvim.keys.visual_mode["k"] = { "l", { desc = "Move right" } }

-- Normal/Visual --> Command mode
---- global keymaps
vim.keymap.set({ "n", "v" }, ";", ":", { desc = "Command mode" })
vim.keymap.set({ "n", "v" }, ":", ";", { desc = "Repeat last find (f or t key)" })

-- Insert mode
---- global keymaps
lvim.keys.insert_mode["<C-c>"] = { "<esc><cmd>noh<cr>", { desc = "Normal mode (no-highlight)" } }

-- Modify the quitting functionality
vim.keymap.set({ "n", "v" }, "Q", utils.buf_close_or_quit, { desc = "Close Buffer or Quit" })
vim.keymap.set("t", "SQ", function()
	utils.buf_close_or_quit("!")
end, { silent = true, desc = "Close Buffer or Quit" })

-- Modify up/down for multiple visual lines
vim.keymap.set({ "n", "v" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
vim.keymap.set({ "n", "v" }, "u", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

-- Some extra keymaps (inspired from ThePrimagen)
---- Paste without copying new text
vim.keymap.set("x", "p", '"_dP', { desc = "Paste w/o copying visual selection" })

---- Keep cursor at same position with motions
lvim.keys.normal_mode["J"] = { "mzJ`z", { desc = "Join with next line" } }
lvim.keys.normal_mode["<c-d>"] = { "<c-d>zz", { desc = "Page-Down" } }
lvim.keys.normal_mode["<c-u>"] = { "<c-u>zz", { desc = "Page-Up" } }
lvim.keys.normal_mode["n"] = { "nzz", { desc = "Next search result" } }
lvim.keys.normal_mode["N"] = { "Nzz", { desc = "Prev search result" } }

-- Save and source the current lua file
vim.keymap.set("n", "<leader>ss", utils.save_and_source, { desc = "Save and source currfile" })

-- Cht.sh integration for queries
vim.keymap.set("n", "<leader>cs", utils.cht_sh_search, { desc = "Search Cht.sh" })

-- Change Alacritty transparency
vim.keymap.set("n", "<leader>ct", utils.set_transparency, { desc = "Set Alacritty transparency" })

-- Custom LSP handlers keymaps
local langs = {
	"*.py",
	"*.lua",
	"*.rs",
}
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = langs,
	callback = function()
		lvim.lsp.buffer_mappings.normal_mode["<leader>lr"] = { lsp_handlers.rename_with_qflist, "Rename with qflist" }
	end,
	group = vim.api.nvim_create_augroup("RenameWithQflist", { clear = true }),
})
