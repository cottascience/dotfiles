return {
  "saghen/blink.cmp",
  opts = {
    keymap = { preset = "enter" },
    completion = {
      list = { max_items = 8 },
      menu = { draw = { columns = { { "label" }, { "kind" } } } },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
