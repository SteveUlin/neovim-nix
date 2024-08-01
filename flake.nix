{
  description = "sulin's Neovim Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    bufsurf-src = {
      url = "github:ton/vim-bufsurf";
      flake = false;
    };
    log-highlight = {
      url = "github:fei6409/log-highlight.nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    neovim-nightly-overlay,
    nixvim,
    flake-utils,
    ...
  }@inputs:
    flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (final: prev: {
          vimPlugins = prev.vimPlugins //
          {
            bufsurf = final.vimUtils.buildVimPlugin {
              name = "bufsurf";
              src = inputs.bufsurf-src;
            };
            log-highlight = final.vimUtils.buildVimPlugin {
              name = "log-highlight";
              src = inputs.log-highlight;
            };
          };
        })
      ];
    };

    nixvim' = nixvim.legacyPackages.${system};
    nvim = nixvim'.makeNixvimWithModule {
      inherit pkgs;
      module = {
        imports = [ ./plugins ./config ];
        extraPackages = with pkgs; [
            clang_18
            delta
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
