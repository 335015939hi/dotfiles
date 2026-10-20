-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

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

-- p -> previous
vim.cmd("cnoreabbrev <expr> p getcmdtype() ==# ':' && getcmdline() ==# 'p' ? 'previous' : 'p'")
vim.cmd("cnoreabbrev <expr> wp getcmdtype() ==# ':' && getcmdline() ==# 'wp' ? 'write <Bar> previous' : 'wp'")
