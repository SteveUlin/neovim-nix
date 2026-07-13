{ 
  config = {
    colorschemes.everforest-nvim = {
      enable = true;
      settings = {
        # LineNr/Conceal/whitespace render in a brighter grey instead of bg5,
        # so the relativenumber column and listchars dots stay legible.
        ui_contrast = "high";
        on_highlights = ''
          function(hl, palette)
            hl["StorageClass"] = { fg = palette.red, italic = true}
            hl["Statement"] = { fg = palette.red, italic = true}
            hl["Structure"] = { fg = palette.red, italic = true}
            hl["Constant"] = { fg = palette.red, italic = true}
            hl["Type"] = { fg = palette.aqua }
            hl["@lsp.type.type"] = { fg = palette.aqua }
            hl["@lsp.type.typeParameter"] = { fg = palette.aqua }
            hl["@lsp.type.class"] = { fg = palette.aqua }
            hl["@lsp.type.function"] = { fg = palette.yellow }
            hl["@lsp.type.method"] = { fg = palette.green }
            hl["@lsp.type.parameter"] = { fg = palette.purple }
            hl["@lsp.type.variable"] = { fg = palette.none }
            hl["@lsp.type.property"] = { fg = palette.blue }
            hl["@lsp.type.concept"] = { fg = palette.aqua, italic = true }

            hl["@lsp.typemod.function.classScope"] = { fg = palette.orange }
            hl["@lsp.typemod.variable.classScope"] = { fg = palette.orange }
            hl["@lsp.typemod.variable.fileScope"] = { fg = palette.orange }
            hl["@lsp.typemod.variable.globalScope"] = { fg = palette.red }

            hl["@lsp.typemod.variable.static"] = { fg = palette.none }

            -- Diff highlights derived from the resolved palette so they stay
            -- correct if `background` ever changes (bg_blue == the old #3a515d).
            hl["DiffAdd"] = { bg = palette.bg_green }
            hl["DiffDelete"] = { bg = palette.bg_red }
            hl["DiffChange"] = { bg = palette.bg_blue }
            hl["DiffText"] = { bg = palette.bg_visual, fg = palette.bg0, bold = true }

            -- VCSigns inline diff
            hl["VcsignsDiffAdd"] = { bg = "#3a5249" }
            hl["VcsignsDiffDelete"] = { bg = "#4a3038" }
            hl["VcsignsDiffTextAdd"] = { bg = "#4a6a59", bold = true }
            hl["VcsignsDiffTextDelete"] = { bg = "#6a3a42", bold = true }

            -- VCSigns gutter signs
            hl["SignAdd"] = { fg = palette.green }
            hl["SignChange"] = { fg = palette.blue }
            hl["SignDelete"] = { fg = palette.red }
            hl["SignChangeDelete"] = { fg = palette.purple }

            -- nvim-live skill: a muted background-only highlight (so treesitter
            -- AND clangd semantic-token foregrounds show through), plus a
            -- distinct aqua short-label badge that doesn't share that background.
            hl["ClaudeLiveHL"] = { bg = palette.bg_red }
            hl["ClaudeLiveNote"] = { fg = palette.aqua, bold = true }

            -- clangd parameter-name inlay hints (f:/t:/fn:) — a visible blue
            -- italic instead of the dim default that links to LineNr.
            hl["LspInlayHint"] = { fg = palette.blue, italic = true }

            -- Slightly darker gutter (sign/number/fold columns) so it reads as
            -- a distinct band — in both normal and zen. Merge bg on the number
            -- columns to preserve their ui_contrast foreground.
            for _, _g in ipairs({ "LineNr", "LineNrAbove", "LineNrBelow", "CursorLineNr" }) do
              hl[_g] = vim.tbl_extend("force", hl[_g] or {}, { bg = palette.bg_dim })
            end
            for _, _g in ipairs({ "SignColumn", "FoldColumn", "CursorLineSign", "CursorLineFold" }) do
              hl[_g] = { bg = palette.bg_dim }
            end
          end
        '';
      };
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";

      # OSC 52 clipboard — works over SSH and inside Zellij
      # by encoding clipboard data as terminal escape sequences
      clipboard = {
        name = "OSC 52";
        copy = {
          "+".__raw = "require('vim.ui.clipboard.osc52').copy('+')";
          "*".__raw = "require('vim.ui.clipboard.osc52').copy('*')";
        };
        paste = {
          "+".__raw = "require('vim.ui.clipboard.osc52').paste('+')";
          "*".__raw = "require('vim.ui.clipboard.osc52').paste('*')";
        };
      };
    };

    diagnostic.settings = {
      # tiny-inline-diagnostic owns the inline render; native virtual_text off.
      virtual_text = false;
      # Worst severity on a line wins the gutter sign (ERROR never hides behind
      # a HINT) and orders the underline highlights by severity.
      severity_sort = true;
      # Glyphs instead of the default E/W/I/H sign letters. __rawKey__ emits the
      # vim.diagnostic.severity.* enum as a raw Lua table key.
      signs.text = {
        "__rawKey__vim.diagnostic.severity.ERROR" = "";
        "__rawKey__vim.diagnostic.severity.WARN" = "";
        "__rawKey__vim.diagnostic.severity.INFO" = "";
        "__rawKey__vim.diagnostic.severity.HINT" = "󰌵";
      };
      # Frame vim.diagnostic.open_float (the <leader>ce popup).
      float.border = "rounded";
    };

    opts = {
      # No `clipboard = "unnamedplus"`: yanks stay in the unnamed register by
      # default so no OSC 52 round-trip fires on every yank (which stalled under
      # Zellij). Use "+y / "+p for explicit system-clipboard access via the
      # OSC 52 provider defined in `globals.clipboard`. (2026-05-30)

      # Line numbers
      number = true;
      relativenumber = true;
      scrolloff = 8;

      # Always use decimal when incrementing and decrementing numbers
      nrformats = "";

      colorcolumn = "81";
      cursorline = true;

      # Default indentation
      shiftwidth = 2;
      tabstop = 2;

      # Do not use tabs, only spaces
      expandtab = true;

      spell = true;
      spelllang = "en";

      # Add a newline to the end of files
      eol = true;

      # Show white space 
      list = true;
      listchars = {
        tab = "->";
        lead = "·";
        trail = "·";
        extends = "⇢";
        precedes = "⇠";
        nbsp = "+";
      };

      # History and Backup files
      backup = false;
      writebackup = false;
      undofile = true;

      # Searching
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;

      # Save all modifications
      autowrite = true;
      autowriteall = true;
      autoread = true;
      swapfile = false;

      # Folding off entirely. vim.treesitter.foldexpr() recomputes fold levels
      # O(n) per motion/edit, the dominant large-file scroll/edit lag — and no
      # method leaves that cost behind with folding disabled.
      foldenable = false;

      conceallevel = 2;

      # Reserve the sign column so the buffer never shifts sideways when a jj
      # (vcsigns) or diagnostic sign appears/disappears.
      signcolumn = "yes";

      # Global float border (Neovim 0.11+): one setting frames every float —
      # LSP hover, signature, diagnostics, blink docs, snacks previews.
      winborder = "rounded";

      # Snappier: leader chords (timeoutlen) and CursorHold/hover (updatetime)
      # stop lagging the 1000ms/4000ms defaults.
      timeoutlen = 300;
      updatetime = 250;

      # Calmer splits: keep existing text on the same screen row when a split
      # opens, and place new splits where the eye is heading (down/right).
      splitkeep = "screen";
      splitbelow = true;
      splitright = true;

      # Cap the completion menu so clangd's verbose lists don't fill the screen.
      pumheight = 10;

      # Prompt to save instead of erroring on quit with unsaved changes.
      confirm = true;

    };

  };
}
