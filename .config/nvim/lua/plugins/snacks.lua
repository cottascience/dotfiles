-- Snacks: Custom dashboard and settings
-- LazyVim provides all Snacks keymaps, this just customizes dashboard and options
return {
  "folke/snacks.nvim",
  opts = {
    statuscolumn = { enabled = false },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║   ██║██║████╗ ████║
██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],
      },
    },
    input = { enabled = true },
    notifier = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true },
      },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end
        vim.print = _G.dd

        vim.ui.input = function(...)
          return require("snacks").input(...)
        end
      end,
    })
  end,
}
