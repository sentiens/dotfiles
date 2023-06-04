require("cutlass").setup({
  cut_key = "<C-x>",
  exclude = {
    "ns",
    "nS",
    "ng",
    "sg",
  },
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<C-x>'] = require('telescope.actions').delete_buffer,
      },
      n = {
        ['<C-x>'] = require('telescope.actions').delete_buffer,
      }
    },
  },
  extensions = {
    file_browser = {
      hijack_netrw = true,
      initial_mode = "normal",
      hidden = true,
      respect_gitignore = false
    },
    frecency = {
      show_unindexed = false,
      ignore_patterns = { "*.git/*" },
      default_workspace = 'CWD'
    },
    recent_files = {
      ignore_patterns = { "*.git/*" },
      only_cwd = true
    }
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require("telescope").load_extension, "file_browser")
pcall(require('telescope').load_extension, 'dap')
pcall(require('telescope').load_extension, 'frecency')
pcall(require("telescope").load_extension, "recent_files")

require('textcase').setup {
  prefix = '<leader>mz'
}
pcall(require('telescope').load_extension, 'textcase')

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'c',
    'cpp',
    'go',
    'lua',
    'python',
    'rust',
    'tsx',
    'typescript',
    'vimdoc',
    'vim',
    'graphql',
    'php',
    'bash',
    "html",
    "javascript",
    "json",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "vim",
    "vimdoc",
    "yaml",
    "dockerfile"
  },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,

  autotag = {
    enable = true,
  },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<A-s>',
      node_incremental = '<A-s>',
      scope_incremental = '<A-a>',
      node_decremental = '<A-f>',
    },
  },
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V',  -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
        ["]l"] = "@loop.*",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        ["]i"] = "@conditional.outer",
      },
      goto_previous = {
        ["[i"] = "@conditional.outer",
      }
    },

  },

}

local faugroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local map = function(keys, func, desc, modes)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    if modes then
      for _, mode in ipairs(modes) do
        vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
      end
    end
  end

  map('<leader>mr', vim.lsp.buf.rename, 'Rename')
  map('<leader>mc', '<cmd>Lspsaga code_action<CR>', 'Code Action')

  map('ga', "<cmd>Lspsaga lsp_finder<CR>", '[G]oto [D]efinition')
  map('gd', "<cmd>Lspsaga goto_definition<CR>", '[G]oto [D]efinition')
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  map('gt', "<cmd>Lspsaga goto_type_definition<CR>", '[T]ype [D]efinition')
  map('gT', "<cmd>Lspsaga peek_type_definition<CR>", '[T]ype [D]efinition')
  map("gp", "<cmd>Lspsaga peek_definition<CR>", "Peek definition")

  map("<leader>o", "<cmd>Lspsaga outline<CR>", "Show outline")

  map("<Leader>gi", "<cmd>Lspsaga incoming_calls<CR>")
  map("<Leader>go", "<cmd>Lspsaga outgoing_calls<CR>")


  map('<leader>bs', require('telescope.builtin').lsp_document_symbols, 'Buffer symbols')
  map('<leader>fs', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace(global) [S]ymbols')

  map('<C-j>', "<cmd>Lspsaga hover_doc ++keep<CR>", 'Hover Documentation', { "v", "i" })
  map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation', { "v", "i" })

  -- Lesser used LSP functionality
  map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  map('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = faugroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = faugroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end
  if client.name == 'gopls' then
    client.server_capabilities.semanticTokensProvider = {
      full = true,
      legend = {
        tokenTypes = { 'namespace', 'type', 'interface', 'struct', 'typeParameter', 'parameter',
          'function', 'method', 'modifier', 'comment',
          'string', 'number', 'regexp', 'operator', 'decorator' },
        tokenModifiers = { 'declaration', 'definition', 'readonly', 'static', 'deprecated', 'abstract', 'async',
          'modification', 'documentation', 'defaultLibrary' }
      }
    }
  end
end

-- fix showing some keywords as constants in some lsps
vim.api.nvim_create_autocmd('LspTokenUpdate', {
  callback = function(args)
    local token = args.data.token
    if token.modifiers.readonly and token.modifiers.defaultLibrary then
      local trees_info = vim.treesitter.get_captures_at_pos(args.buf, token.line, token.start_col)

      for i, tres_info in ipairs(trees_info) do
        if tres_info.capture == 'constant.builtin' then
          vim.lsp.semantic_tokens.highlight_token(
            token, args.buf, args.data.client_id, '@constant.builtin.go', {
              priority = 200,
            }
          )
        end
      end
    end
  end,
})

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  clangd = {},
  phpactor = {},
  pyright = {},
  -- rust_analyzer = {},
  tsserver = {},
  cssls = {},
  html = {},
  jsonls = {},
  graphql = {},
  bashls = {},
  sqlls = {},

  gopls = {
    gopls = {
      semanticTokens = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    }
  },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup {
  library = { plugins = { "nvim-dap-ui" }, types = true },
}

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

require("mason-nvim-dap").setup({
  ensure_installed = {
    "chrome-debug-adapter",
    "node-debug2-adapter",
    "delve",
    "php-debug-adapter",
  },
  automatic_installation = true
})

vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })

local dap, dapui = require("dap"), require("dapui")
dapui.setup()
dap.set_log_level("INFO")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dap.configurations = {
  javascript = {
    {
      type = 'node2',
      name = 'Launch',
      request = 'launch',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
    {
      type = 'node2',
      name = 'Attach',
      request = 'attach',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
  },
  go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}",
    },
    {
      type = "go",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
    },
  },
  php = {
    {
      type = "php",
      request = "launch",
      name = "Listen for Xdebug",
      port = 9003,
      pathMappings = {
        ["/var/www/html"] = "${workspaceFolder}"
      }
    }
  }
}

dap.adapters = {
  go = {
    type = "server",
    port = "${port}",
    executable = {
      command = vim.fn.stdpath("data") .. '/mason/bin/dlv',
      args = { "dap", "-l", "127.0.0.1:${port}" },
    },
  },
  php = {
    type = "executable",
    command = "node",
    args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/vscode-php-debug/out/phpDebug.js" }
  },
  node2 = {
    type = 'executable',
    command = 'node',
    args = { vim.fn.stdpath("data") .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
  }
}

require("nvim-dap-virtual-text").setup()

require("nvim-autopairs").setup {}
-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

local lspkind = require 'lspkind'
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup {
  preselect = cmp.PreselectMode.None,
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
      ellipsis_char = '...',

      symbol_map = {
        Codeium = "",
        Tabnine = "",
        Copilot = "",
      }
    })
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-l>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = "codeium" },
    { name = 'cmp_tabnine' },
    { name = "copilot" },
    { name = 'buffer' },
  },
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

require("toggleterm").setup {
  size = function(term)
    if term.direction == "horizontal" then
      return 25
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
}

require("auto-session").setup {}

require('nvim-ts-autotag').setup()

require('hlslens').setup()

require('Comment').setup()

require('hlargs').setup()

require('neoai').setup {
  prompts = {
    context_prompt = function(context)
      return "I'd like to provide some context for future "
          .. "messages. Here is the code/text that I want to refer "
          .. "to in our upcoming conversations, file " .. vim.fn.expand('%:t') .. ":\n\n"
          .. context
    end,
  },
}

local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require('go.format').goimport()
  end,
  group = format_sync_grp,
})

vim.diagnostic.config({
  virtual_text = false,
})
require("lsp_lines").setup()


require("nvim-surround").setup {}
