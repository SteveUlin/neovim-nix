{
  description = "sulin's Neovim Flake";
  # See the great blogpost below for more details
  # https://primamateria.github.io/blog/neovim-nix/

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    everforest-src = {
      url = "github:neanias/everforest-nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, neovim, flake-utils, everforest-src, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlayFlakeInputs = prev: final: {
          neovim = neovim.packages.${system}.neovim.override {
            inherit (import nixpkgs { inherit system; }) libvterm-neovim;
          };

          vimPlugins = final.vimPlugins // {
            everforest-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "everforest-nvim";
              src = everforest-src;
            };
          };
        };
        overlayMyNeovim = prev: final: {
          myNeovim = (import ./packages/myNeovim.nix { pkgs = final; });
        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlayFlakeInputs overlayMyNeovim ];
        };
      in {
        packages.default = pkgs.myNeovim;
        apps.default = {
          type = "app";
          program = "${pkgs.myNeovim}/bin/nvim";
        };
      });
}
