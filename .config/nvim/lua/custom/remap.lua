-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Replace selection with clipboard
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Just remove without clipboard
vim.keymap.set({ "n", "v" }, "D", '"_d', { silent = true, noremap = true })

vim.keymap.set("n", "<leader>fc", vim.lsp.buf.format)

vim.keymap.set('n', '<C-q>', ':bd<CR>', { silent = true })

vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
  { silent = true, noremap = true }
)
-- For use default preset and it work with dot
vim.keymap.set('n', '<leader>mt', require('treesj').toggle)
-- For extending default preset with `recursive = true`, but this doesn't work with dot
vim.keymap.set(
  'n',
  '<leader>mT',
  function() require('treesj').toggle({ split = { recursive = true } }) end
)
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").open()<CR>',
  {
    desc = "Open Spectre"
  })
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
  {
    desc = "Search current word"
  })
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>',
  {
    desc = "Search current word",
  })
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
  {
    desc = "Search on current file",
  })
-- TODO: Improve o based shortcuts
vim.keymap.set({ 'n', 'x' }, '<leader>on', '<cmd>Telescope notify<CR>', {
  desc = "Open notifications"
})

vim.keymap.set({ 'n', 'x' }, '<leader>O', '<cmd>Navbuddy<CR>')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = '[F]ind [R]ecently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>fg', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Search [F]iles' })

vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- open file_browser with the path of the current buffer
vim.api.nvim_set_keymap(
  "n",
  "<space>fb",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true, desc = "Open file browser", }
)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Split line
vim.api.nvim_set_keymap('n', '<leader>s', ':normal! i<CR><Esc>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>tt', '<CMD>ToggleTerm<CR>', {noremap = true, silent = true})
