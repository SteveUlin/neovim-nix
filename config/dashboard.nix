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

    # Diff / VCS
    "]h [h jump between diff hunks"
    "]r [r step the diff base through commits (jj new+squash)"
    "<space>gs jujutsu status picker"
    "<space>gu undo current hunk"
    "<space>go toggle inline diff overlay"
    "dih operates on the hunk under the cursor"

    # LSP
    "<space>ca code actions - quick fixes and refactors"
    "<space>cr rename symbol across the project"
    "<space>cf format current buffer"
    "<space>ck hover docs for symbol under cursor"
    "<space>cd go to definition"
    "<space>cR find all references"
    "<space>cs list all symbols in file"
    "<space>cS search symbols across workspace"
    "]]/[[ jump to next/prev LSP reference"
    "[x jump up to the enclosing function/class"

    # Editing
    "<C-space> grow selection by syntax node, <BS> shrinks"
    "gsa{motion} surround, gsd delete, gsr replace (mini.surround)"
    "<space>na / <space>pa swap an argument with its neighbour"
    "C-a / C-x increment dates, booleans, &&/|| (dial)"
    "<space>st search TODO/FIX/HACK comments"

    # Files & Buffers
    "<space>fs save file"
    "<space>q close window"
    "<space>bd close buffer without wrecking the split"
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

    # snacks.dashboard (replaces alpha). preset.keys are real, keybound buttons
    # wired to the snacks pickers; the tip-of-the-day is a function section so it
    # re-renders each open. The static motion/text-object reference is kept.
    plugins.snacks-nvim.settings.dashboard = {
      enabled = true;
      preset = {
        header = ''
          ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
          ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
          ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
          ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
          ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
          ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝'';
        keys = [
          { icon = " "; key = "f"; desc = "Find File"; action.__raw = "function() Snacks.picker.smart() end"; }
          { icon = " "; key = "/"; desc = "Live Grep"; action.__raw = "function() Snacks.picker.grep() end"; }
          { icon = " "; key = "r"; desc = "Recent Files"; action.__raw = "function() Snacks.picker.recent() end"; }
          { icon = " "; key = "e"; desc = "Explorer"; action.__raw = "function() Snacks.explorer() end"; }
          { icon = " "; key = "?"; desc = "Cheat Sheet"; action = ":e ~/neovim-nix/CHEATSHEET.md"; }
          { icon = " "; key = "q"; desc = "Quit"; action = ":qa"; }
        ];
      };
      sections = [
        { section = "header"; }
        {
          __raw = "function() return { align = 'center', padding = 1, text = { { _G.random_tip or '', hl = 'String' } } } end";
        }
        { section = "keys"; gap = 1; padding = 1; }
        {
          align = "center";
          text = [ { __unkeyed-1 = "Essential Motions"; hl = "SpecialComment"; } ];
        }
        {
          align = "center";
          padding = 1;
          text = [ { __unkeyed-1 = "w b e  words    ^ first non-blank    { } paragraph    f t ; , find"; hl = "Comment"; } ];
        }
        {
          align = "center";
          text = [ { __unkeyed-1 = "Text Objects"; hl = "SpecialComment"; } ];
        }
        {
          align = "center";
          padding = 1;
          text = [ { __unkeyed-1 = "ciw   da\"   daf vif   cit cat   dap   gsa (surround)"; hl = "Comment"; } ];
        }
      ];
    };
  };
}
