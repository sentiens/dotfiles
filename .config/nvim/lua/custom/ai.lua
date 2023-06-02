local tabnine = require('cmp_tabnine.config')
tabnine:setup({
  max_lines = 1000,
  max_num_results = 5,
  sort = true,
  run_on_every_keystroke = true,
  snippet_placeholder = '..',
  ignored_file_types = {
    -- default is not to ignore
    -- uncomment to ignore in lua:
    -- lua = true
  },
  show_prediction_strength = true
})

local prefetch = vim.api.nvim_create_augroup("prefetch", { clear = true })

vim.api.nvim_create_autocmd('BufRead', {
  group = prefetch,
  pattern = '*',
  callback = function()
    require('cmp_tabnine'):prefetch(vim.fn.expand('%:p'))
  end
})

require("copilot").setup {
  suggestion = { enabled = true },
  panel = { enabled = true },
  copilot_node_command = 'node',
}

require("copilot_cmp").setup()

require("neoai").setup({
  models = {
    {
      name = "openai",
      model = "gpt-4"
    },
  },
})
