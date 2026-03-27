-- Catppuccin theme: Soothing pastel color scheme
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- Ensures it loads before other plugins
  opts = {
    flavour = "mocha", -- matching Zed: "Catppuccin Mocha - No Italics"
    no_italic = true,
    term_colors = true,
    transparent_background = false,
    styles = {
      comments = {},
      conditionals = {},
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
    },
    color_overrides = {
      mocha = {
        base = "#1a1a24",
        mantle = "#181825",
        crust = "#11111b",
      },
    },
    integrations = {
      blink_cmp = true,
      gitsigns = true,
      neotree = true,
      treesitter = true,
      notify = true,
      snacks = true,
      mini = {
        enabled = true,
        indentscope_color = "",
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
        inlay_hints = {
          background = true,
        },
      },
      telescope = {
        enabled = true,
      },
      indent_blankline = {
        enabled = true,
        colored_indent_levels = true,
      },
    },
    custom_highlights = function(colors)
      return {
        NormalFloat = { bg = colors.base },
        FloatBorder = { bg = colors.base },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
