{ pkgs }:
with pkgs; [
  # language servers
  nil
  lua-language-server
  clang-tools_16

  # Treesitter Install
  clang_16

  # copilot
  nodejs_21
]
