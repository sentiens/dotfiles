local set = vim.keymap.set
-- Keymaps for better default experience
-- See `:help set()`
set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

local capi = require('Comment.api')

_G.comment_and_todo = function()
  capi.locked('insert.linewise.eol')("char")
  vim.api.nvim_put({ 'TODO: ' }, 'c', true, true)
end

set('n', '<leader>gt', '<Cmd>lua _G.comment_and_todo()<CR>',
  { noremap = true, silent = true, desc = 'Comment insert end of line and add TODO' })

-- standard macos keymaps
set({ 'n', 'v' }, '<Esc>b', 'b', { noremap = true })
set({ 'n', 'v' }, '<Esc>f', 'w', { noremap = true })
set('i', '<Esc>b', '<C-o>b', { noremap = true })
set('i', '<Esc>f', '<C-o>w', { noremap = true })

set({ 'n', 'v' }, '<C-a>', '0', { noremap = true })
set({ 'n', 'v' }, '<C-e>', '$', { noremap = true })
set('i', '<C-a>', '<C-o>0', { noremap = true })
set('i', '<C-e>', '<C-o>$', { noremap = true })
set({ 'n', 'v' }, "<Esc><", "gg", { noremap = true })
set({ 'n', 'v' }, "<Esc>>", "G", { noremap = true })
set('i', '<Esc><', '<C-o>gg', { noremap = true })
set('i', '<Esc>>', '<C-o>G', { noremap = true })

set("n", "<Esc>a", "ggVG", { noremap = true })
set("i", "<Esc>a", "<Esc>ggVG", { noremap = true })
set("x", "<Esc>a", "<Esc>ggVG", { noremap = true })

set("n", "<Esc>y", "yy", { noremap = true })
set("x", "<Esc>y", "y", { noremap = true })

set("n", "<Esc>z", "u", { noremap = true })
set("i", "<Esc>z", "<Esc>u", { noremap = true })
set("i", "<C-r>", "<C-o><C-r>", { noremap = true })
set("x", "<Esc>z", "<Esc>u", { noremap = true })
set("x", "<C-r>", "<Esc><C-r>", { noremap = true })

-- select pasted content
set("n", "yp", "`[v`]", { noremap = true })

-- move things around
local opts = { noremap = true, silent = true }
set('v', 'J', ':MoveBlock(1)<CR>', opts)
set('v', 'K', ':MoveBlock(-1)<CR>', opts)
set('v', 'H', ':MoveHBlock(-1)<CR>', opts)
set('v', 'L', ':MoveHBlock(1)<CR>', opts)
set('v', '<leader>J', '"zy`]\"zP`[v`]:MoveBlock(1)<CR>', { noremap = true, silent = true })
set('v', '<leader>K', '"zy`[\"zp`[v`]:MoveBlock(-1)<CR>', { noremap = true, silent = true })
set('v', '<leader>H', '"zy`[\"zp`[v`]:MoveHBlock(-1)<CR>', { noremap = true, silent = true })
set('v', '<leader>L', '"zy`]\"zP`[v`]:MoveHBlock(1)<CR>', { noremap = true, silent = true })

set('n', '<C-q>', ':bd<CR>', { silent = true })
set('v', 'p', '"_dp', { noremap = true, silent = true })

set('n', 'sd', '<Plug>(nvim-surround-delete)')
set('n', 'sc', "<Plug>(nvim-surround-change)")
set('n', 'std', '<Plug>(nvim-surround-delete)t')

-- For use default preset and it work with dot
set('n', '<leader>mt', require('treesj').toggle)
set('n', '<leader>mT', require('treesj').split)

set('n', '<leader>Sf', '<cmd>lua require("spectre").open()<CR>',
  {
    desc = "Open Spectre"
  })
set('n', '<leader>Sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
  {
    desc = "Search current word"
  })
set('v', '<leader>Sw', '<esc><cmd>lua require("spectre").open_visual()<CR>',
  {
    desc = "Search current selection",
  })
set('n', '<leader>Sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
  {
    desc = "Search on current file",
  })

-- See `:help telescope.builtin`
set('n', '<leader>bf', require('telescope.builtin').buffers, { desc = 'Find existing buffers' })
set('n', '<leader>b/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
-- set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = '[F]ind [R]ecently opened files' })
set("n", "<leader>fh", "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
  { noremap = true, silent = true })
set("n", "<Leader>fr",
  [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
  { noremap = true, silent = true })

set('n', '<leader>fg', require('telescope.builtin').git_files, { desc = '[F]ind [G]it [F]iles' })
set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
set('n', '<leader>f?', require('telescope.builtin').help_tags, { desc = '[F]find [H]elp' })
set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]find current [W]ord' })
set('n', '<leader>f/', require('telescope.builtin').live_grep, { desc = '[F]find by grep' })
set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]find [D]iagnostics' })
-- open file_browser with the path of the current buffer
set(
  "n",
  "<leader>fb",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true, desc = "Open [F]ile [B]rowser", }
)

