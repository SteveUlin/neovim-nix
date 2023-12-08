require('material').setup({
  plugins = {
    "telescope",
    "neorg",
    "nvim-cmp",
    "rainbow-delimiters",
    "which-key",
  },
})

vim.g.material_style = "deep ocean"
vim.cmd [[ colorscheme material ]]
