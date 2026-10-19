-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.cmd("colorscheme matugen")
vim.api.nvim_create_autocmd("Signal", {
  pattern = "SIGUSR1",
  callback = function()
    vim.cmd("colorscheme matugen")
    package.loaded["lualine-matugen"] = nil
    require("lualine").setup({
      options = { theme = require("lualine-matugen") },
    })
    require("lualine").refresh()
  end,
})

vim.cmd("cnoreabbrev <expr> p getcmdtype() ==# ':' && getcmdline() ==# 'p' ? 'previous' : 'p'")
vim.cmd("cnoreabbrev <expr> wp getcmdtype() ==# ':' && getcmdline() ==# 'wp' ? 'write <Bar> previous' : 'wp'")
