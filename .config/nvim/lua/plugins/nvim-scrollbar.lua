-- Scrollbar: Visual scrollbar with diagnostic colors
return {
  "petertriho/nvim-scrollbar",
  event = "VeryLazy",
  opts = {
    show = true,
    handle = {
      color = "#45475a",
    },
    marks = {
      Search = { color = "#f9e2af" },
      Error = { color = "#f38ba8" },
      Warn = { color = "#fab387" },
      Info = { color = "#89dceb" },
      Hint = { color = "#94e2d5" },
      Misc = { color = "#cba6f7" },
    },
  },
}
