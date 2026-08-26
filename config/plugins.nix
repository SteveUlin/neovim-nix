{
  pkgs,
  helpers,
  lib,
  config,
  ...
}: let
  clangdPkg = pkgs.clang-tools;
in {
  config = {
    extraPlugins = with pkgs.vimPlugins; [
      async-nvim
      claudecode-nvim
      friendly-snippets
      vclib
      vcsigns
    ];

    extraConfigLua = ''
      -- Claude Code MCP server. :ClaudeCode opens claude in a new Zellij pane
      -- to the right, with CLAUDE_CODE_SSE_PORT baked in so each claude is
      -- bound 1:1 to its launching nvim (no auto-discovery free-for-all).
      require('claudecode').setup({
        terminal = {
          provider = "external",
          provider_opts = {
            external_terminal_cmd = function(cmd, env)
              local parts = { "zellij", "action", "new-pane",
                              "--direction", "right",
                              "--name", "claude",
                              "--", "env" }
              for k, v in pairs(env or {}) do
                table.insert(parts, k .. "=" .. v)
              end
              for word in cmd:gmatch("%S+") do
                table.insert(parts, word)
              end
              return parts
            end,
          },
        },
        -- Diff suggestions open in their own full-screen tab instead of
        -- splitting the working window (better on a smaller monitor); the
        -- Claude terminal is kept out of that tab so it's just the diff.
        diff_opts = {
          open_in_new_tab = true,
          hide_terminal_in_new_tab = true,
        },
      })

      require('vcsigns').setup({
        target_commit = 0,
        signs = {
          text = {
            add = '▎',
            change = '▎',
            delete_below = '▁',
            delete_above = '▔',
          },
        },
      })

      -- Jujutsu-native lualine components
      _jj_branch_cache = ""
      local function _jj_update_branch()
        vim.system(
          { "jj", "--ignore-working-copy", "log", "-r", "@", "--no-graph", "-T",
            [[if(local_bookmarks, local_bookmarks.join(" "), change_id.shortest(8))]] },
          { text = true },
          vim.schedule_wrap(function(result)
            _jj_branch_cache = result.code == 0 and vim.trim(result.stdout) or ""
          end)
        )
      end

      _jj_diff_cache = {}
      local function _jj_update_diff(bufnr)
        local file = vim.api.nvim_buf_get_name(bufnr)
        if file == "" then return end
        local cwd = vim.uv.cwd()
        if file:sub(1, #cwd + 1) == cwd .. "/" then
          file = file:sub(#cwd + 2)
        end
        vim.system(
          { "jj", "--ignore-working-copy", "diff", "--git", "--", file },
          { text = true },
          vim.schedule_wrap(function(result)
            if not vim.api.nvim_buf_is_valid(bufnr) then return end
            if result.code ~= 0 then
              _jj_diff_cache[bufnr] = nil
              return
            end
            local added, modified, removed = 0, 0, 0
            for line in result.stdout:gmatch("[^\n]+") do
              local old_n, new_n = line:match("^@@ %-%d+,?(%d*) %+%d+,?(%d*) @@")
              if old_n then
                old_n = tonumber(old_n) or 1
                new_n = tonumber(new_n) or 1
                if old_n == 0 then
                  added = added + new_n
                elseif new_n == 0 then
                  removed = removed + old_n
                else
                  local m = math.min(old_n, new_n)
                  modified = modified + m
                  added = added + math.max(new_n - old_n, 0)
                  removed = removed + math.max(old_n - new_n, 0)
                end
              end
            end
            _jj_diff_cache[bufnr] = { added = added, modified = modified, removed = removed }
          end)
        )
      end

      local _jj_au = vim.api.nvim_create_augroup("JjLualine", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
        group = _jj_au,
        callback = function()
          _jj_update_branch()
          _jj_update_diff(vim.api.nvim_get_current_buf())
        end,
      })
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = _jj_au,
        callback = function()
          _jj_update_diff(vim.api.nvim_get_current_buf())
        end,
      })
      vim.api.nvim_create_autocmd("BufDelete", {
        group = _jj_au,
        callback = function(ev) _jj_diff_cache[ev.buf] = nil end,
      })
      _jj_update_branch()

      -- Signature help toggle: mutates blink.cmp's runtime config so the
      -- auto-trigger can be turned off mid-session when it's in the way.
      function _toggle_blink_signature()
        local cfg = require('blink.cmp.config').signature.trigger
        cfg.enabled = not cfg.enabled
        if not cfg.enabled then require('blink.cmp').hide() end
        vim.notify("blink.cmp signature: " .. (cfg.enabled and "on" or "off"))
      end

      -- Repeatable treesitter moves: ; / , replay the last ]f/[f-style move and
      -- also f/F/t/T. NOTE the hyphenated require path — this is the main-branch
      -- rewrite, not the legacy dotted nvim-treesitter.textobjects path.
      local _tsrepeat = require('nvim-treesitter-textobjects.repeatable_move')
      vim.keymap.set({ 'n', 'x', 'o' }, ';', _tsrepeat.repeat_last_move_next)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', _tsrepeat.repeat_last_move_previous)
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', _tsrepeat.builtin_f_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', _tsrepeat.builtin_F_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 't', _tsrepeat.builtin_t_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', _tsrepeat.builtin_T_expr, { expr = true })

      -- Incremental selection — the nvim-treesitter rewrite removed the built-in
      -- module, so drive it directly off vim.treesitter. <C-space> selects the
      -- node under the cursor then grows to the next-larger node; <BS> shrinks
      -- back down the stack. Stack-based like the original: only use these keys
      -- to change the selection while growing/shrinking.
      do
        local _esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
        local _sel = {}
        local function _set_visual(node)
          local sr, sc, er, ec = node:range()
          if vim.fn.mode():match('[vV]') then vim.cmd('normal! ' .. _esc) end
          vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
          vim.cmd('normal! v')
          local eer, eec = er, ec
          if eec > 0 then
            eec = eec - 1
          else
            eer = er - 1
            eec = math.max(vim.fn.col({ eer + 1, '$' }) - 2, 0)
          end
          vim.api.nvim_win_set_cursor(0, { eer + 1, eec })
        end
        local function _bigger_parent(node)
          local sr, sc, er, ec = node:range()
          local p = node:parent()
          while p do
            local a, b, c, d = p:range()
            if a ~= sr or b ~= sc or c ~= er or d ~= ec then return p end
            p = p:parent()
          end
          return nil
        end
        local function _grow()
          local in_visual = vim.fn.mode():match('^[vV]')
          if not in_visual or #_sel == 0 then
            local ok, node = pcall(vim.treesitter.get_node)
            if not ok or not node then return end
            _sel = { node }
            _set_visual(node)
          else
            local p = _bigger_parent(_sel[#_sel])
            if p then
              table.insert(_sel, p)
              _set_visual(p)
            end
          end
        end
        local function _shrink()
          table.remove(_sel)
          local node = _sel[#_sel]
          if node then _set_visual(node) else vim.cmd('normal! ' .. _esc) end
        end
        vim.keymap.set('n', '<C-space>', _grow, { desc = '🌳 Init/grow TS selection' })
        vim.keymap.set('x', '<C-space>', _grow, { desc = '🌳 Grow TS selection' })
        vim.keymap.set('x', '<BS>', _shrink, { desc = '🌳 Shrink TS selection' })
      end

      -- dial.nvim: context-aware increment/decrement (bool, dates, &&/||, semver).
      -- Builders come from dial.augend; the registry (register_group) is the
      -- separate dial.config.augends object.
      local _augend = require('dial.augend')
      require('dial.config').augends:register_group({
        default = {
          _augend.integer.alias.decimal,
          _augend.integer.alias.hex,
          _augend.date.alias['%Y/%m/%d'],
          _augend.constant.alias.bool,
          _augend.constant.new({ elements = { '&&', '||' }, word = false }),
          _augend.constant.new({ elements = { 'and', 'or' } }),
          _augend.semver.alias.semver,
        },
      })
      local _dial = require('dial.map')
      vim.keymap.set('n', '<C-a>', function() _dial.manipulate('increment', 'normal') end)
      vim.keymap.set('n', '<C-x>', function() _dial.manipulate('decrement', 'normal') end)
      vim.keymap.set('x', '<C-a>', function() _dial.manipulate('increment', 'visual') end)
      vim.keymap.set('x', '<C-x>', function() _dial.manipulate('decrement', 'visual') end)
      vim.keymap.set('x', 'g<C-a>', function() _dial.manipulate('increment', 'gvisual') end)
      vim.keymap.set('x', 'g<C-x>', function() _dial.manipulate('decrement', 'gvisual') end)

      -- Claude Code: focus the Zellij claude pane after a send/add — the
      -- built-in focus_after_send is a no-op for the external provider.
      vim.api.nvim_create_autocmd('User', {
        pattern = 'ClaudeCodeSendComplete',
        callback = function()
          vim.system({ 'zellij', 'action', 'focus-next-pane' })
        end,
      })
    '';

    plugins = {
      bufsurf.enable = true;

      cmp-latex-symbols.enable = true;
      blink-compat.enable = true;
      # To re-enable Copilot: enable blink-copilot, add "copilot" to sources.default,
      # and register it as a provider with module = "blink-copilot".
      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            "<C-j>" = ["select_next" "fallback"];
            "<C-k>" = ["select_prev" "fallback"];
            "<CR>" = ["accept" "fallback"];
            "<Tab>" = ["select_and_accept" "snippet_forward" "fallback"];
            "<S-Tab>" = ["snippet_backward" "fallback"];
          };
          signature = {
            enabled = true;
            window.show_documentation = false;
          };
          completion = {
            # Show the doc/signature popup on selection (default is off, so
            # scrolling completions otherwise shows only the bare label).
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 250;
            };
          };
          sources = {
            # "supermaven" is appended only when aiCompletion is enabled (the
            # nvim-ai build); the provider itself is registered in supermaven.nix.
            default =
              [
                "lsp"
                "snippets"
                "latex_symbols"
                "path"
                "buffer"
              ]
              ++ lib.optional config.aiCompletion.enable "supermaven";
            providers = {
              latex_symbols = {
                name = "latex_symbols";
                module = "blink.compat.source";
              };
            };
          };
        };
      };

      tiny-inline-diagnostic = {
        enable = true;
        package = pkgs.vimPlugins.tiny-inline-diagnostic;
        settings = {
          preset = "modern";
          options = {
            # Errors stay pinned on every line of a multi-line diagnostic;
            # warnings/info/hints collapse to the cursor line only — tames
            # clangd's verbose C++ note chains without hiding real errors.
            multilines = {
              enabled = true;
              always_show = true;
              severity = [ { __raw = "vim.diagnostic.severity.ERROR"; } ];
            };
            show_all_diags_on_cursorline = true;
            use_icons_from_diagnostic = true;
            # Suppress the inline render while vim.diagnostic.open_float is up,
            # so <leader>ce doesn't show the same message twice.
            override_open_float = true;
          };
        };
      };

      eyeliner = {
        enable = true;
        settings = {
          highlight_on_key = true;
          # Grey out the rest of the line on f/t so the highlighted target
          # letter pops instead of being one cue among many.
          dim = true;
        };
      };

      lsp = {
        enable = true;
        onAttach = ''
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        '';
        preConfig = ''
          local __clangdCaps = require('blink.cmp').get_lsp_capabilities()
          __clangdCaps.offsetEncoding = { "utf-16" }
        '';
        servers = {
          clangd = {
            enable = true;
            package = clangdPkg;
            extraOptions = {
              cmd = [
                "${clangdPkg}/bin/clangd"
                "--background-index"
                "--clang-tidy"
                "--header-insertion=iwyu"
                "--completion-style=detailed"
                "--all-scopes-completion"
                "--function-arg-placeholders"
                "--pch-storage=memory"
                "--enable-config"
              ];
              capabilities = {__raw = "__clangdCaps";};
              init_options = {
                semanticHighlighting = true;
                # Offer symbols from not-yet-included headers and auto-add the
                # #include on accept (pairs with --header-insertion=iwyu).
                completeUnimported = true;
                usePlaceholders = true;
                clangdFileStatus = true;
              };
            };
          };
          pyright = {
            enable = true;
            settings = {
              python.analysis = {
                # Infer types from installed packages that ship no stubs (most
                # of the scientific stack) — real completions instead of Unknown.
                useLibraryCodeForTypes = true;
                autoSearchPaths = true;
                typeCheckingMode = "basic";
                # Don't scan the whole tree on every edit (SSH-friendly).
                diagnosticMode = "openFilesOnly";
              };
            };
          };
          nil_ls.enable = true;
          marksman.enable = true;
          zls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
            settings = {
              cargo.features = "all";
            };
          };
        };
      };

      lualine = {
        enable = true;
        settings = {
          options = {
            globalstatus = true;
            # Snacks explorer/picker panes: no filename winbar, and never steal
            # the "active" statusline from the code window.
            disabled_filetypes.winbar = [ "snacks_picker_list" "snacks_picker_input" "snacks_dashboard" ];
            ignore_focus = [ "snacks_picker_list" "snacks_picker_input" "snacks_explorer" ];
          };
          sections = {
            lualine_a = [
              {
                __unkeyed-1.__raw = "function() return _jj_branch_cache end";
                icon = "";
              }
              {
                __unkeyed-1 = "diff";
                source.__raw = "function() return _jj_diff_cache[vim.api.nvim_get_current_buf()] end";
              }
              "diagnostics"
            ];
            lualine_b = [];
            lualine_c = [];
            # Spinner while clangd background-indexes / rust_analyzer builds its
            # crate graph, then settles — "still indexing or actually done?".
            lualine_x = [ "lsp_status" ];
            lualine_y = [];
            lualine_z = [];
          };
          winbar = {
            lualine_a = [
              {
                __unkeyed-1 = "filename";
                path = 1;
              }
            ];
          };
          inactiveWinbar = {
            lualine_a = [
              "filename"
            ];
          };
        };
      };


      rainbow-delimiters = {
        enable = true;
        # Local strategy for deeply-nested C/C++: highlight only the cursor's
        # subtree instead of re-highlighting the whole buffer (global default).
        strategy = {
          "" = "global";
          c = "local";
          cpp = "local";
        };
        settings = {
          highlight = [
            "RainbowDelimiterYellow"
            "RainbowDelimiterBlue"
            "RainbowDelimiterOrange"
            "RainbowDelimiterGreen"
            "RainbowDelimiterViolet"
            "RainbowDelimiterCyan"
            "RainbowDelimiterRed"
          ];
          priority = {
            cuda = 200;
          };
        };
      };

      snacks-nvim = {
        enable = true;
        settings = {
          bigfile.enabled = true;
          explorer = {
            enabled = true;
          };
          input.enabled = true;
          notifier.enabled = true;
          picker = {
            enabled = true;
            sources.explorer = {
              layout.preset = "default";
              auto_close = true;
            };
          };
          scroll = {
            enabled = true;
            # Snappier than the 200ms default: shorter total + outCubic momentum.
            animate = {
              duration = { step = 8; total = 120; };
              easing = "outCubic";
            };
          };
          words.enabled = true;
          # Paint the buffer with treesitter highlighting before the plugin
          # stack loads — biggest payoff over SSH/Zellij cold starts.
          quickfile.enabled = true;
          # Distraction-free mode (replaces the standalone zen-mode plugin).
          # Strips numbers/cursorline/gutter; <leader>z calls Snacks.zen().
          zen = {
            toggles = { dim = false; git_signs = false; mini_diff_signs = false; };
            # Keep the statusline (globalstatus is on) instead of a bare window.
            show = { statusline = true; tabline = false; };
            win = {
              width = 100;
              # Opaque backdrop coloured like Normal bg: the buffer below is fully
              # hidden (not dimmed/see-through), so there's no distracting
              # double-motion when scrolling, and the margins read as plain editor.
              backdrop = { transparent = false; blend = 0; bg = "#191e21"; };
              wo = {
                # Keep normal chrome in zen: line numbers, jj/diagnostic gutter,
                # and the column guide. Only centering + tabline-hiding differ.
                number = true;
                relativenumber = true;
                signcolumn = "yes";
                colorcolumn = "100";
              };
            };
          };
        };
      };

      treesitter = {
        enable = true;
        settings = {
          indent.enable = true;
          highlight.enable = true;
          # NOTE: incremental_selection is implemented in extraConfigLua, not
          # here — the installed nvim-treesitter is the main-branch rewrite,
          # whose setup() dropped the incremental_selection module.
        };
        nixGrammars = true;
        nixvimInjections = true;
      };

      treesitter-textobjects = {
        enable = true;
        settings = {
          move = {
            enable = true;
            goto_next_start = {
              "]f" = "@function.outer";
            };
            goto_next_end = {
              "]F" = "@function.outer";
            };
            goto_previous_start = {
              "[f" = "@function.outer";
            };
            goto_previous_end = {
              "[F" = "@function.outer";
            };
          };
          select = {
            enable = true;
            keymaps = {
              "af" = "@function.outer";
              "if" = "@function.inner";
              "ac" = "@class.outer";
              "ic" = "@class.inner";
              # Argument/parameter object — dip/cip a single call argument.
              "ap" = "@parameter.outer";
              "ip" = "@parameter.inner";
            };
          };
          # Reorder an argument with the next/previous one, treesitter-correct
          # (commas + whitespace handled) — no cut-and-paste.
          swap = {
            enable = true;
            swap_next = { "<leader>na" = "@parameter.inner"; };
            swap_previous = { "<leader>pa" = "@parameter.inner"; };
          };
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          # Single source of truth for format options (replaces the deprecated
          # per-call lsp_fallback=true; <leader>cf inherits this).
          default_format_opts.lsp_format = "fallback";
          formatters_by_ft = {
            c = ["clang-format"];
            cpp = ["clang-format"];
            cuda = ["clang-format"];
            zig = ["zigfmt"];
            python = ["black"];
            nix = ["alejandra"];
            lua = ["stylua"];
            javascript = ["prettier"];
            typescript = ["prettier"];
            javascriptreact = ["prettier"];
            typescriptreact = ["prettier"];
            json = ["prettier"];
            yaml = ["prettier"];
            markdown = ["prettier"];
            html = ["prettier"];
            css = ["prettier"];
          };
        };
      };

      lint = {
        enable = true;
        lintersByFt = {
          # ruff lints the whole repo in ~0.2s vs pylint cold-starting the
          # interpreter on every run; purpose-built for editor-frequency linting.
          python = ["ruff"];
          markdown = ["markdownlint"];
        };
        autoCmd = {
          # Dropped InsertLeave. Guard against special/scratch buffers so we
          # don't spawn linters against snacks/help/terminal panes.
          event = ["BufWritePost" "BufReadPost"];
          callback.__raw = ''
            function()
              local b = vim.bo
              if b.buftype ~= "" or not b.modifiable then return end
              require("lint").try_lint()
            end
          '';
        };
      };

      web-devicons.enable = true;

      which-key = {
        enable = true;
        settings = {
          # Stop which-key prepending its own guessed icon on top of the emoji
          # already curated in each keymap's desc (otherwise every row double-icons).
          icons.mappings = false;
          # Name the leader-prefix namespaces (shown as bare "+" by default).
          spec = [
            { __unkeyed-1 = "<leader>c"; group = "Code / LSP"; }
            { __unkeyed-1 = "<leader>a"; group = "AI / Claude"; }
            { __unkeyed-1 = "<leader>n"; group = "Notes"; }
            { __unkeyed-1 = "<leader>w"; group = "Windows"; }
            { __unkeyed-1 = "<leader>f"; group = "Files"; }
            { __unkeyed-1 = "<leader>s"; group = "Search"; }
            { __unkeyed-1 = "<leader>g"; group = "VCS (jj)"; }
            { __unkeyed-1 = "<leader>b"; group = "Buffers"; }
            { __unkeyed-1 = "<leader>t"; group = "Toggle"; }
            { __unkeyed-1 = "<leader>j"; group = "Jupyter"; }
          ];
        };
      };

      # mini.nvim modules. surround uses a gs prefix so it never clobbers the
      # builtin `s`; ai adds bracket/quote/call a/i objects treesitter lacks.
      mini = {
        enable = true;
        modules = {
          ai = { };
          surround = {
            mappings = {
              add = "gsa";
              delete = "gsd";
              replace = "gsr";
              find = "gsf";
              find_left = "gsF";
              highlight = "gsh";
              update_n_lines = "gsn";
            };
          };
        };
      };

      # Context-aware C-a/C-x (true⇄false, dates, &&⇄||, semver). Augends and
      # keymaps are wired in extraConfigLua (the module has no setup function).
      dial.enable = true;

      # Inline highlighting of TODO/FIX/HACK/PERF/NOTE/WARN comments. The search
      # half already exists as Snacks.picker.todo_comments.
      todo-comments.enable = true;

      markview = {
        enable = true;
        settings = {
          preview = {
            modes = [ "n" "i" "no" "c" ];
            hybrid_modes = [ "n" "i" ];
            debounce = 15; # Super fast updates for hybrid mode
            linewise_hybrid_mode = true;
          };
          # snacks.image typesets $..$ and $$..$$ through tectonic; a Unicode
          # approximation over the same nodes would double-render them.
          latex.enable = false;
          markdown = {
            headings = {
              shift_width = 1;
              heading_1 = { style = "label"; icon = "◉ "; background = "DiffAdd"; };
              heading_2 = { style = "label"; icon = "○ "; background = "DiffChange"; };
              heading_3 = { style = "label"; icon = "◈ "; background = "DiffDelete"; };
              heading_4 = { style = "label"; icon = "◇ "; background = "CursorLine"; };
              heading_5 = { style = "label"; icon = "◆ "; background = "CursorLine"; };
              heading_6 = { style = "label"; icon = "✦ "; background = "CursorLine"; };
            };
            code_blocks = {
              style = "language";
              hl = "CursorLine";
              sign = true;
              pad_char = " ";
              pad_amount = 2;
            };
            block_quotes = {
              default = { border = "▍"; hl = "DiagnosticInfo"; };
              callouts = {
                note = { title = " Note "; icon = "󰋽"; hl = "DiagnosticInfo"; };
                warning = { title = " Warning "; icon = ""; hl = "DiagnosticWarn"; };
                danger = { title = " Danger "; icon = "󰚌"; hl = "DiagnosticError"; };
              };
            };
            list_items = {
              marker_minus = { add_padding = false; text = "•"; hl = "DiagnosticWarn"; };
              marker_plus = { add_padding = false; text = "‣"; hl = "DiagnosticInfo"; };
              marker_star = { add_padding = false; text = "★"; hl = "DiagnosticWarn"; };
            };
            checkboxes = {
              checked = { text = "✔"; hl = "DiagnosticOk"; };
              unchecked = { text = "✗"; hl = "DiagnosticError"; };
              pending = { text = "◐"; hl = "DiagnosticWarn"; };
            };
          };
        };
      };
    };
  };
}
