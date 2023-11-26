local wk = require("which-key")

wk.setup {
  window = {
    border = "double",
  },
}

wk.register({
  f = { name = "File" },
  n = { name = "Notes" },
  w = { name = "Window" },
}, { prefix = "<leader>" })
