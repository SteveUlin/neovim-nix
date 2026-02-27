{
  pkgs,
  helpers,
  ...
}: {
  config = {
    extraPlugins = with pkgs.vimPlugins; [
      vclib
      vcsigns
    ];

    extraConfigLua = ''
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
      local _jj_branch_cache = ""
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

      local _jj_diff_cache = {}
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
    '';

    plugins = {
      bufsurf.enable = true;

      cmp-latex-symbols.enable = true;
      blink-compat.enable = true;
      # Copilot — uncomment when subscription is active (e.g. work machine)
      # blink-copilot.enable = true;
      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            "<C-j>" = ["select_next" "fallback"];
            "<C-k>" = ["select_prev" "fallback"];
            "<CR>" = ["accept" "fallback"];
          };
          sources = {
            default = [
              "lsp"
              # "copilot"
              "latex_symbols"
              "path"
              "buffer"
            ];
            providers = {
              # copilot = {
              #   name = "copilot";
              #   module = "blink-copilot";
              #   score_offset = 100;
              #   async = true;
              #   opts = {
              #     max_completions = 5;
              #     max_attempts = 10;
              #   };
              # };
              latex_symbols = {
                name = "latex_symbols";
                module = "blink.compat.source";
              };
            };
          };
        };
      };

      # copilot-lua = {
      #   enable = true;
      #   settings = {
      #     panel.enabled = false;
      #     suggestion.enabled = false;
      #     filetypes.markdown = true;
      #     copilot_model = "gpt-4o-copilot";
      #
      #     server_opts_overrides = {
      #       settings = {
      #         advanced = {
      #           inlineSuggestCount = 10;
      #         };
      #       };
      #     };
      #   };
      # };

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
        preConfig = ''
          local __clangdCaps = require('blink.cmp').get_lsp_capabilities()
          __clangdCaps.offsetEncoding = { "utf-16" }
        '';
        servers = {
          clangd = {
            enable = true;
            package = pkgs.llvmPackages_19.clang-tools;
            extraOptions = {
              capabilities = {__raw = "__clangdCaps";};
              init_options = {
                semanticHighlighting = true;
              };
            };
          };
          pyright.enable = true;
          nil_ls.enable = true;
          marksman.enable = true;
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
            lualine_b = [""];
            lualine_c = [""];
            lualine_x = [""];
            lualine_y = [""];
            lualine_z = [""];
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
          # statuscolumn.enabled = true;
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
        # folding = true;
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

      web-devicons.enable = true;

      which-key.enable = true;
    };
  };
}
