{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
lib.nixvim.plugins.neovim.mkNeovimPlugin {
  name = "markview";
  defaultPackage = pkgs.vimPlugins.markview-nvim;
  maintainers = [];
}

