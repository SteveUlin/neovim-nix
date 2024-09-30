{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "eyeliner-nvim";
  defaultPackage = pkgs.vimPlugins.eyeliner-nvim;
  luaName = "eyeliner";
  maintainers = [];
}
