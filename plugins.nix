{ pkgs }:
with pkgs.vimPlugins; [
  (nvim-treesitter.withPlugins (
    p: [
      p.cmake
      p.cpp
      p.lua
      p.nix
      p.norg
      ]))
  # UI
  material-nvim
  nvim-web-devicons

  # Neorg
  neorg
  zen-mode-nvim

  # Telescope
  telescope-nvim
  telescope-file-browser-nvim
  neorg-telescope

  # AI
  # copilot-lua
  # copilot-cmp

  # Cmp
  nvim-cmp
  cmp-buffer
  cmp-cmdline
  cmp-emoji
  cmp-latex-symbols
  cmp-nvim-lsp
  cmp-path

  nvim-lspconfig
]
