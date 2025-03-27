{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
helpers.plugins.neovim.mkNeovimPlugin config {
  name = "markview";
  defaultPackage = pkgs.vimPlugins.markview-nvim;
  maintainers = [];
}

