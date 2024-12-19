{
  lib,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "everforest-nvim";
  isColorscheme = true;
  package = "everforest-nvim";
  moduleName = "everforest";
  colorscheme = "everforest";
  maintainers = [];
  
  extraConfig = cfg: { opts.termguicolors = lib.mkDefault true; };
}
