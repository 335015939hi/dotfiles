-- ~/.config/nvim/lua/plugins/coding.lua

return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",

        ["<Tab>"] = { "accept", "fallback" },
        ["<S-Tab>"] = { "select_next", "fallback" },
        ["<C-Tab>"] = { "select_prev", "fallback" },

        ["<Up>"] = { "fallback" },
        ["<Down>"] = { "fallback" },
        ["<Left>"] = { "fallback" },
        ["<Right>"] = { "fallback" },
      },
    },
  },
}
