-- Bufferline: Buffer navigation with number keys
-- LazyVim provides bufferline, this adds your number keymaps
return {
  "akinsho/bufferline.nvim",
  keys = {
    { "<leader>1", function() require("bufferline").go_to(1, true) end, desc = "Buffer 1" },
    { "<leader>2", function() require("bufferline").go_to(2, true) end, desc = "Buffer 2" },
    { "<leader>3", function() require("bufferline").go_to(3, true) end, desc = "Buffer 3" },
    { "<leader>4", function() require("bufferline").go_to(4, true) end, desc = "Buffer 4" },
    { "<leader>5", function() require("bufferline").go_to(5, true) end, desc = "Buffer 5" },
    { "<leader>6", function() require("bufferline").go_to(6, true) end, desc = "Buffer 6" },
    { "<leader>7", function() require("bufferline").go_to(7, true) end, desc = "Buffer 7" },
    { "<leader>8", function() require("bufferline").go_to(8, true) end, desc = "Buffer 8" },
    { "<leader>9", function() require("bufferline").go_to(9, true) end, desc = "Buffer 9" },
    { "<leader>0", function() require("bufferline").go_to(10, true) end, desc = "Buffer 10" },
  },
  opts = {
    options = {
      numbers = "ordinal",
    },
  },
}
