{pkgs, ...}: let
  # Random tips pool - one will be selected each time
  tips = [
    # === Your Keybindings ===
    # Pickers
    "<space><space> smart find - frecency + git files combined"
    "<space>/ live grep across entire project"
    "<space>, switch buffers quickly"
    "<space>; resume your last picker where you left off"
    "<space>: search command history"
    "<space>e opens explorer at current file's directory"
    "<space>fr recent files you've edited"
    "<space>sb fuzzy search lines in current buffer"
    "<space>fb grep across all open buffers"
    "<space>sw grep for word under cursor instantly"
    "<space>su visual undo history - browse and restore"

    # Git
    "]h [h jump between git hunks"
    "<space>gs git status picker"
    "<space>gd git diff picker"
    "<space>gl git log picker"
    "<space>gu undo current hunk"
    "<space>go toggle inline diff overlay"

    # LSP
    "<space>ca code actions - quick fixes and refactors"
    "<space>cf format current buffer"
    "<space>ck hover docs for symbol under cursor"
    "<space>cd go to definition"
    "<space>cR find all references"
    "<space>cs list all symbols in file"
    "<space>cS search symbols across workspace"
    "]]/[[ jump to next/prev LSP reference"

    # Files & Buffers
    "<space>fs save file"
    "<space>q close window"
    "<space>yp copy current file's full path to clipboard"
    "]b [b navigate buffer history (not just list order)"

    # Windows
    "<space>wv vertical split"
    "<space>ws horizontal split"
    "<space>wh/j/k/l move between windows"

    # Notes
    "<space>ne explore your notes folder"
    "<space>nt jump to your todo file"

    # Help
    "<space>h return to this dashboard"
    "<space>? open the full cheat sheet"

    # === Vim Essentials ===
    # The Power Moves
    "The dot (.) repeats your last change - master this first"
    "ciw changes word even from the middle of it"
    "ci\" changes inside quotes, ci( inside parens, ci{ inside braces"
    "da\" deletes quotes AND their contents"
    "* searches forward for word under cursor, # backward"
    "gd jumps to definition, Ctrl-o jumps back"

    # Text Objects (verb + i/a + object)
    "dap deletes a parameter (treesitter)"
    "daf deletes entire function, dif deletes function body"
    "vi{ selects inside braces, va{ includes the braces"
    "cit changes inside HTML tag, cat changes around tag"

    # Movement
    "{ } jump between paragraphs/blank lines"
    "% jump to matching bracket"
    "^ first non-blank char, 0 absolute start, $ end"
    "f<char> jump to char, ; repeat forward, , repeat backward"
    "w word forward, b word back, e end of word"
    "gg top of file, G bottom, 50G go to line 50"
    "H top of screen, M middle, L bottom"
    "Ctrl-d half page down, Ctrl-u half page up"
    "zz center cursor on screen, zt top, zb bottom"

    # Registers & Yanking
    "\"0p pastes last yank (ignores deletes)"
    "\"ap pastes from register a, \"ay yanks to register a"
    "\"+y yanks to system clipboard"
    ":reg shows all registers"

    # Macros
    "qa records macro to register a, q stops recording"
    "@a plays macro a, @@ repeats last macro"
    "5@a runs macro a five times"

    # Visual Mode
    "v char select, V line select, Ctrl-v block select"
    "gv reselect last visual selection"
    "o in visual mode jumps to other end of selection"

    # Search & Replace
    "/<pattern> search, n next, N previous"
    ":%s/old/new/g replace all in file"
    ":%s/old/new/gc replace all with confirmation"
    ":s/old/new/g replace all in current line"

    # Marks
    "ma sets mark a, 'a jumps to line of mark a"
    "`a jumps to exact position of mark a"
    "'' jumps back to previous position"

    # Folds
    "zc close fold, zo open fold, za toggle"
    "zR open all folds, zM close all folds"

    # Misc Power Tips
    "Ctrl-a increment number, Ctrl-x decrement"
    "~ toggles case of character"
    "gU<motion> uppercase, gu<motion> lowercase"
    "J joins lines, gJ joins without space"
    "Ctrl-o in insert mode runs one normal command"
    "gi jump back to last insert position and enter insert mode"
    ":earlier 5m undo to 5 minutes ago"
    "g; g, jump through change list"
  ];
in {
  config = {
    extraConfigLuaPre = ''
      -- Setup random tips
      local tips = {
        ${builtins.concatStringsSep ",\n        " (map (tip: "[=[${tip}]=]") tips)}
      }
      math.randomseed(os.time())
      _G.random_tip = tips[math.random(#tips)]
    '';

    plugins.alpha = {
      enable = true;
      settings.layout = [
        {
          type = "padding";
          val = 2;
        }

        # Header
        {
          type = "text";
          val = [
            "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗"
            "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║"
            "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║"
            "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║"
            "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║"
            "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"
          ];
          opts = {
            position = "center";
            hl = "Type";
          };
        }

        {
          type = "padding";
          val = 2;
        }

        # Tip of the Day (at the top!)
        {
          type = "text";
          val.__raw = "random_tip";
          opts = {
            position = "center";
            hl = "String";
          };
        }

        {
          type = "padding";
          val = 2;
        }

        # Quick Actions
        {
          type = "text";
          val = "Quick Actions";
          opts = {
            position = "center";
            hl = "SpecialComment";
          };
        }
        {
          type = "padding";
          val = 1;
        }
        {
          type = "text";
          val = [
            "  Find File              SPC SPC"
            "  Live Grep              SPC /"
            "  Recent Files           SPC f r"
            "  Explorer               SPC e"
            "  Cheat Sheet            SPC ?"
          ];
          opts = {
            position = "center";
            hl = "Keyword";
          };
        }

        {
          type = "padding";
          val = 2;
        }

        # Essential Motions
        {
          type = "text";
          val = "Essential Motions";
          opts = {
            position = "center";
            hl = "SpecialComment";
          };
        }
        {
          type = "padding";
          val = 1;
        }
        {
          type = "text";
          val = [
            "w b e          word motions"
            "^              first non-blank"
            "{ }            paragraph jumps"
            "f t ; ,        find character"
          ];
          opts = {
            position = "center";
            hl = "Comment";
          };
        }

        {
          type = "padding";
          val = 2;
        }

        # Text Objects
        {
          type = "text";
          val = "Text Objects";
          opts = {
            position = "center";
            hl = "SpecialComment";
          };
        }
        {
          type = "padding";
          val = 1;
        }
        {
          type = "text";
          val = [
            "ciw da\"        change/delete with objects"
            "daf vif        function operations"
            "cit cat        tag operations"
            "dap            parameter operations"
          ];
          opts = {
            position = "center";
            hl = "Comment";
          };
        }

        {
          type = "padding";
          val = 2;
        }

        # Navigation
        {
          type = "text";
          val = "Quick Navigation";
          opts = {
            position = "center";
            hl = "SpecialComment";
          };
        }
        {
          type = "padding";
          val = 1;
        }
        {
          type = "text";
          val = [
            "<space>,       buffers"
            "<space>;       resume picker"
            "]h [h          git hunks"
            "<space>cs      symbols"
          ];
          opts = {
            position = "center";
            hl = "Comment";
          };
        }

        {
          type = "padding";
          val = 1;
        }
      ];
    };
  };
}