-- Diagnostic keymaps
set('n', '<leader>dh', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
set('n', '<leader>dl', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
set('n', '<leader>di', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
set('n', '<leader>da', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
set("n", "<leader>dt", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
set("n", "<leader>dw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
set("n", "<leader>d/", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
set("n", "<leader>ds", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
set("n", "<leader>df", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
set("n", "dr", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  set('t', '<C-v>', [[<C-\><C-n>]], opts)
  set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
set('n', '<leader>tt', '<CMD>ToggleTerm<CR>', { noremap = true, silent = true })

set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })

set({ 'n', 'v' }, '<leader>ao', ':NeoAI<space>', { silent = true, desc = "AI: Open chat" })
set({ 'n', 'v' }, '<leader>ac', '<cmd>NeoAIClose<CR>', { silent = true, desc = "AI: Close chat" })
set({ 'v' }, "<leader>ax", ':NeoAIContextOpen<space>"No description needed, just code. "<Left>',
  { desc = "AI: With context" })
set({ 'v' }, "<leader>ac",
  ':NeoAIContextOpen<space>"In the response return just the plain text code without any descriptions and clarifications. Edit the code with the instructions: "<Left>',
  { silent = false, desc = "AI: Change code" })
set({ 'v' }, "<leader>ae",
  ':NeoAIContextOpen<space>"Explain what this code does please."<CR>',
  { silent = false, desc = "AI: Explain" })
set({ 'v' }, "<leader>at",
  ':NeoAIContextOpen<space>"In the response return just the plain text code without any descriptions and clarifications. Implement TODO in the code."<CR>',
  { silent = false, desc = "AI: TODO" })
set({ 'v' }, "<leader>ar",
  ':NeoAIContextOpen<space>"Review this chunk of code as a senior software engineer. Look carefully if this code contains logical errors and that it is in line with best practices. The answer should be a list of short abstracts that are worth paying attention to without further explanation."<CR>',
  { silent = false, desc = "AI: Review" })
set({ 'v' }, "<leader>as",
  ':NeoAIContextOpen<space>"Come up with possible tests for this code. The output should be a list of short test names."<CR>',
  { silent = false, desc = "AI: Imagine tests" })


local kopts = { noremap = true, silent = true }
set('n', 'n',
  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
  kopts)
set('n', 'N',
  [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
  kopts)
set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

set('n', '<Leader>l', '<Cmd>noh<CR>', kopts)

local keyopts = { noremap = true, silent = true }
set({ 'n', 'v', 'o' }, '<A-h>', require('tree-climber').goto_parent, keyopts)
set({ 'n', 'v', 'o' }, '<A-l>', require('tree-climber').goto_child, keyopts)
set({ 'n', 'v', 'o' }, '<A-j>', require('tree-climber').goto_next, keyopts)
set({ 'n', 'v', 'o' }, '<A-k>', require('tree-climber').goto_prev, keyopts)
set('n', '<A-p>', require('tree-climber').swap_prev, keyopts)
set('n', '<A-u>', require('tree-climber').swap_next, keyopts)
set('n', '<A-s>', require('tree-climber').highlight_node, keyopts)

set('n', '<leader><space>', require("nvim-navbuddy").open, { desc = "Syntax three navigation" })

set({ 'n', 'v' }, '<leader>ma', '<cmd>TextCaseOpenTelescope<CR>', { desc = "Telescope" })
set('x', '<leader>mdc', ":<C-u>'<,'>s,\\v(\\s*)//.*,,g<CR>",
  { noremap = true, silent = true, desc = "Delete comments" })

set('n', '<leader>dec', '<cmd>lua require"dap".continue()<CR>', { desc = "Debug: continue" })
set('n', '<leader>deo', '<cmd>lua require"dap".step_over()<CR>', { desc = "Debug: Step over" })
set('n', '<leader>dei', '<cmd>lua require"dap".step_into()<CR>', { desc = "Debug: Step into" })
set('n', '<leader>deu', '<cmd>lua require"dap".step_out()<CR>', { desc = "Debug: Step out" })
set("n", "<Leader>dee", "<CMD>lua require('dapui').eval()<CR>", { desc = "Debug: Step out" })
set('n', '<leader>deb', '<cmd>lua require"dap".toggle_breakpoint()<CR>', { desc = "Debug: Toggle breakpoint" })
set('n', '<leader>def', '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
  { desc = "Debug: Breakpoint condition" })
set('n', '<leader>dem', '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
  { desc = "Debug: Breakpoint message" })
set('n', '<leader>der', '<cmd>lua require"dap".repl.open()<CR>', { desc = "Debug: Repl" })
set('n', '<leader>del', '<cmd>lua require"dap".repl.run_last()<CR>', { desc = "Debug: Repl run last" })
set('n', '<leader>dec', '<cmd>lua require"dap".terminate()<CR>', { desc = "Debug: Terminate" })
set('n', '<leader>deq', '<cmd>lua require"dap".close()<CR>', { desc = "Debug: close" })

-- telescope-dap
set('n', '<leader>detc', '<cmd>lua require"telescope".extensions.dap.commands{}<CR>', { desc = "Debug: Commands" })
set('n', '<leader>deto', '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>', { desc = "Debug: Configs" })
set('n', '<leader>detb', '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>',
  { desc = "Debug: Breakpoints" })
set('n', '<leader>detv', '<cmd>lua require"telescope".extensions.dap.variables{}<CR>', { desc = "Debug: Variables" })
set('n', '<leader>detf', '<cmd>lua require"telescope".extensions.dap.frames{}<CR>', { desc = "Debug: Frames" })
