-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })

vim.api.nvim_set_hl(0, "CursorLine", {
  bg = normal.bg + 0x111111,
})

vim.cmd("colorscheme matugen")
vim.api.nvim_create_autocmd("Signal", {
  pattern = "SIGUSR1",
  command = "colorscheme matugen",
})

--vim.cmd([[
--    highlight Normal guibg=none ctermbg=none
--  highlight NormalNC guibg=none ctermbg=none
--  highlight LineNr guibg=none ctermbg=none
--  highlight SignColumn guibg=none ctermbg=none
--]])
