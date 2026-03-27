return {
  "gbprod/substitute.nvim",
  opts = {
    yank_substituted_text = true,
    preserve_cursor_position = false,
    highlight_substituted_text = {
      enabled = true,
      timer = 200,
    },
    range = {
      prefix = "s",
      prompt_current_text = false,
      confirm = false,
      complete_word = false,
      subject = nil,
      range = nil,
      suffix = "",
      auto_apply = true,
      cursor_position = "end",
    },
    exchange = {
      motion = true,
      use_esc_to_cancel = true,
      preserve_cursor_position = false,
    },
  },
}
