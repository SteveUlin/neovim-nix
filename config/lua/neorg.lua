require('neorg').setup {
  load = {
    ['core.defaults'] = {},
    ['core.concealer'] = {},
    ['core.integrations.image'] = {},
    ['core.integrations.telescope'] = {},
    -- Install a zen mode
    -- ['core.presenter'] = {},
    ['core.esupports.metagen'] = {
      config = {
        type = "auto",
      },
    },
    ['core.presenter'] = {
      config = {
        zen_mode = "zen-mode",
      },
    },
    ['core.dirman'] = {
      config = {
        workspaces = {
          notes = '~/notes',
        },
        index = 'index.norg',
        default_workspace = 'notes',
      },
    },
  },
}

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.norg",
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcusor = "nc"
    vim.opt_local.wrap = false
  end,
})

