{
  description = "sulin's Neovim Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    neovim,
    nixvim,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
    nixvim' = nixvim.legacyPackages."${system}";
    nvim = nixvim'.makeNixvimWithModule {
      module = {
        imports = [ ./plugins ./config ];
        package = neovim.packages."${system}".neovim;
      };
      pkgs = import nixpkgs {
        inherit system;
      };
    };
    in {
      packages = {
        inherit nvim;
        default = nvim;
      };
    });
}
