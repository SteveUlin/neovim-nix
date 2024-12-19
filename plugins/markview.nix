{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "markview";
  defaultPackage = pkgs.vimPlugins.markview-nvim;
  maintainers = [];
}

