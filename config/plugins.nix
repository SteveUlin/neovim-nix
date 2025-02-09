{ pkgs, helpers, ... }:
{
  config = {
    plugins = {
      better-escape.enable = true;

      bufsurf.enable = true;

      cmp = {
        enable = true;
        
        settings = {
          experimental = { ghost_text = true; };
          window = {
            completion = {
              winhighlight =
                "FloatBorder:CmpBorder,Normal:CmpPmenu";
              scrollbar = false;
              sidePadding = 0;
              border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
            };

            settings.documentation = {
              border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
              winhighlight =
                "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
            };
          };
          formatting = {
            fields = [ "kind" "abbr" "menu" ];
            format = 
              ''
                function(_, item)
                  local icons = {
                    Namespace = "󰌗",
                    Text = "󰉿",
                    Method = "󰆧",
                    Function = "󰆧",
                    Constructor = "",
                    Field = "󰜢",
                    Variable = "󰀫",
                    Class = "󰠱",
                    Interface = "",
                    Module = "",
                    Property = "󰜢",
                    Unit = "󰑭",
                    Value = "󰎠",
                    Enum = "",
                    Keyword = "󰌋",
                    Snippet = "",
                    Color = "󰏘",
                    File = "󰈚",
                    Reference = "󰈇",
                    Folder = "󰉋",
                    EnumMember = "",
                    Constant = "󰏿",
                    Struct = "󰙅",
                    Event = "",
                    Operator = "󰆕",
                    TypeParameter = "󰊄",
                    Table = "",
                    Object = "󰅩",
                    Tag = "",
                    Array = "[]",
                    Boolean = "",
                    Number = "",
                    Null = "󰟢",
                    String = "󰉿",
                    Calendar = "",
                    Watch = "󰥔",
                    Package = "",
                    Copilot = "",
                    Codeium = "",
                    TabNine = "",
                  }

                  local icon = icons[item.kind] or ""
                  item.kind = string.format("%s %s", icon, item.kind or "")
                  return item
                end
            '';
          };
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
          expand = "luasnip";
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
      };

      copilot-chat.enable = true;

      copilot-cmp.enable = true;

      copilot-lua = {
        enable = true;
        panel.enabled = false;
        suggestion.enabled = false;
        filetypes.markdown = true;
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

      diffview.enable = true;

      eyeliner = {
        enable = true;
        settings = {
          highlight_on_key = true;
        };
      };

      fzf-lua = {
        enable = true;
      };

      gitsigns.enable = true;

      illuminate.enable = true;

      lsp = {
        enable = true;
        preConfig =
          ''
            local __clangdCaps = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
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
          nil-ls.enable = true;
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
              "filename"
            ];
          };
          inactiveWinbar = {
            lualine_a =  [ 
              "filename"
            ];
          };
        };
      };

      luasnip = {
        enable = true;
        fromVscode = [{paths = "${pkgs.vimPlugins.friendly-snippets}";}];
      };

      mdx.enable = true;

      mini = {
        enable = true;

        modules = {
          pairs = {};
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
        extraOptions = {
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
            replace_netrw = true;
          };
          input.enabled = true;
          notifier.enabled = true;
          # statuscolumn.enabled = true;
          picker = {
            enabled = true;
            sources.explorer = {
              layout.layout.position = "right";
            };
          };
          scroll.enabled = true;
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
