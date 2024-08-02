{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "everforest-nvim";
  isColorscheme = true;
  defaultPackage = pkgs.vimPlugins.everforest-nvim;
  luaName = "everforest";
  colorscheme = "everforest";
  maintainers = [];
  
  extraConfig = cfg: { opts.termguicolors = lib.mkDefault true; };
}
