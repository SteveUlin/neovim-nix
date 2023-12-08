require("sniprun").setup {
  interpreter_options = {
    neorg_original = {
      use_on_filetypes = {"norg"},
    },
  },
  display = {
    "NvimNotify",
  }
}
