{ 
  config = {
    colorschemes.everforest-nvim = {
      enable = true;
      settings = {
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
          end
        '';
      };
    };

    colorschemes.kanagawa = { 
      enable = false; 
    };

    colorschemes.tokyonight = { 
      enable = false; 
    };

    colorschemes.catppuccin = { 
      enable = false; 
      settings = {
        styles = {
          comments = [ "italic" ];
          functions = [ "italic" ];
          keywords = [ "italic" ];
          types = [ "italic" ];
        };
      };
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    diagnostic.settings = {
      virtual_text = false;
    };

    opts = {
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

      # Start with all folds open
      foldlevelstart = 99;
      
      conceallevel = 2;

    };

  };
}
