return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
  keys = {
    { "<leader>dd", "<cmd>DiffviewOpen<cr>", desc = "Diff working tree vs HEAD" },
    { "<leader>dm", "<cmd>DiffviewOpen main<cr>", desc = "Diff vs main" },
    { "<leader>dM", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diff branch vs main (PR style)" },
    { "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current file)" },
    { "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "File history (repo)" },
    { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
  },
  -- runs at startup so :diff works even before plugin loads (abbrev fires DiffviewOpen -> lazy-load)
  init = function()
    -- :diff           -> DiffviewOpen        (working tree vs HEAD = last commit)
    -- :diff main      -> DiffviewOpen main   (vs branch)
    -- :diff pjfm/v3   -> DiffviewOpen pjfm/v3
    -- only expands when whole cmdline is exactly "diff", so normal :diffthis etc still work
    vim.cmd([[cnoreabbrev <expr> diff getcmdline() ==# 'diff' ? 'DiffviewOpen' : 'diff']])
  end,
  config = function()
    require("diffview").setup({
      enhanced_diff_hl = true, -- nicer hunk highlighting
      default_args = {
        DiffviewOpen = { "--untracked-files=no" },
      },
      keymaps = {
        view = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
          -- <tab>/<s-tab> next/prev file are defaults; ]c/[c jump hunks (native)
        },
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
        },
      },
    })
  end,
}
