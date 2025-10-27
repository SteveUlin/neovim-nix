{ pkgs, helpers, ... }:
{
  config = {
    extraPlugins = with pkgs.vimPlugins; [
      nvim-lint
    ];

    extraConfigLua = ''
      -- Setup nvim-lint
      require('lint').linters_by_ft = {
        python = {'pylint'},
        markdown = {'markdownlint'},
      }

      -- Auto-lint on save and text changed
      vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged" }, {
        callback = function()
          require("lint").try_lint()
        end,
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
            "<C-j>" = [ "select_next" "fallback" ];
            "<C-k>" = [ "select_prev" "fallback" ];
            "<CR>" = [ "accept" "fallback" ];
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
                score_offset = 100;
              };
            };
          };
        };
      };

      avante = {
        enable = true;
        # settings = {};
      };

      # codecompanion = {
      #   enable = true;
      #   settings = {
      #     chat = {
      #       adapter = "copilot";
      #     };
      #     inline = {
      #       adapter = "copilot";
      #     };
      #     agent = {
      #       adapter = "copilot";
      #     };
      #     display = {
      #       diff = {
      #         provider = "mini_diff";
      #       };
      #     };
      #   };
      # };

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

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };
          formatters_by_ft = {
            lua = [ "stylua" ];
            python = [ "black" ];
            rust = [ "rustfmt" ];
            nix = [ "alejandra" ];
            c = [ "clang-format" ];
            cpp = [ "clang-format" ];
            markdown = [ "prettier" ];
            json = [ "prettier" ];
            yaml = [ "prettier" ];
          };
        };
      };

      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "▎";
            change.text = "▎";
            delete.text = "";
            topdelete.text = "";
            changedelete.text = "▎";
            untracked.text = "▎";
          };
          current_line_blame = false;
          current_line_blame_opts = {
            delay = 300;
          };
        };
      };

      diffview = {
        enable = true;
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
        preConfig =
          ''
            local __clangdCaps = require('blink.cmp').get_lsp_capabilities()
            __clangdCaps.offsetEncoding = { "utf-16" }
          '';
        servers = {
          clangd = {
            enable = true;
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
            lualine_a = [ "branch" "diff" "diagnostics" ];
            lualine_b = [ "" ];
            lualine_c = [ "" ];
            lualine_x = [ "" ];
            lualine_y = [ "" ];
            lualine_z = [ "" ];
          };
          winbar = {
            lualine_a =  [
              {
                __unkeyed-1 = "filename";
                path = 1;
              }
            ];
          };
          inactiveWinbar = {
            lualine_a =  [
              "filename"
            ];
          };
        };
      };

      mdx.enable = true;

      mini = {
        enable = true;

        modules = {
          pairs = {};
          diff = {
            view = {
              style = "sign";
              signs = {
                add = "▎";
                change = "▎";
                delete = "🭹" ;
              };
            };
            # Mappings for applying/resetting hunks in overlay
            # gh  - apply hunks (accept changes)
            # gH  - reset hunks (undo changes)
            # Use gitsigns for hunk navigation (]h, [h already mapped)
            mappings = {
              apply = "gh";
              reset = "gH";
              textobject = "gh";
              goto_first = "";
              goto_prev = "";
              goto_next = "";
              goto_last = "";
            };
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

      telescope = {
        enable = true;
        settings = {
          defaults = {
            initial_mode = "normal";
            mappings = {
              n = {
                "<leader>q" = {
                  __raw = ''
                    function(...)
                      return require("telescope.actions").close(...)
                    end'';
                };
              };
            };
          };
        };
        extensions = {
          file-browser.enable = true;
          frecency.enable = true;
          live-grep-args.enable = true;
          undo.enable = true;
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
        move = {
          enable = true;
          gotoNextStart = {
              "]f" = "@function.outer";
          };
          gotoNextEnd = {
              "]F" = "@function.outer";
          };
          gotoPreviousStart = {
                "[f" = "@function.outer";
          };
          gotoPreviousEnd = {
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

      web-devicons.enable = true;

      which-key.enable = true;

    };
  };
}
