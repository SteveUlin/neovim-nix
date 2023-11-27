{ pkgs }:
with pkgs.vimPlugins; [
  (nvim-treesitter.withPlugins (
    p: [
      p.cmake
      p.cpp
      p.lua
      p.nix
      p.norg
      p.bash
      ]))

  # UI
  highlight-undo-nvim
  material-nvim
  nvim-web-devicons
  which-key-nvim

  # Git
  gitsigns-nvim

  # Neorg
  neorg
  zen-mode-nvim
  sniprun

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
