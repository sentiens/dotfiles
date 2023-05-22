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
  suggestion = { enabled = false },
  panel = { enabled = false }
}

require("copilot_cmp").setup()
require("codegpt.config")

vim.g["codegpt_commands_defaults"] = {
  ["completion"] = {
    model = "gpt-4",
    user_message_template =
    "I have the following {{language}} code snippet: ```{{filetype}}\n{{text_selection}}```\nComplete the rest. Use best practices.Use minimum documentation. {{language_instructions}} Only return the code snippet and nothing else.",
    language_instructions = {
    },
  },
  ["code_edit"] = {
    model = "gpt-4",
    user_message_template =
    "I have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\n{{command_args}}. {{language_instructions}} Only return the code snippet and nothing else.",
    language_instructions = {
    },
  },
  ["explain"] = {
    model = "gpt-4",
    user_message_template =
    "Explain the following {{language}} code: ```{{filetype}}\n{{text_selection}}``` Explain as if you were explaining to another developer.",
    callback_type = "text_popup",
  },
  ["question"] = {
    user_message_template =
    "I have a question about the following {{language}} code: ```{{filetype}}\n{{text_selection}}``` {{command_args}}",
    callback_type = "text_popup",
  },
  ["debug"] = {
    user_message_template = "Analyze the following {{language}} code for bugs: ```{{filetype}}\n{{text_selection}}```",
    callback_type = "text_popup",
  },
  ["doc"] = {
    user_message_template =
    "I have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\nWrite really good documentation using best practices for the given language. Attention paid to documenting parameters, return types, any exceptions or errors. {{language_instructions}} Only return the code snippet and nothing else.",
    language_instructions = {
    },
  },
  ["opt"] = {
    user_message_template =
    "I have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\nOptimize this code. {{language_instructions}} Only return the code snippet and nothing else.",
    language_instructions = {
    },
  },
  ["tests"] = {
    user_message_template =
    "I have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\nWrite really good unit tests using best practices for the given language. {{language_instructions}} Only return the unit tests. Only return the code snippet and nothing else. ",
    callback_type = "code_popup",
    language_instructions = {
    },
  },
  ["chat"] = {
    system_message_template = "You are a general assistant to a software developer.",
    user_message_template = "{{command_args}}",
    callback_type = "text_popup",
  },
}
