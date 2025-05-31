{
  lib,
  ...
}:
lib.nixvim.plugins.vim.mkVimPlugin {
  name = "bufsurf";
  package = "bufsurf";
  maintainers = [];
}
