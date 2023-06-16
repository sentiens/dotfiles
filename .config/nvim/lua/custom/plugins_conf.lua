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

local remove_ansi_escape = function(str)
  local ansi_escape_pattern = '\27%[%d+;%d*;%d*m'
  -- Replace all occurrences of the pattern with an empty string
  str = str:gsub(ansi_escape_pattern, '')
  str = str:gsub('\27%[[%d;]*%a', '')
  return str
end

local handle_job_data = function(data)
  if not data then
    return nil
  end
  -- Because the nvim.stdout's data will have an extra empty line at end on some OS (e.g. maxOS), we should remove it.
  for _ = 1, 3, 1 do
    if data[#data] == '' then
      table.remove(data, #data)
    end
  end
  if #data < 1 then
    return nil
  end
  -- remove ansi escape code
  for i, _ in ipairs(data) do
    data[i] = remove_ansi_escape(data[i])
  end

  return data
end


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

  local map = function(keys, func, desc, modes, extra_opts)
    if desc then
      desc = 'LSP: ' .. desc
    end

    local opts = { buffer = bufnr, desc = desc }
    if extra_opts then
      for k, v in pairs(extra_opts) do
        opts[k] = v
      end
    end

    vim.keymap.set('n', keys, func, opts)
    if modes then
      for _, mode in ipairs(modes) do
        vim.keymap.set(mode, keys, func, opts)
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
    local function format()
      if client.name == 'gopls' then
        if vim.o.mod == true then
          vim.cmd('write')
        end

        local current_file_path = vim.api.nvim_buf_get_name(0)
        local status = { gofumpt = false, reviser = false, golines = false, error_occurred = false }
        local error_messages = {}

        local function on_job_exit(job_type)
          return function(_, code, _)
            if code ~= 0 then
              return vim.notify('Formatting failed', vim.log.levels.ERROR)
            end
            status[job_type] = true

            if status.gofumpt and status.reviser and status.golines then
              if status.error_occurred then
                vim.notify(table.concat(error_messages, "\n"), vim.log.levels.ERROR)
              else
                vim.notify("Formatted", vim.log.levels.INFO)
                vim.cmd('edit')
              end
            end
          end
        end

        local function on_job_stderr(job_type)
          return function(_, data, _)
            data = handle_job_data(data)
            if data and #data > 0 then
              status.error_occurred = true
              error_messages[#error_messages + 1] = string.format("%s: %s", job_type, table.concat(data))
            end
          end
        end

        local gofumpt_cmd = string.format("gofumpt -l -w %s", current_file_path)
        local gofumpt_args = vim.fn.split(gofumpt_cmd, " ")
        vim.fn.jobstart(gofumpt_args, {
          on_exit = on_job_exit("gofumpt"),
          on_stderr = on_job_stderr("gofumpt"),
          stderr_buffered = true
        })

        local reviser_cmd = string.format("goimports-reviser -rm-unused -set-alias -format -company-prefixes=pb %s",
          current_file_path)
        local reviser_args = vim.fn.split(reviser_cmd, " ")
        vim.fn.jobstart(reviser_args, {
          on_exit = on_job_exit("reviser"),
          on_stderr = on_job_stderr("reviser"),
          stderr_buffered = true
        })

        local golines_cmd = string.format("golines -m 130 -w %s", current_file_path)
        local golines_args = vim.fn.split(golines_cmd, " ")
        vim.fn.jobstart(golines_args, {
          on_exit = on_job_exit("golines"),
          on_stderr = on_job_stderr("golines"),
          stderr_buffered = true
        })
      else
        vim.lsp.buf.format()
      end
    end


    map("<leader>mf", format, 'Modify [F]ormat')
    vim.api.nvim_clear_autocmds({ group = faugroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = faugroup,
      buffer = bufnr,
      callback = format,
    })
  end
  if client.name == 'gopls' then
    local semantic = client.config.capabilities.textDocument.semanticTokens
    client.server_capabilities.semanticTokensProvider = {
      full = true,
      legend = {
        tokenTypes = semantic.tokenTypes,
        tokenModifiers = semantic.tokenModifiers,
      },
      range = true,
    }

    map('goe', ":GoIfErr<CR>", "Go handle err")
    map('gor', ":GoGenReturn<CR>", "Go generate return")
    map('gofs', ":GoFillStruct<CR>", "Go fill struct")
    map('gofw', ":GoFillSwitch<CR>", "Go fill switch")
    map('gofp', ":GoFixPlurals<CR>", "Go fill plurals")
    map('gota', ":GoAddTag<CR>", "Go add tag")
    map('gotd', ":GoRmTag<CR>", "Go delete tag")
    map('gotc', ":GoClearTag<CR>", "Go clear tag")
    map('goi', ":GoImpl<space>", "Go implement interface", { silent = false })
  end
end

-- fix showing some keywords as constants in some lsps
vim.api.nvim_create_autocmd('LspTokenUpdate', {
  callback = function(args)
    local token = args.data.token

    if (token.modifiers.readonly and token.modifiers.defaultLibrary) then
      local trees_info = vim.treesitter.get_captures_at_pos(args.buf, token.line, token.start_col)

      for _, tres_info in ipairs(trees_info) do
        if tres_info.capture == 'constant.builtin' then
          vim.lsp.semantic_tokens.highlight_token(
            token, args.buf, args.data.client_id, '@constant.builtin.go', {
              priority = 200,
            }
          )
        end
      end
    end
    if (token.type == "variable") then
      local trees_info = vim.treesitter.get_captures_at_pos(args.buf, token.line, token.start_col)

      -- print("got varialbe", vim.inspect(token), vim.inspect(trees_info))

      for _, tres_info in ipairs(trees_info) do
        if tres_info.capture == 'field' or tres_info.capture == 'property' then
          vim.lsp.semantic_tokens.highlight_token(
            token, args.buf, args.data.client_id, '@property.go', {
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
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      hints = {
        assignVariableTypes = false,
        compositeLiteralFields = false,
        compositeLiteralTypes = false,
        constantValues = true,
        functionTypeParameters = false,
        parameterNames = false,
        rangeVariableTypes = false,
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
  experimental = {
    ghost_text = false,
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
    -- { name = 'cmp_tabnine' },
    { name = "copilot" },
    { name = 'buffer' },
  },
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  function(evt)
    local entry = evt.entry
    local item = entry:get_completion_item()
    if item == nil or item.cmp == nil then
      return
    end


    if item.insertText ~= nil and string.len(item.insertText) > 1 and (item.cmp.kind_text == 'Codeium' or item.cmp.kind_text == 'Copilot') then
      -- If the last input character is an opening bracket, add the closing bracket
      local last_char = item.insertText:sub(-1)
      if last_char == '(' then
        vim.api.nvim_input(')')
      elseif last_char == '{' then
        vim.api.nvim_input('}')
      elseif last_char == '[' then
        vim.api.nvim_input(']')
      end
      vim.schedule(function()
        vim.api.nvim_command('normal! i')
      end)
      return
    end

    return cmp_autopairs.on_confirm_done()(evt)
  end
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

vim.diagnostic.config({
  virtual_text = false,
})
require("lsp_lines").setup()

require("nvim-surround").setup {}
