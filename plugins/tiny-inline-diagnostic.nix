
{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "tiny-inline-diagnostic";
  defaultPackage = pkgs.vimPlugins.tiny-inline-diagnostic;
  maintainers = [];
}

