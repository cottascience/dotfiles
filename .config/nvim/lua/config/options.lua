-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Font settings (matching Zed)
opt.guifont = "JetBrains Mono Nerd Font:h12"

-- Tab and indentation (matching Zed: tab_size=4, hard_tabs=false)
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

-- Line length (matching Zed: preferred_line_length=100)
opt.textwidth = 100

-- Wrapping (matching Zed: soft_wrap="editor_width")
opt.wrap = true
opt.linebreak = true

-- Scrolling (matching Zed: vertical_scroll_margin=3, scroll_beyond_last_line="one_page")
opt.scrolloff = 3
opt.sidescrolloff = 8

-- Relative line numbers (matching Zed: relative_line_numbers="enabled")
opt.relativenumber = true
opt.number = true

-- Clipboard (matching Zed vim.use_system_clipboard="always")
opt.clipboard = "unnamedplus"

-- Cursor (matching Zed: cursor_shape="block", cursor_blink=true)
opt.guicursor = "n-c:block,v:hor20,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250"

-- Whitespace (matching Zed: remove_trailing_whitespace_on_save=true)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Ensure final newline (matching Zed: ensure_final_newline_on_save=true)
opt.fixendofline = true

-- Indent guides (matching Zed: indent_guides.enabled=true)
opt.list = true
opt.listchars = { tab = "│ ", trail = "·", extends = "→", precedes = "←", nbsp = "␣" }

-- Folding (enhanced)
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Show sign column always
opt.signcolumn = "yes"

-- Session options (for auto-session)
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
