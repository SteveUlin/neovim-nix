{pkgs, ...}: let
  # Random tips pool - one will be selected each time
  tips = [
    "ci\" changes text inside quotes without moving cursor"
    "The dot (.) repeats your last change - the most powerful command"
    "]h and [h jump between git hunks"
    "<space>sw opens grep with word under cursor"
    "<space>; resumes your last picker"
    "dap deletes a function parameter with treesitter"
    "]] and [[ jump to next/prev reference"
    "<space>su opens undo history picker"
    "* searches forward, # searches backward for word under cursor"
    "gd jumps to definition, Ctrl-o jumps back"
    "<space>go shows inline diff overlay for selective undo (gH to undo hunks)"
    "zz centers cursor line on screen"
    "ciw changes word even when cursor is in middle"
    "<space>cs shows all symbols in file"
    "{ and } jump between paragraphs"
    "^ jumps to first non-blank character"
    "qa records macro, q stops, @a replays"
    "@@ replays last macro"
    "<space>gp previews git hunk"
    "vi{ selects inside braces"
    "\"0p pastes last yank (not affected by deletes)"
  ];
in {
  config = {
    extraConfigLuaPre = ''
      -- Setup random tips
      local tips = {
        ${builtins.concatStringsSep ",\n        " (map (tip: "[[${tip}]]") tips)}
      }
      math.randomseed(os.time())
      _G.random_tip = tips[math.random(#tips)]
    '';

    plugins.alpha = {
      enable = true;
      layout = [
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
