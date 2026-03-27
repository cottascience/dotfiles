-- Grug-far: Search and replace (replaces spectre)
-- Preserves your spectre keymaps
return {
  "MagicDuck/grug-far.nvim",
  keys = {
    -- Your original spectre keymaps mapped to grug-far
    {
      "<leader>S",
      function()
        require("grug-far").open()
      end,
      desc = "Search and Replace (grug-far)",
    },
    {
      "<leader>sf",
      function()
        require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Search/Replace (current file)",
    },
    {
      "<leader>sw",
      function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
      end,
      mode = { "n", "v" },
      desc = "Search current word",
    },
  },
}
