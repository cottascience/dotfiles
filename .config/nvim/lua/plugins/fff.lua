return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    -- this will download prebuild binary or try to use existing rustup toolchain to build from source
    -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
    require("fff.download").download_or_build_binary()
  end,
  -- if you are using nixos
  -- build = "nix run .#release",
  opts = {
    debug = {
      enabled = true, -- disable once scoring feels stable
      show_scores = true,
    },
    max_results = 200,
    layout = {
      prompt_position = "bottom",
      preview_size = 0.55,
      path_shorten_strategy = "middle",
    },
    preview = {
      line_numbers = true,
    },
    grep = {
      smart_case = true,
      time_budget_ms = 300,
      max_matches_per_file = 50,
    },
    history = {
      min_combo_count = 2,
    },
  },
  -- No need to lazy-load with lazy.nvim.
  -- This plugin initializes itself lazily.
  lazy = false,
  keys = {
    {
      "ff", -- try it if you didn't it is a banger keybinding for a picker
      function()
        require("fff").find_files()
      end,
      desc = "FFFind files",
    },
    {
      "fg",
      function()
        require("fff").live_grep()
      end,
      desc = "LiFFFe grep",
    },
    {
      "fz",
      function()
        require("fff").live_grep({
          grep = {
            modes = { "fuzzy", "plain" },
          },
        })
      end,
      desc = "Live fffuzy grep",
    },
    {
      "fc",
      function()
        require("fff").live_grep({ query = vim.fn.expand("<cword>") })
      end,
      desc = "Search current word",
    },
    {
      "fd",
      function()
        local dir = vim.fn.expand("%:p:h")
        require("fff").find_files_in_dir(dir)
      end,
      desc = "Files in current dir",
    },
    {
      "fq",
      function()
        require("fff").live_grep({
          keymaps = {
            send_to_quickfix = "<CR>",
          },
        })
      end,
      desc = "Grep to quickfix",
    },
  },
}
