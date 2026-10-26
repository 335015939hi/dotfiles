-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "s", "cl", { desc = "Substitute character" })
-- Bash-style line navigation in Insert mode
vim.keymap.set("n", "<C-a>", "<Home>", { desc = "Beginning of line" })
vim.keymap.set("n", "<C-e>", "<End>", { desc = "End of line" })
vim.keymap.set("i", "<C-a>", "<Home>", { desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })
vim.keymap.set("v", "<C-a>", "<Home>", { desc = "Beginning of line" })
vim.keymap.set("v", "<C-e>", "<End>", { desc = "End of line" })
