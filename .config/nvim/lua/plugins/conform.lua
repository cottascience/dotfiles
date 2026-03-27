-- Conform: Lightweight formatter plugin
return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      -- Python: use ruff for formatting
      python = { "ruff_format", "ruff_organize_imports" },
      -- Rust: use rustfmt
      rust = { "rustfmt" },
      -- JavaScript/TypeScript: use prettier
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      -- JSON/YAML
      json = { "prettier" },
      yaml = { "prettier" },
      -- Lua
      lua = { "stylua" },
      -- Markdown
      markdown = { "prettier" },
    },
  },
}
