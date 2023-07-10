require("codeium").setup {}

require("copilot").setup {
  suggestions = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "<C-l>",
      accept_word = false,
      accept_line = false,
      next = "<C-]>",
      prev = "<C-[>",
      dismiss = "<C-]>",
    },
  },

  panel = { enabled = true },
  copilot_node_command = 'node',
}

require("copilot_cmp").setup()

require("neoai").setup({
  models = {
    {
      name = "openai",
      model = "gpt-3.5-turbo-16k",
    },
  },
})
