-- Zen mode: Focused coding mode
-- Hide UI elements to reduce distractions
return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  opts = {
    window = {
      width = 120,
      options = {
        number = false,
        relativenumber = false,
      },
    },
  },
  keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
}
