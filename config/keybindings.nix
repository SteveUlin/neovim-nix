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
      options.desc = "🔧 Code Action";
    }
    {
      key = "<leader>ce";
      action = ":lua vim.diagnostic.open_float()<CR>";
      options.desc = "⚠️  Show Line Diagnostics";
    }
    {
      key = "<leader>ck";
      action = ":lua vim.lsp.buf.hover()<CR>";
      options.desc = "📖 LSP Hover";
    }
    {
      key = "<leader>cr";
      action = ":lua vim.lsp.buf.rename()<CR>";
      options.desc = "✏️  Rename Symbol";
    }
    {
      key = "<leader>cf";
      action.__raw = "function() require('conform').format({ async = true, lsp_format = 'fallback' }) end";
      options.desc = "🪶 Format Buffer";
    }
    {
      key = "<leader>ci";
      action.__raw = "function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 }) end";
      options.desc = "💡 Toggle Inlay Hints";
    }
    {
      key = "<leader>ct";
      action.__raw = "function() require('tiny-inline-diagnostic').toggle() end";
      options.desc = "🔘 Toggle Diagnostic Text";
    }
    {
      key = "<leader>ch";
      action.__raw = "function() _toggle_blink_signature() end";
      options.desc = "🪪 Toggle Signature Help";
    }
    {
      key = "]]";
      action.__raw = "function() Snacks.words.jump(vim.v.count1) end";
      options.desc = "🔁 Next Reference";
    }
    {
      key = "[[";
      action.__raw = "function() Snacks.words.jump(-vim.v.count1) end";
      options.desc = "🔁 Previous Reference";
    }
    {
      key = "[x";
      action.__raw = "function() require('treesitter-context').go_to_context(vim.v.count1) end";
      options.desc = "⬆️  Jump to Context";
    }

    # Claude Code (1:1 pairing: nvim spawns its claude in a Zellij pane)
    {
      key = "<leader>ac";
      action = ":ClaudeCode<CR>";
      options.desc = "🤖 Spawn Claude Pane";
    }
    {
      key = "<leader>as";
      mode = ["v"];
      action = ":ClaudeCodeSend<CR>";
      options.desc = "📤 Send Selection to Claude";
    }
    {
      key = "<leader>ab";
      action = ":ClaudeCodeAdd %<CR>";
      options.desc = "📥 Add Buffer to Claude";
    }
    {
      key = "<leader>aL";
      mode = ["v"];
      action.__raw = ''
        function()
          local s = vim.fn.line("v")
          local e = vim.fn.line(".")
          if s > e then s, e = e, s end
          vim.cmd(string.format("ClaudeCodeAdd %% %d %d", s, e))
        end
      '';
      options.desc = "🔢 Add Line Range to Claude";
    }
    {
      key = "<leader>am";
      action = ":ClaudeCodeSelectModel<CR>";
      options.desc = "🤖 Select Claude Model";
    }
    {
      key = "<leader>ax";
      # Toggle visibility of the nvim-live highlights by hiding/restoring their
      # highlight groups — the extmarks stay put, so a re-toggle brings them all
      # back (and reveals any drawn while hidden).
      action.__raw = ''
        (function()
          local hidden, saved = false, nil
          return function()
            hidden = not hidden
            if hidden then
              saved = {
                hl = vim.api.nvim_get_hl(0, { name = 'ClaudeLiveHL' }),
                note = vim.api.nvim_get_hl(0, { name = 'ClaudeLiveNote' }),
              }
              vim.api.nvim_set_hl(0, 'ClaudeLiveHL', {})
              vim.api.nvim_set_hl(0, 'ClaudeLiveNote', {})
            else
              vim.api.nvim_set_hl(0, 'ClaudeLiveHL', saved and saved.hl or {})
              vim.api.nvim_set_hl(0, 'ClaudeLiveNote', saved and saved.note or {})
            end
            vim.notify('Claude highlights: ' .. (hidden and 'hidden' or 'shown'))
          end
        end)()
      '';
      options.desc = "🌓 Toggle Claude Highlights";
    }
    {
      key = "<leader>aa";
      action = ":ClaudeCodeDiffAccept<CR>";
      options.desc = "✅ Accept Claude Diff";
    }
    {
      key = "<leader>ad";
      action = ":ClaudeCodeDiffDeny<CR>";
      options.desc = "❌ Reject Claude Diff";
    }
    {
      key = "<leader>a?";
      action = ":ClaudeCodeStatus<CR>";
      options.desc = "❓ Claude Status";
    }

    # Bufsurf
    {
      key = "]b";
      action = ":BufSurfForward<CR>";
      options.desc = "▶️  Next Buffer";
    }
    {
      key = "[b";
      action = ":BufSurfBack<CR>";
      options.desc = "◀️  Previous Buffer";
    }
    {
      key = "<leader>bd";
      action.__raw = "function() Snacks.bufdelete() end";
      options.desc = "🗑️  Close Buffer";
    }

    # Notes
    {
      key = "<leader>ne";
      action.__raw = "function() Snacks.explorer({cwd = '~/notes'}) end";
      options.desc = "📁 Explore Notes";
    }
    {
      key = "<leader>nt";
      action = ":e ~/notes/todo.norg<CR>";
      options.desc = "✏️  Open Todo";
    }
    {
      key = "<leader>fs";
      action = ":write<CR>";
      options.desc = "💾 Save File";
    }


    {
      key = "<leader>q";
      action = ":close<CR>";
      options.desc = "✖️  Quit";
    }

    # Window
    {
      key = "<leader>wh";
      action = "<C-w>h";
      options.desc = "⬅️  Move Left";
    }
    {
      key = "<leader>wj";
      action = "<C-w>j";
      options.desc = "⬇️  Move Down";
    }
    {
      key = "<leader>wk";
      action = "<C-w>k";
      options.desc = "⬆️  Move Up";
    }
    {
      key = "<leader>wl";
      action = "<C-w>l";
      options.desc = "➡️  Move Right";
    }
    {
      key = "<leader>ws";
      action = "<C-w>s";
      options.desc = "➖ Split Horizontal";
    }
    {
      key = "<leader>wv";
      action = "<C-w>v";
      options.desc = "➕ Split Vertical";
    }
    {
      key = "<leader>ww";
      action = "<C-w>w";
      options.desc = "🔁 Next Window";
    }

    # Yank
    {
      key = "<leader>yp";
      action = ":let @+ = expand('%:p')<CR>";
      options.desc = "📋 Copy File Path";
    }

    # Dashboard & Help
    {
      key = "<leader>h";
      action.__raw = "function() Snacks.dashboard() end";
      options.desc = "🏠 Open Dashboard";
    }
    {
      key = "<leader>?";
      action = ":e ~/neovim-nix/CHEATSHEET.md<CR>";
      options.desc = "❓ Open Cheat Sheet";
    }

    # --- Snack Pickers ---

    # Top Pickers
    {
      options.desc = "🔭 Smart Find Files";
      key = "<leader><space>";
      action.__raw = "function() Snacks.picker.smart({focus='list'}) end";
    }
    {
      options.desc = "🗂️  Buffers";
      key = "<leader>,";
      action.__raw = "function() Snacks.picker.buffers({focus='list'}) end";
    }
    {
      options.desc = "🔍 Grep";
      key = "<leader>/";
      action.__raw = "function() Snacks.picker.grep() end";
    }
    {
      options.desc = "📜 Command History";
      key = "<leader>:";
      action.__raw = "function() Snacks.picker.command_history() end";
    }
    {
      options.desc = "🔔 Notification History";
      key = "<leader>sn";
      action.__raw = "function() Snacks.picker.notifications({focus='list'}) end";
    }
    {
      options.desc = "📁 File Explorer";
      key = "<leader>e";
      # Focus the list if it exists, otherwise open the explorer
      action.__raw = ''
        function ()
          local res = Snacks.picker.get({source = "explorer"})
          if #res > 0
          then
            res[1]:focus("list")
          else
            Snacks.explorer({cwd = vim.fn.expand('%:p:h')})
          end
        end
      '';
    }
    {
      options.desc = "🔁 Resume Picker";
      key = "<leader>;";
      action.__raw = "function() Snacks.picker.resume() end";
    }

    # Find
    {
      options.desc = "📂 Find File";
      key = "<leader>ff";
      action.__raw = "function() Snacks.picker.files() end";
    }
    {
      options.desc = "🕒 Recent Files";
      key = "<leader>fr";
      action = ":lua Snacks.picker.recent({focus='list'})<CR>";
    }

    # Git
    {
      options.desc = "📊 Jujutsu Status";
      key = "<leader>gs";
      action.__raw = ''
        function()
          Snacks.picker({
            title = "Jujutsu Status",
            finder = function(opts, ctx)
              return require("snacks.picker.source.proc").proc(ctx:opts({
                cmd = "jj",
                args = { "diff", "--summary" },
                notify = true,
                transform = function(item)
                  local status, file = item.text:match("^(%a)%s+(.+)$")
                  if not status then return false end
                  item.status = status .. " "
                  item.file = file
                  return item
                end,
              }), ctx)
            end,
            format = "git_status",
            preview = function(ctx)
              if not ctx.item.file then return end
              if ctx.item.status:find("^A") then
                require("snacks.picker.preview").file(ctx)
              else
                require("snacks.picker.preview").cmd(
                  { "jj", "diff", "--git", "--", ctx.item.file },
                  ctx,
                  { ft = "diff" }
                )
              end
            end,
            confirm = "jump",
          })
        end
      '';
    }
    {
      options.desc = "⏭️  Next Hunk";
      key = "]h";
      action.__raw = "function() require('vcsigns.actions').hunk_next(0, vim.v.count1) end";
    }
    {
      options.desc = "⏮️  Previous Hunk";
      key = "[h";
      action.__raw = "function() require('vcsigns.actions').hunk_prev(0, vim.v.count1) end";
    }
    {
      options.desc = "↩️  Undo Hunk";
      key = "<leader>gu";
      action.__raw = "function() require('vcsigns.actions').hunk_undo(0) end";
    }
    {
      options.desc = "👁️  Toggle Inline Diff";
      key = "<leader>go";
      action.__raw = "function() require('vcsigns.actions').toggle_hunk_diff(0) end";
    }
    {
      options.desc = "⤵️  Diff vs Newer Commit";
      key = "]r";
      action.__raw = "function() require('vcsigns.actions').target_newer_commit(0, vim.v.count1) end";
    }
    {
      options.desc = "⤴️  Diff vs Older Commit";
      key = "[r";
      action.__raw = "function() require('vcsigns.actions').target_older_commit(0, vim.v.count1) end";
    }
    {
      options.desc = "🎯 Inside Hunk";
      key = "ih";
      mode = ["o" "x"];
      action.__raw = "function() require('vcsigns.textobj').select_hunk(0) end";
    }

    # Grep
    {
      options.desc = "📃 Buffer Lines";
      key = "<leader>sb";
      action.__raw = "function() Snacks.picker.lines() end";
    }
    {
      options.desc = "🔎 Grep Open Buffers";
      key = "<leader>fb";
      action.__raw = "function() Snacks.picker.grep_buffers() end";
    }
    {
      options.desc = "🔎 Grep Word Under Cursor";
      key = "<leader>sw";
      action.__raw = "function() Snacks.picker.grep({ search = vim.fn.expand('<cword>') }) end";
    }
    {
      options.desc = "📌 Todo Comments";
      key = "<leader>st";
      action.__raw = "function() Snacks.picker.todo_comments() end";
    }

    # Search
    {
      options.desc = "↩️  Undo History";
      key = "<leader>su";
      action.__raw = "function() Snacks.picker.undo_history() end";
    }

    # LSP
    {
      options.desc = "🎯 GoTo Definition";
      key = "<leader>cd";
      action.__raw = "function() Snacks.picker.lsp_definitions() end";
    }
    {
      options.desc = "🪧 GoTo Declaration";
      key = "<leader>cD";
      action.__raw = "function() Snacks.picker.lsp_declarations() end";
    }
    {
      options.desc = "🔁 GoTo References";
      key = "<leader>cR";
      action.__raw = "function() Snacks.picker.lsp_references() end";
    }
    {
      options.desc = "⬇️  GoTo Implementation";
      key = "<leader>cI";
      action.__raw = "function() Snacks.picker.lsp_implementations() end";
    }
    {
      options.desc = "🏷️  GoTo Type Definition";
      key = "<leader>cy";
      action.__raw = "function() Snacks.picker.lsp_type_definitions() end";
    }
    {
      options.desc = "📃 LSP Symbols";
      key = "<leader>cs";
      action.__raw = "function() Snacks.picker.lsp_symbols() end";
    }
    {
      options.desc = "🌐 LSP Workspace Symbols";
      key = "<leader>cS";
      action.__raw = "function() Snacks.picker.lsp_workspace_symbols() end";
    }
    {
      options.desc = "🧘 Toggle Zen Mode";
      key = "<leader>z";
      action.__raw = "function() Snacks.zen() end";
    }
  ];
}
