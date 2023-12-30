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

    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";

    neorg-exec-src = {
      url = "github:laher/neorg-exec";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    neovim,
    nixvim,
    flake-utils,
    neorg-overlay,
    neorg-exec-src,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        neorg-overlay.overlays.default
        (final: prev: {
          vimPlugins = prev.vimPlugins //
          {
            neorg-exec = final.vimUtils.buildVimPlugin {
              name = "neorg-exec";
              src = neorg-exec-src;
            };
          };
        })
      ];
    };

    nixvim' = nixvim.legacyPackages."${system}";
    nvim = nixvim'.makeNixvimWithModule {
      inherit pkgs;
      module = {
        imports = [ ./plugins ./config ];
        package = neovim.packages."${system}".neovim;
        extraPackages = with pkgs; [
          julia
        ];
      };
    };
    in {
      packages = {
        inherit nvim;
        default = nvim;
      };
    });
}
