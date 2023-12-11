-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- The default indentation is 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Expand tabs to spaces
vim.opt.expandtab = true

-- Set space as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Never let the cursor be on the edge
vim.opt.scrolloff = 5

-- Enable spell checking for English
vim.opt.spell = true
vim.opt.spelllang = 'en'

-- Add newline to the end of files
vim.opt.eol = true

-- Use the clipboard
vim.opt.clipboard = 'unnamedplus'

-- History and backups
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Save all modifications
vim.opt.autowriteall = true
vim.opt.autoread = true
vim.opt.swapfile = false

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
-- Start with all folds open
vim.opt.foldlevelstart = 99

