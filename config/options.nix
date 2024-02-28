{ 
  config = {
    colorschemes.everforest.enable = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    options = {
      # Line numbers
      number = true;
      relativenumber = true;

      colorcolumn = "81";

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
    };

    filetype.extension.webc = "html";

  };
}
