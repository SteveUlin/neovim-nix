{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
with lib;
helpers.vim-plugin.mkVimPlugin config {
  name = "bufsurf";
  defaultPackage = pkgs.vimPlugins.bufsurf;
  maintainers = [];
}
