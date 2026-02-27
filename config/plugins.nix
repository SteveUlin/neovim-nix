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
    '';

    plugins = {
      bufsurf.enable = true;

      cmp-latex-symbols.enable = true;
      blink-compat.enable = true;
      blink-copilot.enable = true;
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
              "copilot"
              "latex_symbols"
              "path"
              "buffer"
            ];
            providers = {
              copilot = {
                name = "copilot";
                module = "blink-copilot";
                score_offset = 100;
                async = true;
                opts = {
                  max_completions = 5;
                  max_attempts = 10;
                };
              };
              latex_symbols = {
                name = "latex_symbols";
                module = "blink.compat.source";
              };
            };
          };
        };
      };

      copilot-lua = {
        enable = true;
        settings = {
          panel.enabled = false;
          suggestion.enabled = false;
          filetypes.markdown = true;
          copilot_model = "gpt-4o-copilot";

          server_opts_overrides = {
            settings = {
              advanced = {
                inlineSuggestCount = 10;
              };
            };
          };
        };
      };

      diagflow = {
        enable = true;
        settings = {
          show_borders = true;
          scope = "line";
          border_chars = {
            top_left = "╭";
            top_right = "╮";
            botttom_left = "╰";
            bottom_right = "╯";
            horizontal = "─";
            vertical = "│";
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
            lualine_a = ["branch" "diff" "diagnostics"];
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
