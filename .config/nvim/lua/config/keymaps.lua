-- keymaps are automatically loaded on the verylazy event
-- default keymaps that are always set: https://github.com/lazyvim/lazyvim/blob/main/lua/lazyvim/config/keymaps.lua
-- add any additional keymaps here
local keymap = vim.keymap.set

-- Fast semantic navigation keybindings
keymap({ "n", "v" }, "A", "b", { noremap = true, desc = "Word backward" })
keymap({ "n", "v" }, "D", "e", { noremap = true, desc = "Word forward (end)" })
keymap({ "n", "v" }, "W", "{", { noremap = true, desc = "Paragraph backward" })
keymap({ "n", "v" }, "S", "}", { noremap = true, desc = "Paragraph forward" })
keymap({ "n", "v" }, "Q", "0", { noremap = true, desc = "Start of line" })
keymap({ "n", "v" }, "E", "$", { noremap = true, desc = "End of line" })

-- Toggle comment in visual mode (mirrors Ctrl+/ from VS Code/JetBrains)
keymap("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment" })

-- Insert mode save command (stays in insert mode)
keymap("i", "<C-q>", "<C-o>:w<CR>", { noremap = true, desc = "Save file" })

-- keymap for replacing the word under the cursor (current file only)
keymap("n", "<leader>s*", [[:%s/\<<c-r><c-w>\>/]], {
  desc = "replace word under cursor (current file)",
  noremap = true,
})

-- Helper function to show output in a floating window
local function show_output_window(content, title)
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = vim.split(content, "\n", { trimempty = false })

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].filetype = "markdown"

  -- Calculate window size
  local width = math.min(100, vim.o.columns - 4)
  local height = math.min(30, #lines + 2, vim.o.lines - 4)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = title or "Claude Code Output",
    title_pos = "center",
  })

  -- Set keymaps to close the window
  local opts = { buffer = buf, noremap = true, silent = true }
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, opts)
  vim.keymap.set("n", "<Esc>", function()
    vim.api.nvim_win_close(win, true)
  end, opts)
end

-- Helper function to get file reference with line numbers
local function get_file_ref()
  local file = vim.fn.expand("%:.")
  local mode = vim.fn.mode()

  if mode == "v" or mode == "V" or mode == "\22" then
    -- Visual mode: get selected line range
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")

    -- Ensure start is before end
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end

    return string.format("@%s:%d-%d", file, start_line, end_line)
  else
    -- Normal mode: get current line
    local line = vim.fn.line(".")
    return string.format("@%s:%d", file, line)
  end
end

-- Claude Code keymap for quick inline edits
keymap({ "n", "v" }, "<leader>CC", function()
  -- Get current working directory
  local cwd = vim.fn.getcwd()

  -- Get file path with line numbers
  local file_ref = get_file_ref()

  -- Prompt for user input
  vim.ui.input({
    prompt = "Claude Code task: ",
    default = "",
  }, function(input)
    -- Check if input was provided
    if not input or input == "" then
      vim.notify("No input provided", vim.log.levels.WARN)
      return
    end

    -- Build the command with file reference prepended to input
    local cmd = {
      "claude",
      "-p",
      "--dangerously-skip-permissions",
      "--model",
      "haiku",
      file_ref .. " " .. input,
    }

    vim.notify("Running Claude Code: " .. input, vim.log.levels.INFO)

    -- Use vim.system to run the command asynchronously
    vim.system(cmd, {
      cwd = cwd,
      text = true,
    }, function(result)
      vim.schedule(function()
        if result.code == 0 then
          -- Reload the buffer to reflect any changes
          vim.cmd("edit!")

          -- Show output if available
          if result.stdout and result.stdout ~= "" then
            show_output_window(result.stdout, "Claude Code ✅ - Press q or <Esc> to close")
          else
            vim.notify("Claude Code completed successfully", vim.log.levels.INFO)
          end
        else
          -- Error
          local error_msg = "Claude Code failed with code " .. result.code
          if result.stderr and result.stderr ~= "" then
            error_msg = error_msg .. "\n\n" .. result.stderr
          end
          show_output_window(error_msg, "Claude Code Error - Press q or <Esc> to close")
        end
      end)
    end)
  end)
end, {
  desc = "Run Claude Code with Haiku for quick inline edits",
  noremap = true,
  silent = true,
})
