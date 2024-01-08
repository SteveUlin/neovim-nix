let
  defaultKeymap = {
    options = { silent = true; noremap = true; };
    mode = "n";
  };
in
{
  keymaps = map (keymap: defaultKeymap // keymap) [
    # LSP
    {
      key = "<Leader>ca";
      action = ":lua vim.lsp.buf.code_action()<CR>";
      options.desc = "Code Action";
    }
    {
      key = "<Leader>ce";
      action = "lua vim.lsp.diagnostic.show_line_diagnostics()<CR>";
      options.desc = "Show Line Diagnostics";
    }
    {
      key = "<Leader>cd";
      action = ":Telescope lsp_definitions<CR>";
      options.desc = "LSP Definition";
    }
    {
      key = "<Leader>cD";
      action = ":Telescope lsp_references<CR>";
      options.desc = "LSP References";
    }
    {
      key = "<Leader>ck";
      action = ":lua vim.lsp.buf.hover()<CR>";
      options.desc = "LSP Hover";
    }

    # Notes
    {
      key = "<Leader>ne";
      action = ":Telescope file_browser path=~/notes select_buffer=true<CR>";
      options.desc = "Explore Notes";
    }
    {
      key = "<Leader>nt";
      action = ":e ~/notes/todo.norg<CR>";
      options.desc = "Open Todo";
    }

    # File / Find
    {
      key = "<Leader>fs";
      action = ":write<CR>";
      options.desc = "Save File";
    }
    {
      key = "<Leader>fe";
      action = ":Telescope file_browser path=%:p:h select_buffer=true<CR>";
      options.desc = "File Explorer";
    }
    {
      key = "<Leader>fE";
      action = ":Telescope file_browser<CR>";
      options.desc = "File Explorer -- Current Directory";
    }
    {
      key = "<Leader>ff";
      action = ":Telescope find_files<CR>";
      options.desc = "Find File";
    }
    {
      key = "<Leader>fg";
      action = ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>";
      options.desc = "Live Grep";
    }
    {
      key = "<Leader>fw";
      action = ":lua require('telescope-live-grep-args.shortcuts').grep_word_under_cursor()<CR>";
      options.desc = "Grep Word Under Cursor";
    }
    {
      key = "<Leader>fh";
      action = ":Telescope oldfiles<CR>";
      options.desc = "Open Recent File";
    }
    {
      key = "<Leader>fr";
      action = ":Telescope frecency<CR>";
      options.desc = "Frecency";
    }

    {
      key = "<Leader>q";
      action = ":quit<CR>";
      options.desc = "Quit";
    }

    # Window
    {
      key = "<Leader>wh";
      action = "<C-w>h";
      options.desc = "Move Left";
    }
    {
      key = "<Leader>wj";
      action = "<C-w>j";
      options.desc = "Move Down";
    }
    {
      key = "<Leader>wk";
      action = "<C-w>k";
      options.desc = "Move Up";
    }
    {
      key = "<Leader>wl";
      action = "<C-w>l";
      options.desc = "Move Right";
    }
    {
      key = "<Leader>ws";
      action = "<C-w>s";
      options.desc = "Split Window";
    }
    {
      key = "<Leader>wv";
      action = "<C-w>v";
      options.desc = "Vertical Split Window";
    }
    {
      key = "<Leader>ww";
      action = "<C-w>w";
      options.desc = "Next Window";
    }

    # Yank
    {
      key = "<Leader>yp";
      action = ":let @+ = expand('%:p')<CR>";
      options.desc = "Copy File Path";
    }

  ];
}
