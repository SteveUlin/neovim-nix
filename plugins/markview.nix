{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "markview-nvim";
  defaultPackage = pkgs.vimPlugins.markview-nvim;
  luaName = "markview";
  maintainers = [];
}
