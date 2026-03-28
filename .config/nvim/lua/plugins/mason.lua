-- Mason: Package manager for LSP servers, formatters, and linters
return {
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = {
      -- Python
      "ruff",
      -- Rust
      "rust-analyzer",
      "taplo", -- TOML
      -- JavaScript/TypeScript
      "typescript-language-server",
      "prettier",
      -- JSON/YAML
      "json-lsp",
      "yaml-language-server",
      -- Lua
      "lua-language-server",
      "stylua",
      -- Markdown
      "marksman",
      -- C/C++
      "clangd",
      -- Bash
      "bash-language-server",
      -- LaTeX
      "texlab",
    },
  },
}
