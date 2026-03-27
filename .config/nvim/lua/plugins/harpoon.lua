-- Harpoon: Lightning-fast file navigation
-- Quickly mark and navigate to frequently used files
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- Add current file to harpoon list
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Add to Harpoon" })
    -- Toggle harpoon menu
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle Harpoon Menu" })

    -- Navigate to specific harpoon marks (Ctrl+H/J/K/L for files 1-4)
    vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "Harpoon File 1" })
    vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end, { desc = "Harpoon File 2" })
    vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end, { desc = "Harpoon File 3" })
    vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end, { desc = "Harpoon File 4" })
  end,
}
