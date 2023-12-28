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

      copilot-lua = {
        enable = true;
        panel.enabled = false;
        suggestion.enabled = false;
      };

      copilot-cmp.enable = true;

      diffview.enable = true;

      gitsigns.enable = true;

      neorg = {
        enable = true;
        modules = {
          "core.defaults" = { __empty = null; };
          "core.concealer" = { __empty = null; };
          "core.integrations.telescope" = { __empty = null; };
          "core.esupports.metagen" = {
            config = {
              type = "auto";
            };
          };
        };
      };

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

        sources = [
          { name = "luasnip"; }
          { name = "copilot"; }
          { name = "nvim_lsp"; }
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
          nil_ls.enable = true;
        };
      };

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
        };
        extensions = {
          file_browser.enable = true;
          frecency.enable = true;
          live_grep_args.enable = true;
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
