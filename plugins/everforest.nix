{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "everforest";
  isColorscheme = true;
  defaultPackage = pkgs.vimPlugins.everforest;
  maintainers = [];

  extraConfig = cfg: { opts.termguicolors = mkDefault true; };
}
