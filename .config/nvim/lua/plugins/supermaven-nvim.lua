-- Supermaven AI code completion plugin configuration
return {
  "supermaven-inc/supermaven-nvim",
  -- Load plugin when entering insert mode
  event = "InsertEnter",
  opts = {
    -- Keyboard shortcuts for suggestion interactions
    keymaps = {
      accept_suggestion = "<Tab>",
      clear_suggestion = "<C-]>",
      accept_word = "<C-j>",
    },
    -- Disable suggestions for C++ files
    ignore_filetypes = { cpp = true },
    -- Styling for inline code suggestions
    color = {
      suggestion_color = "#808080",
      cterm = 244,
    },
  },
}
