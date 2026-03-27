-- Todo-comments: Highlight and search for todo comments
-- LazyVim provides todo-comments, this adds your keymaps
return {
  "folke/todo-comments.nvim",
  keys = {
    -- Your custom keymaps (LazyVim uses <leader>st, <leader>sT, <leader>xt, <leader>xT)
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find Todo Comments" },
    { "<leader>fT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Find Todo/Fix/Fixme" },
  },
}
