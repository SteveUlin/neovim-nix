{ pkgs }:
with pkgs.vimPlugins; [
  (nvim-treesitter.withPlugins (
    p: [
      p.cmake
      p.cpp
      p.lua
      p.nix
      p.norg
      p.latex
      p.bash
      ]))

  vimtex

  # UI
  highlight-undo-nvim
  material-nvim
  nvim-web-devicons
  which-key-nvim
  nabla-nvim
  nvim-gdb

  # Git
  gitsigns-nvim
  diffview-nvim

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

  # Image
  image-nvim

  # LSP
  nvim-lspconfig
]
