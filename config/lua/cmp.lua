local cmp = require('cmp')

-- require("copilot").setup {
--   suggestion = { enabled = false },
--   panel = { enabled = false },
-- }
-- require("copilot_cmp").setup {}

local kind_icons = {
    Class = "",
    Color = "󰏘",
    Constant = "󰏿",
    Constructor = "",
    Enum = "",
    EnumMember = "",
    Event = "",
    Field = "󰜢",
    File = "󰈙",
    Folder = "󰉋",
    Function = "󰊕",
    Interface = "",
    Keyword = "󰌋",
    Method = "󰆧",
    Module = "",
    Operator = "󰆕",
    Property = "",
    Reference = "󰈇",
    Snippet = "",
    Struct = "󰙅",
    Text = "󰉿",
    Unit = "󰑭",
    Value = "󰎠",
    Variable = "󰫧",
}

cmp.setup {
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert {
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<TAB>'] = cmp.mapping.confirm { select = true },
      ['<C-j>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.snippet.jumpable(1) then
          vim.snippet.jump(1)
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<C-k>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
        cmp.select_prev_item()
        elseif vim.snippet.jumpable(-1) then
          vim.snippet.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
  },
  sources = cmp.config.sources {
    -- { name = 'copilot' },
    { name = 'treesitter' },
    { name = 'latex_symbols' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'spell' },
    { name = 'path' },
    { name = 'emoji' },
  },
  formatting = {
    fields = { "kind", "abbr", "menu", },
    format = function(entry, item)
      item.kind = string.format("%s", kind_icons[item.kind])

      item.menu = ({
        buffer = "[Buff]",
        nvim_lsp = "[LSP]",
        path = "[Path]",
        luasnip = "[Snip]",
        nvim_lua = "[Lua]",
        latex = "[Tex]",
        spell = "[Spell]",
      })[entry.source.name]
      return item
    end,
  },
}

