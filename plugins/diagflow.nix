{
  lib,
  ...
}:
lib.nixvim.plugins.neovim.mkNeovimPlugin {
  name = "diagflow";
  package = "diagflow";
  maintainers = [];
}
