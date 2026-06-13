{
  pkgs,
  helpers,
  lib,
  config,
  ...
}: let
  clangdPkg = pkgs.llvmPackages_20.clang-tools;
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
            multilines.enabled = true;
            show_all_diags_on_cursorline = true;
            use_icons_from_diagnostic = true;
          };
        };
      };

      eyeliner = {
        enable = true;
        settings = {
          highlight_on_key = true;
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
              };
            };
          };
          pyright.enable = true;
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
          globalstatus = true;
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
            lualine_x = [];
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
          scroll.enabled = true;
          words.enabled = true;
        };
      };

      treesitter = {
        enable = true;
        settings = {
          indent.enable = true;
          highlight.enable = true;
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
            };
          };
        };
      };

      treesitter-context = {
        enable = true;
        settings = {
          max_lines = 4;
          min_window_height = 20;
          multiline_threshold = 1;
          mode = "cursor";
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
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
          python = ["pylint"];
          markdown = ["markdownlint"];
        };
        autoCmd = {
          event = ["BufWritePost" "BufReadPost" "InsertLeave"];
        };
      };

      web-devicons.enable = true;

      which-key.enable = true;

      zen-mode = {
        enable = true;
        settings = {
          window = {
            width = 100; # Match the colorcolumn
            options = {
              colorcolumn = "100";
            };
          };
        };
      };

      markview = {
        enable = true;
        settings = {
          preview = {
            modes = [ "n" "i" "no" "c" ];
            hybrid_modes = [ "n" "i" ];
            debounce = 15; # Super fast updates for hybrid mode
            linewise_hybrid_mode = true;
          };
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
