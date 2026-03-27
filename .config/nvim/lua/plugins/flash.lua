-- Flash: Quick navigation (keymap overrides only)
-- LazyVim provides flash.nvim, this just customizes keymaps
return {
  "folke/flash.nvim",
  keys = {
    { "S", false }, -- Disable default S mapping
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "<c-f>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
