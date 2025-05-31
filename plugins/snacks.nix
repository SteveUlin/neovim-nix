{
  lib,
  ...
}:
lib.nixvim.plugins.neovim.mkNeovimPlugin {
  name = "snacks-nvim";
  package = "snacks-head";
  moduleName = "snacks";
  maintainers = [];
}
