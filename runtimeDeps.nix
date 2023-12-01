{ pkgs }:
with pkgs; [
  # language servers
  nil
  lua-language-server
  clang-tools_16

  # Treesitter Install
  clang_16

  # Copilot
  nodejs_21

  # Image
  imagemagick
  luajitPackages.magick
  curl
]
