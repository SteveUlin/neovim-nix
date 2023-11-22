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
  };

  outputs = { self, nixpkgs, neovim, ... }:
    let
      overlayFlakeInputs = prev: final: {
        neovim = neovim.packages.x86_64-linux.neovim.override {
          inherit ((builtins.getFlake
          "github:NixOS/nixpkgs/d4758c3f27804693ebb6ddce2e9f6624b3371b08").legacyPackages.x86_64-linux)
          libvterm-neovim;
        };
      };
      overlayMyNeovim = prev: final: {
        myNeovim = (import ./packages/myNeovim.nix { pkgs = final; });
      };
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ overlayFlakeInputs overlayMyNeovim ];
      };
    in {
      packages.x86_64-linux.default = pkgs.myNeovim;
      apps.x86_64-linux.default = {
        type = "app";
        program = "${pkgs.myNeovim}/bin/nvim";
      };
    };
}
