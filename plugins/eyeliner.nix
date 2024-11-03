{
  lib,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "eyeliner-nvim";
  package = "eyeliner";
  luaName = "eyeliner";
  maintainers = [];
}
