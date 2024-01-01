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
];
}
