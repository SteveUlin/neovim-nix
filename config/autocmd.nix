{
autoCmd = [
  {
    event = [ "FileType" ];
    pattern = [ "*.norg" ];
    command = '':lua
      vim.opt_local.conceallevel = 2
      vim.opt_local.concealcursor = "nc"
      vim.opt_local.wrap = false
    '';
  }
];
}
