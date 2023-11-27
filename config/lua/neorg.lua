require('neorg').setup {
  load = {
    ['core.defaults'] = {},
    ['core.concealer'] = {},
    ['core.integrations.telescope'] = {},
    -- Install a zen mode
    -- ['core.presenter'] = {},
    ['core.esupports.metagen'] = {
      config = {
        type = "auto",
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
  }
}

