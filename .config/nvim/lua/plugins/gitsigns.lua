-- Gitsigns: Git integration with custom keymaps
-- LazyVim provides gitsigns with <leader>gh* keymaps, this uses <leader>h* instead
return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame_formatter = "-> <author>, <author_time:%R> - <summary>",
    preview_config = {
      border = "rounded",
    },
    on_attach = function(bufnr)
      local gs = require("gitsigns")

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation (same as LazyVim)
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, { desc = "Next git hunk" })

      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, { desc = "Previous git hunk" })

      -- Your custom keymaps (<leader>h* instead of LazyVim's <leader>gh*)
      map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
      map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk" })
      map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
      map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
      map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
      map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
      map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
      map("n", "<leader>hB", gs.blame, { desc = "Blame buffer" })
      map("n", "<leader>he", gs.preview_hunk_inline, { desc = "Preview hunk inline" })

      -- Snacks toggles
      if Snacks then
        local config = require("gitsigns.config").config
        Snacks.toggle({
          name = "Git inline blame",
          get = function() return config.current_line_blame end,
          set = function(state) gs.toggle_current_line_blame(state) end,
        }):map("<leader>ht")

        Snacks.toggle({
          name = "Git inline diff",
          get = function() return config.linehl and config.word_diff end,
          set = function(state)
            gs.toggle_linehl(state)
            gs.toggle_word_diff(state)
          end,
        }):map("<leader>hi")
      else
        map("n", "<leader>ht", gs.toggle_current_line_blame, { desc = "Toggle blame line" })
        map("n", "<leader>hi", function()
          gs.toggle_linehl()
          gs.toggle_word_diff()
        end, { desc = "Toggle inline diff" })
      end

      -- Text objects
      map({ "o", "x" }, "ih", gs.select_hunk, { desc = "Select hunk" })
      map({ "o", "x" }, "ah", gs.select_hunk, { desc = "Select hunk" })
    end,
  },
}
