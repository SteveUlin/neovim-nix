local telescope = require("telescope")

telescope.setup {
  extensions = {
    file_browser = {
      hijack_netrw = true,
    },
  },
}
