-- Treesitter: Better syntax highlighting and code navigation
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed or {}, {
      "python",
      "rust",
      "typescript",
      "javascript",
      "tsx",
      "json",
      "yaml",
      "toml",
      "lua",
      "markdown",
      "markdown_inline",
    })
  end,
}
