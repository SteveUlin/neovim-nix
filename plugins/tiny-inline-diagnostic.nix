
{
  lib,
  ...
}:
lib.nixvim.plugins.neovim.mkNeovimPlugin {
  name = "tiny-inline-diagnostic";
  package = "tiny-inline-diagnostic";
  maintainers = [];
}

