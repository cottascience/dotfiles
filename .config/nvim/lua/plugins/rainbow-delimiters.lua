return {
  "HiPhish/rainbow-delimiters.nvim",
  config = function()
    require("rainbow-delimiters.setup").setup({
      blacklist = { "latex", "tex" },
    })
  end,
}
