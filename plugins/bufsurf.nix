{
  lib,
  pkgs,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "bufsurf";
  package = pkgs.vimPlugins.bufsurf;
  maintainers = [];
}
