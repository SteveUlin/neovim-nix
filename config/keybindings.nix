let
  defaultKeymap = {
    options = { silent = true; noremap = true; };
    mode = "n";
  };
in
{
  keymaps = map (keymap: defaultKeymap // keymap) [
    # Visual Movement
    {
      key = "k";
      mode = ["n" "v"];
      action = "v:count == 0 ? 'gk' : 'k'";
      options.expr = true;
    }
    {
      key = "j";
      mode = ["n" "v"];
      action = "v:count == 0 ? 'gj' : 'j'";
      options.expr = true;
    }
    # LSP
    {
      key = "<leader>ca";
      action = ":lua vim.lsp.buf.code_action()<CR>";
      options.desc = "Code Action";
    }
    {
      key = "<leader>ce";
      action = ":lua vim.lsp.diagnostic.show_line_diagnostics()<CR>";
      options.desc = "Show Line Diagnostics";
    }
    {
      key = "<leader>cd";
      action = ":Telescope lsp_definitions<CR>";
      options.desc = "LSP Definition";
    }
    {
      key = "<leader>cD";
      action = ":Telescope lsp_references<CR>";
      options.desc = "LSP References";
    }
    {
      key = "<leader>ck";
      action = ":lua vim.lsp.buf.hover()<CR>";
      options.desc = "LSP Hover";
    }
    {
      key = "<leader>cf";
      action = ":lua vim.lsp.buf.format()<CR>";
      options.desc = "LSP Format";
    }
    {
      key = "]]";
      action.__raw = "function() Snacks.words.jump(vim.v.count1) end";
      options.desc = "Next Reference";
    }
    {
      key = "[[";
      action.__raw = "function() Snacks.words.jump(-vim.v.count1) end";
      options.desc = "Previous Reference";
    }

    # Bufsurf
    {
      key = "]b";
      action = ":BufSurfForward<CR>";
      options.desc = "Next Buffer";
    }
    {
      key = "[b";
      action = ":BufSurfBack<CR>";
      options.desc = "Previous Buffer";
    }

    # Notes
    {
      key = "<leader>ne";
      action = ":Telescope file_browser path=~/notes select_buffer=true<CR>";
      options.desc = "Explore Notes";
    }
    {
      key = "<leader>nt";
      action = ":e ~/notes/todo.norg<CR>";
      options.desc = "Open Todo";
    }
    {
      key = "<leader>fs";
      action = ":write<CR>";
      options.desc = "Save File";
    }


    {
      key = "<leader>q";
      action = ":close<CR>";
      options.desc = "Quit";
    }

    # Window
    {
      key = "<leader>wh";
      action = "<C-w>h";
      options.desc = "Move Left";
    }
    {
      key = "<leader>wj";
      action = "<C-w>j";
      options.desc = "Move Down";
    }
    {
      key = "<leader>wk";
      action = "<C-w>k";
      options.desc = "Move Up";
    }
    {
      key = "<leader>wl";
      action = "<C-w>l";
      options.desc = "Move Right";
    }
    {
      key = "<leader>ws";
      action = "<C-w>s";
      options.desc = "Split Window";
    }
    {
      key = "<leader>wv";
      action = "<C-w>v";
      options.desc = "Vertical Split Window";
    }
    {
      key = "<leader>ww";
      action = "<C-w>w";
      options.desc = "Next Window";
    }

    # Yank
    {
      key = "<leader>yp";
      action = ":let @+ = expand('%:p')<CR>";
      options.desc = "Copy File Path";
    }

    # --- Snack Pickers ---

    # Top Pickers
    {
      options.desc = "Smart Find Files";
      key = "<leader><space>";
      action.__raw = "function() Snacks.picker.smart({focus='list'}) end";
    }
    {
      options.desc = "Buffers";
      key = "<leader>,";
      action.__raw = "function() Snacks.picker.buffers({focus='list'}) end";
    }
    {
      options.desc = "Grep";
      key = "<leader>/";
      action.__raw = "function() Snacks.picker.grep() end";
    }
    {
      options.desc = "Command History";
      key = "<leader>:";
      action.__raw = "function() Snacks.picker.command_history() end";
    }
    {
      options.desc = "Notification History";
      key = "<leader>n";
      action.__raw = "function() Snacks.picker.notifications({focus='list'}) end";
    }
    {
      options.desc = "File Explorer";
      key = "<leader>e";
      # Focus the list if it exists, otherwise open the explorer
      action.__raw = ''
        function ()
          local res = Snacks.picker.get({source = "explorer"})
          if #res > 0
          then
            res[1]:focus("list")
          else
            Snacks.explorer({cwd = true})
          end
        end
      '';
    }

    # Find
    {
      options.desc = "Find File";
      key = "<leader>ff";
      action.__raw = "function() Snacks.picker.files() end";
    }
    {
      options.desc = "Recent Files";
      key = "<leader>fr";
      action = ":lua Snacks.picker.recent({focus='list'})<CR>";
    }

    # Git
    {
      options.desc = "Git Status";
      key = "<leader>gs";
      action.__raw = "function() Snacks.picker.git_status() end";
    }
    {
      options.desc = "Git Diff";
      key = "<leader>gd";
      action.__raw = "function() Snacks.picker.git_diff() end";
    }
    {
      options.desc = "Git Log";
      key = "<leader>gl";
      action.__raw = "function() Snacks.picker.git_log() end";
    }

    # Grep
    {
      options.desc = "Buffer Lines";
      key = "<leader>sb";
      action.__raw = "function() Snacks.picker.lines() end";
    }
    {
      options.desc = "Grep Open Buffers";
      key = "<leader>fb";
      action.__raw = "function() Snacks.picker.grep_buffers() end";
    }
    {
      options.desc = "Grep Word Under Cursor";
      key = "<leader>sw";
      action.__raw = "function() Snacks.picker.grep_word() end";
    }

    # Search
    {
      options.desc = "Undo History";
      key = "<leader>su";
    }
  ];
}
