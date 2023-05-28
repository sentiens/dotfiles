-- Disable deprecation warnings by filtering out specific notifications

-- First setup noice since it overrides notify
require("noice").setup {
  lsp = {
    signature = {
      enabled = true,
    },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
  },
}
-- Store original notify function
local orig_notify = require("noice.source.notify").notify
-- Define a new notify function that filters out certain notifications
local function filter_notify(text, level, opts)
  -- Check if the notification contains "deprecated" or specific treesitter warnings
  if type(text) == "string" and (
        (string.find(text, "deprecated", 1, true) or
          string.find(text, "treesitter%.lua:28") or
          string.find(text, "treesitter/query%.lua:200")))
  then
    -- If it does, do nothing and return
    return
  end

  -- If it doesn't, call the original notify function
  orig_notify(text, level, opts)
end

-- Overwrite the original notify function with our new one
require("noice.source.notify").notify = filter_notify
