{
  lib,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "snacks-nvim";
  package = "snacks-head";
  moduleName = "snacks";
  maintainers = [];
}
