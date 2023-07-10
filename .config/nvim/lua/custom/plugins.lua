-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      { 'folke/neodev.nvim' },
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "neovim/nvim-lspconfig",
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
          "numToStr/Comment.nvim",        -- Optional
          "nvim-telescope/telescope.nvim" -- Optional
        },
        config = function()
          local navbuddy = require("nvim-navbuddy")
          navbuddy.setup {
            lsp = {
              auto_attach = true
            },
            window = {
              position = "70%",
              size = "40%",
              sections = {
                left = {
                  size = "20%",
                  border = nil, -- You can set border style for each section individually as well.
                },
                mid = {
                  size = "30%",
                  border = nil,
                },
                right = {
                  -- No size option for right most section. It fills to
                  -- remaining area.
                  border = nil,
                  preview = "leaf", -- Right section can show previews too.
                  -- Options: "leaf", "always" or "never"
                }
              },
            }
          }
        end
      }
    },
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-path',
      "rafamadriz/friendly-snippets"
    },
  },
  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',       opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
    config = function()
      require("onedarkpro").setup({
        highlights = {
          -- ["@property.go"] = { fg = "#abb2bf" },
          ["@namespace.go"] = { fg = "#2bbac5" },
          ["@lsp.type.namespace.go"] = { fg = "#2bbac5" },
          ["@lsp.typemod.modifier.readonly.go"] = { fg = "#d19a66" },
          ["@function.builtin.go"] = { fg = "#dd5ba5" },
          ["@number.go"] = { fg = "#768bf3" },
          ["@lsp.type.parameter.go"] = { fg = "#ef9062" },
          ["@property.go"] = { fg = "#e082a2" },
          ["@lsp.typemod.function.defaultLibrary.go"] = { fg = "#47b8c9", style = "italic" },
          ["@constant.builtin.go"] = { fg = "#c678dd", style = "italic" },
          ["@operator.go"] = { fg = "#c678dd", style = "bold" }
        },

        styles = {
          types = "italic",
          methods = "NONE",
          numbers = "NONE",
          strings = "NONE",
          comments = "NONE",
          keywords = "bold,italic",
          constants = "NONE",
          functions = "NONE",
          operators = "NONE",
          variables = "NONE",
          parameters = "NONE",
          conditionals = "italic",
          virtual_text = "NONE",
        }
      })
      vim.cmd.colorscheme 'onedark'
    end,
  },
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  { 'nvim-tree/nvim-web-devicons' },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    config = function()
      -- local navic = require('nvim-navic')
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'onedark',
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        winbar = {
          lualine_c = { 'filename',
            -- {
            --   function()
            --     return navic.get_location()
            --   end,
            --   cond = function()
            --     return navic.is_available()
            --   end
            -- }
          },

          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        tabline = {

        }
      }
    end
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim',          version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
  },
  { 'nvim-treesitter/nvim-treesitter-context' },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    'folke/trouble.nvim',
    opts = {
      position = 'right',
    }
  },
  {
    -- split/join blocks of code
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({ use_default_keymaps = false })
    end,
  },
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  { 'nvim-pack/nvim-spectre' },
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
    end,
  },
  {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline"
      },
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message"
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History"
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All"
      },
      {
        "<leader>snd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All"
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then return "<c-f>" end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" }
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then return "<c-b>" end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" }
      },
    },
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      local navic = require("nvim-navic")
      navic.setup({
        lsp = {
          auto_attach = true,
        },
        depth_limit = 3,
        depth_limit_indicator = "..",
      })
    end
  },
  { "onsails/lspkind.nvim" },
  { "windwp/nvim-autopairs" },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
  },
  { 'akinsho/toggleterm.nvim',   version = "*", config = true },
  { "zbirenbaum/copilot.lua" },
  { "zbirenbaum/copilot-cmp" },
  { "rmagatti/auto-session" },
  { "windwp/nvim-ts-autotag" },
  { "mg979/vim-visual-multi" },
  { "RRethy/vim-illuminate" },
  { "sindrets/diffview.nvim" },
  -- open/search browser
  { "dhruvasagar/vim-open-url" },
  -- treesitter based navigation
  { "drybalka/tree-climber.nvim" },
  { 'fedepujol/move.nvim' },
  { 'kevinhwang91/nvim-hlslens' },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      colors = {
        info = { "DiagnosticHint", "#2563EB" },
        hint = { "DiagnosticInfo", "#2563EB" },
      }
    }
  },
  { 'numToStr/Comment.nvim', },
  { "drybalka/tree-climber.nvim" },
  { "johmsalas/text-case.nvim" },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "jay-babu/mason-nvim-dap.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
    },
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = { "kkharji/sqlite.lua" }
  },
  { "smartpde/telescope-recent-files" },
  {
    "Bryley/neoai.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  { "chrisgrieser/nvim-spider",       lazy = true },
  {
    "jcdickinson/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
  },
  { "gbprod/cutlass.nvim" },
  { "wsdjeg/vim-fetch" },
  { 'mhartington/formatter.nvim' },
  { "jose-elias-alvarez/null-ls.nvim" },
  { "ray-x/lsp_signature.nvim" },
  { "miyakogi/conoline.vim" }
}, {})
