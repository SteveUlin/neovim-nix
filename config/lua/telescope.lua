local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")

require("telescope").load_extension "frecency"
require("telescope").load_extension "live_grep_args"

telescope.setup {
  pickers = {},
  extensions = {
    file_browser = {
      hijack_netrw = true,
    },
    live_grep_args = {
      mappings = {
        i = {
          ["<c-k>"] = lga_actions.quote_prompt(),
          ["<c-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
    },
  },
}

