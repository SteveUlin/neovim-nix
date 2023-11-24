{
  description = "sulin's Neovim Flake";
  # See the great blogpost below for more details
  # https://primamateria.github.io/blog/neovim-nix/

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-staging.url = "github:NixOS/nixpkgs/staging";
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-staging, neovim, ... }:
    let
      system = "x86_64-linux";
      overlayFlakeInputs = prev: final: {
        neovim = neovim.packages.${system}.neovim.override {
          inherit (import nixpkgs-staging { inherit system; }) libvterm-neovim;
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
      packages.${system}.default = pkgs.myNeovim;
      apps.${system}.default = {
        type = "app";
        program = "${pkgs.myNeovim}/bin/nvim";
      };
    };
}
