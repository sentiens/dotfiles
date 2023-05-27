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
  { 'folke/which-key.nvim',          opts = {} },
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
    -- theme that uses treesitter for styles
    'ray-x/aurora',
    priority = 1000,
    config = function()
      vim.g.aurora_italic = 1
      vim.g.aurora_bold = 1
      vim.cmd.colorscheme 'aurora'
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
      local navic = require('nvim-navic')
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'onedark',
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'diff', 'diagnostics' },
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        winbar = {
          lualine_c = { 'filename', {
            function()
              return navic.get_location()
            end,
            cond = function()
              return navic.is_available()
            end
          } },

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
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

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
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
  },
  { 'nvim-treesitter/nvim-treesitter-context' },
  { 'folke/trouble.nvim' },
  {
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
  { "echasnovski/mini.pairs" },
  { 'echasnovski/mini.surround', version = '*' },
  { 'echasnovski/mini.comment',  version = '*' },
  { 'akinsho/toggleterm.nvim',   version = "*", config = true },
  {
    'tzachar/cmp-tabnine',
    build = './install.sh',
    dependencies = 'hrsh7th/nvim-cmp',
  },
  { 'ray-x/lsp_signature.nvim' },
  { "zbirenbaum/copilot.lua" },
  { "zbirenbaum/copilot-cmp" },
  { "rmagatti/auto-session" },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  { "windwp/nvim-ts-autotag" },
  { "mg979/vim-visual-multi" },
  { "RRethy/vim-illuminate" },
  { "sindrets/diffview.nvim" },
  { "dhruvasagar/vim-open-url" }
}, {})
