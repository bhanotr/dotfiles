-- ============================================================================
-- Basic Settings
-- ============================================================================

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.showcmd = true
vim.opt.wildmenu = true

-- Search
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Performance
vim.opt.lazyredraw = true
vim.opt.updatetime = 300

-- Backup and Undo
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand('~/.config/nvim/undo')

-- Split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Visual block mode
vim.opt.virtualedit = 'block'

-- Clipboard (works out of the box with wl-clipboard)
vim.opt.clipboard = 'unnamedplus'

-- Leader key
vim.g.mapleader = ' '

-- ============================================================================
-- Plugin Manager (lazy.nvim)
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme gruvbox]])
    end,
  },

  -- FZF
  {
    "junegunn/fzf",
    build = "./install --bin",
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
  },

  -- Essential plugins
  "tpope/vim-commentary",
  "tpope/vim-surround",
  "tpope/vim-fugitive",

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "lua", "python", "java", "rust", "bash", "cuda" },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
})

-- ============================================================================
-- LSP Configuration
-- ============================================================================

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "clangd", "pyright" },
  automatic_installation = true,
})

-- Get capabilities for autocompletion
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup LSP servers using vim.lsp.config (new API)
local servers = { 'clangd', 'pyright', 'rust_analyzer', 'jdtls' }
for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    capabilities = capabilities,
  })
  vim.lsp.enable(server)
end

-- LSP Keybindings
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- ============================================================================
-- Autocompletion
-- ============================================================================

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- ============================================================================
-- Key Mappings
-- ============================================================================

local keymap = vim.keymap.set

-- General
keymap('n', '<leader>w', ':w<CR>')
keymap('n', '<leader>q', ':q<CR>')
keymap('n', '<leader>h', ':nohlsearch<CR>')

-- Window navigation
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- Splits
keymap('n', '<leader>vs', ':vsplit<CR>')
keymap('n', '<leader>hs', ':split<CR>')

-- Buffer navigation
keymap('n', '<leader>n', ':bnext<CR>')
keymap('n', '<leader>p', ':bprevious<CR>')
keymap('n', '<leader>d', ':bdelete<CR>')

-- Make Y behave consistently
keymap('n', 'Y', 'y$')

-- Keep cursor centered
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')
keymap('n', '<C-d>', '<C-d>zz')
keymap('n', '<C-u>', '<C-u>zz')

-- Visual mode indent
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- FZF keybindings
keymap('n', '<leader>ff', ':Files<CR>')
keymap('n', '<leader>fg', ':GFiles<CR>')
keymap('n', '<leader>fb', ':Buffers<CR>')
keymap('n', '<leader>fl', ':Lines<CR>')
keymap('n', '<leader>fr', ':Rg<CR>')
keymap('n', '<leader>fh', ':History<CR>')
keymap('n', '<leader>fc', ':Commands<CR>')
keymap('n', '<leader>fm', ':Marks<CR>')

-- Git (Fugitive)
keymap('n', '<leader>gs', ':Git<CR>')
keymap('n', '<leader>gc', ':Git commit<CR>')
keymap('n', '<leader>gp', ':Git push<CR>')
keymap('n', '<leader>gl', ':Git log<CR>')
keymap('n', '<leader>gd', ':Gdiffsplit<CR>')

-- ============================================================================
-- Autocommands
-- ============================================================================

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand('~/.config/nvim/undo')
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p')
end

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- ============================================================================
-- LSP Server Installation
-- ============================================================================
-- After opening nvim:
-- :Mason                    Open Mason installer
-- :LspInfo                  Check LSP status
-- :checkhealth              Verify everything is working
