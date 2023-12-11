{ pkgs }:
with pkgs.vimPlugins; [
  (nvim-treesitter.withPlugins (
    p: [
      p.bash
      p.cmake
      p.cpp
      p.fish
      p.latex
      p.lua
      p.nix
      p.norg
      ]))

  # AI
  # copilot-lua
  # copilot-cmp

  # Cmp
  cmp-buffer
  cmp-cmdline
  cmp-emoji
  cmp-latex-symbols
  cmp-nvim-lsp
  cmp-path
  nvim-cmp

  # Debugging
  nvim-gdb

  # Git
  diffview-nvim
  gitsigns-nvim

  # LSP
  nvim-lspconfig

  # Neorg
  image-nvim
  neorg
  sniprun
  zen-mode-nvim

  # Telescope
  neorg-telescope
  telescope-file-browser-nvim
  telescope-nvim
  telescope-frecency-nvim

  # UI
  alpha-nvim
  highlight-undo-nvim
  nabla-nvim
  nvim-notify
  nvim-web-devicons
  rainbow-delimiters-nvim
  which-key-nvim

  # Themes
  material-nvim
  gruvbox-nvim
  everforest-nvim
]
