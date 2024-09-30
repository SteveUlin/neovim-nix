{ 
  config = {
    colorschemes.everforest-nvim = {
      enable = true;
      settings = {
        italics = true;
      };
    };
    # # colorschemes.catppuccin.enable = true;
    # # colorschemes.kanagawa.enable = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
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
