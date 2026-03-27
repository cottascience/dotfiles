-- Auto-session: Session management (replaces LazyVim's persistence.nvim)
return {
  -- Disable LazyVim's persistence.nvim
  { "folke/persistence.nvim", enabled = false },

  -- Use auto-session instead
  {
    "rmagatti/auto-session",
    lazy = false,
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "~/Downloads", "/" },
    },
    keys = {
      -- Match LazyVim's persistence keymaps for familiarity
      { "<leader>qs", "<cmd>SessionRestore<cr>", desc = "Restore Session" },
      { "<leader>qS", "<cmd>SessionSearch<cr>", desc = "Search Sessions" },
      { "<leader>qd", "<cmd>SessionDelete<cr>", desc = "Delete Session" },
      { "<leader>qa", "<cmd>SessionSave<cr>", desc = "Save Session" },
    },
  },
}
