{
autoCmd = [
  {
    event = [ "FileType" ];
    pattern = "norg";
    callback = {
      __raw = ''function()
      vim.opt_local.conceallevel = 3
      vim.opt_local.concealcursor = "nc"
      vim.opt_local.wrap = false
    end
    '';
    };
  }
  {
    event = [ "FileType" ];
    pattern = [ "markdown" "md" ];
    callback = {
      __raw = ''function()
      vim.opt_local.colorcolumn = "100"
      vim.opt_local.textwidth = 100
    end
    '';
    };
  }
];
}
