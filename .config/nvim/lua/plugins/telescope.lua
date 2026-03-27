-- Telescope: Fuzzy finder customizations
-- LazyVim's telescope extra provides most keymaps, this adds your preferences
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- Your custom keymaps (LazyVim uses different prefixes for some)
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
  },
  opts = {
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "truncate" },
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
    },
    pickers = {
      find_files = {
        theme = "dropdown",
        previewer = false,
      },
      buffers = {
        theme = "dropdown",
        previewer = false,
      },
    },
  },
}
