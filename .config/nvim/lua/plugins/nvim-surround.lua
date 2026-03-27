-- Surround text objects
-- Examples:
-- ysiw) - surround word with ()
-- ds" - delete surrounding "
-- cs'" - change surrounding ' to "
return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      -- Use default keymaps: ys, ds, cs
    })
  end,
}
