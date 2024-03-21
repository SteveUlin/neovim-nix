{ pkgs, ... }:
{
  config = {
    plugins = {

      alpha = {
        enable = true;
        layout = import ./alpha_layout.nix;
      };

      better-escape = {
        enable = true;
        mapping = [ "jk" ];
        clearEmptyLines = true;
      };

      bufsurf.enable = true;

      copilot-lua = {
        enable = true;
        panel.enabled = false;
        suggestion.enabled = false;
        filetypes.markdown = true;
      };

      copilot-cmp.enable = true;

      diffview.enable = true;

      gitsigns.enable = true;

      harpoon = {
        enable = true;
        enableTelescope = true;
        keymaps = {
          addFile = "<leader>ha";
          toggleQuickMenu = "<leader>ht";
          navNext = "<leader>hn";
          navPrev = "<leader>hp";
        };
      };

      illuminate.enable = true;

      log-highlight.enable = true;

      luasnip = {
        enable = true;
        fromVscode = [{paths = "${pkgs.vimPlugins.friendly-snippets}";}];
      };

      neorg = {
        enable = true;
        modules = {
          "core.concealer" = { __empty = null; };
          "core.defaults" = { __empty = null; };
          "core.dirman" = {
            config = {
              workspaces = {
                notes = "~/notes";
              };
              index = "index.norg";
              default_workspace = "notes";
            };
          };
          "core.esupports.metagen" = {
            config = {
              type = "auto";
            };
          };
          "core.integrations.telescope" = { __empty = null; };
          "core.integrations.treesitter" = { __empty = null; };
          "core.queries.native" = { __empty = null; };
        };
      };

      neorg-exec.enable = true;

      notify.enable = true;

      nvim-cmp = {
        enable = true;
        mapping = {
          "<CR>" = "cmp.mapping.confirm({select = true })";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<Tab>" = ''
            cmp.mapping(function(fallback)
              local luasnip = require("luasnip")
              local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
              end
              if cmp.visible() then
                cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
              -- they way you will only jump inside the snippet region
              elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s" })
          '';
          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
              local luasnip = require("luasnip")
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';
          "<C-j>" = "cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'})";
          "<C-k>" = "cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'})";
          "<C-e>" = "cmp.mapping.close()";
        };

        snippet.expand = "luasnip";

        sources = [
          { name = "luasnip"; }
          { name = "copilot"; }
          { name = "nvim_lsp"; }
          { name = "cmdline"; }
          { name = "latex_symbols"; }
          { name = "emoji"; }
          { name = "spell"; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "calc"; }
        ];
      };

      lsp = {
        enable = true;
        servers = {
          clangd = {
            enable = true;
            package = pkgs.clang-tools_17;
          };
          pylsp.enable = true;
          nil_ls.enable = true;
        };
      };

      # Automatically adds efm to the list of lsp servers
      # efmls-configs = {
      #   enable = true;
      #   setup = {
      #     markdown = {
      #       linter = [ "markdownlint" ];
      #     };
      #   };
      # };

      rainbow-delimiters = {
        enable = true;
        highlight = [
            "RainbowDelimiterYellow"
            "RainbowDelimiterBlue"
            "RainbowDelimiterOrange"
            "RainbowDelimiterGreen"
            "RainbowDelimiterViolet"
            "RainbowDelimiterCyan"
            "RainbowDelimiterRed"
          ];
      };

      telescope = {
        enable = true;
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
        extensions = {
          file_browser.enable = true;
          frecency.enable = true;
          live_grep_args.enable = true;
          undo.enable = true;
        };
      };

      sniprun = {
        enable = true;
        display = [
          "Terminal"
        ];
        interpreterOptions = {
          Neorg_original = {
            use_on_filetypes = [ "norg" ];
          };
        };
      };

      treesitter = {
        enable = true;
        indent = true;
        folding = true;
        nixGrammars = true;
        nixvimInjections = true;
      };

      venn-nvim.enable = true;

      which-key = {
        enable = true;
        registrations = {
          "<Leader>f" = "+File";
        };
      };

    };
  };
}
