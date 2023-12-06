-- jk is escape
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', 'jk', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', 'jk', '<C-\\><C-n>', { noremap = true, silent = true })

-- Swap Splits
vim.api.nvim_set_keymap('n', '<Leader>wh', '<C-w>h', { noremap = true, silent = true, desc = "Move left" })
vim.api.nvim_set_keymap('n', '<Leader>wj', '<C-w>j', { noremap = true, silent = true, desc = "Move down" })
vim.api.nvim_set_keymap('n', '<Leader>wk', '<C-w>k', { noremap = true, silent = true, desc = "Move up" })
vim.api.nvim_set_keymap('n', '<Leader>wl', '<C-w>l', { noremap = true, silent = true, desc = "Move right" })

-- Create splits
vim.api.nvim_set_keymap('n', '<Leader>wv', ':vsplit<CR>',
  { noremap = true, silent = true, desc = "Create vertical split" })
vim.api.nvim_set_keymap('n', '<Leader>ws', ':split<CR>',
  { noremap = true, silent = true, desc = "Create vertical split" })

vim.api.nvim_set_keymap(
  "n",
  "<space>q",
  ":quit<CR>",
  { noremap = true, silent = true, desc = "File Quit" }
)

-- File 
vim.api.nvim_set_keymap(
  "n",
  "<space>fs",
  ":write<CR>",
  { noremap = true, silent = true, desc = "File Save" }
)
vim.api.nvim_set_keymap(
  "n",
  "<space>fe",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true, silent = true, desc = "File Explorer" }
)
vim.api.nvim_set_keymap(
  "n",
  "<space>ff",
  ":Telescope find_files<CR>",
  { noremap = true, silent = true, desc = "File Find" }
)
vim.api.nvim_set_keymap(
  "n",
  "<space>fg",
  ":Telescope live_grep<CR>",
  { noremap = true, silent = true, desc = "File Grep" }
)
vim.api.nvim_set_keymap(
  "n",
  "<space>fr",
  ":Telescope frecency<CR>",
  { noremap = true, silent = true, desc = "File Frencency" }
)
vim.api.nvim_set_keymap(
  "n",
  "<space>fh",
  ":Telescope oldfiles<CR>",
  { noremap = true, silent = true, desc = "File Recent" }
)
vim.api.nvim_set_keymap(
  "n",
  "<space>fyp",
  ':let @" = expand("%")<CR>',
  { noremap = true, silent = true, desc = "File Yank Path" }
)

-- LSP
vim.api.nvim_set_keymap(
  "n",
  "<space>cd",
  ":Telescope lsp_definitions<CR>",
  { noremap = true, silent = true, desc = "LSP Definitions" }
)
vim.api.nvim_set_keymap(
  "n",
  "<space>cD",
  ":Telescope lsp_references<CR>",
  { noremap = true, silent = true, desc = "LSP References" }
)
vim.api.nvim_set_keymap(
  "n",
  "<space>ch",
  ":lua vim.lsp.buf.hover()<CR>",
  { noremap = true, silent = true, desc = "LSP Hover" }
)
vim.api.nvim_set_keymap(
  "n",
  "<space>ck",
  ":lua vim.diagnostic.open_float()<CR>",
  { noremap = true, silent = true, desc = "LSP Hover" }
)

-- Notes
vim.api.nvim_set_keymap(
  "n",
  "<space>ne",
  ":Telescope file_browser path=~/notes/ select_buffer=true<CR>",
  { noremap = true, silent = true, desc = "Notes Explorer" }
)
vim.api.nvim_set_keymap(
  "n",
  "<space>nw",
  ":Neorg workspace notes<CR>",
  { noremap = true, silent = true, desc = "Notes Explorer" }
)

vim.api.nvim_set_keymap(
  "n",
  "<space>p",
  ':lua require("nabla").popup()<CR>',
  { noremap = true, silent = true, desc = "Show Math" }
)

