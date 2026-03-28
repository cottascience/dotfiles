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

    -- The latex treesitter parser is extremely slow; let vimtex handle everything.
    local disable_latex = { "latex" }
    opts.highlight = opts.highlight or {}
    opts.highlight.disable = vim.list_extend(opts.highlight.disable or {}, disable_latex)
    opts.indent = opts.indent or {}
    opts.indent.disable = vim.list_extend(opts.indent.disable or {}, disable_latex)
  end,
}
